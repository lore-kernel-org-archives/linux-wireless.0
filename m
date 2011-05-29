Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:54282 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab1E2UEN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 May 2011 16:04:13 -0400
Received: from saunalahti-vams (vs3-12.mail.saunalahti.fi [62.142.5.96])
	by emh03-2.mail.saunalahti.fi (Postfix) with SMTP id 4BB5DEBE16
	for <linux-wireless@vger.kernel.org>; Sun, 29 May 2011 23:04:12 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-184-248.elisa-laajakaista.fi [88.115.184.248])
	by emh06.mail.saunalahti.fi (Postfix) with ESMTP id 33CB5E51A4
	for <linux-wireless@vger.kernel.org>; Sun, 29 May 2011 23:04:10 +0300 (EEST)
Subject: [RFC PATCH 02/27] iwlwifi: fix stop/wake queue hacks
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@adurom.com>
Date: Sun, 29 May 2011 23:04:10 +0300
Message-ID: <20110529200410.16479.89790.stgit@localhost6.localdomain6> (sfid-20110529_220416_982835_F384C332)
In-Reply-To: <20110529195022.16479.71762.stgit@localhost6.localdomain6>
References: <20110529195022.16479.71762.stgit@localhost6.localdomain6>
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

