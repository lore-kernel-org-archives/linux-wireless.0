Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 057CBC0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 14:58:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEF802085A
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 14:58:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JR+bKfl9";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JR+bKfl9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BEF802085A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729646AbeKFASL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 19:18:11 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:48178 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbeKFASL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 19:18:11 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B321E6044B; Mon,  5 Nov 2018 14:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541429884;
        bh=MOfga+nQ2MjsB0mxkj/noLSfLl/ulvT7ms9sHlVVpmk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=JR+bKfl9E7Ek9igXyc27LHz/zO+cJDHIWINeYORL61TbFLmlPkArmp6dwv9vX3mtj
         twwUcB9nyr1mWEwtZ6uBkmEYd5hxVhX3FfPaOpor8l5jPvNO5Q6P7EXe6M0dJVq4cO
         AW0yRvllN9atKONM8WDhH65pvluqYUGCrECNYw3E=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 88B7160271;
        Mon,  5 Nov 2018 14:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541429884;
        bh=MOfga+nQ2MjsB0mxkj/noLSfLl/ulvT7ms9sHlVVpmk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=JR+bKfl9E7Ek9igXyc27LHz/zO+cJDHIWINeYORL61TbFLmlPkArmp6dwv9vX3mtj
         twwUcB9nyr1mWEwtZ6uBkmEYd5hxVhX3FfPaOpor8l5jPvNO5Q6P7EXe6M0dJVq4cO
         AW0yRvllN9atKONM8WDhH65pvluqYUGCrECNYw3E=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 88B7160271
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76x0: use band parameter for LC calibration
References: <1540484313-9354-1-git-send-email-sgruszka@redhat.com>
        <20181030131854.GA26291@redhat.com>
Date:   Mon, 05 Nov 2018 16:58:00 +0200
In-Reply-To: <20181030131854.GA26291@redhat.com> (Stanislaw Gruszka's message
        of "Tue, 30 Oct 2018 14:20:59 +0100")
Message-ID: <87efbzbmh3.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> On Thu, Oct 25, 2018 at 06:18:33PM +0200, Stanislaw Gruszka wrote:
>> We use always 1 as band parameter for MCU_CAL_LC, this break 2GHz,
>> we should use 0 for this band instead.
>> 
>> Patch fixes problems happened sometimes when try to associate with 2GHz
>> AP and manifest by errors like below:
>> 
>> [14680.920823] wlan0: authenticate with 18:31:bf:c0:51:b0
>> [14681.109506] wlan0: send auth to 18:31:bf:c0:51:b0 (try 1/3)
>> [14681.310454] wlan0: send auth to 18:31:bf:c0:51:b0 (try 2/3)
>> [14681.518469] wlan0: send auth to 18:31:bf:c0:51:b0 (try 3/3)
>> [14681.726499] wlan0: authentication with 18:31:bf:c0:51:b0 timed out
>> 
>> Fixes: 9aec146d0f6b ("mt76x0: pci: introduce mt76x0_phy_calirate routine")
>> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
>> ---
>> This is for 4.20.
>
> Actually it is not needed for 4.20, bacause the new calibrate code is
> not use for USB in 4.20. It start to be used since:
>
> commit e868a944c55b1f42303ab2941dc1aaada9a3570c
> Author: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> Date:   Mon Oct 15 14:18:05 2018 +0200
>
>     mt76x0: phy: unify calibration between mt76x0u and mt76x0e

So what should happen to this patch? Will Felix take it?

-- 
Kalle Valo
