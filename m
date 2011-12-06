Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55381 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932984Ab1LFIRK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Dec 2011 03:17:10 -0500
Received: by faar15 with SMTP id r15so1411166faa.19
        for <linux-wireless@vger.kernel.org>; Tue, 06 Dec 2011 00:17:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOeh9MuGyhwC3swbaZWjQ4+qvsVkofR13j=UX-Rjx0KENw8wgQ@mail.gmail.com>
References: <CAOeh9MuuJtK_edMQvVaLSRytRoFix_OuW4OEcEMDYEak1=CvMw@mail.gmail.com>
	<CAB3XZEf=jrrqZk58BnV8Gi4iKJ6N6c24M_eLnz816n==kuxmHA@mail.gmail.com>
	<CAOeh9MsqTQT6qzd47Af674cK4KQHN=uOaG-u1hVWV9faeb2Mwg@mail.gmail.com>
	<CAB3XZEf4sm66WzG49jYsig=wzip0m2w87tud2Es0wd4aXV2Fqw@mail.gmail.com>
	<CAOeh9MuGyhwC3swbaZWjQ4+qvsVkofR13j=UX-Rjx0KENw8wgQ@mail.gmail.com>
Date: Tue, 6 Dec 2011 13:47:09 +0530
Message-ID: <CAOeh9MvgzNnToPMSwt0_QX+T5T63dJDuekoUOU6_JcbFDmXV-g@mail.gmail.com> (sfid-20111206_091714_709939_C42E53E6)
Subject: Re: Query on ieee80211_subif_start_xmit
From: uday kiran <kaniki.uday@gmail.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Any pointers ?

On 12/5/11, uday kiran <kaniki.uday@gmail.com> wrote:
> Is ieee80211_subif_start_xmit the standard function called for frame
> conversion ? Or will it change based on the driver under use ?
>
> For frame conversion to work , is it must to add eth and wlan
> interfaces to the bridge interface?
>
> Is it that once 802.3 stack understands that the dest mac is on wi-fi
> interface , it calls this function ?
>
> Please clarify.
>
>> 	skip_header_bytes = ETH_HLEN;
>> 	if (ethertype == ETH_P_AARP || ethertype == ETH_P_IPX) {
>> 		encaps_data = bridge_tunnel_header;
>> 		encaps_len = sizeof(bridge_tunnel_header);
>> 		skip_header_bytes -= 2;
>> 	} else if (ethertype >= 0x600) {
>> 		encaps_data = rfc1042_header;
>> 		encaps_len = sizeof(rfc1042_header);
>> 		skip_header_bytes -= 2;
>> 	} else {
>> 		encaps_data = NULL;
>> 		encaps_len = 0;
>> 	}
>>
>> 	nh_pos = skb_network_header(skb) - skb->data;
>> 	h_pos = skb_transport_header(skb) - skb->data;
>>
>> 	skb_pull(skb, skip_header_bytes);
>>
>> Eliad.
>>
>
