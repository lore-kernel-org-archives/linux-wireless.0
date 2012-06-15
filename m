Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.u-psud.fr ([129.175.33.42]:47198 "EHLO smtp2.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932261Ab2FOQdt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2012 12:33:49 -0400
Received: from smtp2.u-psud.fr (localhost [127.0.0.1])
	by localhost (MTA) with SMTP id 0DFC334D654
	for <linux-wireless@vger.kernel.org>; Fri, 15 Jun 2012 18:33:48 +0200 (CEST)
Received: from ext.lri.fr (ext.lri.fr [129.175.15.4])
	by smtp2.u-psud.fr (MTA) with ESMTP id E1EF134D660
	for <linux-wireless@vger.kernel.org>; Fri, 15 Jun 2012 18:33:47 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by ext.lri.fr (Postfix) with ESMTP id E16544084F
	for <linux-wireless@vger.kernel.org>; Fri, 15 Jun 2012 18:33:47 +0200 (CEST)
Received: from ext.lri.fr ([127.0.0.1])
	by localhost (ext.lri.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Mh4K86FueHKq for <linux-wireless@vger.kernel.org>;
	Fri, 15 Jun 2012 18:33:47 +0200 (CEST)
Received: from smtp-ng.lri.fr (smtp [129.175.3.73])
	by ext.lri.fr (Postfix) with ESMTP id C1D303FE9D
	for <linux-wireless@vger.kernel.org>; Fri, 15 Jun 2012 18:33:47 +0200 (CEST)
Received: from [129.175.25.36] (lri25-36 [129.175.25.36])
	by smtp-ng.lri.fr (Postfix) with ESMTP id AFA5C60F4D
	for <linux-wireless@vger.kernel.org>; Fri, 15 Jun 2012 18:33:47 +0200 (CEST)
Message-ID: <4FDB63EC.5030802@lri.fr> (sfid-20120615_183353_188178_21C243A0)
Date: Fri, 15 Jun 2012 18:33:48 +0200
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [resent to correct list address][RFC] mac80211: tx: do not drop management
 frames to non-MFP STA.
References: <1339777624-27826-1-git-send-email-cavallar@lri.fr>
In-Reply-To: <1339777624-27826-1-git-send-email-cavallar@lri.fr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When drop_unencrypted is enabled and MFP is disabled,
non-robust management frames for not-yet associated STA are dropped.
This isn't visible as many management frames sent from the kernel
have TX_INTFL_DONT_ENCRYPT set and management frames injected
from a monitor vif have TX_CTL_INJECTED so aren't dropped.
But management frames sent from userspace via NL80211_CMD_FRAME
do not have this flag set, so are dropped.

This patch make it drop non-management frames as usual, but
only MFP STA are subject to drops when drop_unencrypted is set to 1.

This shouldn't break anything, as drop_unencrypted is only enabled
in IBSS mode when PRIVACY is requested.

Signed-off-by: Nicolas Cavallari <cavallar@lri.fr>

---

Found this while trying to handle auth frames in userspace
on a IBSS RSN network.
I'm a bit surprised that drop_unencrypted is disabled both
in AP and managed mode, but only enabled in IBSS RSN, which
does not support MFP yet, so the MFP handling is somewhat useless for now.

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index af25c4e..9f61e64 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -558,9 +558,10 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 	else if (tx->sdata->drop_unencrypted &&
 		 (tx->skb->protocol != tx->sdata->control_port_protocol) &&
 		 !(info->flags & IEEE80211_TX_CTL_INJECTED) &&
-		 (!ieee80211_is_robust_mgmt_frame(hdr) ||
-		  (ieee80211_is_action(hdr->frame_control) &&
-		   tx->sta && test_sta_flag(tx->sta, WLAN_STA_MFP)))) {
+		 (!ieee80211_is_mgmt(hdr->frame_control) ||
+		  (!ieee80211_is_robust_mgmt_frame(hdr) ||
+		   ieee80211_is_action(hdr->frame_control)) &&
+		   tx->sta && test_sta_flag(tx->sta, WLAN_STA_MFP))) {
 		I802_DEBUG_INC(tx->local->tx_handlers_drop_unencrypted);
 		return TX_DROP;
 	} else
-- 1.7.10.4
