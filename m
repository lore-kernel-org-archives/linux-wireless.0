Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2747 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382Ab0AIDmN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2010 22:42:13 -0500
Date: Fri, 8 Jan 2010 22:41:32 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Fabio Rossi <rossi.f@inwind.it>
Cc: linux-wireless@vger.kernel.org,
	Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
	ath5k-devel@lists.ath5k.org
Subject: Re: ath5k: 2.6.32-rc6 "no further txbuf available, dropping packet"
Message-ID: <20100109034132.GA18279@hash.localnet>
References: <4AF99EF9.4040408@nets.rwth-aachen.de> <b6c5339f0911102013k20d927d3mc021d25bf6703303@mail.gmail.com> <201001082334.16066.rossi.f@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201001082334.16066.rossi.f@inwind.it>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 08, 2010 at 11:34:16PM +0100, Fabio Rossi wrote:
> Hi Bob,
> I have tried your patch as I get many errors as in subject when I transfer 
> huge files (I'm using as a test a 1GB file). With the patch I have the same 
> errors.
> 
> I'm using wireless-testing.git (v2.6.33-rc2-47131-gc72a18c) in managed mode 
> (no AP).

Ok, well the patch only will affect AP mode -- it addresses a bug where
multicast AP frames are queued but not always processed.  I wonder if your
workload is just filling up the queues and then the queues are awakened
prematurely.  There's a check in ath5k_tx_processq to only re-enable the
queue when there are 40 tx buffers left, but there are a few other paths
that re-enable the queues -- also accounting on txbuf_len could theoretically
get broken.

Maybe a printk in ath5k_tx_queue of sc->txbuf_len caN show how many buffers
are typically available when entering?

-- 
Bob Copeland %% www.bobcopeland.com

