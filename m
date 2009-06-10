Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:48483 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092AbZFJTTM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 15:19:12 -0400
Received: by bwz9 with SMTP id 9so987756bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2009 12:19:13 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	=?iso-8859-15?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	Stefan Steuerwald <salsasepp@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Testing AP mode with WLAN-USB-Stick: How to obtain?
References: <f76a32050906081007q19e9361w8c1fad6fc73c47e7@mail.gmail.com>
	<f76a32050906081011o589474f2geba321c58c0872c2@mail.gmail.com>
	<3ace41890906081659o23cb9ee1sd82ca4fc28a3793d@mail.gmail.com>
	<69e28c910906090426l4c383665rdc4bffc501085661@mail.gmail.com>
	<3ace41890906092018o76b0ee62n91819779a8ccd6db@mail.gmail.com>
	<1244619027.18481.55.camel@johannes.local>
	<20090610113158.GA2798@tuxdriver.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 10 Jun 2009 22:19:06 +0300
In-Reply-To: <20090610113158.GA2798@tuxdriver.com> (John W. Linville's message of "Wed\, 10 Jun 2009 07\:31\:59 -0400")
Message-ID: <87ws7jsxqt.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"John W. Linville" <linville@tuxdriver.com> writes:

> On Wed, Jun 10, 2009 at 09:30:27AM +0200, Johannes Berg wrote:
>
>> This means that your sleeping clients will not be receiving multicast,
>> and as such be invisible to the network once they fall off the ARP/NDP
>> caches. This is the reason we have said that it will not be possible to
>> support AP mode with this card. I'm curious how, if at all, the vendor
>> driver handles that.
>
> My completely uninformed guess is that they ignore it.

That's my guess as well.

> I will hazard a guess that most scenarios involving "laptop as AP" are
> for support of devices that don't (or at least didn't) do a lot of
> sleeping, like other laptops.
>
> I'm still a bit "on the fence" regarding this requirement for AP mode.
> I think there is a reasonable body of users that would prefer a
> not-quite-right AP mode over no AP mode at all.

I understand your point, but the problems from this are so severe that
it would just create a headache for everyone, both for the users and for
us. Think of what kind of problems randomly loosing broadcast and
multicast frames would create: random disconnects, not finding hosts
from the local network etc. How would a normal user realise that this is
because of broken power save support in the AP?

Also deliberately breaking 802.11 specification sounds very wrong to me.
We can, and should, aim higher than that.

Sorry for not being diplomatic here, but hey, I'm a finn. We are born
to be rude. Heritage from the viking era, I guess :)

-- 
Kalle Valo
