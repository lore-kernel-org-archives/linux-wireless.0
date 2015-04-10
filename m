Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:35144 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933443AbbDJNar (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2015 09:30:47 -0400
Received: by labbd9 with SMTP id bd9so13284006lab.2
        for <linux-wireless@vger.kernel.org>; Fri, 10 Apr 2015 06:30:46 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 4/4] ath10k: enable ibss-rsn
Date: Fri, 10 Apr 2015 13:23:23 +0000
Message-Id: <1428672203-8604-5-git-send-email-michal.kazior@tieto.com> (sfid-20150410_153101_054357_E7893778)
In-Reply-To: <1428672203-8604-1-git-send-email-michal.kazior@tieto.com>
References: <1428672203-8604-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Janusz Dziedzic <janusz.dziedzic@tieto.com>

With latest additions to the driver it seems
viable to enable support for IBSS-RSN.

It seems to work on QCA988X and 999.999.0.636 but
is a bit slow to exchange RSN keys for some
reason. This may be a firmware quirk or ath10k is
missing something. Nevertheless it makes sense to
finally enable IBSS-RSN in ath10k even if somewhat
handicapped.

QCA6174 firmware doesn't seem to be able to Tx
EAPOL frames at all now (they get stuck in hw
queues for some reason) so it never gets to set
the keys in driver. It's fairly safe to assume that
once this is fixed IBSS-RSN will work with QCA6174
firmware without any additional changes. Hence no
special handling for advertising
IEEE80211_HW_SUPPORTS_PER_STA_GTK and
WIPHY_FLAG_IBSS_RSN is done now.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 9428d75d0d76..7485d5ccee3d 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6720,11 +6720,13 @@ int ath10k_mac_register(struct ath10k *ar)
 			IEEE80211_HW_SPECTRUM_MGMT |
 			IEEE80211_HW_SW_CRYPTO_CONTROL |
 			IEEE80211_HW_CONNECTION_MONITOR |
+			IEEE80211_HW_SUPPORTS_PER_STA_GTK |
 			IEEE80211_HW_WANT_MONITOR_VIF |
 			IEEE80211_HW_CHANCTX_STA_CSA |
 			IEEE80211_HW_QUEUE_CONTROL;
 
 	ar->hw->wiphy->features |= NL80211_FEATURE_STATIC_SMPS;
+	ar->hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 
 	if (ar->ht_cap_info & WMI_HT_CAP_DYNAMIC_SMPS)
 		ar->hw->wiphy->features |= NL80211_FEATURE_DYNAMIC_SMPS;
-- 
2.1.4

