Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:63614 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757314AbZIOCU4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 22:20:56 -0400
Received: by ewy2 with SMTP id 2so70368ewy.17
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2009 19:20:59 -0700 (PDT)
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: linux-wireless@vger.kernel.org, mcgrof@winlab.rutgers.edu
Cc: Hin-Tak Leung <HinTak.Leung@gmail.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>
Subject: [PATCH] compat-2.6: adding notes on installing to non-running kernel
Date: Tue, 15 Sep 2009 03:20:56 +0100
Message-Id: <1252981256-12371-1-git-send-email-HinTak.Leung@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

adding notes on installing to non-running kernel

Signed-off-by: Hin-Tak Leung <htl10@users.sourceforge.net>
---
 README |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/README b/README
index 7c6c2cd..380fc5a 100644
--- a/README
+++ b/README
@@ -142,6 +142,15 @@ compat-wireless-2.6 drivers for it you can use this syntax:
 
 make KLIB=/home/mcgrof/kernels/linux-2.6.23.9 KLIB_BUILD=/home/mcgrof/kernels/linux-2.6.23.9
 
+If you have a kernel installed, which is not your currently running kernel (e.g. via
+distro updates; plus its corresponding kernel-dev package), you can use this syntax:
+
+make  KLIB=/lib/modules/2.6.30.6-53.fc11.x86_64
+
+  and to install to your system's root path for the non-running kernel:
+
+make  KLIB=/lib/modules/2.6.30.6-53.fc11.x86_64 KMODPATH_ARG='INSTALL_MOD_PATH=' install
+
 Bugs
 -----
 
-- 
1.6.2.5

