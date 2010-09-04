Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54690 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819Ab0IDPHS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Sep 2010 11:07:18 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 5/5] compat-wireless: build if kernel does not have mac80211
Date: Sat,  4 Sep 2010 17:06:49 +0200
Message-Id: <1283612809-6798-6-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1283612809-6798-1-git-send-email-hauke@hauke-m.de>
References: <1283612809-6798-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In kernel 2.6.31 the attributes do_not_encrypt and requeue were removed
from struct sk_buff so we do not need mac80211 to be build while the
kernel was build for nwer kernels.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/config.mk b/config.mk
index 3fee3fe..d208ed1 100644
--- a/config.mk
+++ b/config.mk
@@ -52,9 +52,11 @@ endif
 #
 # skb->requeue
 #
-ifeq ($(shell test $(KERNEL_SUBLEVEL) -ge 27 && echo yes),yes)
+# In kernel 2.6.32 both attributes were removed.
+#
+ifeq ($(shell test $(KERNEL_SUBLEVEL) -ge 27 -a $(KERNEL_SUBLEVEL) -le 31 && echo yes),yes)
 ifeq ($(CONFIG_MAC80211),)
-$(error "ERROR: Your >=2.6.27 kernel has CONFIG_MAC80211 disabled, you should have it CONFIG_MAC80211=m if you want to use this thing.")
+$(error "ERROR: Your >=2.6.27 and <= 2.6.31 kernel has CONFIG_MAC80211 disabled, you should have it CONFIG_MAC80211=m if you want to use this thing.")
 endif
 endif
 
-- 
1.7.0.4

