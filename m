Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:37331 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779AbZJZVeb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 17:34:31 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: ath5k phy0: no further txbuf available, dropping packet
Date: Mon, 26 Oct 2009 22:34:31 +0100
Cc: dsrbecky@gmail.com, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
References: <87f9e23c0910261352x60e17ef8ud859f91f36c43898@mail.gmail.com> <200910262230.57957.mb@bu3sch.de>
In-Reply-To: <200910262230.57957.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200910262234.33711.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 26 October 2009 22:30:55 Michael Buesch wrote:
> On Monday 26 October 2009 21:52:39 David Srbecky wrote:
> > I am getting this error as well.
> 
> Ok, I looked at the code a bit and this looks strange to me.
> There's the TX status handler in base.c which basically looks like this:
> 
> 
> 	loop_over_queued_packets() {
> 		ret = sc->ah->ah_proc_rx_desc(sc->ah, ds, &rs);

Typo. I meant ah_proc_tx_desc()

> 		if (unlikely(ret == -EINPROGRESS))
> 			break;
> 		free_packet_and_return_bufferhead_to_pool();
> 	}
> 
> So the ah_proc_rx_desc callback looks like this:
> 
> 	ah_proc_rx_..._desc()

same here

> 	{
> 		...
> 		/* No frame has been send or error */
> 		if (unlikely(!(tx_status->tx_status_1 & AR5K_DESC_TX_STATUS1_DONE)))
> 			return -EINPROGRESS;
> 		...
> 	}

-- 
Greetings, Michael.
