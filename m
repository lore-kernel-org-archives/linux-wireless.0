Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:38448 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab3JURO7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 13:14:59 -0400
Received: by mail-we0-f177.google.com with SMTP id x55so6833691wes.36
        for <linux-wireless@vger.kernel.org>; Mon, 21 Oct 2013 10:14:58 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, janusz.dziedzic@tieto.com,
	smihir@qti.qualcomm.com, tushnimb@qca.qualcomm.com,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 2/5] ath: clean up ath_reg_apply_active_scan_flags()
Date: Mon, 21 Oct 2013 19:14:48 +0200
Message-Id: <1382375691-25476-3-git-send-email-mcgrof@do-not-panic.com> (sfid-20131021_191502_296152_47C22768)
In-Reply-To: <1382375691-25476-1-git-send-email-mcgrof@do-not-panic.com>
References: <1382375691-25476-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The routine ath_reg_apply_active_scan_flags() can be a bit
hard to read, this cleans it up by adding helpers for the
two cases of clearing IR flags or adding them. This approach
also makes no assumptions on the index of channels 12 and 13
so it should be portable accross different drivers.

Cc: smihir@qti.qualcomm.com
Cc: tushnimb@qca.qualcomm.com
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/ath/regd.c | 101 +++++++++++++++++++++++++---------------
 1 file changed, 63 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index 1b4a532..48e2368 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -177,6 +177,47 @@ static bool ath_is_radar_freq(u16 center_freq)
 	return (center_freq >= 5260 && center_freq <= 5700);
 }
 
+static void ath_force_clear_no_ir_chan(struct wiphy *wiphy,
+				       struct ieee80211_channel *ch)
+{
+	const struct ieee80211_reg_rule *reg_rule;
+
+	reg_rule = freq_reg_info(wiphy, ch->center_freq);
+	if (IS_ERR(reg_rule))
+		return;
+
+	if (!(reg_rule->flags & NL80211_RRF_PASSIVE_SCAN))
+		if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
+			ch->flags &= ~IEEE80211_CHAN_PASSIVE_SCAN;
+}
+
+static void ath_force_clear_no_ir_freq(struct wiphy *wiphy, u16 center_freq)
+{
+	struct ieee80211_channel *ch;
+
+	ch = ieee80211_get_channel(wiphy, center_freq);
+	if (!ch)
+		return;
+
+	ath_force_clear_no_ir_chan(wiphy, ch);
+}
+
+static void ath_force_no_ir_chan(struct ieee80211_channel *ch)
+{
+	ch->flags |= IEEE80211_CHAN_PASSIVE_SCAN;
+}
+
+static void ath_force_no_ir_freq(struct wiphy *wiphy, u16 center_freq)
+{
+	struct ieee80211_channel *ch;
+
+	ch = ieee80211_get_channel(wiphy, center_freq);
+	if (!ch)
+		return;
+
+	ath_force_no_ir_chan(ch);
+}
+
 /*
  * N.B: These exception rules do not apply radar freqs.
  *
@@ -241,54 +282,38 @@ ath_reg_apply_beaconing_flags(struct wiphy *wiphy,
 
 }
 
-/* Allows active scan scan on Ch 12 and 13 */
+/**
+ * ath_reg_apply_active_scan_flags()
+ * @wiphy: the wiphy to use
+ * @initiator: the regulatory hint initiator
+ *
+ * If no country IE has been received always enable passive scan
+ * and no-ibss on these channels. This is only done for specific
+ * regulatory SKUs.
+ *
+ * If a country IE has been received check its rule for this
+ * channel first before enabling active scan. The passive scan
+ * would have been enforced by the initial processing of our
+ * custom regulatory domain.
+ */
 static void
 ath_reg_apply_active_scan_flags(struct wiphy *wiphy,
 				enum nl80211_reg_initiator initiator)
 {
 	struct ieee80211_supported_band *sband;
-	struct ieee80211_channel *ch;
-	const struct ieee80211_reg_rule *reg_rule;
 
 	sband = wiphy->bands[IEEE80211_BAND_2GHZ];
 	if (!sband)
 		return;
 
-	/*
-	 * If no country IE has been received always enable passive scan
-	 * and no-ibss on these channels. This is only done for specific
-	 * regulatory SKUs.
-	 */
-	if (initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE) {
-		ch = &sband->channels[11]; /* CH 12 */
-		ch->flags |= IEEE80211_CHAN_PASSIVE_SCAN;
-
-		ch = &sband->channels[12]; /* CH 13 */
-		ch->flags |= IEEE80211_CHAN_PASSIVE_SCAN;
-		return;
-	}
-
-	/*
-	 * If a country IE has been received check its rule for this
-	 * channel first before enabling active scan. The passive scan
-	 * would have been enforced by the initial processing of our
-	 * custom regulatory domain.
-	 */
-
-	ch = &sband->channels[11]; /* CH 12 */
-	reg_rule = freq_reg_info(wiphy, ch->center_freq);
-	if (!IS_ERR(reg_rule)) {
-		if (!(reg_rule->flags & NL80211_RRF_PASSIVE_SCAN))
-			if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
-				ch->flags &= ~IEEE80211_CHAN_PASSIVE_SCAN;
-	}
-
-	ch = &sband->channels[12]; /* CH 13 */
-	reg_rule = freq_reg_info(wiphy, ch->center_freq);
-	if (!IS_ERR(reg_rule)) {
-		if (!(reg_rule->flags & NL80211_RRF_PASSIVE_SCAN))
-			if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
-				ch->flags &= ~IEEE80211_CHAN_PASSIVE_SCAN;
+	switch(initiator) {
+	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
+		ath_force_clear_no_ir_freq(wiphy, 2467);
+		ath_force_clear_no_ir_freq(wiphy, 2472);
+		break;
+	default:
+		ath_force_no_ir_freq(wiphy, 2467);
+		ath_force_no_ir_freq(wiphy, 2472);
 	}
 }
 
-- 
1.8.4.rc3

