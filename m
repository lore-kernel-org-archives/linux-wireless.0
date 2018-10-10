Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EABAEC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 15:40:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB3D02086D
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 15:40:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB3D02086D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbeJJXDk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 19:03:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38508 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726525AbeJJXDk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 19:03:40 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2BAE4307C713;
        Wed, 10 Oct 2018 15:40:57 +0000 (UTC)
Received: from localhost (ovpn-204-35.brq.redhat.com [10.40.204.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4ECA18D55A;
        Wed, 10 Oct 2018 15:40:56 +0000 (UTC)
Date:   Wed, 10 Oct 2018 17:40:55 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Tom Psyborg <pozega.tomislav@gmail.com>
Cc:     Daniel Golle <daniel@makrotopia.org>,
        linux-wireless@vger.kernel.org, Mathias Kresin <dev@kresin.me>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH v3 4/4] rt2800: fix registers init for MT7620
Message-ID: <20181010154054.GA27779@redhat.com>
References: <1539086170-32528-1-git-send-email-sgruszka@redhat.com>
 <1539086170-32528-4-git-send-email-sgruszka@redhat.com>
 <CAKR_QV+0z-5ee=sbEawFSnEF2ngvJSUPpNUoY_oPK1Cfk9P0iA@mail.gmail.com>
 <20181010071451.GA9140@redhat.com>
 <20181010120657.GA1185@makrotopia.org>
 <20181010124508.GA22330@redhat.com>
 <CAKR_QVJbtzpu6v4bZEz2UegWiAy1Ohooy-TciZcOeR_p+Z+yYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKR_QVJbtzpu6v4bZEz2UegWiAy1Ohooy-TciZcOeR_p+Z+yYg@mail.gmail.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Wed, 10 Oct 2018 15:40:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 10, 2018 at 04:11:12PM +0200, Tom Psyborg wrote:
> case 1:
> 
> 	} else if (rt2x00_rt(rt2x00dev, RT5390) ||
> 		   rt2x00_rt(rt2x00dev, RT5392)) {
> 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000404);
> 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00080606);
> 		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
> 	} else if (rt2x00_rt(rt2x00dev, RT5592)) {
> 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000404);
> 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00000000);
> 		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
> 	} else if (rt2x00_rt(rt2x00dev, RT5350)) {
> 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000404);
> 	} else if (rt2x00_rt(rt2x00dev, RT6352)) {
> 		rt2800_register_write(rt2x00dev, MIMO_PS_CFG, 0x00000002);
> 		rt2800_register_write(rt2x00dev, TX_PIN_CFG, 0x00150F0F);
> 		rt2800_register_write(rt2x00dev, TX_ALC_VGA3, 0x06060606);
> 		rt2800_register_write(rt2x00dev, TX0_BB_GAIN_ATTEN, 0x0);
> 		rt2800_register_write(rt2x00dev, TX1_BB_GAIN_ATTEN, 0x0);
> 		rt2800_register_write(rt2x00dev, TX0_RF_GAIN_ATTEN, 0x6C6C666C);
> 		rt2800_register_write(rt2x00dev, TX1_RF_GAIN_ATTEN, 0x6C6C666C);
> 
> does your 6352 wifi work?
> 
> case 2:
> 
> 	} else if (rt2x00_rt(rt2x00dev, RT5390) ||
> 		   rt2x00_rt(rt2x00dev, RT5392)) {
> 	} else if (rt2x00_rt(rt2x00dev, RT5592)) {
> 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000404);
> 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00000000);
> 		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
> 	} else if (rt2x00_rt(rt2x00dev, RT5350)) {
> 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000404);
> 	} else if (rt2x00_rt(rt2x00dev, RT6352)) {
> 		rt2800_register_write(rt2x00dev, MIMO_PS_CFG, 0x00000002);
> 		rt2800_register_write(rt2x00dev, TX_PIN_CFG, 0x00150F0F);
> 		rt2800_register_write(rt2x00dev, TX_ALC_VGA3, 0x06060606);
> 		rt2800_register_write(rt2x00dev, TX0_BB_GAIN_ATTEN, 0x0);
> 		rt2800_register_write(rt2x00dev, TX1_BB_GAIN_ATTEN, 0x0);
> 		rt2800_register_write(rt2x00dev, TX0_RF_GAIN_ATTEN, 0x6C6C666C);
> 		rt2800_register_write(rt2x00dev, TX1_RF_GAIN_ATTEN, 0x6C6C666C);
> 
> does your 6352 wifi still work?

I checked 'case 2' (on my 'rt2x00' branch on top of 'openwrt-18.06'):

https://github.com/sgruszka/openwrt/commit/8abecc22605bd0221022673a3671201256cff72b

wifi still does work on my MT7620 router with above change and print
is correct.

If it does not work for you, we have to figure this out. Maybe there are
extra patches that broke things or there are some race conditions when
setting "rt =" . Hard to tell. Perhaps you could provide dmesg 
from router where is does not work ?

Thanks
Stanislaw
