Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:54819 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752186AbcKIMf0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Nov 2016 07:35:26 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: Brian Norris <briannorris@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Subject: RE: [PATCH 5/5] mwifiex: wait for firmware dump completion in
 remove_card
Date: Wed, 9 Nov 2016 12:35:22 +0000
Message-ID: <271acd7f41694b09be6f4ad82846782a@SC-EXCH04.marvell.com> (sfid-20161109_133530_353596_BF78BBCF)
References: <1477318892-22877-1-git-send-email-akarwar@marvell.com>
 <1477318892-22877-5-git-send-email-akarwar@marvell.com>
 <20161025001405.GE15034@dtor-ws> <87d1imudwm.fsf@purkki.adurom.net>
 <20161102204537.GA27786@google.com>
In-Reply-To: <20161102204537.GA27786@google.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Brian,

> From: Brian Norris [mailto:briannorris@chromium.org]
> Sent: Thursday, November 03, 2016 2:16 AM
> To: Kalle Valo
> Cc: Dmitry Torokhov; Amitkumar Karwar; linux-wireless@vger.kernel.org;
> Cathy Luo; Nishant Sarmukadam; Xinming Hu
> Subject: Re: [PATCH 5/5] mwifiex: wait for firmware dump completion in
> remove_card
> 
> On Thu, Oct 27, 2016 at 04:20:25PM +0300, Kalle Valo wrote:
> > Dmitry Torokhov <dmitry.torokhov@gmail.com> writes:
> >
> > >> +/* reset_trigger variable is used to identify if
> > >> +mwifiex_sdio_remove()
> > >> + * is called by sdio_work during reset or the call is from sdio
> subsystem.
> > >> + * We will cancel sdio_work only if the call is from sdio
> subsystem.
> > >> + */
> > >> +static u8 reset_triggered;
> > >
> > > It would be really great if the driver supported multiple devices.
> > > IOW please avoid module-globals.
> >
> > Good catch, it's a hard requirement to support multiple devices at the
> > same time.
> 
> BTW, this problem is repeated in several places throughout this driver.
> For instance, look for 'user_rmmod' (why? you shouldn't need to treat
> module unload differently...)

We have 2 kinds of teardown cases.
1) Chip is going to be powered off.
	a) System reboot
	b) Someone manually removed wifi card from system
2) User unloaded the driver.

In case 1. b), we can't have logic to terminate WIFI connection and download SHUTDOWN command to firmware, as hardware itself is not present.

This logic is useful when user just unloads and loads the driver. Firmware download will be skipped in this case, as it's already running. SHUTDOWN command sent during unload has cleared firmware's state. 

'user_rmmod' flag doesn't create problem for supporting multiple devices. The flag is true during module unload OR reboot. It's applicable for all devices.

> and the work structs (and corresponding
> 'saved_adapter' and 'iface_flags') used for PCIe function-level reset
> and SDIO reset.

We are working on the v3 of this patch series. We will try to get rid of these variables along with global "work_struct" as you suggested.

Regards,
Amitkumar
