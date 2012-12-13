Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44987 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231Ab2LMA4e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 19:56:34 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] mac80211: Allow disabling SGI-20.
Date: Wed, 12 Dec 2012 16:56:20 -0800
Message-Id: <1355360180-19295-1-git-send-email-greearb@candelatech.com> (sfid-20121213_015637_703359_E9A35183)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This allows user-space (wpa_supplicant) to disable
short guard interval (SGI) for 20Mhz.  The SGI-40
disable option is already handled.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/mac80211/ht.c   |    3 +++
 net/mac80211/main.c |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index a71d891..8a6d68f 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -62,6 +62,9 @@ void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
 	__check_htcap_disable(sdata, ht_cap, IEEE80211_HT_CAP_SUP_WIDTH_20_40);
 	__check_htcap_disable(sdata, ht_cap, IEEE80211_HT_CAP_SGI_40);
 
+	/* Allow user to disable SGI-20 (SGI-40 is handled above) */
+	__check_htcap_disable(sdata, ht_cap, IEEE80211_HT_CAP_SGI_20);
+
 	/* Allow user to disable the max-AMSDU bit. */
 	__check_htcap_disable(sdata, ht_cap, IEEE80211_HT_CAP_MAX_AMSDU);
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 1b087ff..0c0d4ca 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -537,6 +537,7 @@ static const struct ieee80211_ht_cap mac80211_ht_capa_mod_mask = {
 
 	.cap_info = cpu_to_le16(IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
 				IEEE80211_HT_CAP_MAX_AMSDU |
+				IEEE80211_HT_CAP_SGI_20 |
 				IEEE80211_HT_CAP_SGI_40),
 	.mcs = {
 		.rx_mask = { 0xff, 0xff, 0xff, 0xff, 0xff,
-- 
1.7.3.4

