Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A277C43219
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 06:41:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A894206DD
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 06:41:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="R3NwH/k7";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="R3NwH/k7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbfDZGlV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 02:41:21 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53540 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbfDZGlU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 02:41:20 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EE65A607EB; Fri, 26 Apr 2019 06:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556260879;
        bh=snHt1zZnlCOet6D7tR9i7A1sc/XYSmTmIdk/h9mbjc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R3NwH/k7c+/oxUVFRC2pM/7Z4IOUtaAksaf/kNzQiJcGD74A7t9y0DxInEFUfu7h7
         W/jbjR1JeIC44oC7TDWOOlrlas9LQ5nURJEOZrlRSKF/5Bt0CrDmzWd1PLowj9Fln6
         go6O1MIc85cWhehSJrjBtIe2sfAda5KDTmmi8kmo=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5DED56076C;
        Fri, 26 Apr 2019 06:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556260879;
        bh=snHt1zZnlCOet6D7tR9i7A1sc/XYSmTmIdk/h9mbjc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R3NwH/k7c+/oxUVFRC2pM/7Z4IOUtaAksaf/kNzQiJcGD74A7t9y0DxInEFUfu7h7
         W/jbjR1JeIC44oC7TDWOOlrlas9LQ5nURJEOZrlRSKF/5Bt0CrDmzWd1PLowj9Fln6
         go6O1MIc85cWhehSJrjBtIe2sfAda5KDTmmi8kmo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5DED56076C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, Wen Gong <wgong@codeaurora.org>
Subject: [PATCH 2/5] ath10k: add handler for HTT_T2H_MSG_TYPE_SEC_IND event
Date:   Fri, 26 Apr 2019 09:41:08 +0300
Message-Id: <1556260871-2919-3-git-send-email-kvalo@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556260871-2919-1-git-send-email-kvalo@codeaurora.org>
References: <1556260871-2919-1-git-send-email-kvalo@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Wen Gong <wgong@codeaurora.org>

Add the handler for HTT_T2H_MSG_TYPE_SEC_IND event from firmware, which stores
PN for replay check implemented in the following patch.

Tested on QCA6174 SDIO with firmware WLAN.RMH.4.4.1-00007-QCARMSWP-1.

Signed-off-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 46 ++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index f22840bbc389..cc2875d73bf0 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -3267,6 +3267,51 @@ static void ath10k_fetch_10_2_tx_stats(struct ath10k *ar, u8 *data)
 	rcu_read_unlock();
 }
 
+static int ath10k_htt_rx_pn_len(enum htt_security_types sec_type)
+{
+	switch (sec_type) {
+	case HTT_SECURITY_TKIP:
+	case HTT_SECURITY_TKIP_NOMIC:
+	case HTT_SECURITY_AES_CCMP:
+		return 48;
+	default:
+		return 0;
+	}
+}
+
+static void ath10k_htt_rx_sec_ind_handler(struct ath10k *ar,
+					  struct htt_security_indication *ev)
+{
+	enum htt_txrx_sec_cast_type sec_index;
+	enum htt_security_types sec_type;
+	struct ath10k_peer *peer;
+
+	spin_lock_bh(&ar->data_lock);
+
+	peer = ath10k_peer_find_by_id(ar, __le16_to_cpu(ev->peer_id));
+	if (!peer) {
+		ath10k_warn(ar, "failed to find peer id %d for security indication",
+			    __le16_to_cpu(ev->peer_id));
+		goto out;
+	}
+
+	sec_type = MS(ev->flags, HTT_SECURITY_TYPE);
+
+	if (ev->flags & HTT_SECURITY_IS_UNICAST)
+		sec_index = HTT_TXRX_SEC_UCAST;
+	else
+		sec_index = HTT_TXRX_SEC_MCAST;
+
+	peer->rx_pn[sec_index].sec_type = sec_type;
+	peer->rx_pn[sec_index].pn_len = ath10k_htt_rx_pn_len(sec_type);
+
+	memset(peer->tids_last_pn_valid, 0, sizeof(peer->tids_last_pn_valid));
+	memset(peer->tids_last_pn, 0, sizeof(peer->tids_last_pn));
+
+out:
+	spin_unlock_bh(&ar->data_lock);
+}
+
 bool ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct ath10k_htt *htt = &ar->htt;
@@ -3360,6 +3405,7 @@ bool ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		struct ath10k *ar = htt->ar;
 		struct htt_security_indication *ev = &resp->security_indication;
 
+		ath10k_htt_rx_sec_ind_handler(ar, ev);
 		ath10k_dbg(ar, ATH10K_DBG_HTT,
 			   "sec ind peer_id %d unicast %d type %d\n",
 			  __le16_to_cpu(ev->peer_id),
-- 
2.7.4

