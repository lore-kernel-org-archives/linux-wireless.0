Return-Path: <SRS0=1g4v=XS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50F6DC3A5A6
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Sep 2019 08:07:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2538F20820
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Sep 2019 08:07:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OT6DcloX";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OT6DcloX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405453AbfIWIHR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 23 Sep 2019 04:07:17 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:39022 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405276AbfIWIHR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Sep 2019 04:07:17 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A7B836119D; Mon, 23 Sep 2019 08:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569226035;
        bh=uH4zjXlXe/hhr/BYrZpT/kC8NHNyTFcFYPAI/Bqxml8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=OT6DcloXVJmOJ3QTEHF1DiRl9vCg3C0PNeBi2qVPp2RGgWQ97kv+uIiiOGrDCqhZh
         OBAlO2duM2HP56G7t45wre6FfeYxJi/AWc1enPSWoBs1Ta1in5TSAsd3VwweO44JGg
         79XYMmFDRB5BO7CyRyAxr9AY3tqrNFxbTaS+fnUA=
Received: from x230.qca.qualcomm.com (37-136-106-186.rev.dnainternet.fi [37.136.106.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 47A566034D;
        Mon, 23 Sep 2019 08:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569226035;
        bh=uH4zjXlXe/hhr/BYrZpT/kC8NHNyTFcFYPAI/Bqxml8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=OT6DcloXVJmOJ3QTEHF1DiRl9vCg3C0PNeBi2qVPp2RGgWQ97kv+uIiiOGrDCqhZh
         OBAlO2duM2HP56G7t45wre6FfeYxJi/AWc1enPSWoBs1Ta1in5TSAsd3VwweO44JGg
         79XYMmFDRB5BO7CyRyAxr9AY3tqrNFxbTaS+fnUA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 47A566034D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Surabhi Vishnoi <svishnoi@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] ath10k: Add support for adding htt_rx_ops based on htt_version
References: <1551251628-22518-1-git-send-email-svishnoi@codeaurora.org>
        <1551251628-22518-2-git-send-email-svishnoi@codeaurora.org>
Date:   Mon, 23 Sep 2019 11:07:12 +0300
In-Reply-To: <1551251628-22518-2-git-send-email-svishnoi@codeaurora.org>
        (Surabhi Vishnoi's message of "Wed, 27 Feb 2019 12:43:47 +0530")
Message-ID: <87ef07a11r.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Surabhi Vishnoi <svishnoi@codeaurora.org> writes:

> Refactor the code to add the support to attach htt_rx_ops
> based on HTT version.
>
> Tested HW: WCN3990
> Tested FW: WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1
>
> Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>

[...]

> @@ -3572,7 +3580,7 @@ int ath10k_htt_txrx_compl_task(struct ath10k *ar, int budget)
>  	.htt_reset_paddrs_ring = ath10k_htt_reset_paddrs_ring_64,
>  };
>  
> -static const struct ath10k_htt_rx_ops htt_rx_ops_hl = {
> +static struct ath10k_htt_rx_ops htt_rx_ops_hl = {
>  };
>  
>  void ath10k_htt_set_rx_ops(struct ath10k_htt *htt)
> @@ -3585,4 +3593,19 @@ void ath10k_htt_set_rx_ops(struct ath10k_htt *htt)
>  		htt->rx_ops = &htt_rx_ops_64;
>  	else
>  		htt->rx_ops = &htt_rx_ops_32;
> +
> +	switch (ar->running_fw->fw_file.htt_op_version) {
> +	case ATH10K_FW_HTT_OP_VERSION_MAIN:
> +	case ATH10K_FW_HTT_OP_VERSION_10_1:
> +	case ATH10K_FW_HTT_OP_VERSION_10_4:
> +		htt->rx_ops->htt_fetch_peer_stats = ath10k_htt_fetch_peer_stats;
> +	break;
> +	case ATH10K_FW_HTT_OP_VERSION_TLV:
> +		htt->rx_ops->htt_fetch_peer_stats = ath10k_htt_fetch_peer_stats_tlv;
> +	break;
> +	case ATH10K_FW_HTT_OP_VERSION_MAX:
> +	case ATH10K_FW_HTT_OP_VERSION_UNSET:
> +		WARN_ON(1);
> +	return;
> +	}
>  }

I just realised this won't work. Let's say that there's both a qca988x
and a qca6174 PCI device on the same host. Then htt->rx_ops is shared by
_both_ devices and the htt_fetch_peer_stats field will contain the value
of the last initialised ath10k device.

So back to the drawing board. As this feature is for wcn3990 would it be
enough to modify htt_rx_ops_64? IIRC only wcn3990 support 64bit HTT
interface, right? Of course then qca6174 won't support this feature, but
does the qca6174 firmware even support that?

-- 
Kalle Valo
