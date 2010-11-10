Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58629 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793Ab0KJCVK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:21:10 -0500
Received: by mail-qw0-f46.google.com with SMTP id 5so5541qwh.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:21:09 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 14/44] compat/2.6.25: conditionally defines `__WARN'
Date: Tue,  9 Nov 2010 21:19:56 -0500
Message-Id: <1289355626-25373-15-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

powerpc has a MD definition for it already.

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/compat-2.6.25.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.25.h b/include/linux/compat-2.6.25.h
index 6183a89..b2bf50f 100644
--- a/include/linux/compat-2.6.25.h
+++ b/include/linux/compat-2.6.25.h
@@ -72,7 +72,9 @@ int compat_pm_qos_power_deinit(void);
 /* Although pm_qos stuff is not implemented on <= 2.6.24 lets keep the define */
 #define PM_QOS_DEFAULT_VALUE -1
 
+#ifndef __WARN
 #define __WARN(foo) dump_stack()
+#endif
 
 #define dev_emerg(dev, format, arg...)          \
 	dev_printk(KERN_EMERG , dev , format , ## arg)
-- 
1.7.2.30.gc37d7.dirty

