Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:45347 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbaJYTQ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 15:16:28 -0400
Received: by mail-wi0-f175.google.com with SMTP id h11so1512216wiw.14
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 12:16:26 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 02/48] staging: vt6655: deadcode remove zone file operations and vntconfiguration.dat
Date: Sat, 25 Oct 2014 09:39:40 +0100
Message-Id: <1414226426-5811-3-git-send-email-tvboxspy@gmail.com> (sfid-20141025_211638_339134_5B77DACD)
In-Reply-To: <1414226426-5811-1-git-send-email-tvboxspy@gmail.com>
References: <1414226426-5811-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These are now all handled by mac80211.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h             |   2 -
 drivers/staging/vt6655/device_main.c        | 113 +---------------------------
 drivers/staging/vt6655/vntconfiguration.dat |   1 -
 3 files changed, 3 insertions(+), 113 deletions(-)
 delete mode 100644 drivers/staging/vt6655/vntconfiguration.dat

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 90b4581..35a1689 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -759,6 +759,4 @@ bool device_dma0_xmit(struct vnt_private *pDevice,
 		      struct sk_buff *skb, unsigned int uNodeIndex);
 bool device_alloc_frag_buf(struct vnt_private *pDevice,
 			   PSDeFragControlBlock pDeF);
-int Config_FileOperation(struct vnt_private *pDevice,
-			 bool fwrite, unsigned char *Parameter);
 #endif
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index c5eca10..3a1c9ee 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -303,8 +303,6 @@ static void device_free_rd0_ring(struct vnt_private *pDevice);
 static void device_free_rd1_ring(struct vnt_private *pDevice);
 static void device_free_rings(struct vnt_private *pDevice);
 static void device_free_frag_buf(struct vnt_private *pDevice);
-static int Config_FileGetParameter(unsigned char *string,
-				   unsigned char *dest, unsigned char *source);
 
 /*---------------------  Export Variables  --------------------------*/
 
@@ -412,7 +410,6 @@ static void device_init_registers(struct vnt_private *pDevice)
 	unsigned char byValue1;
 	unsigned char byCCKPwrdBm = 0;
 	unsigned char byOFDMPwrdBm = 0;
-	int zonetype = 0;
 
 	MACbShutdown(pDevice->PortOffset);
 	BBvSoftwareReset(pDevice->PortOffset);
@@ -517,41 +514,6 @@ static void device_init_registers(struct vnt_private *pDevice)
 
 	/* zonetype initial */
 	pDevice->byOriginalZonetype = pDevice->abyEEPROM[EEP_OFS_ZONETYPE];
-	zonetype = Config_FileOperation(pDevice, false, NULL);
-
-	if (zonetype >= 0) {
-		if ((zonetype == 0) &&
-		    (pDevice->abyEEPROM[EEP_OFS_ZONETYPE] != 0x00)) {
-			/* for USA */
-			pDevice->abyEEPROM[EEP_OFS_ZONETYPE] = 0;
-			pDevice->abyEEPROM[EEP_OFS_MAXCHANNEL] = 0x0B;
-
-			pr_debug("Init Zone Type :USA\n");
-		} else if ((zonetype == 1) &&
-			 (pDevice->abyEEPROM[EEP_OFS_ZONETYPE] != 0x01)) {
-			/* for Japan */
-			pDevice->abyEEPROM[EEP_OFS_ZONETYPE] = 0x01;
-			pDevice->abyEEPROM[EEP_OFS_MAXCHANNEL] = 0x0D;
-		} else if ((zonetype == 2) &&
-			  (pDevice->abyEEPROM[EEP_OFS_ZONETYPE] != 0x02)) {
-			/* for Europe */
-			pDevice->abyEEPROM[EEP_OFS_ZONETYPE] = 0x02;
-			pDevice->abyEEPROM[EEP_OFS_MAXCHANNEL] = 0x0D;
-
-			pr_debug("Init Zone Type :Europe\n");
-		} else {
-			if (zonetype != pDevice->abyEEPROM[EEP_OFS_ZONETYPE])
-				pr_debug("zonetype in file[%02x] mismatch with in EEPROM[%02x]\n",
-					 zonetype,
-					 pDevice->abyEEPROM[EEP_OFS_ZONETYPE]);
-			else
-				pr_debug("Read Zonetype file success,use default zonetype setting[%02x]\n",
-					 zonetype);
-		}
-	} else {
-		pr_debug("Read Zonetype file fail,use default zonetype setting[%02x]\n",
-			 SROMbyReadEmbedded(pDevice->PortOffset, EEP_OFS_ZONETYPE));
-	}
 
 	/* Get RFType */
 	pDevice->byRFType = SROMbyReadEmbedded(pDevice->PortOffset, EEP_OFS_RFTYPE);
@@ -595,14 +557,9 @@ static void device_init_registers(struct vnt_private *pDevice)
 	}
 
 	/* recover 12,13 ,14channel for EUROPE by 11 channel */
-	if (((pDevice->abyEEPROM[EEP_OFS_ZONETYPE] == ZoneType_Japan) ||
-	     (pDevice->abyEEPROM[EEP_OFS_ZONETYPE] == ZoneType_Europe)) &&
-	    (pDevice->byOriginalZonetype == ZoneType_USA)) {
-		for (ii = 11; ii < 14; ii++) {
-			pDevice->abyCCKPwrTbl[ii] = pDevice->abyCCKPwrTbl[10];
-			pDevice->abyOFDMPwrTbl[ii] = pDevice->abyOFDMPwrTbl[10];
-
-		}
+	for (ii = 11; ii < 14; ii++) {
+		pDevice->abyCCKPwrTbl[ii] = pDevice->abyCCKPwrTbl[10];
+		pDevice->abyOFDMPwrTbl[ii] = pDevice->abyOFDMPwrTbl[10];
 	}
 
 	/* Load OFDM A Power Table */
@@ -2138,70 +2095,6 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance)
 	return IRQ_RETVAL(handled);
 }
 
-//2008-8-4 <add> by chester
-static int Config_FileGetParameter(unsigned char *string,
-				   unsigned char *dest, unsigned char *source)
-{
-	unsigned char buf1[100];
-	int source_len = strlen(source);
-
-	memset(buf1, 0, 100);
-	strcat(buf1, string);
-	strcat(buf1, "=");
-	source += strlen(buf1);
-
-	memcpy(dest, source, source_len - strlen(buf1));
-	return true;
-}
-
-int Config_FileOperation(struct vnt_private *pDevice,
-			 bool fwrite, unsigned char *Parameter)
-{
-	unsigned char *buffer = kmalloc(1024, GFP_KERNEL);
-	unsigned char tmpbuffer[20];
-	struct file *file;
-	int result = 0;
-
-	if (!buffer) {
-		pr_err("allocate mem for file fail?\n");
-		return -1;
-	}
-	file = filp_open(CONFIG_PATH, O_RDONLY, 0);
-	if (IS_ERR(file)) {
-		kfree(buffer);
-		pr_err("Config_FileOperation:open file fail?\n");
-		return -1;
-	}
-
-	if (kernel_read(file, 0, buffer, 1024) < 0) {
-		pr_err("read file error?\n");
-		result = -1;
-		goto error1;
-	}
-
-	if (Config_FileGetParameter("ZONETYPE", tmpbuffer, buffer) != true) {
-		pr_err("get parameter error?\n");
-		result = -1;
-		goto error1;
-	}
-
-	if (memcmp(tmpbuffer, "USA", 3) == 0) {
-		result = ZoneType_USA;
-	} else if (memcmp(tmpbuffer, "JAPAN", 5) == 0) {
-		result = ZoneType_Japan;
-	} else if (memcmp(tmpbuffer, "EUROPE", 5) == 0) {
-		result = ZoneType_Europe;
-	} else {
-		result = -1;
-		pr_err("Unknown Zonetype[%s]?\n", tmpbuffer);
-	}
-
-error1:
-	kfree(buffer);
-	fput(file);
-	return result;
-}
-
 static void device_set_multi(struct net_device *dev) {
 	struct vnt_private *pDevice = netdev_priv(dev);
 	PSMgmtObject     pMgmt = pDevice->pMgmt;
diff --git a/drivers/staging/vt6655/vntconfiguration.dat b/drivers/staging/vt6655/vntconfiguration.dat
deleted file mode 100644
index 0064ddc..0000000
--- a/drivers/staging/vt6655/vntconfiguration.dat
+++ /dev/null
@@ -1 +0,0 @@
-ZONETYPE=EUROPE
\ No newline at end of file
-- 
1.9.1

