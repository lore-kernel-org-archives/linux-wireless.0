Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:35047 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752081Ab2EJQi0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 12:38:26 -0400
Message-ID: <1336667905.22495.18.camel@joe2Laptop> (sfid-20120510_183830_919218_6D85B843)
Subject: Re: [PATCH 1/4] iwlwifi: Add __printf argument checking to __iwl_dbg
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Thu, 10 May 2012 09:38:25 -0700
In-Reply-To: <1336665952-24363-2-git-send-email-johannes@sipsolutions.net>
References: <1336665952-24363-1-git-send-email-johannes@sipsolutions.net>
	 <1336665952-24363-2-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add gcc format and argument printf checking
to reduce future defect introduction.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/iwlwifi/iwl-debug.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 8376b84..d0c7c9e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -50,10 +50,12 @@ void __iwl_crit(struct device *dev, const char *fmt, ...);
 #define IWL_CRIT(m, f, a...) __iwl_crit((m)->dev, f, ## a)
 
 #if defined(CONFIG_IWLWIFI_DEBUG) || defined(CONFIG_IWLWIFI_DEVICE_TRACING)
+__printf(5, 6)
 void __iwl_dbg(struct device *dev,
 	       u32 level, bool limit, const char *function,
 	       const char *fmt, ...);
 #else
+__printf(5, 6)
 static inline void
 __iwl_dbg(struct device *dev,
 	  u32 level, bool limit, const char *function,




