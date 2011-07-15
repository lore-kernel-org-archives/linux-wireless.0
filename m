Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:44062 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980Ab1GOXAv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 19:00:51 -0400
Subject: [PATCH] carl9170 firmware: install firmware without execute
 permissions
To: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
From: Pavel Roskin <proski@gnu.org>
Date: Fri, 15 Jul 2011 19:00:49 -0400
Message-ID: <20110715230049.4043.39214.stgit@mj.roinet.com> (sfid-20110716_010054_579924_88266F3D)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 autogen.sh |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/autogen.sh b/autogen.sh
index 873fb74..d5b7966 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -32,7 +32,8 @@ case "$1" in
 			tools/src/miniboot a carlfw/carl9170.fw minifw/miniboot.fw
 		fi
 
-		sudo install carlfw/carl9170.fw /lib/firmware/carl9170-$CONFIG_CARL9170FW_RELEASE_VERSION.fw
+		sudo install -m 644 carlfw/carl9170.fw \
+			/lib/firmware/carl9170-$CONFIG_CARL9170FW_RELEASE_VERSION.fw
 		echo "done."
 	;;
 
