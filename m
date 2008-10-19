Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:27166 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbYJSHYd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Oct 2008 03:24:33 -0400
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu Yi" <yi.zhu@intel.com>
Subject: Re: Power saving on mac80211
References: <43e72e890810171810t1c65642g998db601cfe2a390@mail.gmail.com>
	<87bpxh6t1n.fsf@nokia.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Sun, 19 Oct 2008 10:24:23 +0300
In-Reply-To: <87bpxh6t1n.fsf@nokia.com> (Kalle Valo's message of "Sun\, 19 Oct 2008 08\:41\:08 +0300")
Message-ID: <87y70l59p4.fsf@nokia.com> (sfid-20081019_092443_483129_2042AF58)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kalle.valo@nokia.com> writes:

> Luis R. Rodriguez <mcgrof@gmail.com> writes:
>
>> So I wanted to review power saving requirements for mac80211 and see
>> who else out there is focusing on this now or *really soon* so we can
>> divide and conquer on this. If you are interested please let us know
>> so we can coordinate.
>
> Nokia is very interested about client side PSM. Currently it's only
> on/off type, but I would like to see a dynamic version of this there
> the PSM will be enabled when the data path has been idle long enough
> (eg. 200 ms). I will be sending patches later.

Oh, I forgot about beacon filtering. stlc45xx firmware (but no support
in driver yet) supports beacon filtering in PSM mode, meaning that the
beacons are not delivered to the host (not even DTIM beacons). This
improves power consumption because the host CPU is not woken up all
the time.

I'm sure that stlc4560 isn't the only chip supporting this feature
because it's quite essential in low power devices. I have been
planning to implement support to mac80211 in the near future. Though
don't know yet what is needed, I haven't investigated this at all.

-- 
Kalle Valo
