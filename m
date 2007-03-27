Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.233]:28550 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbXC0JZ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2007 05:25:59 -0400
Received: by wr-out-0506.google.com with SMTP id 76so1861593wra
        for <linux-wireless@vger.kernel.org>; Tue, 27 Mar 2007 02:25:58 -0700 (PDT)
Message-ID: <3ae72650703270225k1db9c4a8w6e31b95e007336d7@mail.gmail.com>
Date: Tue, 27 Mar 2007 11:25:57 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Eric Rannaud" <eric.rannaud@gmail.com>
Subject: Re: 2.6.21-rc4-mm1
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
	"Cornelia Huck" <cornelia.huck@de.ibm.com>,
	"Larry Finger" <larry.finger@lwfinger.net>,
	"Matt Mackall" <mpm@selenic.com>, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	"Monakhov Dmitriy" <dmonakhov@openvz.org>
In-Reply-To: <20070326103432.GB18799@zenigma>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
References: <20070321202225.GN10459@waste.org>
	 <20070322123508.3785fd30@gondolin.boeblingen.de.ibm.com>
	 <4602752A.5050109@lwfinger.net>
	 <20070322181019.62fe78ed@gondolin.boeblingen.de.ibm.com>
	 <4602D137.4060402@lwfinger.net>
	 <20070323111029.4089ccfb@gondolin.boeblingen.de.ibm.com>
	 <20070323210618.6a41f5da.akpm@linux-foundation.org>
	 <20070326110949.5301a571@gondolin.boeblingen.de.ibm.com>
	 <20070326012232.0f0b9e09.akpm@linux-foundation.org>
	 <20070326103432.GB18799@zenigma>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/26/07, Eric Rannaud <eric.rannaud@gmail.com> wrote:
> On Mon, Mar 26, 2007 at 01:22:32AM -0800, Andrew Morton wrote:
> > On Mon, 26 Mar 2007 11:09:49 +0200 Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> > > > If so, do you think I should labour on with
> > > > uevent-improve-error-checking-and-handling.patch plus your fix, or should I
> > > > drop the lot?  (I'm inclined toward the latter, but I'm still not
> > > > sure which patch(es) need to be dropped).
> > >
> > > This depends on what semantics uevent returning an error code should
> > > have. The firmware code was using it to suppress uevents, but
> > > uevent_suppress is a better idea now. So if we want uevent returning !=
> > > 0 to imply "something really bad happened", all uevent functions have
> > > to be audited and those that work like firmware_uevent have to be
> > > converted to uevent_suppress. This would be cleaner, but I'm not sure
> > > it's worth the work.
> >
> > We're generally struggling to stay alive amongst all the bugs at present -
> > I'll drop all those patches.
>
> My mistake, I wrote the guilty patch
> uevent-improve-error-checking-and-handling.patch assuming it was safe to
> treat the return value as an error code, since several uevent functions
> returns things like -ENOMEM.
>
> Should I rework the patch as Cornelia suggests and resubmit later, when
> things have settled down a little?

I don't see any point in deregistering a kernel device, if the event
to userspace goes wrong, or a subsytem returns a non-zero value in the
filter.

Checking the uevent return value, will not prevent any malfunction,
usually this kind of "error handling" just prevents bringing up a
whole subsystem, or booting-up a box, because the needed device does
not exist at all.

Thanks,
Kay
