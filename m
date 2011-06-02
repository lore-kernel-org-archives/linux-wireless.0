Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43708 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148Ab1FBRiv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 13:38:51 -0400
Subject: [PATCH] iwlagn: fix interface combinations
From: Johannes Berg <johannes@sipsolutions.net>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1307033971.14344.4.camel@wwguy-ubuntu> (sfid-20110602_190304_456523_2AAB1F56)
References: <1306510833-32049-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1306510833-32049-8-git-send-email-wey-yi.w.guy@intel.com>
	 <20110602162241.GE4580@redhat.com>  <1307033971.14344.4.camel@wwguy-ubuntu>
	 (sfid-20110602_190304_456523_2AAB1F56)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Jun 2011 19:38:43 +0200
Message-ID: <1307036323.3738.3.camel@jlt3.sipsolutions.net> (sfid-20110602_193854_217992_F2A81D94)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

My patch to advertise interface combinations
worked by pure luck in the P2P case, but all
other cases are broken. This is due to a dumb
mistake in the code that checks what should
be advertised, fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Alternatively, this fixes it. Sorry.

 drivers/net/wireless/iwlwifi/iwl-agn.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn.c	2011-06-02 19:36:58.000000000 +0200
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c	2011-06-02 19:37:09.000000000 +0200
@@ -2533,11 +2533,11 @@ static int iwl_mac_setup_register(struct
 
 	BUILD_BUG_ON(NUM_IWL_RXON_CTX != 2);
 
-	if (hw->wiphy->interface_modes & NL80211_IFTYPE_P2P_CLIENT) {
+	if (hw->wiphy->interface_modes & BIT(NL80211_IFTYPE_P2P_CLIENT)) {
 		hw->wiphy->iface_combinations = iwlagn_iface_combinations_p2p;
 		hw->wiphy->n_iface_combinations =
 			ARRAY_SIZE(iwlagn_iface_combinations_p2p);
-	} else if (hw->wiphy->interface_modes & NL80211_IFTYPE_AP) {
+	} else if (hw->wiphy->interface_modes & BIT(NL80211_IFTYPE_AP)) {
 		hw->wiphy->iface_combinations = iwlagn_iface_combinations_dualmode;
 		hw->wiphy->n_iface_combinations =
 			ARRAY_SIZE(iwlagn_iface_combinations_dualmode);



