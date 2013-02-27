Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2391 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755428Ab3B0RWx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2013 12:22:53 -0500
Message-ID: <512E40B7.7080503@broadcom.com> (sfid-20130227_182256_765386_D38A57C1)
Date: Wed, 27 Feb 2013 18:21:59 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Felix Fietkau" <nbd@openwrt.org>
cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Adrian Chadd" <adrian@freebsd.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Piotr Haber" <phaber@broadcom.com>
Subject: Re: [PATCH 1/2] [RFC] cfg80211: configuration of Bluetooth
 coexistence mode
References: <A47087626F2942499CF47E79803E771E0431B792@SJEXCHMB13.corp.ad.broadcom.com>
 <1361564916.3420.11.camel@jlt4.sipsolutions.net>
 <CAJ-VmokSn-jo9oFm4Udhf=T+HXM2N4g=Ckc-=NQEOKL=j=w5NA@mail.gmail.com>
 <A47087626F2942499CF47E79803E771E0431BD3C@SJEXCHMB13.corp.ad.broadcom.com>
 <1361726886.8129.9.camel@jlt4.sipsolutions.net>
 <CAJ-Vmo=z+zbCfjMPXT4edyrB9Ukz0-ChE_Q1sqU_=6m_btx_Hg@mail.gmail.com>
 <512AFC80.9030808@openwrt.org>
 <1361787911.8887.2.camel@jlt4.sipsolutions.net>
 <512B61F9.60802@openwrt.org>
In-Reply-To: <512B61F9.60802@openwrt.org>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/25/13 14:07, Felix Fietkau wrote:
> On 2013-02-25 11:25 AM, Johannes Berg wrote:
>> On Mon, 2013-02-25 at 06:54 +0100, Felix Fietkau wrote:
>>
>>> Most devices have some kind of connection manager that has a high-level
>>> perspective of when it's fully connected (which includes DHCP/bootp).
>>> Why not just let that connection manager set a sane maximum network
>>> latency value via pm_qos network_latency and derive btcoex weight
>>> changing and multi-channel settings from that?
>>
>> Frankly, I don't think that's going to work well. We tried using the
>> pm_qos framework once and nothing ever used it. Android isn't going to
>> change to it, so we'd be stuck with hacks like setting pm_qos in
>> wpa_supplicant which is just as awkward.
> If only the connection manager gets changed to use it, that would
> already be enough. It doesn't have to be pushed into dhcp clients and
> other applications.

Reading back some slides about pm_qos it (from Intel OSTC ;-) ) seems to 
be intended to make kernel drivers aware of performance requirements in 
other kernel parts or user-space. Sounds like a match here although it 
is a one-to-many notification framework. Also not exactly what we want 
(I think).

Gr. AvS

