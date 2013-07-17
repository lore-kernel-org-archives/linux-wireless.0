Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:44059 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab3GQCXC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 22:23:02 -0400
Received: by mail-pa0-f45.google.com with SMTP id bi5so1420970pad.4
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jul 2013 19:23:01 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 50/53] wireless-regdb: enable VHT80 when world roaming
Date: Tue, 16 Jul 2013 19:18:39 -0700
Message-Id: <1374027522-18488-51-git-send-email-mcgrof@do-not-panic.com> (sfid-20130717_042306_907854_05DDE315)
In-Reply-To: <1374027522-18488-1-git-send-email-mcgrof@do-not-panic.com>
References: <1374027522-18488-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

For VHT, the wider bandwidths (up to 160 MHz) need
to be allowed. Since world roaming only covers the
case of connecting to an AP, it can be opened up
there, we will rely on the AP to know the local
regulations.

Based on a patch by Johannes Berg for upstream Linux.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/db.txt b/db.txt
index 0a4b56f..c6def1c 100644
--- a/db.txt
+++ b/db.txt
@@ -6,10 +6,10 @@ country 00:
 	# Channel 14. Only JP enables this and for 802.11b only
 	(2474 - 2494 @ 20), (3, 20), PASSIVE-SCAN, NO-IBSS, NO-OFDM
 	# Channel 36 - 48
-	(5170 - 5250 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS
+	(5170 - 5250 @ 80), (3, 20), PASSIVE-SCAN, NO-IBSS
 	# NB: 5260 MHz - 5700 MHz requies DFS
 	# Channel 149 - 165
-	(5735 - 5835 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS
+	(5735 - 5835 @ 80), (3, 20), PASSIVE-SCAN, NO-IBSS
 
 
 country AD:
-- 
1.7.10.4

