Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:56590 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379AbZFJT2X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 15:28:23 -0400
Received: by bwz9 with SMTP id 9so994410bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2009 12:28:24 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: =?iso-8859-15?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Stefan Steuerwald <salsasepp@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Testing AP mode with WLAN-USB-Stick: How to obtain?
References: <f76a32050906081007q19e9361w8c1fad6fc73c47e7@mail.gmail.com>
	<f76a32050906081011o589474f2geba321c58c0872c2@mail.gmail.com>
	<3ace41890906081659o23cb9ee1sd82ca4fc28a3793d@mail.gmail.com>
	<69e28c910906090426l4c383665rdc4bffc501085661@mail.gmail.com>
	<3ace41890906092018o76b0ee62n91819779a8ccd6db@mail.gmail.com>
	<1244619027.18481.55.camel@johannes.local>
	<3ace41890906100639gb800904td06d86efef90e656@mail.gmail.com>
	<69e28c910906100822q6eae8b29p2381220b23b4f4b1@mail.gmail.com>
	<1244648968.4178.5.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 10 Jun 2009 22:28:18 +0300
In-Reply-To: <1244648968.4178.5.camel@johannes.local> (Johannes Berg's message of "Wed\, 10 Jun 2009 17\:49\:28 +0200")
Message-ID: <87ski7sxbh.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2009-06-10 at 17:22 +0200, Gábor Stefanik wrote:
>> On Wed, Jun 10, 2009 at 3:39 PM, Hin-Tak Leung<hintak.leung@gmail.com> wrote:
>
>> (Note that I'm also for allowing such "buggy" AP mode on devices
>> without a HW multicast buffer, perhaps with hostapd spitting out a
>> big, fat warning on startup; but Johannes has the final say in
>> mac80211-related questions.)
>> 
>> (To Johannes: exactly why is it required for the multicast buffer to
>> be in hardware?)
>
> It isn't required, ath5k/9k don't have it there, they have the notorious
> "CAB" queue for sending frames directly after the beacon. So does b43,
> and probably other designs. The problem really is that powersave mode is
> very important for small clients like your mobile phone or digital
> camera, or even bluetooth3 device, and not doing multicast buffering
> correctly means that either those devices get into weird unreachable
> states, or you need to turn off powersaving features on them which makes
> the battery drain unbearable.

Not only mobile clients, but as we are talking about enabling power save
by default, also Linux laptops would have problems.

> Now, it may or may not be possible to work around this in software by
> sending out the multicast frames on a high-priority queue right after
> the beacon,

And the DTIM beacon should have the broadcast/multicast TIM bit set
before sending the frames.

> or something like that, but frankly I'm not interested in working on
> zd1211rw myself, so that will have to be somebody who is (a) familiar
> with 802.11 powersaving and multicast buffering, (b) wants zd1211rw to
> work, and finally (c) has a lot of time to play with the device.

If someone really has that much time, I think it's better to spend it on
more important issues than this.

-- 
Kalle Valo
