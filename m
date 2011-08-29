Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:33550 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615Ab1H2LwS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 07:52:18 -0400
Date: Mon, 29 Aug 2011 17:12:44 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [PATCH] mwl8k: Set hardware flag IEEE80211_HW_AP_LINK_PS
Message-ID: <20110829114237.GA2648@hertz.marvell.com> (sfid-20110829_135221_548838_FC05943B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will avoid mac80211 to trigger PS mode for connected station
based on the PM bit of incoming frames. AP firmware is capable of
handling such frames and buffering TX frames destined to the
stations that are in PS mode.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 771280a..ea1395a 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -5501,6 +5501,14 @@ static int mwl8k_firmware_load_success(struct mwl8k_priv *priv)
 
 	/* Set rssi values to dBm */
 	hw->flags |= IEEE80211_HW_SIGNAL_DBM | IEEE80211_HW_HAS_RATE_CONTROL;
+
+	/*
+	 * Ask mac80211 to not to trigger PS mode
+	 * based on PM bit of incoming frames.
+	 */
+	if (priv->ap_fw)
+		hw->flags |= IEEE80211_HW_AP_LINK_PS;
+
 	hw->vif_data_size = sizeof(struct mwl8k_vif);
 	hw->sta_data_size = sizeof(struct mwl8k_sta);
 
-- 
1.5.4.1

