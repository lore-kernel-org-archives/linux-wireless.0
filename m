Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:45826 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417AbZKTVCY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 16:02:24 -0500
Received: by ewy19 with SMTP id 19so185250ewy.21
        for <linux-wireless@vger.kernel.org>; Fri, 20 Nov 2009 13:02:29 -0800 (PST)
To: Dan Williams <dcbw@redhat.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] p54: software hot-swap eeprom image
References: <200911202027.13284.chunkeey@googlemail.com>
	<87y6m1aqro.fsf@purkki.valot.fi>
	<1258750095.26965.105.camel@localhost.localdomain>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 20 Nov 2009 23:02:27 +0200
In-Reply-To: <1258750095.26965.105.camel@localhost.localdomain> (Dan Williams's message of "Fri\, 20 Nov 2009 12\:48\:15 -0800")
Message-ID: <87pr7cc3ks.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams <dcbw@redhat.com> writes:

>> Wasn't the concensus that request_firmware() will be used for this
>> kind of device specific data? stlc45xx had a similar sysfs interface
>> and people didn't like it. And I tend to agree with them, adding odd
>> sysfs files is not the best way to handle this.
>
> It could be yes, but what would the trigger to upload the new firmware
> be?  A /standard/ sysfs file that you
>
> echo "new-firmware-v345" > eeprom_write
>
> into that would then request_firmware("new-firmware-v345")?

To be sure that we are talking about the same stuff, let's clarify
this a bit first. There are two different use cases where eeprom from
user space is needed:

Category 1. Devices which don't have eeprom at all and require the
            user space provides the eeprom data during every device
            boot. These devices won't even function correctly if they
            don't get the correct eeprom data from user space. As an
            example, grep nvs from wl12xx.

Category 2. Devices which have eeprom but can be updated by user.

So we have two separate problems here.

For category 1 devices request_firmware() was proposed earlier and for
category 2 the ethtool support you mentioned sounds like a viable
option.

-- 
Kalle Valo
