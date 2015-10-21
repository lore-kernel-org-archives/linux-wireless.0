Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:52485 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756257AbbJUVxZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2015 17:53:25 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath6kl@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH 2/3] ath6k:  add error message to explain lack of HT.
Date: Wed, 21 Oct 2015 14:53:20 -0700
Message-Id: <1445464401-13826-2-git-send-email-greearb@candelatech.com> (sfid-20151021_235337_599760_23515282)
In-Reply-To: <1445464401-13826-1-git-send-email-greearb@candelatech.com>
References: <1445464401-13826-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

It can take a user a while to understand why their
NIC that advertises 802.11n support cannot actually
do 802.11n.  Print out a warning in the logs to save
the next poor person to use this NIC some trouble.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index ed25ad6..6fcb39b 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3797,6 +3797,9 @@ int ath6kl_cfg80211_init(struct ath6kl *ar)
 		ath6kl_band_2ghz.ht_cap.ht_supported = false;
 		ath6kl_band_5ghz.ht_cap.cap = 0;
 		ath6kl_band_5ghz.ht_cap.ht_supported = false;
+
+		if (ht)
+			ath6kl_err("Firmware lacks RSN-CAP-OVERRIDE, so HT (802.11n) is disabled.");
 	}
 
 	if (test_bit(ATH6KL_FW_CAPABILITY_64BIT_RATES,
-- 
2.4.3

