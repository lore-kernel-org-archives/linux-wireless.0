Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.u-psud.fr ([129.175.33.42]:27840 "EHLO smtp2.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035Ab2GDJNw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 05:13:52 -0400
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2] mac80211: tx: do not drop non-robust mgmt to non-MFP stas.
Date: Wed,  4 Jul 2012 11:13:41 +0200
Message-Id: <1341393221-5396-1-git-send-email-cavallar@lri.fr> (sfid-20120704_111406_891380_AA2BED18)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When drop_unencrypted is enabled and MFP is disabled, non-robust
management frames for not-yet associated STA are dropped  before
being transmitted.

This isn't visible as many management frames sent from  the kernel
have TX_INTFL_DONT_ENCRYPT set and management frames injected from
monitor vifs have TX_CTL_INJECTED set, so are never dropped in the
tx path. But mgmt frames sent from userspace via NL80211_CMD_FRAME
do not have any of these flags, so are dropped.

This patch make it accept non-robust management frames,
but drops non-management frames and robust management frames as usual.

Signed-off-by: Nicolas Cavallari <cavallar@lri.fr>

---

Found this while trying to manage auth  frames in userspace
on a IBSS RSN network.
I'm  a bit surprised that drop_unencrypted is disabled both
in AP and managed mode, but only enabled in IBSS RSN, which
does not support MFP, yet.

patch based on linux-wireless 565e1fc.

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 4990f4f..97682e0 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -545,6 +545,8 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 	else if (tx->sdata->drop_unencrypted &&
 		 (tx->skb->protocol != tx->sdata->control_port_protocol) &&
 		 !(info->flags & IEEE80211_TX_CTL_INJECTED) &&
+		 (!ieee80211_is_mgmt(hdr->frame_control) ||
+		  ieee80211_is_robust_mgmt_frame(hdr)) &&
 		 (!ieee80211_is_robust_mgmt_frame(hdr) ||
 		  (ieee80211_is_action(hdr->frame_control) &&
 		   tx->sta && test_sta_flag(tx->sta, WLAN_STA_MFP)))) {
-- 
1.7.10.4

