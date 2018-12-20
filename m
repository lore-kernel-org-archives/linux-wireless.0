Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6B42C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 13:18:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A474E217D8
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 13:18:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ag2Lfi+a";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ag2Lfi+a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732425AbeLTNSV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 08:18:21 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:46114 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730527AbeLTNSV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 08:18:21 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 999F36076A; Thu, 20 Dec 2018 13:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545311900;
        bh=n5QBL4ra4ge9XnXWHm+4/llMyV5/WNyh2wX/a/HnjB8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ag2Lfi+amQp/bqTL/QjCqFiQ/BgdCMEj5e9iYwLCnLRmoiuh2yxRrvF/EG/HDTkYq
         PX9iis0hXuc95OBgQUmsQHxxkUIy4nALCoUSrZEagzYCYO2mLrgcunwxyQPeY0jB2b
         aS6lhUpHx4MFeVZJ+akbHG6eq42v11k58lhO2wzQ=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4031A6014B;
        Thu, 20 Dec 2018 13:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545311900;
        bh=n5QBL4ra4ge9XnXWHm+4/llMyV5/WNyh2wX/a/HnjB8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ag2Lfi+amQp/bqTL/QjCqFiQ/BgdCMEj5e9iYwLCnLRmoiuh2yxRrvF/EG/HDTkYq
         PX9iis0hXuc95OBgQUmsQHxxkUIy4nALCoUSrZEagzYCYO2mLrgcunwxyQPeY0jB2b
         aS6lhUpHx4MFeVZJ+akbHG6eq42v11k58lhO2wzQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4031A6014B
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
        <87y38ktnnm.fsf@kamboji.qca.qualcomm.com>
Date:   Thu, 20 Dec 2018 15:18:15 +0200
In-Reply-To: <87y38ktnnm.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
        of "Thu, 20 Dec 2018 13:58:53 +0200")
Message-ID: <87imzo72w8.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> writes:

> Govind Singh <govinds@codeaurora.org> writes:
>
>> Hi Kalle,
>>
>> On 2018-11-17 16:39, Kalle Valo wrote:
>>> Govind Singh <govinds@codeaurora.org> writes:
>>>
>>>> On 2018-11-16 18:59, Kalle Valo wrote:
>>>>>
>>>>> Via which tree are these patches going? That's not clear for me.
>>>>
>>>> I guess sdm845 dtsi change should be going to
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/agross/linux.git.
>>>> I need to send v5 to address one comment from Brian.
>>>
>>> Ok, I'll then drop these from my queue.
>>
>> Can you pls apply below changes to ath10k tree, i will send sdm845
>> dtsi change as separate patch after rebase.
>>
>>>>>>   dt: bindings: add missing dt properties for WCN3990 wifi node
>>>>>>   dt: bindings: add bindings for wifi iommu node
>
> Ok, these two are back in my queue:
>
> https://patchwork.kernel.org/patch/10668237/
>
> https://patchwork.kernel.org/patch/10668245/
>
> I'll just modify the titles to use ath10k prefix to make it more clear
> these are for ath10k:
>
>    dt: bindings: ath10k: .....

There were conflicts with this commit:

2b741a8aaa34 dt: bindings: add bindings for msa memory region

I fixed them in the pending branch, please double check carefully:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=5bb88d4d49783c75ac083e4ea19b7527bc115857

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=a6d53e207670eacd72a74277658bac1ab346fabd

-- 
Kalle Valo
