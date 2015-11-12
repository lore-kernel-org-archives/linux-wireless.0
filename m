Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:33221 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbbKLNQS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2015 08:16:18 -0500
Received: by lbbkw15 with SMTP id kw15so34771820lbb.0
        for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2015 05:16:17 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 06/12] ath9k: setup correct skb priority for nullfunc
Date: Thu, 12 Nov 2015 14:15:43 +0100
Message-Id: <1447334149-15507-6-git-send-email-janusz.dziedzic@tieto.com> (sfid-20151112_141623_993974_7202A00D)
In-Reply-To: <1447334149-15507-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1447334149-15507-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After queue nullfunc for MCC case, we hit WARN_ON
in xmit.c:2398 while skb priority wasn't set.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index d86566b..4f60ddb 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -1101,6 +1101,7 @@ ath_chanctx_send_vif_ps_frame(struct ath_softc *sc, struct ath_vif *avp,
 			nullfunc->frame_control |=
 				cpu_to_le16(IEEE80211_FCTL_PM);
 
+		skb->priority = 7;
 		skb_set_queue_mapping(skb, IEEE80211_AC_VO);
 		if (!ieee80211_tx_prepare_skb(sc->hw, vif, skb, band, &sta)) {
 			dev_kfree_skb_any(skb);
-- 
1.9.1

