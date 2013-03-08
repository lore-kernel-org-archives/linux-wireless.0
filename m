Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:37993 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab3CHUdV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Mar 2013 15:33:21 -0500
Received: by mail-pb0-f42.google.com with SMTP id xb4so1564984pbc.15
        for <linux-wireless@vger.kernel.org>; Fri, 08 Mar 2013 12:33:20 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Michael Greem <green@qca.qualcomm.com>
Subject: [PATCH] wireless-regdb: enable HT40 in RU - Russian Federation
Date: Fri,  8 Mar 2013 12:33:12 -0800
Message-Id: <1362774792-6209-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20130308_213328_529703_60792E67)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

As per QCA the Russian Federation (RU) enables
HT40 on the 5 GHz band as follows. This has been
verified by actual product submission and product
certification.

Band [MHz]              Max BW [MHz]    Max gain        Max EIRP [dBm (mW)]
5170-5330               40              N/A             20.00 (100.00)
5650-5710               40              N/A             30.00 (1000.00)
5735.000 - 5835.000     40              N/A             30.00 (1000.00)

Prior to this we didn't have HT40 allowed on RU at all.
This patch changes this and splits the 5 GHz band into
two segments which allow two different max EIRP values.

Exact details on the 5 GHz QCA work for Russia you can
refer to this PDF:

http://lists.infradead.org/pipermail/wireless-regdb/attachments/20130125/29d3fa1f/attachment-0001.pdf

Originally submitted to the list by Michael Green.

Cc: Michael Greem <green@qca.qualcomm.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/db.txt b/db.txt
index c5861b8..2d09a3c 100644
--- a/db.txt
+++ b/db.txt
@@ -654,7 +654,9 @@ country RS:
 
 country RU:
 	(2402 - 2482 @ 40), (N/A, 20)
-	(5735 - 5835 @ 20), (N/A, 30)
+	(5170 - 5330 @ 40), (N/A, 20)
+	(5650 - 5710 @ 40), (N/A, 30)
+	(5735 - 5835 @ 40), (N/A, 30)
 
 country RW:
 	(2402 - 2482 @ 40), (N/A, 20)
-- 
1.7.10.4

