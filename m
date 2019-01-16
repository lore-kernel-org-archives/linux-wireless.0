Return-Path: <SRS0=vb4L=PY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ABC8C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 15:40:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AD6220675
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 15:40:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394157AbfAPPke (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Jan 2019 10:40:34 -0500
Received: from muru.com ([72.249.23.125]:33880 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387914AbfAPPke (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Jan 2019 10:40:34 -0500
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id D63A38030;
        Wed, 16 Jan 2019 15:40:39 +0000 (UTC)
Date:   Wed, 16 Jan 2019 07:40:29 -0800
From:   Tony Lindgren <tony@atomide.com>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>, Eyal Reizer <eyalr@ti.com>,
        linux-wireless@vger.kernel.org,
        Ricardo Salveti <rsalveti@rsalveti.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] wlcore: sdio: Fixup power on/off sequence
Message-ID: <20190116154029.GO5544@atomide.com>
References: <20190115150433.12558-1-ulf.hansson@linaro.org>
 <20190115185509.GJ5544@atomide.com>
 <CAPDyKFpBY-urtSGpZtxmS79wgitgA46oFmeNk4w7tOjYW2PDLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDyKFpBY-urtSGpZtxmS79wgitgA46oFmeNk4w7tOjYW2PDLw@mail.gmail.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

* Ulf Hansson <ulf.hansson@linaro.org> [190116 11:44]:
> On Tue, 15 Jan 2019 at 19:55, Tony Lindgren <tony@atomide.com> wrote:
> > # while [ 1 ]; do ifconfig wlan0 down; usleep 20000; \
> >   ifconfig wlan0 up; done
> >
> > Otherwise I get the following on warning pandaboard-es:
> >
> > WARNING: CPU: 0 PID: 1770 at drivers/bus/omap_l3_noc.c:147
> > l3_interrupt_handler+0x2f8/0x388
> > 44000000.ocp:L3 Custom Error: MASTER MPU TARGET L4PER2 (Read):
> > Data Access in User mode during Functional access
> >
> > Meaning that we access registers while not clocked
> > somewhere. I think that warning is different from the
> > earlier errors though :) And we could add a msleep(50)
> > to the end to mostly avoid it until we have a better
> > fix available?
> 
> Well, that would paper over the problem, let's see if we can avoid it.
> 
> I realized that I have not invoked mmc_hw_reset() with the sdio host
> claimed. This could be the reason and is fixed in a v2, please try and
> see if that solves the "new" problem. If id doesn't, you could also
> convert the pm_runtime_put() to a pm_runtime_put_sync() in
> wl12xx_sdio_power_off() and see if that makes a difference.

Yes you're right v2 works for me no problem. I'll go ack
it there.

Tony
