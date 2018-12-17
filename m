Return-Path: <SRS0=RnVe=O2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F146C43387
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Dec 2018 14:45:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE45F2133F
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Dec 2018 14:45:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732940AbeLQOpb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 17 Dec 2018 09:45:31 -0500
Received: from muru.com ([72.249.23.125]:58542 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727453AbeLQOpb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Dec 2018 09:45:31 -0500
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id CAC5080F3;
        Mon, 17 Dec 2018 14:45:34 +0000 (UTC)
Date:   Mon, 17 Dec 2018 06:45:27 -0800
From:   Tony Lindgren <tony@atomide.com>
To:     Ricardo Salveti <rsalveti@rsalveti.net>
Cc:     eyalr@ti.com, John Stultz <john.stultz@linaro.org>,
        linux-wireless@vger.kernel.org, anders.roxell@linaro.org
Subject: Re: [EXTERNAL] Re: wlcore getting stuck on hikey after the runtime
 PM autosuspend support change
Message-ID: <20181217144527.GC39861@atomide.com>
References: <20181212014556.GC39861@atomide.com>
 <c8625c42f04a4721b7efb7d7b6b3931c@ti.com>
 <20181212183116.GH39861@atomide.com>
 <CAHYQr0ojkf3CvFb_zuEK4Vuz1w-rm9Sb=+dk5BkqYkWoxy8+aQ@mail.gmail.com>
 <9060b4655e064665a1812d9fae00f1ec@ti.com>
 <CAHYQr0r4eQNSqZEr-vbCiVN6G_O1CXxX9cxemANSRY-jqDMZ=A@mail.gmail.com>
 <20181213144522.GO39861@atomide.com>
 <CAHYQr0qg31hqyzm9uK03qz=DmUkA9idqTrhLaP9A6nuXPEW73w@mail.gmail.com>
 <20181214232857.GZ39861@atomide.com>
 <CAHYQr0r90pLVzMus6n7Pdj5MELeQPK7nt9LnFWNHsoBM=eKhkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHYQr0r90pLVzMus6n7Pdj5MELeQPK7nt9LnFWNHsoBM=eKhkg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

* Ricardo Salveti <rsalveti@rsalveti.net> [181215 03:38]:
> On Fri, Dec 14, 2018 at 9:29 PM Tony Lindgren <tony@atomide.com> wrote:
> > * Ricardo Salveti <rsalveti@rsalveti.net> [181214 12:42]:
> > > Basically since commit 60f36637bbbd ("wlcore: sdio: allow pm to handle
> > > sdio power") PM is now handling the sdio power off/on process, and if
> > > wl12xx_sdio_power_on gets called right after wl12xx_sdio_power_off (if
> > > down/up), the device will not go to the required power off/on sequence
> > > (since PM will abort the suspend process), and the firmware loading
> > > process will fail. I would guess the problem only happens with
> > > autosuspend because of the extra delay it causes (pm_runtime_put
> > > always returns -EBUSY on wl12xx_sdio_power_off with autosuspend).
> >
> > OK thanks for the update, that's interesting.
> >
> > > Is there a way to force the suspend on wl12xx_sdio_power_off, or
> > > should we partially restore the old behavior?
> >
> > Well usually we could do pm_runtime_put_sync_suspend() but
> > here it won't help as the pm_runtime_put() is already in
> > progress by the SDIO subsystem and that's why we get -EBUSY.
> >
> > Does adding a little wait at the end of wl12xx_sdio_power_off()
> > before return? Maybe something like:
> >
> >         /* Make sure the card gets powered off */
> >         while (error == -EBUSY && !pm_runtime_suspended(&card->dev) &&
> >                 retries--) {
> >                 msleep(100);
> >         }
> 
> Yes, this is enough to force the power off process and fixes the hang
> I was having.

OK

> Also tried playing a bit with the msleep value and can confirm it
> usually needs to wait between 30-40 milliseconds before powering the
> card off.

OK thanks for checking that, I was wondering about that too.

> Do you mind sending a patch with the above changes then? I can help
> testing with the boards I have.

Yes I'll send a patch today.

Regards,

Tony
