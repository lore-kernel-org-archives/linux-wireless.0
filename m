Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:43187 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbYKRIkC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Nov 2008 03:40:02 -0500
Message-ID: <49227F6E.8040203@linux.intel.com> (sfid-20081118_094007_917983_8E3C1A18)
Date: Tue, 18 Nov 2008 09:40:14 +0100
From: Marcel Holtmann <holtmann@linux.intel.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Tomas Winkler <tomasw@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mac80211: remove ieee80211_notify_mac
References: <1226915999.3599.33.camel@johannes.berg>	 <1ba2fa240811170632s49c38320y18da189bf2432d54@mail.gmail.com>	 <1226933141.3902.19.camel@johannes.berg>	 <1ba2fa240811170714j7d0daf5xe718ffa1d4de8f40@mail.gmail.com>	 (sfid-20081117_161447_403583_F9BC9E33) <1226942887.3902.30.camel@johannes.berg>
In-Reply-To: <1226942887.3902.30.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

>>> The point is that the whole thing about disassociation is already the
>>> wrong assumption. As I've outlined, it only works in STA mode, and thus
>>> the function is generally not very useful.
>>>
>>>> I agree that resume/suspend shell be handled properly in the mac80211
>>>> regardless of this issue.
>>> And it will handle the "firmware crashed" case perfectly too.
>> You may have a case, anyhow, please show us some RFC before you remove
>> of mac notify.
> 
> I don't have any, but given the current deficiencies, I don't think the
> notify callback is worth keeping especially in light of the locking
> nightmare it's creating. What does it fix anyway? No user ever
> complained about slow re-association at resume time that I've heard, and
> no driver but iwlwifi tries to speed it up.

until we see hard numbers here, I am fine with treating every driver the 
same and just not do any kind of speed up at all. With all my testing 
during resume and re-association, the timing has always been good enough 
so that no real impact for the user happened.

The question here is what are the real benefits and for that we need a 
more detailed measurement that is realistic. In the desktop case for 
example we have enough time since the users still has to still enter 
their password to unlock the screensaver. For the embedded type devices 
like phones etc., the impact is also not present. At least I've never 
seen it. There are other bottlenecks like updating the DHCP lease etc.

Regards

Marcel
