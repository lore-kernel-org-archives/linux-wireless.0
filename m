Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABAEEC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 14:11:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56B342087A
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 14:11:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BBKIg0GR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 56B342087A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbeJJVde (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 17:33:34 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:34913 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbeJJVde (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 17:33:34 -0400
Received: by mail-ot1-f67.google.com with SMTP id 14so1463931oth.2
        for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2018 07:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=dGybtr+FrhsD0wOlMzW0+HGHsEZ8QinaXLPibsRpWE8=;
        b=BBKIg0GRfolq0bfZMuVsBFUDLfaJMjO+ifRqx2tQrL7pIMPrFMcmepb2YF6dlQTfCU
         fVqHIyF/4wFU4+fLFqluuT1H+6A47x5UbLjvpTPYQNz7T6Wt5CzYTOrXnfsHdomc5v9o
         Y8zQOtCqKqGZaVkLvP4/dFBAP+joxBfmcmekKj0Bs641FY994MpdSRDZOgcwyreN5PXT
         fhmK1CQnbltt6PDtSzTK/70Shpml5q6Kq0cfpofGW0mT/law0mtCk/zs/pJPWHu0/gBO
         0qOH6YgzXkdGYYCrEEvKbcnSkUXJLefdjtulPb/RaWOjX20kjQlEGQF2CKv5ZZP3PORh
         8d1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=dGybtr+FrhsD0wOlMzW0+HGHsEZ8QinaXLPibsRpWE8=;
        b=mZP8txVbuVhyakKuSF4ORjn54LzgUp9EQcWgOdKDcuBpIj9NXknjnVPwAbXXh7IKoo
         8DVPoxgbPzqQlSgxIuyz0iEHT3bXSgmM9i5asjzuIy/wvw8rlemTDJy5rU9ugqtbwptr
         5hRjnsTQqTNksyMq7Rr6rqX/16hS78ITqKSSJ9Vh5Sg3AQJEQOhsG/GqoR6ih5gHuHRu
         emCVT60hPfogV5RAeoBzBSanlnw6lPVHLrbMU2ax3bGkZ+115/wlHDZha/DimbaNITEV
         a4Sq85IuxTY+5SlM3ABHkBa/US7H9Z9VSRk+i1ydgd9uk2d9Q5J2ImxKKH1+HZl7vyRl
         M7uQ==
X-Gm-Message-State: ABuFfohKPkR+vlVI6S9VMN87y7/06ezSlCrv25lXUEVgXTQ+6gwz/swi
        w+6I8wZYRbLrvMEg+DmfbJipGTGOtzcnOHp2pHY=
X-Google-Smtp-Source: ACcGV627nDh+iHaGI7Z93exdxfHvgV/xCg17MJVN2IZA82UN2P5ZyIBdz6c18kwgPeEfZ33GBU8J9NQdAMSxJaulRHc=
X-Received: by 2002:a9d:11b2:: with SMTP id v47mr18723632otf.281.1539180672797;
 Wed, 10 Oct 2018 07:11:12 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:2eab:0:0:0:0:0 with HTTP; Wed, 10 Oct 2018 07:11:12
 -0700 (PDT)
In-Reply-To: <20181010124508.GA22330@redhat.com>
References: <1539086170-32528-1-git-send-email-sgruszka@redhat.com>
 <1539086170-32528-4-git-send-email-sgruszka@redhat.com> <CAKR_QV+0z-5ee=sbEawFSnEF2ngvJSUPpNUoY_oPK1Cfk9P0iA@mail.gmail.com>
 <20181010071451.GA9140@redhat.com> <20181010120657.GA1185@makrotopia.org> <20181010124508.GA22330@redhat.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Wed, 10 Oct 2018 16:11:12 +0200
Message-ID: <CAKR_QVJbtzpu6v4bZEz2UegWiAy1Ohooy-TciZcOeR_p+Z+yYg@mail.gmail.com>
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

case 1:

	} else if (rt2x00_rt(rt2x00dev, RT5390) ||
		   rt2x00_rt(rt2x00dev, RT5392)) {
		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000404);
		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00080606);
		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
	} else if (rt2x00_rt(rt2x00dev, RT5592)) {
		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000404);
		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00000000);
		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
	} else if (rt2x00_rt(rt2x00dev, RT5350)) {
		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000404);
	} else if (rt2x00_rt(rt2x00dev, RT6352)) {
		rt2800_register_write(rt2x00dev, MIMO_PS_CFG, 0x00000002);
		rt2800_register_write(rt2x00dev, TX_PIN_CFG, 0x00150F0F);
		rt2800_register_write(rt2x00dev, TX_ALC_VGA3, 0x06060606);
		rt2800_register_write(rt2x00dev, TX0_BB_GAIN_ATTEN, 0x0);
		rt2800_register_write(rt2x00dev, TX1_BB_GAIN_ATTEN, 0x0);
		rt2800_register_write(rt2x00dev, TX0_RF_GAIN_ATTEN, 0x6C6C666C);
		rt2800_register_write(rt2x00dev, TX1_RF_GAIN_ATTEN, 0x6C6C666C);

does your 6352 wifi work?

case 2:

	} else if (rt2x00_rt(rt2x00dev, RT5390) ||
		   rt2x00_rt(rt2x00dev, RT5392)) {
	} else if (rt2x00_rt(rt2x00dev, RT5592)) {
		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000404);
		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00000000);
		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
	} else if (rt2x00_rt(rt2x00dev, RT5350)) {
		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000404);
	} else if (rt2x00_rt(rt2x00dev, RT6352)) {
		rt2800_register_write(rt2x00dev, MIMO_PS_CFG, 0x00000002);
		rt2800_register_write(rt2x00dev, TX_PIN_CFG, 0x00150F0F);
		rt2800_register_write(rt2x00dev, TX_ALC_VGA3, 0x06060606);
		rt2800_register_write(rt2x00dev, TX0_BB_GAIN_ATTEN, 0x0);
		rt2800_register_write(rt2x00dev, TX1_BB_GAIN_ATTEN, 0x0);
		rt2800_register_write(rt2x00dev, TX0_RF_GAIN_ATTEN, 0x6C6C666C);
		rt2800_register_write(rt2x00dev, TX1_RF_GAIN_ATTEN, 0x6C6C666C);

does your 6352 wifi still work?


On 10/10/2018, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Hello
>
> On Wed, Oct 10, 2018 at 02:06:58PM +0200, Daniel Golle wrote:
>> > > https://github.com/psyborg55/linux/commit/24b46d482590a87553df1de0b5c8032f363cb7cf
>> > >  ?
>> > >
>> > >  using this code to determine 7620 soc
>> > >
>> > >  if (rt == RT5390 && rt2x00_is_soc(rt2x00dev))
>> > >          rt = RT6352;
>> > >
>> > >  somehow did not work in rt2800_init_registers routine. i could
>> > > verify
>> > >  that by removing tx_sw_cfg registers from rt6352 and the wifi would
>> > >  still work, unless removed them from rt5390 also
>> >
>> > I tested by adding additional printk("Init RT6352 registers\n"); in
>> > if (rt2x00_rt(rt2x00dev, RT6352)) branch. The message was printed:
>> >
>> > [   68.049946] ieee80211 phy0: rt2x00_set_rt: Info - RT chipset 6352,
>> > rev 0500 detected
>> > [   68.065392] ieee80211 phy0: rt2x00_set_rf: Info - RF chipset 7620
>> > detected
>> > [   68.079777] ieee80211 phy0: Selected rate control algorithm
>> > 'minstrel_ht'
>> > [   68.177760] kmodloader: done loading kernel modules from
>> > /etc/modules.d/*
>> > [   68.825758] urandom_read: 5 callbacks suppressed
>> > [   68.825768] random: jshn: uninitialized urandom read (4 bytes read)
>> > [   77.792400] 8021q: adding VLAN 0 to HW filter on device eth0
>> > [   77.825045] br-lan: port 1(eth0.1) entered blocking state
>> > [   77.836032] br-lan: port 1(eth0.1) entered disabled state
>> > [   77.847156] device eth0.1 entered promiscuous mode
>> > [   77.856739] device eth0 entered promiscuous mode
>> > [   77.931043] br-lan: port 1(eth0.1) entered blocking state
>> > [   77.941861] br-lan: port 1(eth0.1) entered forwarding state
>> > [   77.953171] IPv6: ADDRCONF(NETDEV_UP): br-lan: link is not ready
>> > [   78.849852] IPv6: ADDRCONF(NETDEV_CHANGE): br-lan: link becomes
>> > ready
>> > [   82.302306] Init RT6352 registers
>> >
>> > Perhaps rt2x00_is_soc(rt2x00dev) does not work on this particular
>> > system
>> > that you have and device is configured as RT5390 ? I.e. maybe this is
>> > PCIe device. This should be printed in :
>> >
>> > ieee80211 phy0: rt2x00_set_rt: Info - RT chipset 6352, rev 0500
>> > detected
>> >
>> > line, you should have 'RT chipset 5390' instead.
>>
>> RT6352 is the pre-mediatek-merge name of MT7620A/N. It is always a SoC.
>> The RF part of both MT7620A and MT7620N identifies as RT5390. The
>> vendor driver also uses an equivalent check to destinguish between the
>> actual PCIe/USB RT5390xx and RT6352, see
>>
>> https://github.com/i80s/mtk-sources/blob/master/mt7620/src/include/rtmp_chip.h#L114
>
> Yes , but this does not explain why things do not work as
> expected for Tomislav, which IIUC use RT5390 configuration.
>
> Perhaps the check:
>
> 	if (rt == RT5390 && rt2x00_is_soc(rt2x00dev))
> 		rt = RT6352;
>
> should be some how modified to work on Tomislav's hardware ?
>
> Thanks
> Stanislaw
>
