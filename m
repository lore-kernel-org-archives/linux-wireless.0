Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:43006 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbZBOP10 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2009 10:27:26 -0500
Received: by nf-out-0910.google.com with SMTP id d21so173545nfb.21
        for <linux-wireless@vger.kernel.org>; Sun, 15 Feb 2009 07:27:25 -0800 (PST)
Message-ID: <4998345C.9050409@gmail.com> (sfid-20090215_162731_098155_352D308E)
Date: Sun, 15 Feb 2009 16:27:24 +0100
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: flamingice@sourmilk.net
CC: linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] p54: misplaced parentheses
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only FIF_FCSFAIL is set due to parentheses

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
// include/net/mac80211.h vi +1133
enum ieee80211_filter_flags {
        FIF_PROMISC_IN_BSS      = 1<<0,
	...
};

diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
index 34561e6..530daee 100644
--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -1932,8 +1932,8 @@ static void p54_configure_filter(struct ieee80211_hw *dev,
 	struct p54_common *priv = dev->priv;
 
 	*total_flags &= FIF_PROMISC_IN_BSS |
-			(*total_flags & FIF_PROMISC_IN_BSS) ?
-				FIF_FCSFAIL : 0;
+			(*total_flags & FIF_PROMISC_IN_BSS ?
+				FIF_FCSFAIL : 0);
 
 	priv->filter_flags = *total_flags;
 
