Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:53462 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932540AbZHLLHb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 07:07:31 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH] iwl3945: fix compilation error in
	iwl3945_pass_packet_to_mac80211()
To: linville@tuxdriver.com
Cc: reinette.chatre@intel.com, linux-wireless@vger.kernel.org
Date: Wed, 12 Aug 2009 14:07:27 +0300
Message-ID: <20090812110727.4963.99515.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit "iwlwifi: Traffic type and counter for debugFs" broke iwl3945 in
a case when CONFIG_IWLWIFI_LEDS is disabled:

drivers/net/wireless/iwlwifi/iwl-3945.c:580: error: 'hdr' undeclared (first use in this function)

Fix it by removing the ifdef check for hdr variable.

Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
---

 drivers/net/wireless/iwlwifi/iwl-3945.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index ae7f163..ba5ef83 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -544,9 +544,7 @@ static void iwl3945_pass_packet_to_mac80211(struct iwl_priv *priv,
 				   struct ieee80211_rx_status *stats)
 {
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
-#ifdef CONFIG_IWLWIFI_LEDS
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)IWL_RX_DATA(pkt);
-#endif
 	struct iwl3945_rx_frame_hdr *rx_hdr = IWL_RX_HDR(pkt);
 	struct iwl3945_rx_frame_end *rx_end = IWL_RX_END(pkt);
 	short len = le16_to_cpu(rx_hdr->len);

