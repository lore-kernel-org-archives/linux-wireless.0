Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:54399 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3KAODz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 10:03:55 -0400
Received: by mail-we0-f177.google.com with SMTP id x55so3977745wes.36
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 07:03:54 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 10/23] wireless-regdb: update RU's 5 GHz rules
Date: Fri,  1 Nov 2013 15:03:05 +0100
Message-Id: <1383314598-21240-11-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150809_509385_FA4E0101)
In-Reply-To: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This:

  o Splits up the first 5 GHz rules into two parts,
    one without  aDFS requirement and one with DFS
    required

  o extends the second 5 GHZ DFS frequency range by
    20 MHz and forces DFS on it

  o enables VHT80 for all 5 GHz frequency ranges

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/db.txt b/db.txt
index a1eafa4..908a369 100644
--- a/db.txt
+++ b/db.txt
@@ -684,9 +684,10 @@ country RS: DFS-ETSI
 
 country RU: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5330 @ 40), (20)
-	(5650 - 5710 @ 40), (30)
-	(5735 - 5835 @ 40), (30)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5650 - 5730 @ 80), (30), DFS
+	(5735 - 5835 @ 80), (30)
 
 country RW: DFS-FCC
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

