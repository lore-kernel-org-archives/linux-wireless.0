Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E8DFC4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 12:43:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDC3420830
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 12:43:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="f8ob4RTG";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lLqlys9A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbfDCMn3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 08:43:29 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:55740 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbfDCMn3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 08:43:29 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2D70061ACD; Wed,  3 Apr 2019 12:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554295408;
        bh=o/s+8yCZyENLtWiX12y6lb78TImCZJO/ei63cuNfjeU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=f8ob4RTG01Ow3dH2cziQ0ONqIyyetZQ+skT6Ev2nik8es2gnhhwMTTQxkCV1J7cIq
         1FND1AwzJtU7Bv3LUh3u/DQ2bqJ1Dgkem77ZUTw1p4KWbaDaD9oiszJ/G4hUUauEBY
         FVy3895M1Kp+DZjjDcOvDL+hNmIfkIQNEwoGHFBw=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2F07A61AD5;
        Wed,  3 Apr 2019 12:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554295386;
        bh=o/s+8yCZyENLtWiX12y6lb78TImCZJO/ei63cuNfjeU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=lLqlys9AquEXBmweO+fxiyE1CEIK36dmZFxEBac0FFZZ1wRChVCos3Y9SzhXeLfe0
         Rd6befgFjnWNxPxELQ8xThuxpDRTzLh1yBIqn8qhUvDCN2fM7cXjY9p6KFT/62kwQf
         e39XuvZtXSu0svSUzQ07zvKw3+CM2BPO09HqdxBk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2F07A61AD5
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 08/21] wil6210: align to latest auto generated wmi.h
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1550845279-16103-9-git-send-email-merez@codeaurora.org>
References: <1550845279-16103-9-git-send-email-merez@codeaurora.org>
To:     Maya Erez <merez@codeaurora.org>
Cc:     Alexei Avshalom Lazar <ailizaro@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190403124328.2D70061ACD@smtp.codeaurora.org>
Date:   Wed,  3 Apr 2019 12:43:07 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Maya Erez <merez@codeaurora.org> wrote:

> Align to latest version of the auto generated wmi file
> describing the interface with FW.
> 
> Signed-off-by: Alexei Avshalom Lazar <ailizaro@codeaurora.org>
> Signed-off-by: Maya Erez <merez@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

8 patches applied to ath-next branch of ath.git, thanks.

73a7d1e34d88 wil6210: align to latest auto generated wmi.h
a061894587ef wil6210: prevent device memory access while in reset or suspend
5793fe9d4fde wil6210: increase PCP stop command timeout
f6194f769dfc wil6210: do not set BIT_USER_SUPPORT_T_POWER_ON_0 in Talyn-MB
044974fbeade wil6210: update WIL_MCS_MAX to 15
e4a29bdd8f82 wil6210: check mid is valid
7b834639c4c4 wil6210: use OEM MAC address from OTP
29ca376066df wil6210: free edma_rx_swtail upon reset

-- 
https://patchwork.kernel.org/patch/10826115/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

