Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43610 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758192Ab0GTQpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jul 2010 12:45:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wireless: correct sparse warning in generated regdb.c
Date: Tue, 20 Jul 2010 12:30:43 -0400
Message-Id: <1279643443-14504-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CHECK   net/wireless/regdb.c
net/wireless/regdb.c:8:34: warning: symbol 'reg_regdb' was not declared.  Should it be static?
net/wireless/regdb.c:11:5: warning: symbol 'reg_regdb_size' was not declared. Should it be static?

Simply include the also generated regdb.h.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/wireless/genregdb.awk |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/wireless/genregdb.awk b/net/wireless/genregdb.awk
index 3cc9e69..53c143f 100644
--- a/net/wireless/genregdb.awk
+++ b/net/wireless/genregdb.awk
@@ -21,6 +21,7 @@ BEGIN {
 	print ""
 	print "#include <linux/nl80211.h>"
 	print "#include <net/cfg80211.h>"
+	print "#include \"regdb.h\""
 	print ""
 	regdb = "const struct ieee80211_regdomain *reg_regdb[] = {\n"
 }
-- 
1.7.1.1

