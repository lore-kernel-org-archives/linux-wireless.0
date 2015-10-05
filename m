Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:44550 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbbJEQPV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 12:15:21 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: seth.forshee@canonical.com
Cc: Chen-Yu Tsai <wens@csie.org>, wireless-regdb@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH v4 2/5] wireless-regdb: Update regulatory rule boundary frequencies for Taiwan (TW)
Date: Tue,  6 Oct 2015 00:14:55 +0800
Message-Id: <1444061698-16384-3-git-send-email-wens@csie.org> (sfid-20151005_181527_523669_B18E265C)
In-Reply-To: <1444061698-16384-1-git-send-email-wens@csie.org>
References: <1444061698-16384-1-git-send-email-wens@csie.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Taiwan's frequency allocation rules [1] list the following frequency
ranges available for low power RF devices:

  - 2400 ~ 2483.5 MHz
  - 5150 ~ 5250 MHz
  - 5250 ~ 5350 MHz
  - 5470 ~ 5725 MHz
  - 5725 ~ 5850 MHz

Update the rules to match. Since 5250 ~ 5350 MHz is wide enough for
VHT80, and there are no regulations against it, enable it as well.

[1] http://www.motc.gov.tw/websitedowndoc?file=post/201411171137330.doc&filedisplay=Table+of+radio+frequency+allocation.doc
[2] http://www.ncc.gov.tw/english/show_file.aspx?table_name=news&file_sn=681

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 db.txt | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/db.txt b/db.txt
index e081634..f6607bc 100644
--- a/db.txt
+++ b/db.txt
@@ -1126,10 +1126,10 @@ country TT: DFS-FCC
 #   http://www.ncc.gov.tw/english/show_file.aspx?table_name=news&file_sn=681
 #   (section 3.10.1, 4.7)
 country TW: DFS-JP
-	(2402 - 2472 @ 40), (30)
-	(5270 - 5330 @ 40), (17), DFS
+	(2400 - 2483.5 @ 40), (30)
+	(5250 - 5350 @ 80), (17), DFS
 	(5470 - 5725 @ 160), (23), DFS
-	(5735 - 5835 @ 80), (30)
+	(5725 - 5850 @ 80), (30)
  
 country TZ:
 	(2402 - 2482 @ 40), (20)
-- 
2.5.3

