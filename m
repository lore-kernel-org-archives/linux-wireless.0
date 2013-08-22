Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:41537 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab3HVNxg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Aug 2013 09:53:36 -0400
Received: by mail-oa0-f46.google.com with SMTP id j10so3401032oah.5
        for <linux-wireless@vger.kernel.org>; Thu, 22 Aug 2013 06:53:35 -0700 (PDT)
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: ignore obviously bogus ECSAs in probe response frames
Date: Thu, 22 Aug 2013 08:53:33 -0500
Message-Id: <1377179613-26591-1-git-send-email-seth.forshee@canonical.com> (sfid-20130822_155339_483780_E02FA567)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The Netgear WNDAP360 sends invalid ECSA IEs in probe response
frames which have the operating class and channel number fields
set to 0, even when no channel switch is pending. mac80211
responds to invalid ECSAs by disconnecting. The result is that
every scan when associated to one of these APs triggers a
disconnect.

Since these ECSAs are obviously bogus, ignore them in probe
response and beacon frames. Do not disconnect.

Cc: <stable@vger.kernel.org> # 3.10+
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 net/mac80211/mlme.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index cc9e02d..f921b67 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1054,6 +1054,13 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		if (!ieee80211_operating_class_to_band(
 				elems->ext_chansw_ie->new_operating_class,
 				&new_band)) {
+			/*
+			 * Some APs send invalid ECSA IEs in probe response
+			 * frames, so check for these and ignore them.
+			 */
+			if (beacon && elems->ext_chansw_ie->new_ch_num == 0 &&
+			    elems->ext_chansw_ie->new_operating_class == 0)
+				return;
 			sdata_info(sdata,
 				   "cannot understand ECSA IE operating class %d, disconnecting\n",
 				   elems->ext_chansw_ie->new_operating_class);
-- 
1.8.1.2

