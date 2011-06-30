Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:44855 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795Ab1F3T0g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 15:26:36 -0400
Received: by fxd18 with SMTP id 18so2559979fxd.11
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jun 2011 12:26:35 -0700 (PDT)
Message-Id: <70f56d2388f96f68d9d6df54b11ff544c8d7d85a.1309459253.git.chunkeey@googlemail.com> (sfid-20110630_212646_538734_3B9CE2B6)
In-Reply-To: <48506f4c6ef4578f748a77e2c7bca7374cf1a187.1309459253.git.chunkeey@googlemail.com>
References: <48506f4c6ef4578f748a77e2c7bca7374cf1a187.1309459253.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Thu, 30 Jun 2011 20:34:54 +0200
Subject: [PATCH 3/3] carl9170: allow PSM if the 5 GHz band is selected
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/carl9170.h |    1 -
 drivers/net/wireless/ath/carl9170/fw.c       |    2 +-
 drivers/net/wireless/ath/carl9170/phy.c      |    6 ------
 3 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
index d96d03f..f9a4655 100644
--- a/drivers/net/wireless/ath/carl9170/carl9170.h
+++ b/drivers/net/wireless/ath/carl9170/carl9170.h
@@ -442,7 +442,6 @@ struct ar9170 {
 enum carl9170_ps_off_override_reasons {
 	PS_OFF_VIF	= BIT(0),
 	PS_OFF_BCN	= BIT(1),
-	PS_OFF_5GHZ	= BIT(2),
 };
 
 struct carl9170_ba_stats {
diff --git a/drivers/net/wireless/ath/carl9170/fw.c b/drivers/net/wireless/ath/carl9170/fw.c
index 221957c..39ddea5 100644
--- a/drivers/net/wireless/ath/carl9170/fw.c
+++ b/drivers/net/wireless/ath/carl9170/fw.c
@@ -237,7 +237,7 @@ static int carl9170_fw(struct ar9170 *ar, const __u8 *data, size_t len)
 		ar->disable_offload = true;
 	}
 
-	if (SUPP(CARL9170FW_PSM))
+	if (SUPP(CARL9170FW_PSM) && SUPP(CARL9170FW_FIXED_5GHZ_PSM))
 		ar->hw->flags |= IEEE80211_HW_SUPPORTS_PS;
 
 	if (!SUPP(CARL9170FW_USB_INIT_FIRMWARE)) {
diff --git a/drivers/net/wireless/ath/carl9170/phy.c b/drivers/net/wireless/ath/carl9170/phy.c
index b6ae0e1..da1ab96 100644
--- a/drivers/net/wireless/ath/carl9170/phy.c
+++ b/drivers/net/wireless/ath/carl9170/phy.c
@@ -1783,12 +1783,6 @@ int carl9170_set_channel(struct ar9170 *ar, struct ieee80211_channel *channel,
 		}
 	}
 
-	/* FIXME: PSM does not work in 5GHz Band */
-	if (channel->band == IEEE80211_BAND_5GHZ)
-		ar->ps.off_override |= PS_OFF_5GHZ;
-	else
-		ar->ps.off_override &= ~PS_OFF_5GHZ;
-
 	ar->channel = channel;
 	ar->ht_settings = new_ht;
 	return 0;
-- 
1.7.5.4

