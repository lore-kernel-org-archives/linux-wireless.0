Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:51432 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750744AbcFUKHe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2016 06:07:34 -0400
Date: Tue, 21 Jun 2016 12:41:46 +0300
From: Jouni Malinen <j@w1.fi>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org, Ben Greear <greearb@candelatech.com>
Subject: Re: [PATCH] ath9k: Support 4.9Ghz channels on AR9580 adapter.
Message-ID: <20160621094146.GA3196@w1.fi> (sfid-20160621_120742_285223_30B1B506)
References: <CAGRGNgWOScCrLPyqRNus2319BPOehv3awQChoHw=RRMcSDUqzQ@mail.gmail.com>
 <1466470940-25229-1-git-send-email-julian.calaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1466470940-25229-1-git-send-email-julian.calaby@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 21, 2016 at 11:02:20AM +1000, Julian Calaby wrote:
> I've only done this work as I hate to see people's efforts go to
> waste and I feel that there's enough roadblocks in the way of
> actually using this functionality that casual idiots won't be able
> to.

Are these really ready to go to the upstream kernel in this state and
without the other changes that would be needed to operate correctly?
What is the use case for these and how have these been tested?

> This is compile tested only as I cannot test this for real as I lack
> both the hardware and license required.

I don't think this is sufficient when touching this type of area. I
would not apply these without proper testing and full set of
functionality being available. I see no point in ath9k defining
additional channels if all those new channels can cause is harm and not
correct functionality. This channel list addition looks like the easiest
part to handle compared to the other patches needed for 4.9 GHz and this
would be the last patch on my list to get accepted..


> diff --git a/drivers/net/wireless/ath/ath9k/common-init.c b/drivers/net/wireless/ath/ath9k/common-init.c
> +#ifdef ATH9K_49_GHZ_CHAN
> +	/* 4.9Ghz channels, public safety channels, license is required in US
> +	 * and most other regulatory domains!
> +	 */
> +	CHAN5G(4915, 38), /* Channel 183 */
> +	CHAN5G(4920, 39), /* Channel 184 */
> +	CHAN5G(4925, 40), /* Channel 185 */
> +	CHAN5G(4935, 41), /* Channel 187 */
> +	CHAN5G(4940, 42), /* Channel 188 */
> +	CHAN5G(4945, 43), /* Channel 189 */
> +	CHAN5G(4960, 44), /* Channel 192 */
> +	CHAN5G(4970, 45), /* Channel 194 */
> +	CHAN5G(4980, 46), /* Channel 196 */

Where are these channels defined and are these really correct
frequencies for them? Please note that many of the 4.9 GHz channels have
channel starting frequencies like 4.9375 GHz and 4.0025 GHz, i.e.,
fractional MHz.. While US public safety may not have all those cases,
even there are some 0.5 MHz cases. In addition, those channel numbers
sound more like some of the channels defined in Japan rather than US
public safety operating class. In addition, some of these channels seem
to be outside the US public safety range.

Is this trying to add 4.9 GHz channels in general for multiple different
use cases? And if so, what are those use cases? Or is this only for some
public safety cases? And if so, for which regulatory domains?

To be frank, I really don't see how this would be even close to a state
that should be accepted into the upstream tree.

-- 
Jouni Malinen                                            PGP id EFC895FA
