Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:31466 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbYKSN7b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 08:59:31 -0500
Received: by ey-out-2122.google.com with SMTP id 6so1374107eyi.37
        for <linux-wireless@vger.kernel.org>; Wed, 19 Nov 2008 05:59:29 -0800 (PST)
Message-ID: <eb3ff54b0811190559g39c2176h86bd9fb1956d6730@mail.gmail.com> (sfid-20081119_145935_547433_CC630140)
Date: Wed, 19 Nov 2008 15:59:29 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH ] zd1211rw: enable master mode. (wireless-testing)
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	kune@deine-taler.de
In-Reply-To: <1226943608.3902.36.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <eb3ff54b0811170751p56544c8fic38d046a868f3bb8@mail.gmail.com>
	 <1226943608.3902.36.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
Regarding zd1211 working as an access point in master mode:

1) Searching for it shows that zd1211 chips do support acting as an
access point (master mode).

Two examples:
1.1) In the link below it says: "ZD1211 can operate in the mode of
station and access point."
http://linux.softpedia.com/get/System/Hardware/ZD1211-Driver-12712.shtml

2) I saw that in the zd1201 driver there is an access point parameter
to the module ;
 in drivers/net/wireless/zd1201.c, we have:
 module_param(ap, int, 0).

- Can you please elaborate a bit about how can we know whether a
device support or does not support multicast buffering ?

- Could it be that some zd1211 chipsets do support multicast
buffering, and some do not ?

Regards,
Rami Rosen


On Mon, Nov 17, 2008 at 7:40 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2008-11-17 at 17:51 +0200, Rami Rosen wrote:
>> This patch adds initial support for master mode for zd1211rw USB
>> wireless driver (via tools such as  hostapd).
>> It enables basic functionality like association from a managed station
>> and identifying the master mode by scanning from a station.
>
> NAK. This device does not support multicast buffering.
>
> johannes
>
