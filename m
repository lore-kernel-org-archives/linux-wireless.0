Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48174 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423513AbcFMVBN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2016 17:01:13 -0400
Date: Mon, 13 Jun 2016 23:01:09 +0200
From: Pavel Machek <pavel@ucw.cz>
To: =?iso-8859-1?Q?Jo=E3o?= Paulo Rechi Vita <jprvita@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Darren Hart <dvhart@infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	platform-driver-x86@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux@endlessm.com,
	=?iso-8859-1?Q?Jo=E3o?= Paulo Rechi Vita
	<jprvita@endlessm.com>
Subject: Re: [RESEND PATCH 1/3] rfkill: Create "rfkill-airplane-mode" LED
 trigger
Message-ID: <20160613210109.GA9303@amd> (sfid-20160613_230137_580877_FAB6CF70)
References: <1462199948-6424-1-git-send-email-jprvita@endlessm.com>
 <1462199948-6424-2-git-send-email-jprvita@endlessm.com>
 <20160504072936.GB17045@amd>
 <1463045572.13313.21.camel@sipsolutions.net>
 <20160519071639.GB17077@amd>
 <1465476194.3442.21.camel@sipsolutions.net>
 <CA+A7VXXP3TYuk4Vvgc8YvxPFo06GG6WpyLJS+2vMLzr0iKQgsA@mail.gmail.com>
 <20160613190048.GA17101@amd>
 <CA+A7VXXOfN1Td2T6uiunWZMS4gvS5sHDzPiDp9VEdx+OPJpSmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CA+A7VXXOfN1Td2T6uiunWZMS4gvS5sHDzPiDp9VEdx+OPJpSmA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon 2016-06-13 15:59:35, João Paulo Rechi Vita wrote:
> On 13 June 2016 at 15:00, Pavel Machek <pavel@ucw.cz> wrote:
> > Hi!
> >
> >> > João, that means you should send a patch to add the ::rfkill suffix.
> >> >
> >>
> >> IMO "airplane" (or maybe "airplane-mode") is a better suffix, as it
> >> reflects the label on the machine's chassis. I'll name it
> >> "asus-wireless::airplane" and send this through platform-drivers-x86,
> >> as this is now contained in the platform-drivers-x86 subsystem. Thanks
> >> Johannes for your patience and help designing and reviewing the rfkill
> >> changes, even if not all of them made it through in the end. And
> >> thanks everyone else involved for the feedback.
> >
> > Actually, I'd do '::rfkill', for consistency with other places in
> > /sys.
> >
> > /sys/devices/platform/thinkpad_acpi/rfkill/rfkill1/name
> > /sys/class/rfkill
> > /sys/module/rfkill
> >
> 
> If we use "rfkill" as a suffix, how do you expect userspace to be able
> to differentiate between a LED that indicates airplane-mode (LED ON
> when all radios are OFF) and a LED that indicates the state of a
> specific radio like WiFi or Bluetooth (LED ON when that specific radio
> is ON)? If we're going this route we should provide meaningful
> information here.

'::airplane' has same problem, no?

If you want to distinguish that, maybe you can do '::rfkill' for
everything vs '::rfkill-wifi' for wifi-only and '::rfkill-bt' for
bluetooth...

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
