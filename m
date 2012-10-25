Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:60827 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab2JYGRF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 02:17:05 -0400
Received: by mail-we0-f174.google.com with SMTP id t9so669687wey.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2012 23:17:04 -0700 (PDT)
From: Rami Rosen <ramirose@gmail.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	Rami Rosen <ramirose@gmail.com>
Subject: [PATCH] mac80211: remove duplicate check in ieee80211_rx_mgmt_beacon().
Date: Thu, 25 Oct 2012 10:16:23 +0200
Message-Id: <1351152983-13871-1-git-send-email-ramirose@gmail.com> (sfid-20121025_081711_207632_E7B9BE18)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes a duplicate identical check in ieee80211_rx_mgmt_beacon(), mlme.c.
There is no need to make again the same check for IEEE80211_HW_PS_NULLFUNC_STACK
flag. It should be done in the same block.

Signed-off-by: Rami Rosen <ramirose@gmail.com>
---
 net/mac80211/mlme.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 861e1c4..8898708 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2564,11 +2564,9 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 					  len - baselen, &elems,
 					  care_about_ies, ncrc);
 
-	if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)
+	if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) {
 		directed_tim = ieee80211_check_tim(elems.tim, elems.tim_len,
 						   ifmgd->aid);
-
-	if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) {
 		if (directed_tim) {
 			if (local->hw.conf.dynamic_ps_timeout > 0) {
 				if (local->hw.conf.flags & IEEE80211_CONF_PS) {
-- 
1.7.11.4

