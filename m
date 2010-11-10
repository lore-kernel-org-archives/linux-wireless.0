Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:47672 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837Ab0KJCV0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:21:26 -0500
Received: by mail-qy0-f174.google.com with SMTP id 12so2500227qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:21:26 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 23/44] compat/2.6.33: fix pcmcia include
Date: Tue,  9 Nov 2010 21:20:05 -0500
Message-Id: <1289355626-25373-24-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fix 'ppc6xx_defconfig' build.

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/compat-2.6.33.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.33.h b/include/linux/compat-2.6.33.h
index fe1783c..8c8789d 100644
--- a/include/linux/compat-2.6.33.h
+++ b/include/linux/compat-2.6.33.h
@@ -7,8 +7,10 @@
 
 #include <linux/skbuff.h>
 #if defined(CONFIG_PCCARD) || defined(CONFIG_PCCARD_MODULE)
+struct pcmcia_socket;
 #include <pcmcia/cs_types.h>
 #include <pcmcia/cistpl.h>
+#include <pcmcia/cs.h>
 #include <pcmcia/ds.h>
 #endif
 #include <linux/kfifo.h>
-- 
1.7.2.30.gc37d7.dirty

