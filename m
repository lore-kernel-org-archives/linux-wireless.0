Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:58928 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbZC0Hmz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 03:42:55 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 27 Mar 2009 00:42:54 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: Don't access managed mode bits in non-managed mode
Date: Fri, 27 Mar 2009 13:08:45 +0530
Message-ID: <1238139525-8064-1-git-send-email-vasanth@atheros.com> (sfid-20090327_084258_988267_29796603)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a stupid bug introduced in 25f85c31d4f..

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 net/mac80211/wext.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index deb4ece..8a2d5b1 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -650,7 +650,7 @@ static int ieee80211_ioctl_siwencode(struct net_device *dev,
 		!sdata->default_key,
 		keybuf, erq->length);
 
-	if (!ret) {
+	if (!ret && sdata->vif.type == NL80211_IFTYPE_STATION) {
 		if (remove)
 			sdata->u.mgd.flags &= ~IEEE80211_STA_TKIP_WEP_USED;
 		else
-- 
1.5.5.1

