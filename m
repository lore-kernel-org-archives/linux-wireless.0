Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:19955 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938AbYL1MzA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Dec 2008 07:55:00 -0500
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH v6 0/3] mac80211 dynamic power save
References: <20081218213306.7248.64398.stgit@tikku>
	<1230069346.31228.51.camel@johannes>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Sun, 28 Dec 2008 14:54:33 +0200
In-Reply-To: <1230069346.31228.51.camel@johannes> (ext Johannes Berg's message of "Tue\, 23 Dec 2008 22\:55\:46 +0100")
Message-ID: <871vvso3xy.fsf@nokia.com> (sfid-20081228_135508_163331_5C7E341D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2008-12-18 at 23:35 +0200, Kalle Valo wrote:
>> Here is v5 of my dynamic powersave patches. I have tested them with
>> stlc45xx on Nokia N810.
>
>> Power save related features which I'll implement later:
>> o disable power save when software scanning
>> o move dynamic_ps_timeout to hw.conf so that drivers can use it in
>>   case they need to
>> o beacon period (wakeup period) to the drivers, can be set from user
>>   space but otherwise is bss's DTIM value
>
> Now that these are in, and more things for user interface are on the
> way, we should probably think about implementing the policy in
> userspace.

Good idea. Also we should consider the interface to the user space,
what parameters we want to provide to user space etc.

> Should that be part of NM? 

I think it should be in NetworkManager, and also Intel's Connection
Manager might want to control power save parameters. And in Nokia we
want to control power save parameters from wlancond, our own Wireless
Extension dbus wrapper.

> It could take into account things like the system power state
> (AC/battery) for the decision, at least by default?

Actually I'm not that enthuastic about AC/battery mode detection, I
would like to save power even in AC mode. In my opinion we should have
more dynamic logic based on current state, for example based on amount
of transfered traffic, QoS, user activity (eg. is the display blanked)
and what not. But I guess AC/battery detection is a good start.

As for the user space interface, here's some ideas I have been
thinking:

Wakeup period (iwconfig wlan0 power period 2), sleep timeout (iwconfig
wlan0 power timeout 500m) and enable/disable of power save (iwconfig
wlan0 power on) are enough for now. If needed, we can add more
parameters later.

Wakeup period should be the DTIM value of the BSS by default and set
by mac80211, but user space can change the value whenever it wants.
Power save should be disabled by default in mac80211 to avoid all the
interoperability problems (there's enough of those, especially with
old APs), but it would be nice to have an easy way for the user to
enable power save from NetworkManager.

-- 
Kalle Valo
