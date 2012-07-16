Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:46350 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746Ab2GPTYj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jul 2012 15:24:39 -0400
Message-ID: <50046A71.9020302@openwrt.org> (sfid-20120716_212442_471283_2A92AC1A)
Date: Mon, 16 Jul 2012 21:24:33 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH v2 08/12] ath9k: fix aggregate size limit based on queue
 TXOP limit
References: <1342105451-42297-1-git-send-email-nbd@openwrt.org> <1342105451-42297-2-git-send-email-nbd@openwrt.org> <1342105451-42297-3-git-send-email-nbd@openwrt.org> <1342105451-42297-4-git-send-email-nbd@openwrt.org> <1342105451-42297-5-git-send-email-nbd@openwrt.org> <1342105451-42297-6-git-send-email-nbd@openwrt.org> <1342105451-42297-7-git-send-email-nbd@openwrt.org> <1342105451-42297-8-git-send-email-nbd@openwrt.org> <20481.3065.540576.366365@gargle.gargle.HOWL> <500143CA.1020804@openwrt.org> <506697F5827BD842B7CB80D046EBE618995399@aphydexd01b> <5002A7B2.409@openwrt.org> <20483.52640.521243.418804@gargle.gargle.HOWL> <5003EABD.5040506@openwrt.org> <20484.23881.582002.607413@gargle.gargle.HOWL>
In-Reply-To: <20484.23881.582002.607413@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-07-16 8:28 PM, Sujith Manoharan wrote:
> Felix Fietkau wrote:
>> The standard does not say anything specifically about A-MPDU, but it
>> does say this:
>> 
>> When the TXOP limit is nonzero, a STA shall fragment an individually
>> addressed MSDU so that the transmission of the first MPDU of the TXOP
>> does not cause the TXOP limit to be exceeded at the PHY rate selected
>> for the initial transmission attempt of that MPDU. The TXOP limit may be
>> exceeded, when using a lower PHY rate than selected for the initial
>> transmission attempt of the first MPDU, for a retransmission of an MPDU,
>> for the initial transmission of an MPDU if any previous MPDU in the
>> current MSDU has been retransmitted, or for group addressed MSDUs. When
>> the TXOP limit is exceeded due to the retransmission of an MPDU at a
>> reduced PHY rate, the STA shall not transmit more than one MPDU in the TXOP.
> 
> Um, am not sure how this passage relates to number of subframe calculation in an
> aggregate ?
The way I understand this, the TXOP limit is meant to limit the duration
of a single transmission on the channel. An aggregate is transmitted in
one go, there's no SIFS or extra PHY headers inbetween, just short
delimiters. So an A-MPDU should be treated pretty much like an MPDU
here, its transmission duration should not exceed the TXOP limit.

- Felix
