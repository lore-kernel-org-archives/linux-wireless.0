Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88CECC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 20:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15B10206B2
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 20:03:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H6g8vZwR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 15B10206B2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbeJKD04 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 23:26:56 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:37314 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbeJKD04 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 23:26:56 -0400
Received: by mail-oi1-f195.google.com with SMTP id e17-v6so5153576oib.4
        for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2018 13:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=ETwSclotxRPBKyqpmun1EXLodV3SuMw2h7E83Dquytg=;
        b=H6g8vZwRKmUQVpyzgPtj0jQkctFzhxaSYG7nRqTi58CpP0jS75n8Ul+wjPbtCG9F6Z
         meNAcHJ0+I6/THzICCMXBljbgYqUQx8VAGrJKaHKrIH9k4pNnOEJhdmDvWWl+3a/d95y
         uUu51ypfcFnpXEoTHCCx9U0l8C5WUUhBFLxz+uIV/KIHyuC7iGgkkjTW2Os98UtxQk/d
         tvg4FxJQcCm6mrjgqm4ND0TYr1jGJdMoZfAYGiPsbhIp05V2w8O1JxcjQ0J+nWNfuXvW
         2fPYw/IYRRM/laFVBlWMaMXTTvS0k1TFnxr+eLQMRrnzZLlpYjQLGksQ16pV8HyZWaWP
         elKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=ETwSclotxRPBKyqpmun1EXLodV3SuMw2h7E83Dquytg=;
        b=LdU7hXyLiVO22ARZfZ03fufAlsHp5fXOFBFn9qa9NN4W0RkBgqbtSSDTNIGOwJSE4+
         tXSmaGBTdW6uu7mksIZO2RRZRc9tvdpYGIAaZA2uIvFSt+4cj4dLamP1UGyZP+CbXCz6
         NP3NMxlfXOd1DnKZomUFanexpandTF7gLwMktDnOO/vhROLEHCE8VHP4BVCetODvnPY5
         MSyB0D3ttvINXZKrgzw+YGM9zRTB7OD2cPG+8dYCMaeCzPTYEkDk87PQ+TBTE44FJxWZ
         AZ9MzQql/mJRGAsvvdH7lCltCONXVlxPH8iUxNcCKnP45p55zAKA3Opa6ZTlTqltawvx
         1AgA==
X-Gm-Message-State: ABuFfoge21rM2y0b6tK53spTxKv3eMCWIR+2G5M/LYOgUCfEPxxK9A/v
        huUo6NgrJSE3MIFwSdrPDDiLeGB8iX0U2/NfL4g=
X-Google-Smtp-Source: ACcGV60vEeBbtw9ZAi7NYqoD49ZBCG8NW3tIsYvNbDPhmy3GxAgvXGW/nXOa+SLbTnOhL8bTcKjBN4i/jDRDKB/aBt8=
X-Received: by 2002:aca:484a:: with SMTP id v71-v6mr2547954oia.163.1539201793014;
 Wed, 10 Oct 2018 13:03:13 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:2eab:0:0:0:0:0 with HTTP; Wed, 10 Oct 2018 13:03:12
 -0700 (PDT)
In-Reply-To: <20181010154054.GA27779@redhat.com>
References: <1539086170-32528-1-git-send-email-sgruszka@redhat.com>
 <1539086170-32528-4-git-send-email-sgruszka@redhat.com> <CAKR_QV+0z-5ee=sbEawFSnEF2ngvJSUPpNUoY_oPK1Cfk9P0iA@mail.gmail.com>
 <20181010071451.GA9140@redhat.com> <20181010120657.GA1185@makrotopia.org>
 <20181010124508.GA22330@redhat.com> <CAKR_QVJbtzpu6v4bZEz2UegWiAy1Ohooy-TciZcOeR_p+Z+yYg@mail.gmail.com>
 <20181010154054.GA27779@redhat.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Wed, 10 Oct 2018 22:03:12 +0200
Message-ID: <CAKR_QVLjFyGtzikLTiQKhrVBSyUoPmDn2tMJqto8dyBDjoFJOQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] rt2800: fix registers init for MT7620
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Daniel Golle <daniel@makrotopia.org>,
        linux-wireless@vger.kernel.org, Mathias Kresin <dev@kresin.me>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

ok, that is strange. do you see any performance differences without
TX_SW_CFG regs? iperf test is a good pointer.

this was a problem on xiaomi mini with old DD trunk builds on 4.4
kernel and LEDE builds from last year. i ain't got no chance to try
this on 18.06. which device you tried this on? if ipa/ilna it might
make no difference

On 10/10/2018, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Wed, Oct 10, 2018 at 04:11:12PM +0200, Tom Psyborg wrote:
>> case 1:
>>
>> 	} else if (rt2x00_rt(rt2x00dev, RT5390) ||
>> 		   rt2x00_rt(rt2x00dev, RT5392)) {
>> 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000404);
>> 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00080606);
>> 		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
>> 	} else if (rt2x00_rt(rt2x00dev, RT5592)) {
>> 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000404);
>> 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00000000);
>> 		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
>> 	} else if (rt2x00_rt(rt2x00dev, RT5350)) {
>> 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000404);
>> 	} else if (rt2x00_rt(rt2x00dev, RT6352)) {
>> 		rt2800_register_write(rt2x00dev, MIMO_PS_CFG, 0x00000002);
>> 		rt2800_register_write(rt2x00dev, TX_PIN_CFG, 0x00150F0F);
>> 		rt2800_register_write(rt2x00dev, TX_ALC_VGA3, 0x06060606);
>> 		rt2800_register_write(rt2x00dev, TX0_BB_GAIN_ATTEN, 0x0);
>> 		rt2800_register_write(rt2x00dev, TX1_BB_GAIN_ATTEN, 0x0);
>> 		rt2800_register_write(rt2x00dev, TX0_RF_GAIN_ATTEN, 0x6C6C666C);
>> 		rt2800_register_write(rt2x00dev, TX1_RF_GAIN_ATTEN, 0x6C6C666C);
>>
>> does your 6352 wifi work?
>>
>> case 2:
>>
>> 	} else if (rt2x00_rt(rt2x00dev, RT5390) ||
>> 		   rt2x00_rt(rt2x00dev, RT5392)) {
>> 	} else if (rt2x00_rt(rt2x00dev, RT5592)) {
>> 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000404);
>> 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00000000);
>> 		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
>> 	} else if (rt2x00_rt(rt2x00dev, RT5350)) {
>> 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000404);
>> 	} else if (rt2x00_rt(rt2x00dev, RT6352)) {
>> 		rt2800_register_write(rt2x00dev, MIMO_PS_CFG, 0x00000002);
>> 		rt2800_register_write(rt2x00dev, TX_PIN_CFG, 0x00150F0F);
>> 		rt2800_register_write(rt2x00dev, TX_ALC_VGA3, 0x06060606);
>> 		rt2800_register_write(rt2x00dev, TX0_BB_GAIN_ATTEN, 0x0);
>> 		rt2800_register_write(rt2x00dev, TX1_BB_GAIN_ATTEN, 0x0);
>> 		rt2800_register_write(rt2x00dev, TX0_RF_GAIN_ATTEN, 0x6C6C666C);
>> 		rt2800_register_write(rt2x00dev, TX1_RF_GAIN_ATTEN, 0x6C6C666C);
>>
>> does your 6352 wifi still work?
>
> I checked 'case 2' (on my 'rt2x00' branch on top of 'openwrt-18.06'):
>
> https://github.com/sgruszka/openwrt/commit/8abecc22605bd0221022673a3671201256cff72b
>
> wifi still does work on my MT7620 router with above change and print
> is correct.
>
> If it does not work for you, we have to figure this out. Maybe there are
> extra patches that broke things or there are some race conditions when
> setting "rt =" . Hard to tell. Perhaps you could provide dmesg
> from router where is does not work ?
>
> Thanks
> Stanislaw
>
