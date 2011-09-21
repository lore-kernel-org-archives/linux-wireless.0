Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33640 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582Ab1IUREc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 13:04:32 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat: add lower_32_bits
Date: Wed, 21 Sep 2011 19:04:24 +0200
Message-Id: <1316624664-7913-2-git-send-email-hauke@hauke-m.de> (sfid-20110921_190436_723281_F1317A51)
In-Reply-To: <1316624664-7913-1-git-send-email-hauke@hauke-m.de>
References: <1316624664-7913-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.27.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.27.h b/include/linux/compat-2.6.27.h
index ed2035c..22fadcd 100644
--- a/include/linux/compat-2.6.27.h
+++ b/include/linux/compat-2.6.27.h
@@ -250,6 +250,12 @@ static inline __u32 ethtool_cmd_speed(const struct ethtool_cmd *ep)
 	return ep->speed;
 }
 
+/**
+ * lower_32_bits - return bits 0-31 of a number
+ * @n: the number we're accessing
+ */
+#define lower_32_bits(n) ((u32)(n))
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,27)) */
 
 #endif /* LINUX_26_27_COMPAT_H */
-- 
1.7.4.1

