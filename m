Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93374C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 11:59:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60150217D8
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 11:59:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="i78YcgHW";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="M4dHu7dx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730866AbeLTL7C (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 06:59:02 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:33854 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729103AbeLTL7B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 06:59:01 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 05B296076A; Thu, 20 Dec 2018 11:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545307140;
        bh=4WX3OaRhVAfe7Xq8miNORsKYHnY2+ix8zsjbuQxj3tQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=i78YcgHWMQy+p7fDXa6LpAVVVMao9IL83i071jWkQTJQX9ZAFbvq45HVDlgAVu2/F
         cbnaT10JNTCW1MjFMfT8fPSwlBXECXhQZjOAxUQQos0QthqNm4S/944ZAgfQTBM1/a
         1DdXPCURq0WQ+ov4SzIWRklIEjRk7lMFGbXluWYY=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A116E6028D;
        Thu, 20 Dec 2018 11:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545307139;
        bh=4WX3OaRhVAfe7Xq8miNORsKYHnY2+ix8zsjbuQxj3tQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=M4dHu7dxwi2BeQ/Qr1WrjP4FySKQIAi/ouifMpBCiVFimJcINFoz8OQhz+IcqMV7n
         ix6v7etJrKVqdCOfHKKIDGnsEKpAqDTrFWaLQ9jXb6bopwytdk/8JtO2gAfDxr551+
         WB7QnLpjGf3/DonvyRXgyiJRj0QwAre+fhZyT6Uo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A116E6028D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Govind Singh <govinds@codeaurora.org>
Cc:     briannorris@chromium.org, andy.gross@linaro.org,
        ath10k@lists.infradead.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-wireless@vger.kernel.org, robh+dt@kernel.org,
        sboyd@kernel.org, dianders@chromium.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/3] Enable ath10k wcn3990 wifi driver support on sdm845
References: <1541423318-19312-1-git-send-email-govinds@codeaurora.org>
        <87d0r55ews.fsf@codeaurora.org>
        <6e831363962be4e28d7551e360ed4d46@codeaurora.org>
        <874lcg55at.fsf@codeaurora.org>
        <9f8bbfaa232c02bb33594207fa1f8821@codeaurora.org>
Date:   Thu, 20 Dec 2018 13:58:53 +0200
In-Reply-To: <9f8bbfaa232c02bb33594207fa1f8821@codeaurora.org> (Govind Singh's
        message of "Wed, 19 Dec 2018 21:11:25 +0530")
Message-ID: <87y38ktnnm.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Govind Singh <govinds@codeaurora.org> writes:

> Hi Kalle,
>
> On 2018-11-17 16:39, Kalle Valo wrote:
>> Govind Singh <govinds@codeaurora.org> writes:
>>
>>> On 2018-11-16 18:59, Kalle Valo wrote:
>>>> Govind Singh <govinds@codeaurora.org> writes:
>>>>
>>>>> This series enables ath10k wifi driver support for WCN3990 target
>>>>> on sdm845 SOC. This series also updates the missing dt binding
>>>>> documentation
>>>>> and adds optional iommu property.
>>>>>
>>>>> Changes since v3:
>>>>>     Moved interrupt/reg/reg-name to required property.
>>>>>     Removed unused clocks.
>>>>>     Corrected interrupt no's.
>>>>>
>>>>> Changes since v2:
>>>>>     dropped [v2,4/4] dts: arm64/sdm845: Enable iommu for WCN3990
>>>>> wifi module
>>>>>     device node patch from the series as dependent patch is not yet
>>>>> merged.
>>>>>     Enabled status flag from sdm845-mtp.dts.
>>>>>
>>>>> Changes since v1:
>>>>>     Listed no of interrupts/clocks for each set of compatible.
>>>>>     Added missing 'wifi' label to sdm845.dtsi.
>>>>>
>>>>> Govind Singh (3):
>>>>>   dt: bindings: add missing dt properties for WCN3990 wifi node
>>>>>   dts: arm64/sdm845: Add WCN3990 WLAN module device node
>>>>>   dt: bindings: add bindings for wifi iommu node
>>>>>
>>>>>  .../bindings/net/wireless/qcom,ath10k.txt          | 62
>>>>> ++++++++++++++--------
>>>>>  arch/arm64/boot/dts/qcom/sdm845-mtp.dts            |  8 +++
>>>>>  arch/arm64/boot/dts/qcom/sdm845.dtsi               | 26 +++++++++
>>>>>  3 files changed, 74 insertions(+), 22 deletions(-)
>>>>
>>>> Via which tree are these patches going? That's not clear for me.
>>>
>>> I guess sdm845 dtsi change should be going to
>>> git://git.kernel.org/pub/scm/linux/kernel/git/agross/linux.git.
>>> I need to send v5 to address one comment from Brian.
>>
>> Ok, I'll then drop these from my queue.
>
> Can you pls apply below changes to ath10k tree, i will send sdm845
> dtsi change as separate patch after rebase.
>
>>>>>   dt: bindings: add missing dt properties for WCN3990 wifi node
>>>>>   dt: bindings: add bindings for wifi iommu node

Ok, these two are back in my queue:

https://patchwork.kernel.org/patch/10668237/

https://patchwork.kernel.org/patch/10668245/

I'll just modify the titles to use ath10k prefix to make it more clear
these are for ath10k:

   dt: bindings: ath10k: .....

-- 
Kalle Valo
