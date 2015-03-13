Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp01.msg.oleane.net ([62.161.4.1]:36728 "EHLO
	smtp01.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756549AbbCMPxj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 11:53:39 -0400
From: "voncken" <cedric.voncken@acksys.fr>
To: "'Dan Williams'" <dcbw@redhat.com>
Cc: "'wim torfs'" <wtorfs@gmail.com>, <linux-wireless@vger.kernel.org>
References: <773DB8A82AB6A046AE0195C68612A319019FECAF@sbs2003.acksys.local>	 <5502D558.90306@gmail.com> <033201d05d93$5aa1c030$0fe54090$@acksys.fr> <1426255583.19064.6.camel@redhat.com>
In-Reply-To: <1426255583.19064.6.camel@redhat.com>
Subject: RE: ARP dropped during WPA handshake
Date: Fri, 13 Mar 2015 16:53:22 +0100
Message-ID: <034401d05da5$d5c0be30$81423a90$@acksys.fr> (sfid-20150313_165343_007514_C2D62E3E)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Below, a tcpdump capture from sta.
> > 17:43:12.964096 EAPOL key (3) v2, len 95
> > 17:43:12.998439 EAPOL key (3) v1, len 117
> > 17:43:13.062409 ARP, Request who-has 10.32.61.100 tell 10.32.0.1,
> > length 28
> > 17:43:13.079989 EAPOL key (3) v2, len 151
> > 17:43:13.082764 EAPOL key (3) v1, len 95
> > 17:43:14.062381 ARP, Request who-has 10.32.61.100 tell 10.32.0.1,
> > length 28
> > 17:43:14.127101 ARP, Reply 10.32.61.100 is-at b8:88:e3:45:1d:c6 (oui
> > Unknown), length 46
> > 17:43:14.127123 IP 10.69.1.201.41690 > 10.32.61.100.5001: UDP, length
> > 1470
> > 17:43:14.127136 IP 10.69.1.201.41690 > 10.32.61.100.5001: UDP, length
> > 1470
> >
> > You can see the ARP request during the WPA Handshake.
> 
> During the initial WPA handshake the connection is not fully set up, and so
> no general traffic can (nor should) pass between the STA and AP.
> That includes ARP and any L2/L3+ protocols, except for EAP and wifi
> management packets.
> 
> The interface itself must be IFF_UP before it can pass traffic, including the
> WPA handshake traffic.  IFF_UP only means that the interface can be
> configured at the L2 level and the hardware is active, it does *not* mean the
> interface can pass traffic.
> 
> Whatever is causing the ARPs shouldn't be doing that yet, and should be fixed
> to use the interface's "operstate" or IFF_LOWER_UP instead of IFF_UP.  Only
> when the supplicant changes the interface's operstate to IF_OPER_UP is the
> interface *actually* ready to pass traffic.  IFF_UP is not sufficient.
> 

Thanks for your reply. 

It seems wpa_supplicant set the operstate to IF_OPER_DORMANT when he received the ASSOCIATED Event from the driver (through netlink). And set the operstate to IF_OPER_UP in case of wpa handshake success.

Is it normal the local ip stack send arp when netdev it is on IF_OPER_DORMANT state?
	

> 
> 
> > 	Any suggestion will be appreciate.
> >
> > Cedric.
> > >
> > > > Thanks for your help.
> > > >
> > > > Cedric Voncken
> > > >
> > > >
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe
> > > > linux-wireless" in the body of a message to
> > > > majordomo@vger.kernel.org More majordomo info at
> > > > http://vger.kernel.org/majordomo-info.html
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-wireless" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


