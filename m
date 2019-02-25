Return-Path: <SRS0=l+aR=RA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C120C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Feb 2019 17:17:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5990C20684
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Feb 2019 17:17:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="L4KthNA6";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="M94K4qMW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbfBYRR5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Feb 2019 12:17:57 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:51558 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728368AbfBYRR5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Feb 2019 12:17:57 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 85CCF6030B; Mon, 25 Feb 2019 17:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551115076;
        bh=W7N75IGProOpyLGaIYF6TvFfn+TXJkKGIyWFOcv1PSo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=L4KthNA62cNmR1vR2atIEa0oX5HWkwl+5ulm6EFloTAi94tSvHHlp31LkwwBTtAqk
         aqkkJSq9BUvL/MPVVUWTlU6sF7tInB01bJP0u+1ozgr4DQE14jphQFs+j2M9pd7M13
         xdiSV2QsIUoIdyIw+lKKTfbRizFTITVXAkQzNhjc=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3A86F60767;
        Mon, 25 Feb 2019 17:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551115076;
        bh=W7N75IGProOpyLGaIYF6TvFfn+TXJkKGIyWFOcv1PSo=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=M94K4qMWCwqjmPpdSbiLjgiCMHNLfktIakCW/hAfHBSQ76snQKK5d+BqtJFx0BBjH
         1HEsIkZ6MwUUGyzs03mz+9nLBmiuCZ7Wvn8/net6UcvEi47NhCp2dsVu1GYe/dfVLn
         c0q9e4kl3hU4ouENptD/0ChEbYDjyNCM4/CSBP4k=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3A86F60767
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Fill rx duration for each peer in fw_stats for
 WCN3990
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1550570110-32010-1-git-send-email-svishnoi@codeaurora.org>
References: <1550570110-32010-1-git-send-email-svishnoi@codeaurora.org>
To:     Surabhi Vishnoi <svishnoi@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Surabhi Vishnoi <svishnoi@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190225171756.85CCF6030B@smtp.codeaurora.org>
Date:   Mon, 25 Feb 2019 17:17:56 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Surabhi Vishnoi <svishnoi@codeaurora.org> wrote:

> Currently, rx_duration for each peer is not getting populated in
> fw_stats debugfs entry for WCN3990.
> 
> WCN3990 firmware sends rx duration for each peer as part of
> peer_extd_stats in WMI_UPDATE_STATS_EVENT. To enable peer_extd_stats,
> firmware expects host to send fw_stats_req_mask with flag
> WMI_TLV_PEER_STATS_EXTD set in WMI_REQUEST_STATS_CMD.
> 
> Send fw_stats_req_mask with flag WMI_TLV_PEER_STATS_EXTD set in
> WMI_REQUEST_STATS_CMD and parse the peer_extd_stats in
> WMI_UPDATE_STATS_EVENT to populate the rx_duration of each peer
> in fw_stats debugfs entry.
> 
> Currently the driver handles 32-bit rx_duration, but the rx_duration
> for WCN3990 can be upto 63 bit. The firmware sends rx_duration split
> into two 32-bit fields, with the upper 32-bits being valid only if its
> MSB is set. This change handles the 63-bit rx_duration obtained from
> WCN3990 and maintain the backward compatibility.
> 
> To get the rx_duration of each connected peer :
> cat /sys/kernel/debug/ieee80211/phyX/ath10k/fw_stats
> 
> Tested HW: WCN3990
> Tested FW: WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1
> 
> Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Kbuild bot reported a warning:

   drivers/net/wireless/ath/ath10k/wmi-tlv.c: In function 'ath10k_wmi_tlv_op_pull_fw_stats':
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:1423:42: warning: left shift count >= width of type [-Wshift-count-overflow]
        dst->rx_duration |= rx_duration_high <<
                                             ^~
-- 
https://patchwork.kernel.org/patch/10819589/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

