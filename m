Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f48.google.com ([209.85.219.48]:41228 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab3LPWBK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 17:01:10 -0500
Received: by mail-oa0-f48.google.com with SMTP id l6so5687102oag.21
        for <linux-wireless@vger.kernel.org>; Mon, 16 Dec 2013 14:01:10 -0800 (PST)
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	brcm80211-dev-list@broadcom.com,
	"John W. Linville" <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Arend van Spriel <arend@broadcom.com>,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [RFC PATCH 5/8] mac80211: Don't start dynamic PS timer when leaving off-channel if still scanning
Date: Mon, 16 Dec 2013 16:00:57 -0600
Message-Id: <1387231260-2849-6-git-send-email-seth.forshee@canonical.com> (sfid-20131216_230119_345010_8E914ADB)
In-Reply-To: <1387231260-2849-1-git-send-email-seth.forshee@canonical.com>
References: <1387231260-2849-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Most of mac80211 does not update the dynamic PS timer during
scans, but ieee80211_offchannel_ps_disable() will still restart
it if a scan is in progress. It doesn't make sense to do this if
no other code is updating the timer, so update this function to
only restart the timer if not scanning.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 net/mac80211/offchannel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 5802c00..1744886 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -72,7 +72,7 @@ static void ieee80211_offchannel_ps_disable(struct ieee80211_sub_if_data *sdata)
 	ieee80211_vif_set_ps_mode(sdata, mode);
 	if (mode == IEEE80211_VIF_PS_AWAKE) {
 		ieee80211_send_nullfunc(local, sdata, 0);
-		if (sdata->vif.dynamic_ps_active)
+		if (sdata->vif.dynamic_ps_active && !local->scanning)
 			mod_timer(&ifmgd->dynamic_ps_timer, jiffies +
 				  msecs_to_jiffies(sdata->vif.dynamic_ps_timeout));
 	}
-- 
1.8.3.2

