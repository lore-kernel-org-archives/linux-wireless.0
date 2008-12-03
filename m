Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:45742 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754043AbYLCExa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 23:53:30 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2008 20:53:30 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18742.4112.665927.756930@gargle.gargle.HOWL> (sfid-20081203_055339_377399_D889216E)
Date: Wed, 3 Dec 2008 10:20:24 +0530
To: Luis Rodriguez <lrodriguez@atheros.com>
CC: Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [ath9k-devel] [PATCH v2 2/2] ath9k: Use GFP_ATOMIC when
 allocating TX private area
In-Reply-To: <43e72e890812022012o7759400mf002f51c0a3f0eb@mail.gmail.com>
References: <1228274124-25140-1-git-send-email-lrodriguez@atheros.com>
	<1228274124-25140-2-git-send-email-lrodriguez@atheros.com>
	<1228274124-25140-3-git-send-email-lrodriguez@atheros.com>
	<18742.299.281327.259785@localhost.localdomain>
	<43e72e890812022012o7759400mf002f51c0a3f0eb@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis Rodriguez wrote:
> ath_test_get_txq() will not return the queue only if the queue is
> getting full. What the check above guarantees is we have at least one
> buffer to run through procesq before disabling the TX queue, otherwise
> the queue won't be be woken up. Or am I missing something? That is,
> say you just have to TX one skb and we hit -ENOMEM on
> ath_tx_setup_buffer() and you disable the queue. How will this queue
> be awoken if this is true in ath_tx_processq():
> 
> list_empty(&txq->axq_q)

Ok, makes sense.
But the queue can be obtained from txctl, so that code can be removed.

Sujith
