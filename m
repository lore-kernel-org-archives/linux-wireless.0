Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f45.google.com ([209.85.215.45]:63673 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758448Ab0LCEMk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 23:12:40 -0500
Received: by ewy10 with SMTP id 10so5229020ewy.4
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 20:12:39 -0800 (PST)
Date: Fri, 3 Dec 2010 06:12:39 +0200
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org,
	sedat.dilek@googlemail.com
Subject: [PATCH 6/6] ath5k: Include tx ack reporting on hw flags
Message-ID: <20101203041239.GF2988@makis.mantri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Since we report tx acks to the protocol stack, add the needed
 flag to hw_flags. This way we'll also use the new AP probing mechanism.

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
 drivers/net/wireless/ath/ath5k/base.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index e68f248..cb4ecfa 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2341,8 +2341,9 @@ ath5k_init_softc(struct ath5k_softc *sc, const struct ath_bus_ops *bus_ops)
 	/* Initialize driver private data */
 	SET_IEEE80211_DEV(hw, sc->dev);
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
-		    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-		    IEEE80211_HW_SIGNAL_DBM;
+			IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
+			IEEE80211_HW_SIGNAL_DBM |
+			IEEE80211_HW_REPORTS_TX_ACK_STATUS;
 
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_AP) |
