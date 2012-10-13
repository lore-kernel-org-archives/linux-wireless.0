Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:39392 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab2JMKZi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Oct 2012 06:25:38 -0400
Received: by mail-la0-f46.google.com with SMTP id h6so2473850lag.19
        for <linux-wireless@vger.kernel.org>; Sat, 13 Oct 2012 03:25:37 -0700 (PDT)
Message-ID: <5079419E.20104@gmail.com> (sfid-20121013_122543_135917_A6A5213F)
Date: Sat, 13 Oct 2012 12:25:34 +0200
From: Pontus Fuchs <pontus.fuchs@gmail.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@adurom.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, hch@lst.de, s.L-H@gmx.de,
	mcgrof@qca.qualcomm.com
Subject: Re: [PATCH 0/4] Driver for the ar5523 chipset
References: <1349985702-21322-1-git-send-email-pontus.fuchs@gmail.com> <20121011203112.GB3317@kroah.com> <87haq017wi.fsf@purkki.adurom.net> <20121012143355.GA25235@tuxdriver.com> <87a9vr0w4d.fsf@purkki.adurom.net>
In-Reply-To: <87a9vr0w4d.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-10-13 07:38, Kalle Valo wrote:
> But after a more thorough review I still think that this driver should
> go to drivers/net/wireless. For example, it has proper endian support,
> it's both gcc and sparse warning free and the code is a pleasure to
> read(!).
Thanks for the feedback. I'm heavily inspired by the wl12xx code so I guess
the style suites you :)

> Here are my comments:
>
> * use ALIGN() and IS_ALIGNED() macros instead of doing it manually

Will fix.

> * checkpatch complains about DOS line endings (but that might be due to
>    mail server, not sure)

No DOS line endings here. Probably chewed somewhere along the way.

> * git-am complained about whitespace damage

Will fix.

> * defines inside structures is not common, kernel style is to have the
>    defines on top of the structure definition
>

Hmmm. That's legacy from the FreeBSD driver. All those structs are
copy-pasted from here:

http://svn.freebsd.org/base/stable/9/sys/dev/usb/wlan/if_uathreg.h

I would prefer to keep as close as possible to that file but if it's
an issue I can certainly change that.

I'll respin the patches asap.

Cheers,

Pontus

