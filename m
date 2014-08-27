Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:10126 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933348AbaH0KkZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2014 06:40:25 -0400
Date: Wed, 27 Aug 2014 13:40:07 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Sujith Manoharan <sujith@msujith.org>
CC: Felix Fietkau <nbd@openwrt.org>,
	John Linville <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>
Subject: Re: [PATCH 1/4] ath9k: Fix channel context transition
Message-ID: <20140827104007.GA4242@jouni.qca.qualcomm.com> (sfid-20140827_124029_145501_9837DB39)
References: <1409121445-11484-1-git-send-email-sujith@msujith.org>
 <1409121445-11484-2-git-send-email-sujith@msujith.org>
 <53FD990F.8050606@openwrt.org>
 <21501.43772.648788.951689@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <21501.43772.648788.951689@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 27, 2014 at 03:25:08PM +0530, Sujith Manoharan wrote:
> Felix Fietkau wrote:
> > That does not make much sense to me. Why would you not inform the AP and
> > instead let it start buffering until the next beacon period?
> 
> Is it correct to send a nullfunc to the AP with PM=0 when there is no
> buffered traffic and the TIM doesn't indicate anything for the station's AID ?
> This was the concern raised.

You can send as many nullfunc Data frames as you want and pretty much
whenever you want.. If the AP has information indicating that the STA is
in power save mode, this frame needs to be sent. If the AP doesn't have
such information or the STA does not know what the state is, this frame
can still be sent. I would skip this only if the STA is reasonably
certain the AP does not have it recorded to be in power save mode.

In addition to power save management, nullfunc frames can be used for
number of other purposes, e.g., to check that the association is valid
and to trigger operations (well, that is related to power save). In any
case, there are no rules (other than normal Data frame rules) that
somehow limit the STA from sending this frame.

-- 
Jouni Malinen                                            PGP id EFC895FA
