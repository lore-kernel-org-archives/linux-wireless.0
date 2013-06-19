Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from diserzione.investici.org ([82.221.99.153]:44106 "EHLO
	diserzione.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934052Ab3FSLhi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 07:37:38 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [PATCH mac80211-next] brcm80211: fix null pointer access
Date: Wed, 19 Jun 2013 13:35:31 +0200
Message-Id: <1371641731-1297-1-git-send-email-ordex@autistici.org> (sfid-20130619_133742_645109_8CCE56D2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

Do not unconditionally access the chan variable in
brcmf_cfg80211_mgmt_tx() as it may be NULL.
Use freq instead.

Introduced by c2ff8cad64233b539c71a27e2a6e324001143ef0
("brcm80211: make mgmt_tx in brcmfmac accept a NULL channel")

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 8bd256b..d316d62 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3985,8 +3985,7 @@ brcmf_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		       le16_to_cpu(action_frame->len));
 
 		brcmf_dbg(TRACE, "Action frame, cookie=%lld, len=%d, freq=%d\n",
-			  *cookie, le16_to_cpu(action_frame->len),
-			  chan->center_freq);
+			  *cookie, le16_to_cpu(action_frame->len), freq);
 
 		ack = brcmf_p2p_send_action_frame(cfg, cfg_to_ndev(cfg),
 						  af_params);
-- 
1.8.1.5

