Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:18604 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144Ab2DXNQu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 09:16:50 -0400
From: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
To: linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [RFCv2 2/6] mac80211: softamp: Adds build config option
Date: Tue, 24 Apr 2012 16:17:36 +0300
Message-Id: <1335273460-12682-3-git-send-email-Andrei.Emeltchenko.news@gmail.com> (sfid-20120424_151701_785673_5613930C)
In-Reply-To: <1335273460-12682-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
References: <1335273460-12682-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Emeltchenko <andrei.emeltchenko@intel.com>


Signed-off-by: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
---
 net/mac80211/Kconfig  |    9 +++++++++
 net/mac80211/Makefile |    2 ++
 2 files changed, 11 insertions(+)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 96ddb72..661b679 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -67,6 +67,15 @@ config MAC80211_RC_DEFAULT_MINSTREL
 
 endchoice
 
+config MAC80211_BLUETOOTH_SOFTAMP
+	bool "Bluetooth Soft AMP80211 device"
+	depends on BT
+	---help---
+	  Enable Bluetooth Virtual / Software AMP 80211 controller.
+	  When AMP is common between two devices data may be routed
+	  through fast 80211 connection from standard Bluetooth BR/EDR
+	  connection.
+
 config MAC80211_RC_DEFAULT
 	string
 	default "minstrel_ht" if MAC80211_RC_DEFAULT_MINSTREL && MAC80211_RC_MINSTREL_HT
diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index 1be7a45..ff0131e 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -40,6 +40,8 @@ mac80211-$(CONFIG_MAC80211_MESH) += \
 	mesh_plink.o \
 	mesh_hwmp.o
 
+mac80211-$(CONFIG_MAC80211_BLUETOOTH_SOFTAMP) += virtual_amp.o
+
 mac80211-$(CONFIG_PM) += pm.o
 
 CFLAGS_driver-trace.o := -I$(src)
-- 
1.7.9.5

