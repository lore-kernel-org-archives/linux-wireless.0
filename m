Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:51524 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933393Ab3GDBIW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 21:08:22 -0400
Received: by mail-pd0-f178.google.com with SMTP id w11so581095pde.23
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jul 2013 18:08:22 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 47/53] wireless-regdb: enable HT40 in RU - Russian Federation
Date: Wed,  3 Jul 2013 18:04:43 -0700
Message-Id: <1372899889-19183-48-git-send-email-mcgrof@do-not-panic.com> (sfid-20130704_032041_567701_249F3629)
In-Reply-To: <1372899889-19183-1-git-send-email-mcgrof@do-not-panic.com>
References: <1372899889-19183-1-git-send-email-mcgrof@do-not-panic.com>
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

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/db.txt b/db.txt
index aa41626..330ccb2 100644
--- a/db.txt
+++ b/db.txt
@@ -672,7 +672,9 @@ country RS:
 
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

