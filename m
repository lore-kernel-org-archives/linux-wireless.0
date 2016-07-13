Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34646 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752600AbcGMHZ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2016 03:25:28 -0400
Message-ID: <1468394693.25088.138.camel@coelho.fi> (sfid-20160713_092651_240509_7370B286)
From: Luca Coelho <luca@coelho.fi>
To: Kalle Valo <kvalo@codeaurora.org>,
	Prarit Bhargava <prarit@redhat.com>
Cc: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linuxwifi <linuxwifi@intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	"Ivgi, Chaya Rachel" <chaya.rachel.ivgi@intel.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"Sharon, Sara" <sara.sharon@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 13 Jul 2016 10:24:53 +0300
In-Reply-To: <87eg6yav5e.fsf@purkki.adurom.net>
References: <1468250301-10357-1-git-send-email-prarit@redhat.com>
	<CANUX_P0AFoM5VEDWDjtvOhNbExu4T1bLWU+uS-EYqoGtu5h2bw@mail.gmail.com>
	<5783E33E.7090205@redhat.com> <1468261650.20877.14.camel@intel.com>
	<57840214.8000904@redhat.com> <87eg6yav5e.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH RESEND] iwlwifi, Do not implement thermal zone unless
 ucode is loaded
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-07-13 at 09:50 +0300, Kalle Valo wrote:
> Prarit Bhargava <prarit@redhat.com> writes:
> 
> > > We implement thermal zone because we do support it, but the
> > > problem is
> > > that we need the firmware to be loaded for that. So you can argue
> > > that
> > > we should register *later* when the firmware is loaded. But this
> > > is
> > > really not helping all that much because the firmware can also be
> > > stopped at any time. So you'd want us to register / unregister
> > > the
> > > thermal zone anytime the firmware is loaded / unloaded?
> > 
> > You might have to do that.  I think that if the firmware enables a
> > feature then
> > the act of loading the firmware should run the code that enables
> > the feature.
> > IMO of course.
> 
> But I suspect that the iwlwifi firmware is loaded during interface up
> (and unloaded during interface down) and in that case
> register/unregister would be happening all the time. That doesn't
> sound
> like a good idea. I would rather try to fix the thermal interface to
> handle the cases when the measurement is not available.

I totally agree with Emmanuel and Kalle.  We should not change this.
 It is a design decision to return an error when the interface is down,
this is very common with other subsystems as well.  The userspace
should be able to handle errors and report something like "unavailable"
when this kind of error is returned.

I'm not sure EIO is the best we can have, but for me that's exactly
what it is.  The thermal zone *is* there, but cannot be accessed
because the firmware is not available.  I'm okay to change it to EBUSY,
if that would help userspace, but I think that's a bit misleading.  The
device is not busy, on the contrary, it's not even running at all.

Furthermore, I don't think this is "breaking userspace" in the sense of
being a regression.  The userspace API has always been implemented with
the possibility of returning errors.  It's not a good design if a
single device returning an error causes all the other devices to also
fail.

--
Cheers,
Luca.
