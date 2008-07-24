Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63139 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbYGXKTv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 06:19:51 -0400
Message-ID: <48885743.8030505@trash.net> (sfid-20080724_121954_779159_81F751BE)
Date: Thu, 24 Jul 2008 12:19:47 +0200
From: Patrick McHardy <kaber@trash.net>
MIME-Version: 1.0
To: Tomas Winkler <tomasw@gmail.com>
CC: David Miller <davem@davemloft.net>,
	francois.valenduc@tvcablenet.be, akpm@linux-foundation.org,
	bugme-daemon@bugzilla.kernel.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, netdev@vger.kernel.org,
	jussi.kivilinna@mbnet.fi
Subject: Re: [Bugme-new] [Bug 11144] New: dhcp doesn't work with iwl4965
References: <4887550B.2070704@tvcablenet.be> <4887555A.30605@trash.net>	 <48875B8C.2090800@trash.net>	 <20080723.142147.61941255.davem@davemloft.net>	 <48884451.1090703@trash.net> <1ba2fa240807240317g15f6ba84h91b513cce75975e9@mail.gmail.com>
In-Reply-To: <1ba2fa240807240317g15f6ba84h91b513cce75975e9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler wrote:
> On Thu, Jul 24, 2008 at 11:58 AM, Patrick McHardy <kaber@trash.net> wrote:
>> David Miller wrote:
>>> From: Patrick McHardy <kaber@trash.net>
>>> Date: Wed, 23 Jul 2008 18:25:48 +0200
>>>
>>>> We can't fit them into the cb together, I don't see a way to
>>>> shrink ieee80211_tx_info.
>>>>
>>>> Maybe one of the wireless folks can suggest something? Is it
>>>> really necessary to pass the full struct ieee80211_tx_info
>>>> through the qdisc layer, or could the struct be split? It
>>>> needs to find a way to co-exist peacefully with qdiscs'
>>>> skb->cb usage.
>>> This is another area that got mangled up in the ->select_queue()
>>> conversion of the WME bits, but in another aspect this problem
>>> existed beforehand as well.
>>>
>>> Specifically, when RX packets get requeued out to transmit in
>>> the code in net/mac80211/rx.c that resends packets back out the
>>> wireless device by setting a bit in the SKB CB then calling
>>> dev_queue_xmit().
>>>
>>> That's completely illegal :-)
>> It seems its doing even more illegal things that were also
>> present previously. The ieee80211_master_start_xmit function
>> expects to get a valid IEEE80211_SKB_CB, which means it
>> expects it to survive through the entire qdisc layer. I'm
>> not sure how packets get to the master device from the
>> subifs though, so I might be wrong.
>>
> Isn't this time to make 802.11 native?


You mean by making these things real skb members? I hope you're
not talking about the entire 48 bytes? :)

