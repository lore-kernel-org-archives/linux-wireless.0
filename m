Return-Path: <SRS0=80NG=P2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75A19C43387
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 15:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51B232087E
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 15:49:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727764AbfARPtj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Jan 2019 10:49:39 -0500
Received: from muru.com ([72.249.23.125]:34218 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726902AbfARPtj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Jan 2019 10:49:39 -0500
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 10E758120;
        Fri, 18 Jan 2019 15:49:44 +0000 (UTC)
Date:   Fri, 18 Jan 2019 07:49:34 -0800
From:   Tony Lindgren <tony@atomide.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Anders Roxell <anders.roxell@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Eyal Reizer <eyalr@ti.com>, linux-wireless@vger.kernel.org,
        Ricardo Salveti <rsalveti@rsalveti.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        John Stultz <john.stultz@linaro.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH V2] wlcore: sdio: Fixup power on/off sequence
Message-ID: <20190118154934.GW5544@atomide.com>
References: <20190116113723.15668-1-ulf.hansson@linaro.org>
 <20190116154311.GP5544@atomide.com>
 <CADYN=9L-x2Ar5COE3mJRZz_V-7TNOF__8Rh4Hq7YJ=PoHFrR3Q@mail.gmail.com>
 <877ef2ou3p.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877ef2ou3p.fsf@kamboji.qca.qualcomm.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

* Kalle Valo <kvalo@codeaurora.org> [190118 15:37]:
> Anders Roxell <anders.roxell@linaro.org> writes:
> 
> > On Wed, 16 Jan 2019 at 16:43, Tony Lindgren <tony@atomide.com> wrote:
> >>
> >> * Ulf Hansson <ulf.hansson@linaro.org> [190116 11:37]:
> >> > During "wlan-up", we are programming the FW into the WiFi-chip. However,
> >> > re-programming the FW doesn't work, unless a power cycle of the WiFi-chip
> >> > is made in-between the programmings.
> >> >
> >> > To conform to this requirement and to fix the regression in a simple way,
> >> > let's start by allowing that the SDIO card (WiFi-chip) may stay powered on
> >> > (runtime resumed) when wl12xx_sdio_power_off() returns. The intent with the
> >> > current code is to treat this scenario as an error, but unfortunate this
> >> > doesn't work as expected, so let's fix this.
> >> >
> >> > The other part is to guarantee that a power cycle of the SDIO card has been
> >> > completed when wl12xx_sdio_power_on() returns, as to allow the FW
> >> > programming to succeed. However, relying solely on runtime PM to deal with
> >> > this isn't sufficient. For example, userspace may prevent runtime suspend
> >> > via sysfs for the device that represents the SDIO card, leading to that the
> >> > mmc core also keeps it powered on. For this reason, let's instead do a
> >> > brute force power cycle in wl12xx_sdio_power_on().
> >> >
> >> > Fixes: 728a9dc61f13 ("wlcore: sdio: Fix flakey SDIO runtime PM handling")
> >> > Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> >> > ---
> >> >
> >> > Changes in v2:
> >> >       - Keep the SDIO host claimed when calling mmc_hw_reset().
> >> >       - Add a fixes tag.
> >>
> >> This v2 version works for me as tested with:
> >>
> >> # while [ 1 ]; do ifconfig wlan0 down; ifconfig wlan0 up; done
> >> [  181.364990] wlcore: down
> >> [  182.116424] wlcore: firmware booted (Rev 6.3.10.0.141)
> >> [  182.151641] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> >> [  182.166778] wlcore: down
> >> [  182.773132] wlcore: firmware booted (Rev 6.3.10.0.141)
> >> [  182.811096] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> >> ...
> >>
> >> Thanks for fixing this issue properly, and feel free to add:
> >>
> >> Tested-by: Tony Lindgren <tony@atomide.com>
> >
> > Tested-by: Anders Roxell <anders.roxell@linaro.org>
> >
> > I tested it on a hikey-6220, and it worked.
> 
> So what's the conclusion, can I take this patch? I see that this didn't
> help with Jan but as Tony and Anders provided positive test results I'm
> inclined to take this now and Jan's problem can be fixed with another
> patch. Do everyone agree?

Sounds good to me, seems like there is another separate issue
lurking around somewhere.

Regards,

Tony
