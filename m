Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:53591 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab0CUCov (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Mar 2010 22:44:51 -0400
Received: by bwz1 with SMTP id 1so984390bwz.21
        for <linux-wireless@vger.kernel.org>; Sat, 20 Mar 2010 19:44:48 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] minstrel_ht: fix BUG_ON(rate[0]->idx < 0)
Date: Sun, 21 Mar 2010 03:44:44 +0100
Cc: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201003210344.44985.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a panic which can be triggered by an
out-of-bound array access.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
static u8 sample_table[SAMPLE_COLUMNS][MCS_GROUP_RATES];
---
--- a/net/mac80211/rc80211_minstrel_ht.c.orig	2010-03-21 03:30:04.000000000 +0100
+++ b/net/mac80211/rc80211_minstrel_ht.c	2010-03-21 03:30:33.000000000 +0100
@@ -318,9 +318,9 @@ minstrel_next_sample_idx(struct minstrel
 		if (!mg->supported)
 			continue;
 
-		if (++mg->index > MCS_GROUP_RATES) {
+		if (++mg->index >= MCS_GROUP_RATES) {
 			mg->index = 0;
-			if (++mg->column > ARRAY_SIZE(sample_table))
+			if (++mg->column >= ARRAY_SIZE(sample_table))
 				mg->column = 0;
 		}
 		break;
