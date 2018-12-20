Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EF99C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 13:24:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D3B72186A
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 13:24:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CD40v8/0";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CD40v8/0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732997AbeLTNYn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 08:24:43 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:49170 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732234AbeLTNYm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 08:24:42 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C8FE560734; Thu, 20 Dec 2018 13:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545312281;
        bh=NIXtCQQK/IafPV7TqJymlEnoMphLjq6l33somg+KjZI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CD40v8/0ZHQnD14G+NYXZ8f12oxTE/L/JcYLUxphyQUJt4S/CwNaJK/lfw89d8x+J
         FTsVdLldK5s46JvZqKoA2EmQ1zmmD6d1O0wCKGF2OPmGN2R2qf2p/XG5Bz/OvnfTcN
         CKG4WE8ELHU2MHRKWuX6wdJ+7tDp2eGfHI9ydmQ8=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 3D85260208;
        Thu, 20 Dec 2018 13:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545312281;
        bh=NIXtCQQK/IafPV7TqJymlEnoMphLjq6l33somg+KjZI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CD40v8/0ZHQnD14G+NYXZ8f12oxTE/L/JcYLUxphyQUJt4S/CwNaJK/lfw89d8x+J
         FTsVdLldK5s46JvZqKoA2EmQ1zmmD6d1O0wCKGF2OPmGN2R2qf2p/XG5Bz/OvnfTcN
         CKG4WE8ELHU2MHRKWuX6wdJ+7tDp2eGfHI9ydmQ8=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 20 Dec 2018 18:54:41 +0530
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
In-Reply-To: <87imzo72w8.fsf@purkki.adurom.net>
References: <1541423318-19312-1-git-send-email-govinds@codeaurora.org>
 <87d0r55ews.fsf@codeaurora.org>
 <6e831363962be4e28d7551e360ed4d46@codeaurora.org>
 <874lcg55at.fsf@codeaurora.org>
 <9f8bbfaa232c02bb33594207fa1f8821@codeaurora.org>
 <87y38ktnnm.fsf@kamboji.qca.qualcomm.com> <87imzo72w8.fsf@purkki.adurom.net>
Message-ID: <b3117fed581713cc60538705760fdf90@codeaurora.org>
X-Sender: govinds@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Kalle,

On 2018-12-20 18:48, Kalle Valo wrote:
> Kalle Valo <kvalo@codeaurora.org> writes:
> 
>> Govind Singh <govinds@codeaurora.org> writes:
>> 
>>> Hi Kalle,
>>> 
>>> On 2018-11-17 16:39, Kalle Valo wrote:
>>>> Govind Singh <govinds@codeaurora.org> writes:
>>>> 
>>>>> On 2018-11-16 18:59, Kalle Valo wrote:
>>>>>> 
>>>>>> Via which tree are these patches going? That's not clear for me.
>>>>> 
>>>>> I guess sdm845 dtsi change should be going to
>>>>> git://git.kernel.org/pub/scm/linux/kernel/git/agross/linux.git.
>>>>> I need to send v5 to address one comment from Brian.
>>>> 
>>>> Ok, I'll then drop these from my queue.
>>> 
>>> Can you pls apply below changes to ath10k tree, i will send sdm845
>>> dtsi change as separate patch after rebase.
>>> 
>>>>>>>   dt: bindings: add missing dt properties for WCN3990 wifi node
>>>>>>>   dt: bindings: add bindings for wifi iommu node
>> 
>> Ok, these two are back in my queue:
>> 
>> https://patchwork.kernel.org/patch/10668237/
>> 
>> https://patchwork.kernel.org/patch/10668245/
>> 
>> I'll just modify the titles to use ath10k prefix to make it more clear
>> these are for ath10k:
>> 
>>    dt: bindings: ath10k: .....
> 
> There were conflicts with this commit:
> 
> 2b741a8aaa34 dt: bindings: add bindings for msa memory region
> 
> I fixed them in the pending branch, please double check carefully:
> 

Changes looks good to me.

> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=5bb88d4d49783c75ac083e4ea19b7527bc115857
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=a6d53e207670eacd72a74277658bac1ab346fabd

BR,
Govind
