Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:57089 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751861AbbJEOhL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 10:37:11 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Oct 2015 17:36:36 +0300
Message-Id: <1444055820-27506-5-git-send-email-luca@coelho.fi> (sfid-20151005_163821_733678_03878A5B)
In-Reply-To: <1444050759.27220.15.camel@coelho.fi>
References: <1444050759.27220.15.camel@coelho.fi>
Subject: [PATCH 05/29] iwlwifi: enable tracing by default
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Tracing, if disabled at runtime, has very low overhead with
great returns on debugging. It therefore makes sense to have
it enabled by default (if the kernel enables EVENT_TRACING).

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index aba0957..6e949df 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -142,6 +142,7 @@ config IWLWIFI_DEBUG_EXPERIMENTAL_UCODE
 config IWLWIFI_DEVICE_TRACING
 	bool "iwlwifi device access tracing"
 	depends on EVENT_TRACING
+	default y
 	help
 	  Say Y here to trace all commands, including TX frames and IO
 	  accesses, sent to the device. If you say yes, iwlwifi will
-- 
2.5.3

