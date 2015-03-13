Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp06.msg.oleane.net ([62.161.4.6]:45753 "EHLO
	smtp06.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbbCMNlJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 09:41:09 -0400
From: "voncken" <cedric.voncken@acksys.fr>
To: "'wim torfs'" <wtorfs@gmail.com>
Cc: <linux-wireless@vger.kernel.org>
References: <773DB8A82AB6A046AE0195C68612A319019FECAF@sbs2003.acksys.local> <5502D558.90306@gmail.com>
In-Reply-To: <5502D558.90306@gmail.com>
Subject: RE: ARP dropped during WPA handshake
Date: Fri, 13 Mar 2015 14:41:05 +0100
Message-ID: <033201d05d93$5aa1c030$0fe54090$@acksys.fr> (sfid-20150313_144119_076293_3661DA83)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> 
> On 03/13/2015 12:36 PM, Cedric VONCKEN wrote:
> > My test plateforme is very simple, One sta (with openwrt), one AP and
> > a computer connected to the AP.
> > I launch iperf on the sta and power up the AP.
> >
> > With wireshark I can observe 1 s delay between the frame EAPOL 4/4 and
> > the arp request sent by the sta. I can observe the delay only if my
> > sta uses architecture with more 1 cpu.
> >
> > When the sta received the Authentication response, mac80211 sets the
> > iface on UP state. This state allows wpa_supplicant to send the EAPOL
> > frame for WPA handshake but other frames are dropped.
> >
> > If an arp request is sent by the local ip stack during the WPA
> > handshake this arp will be dropped and we need to wait the end of arp
> > timeout (1 s).
> >
> > Have you any suggestion / pointer to fix this issue?
> >
> 
> I had a situation where ARP requests were sent and responses were replied,
> but the requester did not accept the responses and therefore was
continuously
> sending request. However, this was in an IBSS and WPA encryption, which is
> not really supported if I understand well. RSN worked like a charm,
though.
> The issue was related to the type of encryption. This could also be an
issue
> in your case, however, AP is well supported, so hard to tell. I'm not
really
> a security expert.
> 
> My point being, you will get better and faster support if you could
specify
> which encryption protocol you use, the specific parameters, etc.
> 
> br,
> Wim.
> 

My platform is very simple. I use 2 equipment. Both equipment are based on
mips64 processor, use ATH9K driver and openwrt.
One equipment is configured in AP mode with WPA2-PSK, another equipment is
configured in station mode. 
I can access to the sta through ssh. 

Below, a tcpdump capture from sta.
17:43:12.964096 EAPOL key (3) v2, len 95
17:43:12.998439 EAPOL key (3) v1, len 117
17:43:13.062409 ARP, Request who-has 10.32.61.100 tell 10.32.0.1, length 28
17:43:13.079989 EAPOL key (3) v2, len 151
17:43:13.082764 EAPOL key (3) v1, len 95
17:43:14.062381 ARP, Request who-has 10.32.61.100 tell 10.32.0.1, length 28
17:43:14.127101 ARP, Reply 10.32.61.100 is-at b8:88:e3:45:1d:c6 (oui
Unknown), length 46
17:43:14.127123 IP 10.69.1.201.41690 > 10.32.61.100.5001: UDP, length 1470
17:43:14.127136 IP 10.69.1.201.41690 > 10.32.61.100.5001: UDP, length 1470

You can see the ARP request during the WPA Handshake.

	Any suggestion will be appreciate.

Cedric.
> 
> > Thanks for your help.
> >
> > Cedric Voncken
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-wireless" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

