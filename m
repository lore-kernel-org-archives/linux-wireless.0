Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:59937 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386Ab2FRHDs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 03:03:48 -0400
Received: by lahg1 with SMTP id g1so4112774lah.30
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jun 2012 00:03:45 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: johannes@sipsolutions.net
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	tony@atomide.com
Subject: [PATCH] mac80211: initialize sta pointer to avoid false-positive warning
Date: Mon, 18 Jun 2012 10:03:37 +0300
Message-Id: <1340003017-5919-1-git-send-email-coelho@ti.com> (sfid-20120618_090352_300029_C37B7B57)
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
declaration.

Reported-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---

Johannes,

I think I recall this having been discussed before.  I don't
completely like the solution for this problem, the compiler should be
fixed (and possibly already has), but this gcc version for ARM is
still widely used.  And as Tony pointed to me, this false-positive is
showing up in Russels build system:

http://www.arm.linux.org.uk/developer/build/result.php?type=build&idx=1178

If you don't like this patch, feel free to drop it and we'll have to
live with the false warning (and hope that next time someone cries
wolf we still react to it ;).

Cheers,
Luca.

 net/mac80211/mlme.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 66e4fcd..1bb1b4c 100644
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
-- 
1.7.10

