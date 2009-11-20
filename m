Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:54212 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbZKTUcO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 15:32:14 -0500
MIME-Version: 1.0
In-Reply-To: <1258746786.26965.83.camel@localhost.localdomain>
References: <200911202027.13284.chunkeey@googlemail.com> <1258746786.26965.83.camel@localhost.localdomain>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 20 Nov 2009 12:32:00 -0800
Message-ID: <43e72e890911201232m1e0d573cq74f40580296ca81d@mail.gmail.com>
Subject: Re: [RFC] p54: software hot-swap eeprom image
To: Dan Williams <dcbw@redhat.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 20, 2009 at 11:53 AM, Dan Williams <dcbw@redhat.com> wrote:
> On Fri, 2009-11-20 at 20:27 +0100, Christian Lamparter wrote:
>> This (aggregated) patch adds a new sysfs file "eeprom_overwrite"
>> which can be used to upload an customized eeprom image to the
>> driver during normal operation.
>>
>> The old wlanX device will quickly vanish. And if the new EEPROM
>> image passes all sanity checks the device will reappear.
>>
>> Hopefully, this proves to be an adequate solution for everyone
>> with a bad/missing EEPROM data/chip.
>
> Honestly I wonder if this would be better done with ethtool.  There's
> already ethtool --eeprom-dump, would it be so hard to do an ethtool
> --eeprom-load ?
>
> I can see a number of devices doing this, so in my mind it makes sense
> to have a generic facility for this sort of thing.  But then again it's
> not so common an operation and its fraught with danger :)  Libertas
> could potentially use this, but libertas has *two* EEPROM images that it
> might need to update.  So if ethtool did grow --eeprom-load we may want
> to account for more than one eeprom image.
>
> What do people think?

Can't request_firmware() be generalized for this sort of stuff too?

  Luis
