Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbbCMOG2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 10:06:28 -0400
Message-ID: <1426255583.19064.6.camel@redhat.com> (sfid-20150313_150631_762476_BF138485)
Subject: Re: ARP dropped during WPA handshake
From: Dan Williams <dcbw@redhat.com>
To: voncken <cedric.voncken@acksys.fr>
Cc: "'wim torfs'" <wtorfs@gmail.com>, linux-wireless@vger.kernel.org
Date: Fri, 13 Mar 2015 09:06:23 -0500
In-Reply-To: <033201d05d93$5aa1c030$0fe54090$@acksys.fr>
References: <773DB8A82AB6A046AE0195C68612A319019FECAF@sbs2003.acksys.local>
	 <5502D558.90306@gmail.com> <033201d05d93$5aa1c030$0fe54090$@acksys.fr>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-03-13 at 14:41 +0100, voncken wrote:
> > 
> > 
> > On 03/13/2015 12:36 PM, Cedric VONCKEN wrote:
> > > My test plateforme is very simple, One sta (with openwrt), one AP and
> > > a computer connected to the AP.
> > > I launch iperf on the sta and power up the AP.
> > >
> > > With wireshark I can observe 1 s delay between the frame EAPOL 4/4 and
> > > the arp request sent by the sta. I can observe the delay only if my
> > > sta uses architecture with more 1 cpu.
> > >
> > > When the sta received the Authentication response, mac80211 sets the
> > > iface on UP state. This state allows wpa_supplicant to send the EAPOL
> > > frame for WPA handshake but other frames are dropped.
> > >
> > > If an arp request is sent by the local ip stack during the WPA
> > > handshake this arp will be dropped and we need to wait the end of arp
> > > timeout (1 s).
> > >
> > > Have you any suggestion / pointer to fix this issue?
> > >
> > 
> > I had a situation where ARP requests were sent and responses were replied,
> > but the requester did not accept the responses and therefore was
> continuously
> > sending request. However, this was in an IBSS and WPA encryption, which is
> > not really supported if I understand well. RSN worked like a charm,
> though.
> > The issue was related to the type of encryption. This could also be an
> issue
> > in your case, however, AP is well supported, so hard to tell. I'm not
> really
> > a security expert.
> > 
> > My point being, you will get better and faster support if you could
> specify
> > which encryption protocol you use, the specific parameters, etc.
> > 
> > br,
> > Wim.
> > 
> 
> My platform is very simple. I use 2 equipment. Both equipment are based on
> mips64 processor, use ATH9K driver and openwrt.
> One equipment is configured in AP mode with WPA2-PSK, another equipment is
> configured in station mode. 
> I can access to the sta through ssh. 
> 
> Below, a tcpdump capture from sta.
> 17:43:12.964096 EAPOL key (3) v2, len 95
> 17:43:12.998439 EAPOL key (3) v1, len 117
> 17:43:13.062409 ARP, Request who-has 10.32.61.100 tell 10.32.0.1, length 28
> 17:43:13.079989 EAPOL key (3) v2, len 151
> 17:43:13.082764 EAPOL key (3) v1, len 95
> 17:43:14.062381 ARP, Request who-has 10.32.61.100 tell 10.32.0.1, length 28
> 17:43:14.127101 ARP, Reply 10.32.61.100 is-at b8:88:e3:45:1d:c6 (oui
> Unknown), length 46
> 17:43:14.127123 IP 10.69.1.201.41690 > 10.32.61.100.5001: UDP, length 1470
> 17:43:14.127136 IP 10.69.1.201.41690 > 10.32.61.100.5001: UDP, length 1470
> 
> You can see the ARP request during the WPA Handshake.

During the initial WPA handshake the connection is not fully set up, and
so no general traffic can (nor should) pass between the STA and AP.
That includes ARP and any L2/L3+ protocols, except for EAP and wifi
management packets.

The interface itself must be IFF_UP before it can pass traffic,
including the WPA handshake traffic.  IFF_UP only means that the
interface can be configured at the L2 level and the hardware is active,
it does *not* mean the interface can pass traffic.

Whatever is causing the ARPs shouldn't be doing that yet, and should be
fixed to use the interface's "operstate" or IFF_LOWER_UP instead of
IFF_UP.  Only when the supplicant changes the interface's operstate to
IF_OPER_UP is the interface *actually* ready to pass traffic.  IFF_UP is
not sufficient.

Dan


> 	Any suggestion will be appreciate.
> 
> Cedric.
> > 
> > > Thanks for your help.
> > >
> > > Cedric Voncken
> > >
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe
> > > linux-wireless" in the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


