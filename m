Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.185]:50215 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbXJKUKE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2007 16:10:04 -0400
Received: by mu-out-0910.google.com with SMTP id i10so1045549mue
        for <linux-wireless@vger.kernel.org>; Thu, 11 Oct 2007 13:10:02 -0700 (PDT)
Message-ID: <40f31dec0710111310l1e78c71cx7c4e318a83d87098@mail.gmail.com> (sfid-20071011_211009_889973_52749BBC)
Date: Thu, 11 Oct 2007 20:10:00 +0000
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH 3/4] Don't read AR5K_RAC_PISR on AR5210, document ath5k_int
Cc: "John Linville" <linville@tuxdriver.com>,
	"Jiri Slaby" <jirislaby@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <20071011194934.GA9403@pogo>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071011193918.GB4334@pogo> <20071011194108.GC4334@pogo>
	 <20071011194630.GA9304@pogo> <20071011194934.GA9403@pogo>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I should have added something inside ath5kreg.h, sry for that...

(?) = not sure

> + * @AR5K_INT_RXDESC: ??
Request RX descriptor/Read RX descriptor (?)

> + * @AR5K_INT_RXNOFRM: ??
No frame received (?)

> + * @AR5K_INT_RXEOL: received End Of List for VEOL (Virtual End Of List). The
> + *     Queue Control Unit (QCU) signals an EOL interrupt only if a descriptor's
> + *     LinkPtr is NULL. For more details, refer to:
> + *     http://www.freepatentsonline.com/20030225739.html

> + * @AR5K_INT_RXORN: indicates a hardware reset is required
Rx overrun is not always fatal, on some chips we can continue
operation without reseting the card, that's why int_fatal is not
common for all chips ;-)

> + * @AR5K_INT_TX: mask to identify received frame interrupts, of type
> + *     AR5K_ISR_TXOK or AR5K_ISR_TXERR
> + * @AR5K_INT_TXDESC: ??
Request TX descriptor/Read TX status descriptor (?)

> + * @AR5K_INT_TXURN: received when we should increase the TX trigger threshold
> + *     We currently do increments on interrupt by
> + *     (AR5K_TUNE_MAX_TX_FIFO_THRES - current_trigger_level) / 2
> + * @AR5K_INT_MIB: Indicates the Management Information Base counters should be
> + *     checked. We should do this with ath5k_hw_update_mib_counters() but
> + *     it seems we should also then do some noise immunity work.

> + * @AR5K_INT_RXPHY: ??
RX PHY Error

> + * @AR5K_INT_RXKCM: ??
> + * @AR5K_INT_SWBA: SoftWare Beacon Alert - indicates its time to send a
> + *     beacon that must be handled in software. The alternative is if you
> + *     have VEOL support, in that case you let the hardware deal with things.
> + * @AR5K_INT_BMISS: If in STA mode this indicates we have stopped seeing
> + *     beacons from the AP have associated with, we should probably try to
> + *     reassociate. When in IBSS mode this might mean we have not received
> + *     any beacons from any local stations. Note that every station in an
> + *     IBSS schedules to send beacons at the Target Beacon Transmission Time
> + *     (TBTT) with a random backoff.
> + * @AR5K_INT_BNR: Beacon Not Ready interrupt - ??

> + * @AR5K_INT_GPIO: ??
GPIO interrupt used for RF Kill, we should handle this inside
interrupt handler, until then i've disabled it because it results an
interrupt storm in case RF Kill switch is off.

> + * @AR5K_INT_NOCARD: signals the card has been removed
There is no such interrupt, it's software stuff used in hal. We can
always check for pending interrupts by reading that register (check
out is_intr_pending) and get rid of this.


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
