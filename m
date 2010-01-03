Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:45527 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab0ACJUZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2010 04:20:25 -0500
From: Benoit Papillault <benoit.papillault@free.fr>
To: dsd@gentoo.org, kune@deine-taler.de
Cc: linux-wireless@vger.kernel.org, zd1211-devs@lists.sourceforge.net,
	Benoit Papillault <benoit.papillault@free.fr>
Subject: [PATCH] zd1211rw: Fix multicast filtering.
Date: Sun,  3 Jan 2010 10:20:01 +0100
Message-Id: <1262510401-22037-1-git-send-email-benoit.papillault@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If multicast parameter (as returned by zd_op_prepare_multicast) has
changed, no bit in changed_flags is set. To handle this situation, we do
not return if changed_flags is 0. If we do so, we will have some issue
with IPv6 which uses multicast for link layer address resolution.

Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
---
 drivers/net/wireless/zd1211rw/zd_mac.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 5313313..9cb6cbc 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -1005,12 +1005,13 @@ static void zd_op_configure_filter(struct ieee80211_hw *hw,
 	changed_flags &= SUPPORTED_FIF_FLAGS;
 	*new_flags &= SUPPORTED_FIF_FLAGS;
 
-	/* changed_flags is always populated but this driver
-	 * doesn't support all FIF flags so its possible we don't
-	 * need to do anything */
-	if (!changed_flags)
-		return;
-
+	/*
+	 * If multicast parameter (as returned by zd_op_prepare_multicast)
+	 * has changed, no bit in changed_flags is set. To handle this
+	 * situation, we do not return if changed_flags is 0. If we do so,
+	 * we will have some issue with IPv6 which uses multicast for link
+	 * layer address resolution.
+	 */
 	if (*new_flags & (FIF_PROMISC_IN_BSS | FIF_ALLMULTI))
 		zd_mc_add_all(&hash);
 
-- 
1.6.3.3

