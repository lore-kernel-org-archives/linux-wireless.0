Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57345 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758279Ab3BYNHL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 08:07:11 -0500
Message-ID: <512B61F9.60802@openwrt.org> (sfid-20130225_140716_013824_F18A300F)
Date: Mon, 25 Feb 2013 14:07:05 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Adrian Chadd <adrian@freebsd.org>,
	Arend Van Spriel <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Piotr Haber <phaber@broadcom.com>
Subject: Re: [PATCH 1/2] [RFC] cfg80211: configuration of Bluetooth coexistence
 mode
References: <A47087626F2942499CF47E79803E771E0431B792@SJEXCHMB13.corp.ad.broadcom.com>  <1361564916.3420.11.camel@jlt4.sipsolutions.net>  <CAJ-VmokSn-jo9oFm4Udhf=T+HXM2N4g=Ckc-=NQEOKL=j=w5NA@mail.gmail.com>  <A47087626F2942499CF47E79803E771E0431BD3C@SJEXCHMB13.corp.ad.broadcom.com>  <1361726886.8129.9.camel@jlt4.sipsolutions.net>  <CAJ-Vmo=z+zbCfjMPXT4edyrB9Ukz0-ChE_Q1sqU_=6m_btx_Hg@mail.gmail.com>  <512AFC80.9030808@openwrt.org> <1361787911.8887.2.camel@jlt4.sipsolutions.net>
In-Reply-To: <1361787911.8887.2.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-02-25 11:25 AM, Johannes Berg wrote:
> On Mon, 2013-02-25 at 06:54 +0100, Felix Fietkau wrote:
> 
>> Most devices have some kind of connection manager that has a high-level
>> perspective of when it's fully connected (which includes DHCP/bootp).
>> Why not just let that connection manager set a sane maximum network
>> latency value via pm_qos network_latency and derive btcoex weight
>> changing and multi-channel settings from that?
> 
> Frankly, I don't think that's going to work well. We tried using the
> pm_qos framework once and nothing ever used it. Android isn't going to
> change to it, so we'd be stuck with hacks like setting pm_qos in
> wpa_supplicant which is just as awkward.
If only the connection manager gets changed to use it, that would
already be enough. It doesn't have to be pushed into dhcp clients and
other applications.

> Also, what you mostly want isn't really so much a weight but rather a
> time-based approach to give it high priority until the connection
> handshake completes (we already do for auth/assoc/... until authorized)
> so I think using the pm_qos framework to give priority wouldn't work
> very well since there'd also be no way to tell when it was "done"
Just release the latency requirement in the connection manager once the
handshake is done. It knows...

- Felix

