Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:54916 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752481AbdBNVBk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 16:01:40 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: johannes.berg@intel.com, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] mac80211:  allow overriding station bandwidth.
Date: Tue, 14 Feb 2017 13:01:35 -0800
Message-Id: <1487106095-23287-1-git-send-email-greearb@candelatech.com> (sfid-20170214_220143_477541_65E9EEB9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This allows one to disable VHT160 (or 80+80) on hardware
that might otherwise try to use it.  One potential reason
to do this is that at least some 160Mhz/80+80 hardware can
only do 2x2 at 160Mhz, but can do 4x4 at 80Mhz.  And, due to
driver and firmware issues, it may effectively be limitted
to 1x1 at 160Mhz for some NICs.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 include/linux/ieee80211.h |  1 +
 net/mac80211/main.c       |  1 +
 net/mac80211/vht.c        | 23 +++++++++++++++++++++++
 3 files changed, 25 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index a80516f..e5dc3a8 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1542,6 +1542,7 @@ struct ieee80211_vht_operation {
 #define IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ		0x00000004
 #define IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ	0x00000008
 #define IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK			0x0000000C
+#define IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_SHIFT			2
 #define IEEE80211_VHT_CAP_RXLDPC				0x00000010
 #define IEEE80211_VHT_CAP_SHORT_GI_80				0x00000020
 #define IEEE80211_VHT_CAP_SHORT_GI_160				0x00000040
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index ec5587d..1447b47 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -464,6 +464,7 @@ static const struct ieee80211_ht_cap mac80211_ht_capa_mod_mask = {
 static const struct ieee80211_vht_cap mac80211_vht_capa_mod_mask = {
 	.vht_cap_info =
 		cpu_to_le32(IEEE80211_VHT_CAP_RXLDPC |
+			    IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK |
 			    IEEE80211_VHT_CAP_SHORT_GI_80 |
 			    IEEE80211_VHT_CAP_SHORT_GI_160 |
 			    IEEE80211_VHT_CAP_RXSTBC_1 |
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index 720c64c..5684e13 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -56,6 +56,29 @@ void ieee80211_apply_vhtcap_overrides(struct ieee80211_sub_if_data *sdata,
 	__check_vhtcap_disable(sdata, vht_cap,
 			       IEEE80211_VHT_CAP_TX_ANTENNA_PATTERN);
 
+	/* Allow disabling 160Mhz or 80+80 */
+	if (sdata->u.mgd.vht_capa_mask.vht_cap_info &
+	    cpu_to_le32(IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK)) {
+		u32 cap, n;
+
+		n = le32_to_cpu(sdata->u.mgd.vht_capa.vht_cap_info) &
+			IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK;
+		n >>= IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_SHIFT;
+		cap = vht_cap->cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK;
+		cap >>= IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_SHIFT;
+
+		if (n < cap) {
+			vht_cap->cap &=
+				~IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK;
+			vht_cap->cap |=
+				n << IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_SHIFT;
+
+			/* Cannot do short GI 160 if we cannot do 160 or 80+80 */
+			if (n == 0)
+				vht_cap->cap &= ~IEEE80211_VHT_CAP_SHORT_GI_160;
+		}
+	}
+
 	/* Allow user to decrease AMPDU length exponent */
 	if (sdata->u.mgd.vht_capa_mask.vht_cap_info &
 	    cpu_to_le32(IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_MASK)) {
-- 
2.4.11
