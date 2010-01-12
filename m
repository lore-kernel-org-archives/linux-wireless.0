Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:48063 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab0ALQfF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 11:35:05 -0500
Received: by yxe17 with SMTP id 17so21524730yxe.33
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jan 2010 08:35:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201001120119.38062.rossi.f@inwind.it>
References: <4AF99EF9.4040408@nets.rwth-aachen.de>
	 <201001082334.16066.rossi.f@inwind.it>
	 <20100109034132.GA18279@hash.localnet>
	 <201001120119.38062.rossi.f@inwind.it>
Date: Tue, 12 Jan 2010 11:35:04 -0500
Message-ID: <b6c5339f1001120835p381b440fgc2b30369737e104c@mail.gmail.com>
Subject: Re: ath5k: 2.6.32-rc6 "no further txbuf available, dropping packet"
From: Bob Copeland <me@bobcopeland.com>
To: Fabio Rossi <rossi.f@inwind.it>
Cc: linux-wireless@vger.kernel.org,
	Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
	ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 11, 2010 at 7:19 PM, Fabio Rossi <rossi.f@inwind.it> wrote:
> I put a printk debug statement in ath5k_tx_queue() to see how sc->txbuf_len
> changes. The maximum number of buffers is 200 as defined by ATH_TXBUF. During
> the file transfer, sometimes, sc>txbuf_len decreases up to 1, then it changes
> to 41 and starts again to decrease up to 1, again 41 and so on for a few
> seconds. When the buffer number is 0 I can see the "no further txbuf available,
> dropping packet" message.

Ok, well then at least we know that it is working :)  Do you get any ill effects
besides the log spam?  If so then there could be an issue with starvation of the
processing tasklet.  Or maybe we should look at changing the limits
for better flow.

We could also stop the queues a packet earlier, I guess.

-- 
Bob Copeland %% www.bobcopeland.com
