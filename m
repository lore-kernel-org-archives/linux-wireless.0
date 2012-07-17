Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:38204 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365Ab2GQLyg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2012 07:54:36 -0400
Message-ID: <50055276.20304@openwrt.org> (sfid-20120717_135443_122414_34BB4E83)
Date: Tue, 17 Jul 2012 13:54:30 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH v2 08/12] ath9k: fix aggregate size limit based on queue
 TXOP limit
References: <1342105451-42297-1-git-send-email-nbd@openwrt.org> <1342105451-42297-2-git-send-email-nbd@openwrt.org> <1342105451-42297-3-git-send-email-nbd@openwrt.org> <1342105451-42297-4-git-send-email-nbd@openwrt.org> <1342105451-42297-5-git-send-email-nbd@openwrt.org> <1342105451-42297-6-git-send-email-nbd@openwrt.org> <1342105451-42297-7-git-send-email-nbd@openwrt.org> <1342105451-42297-8-git-send-email-nbd@openwrt.org> <20481.3065.540576.366365@gargle.gargle.HOWL> <500143CA.1020804@openwrt.org> <506697F5827BD842B7CB80D046EBE618995399@aphydexd01b> <5002A7B2.409@openwrt.org> <20483.52640.521243.418804@gargle.gargle.HOWL> <5003EABD.5040506@openwrt.org> <20484.23881.582002.607413@gargle.gargle.HOWL> <50046A71.9020302@openwrt.org> <20485.19956.285571.372831@gargle.gargle.HOWL>
In-Reply-To: <20485.19956.285571.372831@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-07-17 1:35 PM, Sujith Manoharan wrote:
> Felix Fietkau wrote:
>> The way I understand this, the TXOP limit is meant to limit the duration
>> of a single transmission on the channel. An aggregate is transmitted in
>> one go, there's no SIFS or extra PHY headers inbetween, just short
>> delimiters. So an A-MPDU should be treated pretty much like an MPDU
>> here, its transmission duration should not exceed the TXOP limit.
> 
> Yeah, makes sense.
> 
> But we need to handle multiple interfaces, otherwise this would break
> modes like P2P. For example, bring up a P2P-GO and setup a HT20 network,
> and then bring up a new station interface - this would unconditionally
> update the aggr. limits of the existing network. This wasn't the case earlier
> since the limits were being maintained globally and were common to all interfaces
> and addition/removal of new interfaces would not change the aggr. limits.
Before my patch, the aggr limits were always broken for the VI queue.
Now they're just sometimes broken :)

- Felix
