Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:41055 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770AbZBJQ1e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 11:27:34 -0500
Subject: Re: wl12xx: driver for TI wl1251 chipset
From: Dan Williams <dcbw@redhat.com>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Coelho Luciano (Nokia-D/Helsinki)" <Luciano.Coelho@nokia.com>
In-Reply-To: <87mycuxnum.fsf@nokia.com>
References: <87iqnishuj.fsf@nokia.com> <1234279279.3119.12.camel@localhost>
	 <87mycuxnum.fsf@nokia.com>
Content-Type: text/plain
Date: Tue, 10 Feb 2009 11:25:59 -0500
Message-Id: <1234283159.3119.62.camel@localhost> (sfid-20090210_172737_791355_91EDB447)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-02-10 at 18:23 +0200, Kalle Valo wrote:
> Dan Williams <dcbw@redhat.com> writes:
> 
> >> production line tests and pushing the calibration data from user
> >> space.
> >
> > When is the calibration data required
> 
> When we boot the firmware, that is during interface up.
> 
> > and is it likely to change at runtime?
> 
> It's device specific. Each device is calibrated in the factory and the
> calibration data is stored to a special partition in the device.

By "special partition", you mean a filesystem?  Or something else?

> > What I really mean is, if the calibration data isn't required to
> > change while the interface is up, maybe use request_firmware() and
> > load it at device open time or something?
> 
> request_firmware() has access only to the rootfs which the user can
> flash anytime he wants. So we would have to create the calibration
> file during every boot, or something like that. I guess it's doable
> but a bit ugly.

Yeah, that's somewhat ugly then.

Dan


