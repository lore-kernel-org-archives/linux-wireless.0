Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:46337 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679AbZEHTXb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 15:23:31 -0400
From: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"Abbas, Mohamed" <mohamed.abbas@intel.com>
Date: Fri, 8 May 2009 12:23:30 -0700
Subject: RE: [PATCH] mac80211: properly track HT operation_mode
Message-ID: <E9954878DD1FB34FAE5187FB88C58A354C4BD782@orsmsx506.amr.corp.intel.com>
References: <1241810466.5233.6.camel@johannes.local>
In-Reply-To: <1241810466.5233.6.camel@johannes.local>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nice!

Wey-Yi Guy
Intel Corporation
2111 N.E. 25th Avenue  M/S JF3-308                 
Hillsboro OR 97124-5961
USA
Work Phone: 503-264-6023 (OR)
Cell Phone: 503-329-8410
Email: wey-yi.w.guy@intel.com
 

-----Original Message-----
From: Johannes Berg [mailto:johannes@sipsolutions.net] 
Sent: Friday, May 08, 2009 12:21 PM
To: John Linville
Cc: linux-wireless; Abbas, Mohamed; Guy, Wey-Yi W
Subject: [PATCH] mac80211: properly track HT operation_mode

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


