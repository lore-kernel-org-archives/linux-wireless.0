Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:37509 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab0EDFwL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 01:52:11 -0400
Message-ID: <4BDFB601.9050507@free.fr>
Date: Tue, 04 May 2010 07:52:01 +0200
From: Benoit Papillault <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Joerg Pommnitz <pommnitz@yahoo.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: improve IBSS scanning
References: <469051.90774.qm@web51402.mail.re2.yahoo.com>	 <1272893084.3614.37.camel@jlt3.sipsolutions.net>	 <loom.20100503T153803-630@post.gmane.org>	 <loom.20100503T154149-617@post.gmane.org>	 <1272895062.3614.39.camel@jlt3.sipsolutions.net>	 <loom.20100503T160346-724@post.gmane.org> <1272895986.3614.40.camel@jlt3.sipsolutions.net>
In-Reply-To: <1272895986.3614.40.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le 03/05/2010 16:13, Johannes Berg a écrit :
> On Mon, 2010-05-03 at 14:08 +0000, Joerg Pommnitz wrote:
>> Johannes Berg<johannes@...>  writes:
>>>
>>> Interesting. I guess we never rejected it although it's invalid
>>> according to the standard. Yuck. I think I would like to make nl80211
>>> reject it, but maybe I'll forget about it and let you use it ;)
>>
>> Sorry, I don't know about mac80211. This was more a general point.
>> I thought this woudn't work at all but a co-worker was adamant that
>> it works fine with Madwifi. So I sat down and observed it with
>> a monitoring interface and lo and behold: The beacons really contained
>> the broadcast SSID.
>
> Oh ok. I didn't see anything in cfg80211 but will check and post a
> patch :)
>
> johannes

Sorry to reply late, but in IBSS, beacons are really critical for 
synchronization (including BSSID & TSF). As such, they cannot be removed.

AFAIK, adhoc DEMO is just like adhoc, but without beacons. As such, 
there is no synchronization and every node use the BSSID 
00:00:00:00:00:00, preventing from having several "networks" on the same 
frequency (since there is no SSID to distinguish them).

What you said is that you are using the broadcast SSID instead? And a 
fixed BSSID? I would indeed appreciate the capture file :-)

Regards,
Benoit
