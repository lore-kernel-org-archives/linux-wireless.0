Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:34453 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752710AbcKBUpl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Nov 2016 16:45:41 -0400
Received: by mail-pf0-f182.google.com with SMTP id n85so17767943pfi.1
        for <linux-wireless@vger.kernel.org>; Wed, 02 Nov 2016 13:45:41 -0700 (PDT)
Date: Wed, 2 Nov 2016 13:45:38 -0700
From: Brian Norris <briannorris@chromium.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH 5/5] mwifiex: wait for firmware dump completion in
 remove_card
Message-ID: <20161102204537.GA27786@google.com> (sfid-20161102_214546_426275_0E970D86)
References: <1477318892-22877-1-git-send-email-akarwar@marvell.com>
 <1477318892-22877-5-git-send-email-akarwar@marvell.com>
 <20161025001405.GE15034@dtor-ws>
 <87d1imudwm.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87d1imudwm.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 27, 2016 at 04:20:25PM +0300, Kalle Valo wrote:
> Dmitry Torokhov <dmitry.torokhov@gmail.com> writes:
> 
> >> +/* reset_trigger variable is used to identify if mwifiex_sdio_remove()
> >> + * is called by sdio_work during reset or the call is from sdio subsystem.
> >> + * We will cancel sdio_work only if the call is from sdio subsystem.
> >> + */
> >> +static u8 reset_triggered;
> >
> > It would be really great if the driver supported multiple devices. IOW
> > please avoid module-globals.
> 
> Good catch, it's a hard requirement to support multiple devices at the
> same time.

BTW, this problem is repeated in several places throughout this driver.
For instance, look for 'user_rmmod' (why? you shouldn't need to treat
module unload differently...) and the work structs (and corresponding
'saved_adapter' and 'iface_flags') used for PCIe function-level reset
and SDIO reset.

Hopefully either Marvell's or my cleanups can move to get rid of these
anti-patterns soon...

Brian
