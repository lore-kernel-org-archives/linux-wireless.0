Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41592 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499Ab0KZKiH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Nov 2010 05:38:07 -0500
Subject: [PATCH 2.6.37?] ath9k/carl9170: advertise P2P
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Nov 2010 11:38:04 +0100
Message-ID: <1290767884.3531.21.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

With some upcoming changes we'd like to use
the interface types for P2P capability tests.
Enable them now so that when we add those
tests in wpa_supplicant, nothing will break.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
I know it's rather late for 2.6.37, but it would
help tremendously to have it in because then that
kernel would be the first one having P2P enabled
(at least for ath9k and carl9170) and it's the
only backward-incompatible change I intend to make
still.

 drivers/net/wireless/ath/ath9k/init.c    |    2 ++
 drivers/net/wireless/ath/carl9170/fw.c   |    3 ++-
 drivers/net/wireless/ath/carl9170/main.c |    3 ++-
 3 files changed, 6 insertions(+), 2 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/init.c	2010-11-25 08:00:40.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/ath9k/init.c	2010-11-25 08:02:11.000000000 +0100
@@ -657,6 +657,8 @@ void ath9k_set_hw_capab(struct ath_softc
 		hw->flags |= IEEE80211_HW_MFP_CAPABLE;
 
 	hw->wiphy->interface_modes =
+		BIT(NL80211_IFTYPE_P2P_GO) |
+		BIT(NL80211_IFTYPE_P2P_CLIENT) |
 		BIT(NL80211_IFTYPE_AP) |
 		BIT(NL80211_IFTYPE_WDS) |
 		BIT(NL80211_IFTYPE_STATION) |
--- wireless-testing.orig/drivers/net/wireless/ath/carl9170/fw.c	2010-11-26 11:35:48.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/carl9170/fw.c	2010-11-26 11:35:59.000000000 +0100
@@ -291,7 +291,8 @@ static int carl9170_fw(struct ar9170 *ar
 
 		if (SUPP(CARL9170FW_WLANTX_CAB)) {
 			ar->hw->wiphy->interface_modes |=
-				BIT(NL80211_IFTYPE_AP);
+				BIT(NL80211_IFTYPE_AP) |
+				BIT(NL80211_IFTYPE_P2P_GO);
 		}
 	}
 
--- wireless-testing.orig/drivers/net/wireless/ath/carl9170/main.c	2010-11-26 11:35:25.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/carl9170/main.c	2010-11-26 11:35:41.000000000 +0100
@@ -1648,7 +1648,8 @@ void *carl9170_alloc(size_t priv_size)
 	 * supports these modes. The code which will add the
 	 * additional interface_modes is in fw.c.
 	 */
-	hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
+	hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
+				     BIT(NL80211_IFTYPE_P2P_CLIENT);
 
 	hw->flags |= IEEE80211_HW_RX_INCLUDES_FCS |
 		     IEEE80211_HW_REPORTS_TX_ACK_STATUS |


