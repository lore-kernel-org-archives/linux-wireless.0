Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:48888 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab0DSHQh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 03:16:37 -0400
Received: by wwb24 with SMTP id 24so2312104wwb.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Apr 2010 00:16:36 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 3/3] orinoco: have sparse check endian issues
Date: Mon, 19 Apr 2010 08:16:23 +0100
Message-Id: <1271661383-27839-3-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1271661383-27839-1-git-send-email-kilroyd@googlemail.com>
References: <1271661383-27839-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Orinoco should be endian clean, so enable the checking.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/Makefile |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/orinoco/Makefile b/drivers/net/wireless/orinoco/Makefile
index 9abd632..e645269 100644
--- a/drivers/net/wireless/orinoco/Makefile
+++ b/drivers/net/wireless/orinoco/Makefile
@@ -11,3 +11,6 @@ obj-$(CONFIG_PCI_HERMES)	+= orinoco_pci.o
 obj-$(CONFIG_TMD_HERMES)	+= orinoco_tmd.o
 obj-$(CONFIG_NORTEL_HERMES)	+= orinoco_nortel.o
 obj-$(CONFIG_PCMCIA_SPECTRUM)	+= spectrum_cs.o
+
+# Orinoco should be endian clean.
+ccflags-y += -D__CHECK_ENDIAN__
-- 
1.6.4.4

