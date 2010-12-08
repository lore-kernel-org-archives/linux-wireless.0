Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:17517 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751557Ab0LHIHe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 03:07:34 -0500
Received: from vs3003.wh2.ocn.ne.jp (125.206.180.231)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0828135646
	for <linux-wireless@vger.kernel.org>; Wed,  8 Dec 2010 17:07:28 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Jonathan Guerin <jonathan@guerin.id.au>
Subject: Re: [ath5k-devel] ath5k: Weird Retransmission Behaviour
Date: Wed, 8 Dec 2010 17:06:54 +0900
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	"ath5k-devel" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	bjorn.smedman@venatech.se, nbd@openwrt.org
References: <AANLkTimDF3kofO=kiuOsz+WrTGROdOL8-3eNvKd5NrD3@mail.gmail.com> <AANLkTiky-Q6DLxXSKf-+UU6avpaVikRgtt5078+Ui7Uh@mail.gmail.com> <AANLkTimS03cqqG8TCN1MTGF0DRQ51hrFkSPrbah2Z4gO@mail.gmail.com>
In-Reply-To: <AANLkTimS03cqqG8TCN1MTGF0DRQ51hrFkSPrbah2Z4gO@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012081706.54459.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > When ath5k doesn't get retry limits from above it uses the following
> > defaults on dcu.
> > For now i don't think we use local->hw.conf.short_frame_max_tx_count
> > for that so the
> > default is ah_limit_tx_retries (AR5K_INIT_TX_RETRY) but seems it's
> > wrong and we should
> > fix it...
> > 
> > /* Tx retry limits */
> > #define AR5K_INIT_SH_RETRY                      10
> > #define AR5K_INIT_LG_RETRY                      AR5K_INIT_SH_RETRY
> > /* For station mode */
> > #define AR5K_INIT_SSH_RETRY                     32
> > #define AR5K_INIT_SLG_RETRY                     AR5K_INIT_SSH_RETRY
> > #define AR5K_INIT_TX_RETRY                      10

I just sent a patch cleaning up this mess. Could you please check it? 
Unfortunately i didn't find way to really test re-transmissions, yet. 
Jonathan, could you give it a try in your test setup with my patch, and play 
with the numbers (just hardcode them in ath5k_hw_set_tx_retry_limits) to see 
if they actually have an effect?

As noted in my patch, this does not change the high number of retries we get 
from the rate control. That's a separate issue.

bruno
