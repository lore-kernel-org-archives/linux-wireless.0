Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:44371 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbYG1P6F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 11:58:05 -0400
Received: by yw-out-2324.google.com with SMTP id 9so1435092ywe.1
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2008 08:58:04 -0700 (PDT)
Message-ID: <1ba2fa240807280858o4020fec8k4c287567dff177ca@mail.gmail.com> (sfid-20080728_175821_737435_4C83B859)
Date: Mon, 28 Jul 2008 18:58:03 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: [PATCH 1/6] mac80211: allow no mac address until firmware load
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Michael Buesch" <mb@bu3sch.de>,
	"Luis Carlos Cobo" <luisca@cozybit.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1217258040.28198.40.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <48763814.27052c0a.1794.2095@mx.google.com>
	 <200807281544.33509.mb@bu3sch.de> <1217253397.6364.2.camel@localhost>
	 <200807281600.39103.mb@bu3sch.de>
	 <1217257174.28198.27.camel@localhost.localdomain>
	 <1217257628.15381.2.camel@johannes.berg>
	 <1217258040.28198.40.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 28, 2008 at 6:14 PM, Dan Williams <dcbw@redhat.com> wrote:
> On Mon, 2008-07-28 at 17:07 +0200, Johannes Berg wrote:
>> On Mon, 2008-07-28 at 10:59 -0400, Dan Williams wrote:
>>
>> > > If that's really a problem, yes. 01:00:00:00:00:00 is still better
>> > > than a pseudo random MAC, IMO. It's immediately obvious to the user
>> > > that the MAC currently is not set.
>> >
>> > How about 44:44:44:44:44:44 like orinoco uses for bogus BSSID?  If we
>> > can, let's not keep creating yet more bogus MAC addresses.
>>
>> Either way, the problem is that these will confuse udev if you have two
>> at the same time, no?
>
> the udev script I attached from Fedora 9 already ignores devices with
> 00:00:00::: so I don't think we'd have a problem with that.  Screw the
> Xerox thing, all zeros is just bogus and tons of stuff treats it that
> way already.

So this won't conflict even if you have two or more devices that
claims zero mac address?

Tomas
