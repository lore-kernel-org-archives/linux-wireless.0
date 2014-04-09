Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:56475 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964907AbaDIRvm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 13:51:42 -0400
Received: by mail-we0-f178.google.com with SMTP id u56so2778670wes.23
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 10:51:40 -0700 (PDT)
MIME-Version: 1.0
Reply-To: andrea.merello@gmail.com
In-Reply-To: <20140409170815.GA17551@kroah.com>
References: <53450089.9050008@gmail.com> <20140409170815.GA17551@kroah.com>
From: Andrea Merello <andrea.merello@gmail.com>
Date: Wed, 9 Apr 2014 19:51:20 +0200
Message-ID: <CAN8YU5M3h_og084bcdgqOGLoQqtrcxbxpPpAR6DBmYGz6pBG-w@mail.gmail.com> (sfid-20140409_195146_479536_75735E9A)
Subject: Re: staging/rtl8187se should be removed
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	driverdev-devel@linuxdriverproject.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I honestly can't estimate how many rtl8187se users will be gained by
this driver once it will appears in mainline (considering that most
users will probably run kernels from distributions, that updates
fairly slower than vanilla) and how much new use-cases this driver
will suddenly encounter... Assuming they are not so few, If I had to
decide, I would vote for keeping the staging driver in parallel to
rtl8180 driver for a bit..
In this way we keep a fallback alternative if someone faces any regression..

Rtl8180 driver should be enough for most users (and I hope most of
them will prefer it for a number of reasons, first of all the fact
that the staging driver here sometimes oopsed), but it is still
possible that someone will prefer to stick with staging for a while
(in my plan I will try to do some other features improvement to
rtl8180, and maybe rtl8187, drivers that indeed are present in staging
code).

AFAIK Linux have kept some alternate ethernet driver (intel e100? am I
right ?) and even two firewire stack for long time.. Maybe for staging
stuff we can strongly shorten time, but without totally clamping to
zero :)

... But about this kind of kernel decisions, I guess other people here
are by far more experienced than me.. This is just my personal humble
opinion.. Probably I already wasted too much words with it :)

BTW since the staging driver has been the only (AFAIK) source of
information about rtl8187se HW publicly available, I would like to put
a note in the rtl8180 driver main file, that indicates the latest
linux version in which the staging code could be found, as reference
for who may try to improve/debug rtl8180 driver -se support in future.
Please notify me when the staging code will be killed, and I will post
a patch for that comment note update.

Andrea

On Wed, Apr 9, 2014 at 7:08 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Wed, Apr 09, 2014 at 10:10:49AM +0200, Xose Vazquez Perez wrote:
>> hi,
>>
>> Support for RTL8187SE devices(0x8199) was added to
>> rtl8180 recently. See 1eba648f998ef9c31b8cf062754a4a7b4ab9001f
>
> Very nice, so, any objection to me deleting the staging driver now?
>
> thanks,
>
> greg k-h
