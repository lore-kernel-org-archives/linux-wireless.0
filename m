Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:33311 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbYG1OoO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 10:44:14 -0400
Received: by py-out-1112.google.com with SMTP id p76so3323677pyb.10
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2008 07:44:14 -0700 (PDT)
Message-ID: <1ba2fa240807280744r5ea8c58aqf53cc99abb4cf084@mail.gmail.com> (sfid-20080728_164420_099548_CA996BF9)
Date: Mon, 28 Jul 2008 17:44:13 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH 1/6] mac80211: allow no mac address until firmware load
Cc: "Dan Williams" <dcbw@redhat.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Luis Carlos Cobo" <luisca@cozybit.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200807281625.58188.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <48763814.27052c0a.1794.2095@mx.google.com>
	 <200807281544.33509.mb@bu3sch.de>
	 <1217253465.28198.20.camel@localhost.localdomain>
	 <200807281625.58188.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 28, 2008 at 5:25 PM, Michael Buesch <mb@bu3sch.de> wrote:
> On Monday 28 July 2008 15:57:45 Dan Williams wrote:
>> > (What are the udev problems, btw?)
>>
>> People seem to want persistent device names.  Since the kernel doesn't
>> provide stable device/bus enumeration, there are udev hacks (see
>> attached from Fedora 9) that read the MAC address of the card on
>> hot-plug and then assign it to a cached device name so that every time I
>> plug in my Netgear MA401 it gets "eth2".
>
> Yeah well. But using a pseudo-random MAC as a base to build a persistent
> naming scheme on sounds pretty fragile to me. ;)
>
> I think cards that don't supply MAC early simply cannot support
> a really working persistent naming scheme well. udev should probably
> just enumerate eth0 - ethX as it sees the devices. That's as good
> as mixing a numbering scheme into a pseudo MAC, IMO. And it's
> less confusing and it pushes a lot of policy decisions into userspace.

Can devices supply something depending on its bus numbering that will
not change unless it's plugged out.
Just a thought.
Tomas
