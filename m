Return-Path: <SRS0=1g4v=XS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2E12C3A5A6
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Sep 2019 08:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C133A2087C
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Sep 2019 08:12:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="W3hPzeQb";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="W3hPzeQb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406106AbfIWIMN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 23 Sep 2019 04:12:13 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41466 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388953AbfIWIMM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Sep 2019 04:12:12 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7B26C611CE; Mon, 23 Sep 2019 08:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569226331;
        bh=nd+YstKI8r8Tq4qSUaTYi3GnQD8Vhzgbz1GEJTb7dng=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=W3hPzeQbaDIWkdhsPE2iJ/DpngHSjNuvjpLUAn8sn7VtHhi1nndc46OP+LlZU63au
         GdluXqyk0gxXwsPMQOzcVNQwBNV5r+FBlz2BDhDE7DNPnvWn/buoBX79b3qyLoGHln
         eoD2RD+VFHkGEjfcpmSmisFV5xzBprko7+wDNbPA=
Received: from x230.qca.qualcomm.com (37-136-106-186.rev.dnainternet.fi [37.136.106.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 184E06119F;
        Mon, 23 Sep 2019 08:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569226331;
        bh=nd+YstKI8r8Tq4qSUaTYi3GnQD8Vhzgbz1GEJTb7dng=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=W3hPzeQbaDIWkdhsPE2iJ/DpngHSjNuvjpLUAn8sn7VtHhi1nndc46OP+LlZU63au
         GdluXqyk0gxXwsPMQOzcVNQwBNV5r+FBlz2BDhDE7DNPnvWn/buoBX79b3qyLoGHln
         eoD2RD+VFHkGEjfcpmSmisFV5xzBprko7+wDNbPA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 184E06119F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Surabhi Vishnoi <svishnoi@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] ath10k: Add support for per peer HTT tx stats for WCN3990
References: <1551251628-22518-1-git-send-email-svishnoi@codeaurora.org>
        <1551251628-22518-3-git-send-email-svishnoi@codeaurora.org>
Date:   Mon, 23 Sep 2019 11:12:07 +0300
In-Reply-To: <1551251628-22518-3-git-send-email-svishnoi@codeaurora.org>
        (Surabhi Vishnoi's message of "Wed, 27 Feb 2019 12:43:48 +0530")
Message-ID: <87a7ava0tk.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Surabhi Vishnoi <svishnoi@codeaurora.org> writes:

> The firmware sends peer stats to the host driver if the firmware
> advertises WMI_SERVICE_PEER_STATS service and the host driver
> indicates the WMI_RSRC_CFG_FLAG_TX_PEER_STATS capability in the
> host capab flag in wmi init cmd.
>
> When peer stats are enabled, firmware sends one HTT event
> HTT_TLV_T2H_MSG_TYPE_PEER_STATS for every four PPDUs transmitted.
> HTT msg payload has tag followed by length followed by
> success pkts/bytes, failed pkts/bytes, retry pkts/bytes and rate
> info per ppdu.
>
> Parse peer stats sent by the firmware in tlv format and update the
> tx rate information and tx_stats debugfs entry per STA.
>
> To get the tx_stats:
> echo 1 > /sys/kernel/debug/ieee80211/phyX/ath10k/enable_extd_tx_stats
> cat /sys/kernel/debug/ieee80211/phyX/net:wlanX/stations/xx:xx:xx:xx:xx:xx/tx_stats
>
> Tested HW: WCN3990
> Tested FW: WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1
>
> Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>

[...]

> @@ -3438,7 +3566,7 @@ bool ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
>  		ath10k_htt_rx_tx_mode_switch_ind(ar, skb);
>  		break;
>  	case HTT_T2H_MSG_TYPE_PEER_STATS:
> -		ath10k_htt_fetch_peer_stats(ar, skb);
> +		htt->rx_ops->htt_fetch_peer_stats(ar, skb);
>  		break;

I think this belongs to patch 1.

> +#define ATH10K_HW_GI_MASK				GENMASK(5, 5)

BIT(5)

> +#define ATH10K_HW_SKIPPED_RATE_CTRL_MASK		GENMASK(6, 6)

BIT(6)

> +#define ATH10K_HW_WCN3990_GI_MASK			GENMASK(6, 6)

BIT(6)

> +#define ATH10K_HW_WCN3990_SKIPPED_RATE_CTRL_MASK	GENMASK(7, 7)

BIT(7)

-- 
Kalle Valo
