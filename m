Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39256 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036Ab2GPKTt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jul 2012 06:19:49 -0400
Message-ID: <5003EABD.5040506@openwrt.org> (sfid-20120716_122005_215460_1F3EC266)
Date: Mon, 16 Jul 2012 12:19:41 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH v2 08/12] ath9k: fix aggregate size limit based on queue
 TXOP limit
References: <1342105451-42297-1-git-send-email-nbd@openwrt.org> <1342105451-42297-2-git-send-email-nbd@openwrt.org> <1342105451-42297-3-git-send-email-nbd@openwrt.org> <1342105451-42297-4-git-send-email-nbd@openwrt.org> <1342105451-42297-5-git-send-email-nbd@openwrt.org> <1342105451-42297-6-git-send-email-nbd@openwrt.org> <1342105451-42297-7-git-send-email-nbd@openwrt.org> <1342105451-42297-8-git-send-email-nbd@openwrt.org> <20481.3065.540576.366365@gargle.gargle.HOWL> <500143CA.1020804@openwrt.org> <506697F5827BD842B7CB80D046EBE618995399@aphydexd01b> <5002A7B2.409@openwrt.org> <20483.52640.521243.418804@gargle.gargle.HOWL>
In-Reply-To: <20483.52640.521243.418804@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-07-16 10:15 AM, Sujith Manoharan wrote:
> Felix Fietkau wrote:
>> Yes, but ath9k only has global queue settings, not per-vif ones, so I'm
>> not sure what can be done about the issue of overwriting queue settings.
> 
> Yeah, me neither.
> 
>> Either way, it's important for the aggregation limit to be in sync with
>> the hardware queue TXOP limit, so I believe this patch is correct.
> 
> Except that earlier it was a global, static table. I am curious, which part
> of the standard deals with limiting AMPDU size based on txop ? I searched a bit
> and got lost.
The standard does not say anything specifically about A-MPDU, but it
does say this:

When the TXOP limit is nonzero, a STA shall fragment an individually
addressed MSDU so that the transmission of the first MPDU of the TXOP
does not cause the TXOP limit to be exceeded at the PHY rate selected
for the initial transmission attempt of that MPDU. The TXOP limit may be
exceeded, when using a lower PHY rate than selected for the initial
transmission attempt of the first MPDU, for a retransmission of an MPDU,
for the initial transmission of an MPDU if any previous MPDU in the
current MSDU has been retransmitted, or for group addressed MSDUs. When
the TXOP limit is exceeded due to the retransmission of an MPDU at a
reduced PHY rate, the STA shall not transmit more than one MPDU in the TXOP.

Since 3 ms for VI (default) is still a lot and this queue is meant to
have lower latency compared to BE/BK, I decided to not add any special
rules to treat retransmissions differently.
I'm not sure if it's absolutely required to reduce the A-MPDU
transmission duration here, but even if it isn't, it's still a good idea
for reducing latency, and it does look like it reduces the amount of
retransmissions under load.

The only other queue that has a TXOP limit set by default is the VO
queue, but that one can be ignored since it doesn't do aggregation.

- Felix
