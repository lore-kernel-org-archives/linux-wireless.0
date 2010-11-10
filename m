Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58629 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab0KJCVZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:21:25 -0500
Received: by mail-qw0-f46.google.com with SMTP id 5so5541qwh.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:21:25 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 22/44] compat/2.6.33: add compat macro to BUILD_BUG_ON_NOT_POWER_OF_2()
Date: Tue,  9 Nov 2010 21:20:04 -0500
Message-Id: <1289355626-25373-23-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/compat-2.6.33.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.33.h b/include/linux/compat-2.6.33.h
index c2dbc1b..fe1783c 100644
--- a/include/linux/compat-2.6.33.h
+++ b/include/linux/compat-2.6.33.h
@@ -14,6 +14,9 @@
 #include <linux/kfifo.h>
 #include <linux/firmware.h>
 
+#define BUILD_BUG_ON_NOT_POWER_OF_2(n)			\
+	BUILD_BUG_ON((n) == 0 || (((n) & ((n) - 1)) != 0))
+
 #define release_firmware compat_release_firmware
 #define request_firmware compat_request_firmware
 #define request_firmware_nowait compat_request_firmware_nowait
-- 
1.7.2.30.gc37d7.dirty

