Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:34704 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab1FMWey (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 18:34:54 -0400
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh04-2.mail.saunalahti.fi (Postfix) with SMTP id C8D5F13BAF2
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:34:52 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-184-248.elisa-laajakaista.fi [88.115.184.248])
	by emh04.mail.saunalahti.fi (Postfix) with ESMTP id B12AD41BE2
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:34:51 +0300 (EEST)
Subject: [PATCH v2 02/27] iwlwifi: fix stop/wake queue hacks
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 14 Jun 2011 01:34:50 +0300
Message-ID: <20110613223450.10517.44165.stgit@localhost6.localdomain6> (sfid-20110614_003456_003540_76986E75)
In-Reply-To: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
References: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The hacks break once mac80211-compat.h is taken into use. Fix it by adding
an ifdef check.

Signed-off-by: Kalle Valo <kvalo@adurom.com>
---
 drivers/net/wireless/iwlwifi/iwl-helpers.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-helpers.h b/drivers/net/wireless/iwlwifi/iwl-helpers.h
index 41207a3..9d91552 100644
--- a/drivers/net/wireless/iwlwifi/iwl-helpers.h
+++ b/drivers/net/wireless/iwlwifi/iwl-helpers.h
@@ -120,7 +120,16 @@ static inline void iwl_wake_any_queue(struct iwl_priv *priv,
 	}
 }
 
+#ifdef ieee80211_stop_queue
+#undef ieee80211_stop_queue
+#endif
+
 #define ieee80211_stop_queue DO_NOT_USE_ieee80211_stop_queue
+
+#ifdef ieee80211_wake_queue
+#undef ieee80211_wake_queue
+#endif
+
 #define ieee80211_wake_queue DO_NOT_USE_ieee80211_wake_queue
 
 static inline void iwl_disable_interrupts(struct iwl_priv *priv)

