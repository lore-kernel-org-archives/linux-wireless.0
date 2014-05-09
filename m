Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:56629 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaEIIi4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2014 04:38:56 -0400
Received: by mail-ee0-f53.google.com with SMTP id c13so2409327eek.12
        for <linux-wireless@vger.kernel.org>; Fri, 09 May 2014 01:38:55 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, mcgrof@do-not-panic.com,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] wireless-regdb: add AUTO-BW rule flag
Date: Fri,  9 May 2014 10:38:41 +0200
Message-Id: <1399624723-9167-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140509_103901_679530_56112C60)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sync with latest nl80211.h and add AUTO-BW flag.
If this flag set, maximum available bandwidth should
be calculated base on contiguous rules and wider channels
will be allowed to cross multiple contiguous/overlapping
frequency ranges.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 dbparse.py |    1 +
 1 file changed, 1 insertion(+)

diff --git a/dbparse.py b/dbparse.py
index ac7234b..b735b6a 100755
--- a/dbparse.py
+++ b/dbparse.py
@@ -16,6 +16,7 @@ flag_definitions = {
     # hole at bit 8
     # hole at bit 9. FIXME: Where is NO-HT40 defined?
     'NO-HT40':		1<<10,
+    'AUTO-BW':		1<<11,
 }
 
 dfs_regions = {
-- 
1.7.9.5

