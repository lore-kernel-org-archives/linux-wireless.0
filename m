Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:42656 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbaBJTQA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Feb 2014 14:16:00 -0500
Received: by mail-ee0-f45.google.com with SMTP id b15so3154321eek.32
        for <linux-wireless@vger.kernel.org>; Mon, 10 Feb 2014 11:15:58 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mcgrof@do-not-panic.com,
	linville@tuxdriver.com, Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] wireless-regdb: allow max bandwidth to be AUTO calculated
Date: Mon, 10 Feb 2014 20:15:41 +0100
Message-Id: <1392059741-2366-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140210_201604_767677_7CE42BE1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow max bandwidth to be AUTO calculated, base
on contiguous rules. This AUTO ( bw = 0) parameter will be
send to the kernel mode (cfg80211/nl80211) and next maximum
allowed bandwidth will be calculated base on contiguous rules.

Eg.

country PL: DFS-ETSI
	(2402 - 2482 @ 40), (N/A, 20)
	(5170 - 5250 @ AUTO), (N/A, 20)
	(5250 - 5330 @ AUTO), (N/A, 20), DFS
	(5490 - 5710 @ 80), (N/A, 27), DFS

This mean we will calculate maximum bw for rules where
AUTO were set, 160MHz (5330 - 5170) in example above.
So we will get:
	(5170 - 5250 @ 160), (N/A, 20)
	(5250 - 5330 @ 160), (N/A, 20), DFS

In other case:
country FR: DFS-ETSI
	(2402 - 2482 @ 40), (N/A, 20)
	(5170 - 5250 @ AUTO), (N/A, 20)
	(5250 - 5330 @ 80), (N/A, 20), DFS
	(5490 - 5710 @ 80), (N/A, 27), DFS

We will get 80MHz (5250 - 5170):
	(5170 - 5250 @ 80), (N/A, 20)
	(5250 - 5330 @ 80), (N/A, 20), DFS

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 dbparse.py |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/dbparse.py b/dbparse.py
index ac7234b..7c7bc19 100755
--- a/dbparse.py
+++ b/dbparse.py
@@ -144,7 +144,10 @@ class DBParser(object):
     def _parse_band_def(self, bname, banddef, dupwarn=True):
         try:
             freqs, bw = banddef.split('@')
-            bw = float(bw)
+            if bw == "AUTO":
+                bw = 0.0
+            else:
+                bw = float(bw)
         except ValueError:
             bw = 20.0
 
-- 
1.7.9.5

