Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42632 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932879Ab1JZRWi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Oct 2011 13:22:38 -0400
Message-ID: <4EA7D98E.2000408@sipsolutions.net> (sfid-20111026_192240_888069_ED9F4413)
Date: Wed, 26 Oct 2011 11:57:34 +0200
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/7] mac80211: mesh power mode indication in QoS frames
References: <CAG5dHkRULKh90W1MeR3zq+-gpeNUshrHZ0qbKXsW19PMG5enoQ@mail.gmail.com> <1319190767.3964.8.camel@jlt3.sipsolutions.net> <CAG5dHkQtVC-cgEWcZOC_woLGeQ75Pkg-JmETWxVKJGdHs8qoOA@mail.gmail.com> (sfid-20111023_151105_679810_72556443)
In-Reply-To: <CAG5dHkQtVC-cgEWcZOC_woLGeQ75Pkg-JmETWxVKJGdHs8qoOA@mail.gmail.com> (sfid-20111023_151105_679810_72556443)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/23/2011 3:10 PM, Ivan Bezyazychnyy wrote:
> On 21 October 2011 13:52, Johannes Berg<johannes@sipsolutions.net>  wrote:
>> On Fri, 2011-10-21 at 12:36 +0400, Ivan Bezyazychnyy wrote:
>>
>>> +/* mesh power save level subfield mask */
>>> +#define IEEE80211_QOS_CTL_PS_LEVEL      0x0200
>>
>> That looks like it could use a better name?
>
> Do you mean something like IEEE80211_QOS_CTL_MESH_POWER_SAVE_LEVEL?
> The first half is similar to previous constants.

Not really .. I mean, it's like you have two levels, 0 and 1, but you 
say this is the level. Why not say this is the 1 level, and the 0 level 
is implied otherwise?

For example, typically, if we have something like a bit in a field that 
indicates the device is getting too hot, we'll call it
FOOBAR_DEVICE_TOO_HOT
and not
FOOBAR_DEVICE_TEMPERATURE_LEVEL

Basically I think that the constant name you have now tells me nothing 
about what it means when the bit is set and I think it'd be better if it 
did. That might not even be possible, but I think in that case you 
really should add a comment, e.g.:

/*
  * mesh power save level:
  * set - the device is doing ...
  * unset - the device is doing ...
  */
#define ...

johannes
