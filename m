Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3941 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933706AbXCQMOL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Mar 2007 08:14:11 -0400
Date: Fri, 16 Mar 2007 17:34:17 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: jeff@garzik.org
Cc: linux-wireless@vger.kernel.org
Subject: Please pull 'upstream' branch of wireless-2.6
Message-ID: <20070316213417.GE3426@tuxdriver.com>
References: <20070316213153.GD3426@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070316213153.GD3426@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following changes since commit 0e39a919461842a38e406702fe0e94c6138ddfef
  John W. Linville (1):
        Merge branch 'upstream-fixes' into upstream

are found in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git upstream

Daniel Drake (4):
      zd1211rw: Use compare_ether_addr()
      zd1211rw: Reject AL2230S devices
      zd1211rw: Add AL2230S RF support
      zd1211rw: More device IDs

Larry Finger (2):
      bcm43xx: MANUALWLAN fixes
      bcm43xx:Eliminate some 'G Mode Enable' magic numbers

Michal Schmidt (3):
      airo: Fix an error path memory leak
      airo: Don't check for NULL before kfree()
      airo: Make /sys/bus/pci/drivers/airo/{,un}bind work

 drivers/net/wireless/airo.c                  |   74 ++++++++++-------------
 drivers/net/wireless/bcm43xx/bcm43xx.h       |    3 +
 drivers/net/wireless/bcm43xx/bcm43xx_main.c  |    4 +-
 drivers/net/wireless/bcm43xx/bcm43xx_phy.c   |    8 +-
 drivers/net/wireless/bcm43xx/bcm43xx_radio.c |   14 ++--
 drivers/net/wireless/zd1211rw/zd_chip.c      |    6 +-
 drivers/net/wireless/zd1211rw/zd_chip.h      |    2 +-
 drivers/net/wireless/zd1211rw/zd_mac.c       |   10 ++--
 drivers/net/wireless/zd1211rw/zd_rf.c        |    2 +-
 drivers/net/wireless/zd1211rw/zd_rf.h        |    2 +-
 drivers/net/wireless/zd1211rw/zd_rf_al2230.c |   83 ++++++++++++++++++++++---
 drivers/net/wireless/zd1211rw/zd_usb.c       |    3 +
 12 files changed, 136 insertions(+), 75 deletions(-)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index a8c2bfe..254f285 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -1145,6 +1145,7 @@ static void airo_networks_free(struct airo_info *ai);
 struct airo_info {
 	struct net_device_stats	stats;
 	struct net_device             *dev;
+	struct list_head              dev_list;
 	/* Note, we can have MAX_FIDS outstanding.  FIDs are 16-bits, so we
 	   use the high bit to mark whether it is in use. */
 #define MAX_FIDS 6
@@ -2360,6 +2361,21 @@ static int airo_change_mtu(struct net_device *dev, int new_mtu)
 	return 0;
 }
 
+static LIST_HEAD(airo_devices);
+
+static void add_airo_dev(struct airo_info *ai)
+{
+	/* Upper layers already keep track of PCI devices,
+	 * so we only need to remember our non-PCI cards. */
+	if (!ai->pci)
+		list_add_tail(&ai->dev_list, &airo_devices);
+}
+
+static void del_airo_dev(struct airo_info *ai)
+{
+	if (!ai->pci)
+		list_del(&ai->dev_list);
+}
 
 static int airo_close(struct net_device *dev) {
 	struct airo_info *ai = dev->priv;
@@ -2381,8 +2397,6 @@ static int airo_close(struct net_device *dev) {
 	return 0;
 }
 
-static void del_airo_dev( struct net_device *dev );
-
 void stop_airo_card( struct net_device *dev, int freeres )
 {
 	struct airo_info *ai = dev->priv;
@@ -2434,14 +2448,12 @@ void stop_airo_card( struct net_device *dev, int freeres )
 		}
         }
 	crypto_free_cipher(ai->tfm);
-	del_airo_dev( dev );
+	del_airo_dev(ai);
 	free_netdev( dev );
 }
 
 EXPORT_SYMBOL(stop_airo_card);
 
-static int add_airo_dev( struct net_device *dev );
-
 static int wll_header_parse(struct sk_buff *skb, unsigned char *haddr)
 {
 	memcpy(haddr, skb->mac.raw + 10, ETH_ALEN);
@@ -2740,8 +2752,6 @@ static int airo_networks_allocate(struct airo_info *ai)
 
 static void airo_networks_free(struct airo_info *ai)
 {
-	if (!ai->networks)
-		return;
 	kfree(ai->networks);
 	ai->networks = NULL;
 }
@@ -2816,12 +2826,10 @@ static struct net_device *_init_airo_card( unsigned short irq, int port,
 	if (IS_ERR(ai->airo_thread_task))
 		goto err_out_free;
 	ai->tfm = NULL;
-	rc = add_airo_dev( dev );
-	if (rc)
-		goto err_out_thr;
+	add_airo_dev(ai);
 
 	if (airo_networks_allocate (ai))
-		goto err_out_unlink;
+		goto err_out_thr;
 	airo_networks_initialize (ai);
 
 	/* The Airo-specific entries in the device structure. */
@@ -2852,7 +2860,7 @@ static struct net_device *_init_airo_card( unsigned short irq, int port,
 	if (rc) {
 		airo_print_err(dev->name, "register interrupt %d failed, rc %d",
 				irq, rc);
-		goto err_out_unlink;
+		goto err_out_nets;
 	}
 	if (!is_pcmcia) {
 		if (!request_region( dev->base_addr, 64, dev->name )) {
@@ -2935,9 +2943,10 @@ err_out_res:
 	        release_region( dev->base_addr, 64 );
 err_out_irq:
 	free_irq(dev->irq, dev);
-err_out_unlink:
-	del_airo_dev(dev);
+err_out_nets:
+	airo_networks_free(ai);
 err_out_thr:
+	del_airo_dev(ai);
 	set_bit(JOB_DIE, &ai->jobs);
 	kthread_stop(ai->airo_thread_task);
 err_out_free:
@@ -5536,11 +5545,6 @@ static int proc_close( struct inode *inode, struct file *file )
 	return 0;
 }
 
-static struct net_device_list {
-	struct net_device *dev;
-	struct net_device_list *next;
-} *airo_devices;
-
 /* Since the card doesn't automatically switch to the right WEP mode,
    we will make it do it.  If the card isn't associated, every secs we
    will switch WEP modes to see if that will help.  If the card is
@@ -5583,26 +5587,6 @@ static void timer_func( struct net_device *dev ) {
 	apriv->expires = RUN_AT(HZ*3);
 }
 
-static int add_airo_dev( struct net_device *dev ) {
-	struct net_device_list *node = kmalloc( sizeof( *node ), GFP_KERNEL );
-	if ( !node )
-		return -ENOMEM;
-
-	node->dev = dev;
-	node->next = airo_devices;
-	airo_devices = node;
-
-	return 0;
-}
-
-static void del_airo_dev( struct net_device *dev ) {
-	struct net_device_list **p = &airo_devices;
-	while( *p && ( (*p)->dev != dev ) )
-		p = &(*p)->next;
-	if ( *p && (*p)->dev == dev )
-		*p = (*p)->next;
-}
-
 #ifdef CONFIG_PCI
 static int __devinit airo_pci_probe(struct pci_dev *pdev,
 				    const struct pci_device_id *pent)
@@ -5626,6 +5610,10 @@ static int __devinit airo_pci_probe(struct pci_dev *pdev,
 
 static void __devexit airo_pci_remove(struct pci_dev *pdev)
 {
+	struct net_device *dev = pci_get_drvdata(pdev);
+
+	airo_print_info(dev->name, "Unregistering...");
+	stop_airo_card(dev, 1);
 }
 
 static int airo_pci_suspend(struct pci_dev *pdev, pm_message_t state)
@@ -5751,9 +5739,11 @@ static int __init airo_init_module( void )
 
 static void __exit airo_cleanup_module( void )
 {
-	while( airo_devices ) {
-		airo_print_info(airo_devices->dev->name, "Unregistering...\n");
-		stop_airo_card( airo_devices->dev, 1 );
+	struct airo_info *ai;
+	while(!list_empty(&airo_devices)) {
+		ai = list_entry(airo_devices.next, struct airo_info, dev_list);
+		airo_print_info(ai->dev->name, "Unregistering...");
+		stop_airo_card(ai->dev, 1);
 	}
 #ifdef CONFIG_PCI
 	pci_unregister_driver(&airo_driver);
diff --git a/drivers/net/wireless/bcm43xx/bcm43xx.h b/drivers/net/wireless/bcm43xx/bcm43xx.h
index 95ff175..f8483c1 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx.h
+++ b/drivers/net/wireless/bcm43xx/bcm43xx.h
@@ -277,11 +277,14 @@
 #define BCM43xx_SBTMSTATELOW_REJECT		0x02
 #define BCM43xx_SBTMSTATELOW_CLOCK		0x10000
 #define BCM43xx_SBTMSTATELOW_FORCE_GATE_CLOCK	0x20000
+#define BCM43xx_SBTMSTATELOW_G_MODE_ENABLE	0x20000000
 
 /* sbtmstatehigh state flags */
 #define BCM43xx_SBTMSTATEHIGH_SERROR		0x00000001
 #define BCM43xx_SBTMSTATEHIGH_BUSY		0x00000004
 #define BCM43xx_SBTMSTATEHIGH_TIMEOUT		0x00000020
+#define BCM43xx_SBTMSTATEHIGH_G_PHY_AVAIL	0x00010000
+#define BCM43xx_SBTMSTATEHIGH_A_PHY_AVAIL	0x00020000
 #define BCM43xx_SBTMSTATEHIGH_COREFLAGS		0x1FFF0000
 #define BCM43xx_SBTMSTATEHIGH_DMA64BIT		0x10000000
 #define BCM43xx_SBTMSTATEHIGH_GATEDCLK		0x20000000
diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_main.c b/drivers/net/wireless/bcm43xx/bcm43xx_main.c
index 80cb88e..282f98f 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx_main.c
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_main.c
@@ -1389,7 +1389,7 @@ void bcm43xx_wireless_core_reset(struct bcm43xx_private *bcm, int connect_phy)
 				& ~(BCM43xx_SBF_MAC_ENABLED | 0x00000002));
 	} else {
 		if (connect_phy)
-			flags |= 0x20000000;
+			flags |= BCM43xx_SBTMSTATELOW_G_MODE_ENABLE;
 		bcm43xx_phy_connect(bcm, connect_phy);
 		bcm43xx_core_enable(bcm, flags);
 		bcm43xx_write16(bcm, 0x03E6, 0x0000);
@@ -3586,7 +3586,7 @@ int bcm43xx_select_wireless_core(struct bcm43xx_private *bcm,
 		u32 sbtmstatelow;
 
 		sbtmstatelow = bcm43xx_read32(bcm, BCM43xx_CIR_SBTMSTATELOW);
-		sbtmstatelow |= 0x20000000;
+		sbtmstatelow |= BCM43xx_SBTMSTATELOW_G_MODE_ENABLE;
 		bcm43xx_write32(bcm, BCM43xx_CIR_SBTMSTATELOW, sbtmstatelow);
 	}
 	err = wireless_core_up(bcm, 1);
diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_phy.c b/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
index cae8925..8a99790 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
@@ -168,16 +168,16 @@ int bcm43xx_phy_connect(struct bcm43xx_private *bcm, int connect)
 
 	flags = bcm43xx_read32(bcm, BCM43xx_CIR_SBTMSTATEHIGH);
 	if (connect) {
-		if (!(flags & 0x00010000))
+		if (!(flags & BCM43xx_SBTMSTATEHIGH_G_PHY_AVAIL))
 			return -ENODEV;
 		flags = bcm43xx_read32(bcm, BCM43xx_CIR_SBTMSTATELOW);
-		flags |= (0x800 << 18);
+		flags |= BCM43xx_SBTMSTATELOW_G_MODE_ENABLE;
 		bcm43xx_write32(bcm, BCM43xx_CIR_SBTMSTATELOW, flags);
 	} else {
-		if (!(flags & 0x00020000))
+		if (!(flags & BCM43xx_SBTMSTATEHIGH_A_PHY_AVAIL))
 			return -ENODEV;
 		flags = bcm43xx_read32(bcm, BCM43xx_CIR_SBTMSTATELOW);
-		flags &= ~(0x800 << 18);
+		flags &= ~BCM43xx_SBTMSTATELOW_G_MODE_ENABLE;
 		bcm43xx_write32(bcm, BCM43xx_CIR_SBTMSTATELOW, flags);
 	}
 out:
diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_radio.c b/drivers/net/wireless/bcm43xx/bcm43xx_radio.c
index 32beb91..ee1e7a2 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx_radio.c
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_radio.c
@@ -882,10 +882,10 @@ static void _stack_save(u32 *_stackptr, size_t *stackidx,
 {
 	u32 *stackptr = &(_stackptr[*stackidx]);
 
-	assert((offset & 0xF000) == 0x0000);
-	assert((id & 0xF0) == 0x00);
+	assert((offset & 0xE000) == 0x0000);
+	assert((id & 0xF8) == 0x00);
 	*stackptr = offset;
-	*stackptr |= ((u32)id) << 12;
+	*stackptr |= ((u32)id) << 13;
 	*stackptr |= ((u32)value) << 16;
 	(*stackidx)++;
 	assert(*stackidx < BCM43xx_INTERFSTACK_SIZE);
@@ -896,12 +896,12 @@ static u16 _stack_restore(u32 *stackptr,
 {
 	size_t i;
 
-	assert((offset & 0xF000) == 0x0000);
-	assert((id & 0xF0) == 0x00);
+	assert((offset & 0xE000) == 0x0000);
+	assert((id & 0xF8) == 0x00);
 	for (i = 0; i < BCM43xx_INTERFSTACK_SIZE; i++, stackptr++) {
-		if ((*stackptr & 0x00000FFF) != offset)
+		if ((*stackptr & 0x00001FFF) != offset)
 			continue;
-		if (((*stackptr & 0x0000F000) >> 12) != id)
+		if (((*stackptr & 0x00007000) >> 13) != id)
 			continue;
 		return ((*stackptr & 0xFFFF0000) >> 16);
 	}
diff --git a/drivers/net/wireless/zd1211rw/zd_chip.c b/drivers/net/wireless/zd1211rw/zd_chip.c
index f97288d..f6861da 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -67,11 +67,12 @@ static int scnprint_id(struct zd_chip *chip, char *buffer, size_t size)
 	i += scnprint_mac_oui(chip->e2p_mac, buffer+i, size-i);
 	i += scnprintf(buffer+i, size-i, " ");
 	i += zd_rf_scnprint_id(&chip->rf, buffer+i, size-i);
-	i += scnprintf(buffer+i, size-i, " pa%1x %c%c%c%c", chip->pa_type,
+	i += scnprintf(buffer+i, size-i, " pa%1x %c%c%c%c%c", chip->pa_type,
 		chip->patch_cck_gain ? 'g' : '-',
 		chip->patch_cr157 ? '7' : '-',
 		chip->patch_6m_band_edge ? '6' : '-',
-		chip->new_phy_layout ? 'N' : '-');
+		chip->new_phy_layout ? 'N' : '-',
+		chip->al2230s_bit ? 'S' : '-');
 	return i;
 }
 
@@ -337,6 +338,7 @@ static int read_pod(struct zd_chip *chip, u8 *rf_type)
 	chip->patch_cr157 = (value >> 13) & 0x1;
 	chip->patch_6m_band_edge = (value >> 21) & 0x1;
 	chip->new_phy_layout = (value >> 31) & 0x1;
+	chip->al2230s_bit = (value >> 7) & 0x1;
 	chip->link_led = ((value >> 4) & 1) ? LED1 : LED2;
 	chip->supports_tx_led = 1;
 	if (value & (1 << 24)) { /* LED scenario */
diff --git a/drivers/net/wireless/zd1211rw/zd_chip.h b/drivers/net/wireless/zd1211rw/zd_chip.h
index b07569e..ae39c22 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.h
+++ b/drivers/net/wireless/zd1211rw/zd_chip.h
@@ -711,7 +711,7 @@ struct zd_chip {
 	u16 link_led;
 	unsigned int pa_type:4,
 		patch_cck_gain:1, patch_cr157:1, patch_6m_band_edge:1,
-		new_phy_layout:1,
+		new_phy_layout:1, al2230s_bit:1,
 		is_zd1211b:1, supports_tx_led:1;
 };
 
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 4c5f78e..19172f5 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -974,14 +974,14 @@ static int is_data_packet_for_us(struct ieee80211_device *ieee,
 	switch (ieee->iw_mode) {
 	case IW_MODE_ADHOC:
 		if ((fc & (IEEE80211_FCTL_TODS|IEEE80211_FCTL_FROMDS)) != 0 ||
-		    memcmp(hdr->addr3, ieee->bssid, ETH_ALEN) != 0)
+		    compare_ether_addr(hdr->addr3, ieee->bssid) != 0)
 			return 0;
 		break;
 	case IW_MODE_AUTO:
 	case IW_MODE_INFRA:
 		if ((fc & (IEEE80211_FCTL_TODS|IEEE80211_FCTL_FROMDS)) !=
 		    IEEE80211_FCTL_FROMDS ||
-		    memcmp(hdr->addr2, ieee->bssid, ETH_ALEN) != 0)
+		    compare_ether_addr(hdr->addr2, ieee->bssid) != 0)
 			return 0;
 		break;
 	default:
@@ -989,9 +989,9 @@ static int is_data_packet_for_us(struct ieee80211_device *ieee,
 		return 0;
 	}
 
-	return memcmp(hdr->addr1, netdev->dev_addr, ETH_ALEN) == 0 ||
+	return compare_ether_addr(hdr->addr1, netdev->dev_addr) == 0 ||
 	       (is_multicast_ether_addr(hdr->addr1) &&
-		memcmp(hdr->addr3, netdev->dev_addr, ETH_ALEN) != 0) ||
+		compare_ether_addr(hdr->addr3, netdev->dev_addr) != 0) ||
 	       (netdev->flags & IFF_PROMISC);
 }
 
@@ -1047,7 +1047,7 @@ static void update_qual_rssi(struct zd_mac *mac,
 	hdr = (struct ieee80211_hdr_3addr *)buffer;
 	if (length < offsetof(struct ieee80211_hdr_3addr, addr3))
 		return;
-	if (memcmp(hdr->addr2, zd_mac_to_ieee80211(mac)->bssid, ETH_ALEN) != 0)
+	if (compare_ether_addr(hdr->addr2, zd_mac_to_ieee80211(mac)->bssid) != 0)
 		return;
 
 	spin_lock_irqsave(&mac->lock, flags);
diff --git a/drivers/net/wireless/zd1211rw/zd_rf.c b/drivers/net/wireless/zd1211rw/zd_rf.c
index f50cff3..e6d604b 100644
--- a/drivers/net/wireless/zd1211rw/zd_rf.c
+++ b/drivers/net/wireless/zd1211rw/zd_rf.c
@@ -34,7 +34,7 @@ static const char *rfs[] = {
 	[AL2210_RF]	= "AL2210_RF",
 	[MAXIM_NEW_RF]	= "MAXIM_NEW_RF",
 	[UW2453_RF]	= "UW2453_RF",
-	[AL2230S_RF]	= "AL2230S_RF",
+	[UNKNOWN_A_RF]	= "UNKNOWN_A_RF",
 	[RALINK_RF]	= "RALINK_RF",
 	[INTERSIL_RF]	= "INTERSIL_RF",
 	[RF2959_RF]	= "RF2959_RF",
diff --git a/drivers/net/wireless/zd1211rw/zd_rf.h b/drivers/net/wireless/zd1211rw/zd_rf.h
index a57732e..ee8ac3a 100644
--- a/drivers/net/wireless/zd1211rw/zd_rf.h
+++ b/drivers/net/wireless/zd1211rw/zd_rf.h
@@ -26,7 +26,7 @@
 #define AL2210_RF			0x7
 #define MAXIM_NEW_RF			0x8
 #define UW2453_RF			0x9
-#define AL2230S_RF			0xa
+#define UNKNOWN_A_RF			0xa
 #define RALINK_RF			0xb
 #define INTERSIL_RF			0xc
 #define RF2959_RF			0xd
diff --git a/drivers/net/wireless/zd1211rw/zd_rf_al2230.c b/drivers/net/wireless/zd1211rw/zd_rf_al2230.c
index 25323a1..85a9ad2 100644
--- a/drivers/net/wireless/zd1211rw/zd_rf_al2230.c
+++ b/drivers/net/wireless/zd1211rw/zd_rf_al2230.c
@@ -59,6 +59,18 @@ static const struct zd_ioreq16 zd1211b_ioreqs_shared_1[] = {
 	{ CR240, 0x57 }, { CR9,   0xe0 },
 };
 
+static const struct zd_ioreq16 ioreqs_init_al2230s[] = {
+	{ CR47,   0x1e }, /* MARK_002 */
+	{ CR106,  0x22 },
+	{ CR107,  0x2a }, /* MARK_002 */
+	{ CR109,  0x13 }, /* MARK_002 */
+	{ CR118,  0xf8 }, /* MARK_002 */
+	{ CR119,  0x12 }, { CR122,  0xe0 },
+	{ CR128,  0x10 }, /* MARK_001 from 0xe->0x10 */
+	{ CR129,  0x0e }, /* MARK_001 from 0xd->0x0e */
+	{ CR130,  0x10 }, /* MARK_001 from 0xb->0x0d */
+};
+
 static int zd1211b_al2230_finalize_rf(struct zd_chip *chip)
 {
 	int r;
@@ -90,7 +102,7 @@ static int zd1211_al2230_init_hw(struct zd_rf *rf)
 	int r;
 	struct zd_chip *chip = zd_rf_to_chip(rf);
 
-	static const struct zd_ioreq16 ioreqs[] = {
+	static const struct zd_ioreq16 ioreqs_init[] = {
 		{ CR15,   0x20 }, { CR23,   0x40 }, { CR24,  0x20 },
 		{ CR26,   0x11 }, { CR28,   0x3e }, { CR29,  0x00 },
 		{ CR44,   0x33 }, { CR106,  0x2a }, { CR107, 0x1a },
@@ -117,10 +129,9 @@ static int zd1211_al2230_init_hw(struct zd_rf *rf)
 		{ CR119,  0x10 }, { CR120,  0x4f }, { CR121, 0x77 },
 		{ CR122,  0xe0 }, { CR137,  0x88 }, { CR252, 0xff },
 		{ CR253,  0xff },
+	};
 
-		/* These following happen separately in the vendor driver */
-		{ },
-
+	static const struct zd_ioreq16 ioreqs_pll[] = {
 		/* shdnb(PLL_ON)=0 */
 		{ CR251,  0x2f },
 		/* shdnb(PLL_ON)=1 */
@@ -128,7 +139,7 @@ static int zd1211_al2230_init_hw(struct zd_rf *rf)
 		{ CR138,  0x28 }, { CR203,  0x06 },
 	};
 
-	static const u32 rv[] = {
+	static const u32 rv1[] = {
 		/* Channel 1 */
 		0x03f790,
 		0x033331,
@@ -137,6 +148,9 @@ static int zd1211_al2230_init_hw(struct zd_rf *rf)
 		0x0b3331,
 		0x03b812,
 		0x00fff3,
+	};
+
+	static const u32 rv2[] = {
 		0x000da4,
 		0x0f4dc5, /* fix freq shift, 0x04edc5 */
 		0x0805b6,
@@ -148,8 +162,9 @@ static int zd1211_al2230_init_hw(struct zd_rf *rf)
 		0x0bdffc,
 		0x00000d,
 		0x00500f,
+	};
 
-		/* These writes happen separately in the vendor driver */
+	static const u32 rv3[] = {
 		0x00d00f,
 		0x004c0f,
 		0x00540f,
@@ -157,11 +172,38 @@ static int zd1211_al2230_init_hw(struct zd_rf *rf)
 		0x00500f,
 	};
 
-	r = zd_iowrite16a_locked(chip, ioreqs, ARRAY_SIZE(ioreqs));
+	r = zd_iowrite16a_locked(chip, ioreqs_init, ARRAY_SIZE(ioreqs_init));
+	if (r)
+		return r;
+
+	if (chip->al2230s_bit) {
+		r = zd_iowrite16a_locked(chip, ioreqs_init_al2230s,
+			ARRAY_SIZE(ioreqs_init_al2230s));
+		if (r)
+			return r;
+	}
+
+	r = zd_rfwritev_locked(chip, rv1, ARRAY_SIZE(rv1), RF_RV_BITS);
+	if (r)
+		return r;
+
+	/* improve band edge for AL2230S */
+	if (chip->al2230s_bit)
+		r = zd_rfwrite_locked(chip, 0x000824, RF_RV_BITS);
+	else
+		r = zd_rfwrite_locked(chip, 0x0005a4, RF_RV_BITS);
 	if (r)
 		return r;
 
-	r = zd_rfwritev_locked(chip, rv, ARRAY_SIZE(rv), RF_RV_BITS);
+	r = zd_rfwritev_locked(chip, rv2, ARRAY_SIZE(rv2), RF_RV_BITS);
+	if (r)
+		return r;
+
+	r = zd_iowrite16a_locked(chip, ioreqs_pll, ARRAY_SIZE(ioreqs_pll));
+	if (r)
+		return r;
+
+	r = zd_rfwritev_locked(chip, rv3, ARRAY_SIZE(rv3), RF_RV_BITS);
 	if (r)
 		return r;
 
@@ -227,7 +269,9 @@ static int zd1211b_al2230_init_hw(struct zd_rf *rf)
 		0x481dc0,
 		0xcfff00,
 		0x25a000,
+	};
 
+	static const u32 rv2[] = {
 		/* To improve AL2230 yield, improve phase noise, 4713 */
 		0x25a000,
 		0xa3b2f0,
@@ -250,7 +294,7 @@ static int zd1211b_al2230_init_hw(struct zd_rf *rf)
 		{ CR251, 0x7f }, /* shdnb(PLL_ON)=1 */
 	};
 
-	static const u32 rv2[] = {
+	static const u32 rv3[] = {
 		/* To improve AL2230 yield, 4713 */
 		0xf01b00,
 		0xf01e00,
@@ -269,18 +313,37 @@ static int zd1211b_al2230_init_hw(struct zd_rf *rf)
 	r = zd_iowrite16a_locked(chip, ioreqs1, ARRAY_SIZE(ioreqs1));
 	if (r)
 		return r;
+
+	if (chip->al2230s_bit) {
+		r = zd_iowrite16a_locked(chip, ioreqs_init_al2230s,
+			ARRAY_SIZE(ioreqs_init_al2230s));
+		if (r)
+			return r;
+	}
+
 	r = zd_rfwritev_cr_locked(chip, zd1211b_al2230_table[0], 3);
 	if (r)
 		return r;
 	r = zd_rfwritev_cr_locked(chip, rv1, ARRAY_SIZE(rv1));
 	if (r)
 		return r;
-	r = zd_iowrite16a_locked(chip, ioreqs2, ARRAY_SIZE(ioreqs2));
+
+	if (chip->al2230s_bit)
+		r = zd_rfwrite_locked(chip, 0x241000, RF_RV_BITS);
+	else
+		r = zd_rfwrite_locked(chip, 0x25a000, RF_RV_BITS);
 	if (r)
 		return r;
+
 	r = zd_rfwritev_cr_locked(chip, rv2, ARRAY_SIZE(rv2));
 	if (r)
 		return r;
+	r = zd_iowrite16a_locked(chip, ioreqs2, ARRAY_SIZE(ioreqs2));
+	if (r)
+		return r;
+	r = zd_rfwritev_cr_locked(chip, rv3, ARRAY_SIZE(rv3));
+	if (r)
+		return r;
 	r = zd_iowrite16a_locked(chip, ioreqs3, ARRAY_SIZE(ioreqs3));
 	if (r)
 		return r;
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index 5e67106..145ad61 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -62,6 +62,9 @@ static struct usb_device_id usb_ids[] = {
 	{ USB_DEVICE(0x0471, 0x1236), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x13b1, 0x0024), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0586, 0x340f), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x0b05, 0x171b), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x0586, 0x3410), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x0baf, 0x0121), .driver_info = DEVICE_ZD1211B },
 	/* "Driverless" devices that need ejecting */
 	{ USB_DEVICE(0x0ace, 0x2011), .driver_info = DEVICE_INSTALLER },
 	{}
-- 
John W. Linville
linville@tuxdriver.com
