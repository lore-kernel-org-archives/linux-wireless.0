Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:34293 "EHLO
	mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982AbbK0Ih1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2015 03:37:27 -0500
Received: by lffu14 with SMTP id u14so121540119lff.1
        for <linux-wireless@vger.kernel.org>; Fri, 27 Nov 2015 00:37:25 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, nbd@openwrt.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 03/13] ath9k: queue null frames in case of MCC
Date: Fri, 27 Nov 2015 09:37:08 +0100
Message-Id: <1448613438-5173-3-git-send-email-janusz.dziedzic@tieto.com> (sfid-20151127_093731_053498_A3CDBB5B)
In-Reply-To: <1448613438-5173-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1448613438-5173-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While mac80211 using null frames when connection polling,
we should queue this frames while NOA could be there, and
AP, P2P_GO could be not present.

Without this patch, with no traffic we often saw disconnections
while we try to send nullfunc when AP/GO wasn't present.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 26698a6..82fc76f 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2331,6 +2331,12 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 
 	queue = ieee80211_is_data_present(hdr->frame_control);
 
+	/* If chanctx, queue all null frames while NOA could be there */
+	if (ath9k_is_chanctx_enabled() &&
+	    ieee80211_is_nullfunc(hdr->frame_control) &&
+	    !txctl->force_channel)
+		queue = true;
+
 	/* Force queueing of all frames that belong to a virtual interface on
 	 * a different channel context, to ensure that they are sent on the
 	 * correct channel.
-- 
1.9.1

