Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:41294 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbaEZHjg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 03:39:36 -0400
Received: by mail-pb0-f49.google.com with SMTP id jt11so7299622pbb.36
        for <linux-wireless@vger.kernel.org>; Mon, 26 May 2014 00:39:35 -0700 (PDT)
From: chaitanya.mgit@gmail.com
To: linville@tuxdriver.com, mcgrof@gmail.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	Chaitanya T K <chaitanya.mgit@gmail.com>
Subject: [regdb] Add support to parse 2000mW tx power
Date: Mon, 26 May 2014 13:09:22 +0530
Message-Id: <1401089962-10720-1-git-send-email-chaitanya.mgit@gmail.com> (sfid-20140526_093938_790284_7B77A8B1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 CC [M]  net/wireless/wext-sme.o
 CC [M]  net/wireless/regdb.o
net/wireless/regdb.c:1130:1: error: Unknown undeclared here (not in
a function)
net/wireless/regdb.c:1130:9: error: expected } before power
make[2]: *** [net/wireless/regdb.o] Error 1
make[1]: *** [net/wireless] Error 2
make: *** [net] Error 2

Reported-By: John Walker <john@x109.net>
Signed-off-by: Chaitanya T K <chaitanya.mgit@gmail.com>
---
 net/wireless/genregdb.awk |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/genregdb.awk b/net/wireless/genregdb.awk
index 4119833..0f2b53a 100644
--- a/net/wireless/genregdb.awk
+++ b/net/wireless/genregdb.awk
@@ -74,7 +74,7 @@ function parse_reg_rule()
 			power = 23
 		} else if (power == 500) {
 			power = 27
-		} else if (power == 1000) {
+		} else if ((power == 1000) || (power == 2000)) {
 			power = 30
 		} else {
 			print "Unknown power value in database!"
