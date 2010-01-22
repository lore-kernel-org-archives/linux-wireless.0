Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:57076 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754979Ab0AVWXM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 17:23:12 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 15/17] iwlwifi: check endianness annotations by default
Date: Fri, 22 Jan 2010 14:22:56 -0800
Message-Id: <1264198978-5915-16-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1264198978-5915-1-git-send-email-reinette.chatre@intel.com>
References: <1264198978-5915-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

sparse won't check endianness annotations by
default, but iwlwifi is and should be clean
so we can make sparse check them on it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 7f82044..bdaa924 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -20,3 +20,5 @@ iwlagn-$(CONFIG_IWL5000) += iwl-1000.o
 # 3945
 obj-$(CONFIG_IWL3945)	+= iwl3945.o
 iwl3945-objs		:= iwl3945-base.o iwl-3945.o iwl-3945-rs.o iwl-3945-led.o
+
+ccflags-y += -D__CHECK_ENDIAN__
-- 
1.6.3.3

