Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:61049 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249Ab3J1CTz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Oct 2013 22:19:55 -0400
Received: by mail-we0-f180.google.com with SMTP id q59so5870032wes.25
        for <linux-wireless@vger.kernel.org>; Sun, 27 Oct 2013 19:19:54 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linux-wireless@vger.kernel.org
Cc: wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 2/2] cfg80211: fix parsing when db.txt ends on a rule
Date: Mon, 28 Oct 2013 03:19:46 +0100
Message-Id: <1382926786-7904-3-git-send-email-mcgrof@do-not-panic.com> (sfid-20131028_031959_988276_F7574EF7)
In-Reply-To: <1382926786-7904-1-git-send-email-mcgrof@do-not-panic.com>
References: <1382926786-7904-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If genregdb.awk assumes the file will end with an
extra empty line or a comment line. This is could
not be true so just address this.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/genregdb.awk | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/genregdb.awk b/net/wireless/genregdb.awk
index 95baf61..13b982d 100755
--- a/net/wireless/genregdb.awk
+++ b/net/wireless/genregdb.awk
@@ -140,6 +140,8 @@ active && /^[ \t]*$/ {
 }
 
 END {
+	if (active)
+		print_tail_country()
 	print regdb "};"
 	print ""
 	print "int reg_regdb_size = ARRAY_SIZE(reg_regdb);"
-- 
1.8.4.rc3

