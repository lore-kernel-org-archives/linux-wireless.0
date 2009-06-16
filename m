Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52710 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759461AbZFPSbR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 14:31:17 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] [compat-2.6] Do not build backported rfkill module on new kernels.
Date: Tue, 16 Jun 2009 20:31:10 +0200
Message-Id: <1245177070-13290-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1245177070-13290-1-git-send-email-hauke@hauke-m.de>
References: <1245177070-13290-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/config.mk b/config.mk
index c06c9c2..55d5627 100644
--- a/config.mk
+++ b/config.mk
@@ -353,7 +353,11 @@ CONFIG_LIBERTAS=m
 # CONFIG_LIBERTAS_DEBUG=y
 endif
 
+# We need the backported rfkill module on kernel < 2.6.31.
+# In more recent kernel versions use the in kernel rfkill module.
+ifeq ($(shell test $(KERNEL_SUBLEVEL) -le 30 && echo yes),yes)
 CONFIG_RFKILL_BACKPORT=m
 CONFIG_RFKILL_BACKPORT_LEDS=y
 CONFIG_RFKILL_BACKPORT_INPUT=y
+endif
 
-- 
1.6.2.1

