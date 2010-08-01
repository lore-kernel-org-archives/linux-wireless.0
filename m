Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52857 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab0HAWD3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Aug 2010 18:03:29 -0400
Received: by ewy23 with SMTP id 23so1137344ewy.19
        for <linux-wireless@vger.kernel.org>; Sun, 01 Aug 2010 15:03:28 -0700 (PDT)
From: Kshitij Kulshreshtha <kkhere.geo@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org,
	Kshitij Kulshreshtha <kshitij@math.hu-berlin.de>
Subject: [PATCH 5/5] compat-wireless: copy headers in include/pcmcia from compat
Date: Mon,  2 Aug 2010 00:02:53 +0200
Message-Id: <1280700173-14690-6-git-send-email-kkhere.geo@gmail.com>
In-Reply-To: <4C55D22A.5040302@hauke-m.de>
References: <4C55D22A.5040302@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kshitij Kulshreshtha <kshitij@math.hu-berlin.de>

this is needed after the removal of pcmcia/cs_types.h in v2.6.36

Signed-off-by: Kshitij Kulshreshtha <kshitij@math.hu-berlin.de>
---
 scripts/admin-update.sh |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 4eb7c3e..8ff2ece 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -231,6 +231,7 @@ mkdir -p include/linux/ include/net/ include/linux/usb \
 	include/linux/unaligned \
 	include/linux/spi \
 	include/trace \
+	include/pcmcia \
 	net/mac80211/ net/wireless/ \
 	net/rfkill/ \
 	drivers/ssb/ \
@@ -353,6 +354,7 @@ cp -a $GIT_COMPAT_TREE/scripts/ $COMPAT/
 cp -a $GIT_COMPAT_TREE/include/linux/* include/linux/
 cp -a $GIT_COMPAT_TREE/include/net/* include/net/
 cp -a $GIT_COMPAT_TREE/include/trace/* include/trace/
+cp -a $GIT_COMPAT_TREE/include/pcmcia/* include/pcmcia/
 rm -f $COMPAT/*.mod.c
 
 # Refresh patches using quilt
-- 
1.7.1

