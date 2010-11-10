Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:65142 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab0KJCWE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:22:04 -0500
Received: by mail-qw0-f46.google.com with SMTP id 5so5749qwh.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:22:04 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 42/44] compat/2.6.{21,30}: make dev_set_uevent_suppress() a no-op for <2.6.21
Date: Tue,  9 Nov 2010 21:20:24 -0500
Message-Id: <1289355626-25373-43-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/compat-2.6.30.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.30.h b/include/linux/compat-2.6.30.h
index 28f3d54..e824c22 100644
--- a/include/linux/compat-2.6.30.h
+++ b/include/linux/compat-2.6.30.h
@@ -27,7 +27,9 @@ enum dpm_order {
 
 static inline void dev_set_uevent_suppress(struct device *dev, int val)
 {
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,21))
 	dev->uevent_suppress = val;
+#endif
 }
 
 /*
-- 
1.7.2.30.gc37d7.dirty

