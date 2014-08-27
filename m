Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:46317 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872AbaH0Iio (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2014 04:38:44 -0400
Message-ID: <53FD990F.8050606@openwrt.org> (sfid-20140827_103849_337883_F2A7420E)
Date: Wed, 27 Aug 2014 10:38:39 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>,
	John Linville <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: Re: [PATCH 1/4] ath9k: Fix channel context transition
References: <1409121445-11484-1-git-send-email-sujith@msujith.org> <1409121445-11484-2-git-send-email-sujith@msujith.org>
In-Reply-To: <1409121445-11484-2-git-send-email-sujith@msujith.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-08-27 08:37, Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> In channel context mode, a nullfunc is sent with
> the PM bit enabled when we switch to a new channel
> context from the current one. But, when the scheduler
> switches back to the old context, sending a nullfunc
> with PM bit cleared has to be done only if there is
> buffered traffic at the AP.
> 
> Currently, this is not done and a nullfunc is sent
> for every transition. Fix this by parsing the TIM IE
> for a received beacon and checking if there is buffered
> traffic.
That does not make much sense to me. Why would you not inform the AP and
instead let it start buffering until the next beacon period?

- Felix
