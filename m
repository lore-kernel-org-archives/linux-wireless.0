Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24856 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757390Ab2BYBwU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 20:52:20 -0500
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <hauke@hauke-m.de>, <nbd@nbd.name>, <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [PATCH 3/5] compat-wireless: fix old checks on KERNEL_SUBLEVEL
Date: Fri, 24 Feb 2012 17:52:04 -0800
Message-ID: <1330134726-1634-4-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20120225_025223_977070_7C80F5CD)
In-Reply-To: <1330134726-1634-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1330134726-1634-1-git-send-email-rodrigue@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@frijolero.org>

KERNEL_SUBLEVEL used to be used on config.mk for th 2.6.x series
but after 3.x support was added the variable should have been
changed to KERNEL_26SUBLEVEL.

Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---
 config.mk |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/config.mk b/config.mk
index f8a4ca5..4b47321 100644
--- a/config.mk
+++ b/config.mk
@@ -53,7 +53,8 @@ endif
 # 2.6.27 has FTRACE_DYNAMIC borked, so we will complain if
 # you have it enabled, otherwise you will very likely run into
 # a kernel panic.
-ifeq ($(shell test $(KERNEL_VERSION) -eq 2 -a $(KERNEL_SUBLEVEL) -eq 27 && echo yes),yes)
+# XXX: move this to compat_autoconf.h script generation
+ifeq ($(shell test $(KERNEL_VERSION) -eq 2 -a $(KERNEL_26SUBLEVEL) -eq 27 && echo yes),yes)
 ifeq ($(CONFIG_DYNAMIC_FTRACE),y)
 $(error "ERROR: Your 2.6.27 kernel has CONFIG_DYNAMIC_FTRACE, please upgrade your distribution kernel as newer ones should not have this enabled (and if so report a bug) or remove this warning if you know what you are doing")
 endif
@@ -70,7 +71,8 @@ endif
 #
 # In kernel 2.6.32 both attributes were removed.
 #
-ifeq ($(shell test $(KERNEL_VERSION) -eq 2 -a $(KERNEL_SUBLEVEL) -ge 27 -a $(KERNEL_SUBLEVEL) -le 31 && echo yes),yes)
+# XXX: move this to compat_autoconf.h script generation
+ifeq ($(shell test $(KERNEL_VERSION) -eq 2 -a $(KERNEL_26SUBLEVEL) -ge 27 -a $(KERNEL_26SUBLEVEL) -le 31 && echo yes),yes)
 ifeq ($(CONFIG_MAC80211),)
 $(error "ERROR: Your >=2.6.27 and <= 2.6.31 kernel has CONFIG_MAC80211 disabled, you should have it CONFIG_MAC80211=m if you want to use this thing.")
 endif
-- 
1.7.4.15.g7811d

