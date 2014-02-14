Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:52307 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbaBNHyY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Feb 2014 02:54:24 -0500
Received: by mail-ee0-f54.google.com with SMTP id e53so5489921eek.27
        for <linux-wireless@vger.kernel.org>; Thu, 13 Feb 2014 23:54:20 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mcgrof@do-not-panic.com,
	linville@tuxdriver.com, Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 2/2] cfg80211: regulatory, allow user to set world regdomain
Date: Fri, 14 Feb 2014 08:54:01 +0100
Message-Id: <1392364441-4640-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140214_085427_581762_64E92064)
In-Reply-To: <1392364441-4640-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1392364441-4640-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow to set world regulatory domain in case of user
request (iw reg set 00).

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/wireless/reg.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index c4c3af1..9e2450b 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2373,9 +2373,6 @@ static int reg_set_rd_user(const struct ieee80211_regdomain *rd,
 {
 	const struct ieee80211_regdomain *intersected_rd = NULL;
 
-	if (is_world_regdom(rd->alpha2))
-		return -EINVAL;
-
 	if (!regdom_changes(rd->alpha2))
 		return -EALREADY;
 
-- 
1.7.9.5

