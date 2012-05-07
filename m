Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62863 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab2EGMxa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 08:53:30 -0400
Received: by yenm10 with SMTP id m10so3581168yen.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 May 2012 05:53:30 -0700 (PDT)
Date: Mon, 7 May 2012 08:53:16 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 09/21] cw1200: txrx.*, implementation of datapath.
Message-ID: <20120507125316.GA25400@localhost> (sfid-20120507_145335_155304_CF4C2FEF)
References: <d53e019b1a0bcd29c2c367fbe5665413f2d33938-submit>
 <1330652495-25837-1-git-send-email-dmitry.tarnyagin@stericsson.com>
 <1330652495-25837-10-git-send-email-dmitry.tarnyagin@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1330652495-25837-10-git-send-email-dmitry.tarnyagin@stericsson.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dmitry,

A couple of other quick notes follow.  I'll make and send on those
other patches sometime this week as I get time.

On Fri, Mar 02, 2012 at 02:41:23AM +0100, Dmitry Tarnyagin wrote:
> +	/* minstrel is buggy a little bit, so distille
> +	 * incoming rates first. */

Can you elaborate a bit on the bugs?  It may be worth fixing them
in minstrel so that everyone benefits.  From your code it looks
like you want to reorder them from fastest->slowest, eliminate
duplicate rates, and change retry counts to respect total retry
limits.  I agree that the last two are problematic and should
probably be fixed in minstrel.

Changing the rate order may have adverse affects (I'm not sure).
Minstrel often puts 'probe' rates in early MRR slots to update
its statistics, these may well be lower than the current rate.

> +	/* Sort rates in descending order. */
> +	for (i = 1; i < count; ++i) {
> +		if (rates[i].idx < 0) {
> +			count = i;
> +			break;
> +		}
> +		if (rates[i].idx > rates[i - 1].idx) {
> +			struct ieee80211_tx_rate tmp = rates[i - 1];
> +			rates[i - 1] = rates[i];
> +			rates[i] = tmp;
> +		}
> +	}

This sort seems to be missing an inner loop.  E.g. if input was 2-3-5-4,
I think you would end up with 2-5-4-3 instead of 5-4-3-2.

> +		/* ">> 1" is an equivalent of "/ 2", but faster */
> +		int mid_rate = (rates[0].idx + 4) >> 1;

(This is true, but it's only by a couple of instructions for signed
division since compilers still change divide-by-power-of-two to shifts.
Unsigned /2 typically has the same code as >> 1.  I tend to prefer /2
for readability unless it's a super hot path, but that's your call.)

-- 
Bob Copeland %% www.bobcopeland.com
