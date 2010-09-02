Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53335 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755210Ab0IBNdR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Sep 2010 09:33:17 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/4] compat-wireless: fix generation of compat_autoconf.h
Date: Thu,  2 Sep 2010 15:32:56 +0200
Message-Id: <1283434377-26210-4-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1283434377-26210-1-git-send-email-hauke@hauke-m.de>
References: <1283434377-26210-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The endif of an ifdef or ifndef needs and comment so that gen-compat-
autoconf.sh knows that it should put it into the compat_autoconf.h. If
it is missing compat-wireless will not build.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/config.mk b/config.mk
index 9d89d72..3c6d416 100644
--- a/config.mk
+++ b/config.mk
@@ -502,7 +502,7 @@ CONFIG_ATH6KL_ENABLE_TARGET_DEBUG_PRINTS=y
 # CONFIG_ATH6KL_SKIP_ABI_VERSION_CHECK is not set
 CONFIG_ATH6KL_VIRTUAL_SCATTER_GATHER=y
 CONFIG_ATH6K_LEGACY=m
-endif
+endif #CONFIG_COMPAT_KERNEL_32
 endif
 
 
-- 
1.7.0.4

