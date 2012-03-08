Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64522 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885Ab2CHLdG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 06:33:06 -0500
Received: by bkcik5 with SMTP id ik5so243702bkc.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Mar 2012 03:33:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAO1ZyKkpZy38vNc8iCOODnuVeJJPPb-DOH=+HFPvgGGjj+hDMA@mail.gmail.com>
References: <CAO1ZyKkpZy38vNc8iCOODnuVeJJPPb-DOH=+HFPvgGGjj+hDMA@mail.gmail.com>
Date: Thu, 8 Mar 2012 17:03:04 +0530
Message-ID: <CAD2nsn08oU9MCEnYoFpHPmUfo+7bXrnOP2k1P7PH4P_1NH59Vg@mail.gmail.com> (sfid-20120308_123311_327468_09B18652)
Subject: Re: Accessing PROTOCOL TYPE FILES from rx.c in mac80211
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Claudio Rossi <rossi.claudio.82@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 8, 2012 at 3:54 PM, Claudio Rossi
<rossi.claudio.82@gmail.com> wrote:
> Dear all,
>  I would like to inspect the protocol type field from mac802.11, and
> specifically in rx.c in the function
>
> static ieee80211_rx_result debug_noinline
> ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)

may be you should do this stuff after ieee80211_deliver_skb in 1740, rx.c

if (skb) {
			/* deliver to local stack */
			skb->protocol = eth_type_trans(skb, dev);
			memset(skb->cb, 0, sizeof(skb->cb));
			netif_receive_skb(skb);
		}
	}


>
> I was trying to do:
>
> struct iphdr * network_header;
> skb_set_network_header(skb,ieee80211_get_hdrlen_from_skb(skb));
> network_header = (struct iphdr *)skb_network_header(skb);
>
>  if (network_header->protocol==IPPROTO_TCP){
> ...
> }
> but it does not seams to work....
>
> In status.c everything works fine when I do:
>
> struct iphdr * network_header;
>
> network_header = (struct iphdr *)skb_network_header(skb);
>
>  if (network_header->protocol==IPPROTO_TCP){
> ...
> }
>
> the problem is how to correctly set the network header pointer in the
> skb in rx.c
> can somebody give me an hint?
>
>
> Thank you
>
> --
> Claudio Rossi
> -------------------
> Office @ PoliTO: +39 011 5644194
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi
