Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34915 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084Ab2BYETl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 23:19:41 -0500
Received: by mail-pz0-f46.google.com with SMTP id d14so3190091dae.19
        for <linux-wireless@vger.kernel.org>; Fri, 24 Feb 2012 20:19:41 -0800 (PST)
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: hauke@hauke-m.de, nbd@nbd.name, linville@tuxdriver.com,
	"Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [PATCH 2/4] compat: clean ckmake log of color output
Date: Fri, 24 Feb 2012 20:19:27 -0800
Message-Id: <1330143569-30296-3-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20120225_051944_418405_F1D31E43)
In-Reply-To: <1330143569-30296-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1330143569-30296-1-git-send-email-rodrigue@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@frijolero.org>

Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---
 bin/ckmake          |    3 +++
 scripts/skip-colors |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)
 create mode 100755 scripts/skip-colors

diff --git a/bin/ckmake b/bin/ckmake
index 4d45fb9..ccb291b 100755
--- a/bin/ckmake
+++ b/bin/ckmake
@@ -63,3 +63,6 @@ for i in $KLIBS; do
 
 	nice make clean KLIB=$DIR KLIB_BUILD=$DIR 2>&1 >> $LOG
 done
+
+cat $LOG | ./scripts/skip-colors > $LOG.tmp
+mv $LOG.tmp $LOG
diff --git a/scripts/skip-colors b/scripts/skip-colors
new file mode 100755
index 0000000..121626f
--- /dev/null
+++ b/scripts/skip-colors
@@ -0,0 +1,2 @@
+#!/bin/bash
+perl -pe 's|(\e)\[(\d+)(;*)(\d*)(\w)||g'
-- 
1.7.4.15.g7811d

