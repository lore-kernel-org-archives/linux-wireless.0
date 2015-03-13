Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:34823 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbbCMMRc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 08:17:32 -0400
Received: by wesw55 with SMTP id w55so22872473wes.2
        for <linux-wireless@vger.kernel.org>; Fri, 13 Mar 2015 05:17:31 -0700 (PDT)
Message-ID: <5502D558.90306@gmail.com> (sfid-20150313_131735_521922_8C8852F2)
Date: Fri, 13 Mar 2015 13:17:28 +0100
From: wim torfs <wtorfs@gmail.com>
MIME-Version: 1.0
To: Cedric VONCKEN <cedric.voncken@acksys.fr>
CC: linux-wireless@vger.kernel.org
Subject: Re: ARP dropped during WPA handshake
References: <773DB8A82AB6A046AE0195C68612A319019FECAF@sbs2003.acksys.local>
In-Reply-To: <773DB8A82AB6A046AE0195C68612A319019FECAF@sbs2003.acksys.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 03/13/2015 12:36 PM, Cedric VONCKEN wrote:
> My test plateforme is very simple, One sta (with openwrt), one AP and a
> computer connected to the AP.
> I launch iperf on the sta and power up the AP.
>
> With wireshark I can observe 1 s delay between the frame EAPOL 4/4 and
> the arp request sent by the sta. I can observe the delay only if my sta
> uses architecture with more 1 cpu.
>
> When the sta received the Authentication response, mac80211 sets the
> iface on UP state. This state allows wpa_supplicant to send the EAPOL
> frame for WPA handshake but other frames are dropped.
>
> If an arp request is sent by the local ip stack during the WPA handshake
> this arp will be dropped and we need to wait the end of arp timeout (1
> s).
>
> Have you any suggestion / pointer to fix this issue?
>

I had a situation where ARP requests were sent and responses were 
replied, but the requester did not accept the responses and therefore 
was continuously sending request. However, this was in an IBSS and WPA 
encryption, which is not really supported if I understand well. RSN 
worked like a charm, though. The issue was related to the type of 
encryption. This could also be an issue in your case, however, AP is 
well supported, so hard to tell. I'm not really a security expert.

My point being, you will get better and faster support if you could 
specify which encryption protocol you use, the specific parameters, etc.

br,
Wim.


> Thanks for your help.
>
> Cedric Voncken
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
