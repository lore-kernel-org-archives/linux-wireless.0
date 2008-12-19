Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:47315 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbYLST3c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 14:29:32 -0500
From: Michael Buesch <mb@bu3sch.de>
To: linville@tuxdriver.com
Subject: [PATCH] b43: Add key memory dumping
Date: Fri, 19 Dec 2008 20:24:30 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200812192024.30700.mb@bu3sch.de> (sfid-20081219_202946_086221_4845562E)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds an option to dump all crypto related memory to
the kernel log.
Obviously, it should not be enabled on productive systems. ;)

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

For 2.6.29

Index: wireless-testing/drivers/net/wireless/b43/debugfs.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/debugfs.c	2008-08-30 02:13:22.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/debugfs.c	2008-12-19 19:34:17.000000000 +0100
@@ -728,12 +728,13 @@ static void b43_add_dynamic_debug(struct
 	add_dyn_dbg("debug_dmaoverflow", B43_DBG_DMAOVERFLOW, 0);
 	add_dyn_dbg("debug_dmaverbose", B43_DBG_DMAVERBOSE, 0);
 	add_dyn_dbg("debug_pwork_fast", B43_DBG_PWORK_FAST, 0);
 	add_dyn_dbg("debug_pwork_stop", B43_DBG_PWORK_STOP, 0);
 	add_dyn_dbg("debug_lo", B43_DBG_LO, 0);
 	add_dyn_dbg("debug_firmware", B43_DBG_FIRMWARE, 0);
+	add_dyn_dbg("debug_keys", B43_DBG_KEYS, 0);
 
 #undef add_dyn_dbg
 }
 
 void b43_debugfs_add_device(struct b43_wldev *dev)
 {
Index: wireless-testing/drivers/net/wireless/b43/debugfs.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/debugfs.h	2008-08-28 18:38:15.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/debugfs.h	2008-12-19 19:33:41.000000000 +0100
@@ -9,12 +9,13 @@ enum b43_dyndbg {		/* Dynamic debugging 
 	B43_DBG_DMAOVERFLOW,
 	B43_DBG_DMAVERBOSE,
 	B43_DBG_PWORK_FAST,
 	B43_DBG_PWORK_STOP,
 	B43_DBG_LO,
 	B43_DBG_FIRMWARE,
+	B43_DBG_KEYS,
 	__B43_NR_DYNDBG,
 };
 
 #ifdef CONFIG_B43_DEBUG
 
 struct dentry;
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-12-19 18:32:33.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-12-19 19:42:21.000000000 +0100
@@ -989,12 +989,58 @@ static void b43_clear_keys(struct b43_wl
 	int i;
 
 	for (i = 0; i < dev->max_nr_keys; i++)
 		b43_key_clear(dev, i);
 }
 
+static void b43_dump_keymemory(struct b43_wldev *dev)
+{
+	unsigned int i, index, offset;
+	DECLARE_MAC_BUF(macbuf);
+	u8 mac[ETH_ALEN];
+	u16 algo;
+	u32 rcmta0;
+	u16 rcmta1;
+	u64 hf;
+	struct b43_key *key;
+
+	if (!b43_debug(dev, B43_DBG_KEYS))
+		return;
+
+	hf = b43_hf_read(dev);
+	b43dbg(dev->wl, "Hardware key memory dump:  USEDEFKEYS=%u\n",
+	       !!(hf & B43_HF_USEDEFKEYS));
+	for (index = 0; index < dev->max_nr_keys; index++) {
+		key = &(dev->key[index]);
+		printk(KERN_DEBUG "Key slot %02u: %s",
+		       index, (key->keyconf == NULL) ? " " : "*");
+		offset = dev->ktp + (index * B43_SEC_KEYSIZE);
+		for (i = 0; i < B43_SEC_KEYSIZE; i += 2) {
+			u16 tmp = b43_shm_read16(dev, B43_SHM_SHARED, offset + i);
+			printk("%02X%02X", (tmp & 0xFF), ((tmp >> 8) & 0xFF));
+		}
+
+		algo = b43_shm_read16(dev, B43_SHM_SHARED,
+				      B43_SHM_SH_KEYIDXBLOCK + (index * 2));
+		printk("   Algo: %04X/%02X", algo, key->algorithm);
+
+		if (index >= 4) {
+			rcmta0 = b43_shm_read32(dev, B43_SHM_RCMTA,
+						((index - 4) * 2) + 0);
+			rcmta1 = b43_shm_read16(dev, B43_SHM_RCMTA,
+						((index - 4) * 2) + 1);
+			*((__le32 *)(&mac[0])) = cpu_to_le32(rcmta0);
+			*((__le16 *)(&mac[4])) = cpu_to_le16(rcmta1);
+			printk("   MAC: %s",
+			       print_mac(macbuf, mac));
+		} else
+			printk("   DEFAULT KEY");
+		printk("\n");
+	}
+}
+
 void b43_power_saving_ctl_bits(struct b43_wldev *dev, unsigned int ps_flags)
 {
 	u32 macctl;
 	u16 ucstat;
 	bool hwps;
 	bool awake;
@@ -3563,21 +3609,24 @@ static int b43_op_set_key(struct ieee802
 			goto out_unlock;
 		break;
 	}
 	default:
 		B43_WARN_ON(1);
 	}
+
 out_unlock:
-	spin_unlock_irqrestore(&wl->irq_lock, flags);
-	mutex_unlock(&wl->mutex);
 	if (!err) {
 		b43dbg(wl, "%s hardware based encryption for keyidx: %d, "
 		       "mac: %s\n",
 		       cmd == SET_KEY ? "Using" : "Disabling", key->keyidx,
 		       print_mac(mac, addr));
+		b43_dump_keymemory(dev);
 	}
+	spin_unlock_irqrestore(&wl->irq_lock, flags);
+	mutex_unlock(&wl->mutex);
+
 	return err;
 }
 
 static void b43_op_configure_filter(struct ieee80211_hw *hw,
 				    unsigned int changed, unsigned int *fflags,
 				    int mc_count, struct dev_addr_list *mc_list)

-- 
Greetings, Michael.
