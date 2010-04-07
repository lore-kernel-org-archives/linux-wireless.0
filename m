Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:42488 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398Ab0DGWIL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Apr 2010 18:08:11 -0400
Subject: [PATCH] compat-wireless: fix fallbacks for unknown branch,
 remote or remote URL
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
From: Pavel Roskin <proski@gnu.org>
Date: Wed, 07 Apr 2010 18:08:10 -0400
Message-ID: <20100407220810.14021.54998.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use bash syntax that yields the replacement value if the variable is
either empty or unset.  The original code would only check for unset
variables, but the variable would be set even if git failed to give any
output to stdout.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 scripts/admin-update.sh |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 5d8068d..36cdfac 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -296,11 +296,11 @@ DIR="$PWD"
 cd $GIT_TREE
 GIT_DESCRIBE=$(git describe)
 GIT_BRANCH=$(git branch --no-color |sed -n 's/^\* //p')
-GIT_BRANCH=${GIT_BRANCH-master}
+GIT_BRANCH=${GIT_BRANCH:-master}
 GIT_REMOTE=$(git config branch.${GIT_BRANCH}.remote)
-GIT_REMOTE=${GIT_REMOTE-origin}
+GIT_REMOTE=${GIT_REMOTE:-origin}
 GIT_REMOTE_URL=$(git config remote.${GIT_REMOTE}.url)
-GIT_REMOTE_URL=${GIT_REMOTE_URL-unknown}
+GIT_REMOTE_URL=${GIT_REMOTE_URL:-unknown}
 echo -e "${GREEN}Updated${NORMAL} from local tree: ${BLUE}${GIT_TREE}${NORMAL}"
 echo -e "Origin remote URL: ${CYAN}${GIT_REMOTE_URL}${NORMAL}"
 cd $DIR
