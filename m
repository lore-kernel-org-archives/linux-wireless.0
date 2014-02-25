Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:47890 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaBYHVi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 02:21:38 -0500
Received: by mail-ee0-f45.google.com with SMTP id d17so140115eek.4
        for <linux-wireless@vger.kernel.org>; Mon, 24 Feb 2014 23:21:36 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	mcgrof@do-not-panic.com, linville@tuxdriver.com,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] wireless-regdb: add AUTO-BW rule flag
Date: Tue, 25 Feb 2014 08:21:18 +0100
Message-Id: <1393312878-9471-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140225_082141_134948_FA9060CC)
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

