Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:37174 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467Ab1LBLMt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 06:12:49 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@qca.qualcomm.com
Subject: [PATCH] compat: fix security_sk_clone dummy backport compile
Date: Fri,  2 Dec 2011 12:12:46 +0100
Message-Id: <1322824366-95660-1-git-send-email-nbd@openwrt.org> (sfid-20111202_121252_073429_8C6F37DC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

linux/security.h needs to be included before the dummy function overrides it,
otherwise the macro that redirects it to the compat version will apply to
the kernel function as well, causing multiple conflicting definitions

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/linux/compat-3.1.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-3.1.h b/include/linux/compat-3.1.h
index 0832183..5b00ac9 100644
--- a/include/linux/compat-3.1.h
+++ b/include/linux/compat-3.1.h
@@ -5,6 +5,8 @@
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(3,1,0))
 
+#include <linux/security.h>
+
 #define genl_dump_check_consistent(cb, user_hdr, family)
 
 #define IFF_TX_SKB_SHARING	0x10000	/* The interface supports sharing
-- 
1.7.3.2

