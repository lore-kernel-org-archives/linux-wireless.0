Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:35974 "EHLO
	mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982AbbK0Iha (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2015 03:37:30 -0500
Received: by lfs39 with SMTP id 39so118583239lfs.3
        for <linux-wireless@vger.kernel.org>; Fri, 27 Nov 2015 00:37:29 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, nbd@openwrt.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 06/13] ath9k: setup correct skb priority for nullfunc
Date: Fri, 27 Nov 2015 09:37:11 +0100
Message-Id: <1448613438-5173-6-git-send-email-janusz.dziedzic@tieto.com> (sfid-20151127_093737_689862_4CA36FDA)
In-Reply-To: <1448613438-5173-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1448613438-5173-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After queue nullfunc for MCC case, we hit WARN_ON
in xmit.c:2398 while skb priority wasn't set.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 28bbbef..2afb8da 100644
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

