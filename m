Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41942 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932463Ab1LEQLG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Dec 2011 11:11:06 -0500
Received: by faar15 with SMTP id r15so752161faa.19
        for <linux-wireless@vger.kernel.org>; Mon, 05 Dec 2011 08:11:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB3XZEf4sm66WzG49jYsig=wzip0m2w87tud2Es0wd4aXV2Fqw@mail.gmail.com>
References: <CAOeh9MuuJtK_edMQvVaLSRytRoFix_OuW4OEcEMDYEak1=CvMw@mail.gmail.com>
	<CAB3XZEf=jrrqZk58BnV8Gi4iKJ6N6c24M_eLnz816n==kuxmHA@mail.gmail.com>
	<CAOeh9MsqTQT6qzd47Af674cK4KQHN=uOaG-u1hVWV9faeb2Mwg@mail.gmail.com>
	<CAB3XZEf4sm66WzG49jYsig=wzip0m2w87tud2Es0wd4aXV2Fqw@mail.gmail.com>
Date: Mon, 5 Dec 2011 21:41:04 +0530
Message-ID: <CAOeh9MuGyhwC3swbaZWjQ4+qvsVkofR13j=UX-Rjx0KENw8wgQ@mail.gmail.com> (sfid-20111205_171110_644116_D8EE8B24)
Subject: Re: Query on ieee80211_subif_start_xmit
From: uday kiran <kaniki.uday@gmail.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is ieee80211_subif_start_xmit the standard function called for frame
conversion ? Or will it change based on the driver under use ?

For frame conversion to work , is it must to add eth and wlan
interfaces to the bridge interface?

Is it that once 802.3 stack understands that the dest mac is on wi-fi
interface , it calls this function ?

Please clarify.

> 	skip_header_bytes = ETH_HLEN;
> 	if (ethertype == ETH_P_AARP || ethertype == ETH_P_IPX) {
> 		encaps_data = bridge_tunnel_header;
> 		encaps_len = sizeof(bridge_tunnel_header);
> 		skip_header_bytes -= 2;
> 	} else if (ethertype >= 0x600) {
> 		encaps_data = rfc1042_header;
> 		encaps_len = sizeof(rfc1042_header);
> 		skip_header_bytes -= 2;
> 	} else {
> 		encaps_data = NULL;
> 		encaps_len = 0;
> 	}
>
> 	nh_pos = skb_network_header(skb) - skb->data;
> 	h_pos = skb_transport_header(skb) - skb->data;
>
> 	skb_pull(skb, skip_header_bytes);
>
> Eliad.
>
