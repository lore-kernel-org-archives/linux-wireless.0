Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40085 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758438Ab1DNNHm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2011 09:07:42 -0400
MIME-Version: 1.0
In-Reply-To: <4DA6E9BD.3090404@hauke-m.de>
References: <BANLkTim7Uj2tsgFngWhUqFK_hk3Leg+sQA@mail.gmail.com>
	<1302781431.21145.6.camel@dev.znau.edu.ua>
	<BANLkTinvpt5vs+rXd3WN-a2JpGtTV+=Gyg@mail.gmail.com>
	<4DA6E9BD.3090404@hauke-m.de>
Date: Thu, 14 Apr 2011 15:07:41 +0200
Message-ID: <BANLkTinu+Q367oqQPiUehPcbMs-SBxbwFg@mail.gmail.com>
Subject: Re: Could I (ab)use bus (struct bus_type) for virtual Broadcom bus?
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>,
	Russell King <rmk@arm.linux.org.uk>,
	Arnd Bergmann <arnd@arndb.de>
Cc: George Kashperko <george@znau.edu.ua>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Arend van Spriel <arend@broadcom.com>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	b43-dev@lists.infradead.org, Greg KH <greg@kroah.com>,
	Andy Botting <andy@andybotting.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 14 kwietnia 2011 14:34 użytkownik Hauke Mehrtens
<hauke@hauke-m.de> napisał:
> On 04/14/2011 02:04 PM, Rafał Miłecki wrote:
>> Hauke: you were proposing integrating with drivers/amba. I really
>> expect you to comment on this, please tell us how do you see this now,
>> when we have better overview. I took your proposal seriously, you can
>> see the results above.
>
> I had no closer look at drivers/amba and this bus driver, I just saw
> that there was a discussion about drivers/amba and this implementation
> with no result. When the Bradcom cores are not directly connected to
> AMBA, but are using some sort of wrapper and there are no benefits in
> using drivers/amba, just leave it.
>
> As the implementation of the Braodcom AIX Bus contains some Broadcom
> extensions and there seams to be no normal AMBA device being connected
> to some Broadcom devices with this special interface number 3) "Broadcom
> specific bus (bcmai)" seams to the the best approach in my opinion.

Thanks for commenting.

Russell: you were asking:
> What does this do which the 'amba' bus support doesn't?
I believe I explained it well in this thread. Do you still think about
using amba/driver? Do you think we should use it?

Arnd: I found you saying:
> I believe the one thing we really want from this driver is the bus
> scan code, which is not present in the amba bus implementation,
I explained how it works, I believe scanning (EPROM in this case) it
Broadcom specific, not really AMBA standard. How do you see it?

-- 
Rafał
