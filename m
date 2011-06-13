Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:39320 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054Ab1FMWeq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 18:34:46 -0400
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh05-2.mail.saunalahti.fi (Postfix) with SMTP id 96B138C0CF
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:34:45 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-184-248.elisa-laajakaista.fi [88.115.184.248])
	by emh04.mail.saunalahti.fi (Postfix) with ESMTP id 826C441BE2
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:34:44 +0300 (EEST)
Subject: [PATCH v2 01/27] iwlegacy: fix stop/wake queue hacks
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 14 Jun 2011 01:34:38 +0300
Message-ID: <20110613223438.10517.55155.stgit@localhost6.localdomain6> (sfid-20110614_003449_038159_D5BA178C)
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
 drivers/net/wireless/iwlegacy/iwl-helpers.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-helpers.h b/drivers/net/wireless/iwlegacy/iwl-helpers.h
index a6effda..5cf23ea 100644
--- a/drivers/net/wireless/iwlegacy/iwl-helpers.h
+++ b/drivers/net/wireless/iwlegacy/iwl-helpers.h
@@ -132,7 +132,16 @@ static inline void iwl_legacy_stop_queue(struct iwl_priv *priv,
 			ieee80211_stop_queue(priv->hw, ac);
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
 
 static inline void iwl_legacy_disable_interrupts(struct iwl_priv *priv)

