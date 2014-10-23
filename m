Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:14989 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbaJWI7e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2014 04:59:34 -0400
Date: Thu, 23 Oct 2014 11:59:28 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] wireless-regdb: Fix world roaming 160 MHz to use AUTO-BW
Message-ID: <20141023085928.GA2716@jouni.qca.qualcomm.com> (sfid-20141023_105939_985950_F2034C79)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The cfg80211 reg.c implementation rejects rules that claim to have
maximum bandwidth that is larger than the full range. For cases that
need to merge two rules into a single one with extended maximum
bandwidth, AUTO-BW should be used instead.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 db.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/db.txt b/db.txt
index f0e4312..1e5863f 100644
--- a/db.txt
+++ b/db.txt
@@ -6,9 +6,9 @@ country 00:
 	# Channel 14. Only JP enables this and for 802.11b only
 	(2474 - 2494 @ 20), (20), NO-IR, NO-OFDM
 	# Channel 36 - 48
-	(5170 - 5250 @ 160), (20), NO-IR
+	(5170 - 5250 @ 80), (20), NO-IR, AUTO-BW
 	# Channel 52 - 64
-	(5250 - 5330 @ 160), (20), NO-IR, DFS
+	(5250 - 5330 @ 80), (20), NO-IR, DFS, AUTO-BW
 	# Channel 100 - 144
 	(5490 - 5730 @ 160), (20), NO-IR, DFS
 	# Channel 149 - 165
-- 
1.9.1


-- 
Jouni Malinen                                            PGP id EFC895FA
