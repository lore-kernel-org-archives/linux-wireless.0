Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547Ab3B0K1Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2013 05:27:16 -0500
Message-ID: <1361960826.15573.8.camel@dcbw.foobar.com> (sfid-20130227_112720_508732_DB93DCCE)
Subject: Re: [PATCH 1/2] [RFC] cfg80211: configuration of Bluetooth
 coexistence mode
From: Dan Williams <dcbw@redhat.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Adrian Chadd <adrian@freebsd.org>,
	Arend Van Spriel <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Piotr Haber <phaber@broadcom.com>
Date: Wed, 27 Feb 2013 11:27:06 +0100
In-Reply-To: <512B61F9.60802@openwrt.org>
References: <A47087626F2942499CF47E79803E771E0431B792@SJEXCHMB13.corp.ad.broadcom.com>
	  <1361564916.3420.11.camel@jlt4.sipsolutions.net>
	  <CAJ-VmokSn-jo9oFm4Udhf=T+HXM2N4g=Ckc-=NQEOKL=j=w5NA@mail.gmail.com>
	  <A47087626F2942499CF47E79803E771E0431BD3C@SJEXCHMB13.corp.ad.broadcom.com>
	  <1361726886.8129.9.camel@jlt4.sipsolutions.net>
	  <CAJ-Vmo=z+zbCfjMPXT4edyrB9Ukz0-ChE_Q1sqU_=6m_btx_Hg@mail.gmail.com>
	  <512AFC80.9030808@openwrt.org>
	 <1361787911.8887.2.camel@jlt4.sipsolutions.net>
	 <512B61F9.60802@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-25 at 14:07 +0100, Felix Fietkau wrote:
> On 2013-02-25 11:25 AM, Johannes Berg wrote:
> > On Mon, 2013-02-25 at 06:54 +0100, Felix Fietkau wrote:
> > 
> >> Most devices have some kind of connection manager that has a high-level
> >> perspective of when it's fully connected (which includes DHCP/bootp).
> >> Why not just let that connection manager set a sane maximum network
> >> latency value via pm_qos network_latency and derive btcoex weight
> >> changing and multi-channel settings from that?
> > 
> > Frankly, I don't think that's going to work well. We tried using the
> > pm_qos framework once and nothing ever used it. Android isn't going to
> > change to it, so we'd be stuck with hacks like setting pm_qos in
> > wpa_supplicant which is just as awkward.
> If only the connection manager gets changed to use it, that would
> already be enough. It doesn't have to be pushed into dhcp clients and
> other applications.
> 
> > Also, what you mostly want isn't really so much a weight but rather a
> > time-based approach to give it high priority until the connection
> > handshake completes (we already do for auth/assoc/... until authorized)
> > so I think using the pm_qos framework to give priority wouldn't work
> > very well since there'd also be no way to tell when it was "done"
> Just release the latency requirement in the connection manager once the
> handshake is done. It knows...

We also don't know what IP configuration method will get used; whether
it will be IPv6 RA, DHCPv4 or DHCPv6, IPv4 autoconf, or static.  Only
the connection manager knows that.  Only the connection manager/DHCP
client know when they expect a lease renew operation to start too.
wpa_supplicant doesn't know any of these things either since it doesn't
do anything IP related.

I think the best approach here is to allow the higher layers to hint to
the driver that some operations that are about to start must be "more
reliable".  That includes EAPOL, DHCP, IP autoconfiguration, etc.  Then
when the higher layers know the operation is finished, they can indicate
the operations are done and the driver can go do whatever it wants.

The driver/stack may wish to do any of [set 1Mb rate, block rate
control, change BT coex, turn on microwave protection, whatever] and
that's great, the upper layers don't care about what the driver does,
just that the reliability of the operation is preserved.

Dan

