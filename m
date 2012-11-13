Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54986 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462Ab2KMR3U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 12:29:20 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so4133183eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Nov 2012 09:29:20 -0800 (PST)
From: Maxim Mikityanskiy <maxtram95@gmail.com>
To: greg@kroah.com, Larry.Finger@lwfinger.net,
	linux-wireless@vger.kernel.org
Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH 17/17] staging: rtl8187se: Removed empty stub read_acadapter_file()
Date: Tue, 13 Nov 2012 19:28:23 +0200
Message-Id: <1352827703-4659-18-git-send-email-maxtram95@gmail.com> (sfid-20121113_182926_559670_41247464)
In-Reply-To: <1352827703-4659-1-git-send-email-maxtram95@gmail.com>
References: <1352827703-4659-1-git-send-email-maxtram95@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removed empty read_acadapter_file() and priv->PowerProfile that never
changes its value

Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
---
 drivers/staging/rtl8187se/r8180.h      |    1 -
 drivers/staging/rtl8187se/r8180_core.c |   18 +-----------------
 2 files changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180.h b/drivers/staging/rtl8187se/r8180.h
index 1db8257..70ea414 100644
--- a/drivers/staging/rtl8187se/r8180.h
+++ b/drivers/staging/rtl8187se/r8180.h
@@ -611,7 +611,6 @@ typedef struct r8180_priv
 	struct work_struct watch_dog_wq;
 	short ack_tx_to_ieee;
 
-	u8 PowerProfile;
 	u8 dma_poll_stop_mask;
 
 	//u8 RegThreeWireMode;
diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index 08fdc4a..ea04eec 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -2480,7 +2480,6 @@ short rtl8180_init(struct net_device *dev)
 	priv->NumTxOkTotal = 0;
 	priv->NumTxUnicast = 0;
 	priv->keepAliveLevel = DEFAULT_KEEP_ALIVE_LEVEL;
-	priv->PowerProfile = POWER_PROFILE_AC;
 	priv->CurrRetryCnt = 0;
 	priv->LastRetryCnt = 0;
 	priv->LastTxokCnt = 0;
@@ -2927,8 +2926,6 @@ static void MgntLinkKeepAlive(struct r8180_priv *priv)
 	}
 }
 
-static u8 read_acadapter_file(char *filename);
-
 void rtl8180_watch_dog(struct net_device *dev)
 {
 	struct r8180_priv *priv = ieee80211_priv(dev);
@@ -2961,12 +2958,7 @@ void rtl8180_watch_dog(struct net_device *dev)
 	MgntLinkKeepAlive(priv);
 
 	/* YJ,add,080828,for LPS */
-	if (priv->PowerProfile == POWER_PROFILE_BATTERY)
-		priv->bLeisurePs = true;
-	else if (priv->PowerProfile == POWER_PROFILE_AC) {
-		LeisurePSLeave(priv);
-		priv->bLeisurePs = false;
-	}
+	LeisurePSLeave(priv);
 
 	if (priv->ieee80211->state == IEEE80211_LINKED) {
 		priv->link_detect.NumRxOkInPeriod = priv->ieee80211->NumRxDataInPeriod;
@@ -3735,9 +3727,6 @@ void GPIOChangeRFWorkItemCallBack(struct work_struct *work)
 	static char *envp[] = {"HOME=/", "TERM=linux", "PATH=/usr/bin:/bin", NULL};
 	static int readf_count = 0;
 
-	if (readf_count % 10 == 0)
-		priv->PowerProfile = read_acadapter_file("/proc/acpi/ac_adapter/AC0/state");
-
 	readf_count = (readf_count+1)%0xffff;
 	/* We should turn off LED before polling FF51[4]. */
 
@@ -3782,10 +3771,5 @@ void GPIOChangeRFWorkItemCallBack(struct work_struct *work)
 	}
 }
 
-static u8 read_acadapter_file(char *filename)
-{
-	return 0;
-}
-
 module_init(rtl8180_pci_module_init);
 module_exit(rtl8180_pci_module_exit);
-- 
1.7.10.4

