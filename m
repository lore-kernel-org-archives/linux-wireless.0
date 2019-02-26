Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DB6AC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 11:53:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0ED4F217F9
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 11:53:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Sz54XW2G";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="E2VFBKcW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbfBZLxm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 06:53:42 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:42364 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbfBZLxm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 06:53:42 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 302726141B; Tue, 26 Feb 2019 11:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551182021;
        bh=zKwskB8P4NX1xF6Yyp2wV5B7ErKmEzoHdzPTfypcKP0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Sz54XW2G0ixOkleJV/UE1Wn7duImof8sFrAGfA47AUMYZ4TwFuRCRevPdilJe5g8H
         R+/obQwJcssqbbs3UXtF7XmE0O/vry812d0Ot6Z3iDVPN5yi4v+tKnktejNnylbIaC
         nmPm/fkreAN6IKwQE1TJhlhhnjN4saCSoCwrfhMM=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 7F64161515;
        Tue, 26 Feb 2019 11:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551182020;
        bh=zKwskB8P4NX1xF6Yyp2wV5B7ErKmEzoHdzPTfypcKP0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E2VFBKcWDQWi5jQDFVRpidzXi24YxLZZQndXXg5A/yNeGU1Srnk4AZ/2SrZUN+5e/
         HUIkVppF/MFFLT9QWYgvynneAXG7p4APK7FC6z9fHy5TTXvNkTQH/6P7PLGvVSQ2XD
         yiqZjxxPrNcGUAyZPRQn2TqYhJ6/Jl5Kqtox5IFk=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 26 Feb 2019 17:23:40 +0530
From:   Surabhi Vishnoi <svishnoi@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: Fill rx duration for each peer in fw_stats for
 WCN3990
In-Reply-To: <20190225171756.9632C609F3@smtp.codeaurora.org>
References: <1550570110-32010-1-git-send-email-svishnoi@codeaurora.org>
 <20190225171756.9632C609F3@smtp.codeaurora.org>
Message-ID: <558f033a71573862be59867f22c75294@codeaurora.org>
X-Sender: svishnoi@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


Hi Kalle,

I have uploaded the v2 patch which fixes the warning.
https://patchwork.kernel.org/patch/10829811/


Thanks,
Surabhi Vishnoi


On 2019-02-25 22:47, Kalle Valo wrote:
> Surabhi Vishnoi <svishnoi@codeaurora.org> wrote:
> 
>> Currently, rx_duration for each peer is not getting populated in
>> fw_stats debugfs entry for WCN3990.
>> 
>> WCN3990 firmware sends rx duration for each peer as part of
>> peer_extd_stats in WMI_UPDATE_STATS_EVENT. To enable peer_extd_stats,
>> firmware expects host to send fw_stats_req_mask with flag
>> WMI_TLV_PEER_STATS_EXTD set in WMI_REQUEST_STATS_CMD.
>> 
>> Send fw_stats_req_mask with flag WMI_TLV_PEER_STATS_EXTD set in
>> WMI_REQUEST_STATS_CMD and parse the peer_extd_stats in
>> WMI_UPDATE_STATS_EVENT to populate the rx_duration of each peer
>> in fw_stats debugfs entry.
>> 
>> Currently the driver handles 32-bit rx_duration, but the rx_duration
>> for WCN3990 can be upto 63 bit. The firmware sends rx_duration split
>> into two 32-bit fields, with the upper 32-bits being valid only if its
>> MSB is set. This change handles the 63-bit rx_duration obtained from
>> WCN3990 and maintain the backward compatibility.
>> 
>> To get the rx_duration of each connected peer :
>> cat /sys/kernel/debug/ieee80211/phyX/ath10k/fw_stats
>> 
>> Tested HW: WCN3990
>> Tested FW: WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1
>> 
>> Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
>> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> 
> Kbuild bot reported a warning:
> 
>    drivers/net/wireless/ath/ath10k/wmi-tlv.c: In function
> 'ath10k_wmi_tlv_op_pull_fw_stats':
>>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:1423:42: warning: left 
>>> shift count >= width of type [-Wshift-count-overflow]
>         dst->rx_duration |= rx_duration_high <<
>                                              ^~
