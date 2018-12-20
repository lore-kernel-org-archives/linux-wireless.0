Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6691C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 23:14:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF725218FE
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 23:14:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390292AbeLTXOF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 18:14:05 -0500
Received: from muru.com ([72.249.23.125]:58890 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390272AbeLTXOF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 18:14:05 -0500
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 582FA809C;
        Thu, 20 Dec 2018 23:14:08 +0000 (UTC)
Date:   Thu, 20 Dec 2018 15:14:01 -0800
From:   Tony Lindgren <tony@atomide.com>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>, Eyal Reizer <eyalr@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Guy Mishol <guym@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap <linux-omap@vger.kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Ricardo Salveti <rsalveti@rsalveti.net>
Subject: Re: [PATCH] wlcore: Fix bringing up wlan0 again if powered down
 briefly
Message-ID: <20181220231401.GG6707@atomide.com>
References: <20181217164207.20081-1-tony@atomide.com>
 <CAPDyKFoLnNWsBfaUwqwL31J=zb0UOQjXUKi7Sj0AUsnNoC6bYg@mail.gmail.com>
 <20181218155439.GB6707@atomide.com>
 <CAPDyKFr2xx6fmdgjd10C1jekWg-yZPk32fGWEPO2PyexjofJ1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDyKFr2xx6fmdgjd10C1jekWg-yZPk32fGWEPO2PyexjofJ1A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

* Ulf Hansson <ulf.hansson@linaro.org> [181220 10:15]:
> On Tue, 18 Dec 2018 at 16:54, Tony Lindgren <tony@atomide.com> wrote:
> >
> > Hi,
> >
> > * Ulf Hansson <ulf.hansson@linaro.org> [181218 12:34]:
> > > Instead, it looks like what you need, is a way to keep track of
> > > whether the SDIO card, became power cycled or if it stayed powered on,
> > > when "ifconfig wlan0 up" is done. In case of a power cycle, you need
> > > to re-program the firmware, right?
> >
> > Yeah mostly. But we also need to ensure things do get powered down
> > properly after ifconfig wlan0 down :) IMO after ifconfig wlan0 down
> > returns, there should be no waiting needed.
> >
> > > Would it be possible to re-program the firmware, even if the SDIO card
> > > stayed powered-on?
> >
> > That might help for some cases, but the problem of how to ensure the
> > card is powered down after ifconfig wlan0 down returns still exists.
> 
> Well, does the SDIO card really have to be powered down before
> "ifconfig wlan0 down" returns? If so, why?

Good question. Eyal, any comments what should happen here from
the wlcore hardware point of view?

> An option would be to call pm_runtime_get_sync() at "ifconfig wlan0
> up" (I assume you already do that) and then re-program the firmware,
> even if the card hasn't been power cycled. Wouldn't that work?

Ricardo, care to test and see if the problem comes back if you
keep PM runtime enabled?

> Or perhaps this is the problem you are encountering, that the FW can't
> be reprogrammed, unless the card has been power cycled? You can easily
> test that, by simply bumping the runtime usage count for the card
> device via sysfs, before doing the "ifconfig wlan0 up/down" thingy.

Ricardo, care to play with this too?

Regards,

Tony
