Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2570 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbZJ0KKA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2009 06:10:00 -0400
Date: Tue, 27 Oct 2009 06:09:26 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: dsrbecky@gmail.com, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
Subject: Re: ath5k phy0: no further txbuf available, dropping packet
Message-ID: <20091027100926.GA13391@hash.localnet>
References: <87f9e23c0910261352x60e17ef8ud859f91f36c43898@mail.gmail.com> <200910262230.57957.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200910262230.57957.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 26, 2009 at 10:30:55PM +0100, Michael Buesch wrote:
> 		/* No frame has been send or error */
> 		if (unlikely(!(tx_status->tx_status_1 & AR5K_DESC_TX_STATUS1_DONE)))
> 			return -EINPROGRESS;
> 		...
> 	}

> Notice the comment and how it says "or error".

Hmm, that does sound problematic.  But looking at the various bitfields:

#define AR5K_DESC_TX_STATUS1_DONE               0x00000001
#define AR5K_DESC_TX_STATUS1_SEQ_NUM            0x00001ffe
#define AR5K_DESC_TX_STATUS1_ACK_SIG_STRENGTH   0x001fe000
#define AR5K_DESC_TX_STATUS1_FINAL_TS_INDEX     0x00600000
#define AR5K_DESC_TX_STATUS1_COMP_SUCCESS       0x00800000
#define AR5K_DESC_TX_STATUS1_XMIT_ANTENNA       0x01000000

I would be led to believe that 'done' means 'completed or error' and
the comment is similarly ambiguous.  The status0 word contains things
like 'really did succeed, number of retries, timestamp' etc.

-- 
Bob Copeland %% www.bobcopeland.com

