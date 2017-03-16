Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54806 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751957AbdCPNmY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Mar 2017 09:42:24 -0400
Date: Thu, 16 Mar 2017 22:31:27 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Ming Lei <ming.lei@canonical.com>,
        "Luis R . Rodriguez" <mcgrof@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH V4 1/2] firmware: add more flexible
 request_firmware_async function
Message-ID: <20170316133127.GA10679@kroah.com> (sfid-20170316_144251_902048_643560A4)
References: <20170221094754.15406-1-zajec5@gmail.com>
 <20170223183018.16704-1-zajec5@gmail.com>
 <CACna6rzK29VSR2YNQPMhVri3M_DzbFSvFfZ1=RVnkT2P+ohTFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6rzK29VSR2YNQPMhVri3M_DzbFSvFfZ1=RVnkT2P+ohTFw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 16, 2017 at 10:57:00AM +0100, Rafał Miłecki wrote:
> On 23 February 2017 at 19:30, Rafał Miłecki <zajec5@gmail.com> wrote:
> > From: Rafał Miłecki <rafal@milecki.pl>
> >
> > So far we got only one function for loading firmware asynchronously:
> > request_firmware_nowait. It didn't allow much customization of firmware
> > loading process - there is only one bool uevent argument. Moreover this
> > bool also controls user helper in an unclear way.
> >
> > Resolve this problem by adding one internally shared  function that
> > allows specifying any flags manually.
> >
> > This implementation:
> > 1) Allows keeping old request_firmware_nowait API unchanged
> > 2) Doesn't require adjusting / rewriting current drivers
> > 3) Minimizes risk of regressions
> > 4) Adds new function for drivers that need more control over loading a
> >    firmware.
> >
> > The new function takes options struct pointer as an argument to make
> > further improvements possible (without any big reworks).
> >
> > Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> > ---
> > V3: Don't expose all FW_OPT_* flags.
> >     As Luis noted we want a struct so add struct firmware_opts for real
> >     flexibility.
> >     Thank you Luis for your review!
> >
> > Ming/Luis/Greg: assuming this gets a positive review, could someone of you pick
> > this patchset?
> 
> Ping. I hope it's relatively simple and non-intrusive change with a
> proper design now.
> 
> Is there some who could pick this small patchset?

It would be nice if the firmware maintainer could review it, I can't do
anything with this until then...

thanks,

greg k-h
