Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41317 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbYLATde (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 14:33:34 -0500
Subject: [PATCH] iwlwifi: disable AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 01 Dec 2008 18:50:27 +0100
Message-Id: <1228153827.10627.25.camel@johannes.berg> (sfid-20081201_203337_124543_D451073B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwlwifi does not support AP mode in any way. For one, it doesn't even
buffer multicast/broadcast frames properly. We didn't allow zd1211rw AP
mode to be enabled without this, so iwlwifi shouldn't be allowed to
advertise AP mode either.

It also doesn't work at all, it doesn't even answer to probe requests,
I'm guessing the packet injection code was disabled again.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
FYI, I've also tested AP mode on iwl5000 and it most definitely does not
work properly:

[  471.524478] iwlagn: ERROR: APs don't scan

this is a long-standing bug, of course APs scan to know their
surroundings, not sure why this is there, it's also very pointless since
I can remove it by enabling software scan...

[  487.507346] iwlagn: Microcode SW error detected.  Restarting 0x2000000.

apparently even the microcode doesn't like AP mode :) Note that I've
done nothing out of the ordinary, just started hostapd.

Once somebody cares to fix the code these two lines can be put back
easily, I haven't ripped out the actual support code. But when you do
please test with PS clients and multicast traffic.

 drivers/net/wireless/iwlwifi/iwl-core.c     |    1 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 -
 2 files changed, 2 deletions(-)

--- everything.orig/drivers/net/wireless/iwlwifi/iwl-core.c	2008-12-01 18:34:29.000000000 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl-core.c	2008-12-01 18:34:31.000000000 +0100
@@ -808,7 +808,6 @@ int iwl_setup_mac(struct iwl_priv *priv)
 		    IEEE80211_HW_NOISE_DBM |
 		    IEEE80211_HW_AMPDU_AGGREGATION;
 	hw->wiphy->interface_modes =
-		BIT(NL80211_IFTYPE_AP) |
 		BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC);
 
--- everything.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-12-01 18:34:06.000000000 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-12-01 18:34:22.000000000 +0100
@@ -7861,7 +7861,6 @@ static int iwl3945_pci_probe(struct pci_
 		    IEEE80211_HW_NOISE_DBM;
 
 	hw->wiphy->interface_modes =
-		BIT(NL80211_IFTYPE_AP) |
 		BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC);
 


