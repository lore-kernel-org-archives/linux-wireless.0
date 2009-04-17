Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:48018 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757869AbZDQNtQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2009 09:49:16 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [RFC] p54: fix pspoll mechanism in ap mode
Date: Fri, 17 Apr 2009 15:49:19 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200904171549.20075.chunkeey@web.de> (sfid-20090417_154919_782706_613FBFB7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pspolled data frames need be able to bypass the firmware's powersave filter.

---
I'm not sure about the mac80211 change... 

But without it, all frames send after the pspoll request by the station
are requeued into sta->tx_filtered.

The reason: 
the firmware rejected them (tx_status) because the station is blacklisted.
---
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 3fb04a8..d1fcfef 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -409,7 +409,8 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 		       sta->sta.addr);
 	}
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
-	clear_sta_flags(sta, WLAN_STA_PSPOLL);
+	if (test_and_clear_sta_flags(sta, WLAN_STA_PSPOLL))
+		info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
 
 	return TX_CONTINUE;
 }
diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
index adb812b..d80f2ec 100644
--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -1650,7 +1650,8 @@ static int p54_tx_fill(struct ieee80211_hw *dev, struct sk_buff *skb,
 
 		if (info->control.sta)
 			*aid = info->control.sta->aid;
-		else
+
+		if (info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT)
 			*flags |= P54_HDR_FLAG_DATA_OUT_NOCANCEL;
 		break;
 	}
