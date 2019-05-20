Return-Path: <SRS0=gKIL=TU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFF1AC04E87
	for <linux-wireless@archiver.kernel.org>; Mon, 20 May 2019 08:55:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C062D204FD
	for <linux-wireless@archiver.kernel.org>; Mon, 20 May 2019 08:55:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731680AbfETIzZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 20 May 2019 04:55:25 -0400
Received: from nbd.name ([46.4.11.11]:41470 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731671AbfETIzX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 May 2019 04:55:23 -0400
Received: from p548c87ba.dip0.t-ipconnect.de ([84.140.135.186] helo=bertha.datto.lan)
        by ds12 with esmtpa (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1hSe4l-0002Y7-GY; Mon, 20 May 2019 10:55:19 +0200
From:   John Crispin <john@phrozen.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Shashidhar Lakkavalli <slakkavalli@datto.com>
Subject: [PATCH V5 7/8] ath11k: handle rx status for HE frames
Date:   Mon, 20 May 2019 10:55:07 +0200
Message-Id: <20190520085508.5888-8-john@phrozen.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190520085508.5888-1-john@phrozen.org>
References: <20190520085508.5888-1-john@phrozen.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The case clause handling HE frames was not handled yet in the code reading
the RX status. The new case is identical to VHT with the difference of the
higher maximum MCS rate.

Signed-off-by: Shashidhar Lakkavalli <slakkavalli@datto.com>
Signed-off-by: John Crispin <john@phrozen.org>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index e52a54cd2b79..71d385cf55d7 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -1727,7 +1727,16 @@ static void ath11k_dp_rx_h_rate(struct ath11k *ar, void *rx_desc,
 		rx_status->bw = ath11k_bw_to_mac80211_bw(bw);
 		break;
 	case RX_MSDU_START_PKT_TYPE_11AX:
-		ath11k_warn(ar->ab, "pkt_type %d not yet supported\n", pkt_type);
+		rx_status->rate_idx = rate_mcs;
+		if (rate_mcs > ATH11K_HE_MCS_MAX) {
+			ath11k_warn(ar->ab,
+				    "Received with invalid mcs in HE mode %d\n",
+				    rate_mcs);
+			break;
+		}
+		rx_status->encoding = RX_ENC_HE;
+		rx_status->nss = nss;
+		rx_status->bw = ath11k_bw_to_mac80211_bw(bw);
 		break;
 	}
 }
-- 
2.20.1

