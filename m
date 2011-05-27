Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54157 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756503Ab1E0AXN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2011 20:23:13 -0400
Message-ID: <4DDEEEEC.6010800@openwrt.org> (sfid-20110527_022316_527351_9754009D)
Date: Fri, 27 May 2011 02:23:08 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	hostap@lists.shmoo.com, Matt Smith <Matt.Smith@atheros.com>
Subject: Re: Initial automatic channel selection implementation
References: <BANLkTi=-MDn9eAsRsoXtAetDOZehkMEhJw@mail.gmail.com> <201105241627.49201.helmut.schaa@googlemail.com> <BANLkTikcEsKYo=c=ZmzJRbmfgjmrFmx9bg@mail.gmail.com> <BANLkTin4MvdbqugTjtXvmjz5N8_TyTY7OA@mail.gmail.com> <BANLkTi=xfv_0C1mVAtO=w5JqyXLvh=vtAQ@mail.gmail.com> <BANLkTimMXbZE=vY95C0b2H3hx=4XWdU2Qg@mail.gmail.com> <BANLkTi=rS_kDhB8oKBLsz2Mk2nvRJMu5mg@mail.gmail.com> <4DDD5691.2040205@openwrt.org> <BANLkTi=1uj52P208p--5NU=Ow4rDndMkAw@mail.gmail.com> <BANLkTimRiU9Pv1B1=VC3XuREbmnpLk3S7w@mail.gmail.com> <4DDE2F5B.3020804@openwrt.org> <BANLkTimuaOoV0uvyzs9PbeK_k6vwOG=+YA@mail.gmail.com>
In-Reply-To: <BANLkTimuaOoV0uvyzs9PbeK_k6vwOG=+YA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-05-27 1:45 AM, Luis R. Rodriguez wrote:
> On Thu, May 26, 2011 at 3:45 AM, Felix Fietkau<nbd@openwrt.org>  wrote:
>>  On 2011-05-25 9:27 PM, Luis R. Rodriguez wrote:
>>>  The missing piece is how to deal with noise info here. In short the
>>>  lower noise we have the better signal we'll get. The challenge then is
>>>  to take into consideration the noise mathematically in such a that a
>>>  high noise value would nullify any clean idle air time ratio
>>>  conditions from the formula postulated before. Let me review again
>>>  with some modifications.
>>>
>>>  Active time is the time we spend on the channel, so to get an idea of
>>>  how "busy" that channel is we have to remove the tx and rx time from
>>>  that channel. That gives us the time we spent idle on that channel.
>>>  Then the busy time is a subset of the entire active time but we should
>>>  also exclude the time we spent tx'ing and rx'ing as well. We then
>>>  have:
>>>
>>>    (busy time - rx time - tx time) / (active time - rx time - tx time)
>>>
>>>  This is a bounded ratio already, given that if we spent 0 time tx'ing
>>>  0 time rx'ing, but 10 ms on a channel, and all that time we had busy
>>>  time as well we'd have a ratio of 10 / 10 = 1. In the best case we'd
>>>  have  0 / 10 = 0.
>>>
>>>  What I'd like to do is to affect the ratio to nullify it if the noise
>>>  is very low on the channel. Given that noise is logarithmic we'd have
>>>  to use a logarithmic function as well. Working on that now.
>>
>>  Please explain why you want to remove the rx time, it makes no sense to me.
>>  Without rx time you will usually not get any useful indication of how busy
>>  the channel is.
>
> The busy time that happens when do not TX or RX accounts for
> interference on the frequency which is not accounted for. RX time may
> mean receiving beacons or probe responses, this type of data exchange
> doesn't necessarily mean interference. I believe sampling conditions
> each frequency without TX or RX'ing data would yield a more fair
> representation of general interference on the channel, otherwise the
> interference would be taking into consideration explicit forced
> interference on the frequency by our own radio.
I think real channel load (including rx) is much more interesting for 
channel selection than only interference. Interference time shouldn't 
really matter that much in practice unless it's excessively high. Also, 
even normal packets will increase the measured non-rx/tx busy time, 
partially due to collisions, partially (on Atheros radios) because of 
the way the radio works.

- Felix
