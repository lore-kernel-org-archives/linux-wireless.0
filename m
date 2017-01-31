Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:41981 "EHLO mail.neratec.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751604AbdAaKSL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jan 2017 05:18:11 -0500
Subject: Re: Packet throughput (and those iperf data rate) with mac80211/ath9k
 is 20% worse than net80211/madwifi
To: Klaus Kinski <jpo234@outlook.de>
References: <HE1PR0701MB1803E46BC8EC38D682361523FC4B0@HE1PR0701MB1803.eurprd07.prod.outlook.com>
 <87lgtsjz6o.fsf@toke.dk>
 <CAA93jw5w6MaegbE+n9=-+F59vXTjEFGOH94Q=XYxiAqFKHeVfw@mail.gmail.com>
 <HE1PR0701MB1803A03DD96F300119936D0EFC4B0@HE1PR0701MB1803.eurprd07.prod.outlook.com>
 <87o9yo2v0s.fsf@toke.dk> <d23a5b33-9ec5-a3c3-81ed-91d8e9abe67a@neratec.com>
 <HE1PR0701MB18031C6DF4DF46865EBF9E87FC4A0@HE1PR0701MB1803.eurprd07.prod.outlook.com>
 <f5adadba-2764-a7cc-c661-7061545341a7@neratec.com>
 <CAEvAWuGa6YSFA80mC0+saoGO5VWGNqfbyw94Nv0vfhSoQfD-Jw@mail.gmail.com>
 <HE1PR0701MB1803B7D5D0182EF7DD662B18FC4A0@HE1PR0701MB1803.eurprd07.prod.outlook.com>
Cc: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        Dave Taht <dave.taht@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
From: Wojciech Dubowik <wojciech.dubowik@neratec.com>
Message-ID: <afccf3d4-b095-1a64-fd08-d559b44bcb72@neratec.com> (sfid-20170131_111924_227785_3DC6B7B8)
Date: Tue, 31 Jan 2017 10:52:30 +0100
MIME-Version: 1.0
In-Reply-To: <HE1PR0701MB1803B7D5D0182EF7DD662B18FC4A0@HE1PR0701MB1803.eurprd07.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 31/01/17 10:46, Klaus Kinski wrote:
> BTW, if I read the sources correctly, than IBSS mode uses the TXQ 
> parameters from ieee80211_set_wmm_default with enable_qos = false 
> which means that qparam.txop = 0, e.g. bursting is disabled. Am I right?
I guess so. But you need to look also at contention window sizes because 
it make a big impact on throughout with retries and collisions.
>
> Jörg Pommnitz <jpo234@outlook.de <mailto:jpo234@outlook.de>> schrieb 
> am Di., 31. Jan. 2017 um 10:37 Uhr:
>
>     I'm mostly interested in Ad-Hoc mode, e.g. IBSS.
>
>     Wojciech Dubowik <wojciech.dubowik@neratec.com
>     <mailto:wojciech.dubowik@neratec.com>> schrieb am Di., 31. Jan.
>     2017 um 10:35 Uhr:
>
>         That's tricky but look at
>         http://w1.fi/cgit/hostap/tree/hostapd/hostapd.conf
>         <http://w1.fi/cgit/hostap/tree/hostapd/hostapd.conf>
>
>         tx_queue... are for AP and wmm_... for STA (over beacons).
>
>         These should be default parameters. You can also enable CONFIG
>         debug flag
>
>         for ath9k and it prints wme parameters when it starts.
>
>         Wojtek
>
>
>         On 31/01/17 10:18, Klaus Kinski wrote:
>>         It seems that bursting can be controlled over nl80211 (see ,
>>         specifically with NL80211_ATTR_WIPHY_TXQ_PARAMS.
>>         Unfortunately this seems not to be exposed in iw. It's an
>>         attribute of NL80211_CMD_SET_WIPHY.
>>         Is there another tool that exposes txq params? If not, has
>>         anybody thought about exposing it in iw? I might take a stab
>>         at it...
>>
>>         Regards
>>           Joerg
>>
>>         Wojciech Dubowik <wojciech.dubowik@neratec.com
>>         <mailto:wojciech.dubowik@neratec.com>> schrieb am Di., 31.
>>         Jan. 2017 um 08:55 Uhr:
>>
>>             Madwifi has default best effort queue "tuned" for throughout
>>
>>             and its parameters are different from mac80211 defaults when
>>
>>             qos  (WME) is disabled.
>>
>>             You would have to dump qos settings for both systems before
>>
>>             comparing them. I guess the easiest way is to make sure QoS
>>
>>             is enabled and send video type of packets with iperf ...
>>             -S 0xa0
>>
>>             Wojtek
>>
>>
>>             On 30/01/17 20:43, Toke Høiland-Jørgensen wrote:
>>             > Klaus Kinski <jpo234@outlook.de
>>             <mailto:jpo234@outlook.de>> writes:
>>             >
>>             >> The captures I used to create the statistics are here:
>>             >>
>>             https://drive.google.com/open?id=0ByFGz3ZH6JcYMGp0a05lYzBPNzA
>>             >>
>>             >> An obvious difference is, that Madwifi sends 5 packets
>>             in a row
>>             >> without waiting for an ACK whereas ath9k/mac80211
>>             always seems to wait
>>             >> for an ACK. This seems to point to the "net80211
>>             aggressive mode
>>             >> theory" https://wiki.freebsd.org/WifiAggressiveMode
>>             <https://wiki.freebsd.org/WifiAggressiveMode>, IMHO.
>>             > I'm not too familiar with that part of the stack, but
>>             that seems
>>             > reasonable, yeah. AFAIK the "aggresive mode" is a
>>             pre-802.11n feature,
>>             > though, which is why you won't see that in ath9k. In
>>             802.11n this kind
>>             > of bursting was replaced by aggregation, which you're
>>             not getting any of
>>             > since you're running in 802.11a mode, obviously.
>>             >
>>             > The lack of bursting will translate to slightly lower
>>             throughput, which
>>             > will be why you see fewer packets transmitted by ath9k.
>>             Of course, if
>>             > your receiver supported aggregation, the numbers would
>>             look dramatically
>>             > better in ath9k's favour... ;)
>>             >
>>             > -Toke
>>
