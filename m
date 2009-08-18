Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:40183 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756622AbZHRDwp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 23:52:45 -0400
Date: Tue, 18 Aug 2009 05:52:46 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 11/29] mwl8k: ->add_interface() is not called for monitor interfaces
Message-ID: <20090818035246.GP18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no need to check for NL80211_IFTYPE_MONITOR in
->add_interface(), as this function is never called for monitor
interfaces.  Also, there is no need to advertise this bit in our
wiphy's ->interface_modes.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index e266bc1..4580b1d 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2883,8 +2883,7 @@ static int mwl8k_add_interface(struct ieee80211_hw *hw,
 	/*
 	 * We only support managed interfaces for now.
 	 */
-	if (conf->type != NL80211_IFTYPE_STATION &&
-	    conf->type != NL80211_IFTYPE_MONITOR)
+	if (conf->type != NL80211_IFTYPE_STATION)
 		return -EINVAL;
 
 	/* Clean out driver private area */
@@ -3444,8 +3443,7 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 
 	hw->queues = MWL8K_TX_QUEUES;
 
-	hw->wiphy->interface_modes =
-		BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_MONITOR);
+	hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 
 	/* Set rssi and noise values to dBm */
 	hw->flags |= IEEE80211_HW_SIGNAL_DBM | IEEE80211_HW_NOISE_DBM;
-- 
1.5.6.4
