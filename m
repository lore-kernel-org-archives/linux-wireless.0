Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbZKTXMU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 18:12:20 -0500
Subject: Re: [RFC] p54: software hot-swap eeprom image
From: Dan Williams <dcbw@redhat.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <87pr7cc3ks.fsf@purkki.valot.fi>
References: <200911202027.13284.chunkeey@googlemail.com>
	 <87y6m1aqro.fsf@purkki.valot.fi>
	 <1258750095.26965.105.camel@localhost.localdomain>
	 <87pr7cc3ks.fsf@purkki.valot.fi>
Content-Type: text/plain
Date: Fri, 20 Nov 2009 15:12:30 -0800
Message-Id: <1258758750.26965.117.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-11-20 at 23:02 +0200, Kalle Valo wrote:
> Dan Williams <dcbw@redhat.com> writes:
> 
> >> Wasn't the concensus that request_firmware() will be used for this
> >> kind of device specific data? stlc45xx had a similar sysfs interface
> >> and people didn't like it. And I tend to agree with them, adding odd
> >> sysfs files is not the best way to handle this.
> >
> > It could be yes, but what would the trigger to upload the new firmware
> > be?  A /standard/ sysfs file that you
> >
> > echo "new-firmware-v345" > eeprom_write
> >
> > into that would then request_firmware("new-firmware-v345")?
> 
> To be sure that we are talking about the same stuff, let's clarify
> this a bit first. There are two different use cases where eeprom from
> user space is needed:
> 
> Category 1. Devices which don't have eeprom at all and require the
>             user space provides the eeprom data during every device
>             boot. These devices won't even function correctly if they
>             don't get the correct eeprom data from user space. As an
>             example, grep nvs from wl12xx.

Obviously; pretty much every driver that needs firmware does this
already, yeah.  And uses request_firmware().

> Category 2. Devices which have eeprom but can be updated by user.

I was under the impression that chr's original patch was doing #2 here.
Run-time update of firmware.  I guess if the device doesn't actually
write the new firmware to eeprom then yeah, use #1.  Thought his case
was #2 or something.

Dan

