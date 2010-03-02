Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:36070 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413Ab0CBOvN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 09:51:13 -0500
Message-ID: <4B8D25DC.8070502@openwrt.org>
Date: Tue, 02 Mar 2010 15:51:08 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Derek Smithies <derek@indranet.co.nz>,
	Benoit PAPILLAULT <benoit.papillault@free.fr>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC/RFT] minstrel_ht: new rate control module for 802.11n
References: <4B8C3A21.2050105@openwrt.org> <133e8d7e1003020419r6fab7b13kd77b06407c8c1380@mail.gmail.com>
In-Reply-To: <133e8d7e1003020419r6fab7b13kd77b06407c8c1380@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-03-02 1:19 PM, Björn Smedman wrote:
> Hi Felix,
> 
> First of all thanx for this new rate control algorithm!
> 
> One question about AMPDUs (which is not really specific to your code
> but anyway): How do you handle "software retries"?
> 
> At least ath9k seems to retry frames in serveral AMPDUs up to
> ATH_MAX_SW_RETRIES times within the driver (without notifying
> mac80211). First of all, is this your understanding as well?
Since the tx status information on A-MPDUs is imprecise either way, I
simply treat a full A-MPDU as a single frame at the moment. I did some
experiments with taking the exact number of frames into account, but it
didn't improve overall performance, so I removed the code for that again.

> If my understanding is correct then there are two problems as I see it:
> 
> 1) The rate control algorithm will get incorrect information about the
> transmission attempts. This could be corrected to some extent by
> correctly setting the count and idx tx_status fields taking software
> retries into account, but that interface is actually too thin to carry
> all the information since the frame may have been retried at many
> bitrates (more than 4). Also, the duration the radio has been busy
> transmitting the frame is impossible to derive because you do not know
> how many separate AMPDUs it has been transmitted in which makes a
> difference in contention window and inter frame space, etc.
Correct. I use a rough approximation, because not only is the interface
too thin to carry all the relevant information, also the hardware
doesn't even provide enough information to do any kind of precise
calculation on airtime utilization by tx attempts. For instance, I don't
get any information on how many frames in an A-MPDU were successfully
transmitted on each retransmission attempt.
Additionally, I intend to use this rate control algorithm on non-Atheros
hardware - and tx status feedback will be even more limited there.

> 2) The rate selection is suboptimal if software retries are not taken
> into account. The reason you want to use a high probability bitrate on
> the last few transmission attempts is that you want to avoid packet
> loss at (almost) any price. But if you can retry the frame in software
> it may be better to transmit only at spectrum efficient bitrates and
> use the receivers reorder buffer to avoid packet loss. This is IMHO
> one of the main advantages of the 802.11n MAC and something we should
> really try to take advantage of.
Software retries are being taken into account on some level, because a
software retry is simply going to be part of the next A-MPDU, which will
get accounted for in the rate control code.

This early version will probably not make a fully optimal tradeoff
between retransmission probability and raw throughput, but that can
probably be tweaked over time, simply by adjusting the internal
throughput metric calculation to something that gets close in practice
at least most of the time.

- Felix
