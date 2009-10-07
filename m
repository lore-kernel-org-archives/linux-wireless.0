Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f217.google.com ([209.85.219.217]:62872 "EHLO
	mail-ew0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbZJGDkL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 23:40:11 -0400
Received: by ewy17 with SMTP id 17so193511ewy.39
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2009 20:39:33 -0700 (PDT)
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Cc: Hin-Tak Leung <HinTak.Leung@gmail.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>
Subject: [PATCH] compat-2.6: adding ethtool.h to compat-2.6.31.h
Date: Wed,  7 Oct 2009 04:39:22 +0100
Message-Id: <1254886762-17211-1-git-send-email-HinTak.Leung@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Between 2.6.30 and 2.6.31, linux/netdevice.h started
to include linux/ethtool.h (commit b1b67dd45a6b629eb41553856805aaa1614fbb83,
"net: factor out ethtool invocation of vlan/macvlan drivers"),
and commit 7508e486965b0af13984bc6d9da62a8d8f0dc5f9,
"cfg80211: add firmware and hardware version to wiphy", introduces
dependency of ETHTOOL_BUSINFO_LEN from linux/ethtool.h
to net/cfg80211.h .

Signed-off-by: Hin-Tak Leung <htl10@users.sourceforge.net>
---
 compat/compat-2.6.31.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/compat/compat-2.6.31.h b/compat/compat-2.6.31.h
index 154209c..e46334a 100644
--- a/compat/compat-2.6.31.h
+++ b/compat/compat-2.6.31.h
@@ -12,6 +12,7 @@
 #include <linux/interrupt.h>
 #include <net/dst.h>
 #include <net/genetlink.h>
+#include <linux/ethtool.h>
 
 /*
  * These macros allow us to backport rfkill without any
-- 
1.6.5.rc2

