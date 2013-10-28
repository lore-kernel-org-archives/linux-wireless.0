Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:57891 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894Ab3J1RM3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 13:12:29 -0400
Received: by mail-la0-f48.google.com with SMTP id ev20so5501026lab.35
        for <linux-wireless@vger.kernel.org>; Mon, 28 Oct 2013 10:12:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <526E9093.6020409@rempel-privat.de>
References: <CAMP44s1XJRHV8bAX=_-TkSKMkY8Nw1=eHorqTCZ2QmtR5m8uJA@mail.gmail.com>
	<526E20EA.9090203@rempel-privat.de>
	<CAMP44s0ypeV5JeoF=KWPM-VqZbyR_joJ-4Xg5icKqp2QiNN=Tw@mail.gmail.com>
	<526E33C3.60302@rempel-privat.de>
	<CAMP44s05-NRskvWHNqzVxTRiB_2DeRsPwQGAZZ3saM-VC=ZyQA@mail.gmail.com>
	<526E9093.6020409@rempel-privat.de>
Date: Mon, 28 Oct 2013 11:12:27 -0600
Message-ID: <CAMP44s14Bm1t25XNvREHy71yudgD15Nf+ndeuYbbS8BS9aXE4w@mail.gmail.com> (sfid-20131028_181252_314579_5BCE36DD)
Subject: Re: I always need a miracle to connect with iwlwifi
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
	ilw@linux.intel.com,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 28, 2013 at 10:28 AM, Oleksij Rempel <linux@rempel-privat.de> wrote:
> Am 28.10.2013 16:44, schrieb Felipe Contreras:

>> And BTW, the devices we are talking about are very varied: Wii U,
>> Windows 7, Windows 8.1, Nokia N9, Android phone, iPhone, iMac, Amazon
>> Kindle. Yet the only device that seems to have a problem is my Linux
>> machine, I think it's pretty clear where the problem is.
>
> Do any of listed devices use mac80211?

Yes, my Nokia N900, which works flawlessly. I didn't list that, but I
just tried it.

> If not, you still have fallowing
> options: wpa_supplicant, mac80211, iwlwifi driver, iwlwifi firmware. In
> you arguments you even didn't tried to eliminate any of them. So, no. It
> is not clear where problem is.

All of these things run in the Linux laptop, so to me it is clearly
not in the router. Sure, the router might be buggy, but it's very
conspicuous that only this machine reproduces that bug.

>> And sure, it does not necessarily means that other people have the
>> same problem, but it is very unlikely that I'm the only one.
>
> what is your hardware?

Intel Corporation Centrino Advanced-N 6235

> Did you tired to disable power save mode?

modinfo shows this:

parm:           power_save:enable WiFi power management (default:
disable) (bool)

So I guessed power saving was disabled by default.

But yeah, to be sure I did try it:

sudo modprobe iwlwifi power_save=0 power_level=1

> I have "Intel Centrino Advanced-N 6235", it use same driver and works
> with three of my APs. I say just to show, that list of working hardware
> is not helpful.

Of course it is helpful, it tells us that the problem is very likely
on this machine, not on the AP.

> what is you AP?

ZNID-GPON-2516

> Mode it is running?

I don't know, it's a wireless router.

> Do changing settings of this AP makes some difference?

I don't have access to the settings. I'm going to ask for access, but
I'm not too hopeful.

-- 
Felipe Contreras
