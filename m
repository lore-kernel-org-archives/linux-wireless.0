Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:25213 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbYLWMzQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 07:55:16 -0500
Received: by rv-out-0506.google.com with SMTP id k40so2358283rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2008 04:55:15 -0800 (PST)
Date: Tue, 23 Dec 2008 18:28:34 -0800
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: A couple of fixes to dynamic power save.
Message-ID: <20081224022834.GB5225@myhost.users.atheros.com> (sfid-20081223_135521_844993_73842A99)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

a) hw_config() should not be called from siwpower() for the drivers which do not support
   dynamic powersave.
b) IEEE80211_HW_NO_STACK_DYNAMIC_PS needs to be verified in set_associated() also before
   enabling the power save timers.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 net/mac80211/mlme.c |    3 ++-
 net/mac80211/wext.c |    9 +++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c75d0ea..b23e62b 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -746,7 +746,8 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 	bss_info_changed |= BSS_CHANGED_BASIC_RATES;
 	ieee80211_bss_info_change_notify(sdata, bss_info_changed);
 
-	if (local->powersave) {
+	if (local->powersave &&
+			!(local->hw.flags & IEEE80211_HW_NO_STACK_DYNAMIC_PS)) {
 		if (local->dynamic_ps_timeout > 0)
 			mod_timer(&local->dynamic_ps_timer, jiffies +
 				  msecs_to_jiffies(local->dynamic_ps_timeout));
diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index 7162d58..673c5d7 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -865,9 +865,9 @@ set:
 	local->powersave = ps;
 	local->dynamic_ps_timeout = timeout;
 
-	if (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED) {
-		if (!(local->hw.flags & IEEE80211_HW_NO_STACK_DYNAMIC_PS) &&
-		    local->dynamic_ps_timeout > 0)
+	if (!(local->hw.flags & IEEE80211_HW_NO_STACK_DYNAMIC_PS) &&
+			(sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED)) {
+		if (local->dynamic_ps_timeout > 0)
 			mod_timer(&local->dynamic_ps_timer, jiffies +
 				  msecs_to_jiffies(local->dynamic_ps_timeout));
 		else {
@@ -875,8 +875,9 @@ set:
 				conf->flags |= IEEE80211_CONF_PS;
 			else
 				conf->flags &= ~IEEE80211_CONF_PS;
+			ret = ieee80211_hw_config(local,
+					IEEE80211_CONF_CHANGE_PS);
 		}
-		ret = ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 	}
 
 	return ret;
-- 
1.6.0.1

