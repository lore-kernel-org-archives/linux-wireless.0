Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx-relay02-dus.antispameurope.com ([94.100.134.202]:42109 "EHLO
	mx-relay02-dus.antispameurope.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753700AbaBDNNr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Feb 2014 08:13:47 -0500
Message-ID: <52F0E771.8070904@fokus.fraunhofer.de> (sfid-20140204_141355_548993_3DD78975)
Date: Tue, 4 Feb 2014 14:13:21 +0100
From: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
MIME-Version: 1.0
To: Daniel Borkmann <dborkman@redhat.com>
CC: <netdev@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Jesper Dangaard Brouer <jbrouer@redhat.com>
Subject: Re: linux-3.14-rc1 & PACKET_QDISC_BYPASS : slow_path warning
References: <52F01C97.20001@fokus.fraunhofer.de> <52F0E361.9000304@redhat.com>
In-Reply-To: <52F0E361.9000304@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

On 02/04/2014 01:56 PM, Daniel Borkmann wrote:
> Hi Mathias, [cc'ing Felix]
>
> On 02/03/2014 11:47 PM, Mathias Kretschmer wrote:
>> Hi Daniel,
>>
>> we are developing a wired/wireless MPLS switch. Currently the data plane runs in
>> user space using PF_PACKET sockets via RX_RING/TX_RING.
>>
>> We had hoped to test the PACKET_QDISC_BYPASS option since this seems to be the
>> proper optimization for our purposes.
>>
>> Unfortunately, we're seeing a 'slow path' warning for every packet that is being
>> sent out. With PACKET_QDISC_BYPASS disabled, no warnings are dumped. Hardware is
>> an older AMD Geode LX embedded board (ALiX).
>>
>> BTW, this happens while sending via a wireless (802.11) adhoc interface. Hence, it
>> might be an interaction with the ieee80211 sub system.
>
> Hm, so the WARN_ON() is triggered inside ath9k driver in relation to 802.11 QoS,
> and came in from commit 066dae93bdf ("ath9k: rework tx queue selection and fix
> queue stopping/waking"). We did the stress testing of that option for PF_PACKET
> on 10Gbit/s NICs. Seems to me you might be running into the same issue when using
> pktgen as it randomly or per round-robin selects tx queues as well? Not entirely
> sure how necessary this WARN_ON() is though, Felix? I think QDISC_BYPASS might not
> be the best option in your case, perhaps you will run into increased power usage
> in your NIC as a side-effect?

I'm not familiar with the exact implementation details, but from the description of 
this option, it seems to me that this is exactly what one would want to use if the 
goal is to send an Ethernet frame out on a particular interface without any further 
processing by the kernel.

Why would this increase the power usage on the NIC ?  Due to a higher achievable 
packet rate ?  That would be acceptable :)

Cheers,

Mathias


> Cheers,
>
> Daniel

