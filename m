Return-Path: <SRS0=RZjE=XF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8124C3A5A2
	for <linux-wireless@archiver.kernel.org>; Tue, 10 Sep 2019 12:59:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A99820863
	for <linux-wireless@archiver.kernel.org>; Tue, 10 Sep 2019 12:59:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dkkt1GTc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392840AbfIJM7m (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 10 Sep 2019 08:59:42 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:46713 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbfIJM7m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Sep 2019 08:59:42 -0400
Received: by mail-ot1-f68.google.com with SMTP id g19so18402425otg.13
        for <linux-wireless@vger.kernel.org>; Tue, 10 Sep 2019 05:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=jqek9cTuxOVyyem7HaT7VFiIzPh0AIP2n48z7Rb1qmA=;
        b=Dkkt1GTc2eajU+J+J+R4hnNQMJzi6EgshdS3myxu6JYLTLnFbDw3XKlP8DsYcoLJmJ
         JXPvjAWz+YL2kiyQ7Ii62ecTwo/2G2sDwR2xD58k3zgo1Cye1Y3GViwbvkW6mURGAMFF
         tEK55XaSwTMYAFaKfmbEqBInGd3S2PAQlCiNihHGphMrlBl3AADDio69gp+DiUxo4ZzB
         Rjufng5XymZhpX0QU0To3EIminv3qPZL8Lg6eoiS83DqsTqWf0jedsU3f8JOOhuzQgPg
         rRPYqvltHjuFjlURNRhBx12GTlSrHyWb0piki0D442lpxt8WAVmSrUcHwjDuN4lFanG/
         mSHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=jqek9cTuxOVyyem7HaT7VFiIzPh0AIP2n48z7Rb1qmA=;
        b=NTWj2l4OEfcqxm+GmgMsogvp08yfhDuiOxHYH6wzK6zbq7JtYdUqfG+gITK4yAMqZI
         VEtddFj9X7vOPH9qeU7EPXvHUygYG2Gmb47BtDctt7x98k2t2lZoCLfr6kCKwe/Kp/0l
         9HZWwPnr7Xn7j98LH0ta8DWO1mEP17yYwAu7+EbDed5XYQ2OoAtHH7k5gNwTy2vh013b
         AtC38ndztQIn8n9IYi8Fjb+D34M7y6CpBkUPJ4kzxKdox9mpnlXTvitpVobydR++G0uD
         FUnIf/ElNbZOm9vtLVvWhLDhV4yRmvgG/cALtdS009fRZO4FxxjIcSkIlLRbO/E2Tl0M
         eHAg==
X-Gm-Message-State: APjAAAV7S7IqkYxqG3hZ2BbT2oEOFHWuUnIW0bTlP+TtnN2/jwfEuBeh
        aqRIpA4C02CHdubd9s0lmP7s7u83Yyhp/+D81mTmcQ==
X-Google-Smtp-Source: APXvYqyX7NKFXkv1ChR/FaEEzbd9XYAjINqR1jnnsqiWInRfuPzyhU/HLE8lu90CV18CG5xzGnpErJWhxu35cHZOWzY=
X-Received: by 2002:a05:6830:18f3:: with SMTP id d19mr13675533otf.256.1568120381700;
 Tue, 10 Sep 2019 05:59:41 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:2286:0:0:0:0:0 with HTTP; Tue, 10 Sep 2019 05:59:40
 -0700 (PDT)
In-Reply-To: <87h85kfwfn.fsf@codeaurora.org>
References: <20190906215423.23589-1-chunkeey@gmail.com> <20190907214359.1C52A21835@mail.kernel.org>
 <CAKR_QVKv8kgXSSCwd8esw28hARA61Pah3usRi+ZZG6ss2CcS=g@mail.gmail.com> <87h85kfwfn.fsf@codeaurora.org>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Tue, 10 Sep 2019 14:59:40 +0200
Message-ID: <CAKR_QVJpGZCBaE3hW6FShykYa=T6hy2dHn22daQVodWGL_-Afw@mail.gmail.com>
Subject: Re: [PATCH] ath10k: restore QCA9880-AR1A (v1) detection
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Sasha Levin <sashal@kernel.org>, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org,
        Christian Lamparter <chunkeey@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/09/2019, Kalle Valo <kvalo@codeaurora.org> wrote:
> (dropping stable list)
>
> Tom Psyborg <pozega.tomislav@gmail.com> writes:
>
>> According to this very old post
>> http://lists.infradead.org/pipermail/ath10k/2013-July/000021.html
>> seems like you've been misinformed on amount of these cards that were
>> put out in the market.
>>
>> At least digipart only have >40000 units in stocks
>> https://www.digipart.com/part/QCA9880-AR1A and other retailers
>> probably few thousands more.
>>
>> With that large amount of cards I think it is justified to request
>> firmware support for the chip. And probably a lot easier to make few
>> firmware modifications than go hacking a bunch of API calls so it
>> works with v2 firmware.
>
> I'm very surprised that QCA9880 hw1.0 boards are still available, after
> six years. Did you confirm that it really is hw1.0 and not just some
> mixup with hardware ids or something like that?

Print on the chip clearly says QCA9880-AR1A. ID same as for v2 - 003C.

> old hw1.0 firmware to see if it works.

I don't know which fw blob version that is. I could not find it
online. All files are v2 related.

>
> But if it's really is hw1.0 I doubt there will be any support for that.
> I recommend to avoid hw1.0 altogether.
>
> --
> Kalle Valo
>

That would be too bad, even worse when you find out that
qca-wifi-10.2.4.58.1 driver fails to load firmware too. The only one
that works is qca-wifi that comes with tp-link firmware, some very
early version 10.0.108 or somtehing like that that has no available
sources..
