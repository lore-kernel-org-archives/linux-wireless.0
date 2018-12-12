Return-Path: <SRS0=wq86=OV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DA99C67839
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 01:25:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 340FA20851
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 01:25:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 340FA20851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=atomide.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbeLLBZn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Dec 2018 20:25:43 -0500
Received: from muru.com ([72.249.23.125]:57608 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726218AbeLLBZn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Dec 2018 20:25:43 -0500
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id D7F198027;
        Wed, 12 Dec 2018 01:25:45 +0000 (UTC)
Date:   Tue, 11 Dec 2018 17:25:39 -0800
From:   Tony Lindgren <tony@atomide.com>
To:     Ricardo Salveti <rsalveti@rsalveti.net>
Cc:     John Stultz <john.stultz@linaro.org>,
        linux-wireless@vger.kernel.org, anders.roxell@linaro.org
Subject: Re: wlcore getting stuck on hikey after the runtime PM autosuspend
 support change
Message-ID: <20181212012539.GA39861@atomide.com>
References: <CAHYQr0pKurSS=nvLEaLzup1hgx4+RJ0CezA2nFeA=C4XBDQQog@mail.gmail.com>
 <20181211181944.GW39861@atomide.com>
 <CAHYQr0pk-WKM-aYR7ubM4GHx8PA82XP5ze9TW9WEJLzdO0f88A@mail.gmail.com>
 <20181211190128.GX39861@atomide.com>
 <CAHYQr0qc_Lav=1sEGcOmOykUftWRzd6+vis97eBpanEXzfUHaA@mail.gmail.com>
 <CALAqxLUVajBw_PkyhA0s=FhQQHWu1FBEMX+4oDTStRXr6L5Txw@mail.gmail.com>
 <20181211201221.GY39861@atomide.com>
 <CAHYQr0qffa_G2ZVnSsDfjqSgxuBBZB+8e6ZODpAWV_TMhqzFYg@mail.gmail.com>
 <CAHYQr0onAAMZ21YU59XOgNsVrZ-+33tUHfOa9aPr+hG2M0zb3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHYQr0onAAMZ21YU59XOgNsVrZ-+33tUHfOa9aPr+hG2M0zb3g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

* Ricardo Salveti <rsalveti@rsalveti.net> [181211 21:51]:
> Tried to change back wl12xx_sdio_power_off to use pm_runtime_put_sync
> as a test, and noticed I always get -EBUSY when reproducing the hang,
> so it looks like this could be a race between pm_runtime_put/get when
> doing if down/up (and the side effect on the mmc controller).

Hmm so -EBUSY for pm_runtime means transition is already happening
and in many cases the test should be:

error = pm_runtime_get(dev);
if (error < 0 && error != -EBUSY) {
	...
}
...
pm_runtime_put(dev);

Where are you getting it?

Regards,

Tony
