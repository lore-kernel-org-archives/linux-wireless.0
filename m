Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34863 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab2CJLCM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Mar 2012 06:02:12 -0500
Received: by vcqp1 with SMTP id p1so2319243vcq.19
        for <linux-wireless@vger.kernel.org>; Sat, 10 Mar 2012 03:02:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAO1ZyK=kzvnRS8BsZoyqqun4-sra=AROF_uL1Nxjr2BoQCGwhw@mail.gmail.com>
References: <CAO1ZyKkpZy38vNc8iCOODnuVeJJPPb-DOH=+HFPvgGGjj+hDMA@mail.gmail.com>
	<CAD2nsn08oU9MCEnYoFpHPmUfo+7bXrnOP2k1P7PH4P_1NH59Vg@mail.gmail.com>
	<CAO1ZyK=kzvnRS8BsZoyqqun4-sra=AROF_uL1Nxjr2BoQCGwhw@mail.gmail.com>
Date: Sat, 10 Mar 2012 16:32:11 +0530
Message-ID: <CAD2nsn1NMY2vmiQVoaSP+yGH70QWma8dY02a8r5gz4YmtfsDFQ@mail.gmail.com> (sfid-20120310_120238_330590_2F2A7DB0)
Subject: Re: Accessing PROTOCOL TYPE FILES from rx.c in mac80211
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Claudio Rossi <rossi.claudio.82@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Claudio,

>  I need to work inside  ieee80211_rx_h_sta_process as I have to
> perform stationwise stats and I have to catch all packets, also the
> ones that will be redirected to the BSS.
> I think that the problem arise because the pointer of the
> network_header is not correctly set.
> If I am not wrong, at this point of the receive path the skb should
> contain the 802.11 header as a first element, so I did
> skb_set_nework_header(skb,ieee80211_get_hdrlen_from_skb(skb)))
> I was supposing that after the MAC header there is the IP header... no
> ethernet header in between. Is this the case?
> Also doing

currently don't have much idea, need to poke into the code

> skb_set_nework_header(skb,ieee80211_get_hdrlen_from_skb(skb)+sizeof(struct(ethhdr)))
> does not work
> Does somebody have any hint?
> thank you
>
> Claudio
>
>
> 2012/3/8 Mohammed Shafi <shafi.wireless@gmail.com>:
>> On Thu, Mar 8, 2012 at 3:54 PM, Claudio Rossi
>> <rossi.claudio.82@gmail.com> wrote:
>>> Dear all,
>>>  I would like to inspect the protocol type field from mac802.11, and
>>> specifically in rx.c in the function
>>>
>>> static ieee80211_rx_result debug_noinline
>>> ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
>>
>> may be you should do this stuff after ieee80211_deliver_skb in 1740, rx.c
>>
>> if (skb) {
>>                        /* deliver to local stack */
>>                        skb->protocol = eth_type_trans(skb, dev);
>>                        memset(skb->cb, 0, sizeof(skb->cb));
>>                        netif_receive_skb(skb);
>>                }
>>        }
>>
>>
>>>
>>> I was trying to do:
>>>
>>> struct iphdr * network_header;
>>> skb_set_network_header(skb,ieee80211_get_hdrlen_from_skb(skb));
>>> network_header = (struct iphdr *)skb_network_header(skb);
>>>
>>>  if (network_header->protocol==IPPROTO_TCP){
>>> ...
>>> }
>>> but it does not seams to work....
>>>
>>> In status.c everything works fine when I do:
>>>
>>> struct iphdr * network_header;
>>>
>>> network_header = (struct iphdr *)skb_network_header(skb);
>>>
>>>  if (network_header->protocol==IPPROTO_TCP){
>>> ...
>>> }
>>>
>>> the problem is how to correctly set the network header pointer in the
>>> skb in rx.c
>>> can somebody give me an hint?
>>>
>>>
>>> Thank you
>>>
>>> --
>>> Claudio Rossi
>>> -------------------
>>> Office @ PoliTO: +39 011 5644194
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>> --
>> thanks,
>> shafi
>
>
>
> --
> Claudio Rossi
> -------------------
> Office @ PoliTO: +39 011 5644194



-- 
thanks,
shafi
