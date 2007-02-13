Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.226]:23024 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbXBMUOA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Feb 2007 15:14:00 -0500
Received: by nz-out-0506.google.com with SMTP id s1so2116111nze
        for <linux-wireless@vger.kernel.org>; Tue, 13 Feb 2007 12:14:00 -0800 (PST)
Message-ID: <43e72e890702131213s715df387wa4bd4d1c66b4a664@mail.gmail.com>
Date: Tue, 13 Feb 2007 15:13:59 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Michael Wu" <flamingice@sourmilk.net>
Subject: Re: network manager vs. missing firmware
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Dan Williams" <dcbw@redhat.com>, linux-wireless@vger.kernel.org
In-Reply-To: <200702131443.16553.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
References: <1171392106.10344.100.camel@johannes.berg>
	 <1171394598.5329.31.camel@localhost.localdomain>
	 <1171395459.10344.123.camel@johannes.berg>
	 <200702131443.16553.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/13/07, Michael Wu <flamingice@sourmilk.net> wrote:
> On Tuesday 13 February 2007 14:37, Johannes Berg wrote:
> > > So this isn't really consistent.  I'm unclear as to why the ipw cards
> > > need it on init rather than on dev open, but hey, why make things
> > > easier?
> >
> > When is ->init() called anyway? Isn't it when you register the netdev so
> > it would be on probe?
> >
> Yes, ipw2200 does it on probe... but I know it can be pushed off to open. I've
> done it. However.. I think intersil cards really need firmware to read the
> eeprom.

This is correct

> prism54 currently sets a fake MAC address so they can push it off to
> open, but I think this is wrong.

This was suggested by Jean a long time ago after we asked for advice
on what to do since we couldn't read the MAC before loading the
firmware. Whatever we decide on we should standardize on it in case
other new cards end up with same issue. One option was to have the
probe() fail if no firmware was present but obviously this would force
you to reload the module/reboot if you then get the firmware. We
decided to leave the firmware upload on open() to overcome this but
the problem then was the lack of a MAC address.

Anyone know if wireless network devices the only ones requiring a
firmware? If not then we should think of slapping something onto
net_device. Otherwise we should distinguish the requirement on
cfg80211_config so userspace tools know WTF is going on and inform the
user appropriately.

  Luis
