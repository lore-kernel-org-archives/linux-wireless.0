Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:27319 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888AbZCFDtE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2009 22:49:04 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 05 Mar 2009 19:49:03 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] wireless-regdb: enable passive scanning for world regdomain on other channels
Date: Thu, 5 Mar 2009 19:48:18 -0800
Message-ID: <1236311299-30407-1-git-send-email-lrodriguez@atheros.com> (sfid-20090306_044910_500818_55DAEF8F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We allow passive scanning on other standard IEEE-802.11 channels.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

John I just put the 2 GHz stuff and 5 GHz stuff into one. I also
realized we had to separate channel 14 separately as it requires
no OFDM.

 db.txt         |   11 +++++++++++
 1 file changed, 11 insertions(+), 0 deletions(-)

diff --git a/db.txt b/db.txt
index 89a9d52..d3a05ea 100644
--- a/db.txt
+++ b/db.txt
@@ -1,5 +1,16 @@
+# This is the word regulatory domain
 country 00:
 	(2402 - 2472 @ 40), (3, 20)
+        # Channel 12 - 14. No HT40 channel fits here
+        (2457 - 2482 @ 20), (3, 20), PASSIVE-SCAN, NO-IBSS
+        # Channel 14. Only JP enables this and for 802.11b only
+        (2474 - 2494 @ 20), (3, 20), PASSIVE-SCAN, NO-IBSS, NO-OFDM
+        # Channel 36 - 48
+        (5170 - 5250 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS
+        # NB: 5260 MHz - 5700 MHz requies DFS
+        # Channel 149 - 165
+        (5735 - 5835 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS
+
 
 country AE:
 	(2402 - 2482 @ 40), (N/A, 20)
