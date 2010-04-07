Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:65104 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424Ab0DGFbJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Apr 2010 01:31:09 -0400
Subject: [PATCH 4/4] compat-wireless: find the actual remote URL
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
From: Pavel Roskin <proski@gnu.org>
Date: Wed, 07 Apr 2010 01:31:08 -0400
Message-ID: <20100407053108.23575.92800.stgit@mj.roinet.com>
In-Reply-To: <20100407053051.23575.94594.stgit@mj.roinet.com>
References: <20100407053051.23575.94594.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't assume the remote to be called "origin".  Instead, find the
current branch first, defaulting to "master".  Then find the
corresponding remote, defaulting to "origin".  Then find the remote URL,
defaulting to "unknown".  Reuse the remote URL for TREE_NAME.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 scripts/admin-update.sh |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index af4479a..5d8068d 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -295,15 +295,20 @@ done
 DIR="$PWD"
 cd $GIT_TREE
 GIT_DESCRIBE=$(git describe)
+GIT_BRANCH=$(git branch --no-color |sed -n 's/^\* //p')
+GIT_BRANCH=${GIT_BRANCH-master}
+GIT_REMOTE=$(git config branch.${GIT_BRANCH}.remote)
+GIT_REMOTE=${GIT_REMOTE-origin}
+GIT_REMOTE_URL=$(git config remote.${GIT_REMOTE}.url)
+GIT_REMOTE_URL=${GIT_REMOTE_URL-unknown}
 echo -e "${GREEN}Updated${NORMAL} from local tree: ${BLUE}${GIT_TREE}${NORMAL}"
-echo -e "Origin remote URL: ${CYAN}$(git config remote.origin.url)${NORMAL}"
+echo -e "Origin remote URL: ${CYAN}${GIT_REMOTE_URL}${NORMAL}"
 cd $DIR
 if [ -d ./.git ]; then
 	git describe > compat-release
 
 	cd $GIT_TREE
-	TREE_NAME=$(git config remote.origin.url)
-	TREE_NAME=${TREE_NAME##*/}
+	TREE_NAME=${GIT_REMOTE_URL##*/}
 
 	echo $TREE_NAME > $DIR/git-describe
 	echo $GIT_DESCRIBE >> $DIR/git-describe
