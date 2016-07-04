Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36695 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbcGDLJc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2016 07:09:32 -0400
Received: by mail-wm0-f65.google.com with SMTP id c82so20817669wme.3
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jul 2016 04:09:32 -0700 (PDT)
From: lemagoup@gmail.com
To: kvalo@qca.qualcomm.com
Cc: ath6kl@lists.infradead.org, linux-wireless@vger.kernel.org,
	jmassot@aldebaran.com,
	Pierre Le Magourou <plemagourou@aldebaran.com>
Subject: [PATCH v2 2/3] ath6kl: Fix wrong regulatory domain disconnection.
Date: Mon,  4 Jul 2016 13:07:18 +0200
Message-Id: <20160704110719.7694-3-plemagourou@aldebaran.com> (sfid-20160704_130947_853649_17E8DACD)
In-Reply-To: <20160704110719.7694-1-plemagourou@aldebaran.com>
References: <20160704110719.7694-1-plemagourou@aldebaran.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pierre Le Magourou <plemagourou@aldebaran.com>

One minute after a successful connection, the kernel checks if the
frequency and the channel width are well configured for the country we
are in. (regulatory domain)

ath6kl driver was setting the NL80211_CHAN_HT20 channel without checking
for the HT capabilities. (we should have NL80211_CHAN_NO_HT in our
case because the firmware did not support HT)

This patch adds a check on ht_cap.ht_supported in order to create the
channel corresponding to the firmware capabilities.

Signed-off-by: Pierre Le Magourou <plemagourou@aldebaran.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 4e11ba0..c9c4d7f 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1104,7 +1104,8 @@ void ath6kl_cfg80211_ch_switch_notify(struct ath6kl_vif *vif, int freq,
 
 	cfg80211_chandef_create(&chandef,
 				ieee80211_get_channel(vif->ar->wiphy, freq),
-				(mode == WMI_11G_HT20) ?
+				(mode == WMI_11G_HT20 &&
+				 ath6kl_band_2ghz.ht_cap.ht_supported) ?
 					NL80211_CHAN_HT20 : NL80211_CHAN_NO_HT);
 
 	mutex_lock(&vif->wdev.mtx);
-- 
2.9.0

