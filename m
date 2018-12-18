Return-Path: <SRS0=MtVb=O3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9A1AC43387
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 15:54:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1FD121871
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 15:54:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbeLRPyn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 18 Dec 2018 10:54:43 -0500
Received: from muru.com ([72.249.23.125]:58686 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726923AbeLRPyn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Dec 2018 10:54:43 -0500
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id D4C53810D;
        Tue, 18 Dec 2018 15:54:46 +0000 (UTC)
Date:   Tue, 18 Dec 2018 07:54:39 -0800
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
Message-ID: <20181218155439.GB6707@atomide.com>
References: <20181217164207.20081-1-tony@atomide.com>
 <CAPDyKFoLnNWsBfaUwqwL31J=zb0UOQjXUKi7Sj0AUsnNoC6bYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDyKFoLnNWsBfaUwqwL31J=zb0UOQjXUKi7Sj0AUsnNoC6bYg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

* Ulf Hansson <ulf.hansson@linaro.org> [181218 12:34]:
> Instead, it looks like what you need, is a way to keep track of
> whether the SDIO card, became power cycled or if it stayed powered on,
> when "ifconfig wlan0 up" is done. In case of a power cycle, you need
> to re-program the firmware, right?

Yeah mostly. But we also need to ensure things do get powered down
properly after ifconfig wlan0 down :) IMO after ifconfig wlan0 down
returns, there should be no waiting needed.

> Would it be possible to re-program the firmware, even if the SDIO card
> stayed powered-on?

That might help for some cases, but the problem of how to ensure the
card is powered down after ifconfig wlan0 down returns still exists.

> In regards to delays needed due to a capacitance. If that really is
> the case, that shall be the managed by the mmc core, as it's there the
> power cycle sequence is being done. As a matter of fact, you should be
> able to use drivers/mmc/core/pwrseq_simple.c and extend
> "power-off-delay-us" in the DTB for Hikey if that is needed.

Hmm I do have a mostly done wlcore pwrseq driver here somewhere that
I have not had a chance to finish again. But that's not going to work
for a fix and needs updating of the related dts files too.

Regards,

Tony
