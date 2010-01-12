Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out12.libero.it ([212.52.84.112]:56116 "EHLO
	cp-out12.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab0ALAWH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jan 2010 19:22:07 -0500
From: Fabio Rossi <rossi.f@inwind.it>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: ath5k: 2.6.32-rc6 "no further txbuf available, dropping packet"
Date: Tue, 12 Jan 2010 01:19:38 +0100
Cc: linux-wireless@vger.kernel.org,
	Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
	ath5k-devel@lists.ath5k.org
References: <4AF99EF9.4040408@nets.rwth-aachen.de> <201001082334.16066.rossi.f@inwind.it> <20100109034132.GA18279@hash.localnet>
In-Reply-To: <20100109034132.GA18279@hash.localnet>
MIME-Version: 1.0
Message-Id: <201001120119.38062.rossi.f@inwind.it>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 09 January 2010 04:41:32 Bob Copeland wrote:

> Ok, well the patch only will affect AP mode -- it addresses a bug where
> multicast AP frames are queued but not always processed.  I wonder if your
> workload is just filling up the queues and then the queues are awakened
> prematurely.  There's a check in ath5k_tx_processq to only re-enable the
> queue when there are 40 tx buffers left, but there are a few other paths
> that re-enable the queues -- also accounting on txbuf_len could
>  theoretically get broken.
> 
> Maybe a printk in ath5k_tx_queue of sc->txbuf_len caN show how many buffers
> are typically available when entering?

I put a printk debug statement in ath5k_tx_queue() to see how sc->txbuf_len 
changes. The maximum number of buffers is 200 as defined by ATH_TXBUF. During 
the file transfer, sometimes, sc>txbuf_len decreases up to 1, then it changes 
to 41 and starts again to decrease up to 1, again 41 and so on for a few 
seconds. When the buffer number is 0 I can see the "no further txbuf available, 
dropping packet" message.

Fabio
