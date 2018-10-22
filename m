Return-Path: <SRS0=+Qrf=NC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 752F3C67863
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 12:13:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BCB92064E
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 12:13:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3BCB92064E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728412AbeJVUb6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 22 Oct 2018 16:31:58 -0400
Received: from gateway24.websitewelcome.com ([192.185.50.66]:48841 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727553AbeJVUb6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Oct 2018 16:31:58 -0400
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id 795311A10D
        for <linux-wireless@vger.kernel.org>; Mon, 22 Oct 2018 06:50:21 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id EYipgCnj6BcCXEYiugRzSi; Mon, 22 Oct 2018 06:50:21 -0500
X-Authority-Reason: nr=8
Received: from lfbn-1-466-13.w86-245.abo.wanadoo.fr ([86.245.173.13]:41624 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1gEYio-001GKv-82; Mon, 22 Oct 2018 06:50:10 -0500
Date:   Mon, 22 Oct 2018 13:50:08 +0200
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jes Sorensen <Jes.Sorensen@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 1/2] rtl8xxxu: Mark expected switch fall-throughs
Message-ID: <08817d137b32d5d091eacc6fee0a3eca68d49d94.1540208577.git.gustavo@embeddedor.com>
References: <cover.1540208577.git.gustavo@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1540208577.git.gustavo@embeddedor.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 86.245.173.13
X-Source-L: No
X-Exim-ID: 1gEYio-001GKv-82
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: lfbn-1-466-13.w86-245.abo.wanadoo.fr (embeddedor) [86.245.173.13]:41624
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 10
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Addresses-Coverity-ID: 1357355 ("Missing break in switch")
Addresses-Coverity-ID: 1357378 ("Missing break in switch")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 56040b1..c6b0686 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -1153,6 +1153,7 @@ void rtl8xxxu_gen1_config_channel(struct ieee80211_hw *hw)
 	switch (hw->conf.chandef.width) {
 	case NL80211_CHAN_WIDTH_20_NOHT:
 		ht = false;
+		/* fall through */
 	case NL80211_CHAN_WIDTH_20:
 		opmode |= BW_OPMODE_20MHZ;
 		rtl8xxxu_write8(priv, REG_BW_OPMODE, opmode);
@@ -1280,6 +1281,7 @@ void rtl8xxxu_gen2_config_channel(struct ieee80211_hw *hw)
 	switch (hw->conf.chandef.width) {
 	case NL80211_CHAN_WIDTH_20_NOHT:
 		ht = false;
+		/* fall through */
 	case NL80211_CHAN_WIDTH_20:
 		rf_mode_bw |= WMAC_TRXPTCL_CTL_BW_20;
 		subchannel = 0;
@@ -1748,9 +1750,11 @@ static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
 		case 3:
 			priv->ep_tx_low_queue = 1;
 			priv->ep_tx_count++;
+			/* fall through */
 		case 2:
 			priv->ep_tx_normal_queue = 1;
 			priv->ep_tx_count++;
+			/* fall through */
 		case 1:
 			priv->ep_tx_high_queue = 1;
 			priv->ep_tx_count++;
-- 
2.7.4

