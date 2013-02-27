Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2474 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932182Ab3B0RpG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2013 12:45:06 -0500
Message-ID: <512E4612.2050106@broadcom.com> (sfid-20130227_184512_480301_AE699EEF)
Date: Wed, 27 Feb 2013 18:44:50 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Dan Williams" <dcbw@redhat.com>
cc: "Felix Fietkau" <nbd@openwrt.org>,
	"Johannes Berg" <johannes@sipsolutions.net>,
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
 <512B61F9.60802@openwrt.org> <1361960826.15573.8.camel@dcbw.foobar.com>
In-Reply-To: <1361960826.15573.8.camel@dcbw.foobar.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/27/13 11:27, Dan Williams wrote:
> On Mon, 2013-02-25 at 14:07 +0100, Felix Fietkau wrote:
>> On 2013-02-25 11:25 AM, Johannes Berg wrote:
>>> On Mon, 2013-02-25 at 06:54 +0100, Felix Fietkau wrote:
>>>
>>>> Most devices have some kind of connection manager that has a high-level
>>>> perspective of when it's fully connected (which includes DHCP/bootp).
>>>> Why not just let that connection manager set a sane maximum network
>>>> latency value via pm_qos network_latency and derive btcoex weight
>>>> changing and multi-channel settings from that?
>>>
>>> Frankly, I don't think that's going to work well. We tried using the
>>> pm_qos framework once and nothing ever used it. Android isn't going to
>>> change to it, so we'd be stuck with hacks like setting pm_qos in
>>> wpa_supplicant which is just as awkward.
>> If only the connection manager gets changed to use it, that would
>> already be enough. It doesn't have to be pushed into dhcp clients and
>> other applications.
>>
>>> Also, what you mostly want isn't really so much a weight but rather a
>>> time-based approach to give it high priority until the connection
>>> handshake completes (we already do for auth/assoc/... until authorized)
>>> so I think using the pm_qos framework to give priority wouldn't work
>>> very well since there'd also be no way to tell when it was "done"
>> Just release the latency requirement in the connection manager once the
>> handshake is done. It knows...
>
> We also don't know what IP configuration method will get used; whether
> it will be IPv6 RA, DHCPv4 or DHCPv6, IPv4 autoconf, or static.  Only
> the connection manager knows that.  Only the connection manager/DHCP
> client know when they expect a lease renew operation to start too.
> wpa_supplicant doesn't know any of these things either since it doesn't
> do anything IP related.
>
> I think the best approach here is to allow the higher layers to hint to
> the driver that some operations that are about to start must be "more
> reliable".  That includes EAPOL, DHCP, IP autoconfiguration, etc.  Then
> when the higher layers know the operation is finished, they can indicate
> the operations are done and the driver can go do whatever it wants.

Indeed the RFC approach was explicit about the scope of this interface 
being BT coex or actually BT coex override. Johannes proposes one 
dedicated to DHCP as a similar interface in Android is used for that 
right now. Abstracting it to "more reliable" mainly avoids renaming it 
when someone comes up with a use-case other than BT coex or DHCP.

> The driver/stack may wish to do any of [set 1Mb rate, block rate
> control, change BT coex, turn on microwave protection, whatever] and
> that's great, the upper layers don't care about what the driver does,
> just that the reliability of the operation is preserved.

It is actually the reliability of the connection, but it may depend on 
what you mean by "operation" here. I think from user-space perpective 
this API is at most a notification to the driver, which *may* result in 
a more reliable protocol exchange in terms of reliability and/or latency.

Regards,
Arend

