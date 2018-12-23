Return-Path: <SRS0=iJrv=PA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9843BC43387
	for <linux-wireless@archiver.kernel.org>; Sun, 23 Dec 2018 16:02:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EB51222A3
	for <linux-wireless@archiver.kernel.org>; Sun, 23 Dec 2018 16:02:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729474AbeLWQCa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 23 Dec 2018 11:02:30 -0500
Received: from muru.com ([72.249.23.125]:59126 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729347AbeLWQCa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 23 Dec 2018 11:02:30 -0500
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id B59888119;
        Sun, 23 Dec 2018 16:02:33 +0000 (UTC)
Date:   Sun, 23 Dec 2018 08:02:26 -0800
From:   Tony Lindgren <tony@atomide.com>
To:     "Reizer, Eyal" <eyalr@ti.com>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        KISHON VIJAY ABRAHAM <kishon@ti.com>,
        "Mishol, Guy" <guym@ti.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Ricardo Salveti <rsalveti@rsalveti.net>
Subject: Re: [EXTERNAL] Re: [PATCH] wlcore: Fix bringing up wlan0 again if
 powered down briefly
Message-ID: <20181223160226.GK6707@atomide.com>
References: <20181217164207.20081-1-tony@atomide.com>
 <CAPDyKFoLnNWsBfaUwqwL31J=zb0UOQjXUKi7Sj0AUsnNoC6bYg@mail.gmail.com>
 <20181218155439.GB6707@atomide.com>
 <CAPDyKFr2xx6fmdgjd10C1jekWg-yZPk32fGWEPO2PyexjofJ1A@mail.gmail.com>
 <20181220231401.GG6707@atomide.com>
 <c22e2ab61b494ea0852c0f4654fef92d@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c22e2ab61b494ea0852c0f4654fef92d@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

* Reizer, Eyal <eyalr@ti.com> [181223 07:38]:
> You are ok as long as the wlan_enable pin Does go down for a sufficient amount of time 
> turning the wl18xx device off.
> The firmware can only be downloaded once after power on.
> In between down/up you have to make sure the wlan_enable is fully going through on->off->on 
> and the wl18xx device is fully reset. 
> On power on the firmware is loaded by the driver and this will fail in case the reset didn't happen

OK thanks for confirming that it's the enable pin that needs to toggle.

Sounds like I need to get the wlcore pwrseq changes done and posted as
the long term solution.

And for a short term fix, we should just add msleep(50) for now with
updated patch description.

Does that that sound OK to everybody?

Regards,

Tony
