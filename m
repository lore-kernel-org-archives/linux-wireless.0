Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79327C433F5
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Nov 2021 07:28:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F4CB63215
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Nov 2021 07:28:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbhKQHbT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Nov 2021 02:31:19 -0500
Received: from so254-9.mailgun.net ([198.61.254.9]:28239 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbhKQHbT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Nov 2021 02:31:19 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1637134094; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=XbO7mzpxWdT7BlrPjC/8KECIfX1n/8CZNR5jOCgeZgA=;
 b=PIicr36CAgDSpehmOujYZAJT5dyP96UnUk3agqy4zIePyG65SZNNfjhCGt3fKs17orXHawBv
 g1FOxtArOXvh7ueNeTb48+YdWde6ILxCgWN192cZqw442TqVljJr77njeAUeTkoMLaiI72Mj
 KrTD9N406C2lNp9e/fH/dSecvYQ=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 6194af0d11cd6d40778f132d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 17 Nov 2021 07:28:13
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2D99FC43616; Wed, 17 Nov 2021 07:28:13 +0000 (UTC)
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 857A3C43460;
        Wed, 17 Nov 2021 07:28:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 857A3C43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath11k: Disabling credit flow for WMI path
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1635156494-20059-1-git-send-email-quic_ppranees@quicinc.com>
References: <1635156494-20059-1-git-send-email-quic_ppranees@quicinc.com>
To:     P Praneesh <quic_ppranees@quicinc.com>
Cc:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        P Praneesh <quic_ppranees@quicinc.com>,
        Pravas Kumar Panda <kumarpan@codeaurora.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163713408935.31320.4287583545861916111.kvalo@codeaurora.org>
Date:   Wed, 17 Nov 2021 07:28:13 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

P Praneesh <quic_ppranees@quicinc.com> wrote:

> Firmware credit flow control is enabled for WMI control services,
> which expects available tokens should be acquired before sending a
> command to the target. Also the token gets released when firmware
> receives the command.
> 
> This credit-based flow limits driver to send WMI command only
> when the token available which is causing WMI commands to timeout and
> return -EAGAIN, whereas firmware has enough capability to process the
> WMI command. To fix this Tx starvation issue, introduce the ability to
> disable the credit flow for the WMI path.
> 
> The driver sends WMI configuration for disabling credit flow to firmware
> by two ways.
>         1. By using a global flag
>                 (HTC_MSG_SETUP_COMPLETE_EX_ID msg type flags)
>         2. By using a local flag
>                 (ATH11K_HTC_CONN_FLAGS_DISABLE_CREDIT_FLOW_CTRL = 1 << 3)
> 
> Ath11k uses both these configurations to disable credit flow for the
> WMI path completely.
> 
> Also added a hw_param member for credit flow control by which we can
> enable or disable it based on per-target basis. Currently we are disabling
> credit flow for IPQ8074, IPQ6018, and QCN9074 as recommended by firmware.
> 
> Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.4.0.1-01492-QCAHKSWPL_SILICONZ-1
> Tested-on: IPQ6018 hw1.0 AHB WLAN.HK.2.4.0.1-00330-QCAHKSWPL_SILICONZ-1
> 
> Co-developed-by: Pravas Kumar Panda <kumarpan@codeaurora.org>
> Signed-off-by: Pravas Kumar Panda <kumarpan@codeaurora.org>
> Signed-off-by: P Praneesh <quic_ppranees@quicinc.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

f951380a6022 ath11k: Disabling credit flow for WMI path

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1635156494-20059-1-git-send-email-quic_ppranees@quicinc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

