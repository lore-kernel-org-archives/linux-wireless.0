Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765403AbXF2NhC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2007 09:37:02 -0400
From: Michal Schmidt <mschmidt@redhat.com>
Subject: [PATCH 4/5] airo: simpler calling convention for enable_MAC()
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
	Matteo Croce <rootkit85@yahoo.it>
Date: Fri, 29 Jun 2007 15:33:47 +0200
Message-ID: <20070629133346.6658.6214.stgit@localhost.localdomain>
In-Reply-To: <20070629131841.6658.76381.stgit@localhost.localdomain>
References: <20070629131841.6658.76381.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Callers of enable_MAC() shouldn't have to worry about the bits in the
response's status word (and most of them don't). The return value is
sufficient information.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
---

 drivers/net/wireless/airo.c |   63 ++++++++++++++++++-------------------------
 1 files changed, 27 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index ae8f26e..ea79772 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -1094,7 +1094,7 @@ static int get_dec_u16( char *buffer, int *start, int limit );
 static void OUT4500( struct airo_info *, u16 register, u16 value );
 static unsigned short IN4500( struct airo_info *, u16 register );
 static u16 setup_card(struct airo_info*, u8 *mac, int lock);
-static int enable_MAC( struct airo_info *ai, Resp *rsp, int lock );
+static int enable_MAC(struct airo_info *ai, int lock);
 static void disable_MAC(struct airo_info *ai, int lock);
 static void enable_interrupts(struct airo_info*);
 static void disable_interrupts(struct airo_info*);
@@ -1938,7 +1938,6 @@ static void try_auto_wep(struct airo_info *ai)
 
 static int airo_open(struct net_device *dev) {
 	struct airo_info *ai = dev->priv;
-	Resp rsp;
 	int rc = 0;
 
 	if (test_bit(FLAG_FLASHING, &ai->flags))
@@ -1976,7 +1975,7 @@ static int airo_open(struct net_device *dev) {
 
 		try_auto_wep(ai);
 	}
-	enable_MAC(ai, &rsp, 1);
+	enable_MAC(ai, 1);
 
 	netif_start_queue(dev);
 	return 0;
@@ -2367,14 +2366,13 @@ static int airo_set_mac_address(struct net_device *dev, void *p)
 {
 	struct airo_info *ai = dev->priv;
 	struct sockaddr *addr = p;
-	Resp rsp;
 
 	readConfigRid(ai, 1);
 	memcpy (ai->config.macAddr, addr->sa_data, dev->addr_len);
 	set_bit (FLAG_COMMIT, &ai->flags);
 	disable_MAC(ai, 1);
 	writeConfigRid (ai, 1);
-	enable_MAC(ai, &rsp, 1);
+	enable_MAC(ai, 1);
 	memcpy (ai->dev->dev_addr, addr->sa_data, dev->addr_len);
 	if (ai->wifidev)
 		memcpy (ai->wifidev->dev_addr, addr->sa_data, dev->addr_len);
@@ -3539,9 +3537,11 @@ static u16 IN4500( struct airo_info *ai, u16 reg ) {
 	return rc;
 }
 
-static int enable_MAC( struct airo_info *ai, Resp *rsp, int lock ) {
+static int enable_MAC(struct airo_info *ai, int lock)
+{
 	int rc;
-        Cmd cmd;
+	Cmd cmd;
+	Resp rsp;
 
 	/* FLAG_RADIO_OFF : Radio disabled via /proc or Wireless Extensions
 	 * FLAG_RADIO_DOWN : Radio disabled via "ifconfig ethX down"
@@ -3557,7 +3557,7 @@ static int enable_MAC( struct airo_info *ai, Resp *rsp, int lock ) {
 	if (!test_bit(FLAG_ENABLED, &ai->flags)) {
 		memset(&cmd, 0, sizeof(cmd));
 		cmd.cmd = MAC_ENABLE;
-		rc = issuecommand(ai, &cmd, rsp);
+		rc = issuecommand(ai, &cmd, &rsp);
 		if (rc == SUCCESS)
 			set_bit(FLAG_ENABLED, &ai->flags);
 	} else
@@ -3567,8 +3567,12 @@ static int enable_MAC( struct airo_info *ai, Resp *rsp, int lock ) {
 	    up(&ai->sem);
 
 	if (rc)
-		airo_print_err(ai->dev->name, "%s: Cannot enable MAC, err=%d",
-			__FUNCTION__, rc);
+		airo_print_err(ai->dev->name, "Cannot enable MAC");
+	else if ((rsp.status & 0xFF00) != 0) {
+		airo_print_err(ai->dev->name, "Bad MAC enable reason=%x, "
+			"rid=%x, offset=%d", rsp.rsp0, rsp.rsp1, rsp.rsp2);
+		rc = ERROR;
+	}
 	return rc;
 }
 
@@ -3912,12 +3916,9 @@ static u16 setup_card(struct airo_info *ai, u8 *mac, int lock)
 		if ( status != SUCCESS ) return ERROR;
 	}
 
-	status = enable_MAC(ai, &rsp, lock);
-	if ( status != SUCCESS || (rsp.status & 0xFF00) != 0) {
-		airo_print_err(ai->dev->name, "Bad MAC enable reason = %x, rid = %x,"
-			" offset = %d", rsp.rsp0, rsp.rsp1, rsp.rsp2 );
+	status = enable_MAC(ai, lock);
+	if (status != SUCCESS)
 		return ERROR;
-	}
 
 	/* Grab the initial wep key, we gotta save it for auto_wep */
 	rc = readWepKeyRid(ai, &wkr, 1, lock);
@@ -5159,7 +5160,6 @@ static void proc_SSID_on_close( struct inode *inode, struct file *file ) {
 	struct net_device *dev = dp->data;
 	struct airo_info *ai = dev->priv;
 	SsidRid SSID_rid;
-	Resp rsp;
 	int i;
 	int offset = 0;
 
@@ -5184,7 +5184,7 @@ static void proc_SSID_on_close( struct inode *inode, struct file *file ) {
 		SSID_rid.len = sizeof(SSID_rid);
 	disable_MAC(ai, 1);
 	writeSsidRid(ai, &SSID_rid, 1);
-	enable_MAC(ai, &rsp, 1);
+	enable_MAC(ai, 1);
 }
 
 static inline u8 hexVal(char c) {
@@ -5200,7 +5200,6 @@ static void proc_APList_on_close( struct inode *inode, struct file *file ) {
 	struct net_device *dev = dp->data;
 	struct airo_info *ai = dev->priv;
 	APListRid APList_rid;
-	Resp rsp;
 	int i;
 
 	if ( !data->writelen ) return;
@@ -5225,18 +5224,17 @@ static void proc_APList_on_close( struct inode *inode, struct file *file ) {
 	}
 	disable_MAC(ai, 1);
 	writeAPListRid(ai, &APList_rid, 1);
-	enable_MAC(ai, &rsp, 1);
+	enable_MAC(ai, 1);
 }
 
 /* This function wraps PC4500_writerid with a MAC disable */
 static int do_writerid( struct airo_info *ai, u16 rid, const void *rid_data,
 			int len, int dummy ) {
 	int rc;
-	Resp rsp;
 
 	disable_MAC(ai, 1);
 	rc = PC4500_writerid(ai, rid, rid_data, len, 1);
-	enable_MAC(ai, &rsp, 1);
+	enable_MAC(ai, 1);
 	return rc;
 }
 
@@ -5267,7 +5265,6 @@ static int set_wep_key(struct airo_info *ai, u16 index,
 		       const char *key, u16 keylen, int perm, int lock ) {
 	static const unsigned char macaddr[ETH_ALEN] = { 0x01, 0, 0, 0, 0, 0 };
 	WepKeyRid wkr;
-	Resp rsp;
 
 	memset(&wkr, 0, sizeof(wkr));
 	if (keylen == 0) {
@@ -5287,7 +5284,7 @@ static int set_wep_key(struct airo_info *ai, u16 index,
 
 	if (perm) disable_MAC(ai, lock);
 	writeWepKeyRid(ai, &wkr, perm, lock);
-	if (perm) enable_MAC(ai, &rsp, lock);
+	if (perm) enable_MAC(ai, lock);
 	return 0;
 }
 
@@ -5555,7 +5552,6 @@ static int proc_close( struct inode *inode, struct file *file )
    changed. */
 static void timer_func( struct net_device *dev ) {
 	struct airo_info *apriv = dev->priv;
-	Resp rsp;
 
 /* We don't have a link so try changing the authtype */
 	readConfigRid(apriv, 0);
@@ -5582,7 +5578,7 @@ static void timer_func( struct net_device *dev ) {
 	}
 	set_bit (FLAG_COMMIT, &apriv->flags);
 	writeConfigRid(apriv, 0);
-	enable_MAC(apriv, &rsp, 0);
+	enable_MAC(apriv, 0);
 	up(&apriv->sem);
 
 /* Schedule check to see if the change worked */
@@ -5657,7 +5653,6 @@ static int airo_pci_resume(struct pci_dev *pdev)
 {
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct airo_info *ai = dev->priv;
-	Resp rsp;
 	pci_power_t prev_state = pdev->current_state;
 
 	pci_set_power_state(pdev, PCI_D0);
@@ -5690,7 +5685,7 @@ static int airo_pci_resume(struct pci_dev *pdev)
 		ai->APList = NULL;
 	}
 	writeConfigRid(ai, 0);
-	enable_MAC(ai, &rsp, 0);
+	enable_MAC(ai, 0);
 	ai->power = PMSG_ON;
 	netif_device_attach(dev);
 	netif_wake_queue(dev);
@@ -5914,7 +5909,6 @@ static int airo_set_essid(struct net_device *dev,
 			  char *extra)
 {
 	struct airo_info *local = dev->priv;
-	Resp rsp;
 	SsidRid SSID_rid;		/* SSIDs */
 
 	/* Reload the list of current SSID */
@@ -5946,7 +5940,7 @@ static int airo_set_essid(struct net_device *dev,
 	/* Write it to the card */
 	disable_MAC(local, 1);
 	writeSsidRid(local, &SSID_rid, 1);
-	enable_MAC(local, &rsp, 1);
+	enable_MAC(local, 1);
 
 	return 0;
 }
@@ -6011,7 +6005,7 @@ static int airo_set_wap(struct net_device *dev,
 		memcpy(APList_rid.ap[0], awrq->sa_data, ETH_ALEN);
 		disable_MAC(local, 1);
 		writeAPListRid(local, &APList_rid, 1);
-		enable_MAC(local, &rsp, 1);
+		enable_MAC(local, 1);
 	}
 	return 0;
 }
@@ -7465,7 +7459,6 @@ static int airo_config_commit(struct net_device *dev,
 			      char *extra)			/* NULL */
 {
 	struct airo_info *local = dev->priv;
-	Resp rsp;
 
 	if (!test_bit (FLAG_COMMIT, &local->flags))
 		return 0;
@@ -7490,7 +7483,7 @@ static int airo_config_commit(struct net_device *dev,
 	if (down_interruptible(&local->sem))
 		return -ERESTARTSYS;
 	writeConfigRid(local, 0);
-	enable_MAC(local, &rsp, 0);
+	enable_MAC(local, 0);
 	if (test_bit (FLAG_RESET, &local->flags))
 		airo_set_promisc(local);
 	else
@@ -7757,7 +7750,6 @@ static int readrids(struct net_device *dev, aironet_ioctl *comp) {
 	unsigned char *iobuf;
 	int len;
 	struct airo_info *ai = dev->priv;
-	Resp rsp;
 
 	if (test_bit(FLAG_FLASHING, &ai->flags))
 		return -EIO;
@@ -7769,7 +7761,7 @@ static int readrids(struct net_device *dev, aironet_ioctl *comp) {
 		if (test_bit(FLAG_COMMIT, &ai->flags)) {
 			disable_MAC (ai, 1);
 			writeConfigRid (ai, 1);
-			enable_MAC (ai, &rsp, 1);
+			enable_MAC(ai, 1);
 		}
 		break;
 	case AIROGSLIST:    ridcode = RID_SSID;         break;
@@ -7826,7 +7818,6 @@ static int writerids(struct net_device *dev, aironet_ioctl *comp) {
 	struct airo_info *ai = dev->priv;
 	int  ridcode;
         int  enabled;
-	Resp      rsp;
 	static int (* writer)(struct airo_info *, u16 rid, const void *, int, int);
 	unsigned char *iobuf;
 
@@ -7860,7 +7851,7 @@ static int writerids(struct net_device *dev, aironet_ioctl *comp) {
 		 * same with MAC off
 		 */
 	case AIROPMACON:
-		if (enable_MAC(ai, &rsp, 1) != 0)
+		if (enable_MAC(ai, 1) != 0)
 			return -EIO;
 		return 0;
 

