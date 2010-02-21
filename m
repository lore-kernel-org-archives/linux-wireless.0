Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51074 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377Ab0BUO2F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Feb 2010 09:28:05 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat-wireless: Fix refresh script if no patches are available
Date: Sun, 21 Feb 2010 15:27:50 +0100
Message-Id: <1266762470-6275-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 scripts/admin-update.sh |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index e7f9a1c..c75af30 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -247,6 +247,10 @@ patchRefresh() {
 	mv -u $1/* patches.orig/
 
 	for i in patches.orig/*.patch; do
+		if [ ! -f "$i" ]; then
+			echo -e "${RED}No patches found in $1${NORMAL}"
+			break;
+		fi
 		echo -e "${GREEN}Refresh backport patch${NORMAL}: ${BLUE}$i${NORMAL}"
 		quilt import $i
 		quilt push -f
-- 
1.6.3.3

