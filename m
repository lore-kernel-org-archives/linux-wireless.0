Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:41874 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751586AbdLBJyT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Dec 2017 04:54:19 -0500
Received: by mail-pf0-f194.google.com with SMTP id j28so5731792pfk.8
        for <linux-wireless@vger.kernel.org>; Sat, 02 Dec 2017 01:54:18 -0800 (PST)
Date: Sat, 2 Dec 2017 17:54:13 +0800
From: Kenneth Lu <kuohsianglu@gmail.com>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath6kl@lists.infradead.org
Subject: [PATCH] ath6kl: improve endianness handling
Message-ID: <20171202095413.GA12091@blackstone> (sfid-20171202_105423_008906_76263F16)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace ntohs with be16_to_cpu to do endian conversions for ethhdr
h_proto assignment.

Signed-off-by: Kenneth Lu <kuohsianglu@gmail.com>
---
 drivers/net/wireless/ath/ath6kl/txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 1379906..8da9506 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -1001,7 +1001,7 @@ static void aggr_slice_amsdu(struct aggr_info *p_aggr,
 
 	while (amsdu_len > mac_hdr_len) {
 		hdr = (struct ethhdr *) framep;
-		payload_8023_len = ntohs(hdr->h_proto);
+		payload_8023_len = be16_to_cpu(hdr->h_proto);
 
 		if (payload_8023_len < MIN_MSDU_SUBFRAME_PAYLOAD_LEN ||
 		    payload_8023_len > MAX_MSDU_SUBFRAME_PAYLOAD_LEN) {
-- 
2.7.4
