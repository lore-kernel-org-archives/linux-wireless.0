Return-Path: <SRS0=KFxB=X2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0C9AECE587
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Oct 2019 13:03:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 715E821906
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Oct 2019 13:03:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BmUsK7Uj";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UwnADJT9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbfJANDP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 1 Oct 2019 09:03:15 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:60750 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbfJANDP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Oct 2019 09:03:15 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D70636055C; Tue,  1 Oct 2019 13:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569934993;
        bh=p4zIXu+5rfpDbgBWTXAcpuxmgvNJNnfGR3EsbUfdxqY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=BmUsK7UjXrnydLIfP71EHKtXXEZzCyL82sqzPSgosKZffqV+TeVtuwSTte4ErRgHh
         QieI/MYX3RPswY6pRL0x+RCQtgjYJY2XmvkhIylAuT0kSYuczPiG+zlzush6IZrXhm
         Lj7XSVoY8T9kfJJhtI6oOleaKWNQOHGIH7+YAphc=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1DCDD601D4;
        Tue,  1 Oct 2019 13:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569934992;
        bh=p4zIXu+5rfpDbgBWTXAcpuxmgvNJNnfGR3EsbUfdxqY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=UwnADJT9d3kTy1cRpDf/NZweKi/UuHE8ZWN+5JpsiluPSA4wyF5bFr1D2fuNRG01F
         +oarxmdidbzB/acjfM5ptNI+doZPd0eekMgHTuynZhJjeVLHCKj9GSi0UVdkIuOXIu
         yeTKeDnst0X3d5iGRpzK4a29u8xYPTOpvxhEoZMU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1DCDD601D4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     =?utf-8?Q?Micha=C5=82?= Kazior <kazikcz@gmail.com>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH] ath10k: restore QCA9880-AR1A (v1) detection
References: <20190906215423.23589-1-chunkeey@gmail.com>
        <20190917064412.C2E0D61572@smtp.codeaurora.org>
        <2099574.gZacamft7q@debian64>
Date:   Tue, 01 Oct 2019 16:03:08 +0300
In-Reply-To: <2099574.gZacamft7q@debian64> (Christian Lamparter's message of
        "Fri, 20 Sep 2019 19:19:06 +0200")
Message-ID: <87imp84nzn.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Christian Lamparter <chunkeey@gmail.com> writes:

> On Tuesday, September 17, 2019 8:44:12 AM CEST Kalle Valo wrote:
>> Christian Lamparter <chunkeey@gmail.com> wrote:
>> 
>> > This patch restores the old behavior that read
>> > the chip_id on the QCA988x before resetting the
>> > chip. This needs to be done in this order since
>> > the unsupported QCA988x AR1A chips fall off the
>> > bus when resetted. Otherwise the next MMIO Op
>> > after the reset causes a BUS ERROR and panic.
>> > 
>> > Cc: stable@vger.kernel.org
>> > Fixes: 1a7fecb766c8 ("ath10k: reset chip before reading chip_id in probe")
>> > Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
>> 
>> I'll drop this as there's no plan to support QCA988X hw1.0.
>
> Kalle,
>
> I'm surprised about this. And your justification "no plan to support
> QCA988X hw1.0" seems very odd in this context, because this patch does
> not add any support for the QCA988X hw1.0.

No wonder my comment was odd, it seems I had completely misunderstood :)
I assumed this is for preparation in adding QCA988X hw1.0 support, which
is clearly wrong.

> But, I could see how the mails/replies from Tom Psyborg derailed the
> topic here. Though, I'm not sure if this is the case or not.
>
> So let set the record straight and show you the result of having that
> patch applied and load ath10k_pci with a QCA9880 v1 AR1A:
>
> [ 1491.622282] ath10k_pci 0000:00:00.0: device 003c with chip_id
> 043200ff isn't supported
>
> (System is all good!)
>
> And without the patch:
>
> [  900.320000] Data bus error, epc == 86a9a1b0, ra == 86a9a4b0

[...]

> Notice the DATA BUS Error! The router is unusable at that point and no
> longer "working".

Thanks, this clear for me now. I added this back to my queue and clarify
the commit log a bit.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
