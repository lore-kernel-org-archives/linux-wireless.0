Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:65142 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837Ab0KJCVg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:21:36 -0500
Received: by mail-qw0-f46.google.com with SMTP id 5so5749qwh.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:21:36 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 29/44] compat/2.6.22: rework `uninitialized_var' and `__maybe_unused' macros
Date: Tue,  9 Nov 2010 21:20:11 -0500
Message-Id: <1289355626-25373-30-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Protect their definitions, and add fallbacks.

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/compat-2.6.22.h |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/compat-2.6.22.h b/include/linux/compat-2.6.22.h
index 7ca1b18..174a269 100644
--- a/include/linux/compat-2.6.22.h
+++ b/include/linux/compat-2.6.22.h
@@ -80,9 +80,18 @@ static inline void skb_copy_from_linear_data_offset(const struct sk_buff *skb,
 	memcpy(to, skb->data + offset, len);
 }
 
-#define __maybe_unused	__attribute__((unused))
+#if defined(__GNUC__)
+#define __maybe_unused		__attribute__((unused))
+#define uninitialized_var(x)	x = x
+#endif
+
+#ifndef __maybe_unused
+#define __maybe_unused		/* unimplemented */
+#endif
 
-#define uninitialized_var(x) x = x
+#ifndef uninitialized_var
+#define uninitialized_var(x)	x
+#endif
 
 /* This will lead to very weird behaviour... */
 #define NLA_BINARY NLA_STRING
-- 
1.7.2.30.gc37d7.dirty

