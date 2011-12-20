Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41156 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805Ab1LTCdt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 21:33:49 -0500
Received: by ggdk6 with SMTP id k6so4459801ggd.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Dec 2011 18:33:49 -0800 (PST)
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: mcgrof@frijolero.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>, greg@kroah.com,
	kvalo@qca.qualcomm.com, linville@tuxdriver.com,
	senthilb@qca.qualcomm.com, johannes@sipsolutions.net
Subject: [PATCH] compat-wireless: use linux-stable instead of linux-2.6-allstable
Date: Mon, 19 Dec 2011 18:33:42 -0800
Message-Id: <1324348422-25090-1-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20111220_033353_228487_67ECDAAC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

I used to use hpa's linux-2.6-allstable.git tree to make
stable releases of compat-wireless. This allowed me to
make updates to the stable releases whenever a 2.6.x.y
extraversion got out -- but also to make updates whenever
Linus updated his own tree so I can make RC releases
based on the latest RC release. Greg has taken over of
that tree and its now called linux-stable.git. What I am
seeing though is that the linux-stable git tree now seems
to not update as often to Linus' tree. This is fine as all
I have to do is add Linus' tree as a remote and fetch
those objects and then reset the tree to say, v3.2-rc6
and that'll get what Linus' tree looks like today.

This patch just changes the path where we pick up stable
releases from but also documents this change in case
anyone that wants to make stable release must also add
Linus' tree as a remote and fetch those objects.

Cc: greg@kroah.com
CC: kvalo@qca.qualcomm.com
Cc: linville@tuxdriver.com
Cc: senthilb@qca.qualcomm.com
Cc: johannes@sipsolutions.net
Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 scripts/gen-stable-release.sh |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/scripts/gen-stable-release.sh b/scripts/gen-stable-release.sh
index d01cb36..a271074 100755
--- a/scripts/gen-stable-release.sh
+++ b/scripts/gen-stable-release.sh
@@ -22,7 +22,10 @@ PURPLE="\033[35m"
 CYAN="\033[36m"
 UNDERLINE="\033[02m"
 
-ALL_STABLE_TREE="linux-2.6-allstable"
+# Note that this tree may not have the latest RC stuff, so you should also add
+# Linus' tree as a remote and fetch those objects if you want to make an RC
+# release instead.
+ALL_STABLE_TREE="linux-stable"
 STAGING=/tmp/staging/compat-wireless/
 
 function usage()
-- 
1.7.4.15.g7811d

