Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753897Ab1AUMwO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 07:52:14 -0500
Date: Fri, 21 Jan 2011 13:51:38 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Sujith <m.sujith@gmail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT] ath9k_htc: fix race conditions when stop device
Message-ID: <20110121135138.147697db@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <19769.24127.113716.558660@gargle.gargle.HOWL>
References: <20110121061204.GA3041@redhat.com>
	<19769.24127.113716.558660@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 21 Jan 2011 15:51:51 +0530
Sujith <m.sujith@gmail.com> wrote:

> Stanislaw Gruszka wrote:
> > Similar fix I already posted for ath9k. When stopping device, disable
> > interrupts, kill tasklets and then works, in correct order. Patch drop
> > mutex in them middle of a function, which I don't like and can possibly
> > not be correct. Perhaps this can be arranged differently. Also
> > there is no synchronize_irq, which IMHO should be added somewhere in
> > htc/wmi stop.
> 
> It should be okay if the work instances are canceled first before the mutex
> is acquired. 

IIRC, there is possibility to schedule priv->ps_work from ath9k_rx_tasklet (when
receive beacon frame and being in power save mode), so we should cancel that work
after assure tasklet will not be executed.

> And I don't think synchronize_irq() is required since this is a USB driver.
> 
> But when the driver is loaded and unloaded without bringing the interface up,
> stop() wouldn't be called at all, but I guess it's alright since no tasklet would
> have been scheduled. 

I assumed ath9k_htc_rxep() and ath9k_htc_txep() can not be called before _start()
(and after _stop() of course), hence removing tasklet_kill's from ath9k_deinit_priv()

> I tested with ath9k_htc and saw no issues.

Thanks!
Stanislaw
