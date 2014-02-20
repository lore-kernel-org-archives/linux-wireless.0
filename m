Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:53803 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896AbaBTLnB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 06:43:01 -0500
From: Ilan Peer <ilan.peer@intel.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@do-not-panic.com, Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH v5 2/5] cfg80211: Add Kconfig option for cellular BS hints
Date: Thu, 20 Feb 2014 13:44:28 +0200
Message-Id: <1392896671-4288-3-git-send-email-ilan.peer@intel.com> (sfid-20140220_124313_265024_C6D41EB9)
In-Reply-To: <1392896671-4288-1-git-send-email-ilan.peer@intel.com>
References: <1392896671-4288-1-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move the regulatory cellular base station hints support under
a specific configuration option and make the option depend
on CFG80211_CERTIFICATION_ONUS.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
---
 net/wireless/Kconfig |   13 +++++++++++++
 net/wireless/reg.c   |    2 +-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 16d08b3..2a891bc 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -95,6 +95,19 @@ config CFG80211_CERTIFICATION_ONUS
 	  you are a wireless researcher and are working in a controlled
 	  and approved environment by your local regulatory agency.
 
+config CFG80211_REG_CELLULAR_HINTS
+	bool "cfg80211 regulatory support for cellular base station hints"
+	depends on CFG80211_CERTIFICATION_ONUS
+	---help---
+	  This option enables support for parsing regulatory hints
+	  from cellular base stations. If enabled and at least one driver
+	  claims support for parsing cellular base station hints the
+	  regulatory core will allow and parse these regulatory hints.
+	  The regulatory core will only apply these regulatory hints on
+	  drivers that support this feature. You should only enable this
+	  feature if you have tested and validated this feature on your
+	  systems.
+
 config CFG80211_DEFAULT_PS
 	bool "enable powersave by default"
 	depends on CFG80211
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index eeccce3..096268f 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1109,7 +1109,7 @@ bool reg_last_request_cell_base(void)
 	return reg_request_cell_base(get_last_request());
 }
 
-#ifdef CONFIG_CFG80211_CERTIFICATION_ONUS
+#ifdef CONFIG_CFG80211_REG_CELLULAR_HINTS
 /* Core specific check */
 static enum reg_request_treatment
 reg_ignore_cell_hint(struct regulatory_request *pending_request)
-- 
1.7.10.4

