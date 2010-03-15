Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:63619 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758870Ab0COHEn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Mar 2010 03:04:43 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 15 Mar 2010 00:04:43 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19357.57506.489965.182709@gargle.gargle.HOWL>
Date: Mon, 15 Mar 2010 12:54:18 +0530
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath9k: fix BUG_ON triggered by PAE frames
In-Reply-To: <4B99AED3.4000204@openwrt.org>
References: <4B99AED3.4000204@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> When I initially stumbled upon sequence number problems with PAE frames
> in ath9k, I submitted a patch to remove all special cases for PAE
> frames and let them go through the normal transmit path.
> Out of concern about crypto incompatibility issues, this change was
> merged instead:
> 
> commit 6c8afef551fef87a3bf24f8a74c69a7f2f72fc82
> Author: Sujith <Sujith.Manoharan@atheros.com>
> Date:   Tue Feb 9 10:07:00 2010 +0530
> 
>     ath9k: Fix sequence numbers for PAE frames
> 
> After a lot of testing, I'm able to reliably trigger a driver crash on
> rekeying with current versions with this change in place.
> It seems that the driver does not support sending out regular MPDUs with
> the same TID while an A-MPDU session is active.
> This leads to duplicate entries in the TID Tx buffer, which hits the
> following BUG_ON in ath_tx_addto_baw():
> 
>     index  = ATH_BA_INDEX(tid->seq_start, bf->bf_seqno);
>     cindex = (tid->baw_head + index) & (ATH_TID_MAX_BUFS - 1);
> 
>     BUG_ON(tid->tx_buf[cindex] != NULL);

I have seen this too, but am not sure if I was using encryption.
I have triggered this occasionally during a suspend/resume cycle.

> I believe until we actually have a reproducible case of an
> incompatibility with another AP using no PAE special cases, we should
> simply get rid of this mess.
> 
> This patch completely fixes my crash issues in STA mode and makes it
> stay connected without throughput drops or connectivity issues even
> when the AP is configured to a very short group rekey interval.
> 

Ok. We can remove this and see if any users report crupto problems
with random APs out there.

We did run into re-keying issues with a few APs when sending PAE
frames as part of aggregates, but unfortunately the bug reports seem
to be non-existent ...

Sujith
