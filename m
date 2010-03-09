Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:22107 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753088Ab0CIHzv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Mar 2010 02:55:51 -0500
Received: from vs3002.wh2.ocn.ne.jp (125.206.180.165)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-085521350
	for <linux-wireless@vger.kernel.org>; Tue,  9 Mar 2010 16:55:50 +0900 (JST)
Subject: [PATCH 07/13] ath5k: remove ah_mac_revision
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Tue, 09 Mar 2010 16:55:49 +0900
Message-ID: <20100309075549.30616.4609.stgit@void>
In-Reply-To: <20100309075124.30616.40896.stgit@void>
References: <20100309075124.30616.40896.stgit@void>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

it's not used, and we have ah_mac_srev.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/ath5k.h  |    1 -
 drivers/net/wireless/ath/ath5k/attach.c |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 3d63511..54f35ae 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1047,7 +1047,6 @@ struct ath5k_hw {
 	u32			ah_phy;
 	u32			ah_mac_srev;
 	u16			ah_mac_version;
-	u16			ah_mac_revision;
 	u16			ah_phy_revision;
 	u16			ah_radio_5ghz_revision;
 	u16			ah_radio_2ghz_revision;
diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index 66758cb..dd4099a 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -148,7 +148,6 @@ int ath5k_hw_attach(struct ath5k_softc *sc)
 	/* Get MAC, PHY and RADIO revisions */
 	ah->ah_mac_srev = srev;
 	ah->ah_mac_version = AR5K_REG_MS(srev, AR5K_SREV_VER);
-	ah->ah_mac_revision = AR5K_REG_MS(srev, AR5K_SREV_REV);
 	ah->ah_phy_revision = ath5k_hw_reg_read(ah, AR5K_PHY_CHIP_ID) &
 			0xffffffff;
 	ah->ah_radio_5ghz_revision = ath5k_hw_radio_revision(ah,

