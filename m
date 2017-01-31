Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:22796 "EHLO mail.neratec.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750790AbdAaHyr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jan 2017 02:54:47 -0500
Subject: Re: Packet throughput (and those iperf data rate) with mac80211/ath9k
 is 20% worse than net80211/madwifi
To: Klaus Kinski <jpo234@outlook.de>
References: <HE1PR0701MB1803E46BC8EC38D682361523FC4B0@HE1PR0701MB1803.eurprd07.prod.outlook.com>
 <87lgtsjz6o.fsf@toke.dk>
 <CAA93jw5w6MaegbE+n9=-+F59vXTjEFGOH94Q=XYxiAqFKHeVfw@mail.gmail.com>
 <HE1PR0701MB1803A03DD96F300119936D0EFC4B0@HE1PR0701MB1803.eurprd07.prod.outlook.com>
 <87o9yo2v0s.fsf@toke.dk>
Cc: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        Dave Taht <dave.taht@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
From: Wojciech Dubowik <wojciech.dubowik@neratec.com>
Message-ID: <d23a5b33-9ec5-a3c3-81ed-91d8e9abe67a@neratec.com> (sfid-20170131_085450_143329_6A83315F)
Date: Tue, 31 Jan 2017 08:54:44 +0100
MIME-Version: 1.0
In-Reply-To: <87o9yo2v0s.fsf@toke.dk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Madwifi has default best effort queue "tuned" for throughout

and its parameters are different from mac80211 defaults when

qos  (WME) is disabled.

You would have to dump qos settings for both systems before

comparing them. I guess the easiest way is to make sure QoS

is enabled and send video type of packets with iperf ... -S 0xa0

Wojtek


On 30/01/17 20:43, Toke Høiland-Jørgensen wrote:
> Klaus Kinski <jpo234@outlook.de> writes:
>
>> The captures I used to create the statistics are here:
>> https://drive.google.com/open?id=0ByFGz3ZH6JcYMGp0a05lYzBPNzA
>>
>> An obvious difference is, that Madwifi sends 5 packets in a row
>> without waiting for an ACK whereas ath9k/mac80211 always seems to wait
>> for an ACK. This seems to point to the "net80211 aggressive mode
>> theory" https://wiki.freebsd.org/WifiAggressiveMode, IMHO.
> I'm not too familiar with that part of the stack, but that seems
> reasonable, yeah. AFAIK the "aggresive mode" is a pre-802.11n feature,
> though, which is why you won't see that in ath9k. In 802.11n this kind
> of bursting was replaced by aggregation, which you're not getting any of
> since you're running in 802.11a mode, obviously.
>
> The lack of bursting will translate to slightly lower throughput, which
> will be why you see fewer packets transmitted by ath9k. Of course, if
> your receiver supported aggregation, the numbers would look dramatically
> better in ath9k's favour... ;)
>
> -Toke
