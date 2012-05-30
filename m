Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55986 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237Ab2E3ADx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 20:03:53 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@qca.qualcomm.com
Subject: [PATCH] compat: fix build on kernels that already have backported codel support
Date: Wed, 30 May 2012 02:03:50 +0200
Message-Id: <1338336230-94883-1-git-send-email-nbd@openwrt.org> (sfid-20120530_020408_982542_5790FF97)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/linux/compat-3.5.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-3.5.h b/include/linux/compat-3.5.h
index c9ba6af..35fd14b 100644
--- a/include/linux/compat-3.5.h
+++ b/include/linux/compat-3.5.h
@@ -10,6 +10,8 @@
 
 #include <linux/pkt_sched.h>
 
+#ifndef TCA_CODEL_MAX
+
 /*
  * This backports:
  *
@@ -107,6 +109,7 @@ struct tc_fq_codel_xstats {
 	};
 };
 
+#endif /* TCA_CODEL_MAX */
 
 /* Backports tty_lock: Localise the lock */
 #define tty_lock(__tty) tty_lock()
-- 
1.7.3.2

