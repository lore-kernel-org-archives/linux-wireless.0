Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49658 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab2KLV7S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 16:59:18 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so3644080eek.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2012 13:59:18 -0800 (PST)
From: Maxim Mikityanskiy <maxtram95@gmail.com>
To: greg@kroah.com, linux-wireless@vger.kernel.org
Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH 17/17] Removed empty stub read_acadapter_file()
Date: Mon, 12 Nov 2012 23:58:31 +0200
Message-Id: <1352757511-26957-18-git-send-email-maxtram95@gmail.com> (sfid-20121112_231526_554678_0DC180CA)
In-Reply-To: <1352757511-26957-1-git-send-email-maxtram95@gmail.com>
References: <1352757511-26957-1-git-send-email-maxtram95@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
---
 r8180.h      |    1 -
 r8180_core.c |   18 +-----------------
 2 files changed, 1 insertion(+), 18 deletions(-)

diff --git a/r8180.h b/r8180.h
index 1db8257..70ea414 100644
--- a/r8180.h
+++ b/r8180.h
@@ -611,7 +611,6 @@ typedef struct r8180_priv
 	struct work_struct watch_dog_wq;
 	short ack_tx_to_ieee;
 
-	u8 PowerProfile;
 	u8 dma_poll_stop_mask;
 
 	//u8 RegThreeWireMode;
diff --git a/r8180_core.c b/r8180_core.c
index 9e0621b..c60a618 100644
--- a/r8180_core.c
+++ b/r8180_core.c
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

