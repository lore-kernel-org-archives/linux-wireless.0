Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56354 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752595AbdCPOMV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Mar 2017 10:12:21 -0400
Date: Thu, 16 Mar 2017 23:03:52 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Ming Lei <tom.leiming@gmail.com>,
        "Luis R . Rodriguez" <mcgrof@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH V4 1/2] firmware: add more flexible
 request_firmware_async function
Message-ID: <20170316140352.GA30080@kroah.com> (sfid-20170316_151313_360516_DF536AFC)
References: <20170221094754.15406-1-zajec5@gmail.com>
 <20170223183018.16704-1-zajec5@gmail.com>
 <f0451c04-cffe-ae1c-74de-38748da38272@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <f0451c04-cffe-ae1c-74de-38748da38272@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 16, 2017 at 02:55:09PM +0100, Rafał Miłecki wrote:
> On 02/23/2017 07:30 PM, Rafał Miłecki wrote:
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
> Hi Ming,
> 
> It seems you changed e-mail address somewhere between V3 and V4 of this
> patchset. Could you review/comment/ack this, please?

Ming isn't the firmware maintainer anymore :(

> Luis: would you ack this patch now I followed your guidance?

It's up to Luis now :)

greg k-h
