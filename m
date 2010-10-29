Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41354 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762168Ab0J2Xfm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Oct 2010 19:35:42 -0400
Received: by bwz11 with SMTP id 11so3037821bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 29 Oct 2010 16:35:40 -0700 (PDT)
Message-Id: <e8a175c9052597a67f431531c4a529288ef980c4.1288393804.git.chunkeey@googlemail.com>
In-Reply-To: <cover.1288393804.git.chunkeey@googlemail.com>
References: <cover.1288393804.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Fri, 29 Oct 2010 23:17:38 +0200
Subject: [PATCH 3/6] carl9170: initialize HW aMPDU parameters properly
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes the initial aMPDU density and
factor settings to match those of Otus.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/mac.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/mac.c b/drivers/net/wireless/ath/carl9170/mac.c
index 2305bc2..c34eeee 100644
--- a/drivers/net/wireless/ath/carl9170/mac.c
+++ b/drivers/net/wireless/ath/carl9170/mac.c
@@ -205,8 +205,8 @@ int carl9170_init_mac(struct ar9170 *ar)
 	carl9170_regwrite(AR9170_MAC_REG_BACKOFF_PROTECT, 0x105);
 
 	/* Aggregation MAX number and timeout */
-	carl9170_regwrite(AR9170_MAC_REG_AMPDU_FACTOR, 0xa);
-	carl9170_regwrite(AR9170_MAC_REG_AMPDU_DENSITY, 0x140a00);
+	carl9170_regwrite(AR9170_MAC_REG_AMPDU_FACTOR, 0x8000a);
+	carl9170_regwrite(AR9170_MAC_REG_AMPDU_DENSITY, 0x140a07);
 
 	carl9170_regwrite(AR9170_MAC_REG_FRAMETYPE_FILTER,
 			  AR9170_MAC_FTF_DEFAULTS);
-- 
1.7.2.3

