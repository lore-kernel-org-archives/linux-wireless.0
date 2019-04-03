Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C21B4C4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 19:30:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FA9D2084B
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 19:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbfDCTah (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 15:30:37 -0400
Received: from gateway20.websitewelcome.com ([192.185.65.13]:40464 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726151AbfDCTah (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 15:30:37 -0400
X-Greylist: delayed 1367 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Apr 2019 15:30:37 EDT
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id 20EC3400ED61C
        for <linux-wireless@vger.kernel.org>; Wed,  3 Apr 2019 14:06:38 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id BlDahcJNdiQerBlDahNIT6; Wed, 03 Apr 2019 14:06:38 -0500
X-Authority-Reason: nr=8
Received: from [189.250.114.183] (port=48104 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1hBlDZ-0033Pm-BZ; Wed, 03 Apr 2019 14:06:37 -0500
Date:   Wed, 3 Apr 2019 14:06:36 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] ath10k: coredump: use struct_size() helper
Message-ID: <20190403190636.GA9827@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 189.250.114.183
X-Source-L: No
X-Exim-ID: 1hBlDZ-0033Pm-BZ
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [189.250.114.183]:48104
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 4
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes, in particular in the
context in which this code is being used.

So, replace code of the following form:

sizeof(*ce_hdr) + CE_COUNT * sizeof(ce_hdr->entries[0])

with:

struct_size(ce_hdr, entries, CE_COUNT)

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wireless/ath/ath10k/coredump.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/coredump.c b/drivers/net/wireless/ath/ath10k/coredump.c
index 33838d9c1cb6..7825b6a1b104 100644
--- a/drivers/net/wireless/ath/ath10k/coredump.c
+++ b/drivers/net/wireless/ath/ath10k/coredump.c
@@ -1192,8 +1192,8 @@ static struct ath10k_dump_file_data *ath10k_coredump_build(struct ath10k *ar)
 	if (test_bit(ATH10K_FW_CRASH_DUMP_CE_DATA, &ath10k_coredump_mask)) {
 		dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
 		dump_tlv->type = cpu_to_le32(ATH10K_FW_CRASH_DUMP_CE_DATA);
-		dump_tlv->tlv_len = cpu_to_le32(sizeof(*ce_hdr) +
-						CE_COUNT * sizeof(ce_hdr->entries[0]));
+		dump_tlv->tlv_len = cpu_to_le32(struct_size(ce_hdr, entries,
+							    CE_COUNT));
 		ce_hdr = (struct ath10k_ce_crash_hdr *)(dump_tlv->tlv_data);
 		ce_hdr->ce_count = cpu_to_le32(CE_COUNT);
 		memset(ce_hdr->reserved, 0, sizeof(ce_hdr->reserved));
-- 
2.21.0

