Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:53519 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab2FYK6L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 06:58:11 -0400
Received: by wibhr14 with SMTP id hr14so965819wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jun 2012 03:58:09 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: flush queues before deauth/disassoc
Date: Mon, 25 Jun 2012 13:58:19 +0300
Message-Id: <1340621899-15002-1-git-send-email-eliad@wizery.com> (sfid-20120625_125815_405547_D62E871F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On deauth/disassoc we tear down all BA sessions. These
DELBA packets are sent on the appropriate TID, while
deauth/disassoc is always sent on VO. This sometimes
ends with the DELBA being sent after the deauth was
already sent.

Fix it by flushing all the pending frames before
sending deauth/disassoc (in ieee80211_send_deauth_disassoc).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
i think flushing in ieee80211_send_deauth_disassoc is the
easiest thing to do here, as it handles all the (future) cases.
however, i don't care moving the flush to a higher function
if someone prefers it.

 net/mac80211/mlme.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 426877d..6a73c65 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -580,6 +580,9 @@ static void ieee80211_send_deauth_disassoc(struct ieee80211_sub_if_data *sdata,
 		if (!(ifmgd->flags & IEEE80211_STA_MFP_ENABLED))
 			IEEE80211_SKB_CB(skb)->flags |=
 				IEEE80211_TX_INTFL_DONT_ENCRYPT;
+
+		/* flush out any pending frame */
+		drv_flush(local, false);
 		ieee80211_tx_skb(sdata, skb);
 	}
 }
-- 
1.7.6.401.g6a319

