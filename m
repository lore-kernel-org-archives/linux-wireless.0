Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:50093 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325AbZJ0K3J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2009 06:29:09 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: ath5k phy0: no further txbuf available, dropping packet
Date: Tue, 27 Oct 2009 11:29:08 +0100
Cc: dsrbecky@gmail.com, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
References: <87f9e23c0910261352x60e17ef8ud859f91f36c43898@mail.gmail.com> <200910262230.57957.mb@bu3sch.de> <20091027100926.GA13391@hash.localnet>
In-Reply-To: <20091027100926.GA13391@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200910271129.10535.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 27 October 2009 11:09:26 Bob Copeland wrote:
> On Mon, Oct 26, 2009 at 10:30:55PM +0100, Michael Buesch wrote:
> > 		/* No frame has been send or error */
> > 		if (unlikely(!(tx_status->tx_status_1 & AR5K_DESC_TX_STATUS1_DONE)))
> > 			return -EINPROGRESS;
> > 		...
> > 	}
> 
> > Notice the comment and how it says "or error".
> 
> Hmm, that does sound problematic.  But looking at the various bitfields:
> 
> #define AR5K_DESC_TX_STATUS1_DONE               0x00000001
> #define AR5K_DESC_TX_STATUS1_SEQ_NUM            0x00001ffe
> #define AR5K_DESC_TX_STATUS1_ACK_SIG_STRENGTH   0x001fe000
> #define AR5K_DESC_TX_STATUS1_FINAL_TS_INDEX     0x00600000
> #define AR5K_DESC_TX_STATUS1_COMP_SUCCESS       0x00800000
> #define AR5K_DESC_TX_STATUS1_XMIT_ANTENNA       0x01000000
> 
> I would be led to believe that 'done' means 'completed or error' and
> the comment is similarly ambiguous.  The status0 word contains things
> like 'really did succeed, number of retries, timestamp' etc.

Hm, I looked through the whole status processing code and this is the only
place I can see that could trigger stalling of the buffer head queue.

If the lowlevel status handler is able to distinguish between "done", "error" and "not done yet",
the return codes should probably changed:

0 => Packet was properly processed.
     The upper status handler will free it
-INPROGRESS => Packet was not processed, yet.
               The upper status handler should bail out and wait.
ERROR => Packet failed.
         The upper status handler should drop the packet
         and go on processing the other frames.

If that's not the case, I don't really know what's happening.

-- 
Greetings, Michael.
