Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.243]:34087 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbYBBCkp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 21:40:45 -0500
Received: by an-out-0708.google.com with SMTP id d31so331310and.103
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2008 18:40:44 -0800 (PST)
Message-ID: <40f31dec0802011840r56817691j3e74d3566f53bc28@mail.gmail.com> (sfid-20080202_024049_639963_22E0147E)
Date: Sat, 2 Feb 2008 04:40:44 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: mac80211 QoS/aggregation questions, thoughts
Cc: "Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Jouni Malinen" <j@w1.fi>, "Ivo van Doorn" <ivdoorn@gmail.com>,
	"Tomas Winkler" <tomasw@gmail.com>,
	"Patrick McHardy" <kaber@trash.net>
In-Reply-To: <1201882512.4188.66.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1201882512.4188.66.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> To be honest, I'm totally unclear on how all this queue stuff is
> supposed to work. Ivo pointed me to IEEE80211_TX_QUEUE_AFTER_BEACON
> which is unused and duplicated with IEEE80211_TXCTL_SEND_AFTER_DTIM.
>
> It seems to me that this queue stuff is mostly designed after atheros
> hardware and we should be getting rid of it...
>

Atheros hw has 12 hw queues since 5211, one is used already for
beacons inside ath5k (check out beacon_config/setup etc functions
inside hw.c), one called CAB ("crap after beacon" i think), and 10
data queues (newer hw might have more queues -madwifi btw only
includes 10 out of 12 queues on HAL's headers). I guess they can go
away since we have beacon_update callback from stack (we know what
frames to put in that queue anyway and cwmin/max parameters for
beacons are standard i guess).

> Ultimately, we only need four data queues as required by WMM and then
> A-MPDU queues. Right now, you can only use 12 of the 16 queues iwl4965
> hw offers (well actually 13 but I think using the BEACON queue ID is
> wrong so 12 if that mistake is corrected) as far as I can tell, because
> the qdisc_pool is only searched starting with IEEE80211_TX_QUEUE_BEACON
> (but see above).
>
> Here's a possible plan:
>
>      1. move queue configuration for data queues to bss-config
>         structure, it really is part of the bss configuration since it
>         is mandated by the AP

ACK, btw why do we have a separate ht_bss_conf which is handled by
bss_info_changed instead of bss_info_changed or conf_ht ?

>      2. get rid of IEEE80211_TX_QUEUE_BEACON, it isn't used in mac80211
>         and it's not hardware-independent, not all hardware actually
>         uses a queue for beacons (b43 for example does beaconing
>         differently), those drivers that do use a queue will have to do
>         that internally. Also, the one place where it is used is the
>         queue configuration for IBSS beacons, but that somewhat bogus
>         anyway since we never reset that should we go back into AP mode
>         after being in IBSS! Hence, I think the driver should handle
>         that when an interface is brought up. Ivo, any comments?

ACK

>      3. get rid of IEEE80211_TX_QUEUE_AFTER_BEACON, we have
>         IEEE80211_TXCTL_SEND_AFTER_DTIM now and that is
>         hardware-independent

ACK

>      4. remove IEEE80211_TX_QUEUE_SVP, it's something strange and
>         atheros specific

ACK spectralink voice protocol, some voip related stuff i don't know
anything about, i just found it's definition on some old d80211 header
while porting openhal to dadwifi and wanted to make openhal's code
more portable across stacks so i added the comment on ath5k.h to note
the mapping.

>      5. remove IEEE80211_TX_QUEUE_DATA4, only rt61pci uses that and that
>         use is strange, Ivo? We never submit frames to that queue...
>

ACK and btw let's also rename them, DATA* is not very informative,
something like IEEE80211_TX_QUEUE_BE would be better imho



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
