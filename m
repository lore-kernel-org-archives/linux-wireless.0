Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1-g19.free.fr ([212.27.42.27]:55446 "EHLO smtp1-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbYJUUUt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 16:20:49 -0400
Message-ID: <48FE399E.6050907@free.fr> (sfid-20081021_222053_979649_39DDEB3E)
Date: Tue, 21 Oct 2008 22:20:46 +0200
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: [PATCH 4/5] crda: Updated regulatory information for France (FR)
References: <cover.1223583376.git.benoit.papillault@free.fr>,	<cover.1223583376.git.benoit.papillault@free.fr>
In-Reply-To: <cover.1223583376.git.benoit.papillault@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is for review. It might be tricky to use the INDOOR/OUTDOOR
with those definitions, but it will be another issue.


Signed-off-by: Benoit PAPILLAULT <benoit.papillault@free.fr>
---
 db.txt |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/db.txt b/db.txt
index 6a282b6..bfc91ef 100644
--- a/db.txt
+++ b/db.txt
@@ -199,12 +199,17 @@ country FI:
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
-
+# Data from http://www.arcep.fr/index.php?id=9272#12931
+# Updated 2008-10-04
+# 1W => 30dBm, 200mW => 23dBm, 100mW => 20dBm, 10mW => 10dBm
+# TPC is needed for 5250-5350 and 5470-5725, which flag to use?
 country FR:
-	(2402 - 2482 @ 40), (N/A, 20)
-	(5170 - 5250 @ 40), (N/A, 20)
-	(5250 - 5330 @ 40), (N/A, 20), DFS
-	(5490 - 5710 @ 40), (N/A, 27), DFS
+	(2400 - 2454 @ 40), (N/A, 20)
+	(2454 - 2483.5 @ 40), (N/A, 20), NO-OUTDOOR
+	(2454 - 2483.5 @ 40), (N/A, 10), NO-INDOOR
+	(5150 - 5250 @ 40), (N/A, 23), NO-OUTDOOR
+	(5250 - 5350 @ 40), (N/A, 23), NO-OUTDOOR, DFS, PASSIVE-SCAN
+	(5470 - 5725 @ 40), (N/A, 30), DFS, PASSIVE-SCAN

 country GE:
 	(2402 - 2482 @ 40), (N/A, 20)
-- 
1.5.6.5


