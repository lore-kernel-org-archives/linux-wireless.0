Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40142 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714Ab3BYFyM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 00:54:12 -0500
Message-ID: <512AFC80.9030808@openwrt.org> (sfid-20130225_065415_873821_6D9EFFF2)
Date: Mon, 25 Feb 2013 06:54:08 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Arend Van Spriel <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Piotr Haber <phaber@broadcom.com>
Subject: Re: [PATCH 1/2] [RFC] cfg80211: configuration of Bluetooth coexistence
 mode
References: <A47087626F2942499CF47E79803E771E0431B792@SJEXCHMB13.corp.ad.broadcom.com> <1361564916.3420.11.camel@jlt4.sipsolutions.net> <CAJ-VmokSn-jo9oFm4Udhf=T+HXM2N4g=Ckc-=NQEOKL=j=w5NA@mail.gmail.com> <A47087626F2942499CF47E79803E771E0431BD3C@SJEXCHMB13.corp.ad.broadcom.com> <1361726886.8129.9.camel@jlt4.sipsolutions.net> <CAJ-Vmo=z+zbCfjMPXT4edyrB9Ukz0-ChE_Q1sqU_=6m_btx_Hg@mail.gmail.com>
In-Reply-To: <CAJ-Vmo=z+zbCfjMPXT4edyrB9Ukz0-ChE_Q1sqU_=6m_btx_Hg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-02-25 6:08 AM, Adrian Chadd wrote:
> On 24 February 2013 09:28, Johannes Berg <johannes@sipsolutions.net> wrote:
> 
>>> In the driver we could inspect each sk_buff and boost priority of any
>>> BOOTP packets so that it will end up in the AC_VO fifo and have
>>> hardware coexistence handle it further. I consider that more a
>>> pragmatic fix, which is not always the worst thing to go for.
>>
>> Well, I don't really think that's the best idea. Sniffing the protocol
>> is clumsy at best.
> 
> Sure, but it's the kind of thing that commercial devices do in order
> to work around real world issues.
Just because commercial devices do this crap to weasel out of fixing
things properly doesn't mean we have to do the same.

> So it'd be nice to have a programmatic way to detect things (eg bootp
> packets going out) and signal the driver via some side channel to do
> things like btcoex weight changing.
I disagree, that approach clumsy and fragile and it's trying to address
the issue in the wrong place.

Most devices have some kind of connection manager that has a high-level
perspective of when it's fully connected (which includes DHCP/bootp).
Why not just let that connection manager set a sane maximum network
latency value via pm_qos network_latency and derive btcoex weight
changing and multi-channel settings from that?

- Felix
