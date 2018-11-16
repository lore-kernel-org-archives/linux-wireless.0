Return-Path: <SRS0=ZGUU=N3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAA8AC43441
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 16:07:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 822C32086C
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 16:07:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Cfp9zdqG";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Cfp9zdqG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 822C32086C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390074AbeKQCT4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Nov 2018 21:19:56 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:59634 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728169AbeKQCT4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Nov 2018 21:19:56 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 58C0760591; Fri, 16 Nov 2018 16:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542384418;
        bh=JYPHTv5oZt2rssGNkwQaCH2UzaK/87z0BCNtqcJmzC4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Cfp9zdqGD6w7bJA7pAYFO7zvMzTAwM2hlg2+IrCgHLXAUgwReVO810Ph0VdoNSbs+
         VFZTZoGxlCmG41VSURSjtFmEDfZF0/21MkHz5z/ouD1SwS0ipVIj3zdOpYxPPk8fs+
         5mu7fFd5UlnZS1qD9Qaj1Om/VqDKuBa7lzgXZ7qc=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id E64AC60386;
        Fri, 16 Nov 2018 16:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542384418;
        bh=JYPHTv5oZt2rssGNkwQaCH2UzaK/87z0BCNtqcJmzC4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Cfp9zdqGD6w7bJA7pAYFO7zvMzTAwM2hlg2+IrCgHLXAUgwReVO810Ph0VdoNSbs+
         VFZTZoGxlCmG41VSURSjtFmEDfZF0/21MkHz5z/ouD1SwS0ipVIj3zdOpYxPPk8fs+
         5mu7fFd5UlnZS1qD9Qaj1Om/VqDKuBa7lzgXZ7qc=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 16 Nov 2018 21:36:57 +0530
From:   Govind Singh <govinds@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     briannorris@chromium.org, andy.gross@linaro.org,
        ath10k@lists.infradead.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-wireless@vger.kernel.org, robh+dt@kernel.org,
        sboyd@kernel.org, dianders@chromium.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/3] Enable ath10k wcn3990 wifi driver support on
 sdm845
In-Reply-To: <87d0r55ews.fsf@codeaurora.org>
References: <1541423318-19312-1-git-send-email-govinds@codeaurora.org>
 <87d0r55ews.fsf@codeaurora.org>
Message-ID: <6e831363962be4e28d7551e360ed4d46@codeaurora.org>
X-Sender: govinds@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-11-16 18:59, Kalle Valo wrote:
> Govind Singh <govinds@codeaurora.org> writes:
> 
>> This series enables ath10k wifi driver support for WCN3990 target
>> on sdm845 SOC. This series also updates the missing dt binding 
>> documentation
>> and adds optional iommu property.
>> 
>> Changes since v3:
>>     Moved interrupt/reg/reg-name to required property.
>>     Removed unused clocks.
>>     Corrected interrupt no's.
>> 
>> Changes since v2:
>>     dropped [v2,4/4] dts: arm64/sdm845: Enable iommu for WCN3990 wifi 
>> module
>>     device node patch from the series as dependent patch is not yet 
>> merged.
>>     Enabled status flag from sdm845-mtp.dts.
>> 
>> Changes since v1:
>>     Listed no of interrupts/clocks for each set of compatible.
>>     Added missing 'wifi' label to sdm845.dtsi.
>> 
>> Govind Singh (3):
>>   dt: bindings: add missing dt properties for WCN3990 wifi node
>>   dts: arm64/sdm845: Add WCN3990 WLAN module device node
>>   dt: bindings: add bindings for wifi iommu node
>> 
>>  .../bindings/net/wireless/qcom,ath10k.txt          | 62 
>> ++++++++++++++--------
>>  arch/arm64/boot/dts/qcom/sdm845-mtp.dts            |  8 +++
>>  arch/arm64/boot/dts/qcom/sdm845.dtsi               | 26 +++++++++
>>  3 files changed, 74 insertions(+), 22 deletions(-)
> 
> Via which tree are these patches going? That's not clear for me.

I guess sdm845 dtsi change should be going to 
git://git.kernel.org/pub/scm/linux/kernel/git/agross/linux.git.
I need to send v5 to address one comment from Brian.

BR,
Govind
