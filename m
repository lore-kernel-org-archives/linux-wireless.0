Return-Path: <SRS0=qpxp=O4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC156C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 15:41:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABFBC2086C
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 15:41:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="O1s/sSwY";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="oM2HA0dI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730354AbeLSPl2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Dec 2018 10:41:28 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:60496 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728135AbeLSPl1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Dec 2018 10:41:27 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8E2A861CB7; Wed, 19 Dec 2018 15:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545234086;
        bh=34JLDKlwAfL9TmveL8qHUUFHdqwJMXCqWotrQNTQi30=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O1s/sSwYpvGvszZGyPPPWCpbXOg/wC/hpqsljfcAopHbVVWEL6nMZpY8JdFFUoFpt
         0pB/m5cn4IJ4cT+wHlA8ARnoAMe7Wy9t4pko67ljazB21wdQi4VoNO7l+0gGlXJWN5
         xbs7MNkCKwHPe8udI4I2t9ceWAju3MSHlZIoIcUQ=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id A1AC861B87;
        Wed, 19 Dec 2018 15:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545234085;
        bh=34JLDKlwAfL9TmveL8qHUUFHdqwJMXCqWotrQNTQi30=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oM2HA0dIBL46C3Ry+E5hVcPR0S2LOphpYymaIGZ5w/fzeyco+Jhsh8K7a8CPWRSpq
         C81c50aFO/Uy7zcavQXfXmgfcaCbRcxq1OFBOtCuyIY8mcGjhrUn7VDjJHwpu5hfVz
         NlzN5+MBaDAExNh8Afo6bigSO0L2JH1wmBnWtHi4=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 19 Dec 2018 21:11:25 +0530
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
In-Reply-To: <874lcg55at.fsf@codeaurora.org>
References: <1541423318-19312-1-git-send-email-govinds@codeaurora.org>
 <87d0r55ews.fsf@codeaurora.org>
 <6e831363962be4e28d7551e360ed4d46@codeaurora.org>
 <874lcg55at.fsf@codeaurora.org>
Message-ID: <9f8bbfaa232c02bb33594207fa1f8821@codeaurora.org>
X-Sender: govinds@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Kalle,

On 2018-11-17 16:39, Kalle Valo wrote:
> Govind Singh <govinds@codeaurora.org> writes:
> 
>> On 2018-11-16 18:59, Kalle Valo wrote:
>>> Govind Singh <govinds@codeaurora.org> writes:
>>> 
>>>> This series enables ath10k wifi driver support for WCN3990 target
>>>> on sdm845 SOC. This series also updates the missing dt binding
>>>> documentation
>>>> and adds optional iommu property.
>>>> 
>>>> Changes since v3:
>>>>     Moved interrupt/reg/reg-name to required property.
>>>>     Removed unused clocks.
>>>>     Corrected interrupt no's.
>>>> 
>>>> Changes since v2:
>>>>     dropped [v2,4/4] dts: arm64/sdm845: Enable iommu for WCN3990
>>>> wifi module
>>>>     device node patch from the series as dependent patch is not yet
>>>> merged.
>>>>     Enabled status flag from sdm845-mtp.dts.
>>>> 
>>>> Changes since v1:
>>>>     Listed no of interrupts/clocks for each set of compatible.
>>>>     Added missing 'wifi' label to sdm845.dtsi.
>>>> 
>>>> Govind Singh (3):
>>>>   dt: bindings: add missing dt properties for WCN3990 wifi node
>>>>   dts: arm64/sdm845: Add WCN3990 WLAN module device node
>>>>   dt: bindings: add bindings for wifi iommu node
>>>> 
>>>>  .../bindings/net/wireless/qcom,ath10k.txt          | 62
>>>> ++++++++++++++--------
>>>>  arch/arm64/boot/dts/qcom/sdm845-mtp.dts            |  8 +++
>>>>  arch/arm64/boot/dts/qcom/sdm845.dtsi               | 26 +++++++++
>>>>  3 files changed, 74 insertions(+), 22 deletions(-)
>>> 
>>> Via which tree are these patches going? That's not clear for me.
>> 
>> I guess sdm845 dtsi change should be going to
>> git://git.kernel.org/pub/scm/linux/kernel/git/agross/linux.git.
>> I need to send v5 to address one comment from Brian.
> 
> Ok, I'll then drop these from my queue.

Can you pls apply below changes to ath10k tree, i will send sdm845 dtsi 
change as separate patch after rebase.
>>>>   dt: bindings: add missing dt properties for WCN3990 wifi node
>>>>   dt: bindings: add bindings for wifi iommu node

BR,
Govind
