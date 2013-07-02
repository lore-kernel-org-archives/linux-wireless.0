Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20764 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134Ab3GBNb3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jul 2013 09:31:29 -0400
From: Ilan Peer <ilan.peer@intel.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@do-not-panic.com, Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH 2/3] [RFC] cfg80211: Add Kconfig option for cellular BS hints
Date: Tue,  2 Jul 2013 15:28:14 +0300
Message-Id: <1372768095-26053-3-git-send-email-ilan.peer@intel.com> (sfid-20130702_153132_274353_3390A781)
In-Reply-To: <1372768095-26053-1-git-send-email-ilan.peer@intel.com>
References: <1372768095-26053-1-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move the regulatory cellular base station hints support under
a specific configuration option and make the option depend
on CFG80211_CERTIFICATION_ONUS.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
---
 net/wireless/Kconfig |    7 +++++++
 net/wireless/reg.c   |    2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 16d08b3..de76078 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -95,6 +95,13 @@ config CFG80211_CERTIFICATION_ONUS
 	  you are a wireless researcher and are working in a controlled
 	  and approved environment by your local regulatory agency.
 
+config CFG80211_REG_CELLULAR_HINTS
+	bool "cfg80211 regulatory support for cellular base station hints"
+	depends on CFG80211 && CFG80211_CERTIFICATION_ONUS
+	---help---
+	  This option adds support for drivers that can receive regulatory
+	  hints from cellular base stations
+
 config CFG80211_DEFAULT_PS
 	bool "enable powersave by default"
 	depends on CFG80211
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 5a24c98..2459a69 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -928,7 +928,7 @@ bool reg_last_request_cell_base(void)
 	return reg_request_cell_base(get_last_request());
 }
 
-#ifdef CONFIG_CFG80211_CERTIFICATION_ONUS
+#ifdef CONFIG_CFG80211_REG_CELLULAR_HINTS
 /* Core specific check */
 static enum reg_request_treatment
 reg_ignore_cell_hint(struct regulatory_request *pending_request)
-- 
1.7.10.4

