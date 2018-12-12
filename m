Return-Path: <SRS0=wq86=OV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 672D2C67839
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 18:31:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 384B820851
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 18:31:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 384B820851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=atomide.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728337AbeLLSb0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 12 Dec 2018 13:31:26 -0500
Received: from muru.com ([72.249.23.125]:57838 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727900AbeLLSbU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Dec 2018 13:31:20 -0500
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 44C86809F;
        Wed, 12 Dec 2018 18:31:23 +0000 (UTC)
Date:   Wed, 12 Dec 2018 10:31:16 -0800
From:   Tony Lindgren <tony@atomide.com>
To:     "Reizer, Eyal" <eyalr@ti.com>
Cc:     Ricardo Salveti <rsalveti@rsalveti.net>,
        John Stultz <john.stultz@linaro.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "anders.roxell@linaro.org" <anders.roxell@linaro.org>
Subject: Re: [EXTERNAL] Re: wlcore getting stuck on hikey after the runtime
 PM autosuspend support change
Message-ID: <20181212183116.GH39861@atomide.com>
References: <20181211181944.GW39861@atomide.com>
 <CAHYQr0pk-WKM-aYR7ubM4GHx8PA82XP5ze9TW9WEJLzdO0f88A@mail.gmail.com>
 <20181211190128.GX39861@atomide.com>
 <CAHYQr0qc_Lav=1sEGcOmOykUftWRzd6+vis97eBpanEXzfUHaA@mail.gmail.com>
 <CALAqxLUVajBw_PkyhA0s=FhQQHWu1FBEMX+4oDTStRXr6L5Txw@mail.gmail.com>
 <20181211201221.GY39861@atomide.com>
 <CAHYQr0qffa_G2ZVnSsDfjqSgxuBBZB+8e6ZODpAWV_TMhqzFYg@mail.gmail.com>
 <CAHYQr0qhqce2QcwMLRMWnqhZTL4KzHKJLzt6tfCNLHUcEt9pyQ@mail.gmail.com>
 <20181212014556.GC39861@atomide.com>
 <c8625c42f04a4721b7efb7d7b6b3931c@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8625c42f04a4721b7efb7d7b6b3931c@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

* Reizer, Eyal <eyalr@ti.com> [181212 07:27]:
> I Just tried on an available am335x-evm using 4.20.0-rc1 which I believe has all the patches merged already.
> I am using the same script  and not seeing any failure yet.
> See below:
> 
> root@am335x-evm:/usr/share/wl18xx# uname -r
> 4.20.0-rc1-11287-gf487c00
> root@am335x-evm:/usr/share/wl18xx#
> root@am335x-evm:/usr/share/wl18xx#
> root@am335x-evm:/usr/share/wl18xx#
> root@am335x-evm:/usr/share/wl18xx#
> root@am335x-evm:/usr/share/wl18xx# while true; do ifconfig wlan0 down; ifconfig wlan0 up; done;
> [1378786.491101] wlcore: down
> [1378787.093006] wlcore: PHY firmware version: Rev 8.2.0.0.242
> [1378787.168523] wlcore: firmware booted (Rev 8.9.0.1.79)
> [1378787.215897] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
...

Yeah I was seeing the same yesterday when I tried it.

Could it be that there needs to be a little msleep() after
loading the firmware on some platforms and before enabling
PM runtime?

Regards,

Tony

