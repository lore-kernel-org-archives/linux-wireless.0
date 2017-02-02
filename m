Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:50007 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750879AbdBBOjB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Feb 2017 09:39:01 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Arnd Bergmann <arnd@arndb.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8192u: move stats_IndicateArray off stack
Date: Thu,  2 Feb 2017 15:38:24 +0100
Message-Id: <20170202143850.3622382-1-arnd@arndb.de> (sfid-20170202_153941_803350_93AAA4D7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Putting 128 pointers on the stack is rather wasteful, in particular
on 64-bit architectures:

drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c: In function 'RxPktPendingTimeout':
drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c:92:1: warning: the frame size of 1072 bytes is larger than 1024 bytes [-Wframe-larger-than=]

The rtl8192e driver has the exact same function, except that stores the
array in its 'ieee' structure. Let's do it the same way here for consistency.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/rtl8192u/ieee80211/ieee80211.h      | 1 +
 drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c | 5 ++---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211.h b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
index 17e985a1babf..10bb23739748 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
@@ -1894,6 +1894,7 @@ struct ieee80211_device {
 	//u32 STA_EDCA_PARAM[4];
 	//CHANNEL_ACCESS_SETTING ChannelAccessSetting;
 
+	struct ieee80211_rxb *stats_IndicateArray[REORDER_WIN_SIZE];
 
 	/* Callback functions */
 	void (*set_security)(struct net_device *dev,
diff --git a/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c b/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c
index 6033502eff3d..b9ff8fec2edf 100644
--- a/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c
+++ b/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c
@@ -31,7 +31,6 @@ static void RxPktPendingTimeout(unsigned long data)
 
 	//u32 flags = 0;
 	unsigned long flags = 0;
-	struct ieee80211_rxb *stats_IndicateArray[REORDER_WIN_SIZE];
 	u8 index = 0;
 	bool bPktInBuf = false;
 
@@ -55,7 +54,7 @@ static void RxPktPendingTimeout(unsigned long data)
 					pRxTs->RxIndicateSeq = (pRxTs->RxIndicateSeq + 1) % 4096;
 
 				IEEE80211_DEBUG(IEEE80211_DL_REORDER,"RxPktPendingTimeout(): IndicateSeq: %d\n", pReorderEntry->SeqNum);
-				stats_IndicateArray[index] = pReorderEntry->prxb;
+				ieee->stats_IndicateArray[index] = pReorderEntry->prxb;
 				index++;
 
 				list_add_tail(&pReorderEntry->List, &ieee->RxReorder_Unused_List);
@@ -79,7 +78,7 @@ static void RxPktPendingTimeout(unsigned long data)
 			spin_unlock_irqrestore(&(ieee->reorder_spinlock), flags);
 			return;
 		}
-		ieee80211_indicate_packets(ieee, stats_IndicateArray, index);
+		ieee80211_indicate_packets(ieee, ieee->stats_IndicateArray, index);
 	}
 
 	if(bPktInBuf && (pRxTs->RxTimeoutIndicateSeq==0xffff))
-- 
2.9.0
