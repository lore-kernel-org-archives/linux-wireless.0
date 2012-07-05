Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54658 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab2GEHaZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 03:30:25 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20469.16960.475409.87512@gargle.gargle.HOWL> (sfid-20120705_093032_144575_43334242)
Date: Thu, 5 Jul 2012 12:59:04 +0530
To: Luis Rodriguez <rodrigue@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] compat-wireless: Make target/compat branch check optional
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The safety check to ensure that the target kernel and the
local compat-wireless branch are the same can be adjusted a
bit to allow users to generate stable releases from a temporary
branch.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 scripts/gen-stable-release.sh | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/scripts/gen-stable-release.sh b/scripts/gen-stable-release.sh
index 6bfba03..5a7dc5f 100755
--- a/scripts/gen-stable-release.sh
+++ b/scripts/gen-stable-release.sh
@@ -145,7 +145,12 @@ if [[ $COMPAT_WIRELESS_BRANCH != $TARGET_KERNEL_RELEASE ]]; then
 	echo -e "You are on the compat-wireless ${GREEN}${COMPAT_WIRELESS_BRANCH}${NORMAL} but are "
 	echo -en "on the ${RED}${TARGET_KERNEL_RELEASE}${NORMAL} branch... "
 	echo -e "try changing to that first."
-	exit
+
+	read -p "Do you still want to continue (y/N)? "
+	if [[ "${REPLY}" != "y" ]]; then
+	    echo -e "Bailing out !"
+	    exit
+	fi
 fi
 
 
-- 
1.7.11.1

