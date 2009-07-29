Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f196.google.com ([209.85.221.196]:45590 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021AbZG2UaX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 16:30:23 -0400
Received: by qyk34 with SMTP id 34so256181qyk.33
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2009 13:30:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <40f31dec0907291306q7e19c9fdib7e9a6dcab89ac21@mail.gmail.com>
References: <1248877744-7273-1-git-send-email-me@bobcopeland.com>
	 <1248877744-7273-2-git-send-email-me@bobcopeland.com>
	 <40f31dec0907291306q7e19c9fdib7e9a6dcab89ac21@mail.gmail.com>
Date: Wed, 29 Jul 2009 16:30:22 -0400
Message-ID: <b6c5339f0907291330r11b3b2dbg8ff8833a955021b8@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 2/2] ath5k: fix CAB queue operation
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	linville@tuxdriver.com, jirislaby@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 29, 2009 at 4:06 PM, Nick Kossifidis<mickflemm@gmail.com> wrote:
> 2009/7/29 Bob Copeland <me@bobcopeland.com>:

> I think we are doing the wrong thing, CAB queue is supposed to fire
> after beacon queue. Ath9k fires up cab queue and beacon queue at the
> same time and uses ready time to hold cab queue for a fixed interval.
> Try to remove the readytime stuff from cab queue and i guess it'll
> work fine (now we fire it after the beacon queue AND wait for a beacon
> transmition period).

Yeah I was getting almost no delivery of buffered frames without that
change, but I didn't check the delivery time to see if they were too
late, which they probably are.

So you are saying keep BCN_SENT_GT, but remove this:

	ath5k_hw_reg_write(ah, ((AR5K_TUNE_BEACON_INTERVAL -
		(AR5K_TUNE_SW_BEACON_RESP -
		AR5K_TUNE_DMA_BEACON_RESP) -
		AR5K_TUNE_ADDITIONAL_SWBA_BACKOFF) * 1024) |
		AR5K_QCU_RDYTIMECFG_ENABLE,
		AR5K_QUEUE_RDYTIMECFG(queue));

I'll give it ago.  Maybe split that part out because the process tx
queue fix is obvious enough.

(Now I see that the similar-to-above-stuff from madwifi is only compat
code and also uses a readyTime like ath9k.  Ah.)

-- 
Bob Copeland %% www.bobcopeland.com
