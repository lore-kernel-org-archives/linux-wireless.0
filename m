Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36639 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932551Ab2C2X25 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2012 19:28:57 -0400
Received: by mail-pb0-f46.google.com with SMTP id un15so789148pbc.19
        for <linux-wireless@vger.kernel.org>; Thu, 29 Mar 2012 16:28:57 -0700 (PDT)
MIME-Version: 1.0
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: javier@cozybit.com, thomas@cozybit.com, johannes@sipsolutions.net,
	devel@lists.open80211s.org, linville@tuxdriver.com,
	Ashok Nagarajan <ashok@cozybit.com>
Subject: [PATCH 2/4] mac80211: Indicate basic rates when adding supported rates
Date: Thu, 29 Mar 2012 16:28:47 -0700
Message-Id: <1333063729-9353-2-git-send-email-ashok@cozybit.com> (sfid-20120330_012901_671445_15225E49)
In-Reply-To: <1333063729-9353-1-git-send-email-ashok@cozybit.com>
References: <1333063729-9353-1-git-send-email-ashok@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

and extended supported rates

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/util.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 32f7a3b..a1e2ff5 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1685,6 +1685,7 @@ int ieee80211_add_srates_ie(struct ieee80211_vif *vif, struct sk_buff *skb)
 	struct ieee80211_supported_band *sband;
 	int rate;
 	u8 i, rates, *pos;
+	u32 basic_rates = vif->bss_conf.basic_rates;
 
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 	rates = sband->n_bitrates;
@@ -1698,8 +1699,11 @@ int ieee80211_add_srates_ie(struct ieee80211_vif *vif, struct sk_buff *skb)
 	*pos++ = WLAN_EID_SUPP_RATES;
 	*pos++ = rates;
 	for (i = 0; i < rates; i++) {
+		u8 basic = 0;
+		if (basic_rates & BIT(i))
+			basic = 0x80;
 		rate = sband->bitrates[i].bitrate;
-		*pos++ = (u8) (rate / 5);
+		*pos++ = basic | (u8) (rate / 5);
 	}
 
 	return 0;
@@ -1712,6 +1716,7 @@ int ieee80211_add_ext_srates_ie(struct ieee80211_vif *vif, struct sk_buff *skb)
 	struct ieee80211_supported_band *sband;
 	int rate;
 	u8 i, exrates, *pos;
+	u32 basic_rates = vif->bss_conf.basic_rates;
 
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 	exrates = sband->n_bitrates;
@@ -1728,8 +1733,11 @@ int ieee80211_add_ext_srates_ie(struct ieee80211_vif *vif, struct sk_buff *skb)
 		*pos++ = WLAN_EID_EXT_SUPP_RATES;
 		*pos++ = exrates;
 		for (i = 8; i < sband->n_bitrates; i++) {
+			u8 basic = 0;
+			if (basic_rates & BIT(i))
+				basic = 0x80;
 			rate = sband->bitrates[i].bitrate;
-			*pos++ = (u8) (rate / 5);
+			*pos++ = basic | (u8) (rate / 5);
 		}
 	}
 	return 0;
-- 
1.7.5.4

