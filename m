Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:40787 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbaEZMcQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 08:32:16 -0400
Received: by mail-we0-f172.google.com with SMTP id k48so8112393wev.31
        for <linux-wireless@vger.kernel.org>; Mon, 26 May 2014 05:32:15 -0700 (PDT)
From: chaitanya.mgit@gmail.com
To: linville@tuxdriver.com, mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org,
	Chaitanya T K <chaitanya.mgit@gmail.com>
Subject: [PATCH V2] regdb: Generalize the mW to dBm power conversion
Date: Mon, 26 May 2014 18:01:44 +0530
Message-Id: <1401107504-11385-1-git-send-email-chaitanya.mgit@gmail.com> (sfid-20140526_143219_846087_559DD3B4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Generalize the power conversion from mW to dBm 
using log. This should fix the below compilation
error for country NO which adds a new power value
2000mW which is not handled earlier.

 CC [M]  net/wireless/wext-sme.o
 CC [M]  net/wireless/regdb.o
net/wireless/regdb.c:1130:1: error: Unknown undeclared here (not in
a function)
net/wireless/regdb.c:1130:9: error: expected } before power
make[2]: *** [net/wireless/regdb.o] Error 1
make[1]: *** [net/wireless] Error 2
make: *** [net] Error 2

Reported-By:  John Walker <john@x109.net>
Signed-off-by: Chaitanya T K <chaitanya.mgit@gmail.com>

---
 net/wireless/genregdb.awk |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/net/wireless/genregdb.awk b/net/wireless/genregdb.awk
index 4119833..949ee38 100644
--- a/net/wireless/genregdb.awk
+++ b/net/wireless/genregdb.awk
@@ -68,17 +68,7 @@ function parse_reg_rule()
 	sub(/,/, "", units)
 	dfs_cac = $9
 	if (units == "mW") {
-		if (power == 100) {
-			power = 20
-		} else if (power == 200) {
-			power = 23
-		} else if (power == 500) {
-			power = 27
-		} else if (power == 1000) {
-			power = 30
-		} else {
-			print "Unknown power value in database!"
-		}
+		power = 10 * (log(power)/log(10))
 	} else {
 		dfs_cac = $8
 	}
