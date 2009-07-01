Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:40300 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbZGARv1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 13:51:27 -0400
Received: by ewy6 with SMTP id 6so1370234ewy.37
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jul 2009 10:51:29 -0700 (PDT)
Message-ID: <4A4BA21F.1070101@gmail.com>
Date: Wed, 01 Jul 2009 18:51:27 +0100
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: Karl Relton <karllinuxtest.relton@ntlworld.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>, dwmw2@infradead.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Add prism 2/3 usb adaptor firmware for use with staging/wlan-ng
 driver.
References: <1246388712.4949.52.camel@localhost>	 <43e72e890906301217m2dec7bfaqea0472907531d21d@mail.gmail.com>	 <1246396179.4949.76.camel@localhost>	 <43e72e890906301458y197c5411yfb93ea0089ed49f3@mail.gmail.com> <1246464991.4331.18.camel@localhost>
In-Reply-To: <1246464991.4331.18.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Karl Relton wrote:
> On Tue, 2009-06-30 at 14:58 -0700, Luis R. Rodriguez wrote:
>> Why all the srec->binary conversion? Doesn't this waste space on
>> people's firmware directories?
>>
> Yes, technically it does. The srec file is ~185KB, a binary image would
> be ~64KB.
> 
> The reason it was left is that the driver has to do some runtime
> plugging of data into the image, so pre-compilation would have meant
> inventing both a compiler tool and an intermediate format for the driver
> to read and process. Putting all the srec processing in the driver was
> more expedient (just meant porting existing userspace code into driver
> space).

I can't find the wlan_ng request_firmware call in my wireless-testing
tree (week or so old). Is that new?

>From what I can tell the wlan_ng, hostap and orinoco drivers all program
firmware that has the same basic format. Hostap doesn't use
request_firmware, and gives userspace the control over the write
sequence. orinoco places a very simple header in front of the binary image.

Do we really want to add srec processing to the driver (or even the kernel)?

It would be nice if the FW image was in the same format for orinoco and
wlan_ng, as the prism firmware ought to work on non-USB prism cards, and
we should be able to make orinoco use it.


Regards,

Dave.
