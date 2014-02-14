Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:57477 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbaBNIGA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Feb 2014 03:06:00 -0500
Received: by mail-ee0-f45.google.com with SMTP id b15so5488046eek.4
        for <linux-wireless@vger.kernel.org>; Fri, 14 Feb 2014 00:05:59 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mcgrof@do-not-panic.com,
	linville@tuxdriver.com, Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] wireless-regdb: set AUTO bandwidth for world regulatory
Date: Fri, 14 Feb 2014 09:05:49 +0100
Message-Id: <1392365149-4829-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140214_090611_305332_AA8D2298)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set AUTO bandwidth calculation for world regulatory
domain. This will fix CRDA veryfication issue for
world regulatory domain. This will also allow to set
world regulatory from user mode (using iw/hostapd).

Before we fail when check bandwidth for rule:
2457 - 2482 @ 40 - where (2482 - 2457) < 40

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 db.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/db.txt b/db.txt
index fcab208..1fa16fe 100644
--- a/db.txt
+++ b/db.txt
@@ -1,8 +1,8 @@
 # This is the world regulatory domain
 country 00:
-	(2402 - 2472 @ 40), (20)
+	(2402 - 2472 @ AUTO), (20)
 	# Channel 12 - 13.
-	(2457 - 2482 @ 40), (20), NO-IR
+	(2457 - 2482 @ AUTO), (20), NO-IR
 	# Channel 14. Only JP enables this and for 802.11b only
 	(2474 - 2494 @ 20), (20), NO-IR
 	# Channel 36 - 48
-- 
1.7.9.5

