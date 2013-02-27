Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51253 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508Ab3B0SpT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2013 13:45:19 -0500
Message-ID: <1361990705.8172.12.camel@jlt4.sipsolutions.net> (sfid-20130227_194525_266025_C7D59EDF)
Subject: Re: [PATCH 1/2] [RFC] cfg80211: configuration of Bluetooth
 coexistence mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Felix Fietkau <nbd@openwrt.org>, Adrian Chadd <adrian@freebsd.org>,
	Arend Van Spriel <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Piotr Haber <phaber@broadcom.com>
Date: Wed, 27 Feb 2013 19:45:05 +0100
In-Reply-To: <1361960826.15573.8.camel@dcbw.foobar.com>
References: <A47087626F2942499CF47E79803E771E0431B792@SJEXCHMB13.corp.ad.broadcom.com>
	 <1361564916.3420.11.camel@jlt4.sipsolutions.net>
	 <CAJ-VmokSn-jo9oFm4Udhf=T+HXM2N4g=Ckc-=NQEOKL=j=w5NA@mail.gmail.com>
	 <A47087626F2942499CF47E79803E771E0431BD3C@SJEXCHMB13.corp.ad.broadcom.com>
	 <1361726886.8129.9.camel@jlt4.sipsolutions.net>
	 <CAJ-Vmo=z+zbCfjMPXT4edyrB9Ukz0-ChE_Q1sqU_=6m_btx_Hg@mail.gmail.com>
	 <512AFC80.9030808@openwrt.org>
	 <1361787911.8887.2.camel@jlt4.sipsolutions.net>
	 <512B61F9.60802@openwrt.org> <1361960826.15573.8.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-27 at 11:27 +0100, Dan Williams wrote:
> 
> We also don't know what IP configuration method will get used; whether
> it will be IPv6 RA, DHCPv4 or DHCPv6, IPv4 autoconf, or static.  Only
> the connection manager knows that.  Only the connection manager/DHCP
> client know when they expect a lease renew operation to start too.
> wpa_supplicant doesn't know any of these things either since it doesn't
> do anything IP related.

Right, and if it's static you don't want any of this. I don't think
network latency stuff is a good method, even though on the face of it
the idea here is to reduce the initial connection latency.

> I think the best approach here is to allow the higher layers to hint to
> the driver that some operations that are about to start must be "more
> reliable".  That includes EAPOL, DHCP, IP autoconfiguration, etc.  Then
> when the higher layers know the operation is finished, they can indicate
> the operations are done and the driver can go do whatever it wants.

Yeah, I agree.

Note that it's less about being "more reliable" and more about being
"fast" (for some definition of that), in particular in the multi-channel
scenario you'd want to attempt to not switch away from the channel (if
possible) until DHCP finishes, or at least give it a chance to finish
quickly. But for example for static IP configuration you don't need to
and don't necessarily want to block being on that channel just in case
DHCP happens. Similarly with BT Coex of course, though there I guess
it's more about priority.

In any case it's about completing the connection to the network quickly
before being forced to go to powersave. In particular IPv6 might also
require multicast so doing powersave there really hurts (DTIM beacon.)

> The driver/stack may wish to do any of [set 1Mb rate, block rate
> control, change BT coex, turn on microwave protection, whatever] and
> that's great, the upper layers don't care about what the driver does,
> just that the reliability of the operation is preserved.

I'd say "reliability of the operation is _increased_" I guess :-) But
yeah.

johannes

