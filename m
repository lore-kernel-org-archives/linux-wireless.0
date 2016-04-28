Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513AbcD1TTQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2016 15:19:16 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 01/11] rtl8xxxu: Rename rtl8xxxu.c to rtl8xxxu_core.c
Date: Thu, 28 Apr 2016 15:19:05 -0400
Message-Id: <1461871155-11826-2-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160428_211922_621393_5526DFB2)
In-Reply-To: <1461871155-11826-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1461871155-11826-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This renames the core file to rtl8xxxu_core.c in order to allow us to
keep the module nake rtl8xxxu.ko when refactoring the code into
multiple files.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/Makefile                        | 2 ++
 drivers/net/wireless/realtek/rtl8xxxu/{rtl8xxxu.c => rtl8xxxu_core.c} | 0
 2 files changed, 2 insertions(+)
 rename drivers/net/wireless/realtek/rtl8xxxu/{rtl8xxxu.c => rtl8xxxu_core.c} (100%)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/Makefile b/drivers/net/wireless/realtek/rtl8xxxu/Makefile
index 5dea3bb..a6dfeee 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/Makefile
+++ b/drivers/net/wireless/realtek/rtl8xxxu/Makefile
@@ -1 +1,3 @@
 obj-$(CONFIG_RTL8XXXU)	+= rtl8xxxu.o
+
+rtl8xxxu-y	:= rtl8xxxu_core.o
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
similarity index 100%
rename from drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
rename to drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
-- 
2.5.5

