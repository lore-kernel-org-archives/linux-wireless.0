Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48388 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab2HXDbY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2012 23:31:24 -0400
Received: by pbbrr13 with SMTP id rr13so2630919pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Aug 2012 20:31:24 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: jirislaby@gmail.com, mickflemm@gmail.com, mcgrof@qca.qualcomm.com,
	ath5k-devel@lists.ath5k.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] ath5k: set hw mfp capable flag for secured mesh
Date: Fri, 24 Aug 2012 11:29:53 +0800
Message-Id: <1345778993-23033-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120824_053128_684894_141999F9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The IEEE80211_HW_MFP_CAPABLE is required to ensure the
successful key installation of CIPHER_AES_CMAC (currently
done in software) for secured mesh.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index a0a202d..4605fe1 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2446,7 +2446,8 @@ ath5k_init_ah(struct ath5k_hw *ah, const struct ath_bus_ops *bus_ops)
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 			IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 			IEEE80211_HW_SIGNAL_DBM |
-			IEEE80211_HW_REPORTS_TX_ACK_STATUS;
+			IEEE80211_HW_REPORTS_TX_ACK_STATUS |
+			IEEE80211_HW_MFP_CAPABLE;
 
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_AP) |
-- 
1.7.0.4

