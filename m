Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:40557 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375Ab0FFJMQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jun 2010 05:12:16 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/3] compat-wireless: deactivate atl1c for kernel < 2.6.27
Date: Sun,  6 Jun 2010 11:11:57 +0200
Message-Id: <1275815518-30281-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1275815518-30281-1-git-send-email-hauke@hauke-m.de>
References: <1275815518-30281-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

atl1c uses pci_prepare_to_sleep that is not backported.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/config.mk b/config.mk
index ae56849..b0bb35b 100644
--- a/config.mk
+++ b/config.mk
@@ -289,7 +289,11 @@ CONFIG_MWL8K=m
 CONFIG_ATL1=m
 CONFIG_ATL2=m
 CONFIG_ATL1E=m
+ifdef CONFIG_COMPAT_KERNEL_27
+CONFIG_ATL1C=n
+else
 CONFIG_ATL1C=m
+endif
 
 CONFIG_HERMES=m
 CONFIG_HERMES_CACHE_FW_ON_INIT=y
-- 
1.7.0.4

