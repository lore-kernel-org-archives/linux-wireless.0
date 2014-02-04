Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbaBDM4T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Feb 2014 07:56:19 -0500
Message-ID: <52F0E361.9000304@redhat.com> (sfid-20140204_135635_789227_76A8C165)
Date: Tue, 04 Feb 2014 13:56:01 +0100
From: Daniel Borkmann <dborkman@redhat.com>
MIME-Version: 1.0
To: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
CC: netdev@vger.kernel.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Jesper Dangaard Brouer <jbrouer@redhat.com>
Subject: Re: linux-3.14-rc1 & PACKET_QDISC_BYPASS : slow_path warning
References: <52F01C97.20001@fokus.fraunhofer.de>
In-Reply-To: <52F01C97.20001@fokus.fraunhofer.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mathias, [cc'ing Felix]

On 02/03/2014 11:47 PM, Mathias Kretschmer wrote:
> Hi Daniel,
>
> we are developing a wired/wireless MPLS switch. Currently the data plane runs in user space using PF_PACKET sockets via RX_RING/TX_RING.
>
> We had hoped to test the PACKET_QDISC_BYPASS option since this seems to be the proper optimization for our purposes.
>
> Unfortunately, we're seeing a 'slow path' warning for every packet that is being sent out. With PACKET_QDISC_BYPASS disabled, no warnings are dumped. Hardware is an older AMD Geode LX embedded board (ALiX).
>
> BTW, this happens while sending via a wireless (802.11) adhoc interface. Hence, it might be an interaction with the ieee80211 sub system.

Hm, so the WARN_ON() is triggered inside ath9k driver in relation to 802.11 QoS,
and came in from commit 066dae93bdf ("ath9k: rework tx queue selection and fix
queue stopping/waking"). We did the stress testing of that option for PF_PACKET
on 10Gbit/s NICs. Seems to me you might be running into the same issue when using
pktgen as it randomly or per round-robin selects tx queues as well? Not entirely
sure how necessary this WARN_ON() is though, Felix? I think QDISC_BYPASS might not
be the best option in your case, perhaps you will run into increased power usage
in your NIC as a side-effect?

Cheers,

Daniel
