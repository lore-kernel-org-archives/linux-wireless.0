Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:16872 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbYDXCcj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 22:32:39 -0400
Subject: [PATCH] iwlwifi: Fix built-in compilation of iwlcore (part 2)
From: Zhu Yi <yi.zhu@intel.com>
To: torvalds@linux-foundation.org, davem@davemloft.net,
	reinette.chatre@intel.com, linux-wireless@vger.kernel.org,
	"Winkler, Tomas" <tomas.winkler@intel.com>
In-Reply-To: <1208947121-22640-1-git-send-email-tomas.winkler@intel.com>
References: <1208947121-22640-1-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain
Date: Thu, 24 Apr 2008 10:31:47 +0800
Message-Id: <1209004307.17816.33.camel@debian.sh.intel.com> (sfid-20080424_043313_327525_7553F9E2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-04-23 at 13:38 +0300, Tomas Winkler wrote:
> This patch fixes problem in Makefile that prevented
> built-in compilation of iwlcore

Here is the second part. Without this,
drivers/net/wireless/iwlwifi/build-in.o will not be linked into vmlinux.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>

diff --git a/drivers/net/wireless/Makefile
b/drivers/net/wireless/Makefile
index 300fc68..41eb08e 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -58,8 +58,7 @@ obj-$(CONFIG_RTL8187)	+= rtl8187.o
 
 obj-$(CONFIG_ADM8211)	+= adm8211.o
 
-obj-$(CONFIG_IWL3945)	+= iwlwifi/
-obj-$(CONFIG_IWL4965)	+= iwlwifi/
+obj-$(CONFIG_IWLCORE)	+= iwlwifi/
 obj-$(CONFIG_RT2X00)	+= rt2x00/
 
 obj-$(CONFIG_P54_COMMON)	+= p54/


