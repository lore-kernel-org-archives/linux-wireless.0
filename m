Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:41205 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755272Ab1HBVPG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 17:15:06 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/5] compat: add IFF_TX_SKB_SHARING
Date: Tue,  2 Aug 2011 23:14:20 +0200
Message-Id: <1312319663-21654-2-git-send-email-hauke@hauke-m.de> (sfid-20110802_231510_821558_39C3B8AC)
In-Reply-To: <1312319663-21654-1-git-send-email-hauke@hauke-m.de>
References: <1312319663-21654-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This flag should be ignored by older kernel versions.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-3.1.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-3.1.h b/include/linux/compat-3.1.h
index be68c81..f9b7e88 100644
--- a/include/linux/compat-3.1.h
+++ b/include/linux/compat-3.1.h
@@ -24,6 +24,9 @@
 
 #define genl_dump_check_consistent(cb, user_hdr, family)
 
+#define IFF_TX_SKB_SHARING	0x10000	/* The interface supports sharing
+					 * skbs on transmit */
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,1,0)) */
 
 #endif /* LINUX_3_1_COMPAT_H */
-- 
1.7.4.1

