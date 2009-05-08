Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59550 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbZEHTVM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 15:21:12 -0400
Subject: [PATCH] mac80211: properly track HT operation_mode
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
Content-Type: text/plain
Date: Fri, 08 May 2009 21:21:06 +0200
Message-Id: <1241810466.5233.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we disassociate, we set the channel to non-HT which
obviously invalidates any ht_operation_mode setting. But
when we then associate with the next AP again, we might
still have the ht_operation_mode from the previous AP
cached and fail to configure the hardware with the new
(but unchanged) operation mode. This patch fixes it by
separately tracking whether our cache is valid.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Requires the previous patch - "mac80211: move HT operation mode BSS info"

 net/mac80211/ieee80211_i.h |    6 ++++++
 net/mac80211/mlme.c        |    7 ++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-05-08 21:07:32.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-05-08 21:09:13.000000000 +0200
@@ -427,6 +427,12 @@ struct ieee80211_sub_if_data {
 
 	int drop_unencrypted;
 
+	/*
+	 * keep track of whether the HT opmode (stored in
+	 * vif.bss_info.ht_operation_mode) is valid.
+	 */
+	bool ht_opmode_valid;
+
 	/* Fragment table for host-based reassembly */
 	struct ieee80211_fragment_entry	fragments[IEEE80211_FRAGMENT_MAX];
 	unsigned int fragment_next;
--- wireless-testing.orig/net/mac80211/mlme.c	2009-05-08 21:04:20.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-05-08 21:07:53.000000000 +0200
@@ -155,9 +155,11 @@ static u32 ieee80211_enable_ht(struct ie
 	ht_opmode = le16_to_cpu(hti->operation_mode);
 
 	/* if bss configuration changed store the new one */
-	if (sdata->vif.bss_conf.ht_operation_mode != ht_opmode) {
+	if (!sdata->ht_opmode_valid ||
+	    sdata->vif.bss_conf.ht_operation_mode != ht_opmode) {
 		changed |= BSS_CHANGED_HT;
 		sdata->vif.bss_conf.ht_operation_mode = ht_opmode;
+		sdata->ht_opmode_valid = true;
 	}
 
 	return changed;
@@ -1047,6 +1049,9 @@ static void ieee80211_set_disassoc(struc
 	/* channel(_type) changes are handled by ieee80211_hw_config */
 	local->oper_channel_type = NL80211_CHAN_NO_HT;
 
+	/* on the next assoc, re-program HT parameters */
+	sdata->ht_opmode_valid = false;
+
 	local->power_constr_level = 0;
 
 	del_timer_sync(&local->dynamic_ps_timer);


