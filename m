Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:35897 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751178Ab2FRMxD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 08:53:03 -0400
Received: by eaaa1 with SMTP id a1so1484100eaa.10
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jun 2012 05:53:00 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: johannes@sipsolutions.net
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	tony@atomide.com
Subject: [PATCH v2] mac80211: initialize sta pointer to avoid false-positive warning
Date: Mon, 18 Jun 2012 15:52:51 +0300
Message-Id: <1340023971-9754-1-git-send-email-coelho@ti.com> (sfid-20120618_145307_724386_DEFAA1F4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some compilers (eg. gcc 4.4.1 for ARM) report a false positive warning
in mlme.c:

net/mac80211/mlme.c: In function 'ieee80211_prep_connection':
net/mac80211/mlme.c:3035: warning: 'sta' may be used uninitialized in this function

This is a false positive because the place where 'sta' is used is
inside an if with the same condition of where it is set:

[...]
        if (!have_sta) {
                sta = sta_info_alloc(sdata, cbss->bssid, GFP_KERNEL);
                if (!sta)
                        return -ENOMEM;
        }
[...]
        if (!have_sta) {
[...]
                sta->sta.supp_rates[cbss->channel->band] = rates;
[...]

For some reason the compiler doesn't understand this and warns.

While this is not a problem in the code itself, we can avoid polluting
the build logs with false positives by setting sta to NULL on
declaration and checking for sta instead of !have_sta in the second if.

Reported-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---

In v2:

   Changed the second if to "if (sta)" to make it cleaner, as Johannes
   suggested.


 net/mac80211/mlme.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 66e4fcd..1094ada 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3032,7 +3032,7 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_bss *bss = (void *)cbss->priv;
-	struct sta_info *sta;
+	struct sta_info *sta = NULL;
 	bool have_sta = false;
 	int err;
 	int ht_cfreq;
@@ -3126,7 +3126,7 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 	local->oper_channel = cbss->channel;
 	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 
-	if (!have_sta) {
+	if (sta) {
 		u32 rates = 0, basic_rates = 0;
 		bool have_higher_than_11mbit;
 		int min_rate = INT_MAX, min_rate_index = -1;
-- 
1.7.10

