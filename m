Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:52726 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519AbaATOZp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 09:25:45 -0500
Received: by mail-ea0-f171.google.com with SMTP id h10so3167879eak.30
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jan 2014 06:25:44 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 7/7] Revert "cfg80211: disable CSA for all drivers"
Date: Mon, 20 Jan 2014 15:21:10 +0100
Message-Id: <1390227670-19030-8-git-send-email-michal.kazior@tieto.com> (sfid-20140120_152549_942080_6E21E5C4)
In-Reply-To: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com>
References: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit dda444d52496aa8ddc501561bca580f1374a96a9.

Re-enable CSA as the locking issues have been solved.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/wireless/core.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index d89dee2..aa3def7 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -443,12 +443,6 @@ int wiphy_register(struct wiphy *wiphy)
 	/* support for 5/10 MHz is broken due to nl80211 API mess - disable */
 	wiphy->flags &= ~WIPHY_FLAG_SUPPORTS_5_10_MHZ;
 
-	/*
-	 * There are major locking problems in nl80211/mac80211 for CSA,
-	 * disable for all drivers until this has been reworked.
-	 */
-	wiphy->flags &= ~WIPHY_FLAG_HAS_CHANNEL_SWITCH;
-
 #ifdef CONFIG_PM
 	if (WARN_ON(wiphy->wowlan &&
 		    (wiphy->wowlan->flags & WIPHY_WOWLAN_GTK_REKEY_FAILURE) &&
-- 
1.8.4.rc3

