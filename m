Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6C7DC6786C
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 14:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E8D02098A
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 14:49:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="d72Qj0cK";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZXspv1G0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E8D02098A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbeJLWWa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 18:22:30 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:52544 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728720AbeJLWWa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 18:22:30 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C639F607DC; Fri, 12 Oct 2018 14:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539355782;
        bh=zwMqod3rbP8TiPUsqY6d9ddUuINHvHFC/DANIdaS/wM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=d72Qj0cKmhnWs6GxNGsMiRm/HZuXKbtXRPviouyBmOUOeKFl9Gayb7dtLBpmn66xC
         mSFkkjoKi2ieD0ab9OpqI01XHcS2RdnYVmcNufUIQf1+gphFQIxLkpl8ZzSkmqXWYx
         TkGrFun34s0Wc1yfiRppFbnVm0K1OI+D39udtnYs=
Received: from potku.adurom.net (88-114-240-228.elisa-laajakaista.fi [88.114.240.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 28CB2607DC;
        Fri, 12 Oct 2018 14:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539355781;
        bh=zwMqod3rbP8TiPUsqY6d9ddUuINHvHFC/DANIdaS/wM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ZXspv1G0pyiIp+lrjwEM7N2EbQ/jFLMZacZBmkFGRtBdLQ+ew78Td9etLWDdrc+kJ
         AvABGIcz0pFG4MXfq1SjApEoKUnAvF70W9kkoVSPaD1TNqC3FHgRR2vqau6u4R6etg
         BYNebzn3RnUF3qshSS3Agbo5/y1hhulL9UIagGeA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 28CB2607DC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     kbuild test robot <lkp@intel.com>, pillair@codeaurora.org,
        kbuild-all@01.org, ath10k@lists.infradead.org,
        svishnoi@codeaurora.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath6kl:pending 10/15] ERROR: "__udivdi3" [drivers/net/wireless/ath/ath10k/ath10k_core.ko] undefined!
References: <201810090804.eQbqAwdi%fengguang.wu@intel.com>
        <87pnwf44n6.fsf@kamboji.qca.qualcomm.com>
        <CAK8P3a2NaKwHwe3RE_wZN6=myd1dqtWC91EJahbbKuS2oZ+xXw@mail.gmail.com>
Date:   Fri, 12 Oct 2018 17:49:37 +0300
In-Reply-To: <CAK8P3a2NaKwHwe3RE_wZN6=myd1dqtWC91EJahbbKuS2oZ+xXw@mail.gmail.com>
        (Arnd Bergmann's message of "Fri, 12 Oct 2018 16:46:10 +0200")
Message-ID: <878t3343um.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> On Fri, Oct 12, 2018 at 4:32 PM Kalle Valo <kvalo@codeaurora.org> wrote:
>>
>> + linux-wireless, arnd
>>
>> >
>> >>> ERROR: "__udivdi3" [drivers/net/wireless/ath/ath10k/ath10k_core.ko] undefined!
>> >>> ERROR: "__divdi3" [drivers/net/wireless/ath/ath10k/ath10k_core.ko] undefined!
>>
>> I'm not sure what this is about. The corresponding patch is here:
>>
>> https://patchwork.kernel.org/patch/10624567/
>>
>> I see some division in the patch but I can't immeaditely see what's
>> wrong. So is this a problem in the bot, in parisc architecture or with
>> the patch? Anyone have any good ideas? Arnd?
>>
>
> I think the problem is that 'clock_freq' is a 'u64', which means we can't use
> a normal 32-bit division. It looks like it cannot actually go beyond the
> range of a u32, so changing the type should be sufficient.

Great, thanks for the quick help :)

-- 
Kalle Valo
