Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.237]:50777 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbYGXLfq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 07:35:46 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2831568rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2008 04:35:46 -0700 (PDT)
Message-ID: <1ba2fa240807240435g36daa80at254144afffc39c32@mail.gmail.com> (sfid-20080724_133550_701095_354A4111)
Date: Thu, 24 Jul 2008 14:35:46 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Patrick McHardy" <kaber@trash.net>
Subject: Re: [Bugme-new] [Bug 11144] New: dhcp doesn't work with iwl4965
Cc: "David Miller" <davem@davemloft.net>,
	francois.valenduc@tvcablenet.be, akpm@linux-foundation.org,
	bugme-daemon@bugzilla.kernel.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, netdev@vger.kernel.org,
	jussi.kivilinna@mbnet.fi
In-Reply-To: <48885743.8030505@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <4887550B.2070704@tvcablenet.be> <4887555A.30605@trash.net>
	 <48875B8C.2090800@trash.net>
	 <20080723.142147.61941255.davem@davemloft.net>
	 <48884451.1090703@trash.net>
	 <1ba2fa240807240317g15f6ba84h91b513cce75975e9@mail.gmail.com>
	 <48885743.8030505@trash.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 24, 2008 at 1:19 PM, Patrick McHardy <kaber@trash.net> wrote:
> Tomas Winkler wrote:
>>
>> On Thu, Jul 24, 2008 at 11:58 AM, Patrick McHardy <kaber@trash.net> wrote:
>>>
>>> David Miller wrote:
>>>>
>>>> From: Patrick McHardy <kaber@trash.net>
>>>> Date: Wed, 23 Jul 2008 18:25:48 +0200
>>>>
>>>>> We can't fit them into the cb together, I don't see a way to
>>>>> shrink ieee80211_tx_info.
>>>>>
>>>>> Maybe one of the wireless folks can suggest something? Is it
>>>>> really necessary to pass the full struct ieee80211_tx_info
>>>>> through the qdisc layer, or could the struct be split? It
>>>>> needs to find a way to co-exist peacefully with qdiscs'
>>>>> skb->cb usage.
>>>>
>>>> This is another area that got mangled up in the ->select_queue()
>>>> conversion of the WME bits, but in another aspect this problem
>>>> existed beforehand as well.
>>>>
>>>> Specifically, when RX packets get requeued out to transmit in
>>>> the code in net/mac80211/rx.c that resends packets back out the
>>>> wireless device by setting a bit in the SKB CB then calling
>>>> dev_queue_xmit().
>>>>
>>>> That's completely illegal :-)
>>>
>>> It seems its doing even more illegal things that were also
>>> present previously. The ieee80211_master_start_xmit function
>>> expects to get a valid IEEE80211_SKB_CB, which means it
>>> expects it to survive through the entire qdisc layer. I'm
>>> not sure how packets get to the master device from the
>>> subifs though, so I might be wrong.
>>>
>> Isn't this time to make 802.11 native?
>
>
> You mean by making these things real skb members? I hope you're
> not talking about the entire 48 bytes? :)

I mean elevating 802.11 header to 802.3 level. Not doing 802.3 ->
802.11 translation where not needed.
Tomas
