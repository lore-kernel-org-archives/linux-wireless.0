Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47121 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758299AbZJLVUn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 17:20:43 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 6/9] [compat-2.6] Fix build with kernel < 2.6.27
Date: Mon, 12 Oct 2009 23:19:15 +0200
Message-Id: <1255382358-20760-8-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1255382358-20760-1-git-send-email-hauke@hauke-m.de>
References: <1255382358-20760-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iw_handler.h have changed in kernel 2.6.27.
For older kernel we need some extra backport code.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-2.6.27.h |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/compat/compat-2.6.27.h b/compat/compat-2.6.27.h
index 2543482..8cc6c22 100644
--- a/compat/compat-2.6.27.h
+++ b/compat/compat-2.6.27.h
@@ -163,6 +163,26 @@ static inline void list_splice_tail_init(struct list_head *list,
 extern unsigned int mmc_align_data_size(struct mmc_card *, unsigned int);
 extern unsigned int sdio_align_size(struct sdio_func *func, unsigned int sz);
 
+/** Include iw_handler.h before we redefine some methods **/
+#include <net/iw_handler.h>
+
+#define iwe_stream_add_value(info, event, value, ends, iwe, event_len) iwe_stream_add_value(event, value, ends, iwe, event_len)
+#define iwe_stream_add_point(info, stream, ends, iwe, extra) iwe_stream_add_point(stream, ends, iwe, extra)
+#define iwe_stream_add_event(info, stream, ends, iwe, event_len) iwe_stream_add_event(stream, ends, iwe, event_len)
+
+/* Flags available in struct iw_request_info */
+#define IW_REQUEST_FLAG_COMPAT	0x0001	/* Compat ioctl call */
+
+static inline int iwe_stream_lcp_len(struct iw_request_info *info)
+{
+#ifdef CONFIG_COMPAT
+	if (info->flags & IW_REQUEST_FLAG_COMPAT)
+		return IW_EV_COMPAT_LCP_LEN;
+#endif
+	return IW_EV_LCP_LEN;
+}
+/** source: include/net/iw_handler.h **/
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,27)) */
 
 #endif /* LINUX_26_27_COMPAT_H */
-- 
1.6.2.1

