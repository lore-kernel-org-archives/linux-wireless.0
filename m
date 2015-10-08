Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:39313 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011AbbJHSOQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2015 14:14:16 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Kernel development list <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 1/2] airo: Track APList_rid in struct airo_info
Date: Thu,  8 Oct 2015 20:14:03 +0200
Message-Id: <1444328044-13075-1-git-send-email-linux@rainbow-software.org> (sfid-20151008_201444_117164_02BE59C2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of dynamically allocating APList, make it a member of struct
airo_info to always track state of APList_rid.
This simplifies suspend/resume and allows removal of readAPListRid.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/net/wireless/airo.c |   57 +++++++++++++++----------------------------
 1 file changed, 19 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 8ae838d..4ef2f98 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -1231,7 +1231,7 @@ struct airo_info {
 	dma_addr_t		shared_dma;
 	pm_message_t		power;
 	SsidRid			*SSID;
-	APListRid		*APList;
+	APListRid		APList;
 #define	PCI_SHARED_LEN		2*MPI_MAX_FIDS*PKTSIZE+RIDSIZE
 	char			proc_name[IFNAMSIZ];
 
@@ -1848,11 +1848,6 @@ static int readStatusRid(struct airo_info *ai, StatusRid *statr, int lock)
 	return PC4500_readrid(ai, RID_STATUS, statr, sizeof(*statr), lock);
 }
 
-static int readAPListRid(struct airo_info *ai, APListRid *aplr)
-{
-	return PC4500_readrid(ai, RID_APLIST, aplr, sizeof(*aplr), 1);
-}
-
 static int writeAPListRid(struct airo_info *ai, APListRid *aplr, int lock)
 {
 	return PC4500_writerid(ai, RID_APLIST, aplr, sizeof(*aplr), lock);
@@ -2413,7 +2408,6 @@ void stop_airo_card( struct net_device *dev, int freeres )
 
 	kfree(ai->flash);
 	kfree(ai->rssi);
-	kfree(ai->APList);
 	kfree(ai->SSID);
 	if (freeres) {
 		/* PCMCIA frees this stuff, so only for PCI and ISA */
@@ -2809,6 +2803,7 @@ static struct net_device *_init_airo_card( unsigned short irq, int port,
 	init_waitqueue_head (&ai->thr_wait);
 	ai->tfm = NULL;
 	add_airo_dev(ai);
+	ai->APList.len = cpu_to_le16(sizeof(struct APListRid));
 
 	if (airo_networks_allocate (ai))
 		goto err_out_free;
@@ -3852,8 +3847,6 @@ static u16 setup_card(struct airo_info *ai, u8 *mac, int lock)
 		tdsRssiRid rssi_rid;
 		CapabilityRid cap_rid;
 
-		kfree(ai->APList);
-		ai->APList = NULL;
 		kfree(ai->SSID);
 		ai->SSID = NULL;
 		// general configuration (read/modify/write)
@@ -5130,31 +5123,31 @@ static void proc_APList_on_close( struct inode *inode, struct file *file ) {
 	struct proc_data *data = file->private_data;
 	struct net_device *dev = PDE_DATA(inode);
 	struct airo_info *ai = dev->ml_priv;
-	APListRid APList_rid;
+	APListRid *APList_rid = &ai->APList;
 	int i;
 
 	if ( !data->writelen ) return;
 
-	memset( &APList_rid, 0, sizeof(APList_rid) );
-	APList_rid.len = cpu_to_le16(sizeof(APList_rid));
+	memset(APList_rid, 0, sizeof(*APList_rid));
+	APList_rid->len = cpu_to_le16(sizeof(*APList_rid));
 
 	for( i = 0; i < 4 && data->writelen >= (i+1)*6*3; i++ ) {
 		int j;
 		for( j = 0; j < 6*3 && data->wbuffer[j+i*6*3]; j++ ) {
 			switch(j%3) {
 			case 0:
-				APList_rid.ap[i][j/3]=
+				APList_rid->ap[i][j/3]=
 					hex_to_bin(data->wbuffer[j+i*6*3])<<4;
 				break;
 			case 1:
-				APList_rid.ap[i][j/3]|=
+				APList_rid->ap[i][j/3]|=
 					hex_to_bin(data->wbuffer[j+i*6*3]);
 				break;
 			}
 		}
 	}
 	disable_MAC(ai, 1);
-	writeAPListRid(ai, &APList_rid, 1);
+	writeAPListRid(ai, APList_rid, 1);
 	enable_MAC(ai, 1);
 }
 
@@ -5408,7 +5401,7 @@ static int proc_APList_open( struct inode *inode, struct file *file ) {
 	struct airo_info *ai = dev->ml_priv;
 	int i;
 	char *ptr;
-	APListRid APList_rid;
+	APListRid *APList_rid = &ai->APList;
 
 	if ((file->private_data = kzalloc(sizeof(struct proc_data ), GFP_KERNEL)) == NULL)
 		return -ENOMEM;
@@ -5426,13 +5419,12 @@ static int proc_APList_open( struct inode *inode, struct file *file ) {
 	}
 	data->on_close = proc_APList_on_close;
 
-	readAPListRid(ai, &APList_rid);
 	ptr = data->rbuffer;
 	for( i = 0; i < 4; i++ ) {
 // We end when we find a zero MAC
-		if ( !*(int*)APList_rid.ap[i] &&
-		     !*(int*)&APList_rid.ap[i][2]) break;
-		ptr += sprintf(ptr, "%pM\n", APList_rid.ap[i]);
+		if ( !*(int*)APList_rid->ap[i] &&
+		     !*(int*)&APList_rid->ap[i][2]) break;
+		ptr += sprintf(ptr, "%pM\n", APList_rid->ap[i]);
 	}
 	if (i==0) ptr += sprintf(ptr, "Not using specific APs\n");
 
@@ -5596,15 +5588,10 @@ static int airo_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	Cmd cmd;
 	Resp rsp;
 
-	if (!ai->APList)
-		ai->APList = kmalloc(sizeof(APListRid), GFP_KERNEL);
-	if (!ai->APList)
-		return -ENOMEM;
 	if (!ai->SSID)
 		ai->SSID = kmalloc(sizeof(SsidRid), GFP_KERNEL);
 	if (!ai->SSID)
 		return -ENOMEM;
-	readAPListRid(ai, ai->APList);
 	readSsidRid(ai, ai->SSID);
 	memset(&cmd, 0, sizeof(cmd));
 	/* the lock will be released at the end of the resume callback */
@@ -5652,11 +5639,7 @@ static int airo_pci_resume(struct pci_dev *pdev)
 		kfree(ai->SSID);
 		ai->SSID = NULL;
 	}
-	if (ai->APList) {
-		writeAPListRid(ai, ai->APList, 0);
-		kfree(ai->APList);
-		ai->APList = NULL;
-	}
+	writeAPListRid(ai, &ai->APList, 0);
 	writeConfigRid(ai, 0);
 	enable_MAC(ai, 0);
 	ai->power = PMSG_ON;
@@ -5954,7 +5937,7 @@ static int airo_set_wap(struct net_device *dev,
 	struct airo_info *local = dev->ml_priv;
 	Cmd cmd;
 	Resp rsp;
-	APListRid APList_rid;
+	APListRid *APList_rid = &local->APList;
 
 	if (awrq->sa_family != ARPHRD_ETHER)
 		return -EINVAL;
@@ -5967,11 +5950,11 @@ static int airo_set_wap(struct net_device *dev,
 		issuecommand(local, &cmd, &rsp);
 		up(&local->sem);
 	} else {
-		memset(&APList_rid, 0, sizeof(APList_rid));
-		APList_rid.len = cpu_to_le16(sizeof(APList_rid));
-		memcpy(APList_rid.ap[0], awrq->sa_data, ETH_ALEN);
+		memset(APList_rid, 0, sizeof(*APList_rid));
+		APList_rid->len = cpu_to_le16(sizeof(*APList_rid));
+		memcpy(APList_rid->ap[0], awrq->sa_data, ETH_ALEN);
 		disable_MAC(local, 1);
-		writeAPListRid(local, &APList_rid, 1);
+		writeAPListRid(local, APList_rid, 1);
 		enable_MAC(local, 1);
 	}
 	return 0;
@@ -7505,10 +7488,8 @@ static int airo_config_commit(struct net_device *dev,
 	 * parameters. It's now time to commit them in the card */
 	disable_MAC(local, 1);
 	if (test_bit (FLAG_RESET, &local->flags)) {
-		APListRid APList_rid;
 		SsidRid SSID_rid;
 
-		readAPListRid(local, &APList_rid);
 		readSsidRid(local, &SSID_rid);
 		if (test_bit(FLAG_MPI,&local->flags))
 			setup_card(local, dev->dev_addr, 1 );
@@ -7516,7 +7497,7 @@ static int airo_config_commit(struct net_device *dev,
 			reset_airo_card(dev);
 		disable_MAC(local, 1);
 		writeSsidRid(local, &SSID_rid, 1);
-		writeAPListRid(local, &APList_rid, 1);
+		writeAPListRid(local, &local->APList, 1);
 	}
 	if (down_interruptible(&local->sem))
 		return -ERESTARTSYS;
-- 
Ondrej Zary

