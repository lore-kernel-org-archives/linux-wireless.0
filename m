Return-Path: <SRS0=nAss=VM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62F64C7618F
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Jul 2019 13:41:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F1112080A
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Jul 2019 13:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563198090;
	bh=FMLCJaIguW6YWjuMGHKMm+W18reEkOZbzo2vwzvBfvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=XuD61CnMaA18pl3b/7bTW8wtK0TQNXR6bhWEZjVisM2ZxwOyb3GYQ5ZrkR0MIxNNf
	 jVVEnD3wpmEtKkXruXIhZ6/spd3FyEcg7gseeNpDhCwfyC84dkq+2Kj+f1MUPA3PfW
	 EVqaLbbaYIAKFldn2QteKpM4G/wUpl5KIjutQl3Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731109AbfGONi5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Jul 2019 09:38:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731091AbfGONiz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jul 2019 09:38:55 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3564F212F5;
        Mon, 15 Jul 2019 13:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563197933;
        bh=FMLCJaIguW6YWjuMGHKMm+W18reEkOZbzo2vwzvBfvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u6+9C0WOj7oij6vrVkXMRLagGrLd/hkjHWIYipYZ5qWsUuQp7MyoI4TLwIwRLux2d
         vcfDKTws3seM8ccefXqiTmxmLy+4ZhBBITJyPlugmtSYVKMQW/gCqwbjq5XAcwBtcv
         DTNL+4l278QEiiGS/Jyy5zgB/89/lNZWV+o8g1yY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rakesh Pillai <pillair@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 016/219] ath10k: Fix encoding for protected management frames
Date:   Mon, 15 Jul 2019 09:34:48 -0400
Message-Id: <20190715133811.2441-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715133811.2441-1-sashal@kernel.org>
References: <20190715133811.2441-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Rakesh Pillai <pillair@codeaurora.org>

[ Upstream commit 42f1bc43e6a97b9ddbe976eba9bd05306c990c75 ]

Currently the protected management frames are
not appended with the MIC_LEN which results in
the protected management frames being encoded
incorrectly.

Add the extra space at the end of the protected
management frames to fix this encoding error for
the protected management frames.

Tested HW: WCN3990
Tested FW: WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1

Fixes: 1807da49733e ("ath10k: wmi: add management tx by reference support over wmi")
Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 582fb11f648a..02709fc99034 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -2840,8 +2840,10 @@ ath10k_wmi_tlv_op_gen_mgmt_tx_send(struct ath10k *ar, struct sk_buff *msdu,
 	if ((ieee80211_is_action(hdr->frame_control) ||
 	     ieee80211_is_deauth(hdr->frame_control) ||
 	     ieee80211_is_disassoc(hdr->frame_control)) &&
-	     ieee80211_has_protected(hdr->frame_control))
+	     ieee80211_has_protected(hdr->frame_control)) {
+		skb_put(msdu, IEEE80211_CCMP_MIC_LEN);
 		buf_len += IEEE80211_CCMP_MIC_LEN;
+	}
 
 	buf_len = min_t(u32, buf_len, WMI_TLV_MGMT_TX_FRAME_MAX_LEN);
 	buf_len = round_up(buf_len, 4);
-- 
2.20.1

