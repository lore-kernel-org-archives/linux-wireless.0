Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:55862 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181AbZA2TGX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2009 14:06:23 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Jay Sternberg <jay.e.sternberg@linux.intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 7/7] ipw2x00: correct Kconfig to prevent following entries from not indenting
Date: Thu, 29 Jan 2009 11:09:17 -0800
Message-Id: <1233256157-21290-8-git-send-email-reinette.chatre@intel.com> (sfid-20090129_200631_690393_73BE3D61)
In-Reply-To: <1233256157-21290-7-git-send-email-reinette.chatre@intel.com>
References: <>
 <1233256157-21290-1-git-send-email-reinette.chatre@intel.com>
 <1233256157-21290-2-git-send-email-reinette.chatre@intel.com>
 <1233256157-21290-3-git-send-email-reinette.chatre@intel.com>
 <1233256157-21290-4-git-send-email-reinette.chatre@intel.com>
 <1233256157-21290-5-git-send-email-reinette.chatre@intel.com>
 <1233256157-21290-6-git-send-email-reinette.chatre@intel.com>
 <1233256157-21290-7-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jay Sternberg <jay.e.sternberg@linux.intel.com>

not defining dependencies for LIBIPW caused the following entries to not be
indented. changing this entry to depend on PCI && WLAN_80211 corrects this
issue

Signed-off-by: Jay Sternberg <jay.e.sternberg@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/ipw2x00/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/Kconfig b/drivers/net/wireless/ipw2x00/Kconfig
index 3d5cc44..1d5dc3e 100644
--- a/drivers/net/wireless/ipw2x00/Kconfig
+++ b/drivers/net/wireless/ipw2x00/Kconfig
@@ -150,6 +150,7 @@ config IPW2200_DEBUG
 
 config LIBIPW
 	tristate
+	depends on PCI && WLAN_80211
 	select WIRELESS_EXT
 	select CRYPTO
 	select CRYPTO_ARC4
-- 
1.5.4.3

