Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50908 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1758122AbdLRKOM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Dec 2017 05:14:12 -0500
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Adiel Aloni <adiel.aloni@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 18 Dec 2017 12:14:04 +0200
Message-Id: <20171218101405.9330-2-luca@coelho.fi> (sfid-20171218_111423_057361_AC090D5B)
In-Reply-To: <20171218101405.9330-1-luca@coelho.fi>
References: <20171218101405.9330-1-luca@coelho.fi>
Subject: [PATCH 1/2] mac80211_hwsim: enable TODS BIT in null data frame
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Adiel Aloni <adiel.aloni@intel.com>

Same as in ieee80211_nullfunc_get, enable the TODS bit, otherwise the
nullfunc packet will not be handled in ap rx path.
(will be dropped in ieee80211_accept_frame()).

Signed-off-by: Adiel Aloni <adiel.aloni@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 45cca54c05bf..3141b8e28b34 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -684,6 +684,7 @@ static void hwsim_send_nullfunc(struct mac80211_hwsim_data *data, u8 *mac,
 	hdr = skb_put(skb, sizeof(*hdr) - ETH_ALEN);
 	hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_DATA |
 					 IEEE80211_STYPE_NULLFUNC |
+					 IEEE80211_FCTL_TODS |
 					 (ps ? IEEE80211_FCTL_PM : 0));
 	hdr->duration_id = cpu_to_le16(0);
 	memcpy(hdr->addr1, vp->bssid, ETH_ALEN);
-- 
2.15.1
