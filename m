Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:53725 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191AbZBJQYa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 11:24:30 -0500
To: Dan Williams <dcbw@redhat.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Coelho Luciano \(Nokia-D\/Helsinki\)" <Luciano.Coelho@nokia.com>
Subject: Re: wl12xx: driver for TI wl1251 chipset
References: <87iqnishuj.fsf@nokia.com> <1234279279.3119.12.camel@localhost>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Tue, 10 Feb 2009 18:23:29 +0200
In-Reply-To: <1234279279.3119.12.camel@localhost> (ext Dan Williams's message of "Tue\, 10 Feb 2009 16\:21\:19 +0100")
Message-ID: <87mycuxnum.fsf@nokia.com> (sfid-20090210_172435_534003_CC20C974)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams <dcbw@redhat.com> writes:

>> production line tests and pushing the calibration data from user
>> space.
>
> When is the calibration data required

When we boot the firmware, that is during interface up.

> and is it likely to change at runtime?

It's device specific. Each device is calibrated in the factory and the
calibration data is stored to a special partition in the device.

> What I really mean is, if the calibration data isn't required to
> change while the interface is up, maybe use request_firmware() and
> load it at device open time or something?

request_firmware() has access only to the rootfs which the user can
flash anytime he wants. So we would have to create the calibration
file during every boot, or something like that. I guess it's doable
but a bit ugly.

-- 
Kalle Valo
