Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41901 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699AbZJ0Pxn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2009 11:53:43 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Michael Green <Michael.Green@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	David Quan <David.Quan@atheros.com>
Subject: [PATCH] wireless-regdb: update US rules for 5600 MHz - 5650 MHz
Date: Tue, 27 Oct 2009 11:53:47 -0400
Message-Id: <1256658827-25940-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The FCC is trying to assist airports that use Terminal Doppler
Weather Radar (TDWR) systems in avoiding interference with
some outdoor wireless systems operating in the 5.4 GHz
(5470 MHz - 5725 MHz) band. One of the things they have decided
on is to disallow operation on the 5600 MHz - 5650 MHz frequency
range inclusive. What this means in practice is 5 GHz 802.11
devices programmed to operate in the US will have these
channels now disabled:

 * 5600 MHz [120] (disabled)
 * 5620 MHz [124] (disabled)
 * 5640 MHz [128] (disabled)
 * 5660 MHz [132] (disabled)

This is documented on the FCC Knowledge based Publication
Number: 443999 [1]

[1] https://fjallfoss.fcc.gov/oetcf/kdb/forms/FTSSearchResultPage.cfm?switch=P&id=41732

Cc: Michael Green <Michael.Green@atheros.com>
Cc: Senthil Balasubramanian <senthilkumar@atheros.com>
Cc: David Quan <David.Quan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 db.txt |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/db.txt b/db.txt
index 84be443..c8b1ef0 100644
--- a/db.txt
+++ b/db.txt
@@ -562,7 +562,8 @@ country US:
 	(2402 - 2472 @ 40), (3, 27)
 	(5170 - 5250 @ 40), (3, 17)
 	(5250 - 5330 @ 40), (3, 20), DFS
-	(5490 - 5710 @ 40), (3, 20), DFS
+	(5490 - 5600 @ 40), (3, 20), DFS
+	(5651 - 5710 @ 40), (3, 20), DFS
 	(5735 - 5835 @ 40), (3, 30)
 
 country UY:
-- 
1.6.0.4

