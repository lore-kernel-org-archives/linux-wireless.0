Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47122 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758300AbZJLVUo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 17:20:44 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 7/9] [compat-2.6] b44 fix
Date: Mon, 12 Oct 2009 23:19:16 +0200
Message-Id: <1255382358-20760-9-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1255382358-20760-1-git-send-email-hauke@hauke-m.de>
References: <1255382358-20760-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

encapsulate $ in bash script

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 scripts/admin-update.sh |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 84f58a4..f85dacf 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -149,7 +149,7 @@ done
 # b44 is dependent on ssb, so its has to be rebuilt as well.
 DIR="drivers/net"
 cp $GIT_TREE/$DIR/b44.[ch] $DIR
-echo "obj-$(CONFIG_B44) += b44.o" > $DIR/Makefile
+echo "obj-\$(CONFIG_B44) += b44.o" > $DIR/Makefile
 
 # Misc
 mkdir -p drivers/misc/eeprom/
-- 
1.6.2.1

