Return-Path: <SRS0=pQzZ=MS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54804C65C30
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 11:34:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0284E2147D
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 11:34:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="nQC52cRB";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="nQC52cRB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0284E2147D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbeJFShb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 14:37:31 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:40800 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727140AbeJFShb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 14:37:31 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A0F6E60C4E; Sat,  6 Oct 2018 11:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538825676;
        bh=wHV1ExdDiTwZieBlpfuAUHZrsDxGcmT+6A+M3eNWSm0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=nQC52cRB2/Yq/z2ikUGRsRYMpwjSxt+taId7x2oWSEcuzAydgDddg9q2WWvPWZ4L/
         2+NXPLynmXqR3CXcLtuJNb0Z+frfMI9SMOQxKs9owql15sHJdVb2FWR2ubYs75gXx9
         XqoW+cWi4v9NzUlLRXe8lipKeA4dBrm9K27pJ4uY=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EB086607F4;
        Sat,  6 Oct 2018 11:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538825676;
        bh=wHV1ExdDiTwZieBlpfuAUHZrsDxGcmT+6A+M3eNWSm0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=nQC52cRB2/Yq/z2ikUGRsRYMpwjSxt+taId7x2oWSEcuzAydgDddg9q2WWvPWZ4L/
         2+NXPLynmXqR3CXcLtuJNb0Z+frfMI9SMOQxKs9owql15sHJdVb2FWR2ubYs75gXx9
         XqoW+cWi4v9NzUlLRXe8lipKeA4dBrm9K27pJ4uY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EB086607F4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Erik Stromdahl <erik.stromdahl@gmail.com>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [RFC v5 01/12] ath10k: add struct ath10k_bus_params
References: <20180603182029.8914-2-erik.stromdahl@gmail.com>
        <20180906161624.B4751606FA@smtp.codeaurora.org>
        <9de4aaff-a26c-cac3-bc73-069834820a14@gmail.com>
Date:   Sat, 06 Oct 2018 14:34:32 +0300
In-Reply-To: <9de4aaff-a26c-cac3-bc73-069834820a14@gmail.com> (Erik
        Stromdahl's message of "Thu, 6 Sep 2018 20:22:08 +0200")
Message-ID: <87ftxjgvg7.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Erik Stromdahl <erik.stromdahl@gmail.com> writes:

> On 9/6/18 6:16 PM, Kalle Valo wrote:
>> Erik Stromdahl <erik.stromdahl@gmail.com> wrote:
>>
>>> This struct is used as argument to ath10k_core_register in order to
>>> make it easier to add more bus parameters in the future.
>>>
>>> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
>>> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
>>
>> 12 patches applied to ath-next branch of ath.git, thanks.
>>
>> c0d8d565787c ath10k: add struct ath10k_bus_params
>> 7c2dd6154fc2 ath10k: add device type enum to ath10k_bus_params
>> 367c899f622c ath10k: add bus type check in ath10k_init_hw_params
>> 9faaa14387fb ath10k: use hw_params.num_peers for num_tids in TLV init
>> 4875e0b52085 ath10k: add per target config of max_num_peers
>> e66d5361127a ath10k: DMA related fixes for high latency devices
>> 852d1bf86a5b ath10k: add HTT TX HL ops
>> d4e7f553eec3 ath10k: add HTT RX HL ops
>> 4daacc950d4d ath10k: htt: RX ring config HL support
>> a2097d6444c3 ath10k: htt: High latency TX support
>> f88d49345040 ath10k: htt: High latency RX support
>> 37f62c0d5822 ath10k: wmi: disable softirq's while calling ieee80211_rx
>>
>
> I am afraid that one of the patches in this series causes a regression
> for PCI devices :(
>
> The patch is:
>
> 4875e0b52085 ath10k: add per target config of max_num_peers
>
> With this patch I got an error during driver load.
> Reverting the patch solved the problem.
>
> I discovered this yesterday when I was setting up a test AP with an
> ath10k pcie device.
> I thought it would be a good idea to use my own tree just to make sure
> it works with PCI, and apparently it didn't work.
> I did some bisecting and the patch mentioned above turned out to be the culprit.
> I have not looked into why it fails yet (I think it is related to a
> bad num_peers value in the ath10k_hw_params_list array),
> I just noticed that reverting the patch solved the problem
>
> I was actually planning on submitting a v6 series with this patch
> removed, but you were faster.

Yeah, sorry about this. I noticed you marked the patchset as RFC but as
they looked so good I decided to take them anyway :)

But thanks for the quick fixes which I have applied and I think
everything is good now, right?

-- 
Kalle Valo
