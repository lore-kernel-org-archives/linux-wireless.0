Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60049 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbaATMAz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 07:00:55 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.82)
	(envelope-from <johannes@sipsolutions.net>)
	id 1W5DXC-0007j5-L3
	for linux-wireless@vger.kernel.org; Mon, 20 Jan 2014 13:00:54 +0100
Message-ID: <1390219252.4335.24.camel@jlt4.sipsolutions.net> (sfid-20140120_130058_635262_649D6D3E)
Subject: [PATCH] mac80211: advertise BF STS according to AP support
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 20 Jan 2014 13:00:52 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Restrict our published beamformee STS capability according
to the AP value.
Some AP show bad behaviour in interoperability testing
when our capabilities are better.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index dc770bd..2d7e1bee 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -508,6 +508,7 @@ static void ieee80211_add_vht_ie(struct ieee80211_sub_if_data *sdata,
 	u8 *pos;
 	u32 cap;
 	struct ieee80211_sta_vht_cap vht_cap;
+	u32 mask, ap_bf_sts, our_bf_sts;
 
 	BUILD_BUG_ON(sizeof(vht_cap) != sizeof(sband->vht_cap));
 
@@ -535,6 +536,16 @@ static void ieee80211_add_vht_ie(struct ieee80211_sub_if_data *sdata,
 			cpu_to_le32(IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE)))
 		cap &= ~IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE;
 
+	mask = IEEE80211_VHT_CAP_BEAMFORMEE_STS_MASK;
+
+	ap_bf_sts = le32_to_cpu(ap_vht_cap->vht_cap_info) & mask;
+	our_bf_sts = cap & mask;
+
+	if (ap_bf_sts < our_bf_sts) {
+		cap &= ~mask;
+		cap |= ap_bf_sts;
+	}
+
 	/* reserve and fill IE */
 	pos = skb_put(skb, sizeof(struct ieee80211_vht_cap) + 2);
 	ieee80211_ie_build_vht_cap(pos, &vht_cap, cap);
-- 
1.8.5.1



