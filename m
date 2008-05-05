Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41783 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754172AbYEECYR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 22:24:17 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Yi Zhu <yi.zhu@intel.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 11/25] iwlwifi: Fix built-in compilation of iwlcore (part 2)
Date: Mon,  5 May 2008 10:22:38 +0800
Message-Id: <1209954172-3092-12-git-send-email-yi.zhu@intel.com> (sfid-20080505_044417_696182_9B5D181D)
In-Reply-To: <1209954172-3092-11-git-send-email-yi.zhu@intel.com>
References: <1209954172-3092-1-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-2-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-3-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-4-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-5-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-6-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-7-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-8-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-9-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-10-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-11-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yi Zhu <yi.zhu@intel.com>

On Wed, 2008-04-23 at 13:38 +0300, Tomas Winkler wrote:
> This patch fixes problem in Makefile that prevented
> built-in compilation of iwlcore

Here is the second part. Without this,
drivers/net/wireless/iwlwifi/build-in.o will not be linked into
vmlinux.

Signed-off-by: Yi Zhu <yi.zhu@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/wireless/Makefile |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
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
-- 
1.5.3.6

