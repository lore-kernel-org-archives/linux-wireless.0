Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:58662 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752760AbcKJKBG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Nov 2016 05:01:06 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: Brian Norris <briannorris@chromium.org>
CC: Kalle Valo <kvalo@codeaurora.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>,
        "Nishant Sarmukadam" <nishants@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Subject: RE: [PATCH 5/5] mwifiex: wait for firmware dump completion in
 remove_card
Date: Thu, 10 Nov 2016 10:01:02 +0000
Message-ID: <dccf759ac6ed4e3ba64439831706953c@SC-EXCH04.marvell.com> (sfid-20161110_110132_834450_4D79E7ED)
References: <1477318892-22877-1-git-send-email-akarwar@marvell.com>
 <1477318892-22877-5-git-send-email-akarwar@marvell.com>
 <20161025001405.GE15034@dtor-ws> <87d1imudwm.fsf@purkki.adurom.net>
 <20161102204537.GA27786@google.com>
 <271acd7f41694b09be6f4ad82846782a@SC-EXCH04.marvell.com>
 <20161109203710.GA118631@google.com>
In-Reply-To: <20161109203710.GA118631@google.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Brian,

> From: Brian Norris [mailto:briannorris@chromium.org]
> Sent: Thursday, November 10, 2016 2:07 AM
> To: Amitkumar Karwar
> Cc: Kalle Valo; Dmitry Torokhov; linux-wireless@vger.kernel.org; Cathy
> Luo; Nishant Sarmukadam; Xinming Hu
> Subject: Re: [PATCH 5/5] mwifiex: wait for firmware dump completion in
> remove_card
> 
> On Wed, Nov 09, 2016 at 12:35:22PM +0000, Amitkumar Karwar wrote:
> > Hi Brian,
> 
> Hi,
> 
> > > From: Brian Norris [mailto:briannorris@chromium.org]
> > > Sent: Thursday, November 03, 2016 2:16 AM
> > > To: Kalle Valo
> > > Cc: Dmitry Torokhov; Amitkumar Karwar;
> > > linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> > > Xinming Hu
> > > Subject: Re: [PATCH 5/5] mwifiex: wait for firmware dump completion
> > > in remove_card
> > >
> > > On Thu, Oct 27, 2016 at 04:20:25PM +0300, Kalle Valo wrote:
> > > > Dmitry Torokhov <dmitry.torokhov@gmail.com> writes:
> > > >
> > > > >> +/* reset_trigger variable is used to identify if
> > > > >> +mwifiex_sdio_remove()
> > > > >> + * is called by sdio_work during reset or the call is from
> > > > >> +sdio
> > > subsystem.
> > > > >> + * We will cancel sdio_work only if the call is from sdio
> > > subsystem.
> > > > >> + */
> > > > >> +static u8 reset_triggered;
> > > > >
> > > > > It would be really great if the driver supported multiple
> devices.
> > > > > IOW please avoid module-globals.
> > > >
> > > > Good catch, it's a hard requirement to support multiple devices at
> > > > the same time.
> > >
> > > BTW, this problem is repeated in several places throughout this
> driver.
> > > For instance, look for 'user_rmmod' (why? you shouldn't need to
> > > treat module unload differently...)
> >
> > We have 2 kinds of teardown cases.
> > 1) Chip is going to be powered off.
> > 	a) System reboot
> > 	b) Someone manually removed wifi card from system
> > 2) User unloaded the driver.
> >
> > In case 1. b), we can't have logic to terminate WIFI connection and
> > download SHUTDOWN command to firmware, as hardware itself is not
> > present.
> 
> That seems like a poor way of determining the difference between hot
> unplug and clean shutdown. What if unplug happens concurrently with
> rmmod?

I agree. hotunplug thread may read the flag as "true" in this race and try to interact with hardware.

> Seems like it'd be better to identify hardware failures as such,
> and just skip talking to HW. Also, for interfaces that support unplug
> well (like USB), shouldn't you be able to get hotplug info from the
> driver core, instead of having to guess the inverse of that ("this was
> not a hotplug") from static variables like that?

You are right. We can identify hardware read/write failure and continue performing remaining cleanup.
This way "user_rmmod" flag can be avoided.
I will plan for this cleanup. Tests need to be performed with SDIO, PCIe use USB devices.
I just found hotunplug info is received in case of USB.(udev->state changed to USB_STATE_NOTATTACHED). We will make use of this.

> 
> > This logic is useful when user just unloads and loads the driver.
> > Firmware download will be skipped in this case, as it's already
> > running. SHUTDOWN command sent during unload has cleared firmware's
> > state.
> 
> Why is that useful?

Sending SHUTDOWN command helps firmware reset/clean it's state. As per our protocol, SHUTDOWN is the last command downloaded to firmware. After this, firmware's state would be same as freshly downloaded firmware.
Next time when driver is loaded, firmware download is skipped, as it's already active. Driver just need to send couple of initialization commands.

Regards,
Amitkumar
