Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49836 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbXJ1NwR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2007 09:52:17 -0400
Subject: [PATCH] iwlwifi: select proper rate control algorithm
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Zhu Yi <yi.zhu@intel.com>
Content-Type: text/plain
Date: Sun, 28 Oct 2007 14:53:36 +0100
Message-Id: <1193579616.5197.13.camel@johannes.berg> (sfid-20071028_135220_635543_907F7A1D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prior to this patch, iwlwifi would always use the first
registered rate control algorithm which, depending on system
setup, could be anything. After the mac80211 patch to make
the simple algorithm built-in, it would always be simple.

This has always been a bug in iwlwifi.

This fixes it by requesting that mac80211 selects the right
rate control algorithm.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
Untested, and the iwlwifi base code that registers rate control
algorithms is a *total* mess. They should only be registered once at
module load rather than at hardware probe time! Hence, I have no idea
whether this will suffice or if rate control algorithm initialisation
has to be rewritten.

 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 ++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 ++
 2 files changed, 4 insertions(+)

--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2007-10-28 14:31:02.845330022 +0100
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl3945-base.c	2007-10-28 14:31:54.255349989 +0100
@@ -8317,6 +8317,8 @@ static int iwl_pci_probe(struct pci_dev 
 	}
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 
+	hw->rate_control_algorithm = "iwl-3945-rs";
+
 	IWL_DEBUG_INFO("*** LOAD DRIVER ***\n");
 	priv = hw->priv;
 	priv->hw = hw;
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c	2007-10-28 14:31:03.005056368 +0100
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl4965-base.c	2007-10-28 14:32:07.735049425 +0100
@@ -8918,6 +8918,8 @@ static int iwl_pci_probe(struct pci_dev 
 	}
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 
+	hw->rate_control_algorithm = "iwl-4965-rs";
+
 	IWL_DEBUG_INFO("*** LOAD DRIVER ***\n");
 	priv = hw->priv;
 	priv->hw = hw;


