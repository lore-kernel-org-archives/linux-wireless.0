Return-Path: <SRS0=+Qrf=NC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A9F8C7112C
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 20:46:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FC2820672
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 20:46:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7FC2820672
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729175AbeJWFGV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 01:06:21 -0400
Received: from gateway23.websitewelcome.com ([192.185.49.179]:14623 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725788AbeJWFGV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 01:06:21 -0400
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 8FD3119EA7
        for <linux-wireless@vger.kernel.org>; Mon, 22 Oct 2018 15:46:15 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id Eh5TgYqDJBcCXEh5YgnwLj; Mon, 22 Oct 2018 15:46:15 -0500
X-Authority-Reason: nr=8
Received: from lfbn-1-466-13.w86-245.abo.wanadoo.fr ([86.245.173.13]:51064 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1gEh5S-0025do-ER; Mon, 22 Oct 2018 15:46:06 -0500
Date:   Mon, 22 Oct 2018 22:46:03 +0200
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 16/20] rt2x00: rt2800lib: mark expected switch fall-throughs
Message-ID: <85711e291a870ba4a36373bcbdcc3eb2f7d3171f.1540239684.git.gustavo@embeddedor.com>
References: <cover.1540239684.git.gustavo@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1540239684.git.gustavo@embeddedor.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 86.245.173.13
X-Source-L: No
X-Exim-ID: 1gEh5S-0025do-ER
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: lfbn-1-466-13.w86-245.abo.wanadoo.fr (embeddedor) [86.245.173.13]:51064
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 114
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Addresses-Coverity-ID: 145198 ("Missing break in switch")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 9e7b893..0e95555 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -2482,6 +2482,7 @@ static void rt2800_config_channel_rf3052(struct rt2x00_dev *rt2x00dev,
 		switch (rt2x00dev->default_ant.tx_chain_num) {
 		case 1:
 			rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD, 1);
+			/* fall through */
 		case 2:
 			rt2x00_set_field8(&rfcsr, RFCSR1_TX2_PD, 1);
 			break;
@@ -2490,6 +2491,7 @@ static void rt2800_config_channel_rf3052(struct rt2x00_dev *rt2x00dev,
 		switch (rt2x00dev->default_ant.rx_chain_num) {
 		case 1:
 			rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD, 1);
+			/* fall through */
 		case 2:
 			rt2x00_set_field8(&rfcsr, RFCSR1_RX2_PD, 1);
 			break;
@@ -9457,8 +9459,10 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	switch (rx_chains) {
 	case 3:
 		spec->ht.mcs.rx_mask[2] = 0xff;
+		/* fall through */
 	case 2:
 		spec->ht.mcs.rx_mask[1] = 0xff;
+		/* fall through */
 	case 1:
 		spec->ht.mcs.rx_mask[0] = 0xff;
 		spec->ht.mcs.rx_mask[4] = 0x1; /* MCS32 */
-- 
2.7.4

