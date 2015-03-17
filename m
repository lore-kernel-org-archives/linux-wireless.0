Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932675AbbCQQEc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 12:04:32 -0400
Message-ID: <1426608255.11120.2.camel@redhat.com> (sfid-20150317_170448_316813_DA8569C0)
Subject: Re: ARP dropped during WPA handshake
From: Dan Williams <dcbw@redhat.com>
To: voncken <cedric.voncken@acksys.fr>
Cc: "'wim torfs'" <wtorfs@gmail.com>, linux-wireless@vger.kernel.org
Date: Tue, 17 Mar 2015 11:04:15 -0500
In-Reply-To: <03e401d060c3$6fcd9e60$4f68db20$@acksys.fr>
References: <773DB8A82AB6A046AE0195C68612A319019FECAF@sbs2003.acksys.local>
			 <5502D558.90306@gmail.com> <033201d05d93$5aa1c030$0fe54090$@acksys.fr>
		 <1426255583.19064.6.camel@redhat.com>
		 <034401d05da5$d5c0be30$81423a90$@acksys.fr>
	 <1426264174.19064.19.camel@redhat.com>
	 <03e401d060c3$6fcd9e60$4f68db20$@acksys.fr>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-03-17 at 16:02 +0100, voncken wrote:
> 
> > > > During the initial WPA handshake the connection is not fully set up,
> > > > and so no general traffic can (nor should) pass between the STA and AP.
> > > > That includes ARP and any L2/L3+ protocols, except for EAP and wifi
> > > > management packets.
> > > >
> > > > The interface itself must be IFF_UP before it can pass traffic,
> > > > including the WPA handshake traffic.  IFF_UP only means that the
> > > > interface can be configured at the L2 level and the hardware is
> > > > active, it does *not* mean the interface can pass traffic.
> > > >
> > > > Whatever is causing the ARPs shouldn't be doing that yet, and should
> > > > be fixed to use the interface's "operstate" or IFF_LOWER_UP instead
> > > > of IFF_UP.  Only when the supplicant changes the interface's
> > > > operstate to IF_OPER_UP is the interface *actually* ready to pass
> > traffic.  IFF_UP is not sufficient.
> > > >
> > >
> > > Thanks for your reply.
> > >
> > > It seems wpa_supplicant set the operstate to IF_OPER_DORMANT when he
> > received the ASSOCIATED Event from the driver (through netlink). And set the
> > operstate to IF_OPER_UP in case of wpa handshake success.
> > >
> > > Is it normal the local ip stack send arp when netdev it is on
> > IF_OPER_DORMANT state?
> > 
> > I'm not sure the kernel stack cares much as long as the device is up.
> > It is requesting the ARP because some application is attempting to
> > communicate with that IP address.  That application should probably be
> > waiting until the interface is actually ready to communicate, which means
> > IF_OPER_UP.
> > 
> > But if this is the first WPA handshake with the AP during the initial
> > connection, the wifi device shouldn't even have an IP address yet, so nothing
> > should be doing ARP on the interface yet.  Perhaps whatever is assigning the
> > IP address to the interface is doing it too early, before the interface is
> > IF_OPER_UP?
> > 
> It is not the initial connection. My sta is connected on AP1 and the communication is established (in my test the communication it is iperf from STA to computer behind the APs). 
> 
> I looking for a solution to enable the communication for wpa_supplicant, but block the L3 communication while the WPA handshake is not finished.

Yeah, I saw your mail to netdev.  In my opinion (which may not count for
much) I don't think the kernel should be doing any ARP when the
interface is not IF_OPER_UP.  wpa_supplicant is doing the right thing if
it is setting the interface IF_OPER_DORMANT when doing the rekeying and
then setting the interface to IF_OPER_UP when it has successfully
installed the new keys.

There's only a few places where ARPs get triggered in the kernel, and
perhaps those need to be modified to defer the ARP until IF_OPER_UP or
something like that.  In any case, I think this is best followed up on
netdev since I don't think the supplicant is doing anything wrong here.

Dan

