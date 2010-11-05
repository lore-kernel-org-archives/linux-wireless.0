Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37332 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab0KELfI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Nov 2010 07:35:08 -0400
Received: by iwn41 with SMTP id 41so808045iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 05 Nov 2010 04:35:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CD2AC85.1090806@openwrt.org>
References: <4CD2AC85.1090806@openwrt.org>
Date: Fri, 5 Nov 2010 12:35:07 +0100
Message-ID: <AANLkTi=Qz1Px=wJBL+1TdsTN0EnJ0WOY_kf-XMNf=Vtp@mail.gmail.com>
Subject: Re: [PATCH] ath9k: rework tx queue selection and fix queue stopping/waking
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Ben Greear <greearb@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 4, 2010 at 1:52 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> The current ath9k tx queue handling code showed a few issues that could
> lead to locking issues, tx stalls due to stopped queues, and maybe even
> DMA issues.

Great looking patch. :)

> The main source of these issues is that in some places the queue is
> selected via skb queue mapping in places where this mapping may no
> longer be valid. One such place is when data frames are transmitted via
> the CAB queue (for powersave buffered frames). This is made even worse
> by a lookup WMM AC values from the assigned tx queue (which is
> undefined for the CAB queue).
>
> This messed up the pending frame counting, which in turn caused issues
> with queues getting stopped, but not woken again.

I took another look and isn't there one more way we can put the queue
to sleep forever: if the mac80211 queue is stopped and the ath9k txq
then drained for some reason. Could there be some other way skbs can
leave the tx pipeline without the mac80211 queue getting woken up
again?

> To fix these issues, this patch removes an unnecessary abstraction
> separating a driver internal queue number from the skb queue number
> (not to be confused with the hardware queue number).
>
> It seems that this abstraction may have been necessary because of tx
> queue preinitialization from the initvals. This patch avoids breakage
> here by pushing the software <-> hardware queue mapping to the function
> that assigns the tx queues and redefining the WMM AC definitions to
> match the numbers used by mac80211 (also affects ath9k_htc).

Good catch. :)

> To ensure consistency wrt. pending frame count tracking, these counters
> are moved to the ath_txq struct, updated with the txq lock held, but
> only where the tx queue selected by the skb queue map actually matches
> the tx queue used by the driver for the frame.

I was thinking. Now we check for counting imbalance in one direction
(down) and actually found something if I understand correctly. Would
it be possible to check the catastropic case as well, i.e. that we are
off in the upward direction so that pending_frames stays so high that
mac80211 queues lock up forever? Perhaps when we drain the txq or
unload the driver or something we could do a WARN_ON(pending_frames !=
0)?

/Björn
