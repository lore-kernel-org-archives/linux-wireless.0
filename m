Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753818AbZKTUsE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 15:48:04 -0500
Subject: Re: [RFC] p54: software hot-swap eeprom image
From: Dan Williams <dcbw@redhat.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <87y6m1aqro.fsf@purkki.valot.fi>
References: <200911202027.13284.chunkeey@googlemail.com>
	 <87y6m1aqro.fsf@purkki.valot.fi>
Content-Type: text/plain
Date: Fri, 20 Nov 2009 12:48:15 -0800
Message-Id: <1258750095.26965.105.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-11-20 at 22:24 +0200, Kalle Valo wrote:
> Christian Lamparter <chunkeey@googlemail.com> writes:
> 
> > This (aggregated) patch adds a new sysfs file "eeprom_overwrite"
> > which can be used to upload an customized eeprom image to the
> > driver during normal operation.
> >
> > The old wlanX device will quickly vanish. And if the new EEPROM
> > image passes all sanity checks the device will reappear.
> >
> > Hopefully, this proves to be an adequate solution for everyone
> > with a bad/missing EEPROM data/chip.
> 
> Wasn't the concensus that request_firmware() will be used for this
> kind of device specific data? stlc45xx had a similar sysfs interface
> and people didn't like it. And I tend to agree with them, adding odd
> sysfs files is not the best way to handle this.

It could be yes, but what would the trigger to upload the new firmware
be?  A /standard/ sysfs file that you

echo "new-firmware-v345" > eeprom_write

into that would then request_firmware("new-firmware-v345")?  I don't
really care where read/write functionality is, I just want this stuff to
be in one place and not have one mechanism for reading it and a few
different ones for writing it.

Dan


