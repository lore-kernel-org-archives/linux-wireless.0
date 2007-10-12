Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:48574 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbXJLOG2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2007 10:06:28 -0400
Received: by py-out-1112.google.com with SMTP id u77so1672633pyb
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2007 07:06:26 -0700 (PDT)
Message-ID: <43e72e890710120706lbcf41a1sbff7845c6323211b@mail.gmail.com> (sfid-20071012_150632_293992_21470C5F)
Date: Fri, 12 Oct 2007 10:06:26 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Subject: Re: [PATCH 3/4] Don't read AR5K_RAC_PISR on AR5210, document ath5k_int
Cc: "John Linville" <linville@tuxdriver.com>,
	"Jiri Slaby" <jirislaby@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <40f31dec0710111310l1e78c71cx7c4e318a83d87098@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071011193918.GB4334@pogo> <20071011194108.GC4334@pogo>
	 <20071011194630.GA9304@pogo> <20071011194934.GA9403@pogo>
	 <40f31dec0710111310l1e78c71cx7c4e318a83d87098@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/11/07, Nick Kossifidis <mickflemm@gmail.com> wrote:
> I should have added something inside ath5kreg.h, sry for that...
>
> (?) = not sure
>
> > + * @AR5K_INT_RXDESC: ??
> Request RX descriptor/Read RX descriptor (?)
>
> > + * @AR5K_INT_RXNOFRM: ??
> No frame received (?)
>
> > + * @AR5K_INT_RXEOL: received End Of List for VEOL (Virtual End Of List). The
> > + *     Queue Control Unit (QCU) signals an EOL interrupt only if a descriptor's
> > + *     LinkPtr is NULL. For more details, refer to:
> > + *     http://www.freepatentsonline.com/20030225739.html
>
> > + * @AR5K_INT_RXORN: indicates a hardware reset is required
> Rx overrun is not always fatal, on some chips we can continue
> operation without reseting the card, that's why int_fatal is not
> common for all chips ;-)
>
> > + * @AR5K_INT_TX: mask to identify received frame interrupts, of type
> > + *     AR5K_ISR_TXOK or AR5K_ISR_TXERR
> > + * @AR5K_INT_TXDESC: ??
> Request TX descriptor/Read TX status descriptor (?)
>
> > + * @AR5K_INT_TXURN: received when we should increase the TX trigger threshold
> > + *     We currently do increments on interrupt by
> > + *     (AR5K_TUNE_MAX_TX_FIFO_THRES - current_trigger_level) / 2
> > + * @AR5K_INT_MIB: Indicates the Management Information Base counters should be
> > + *     checked. We should do this with ath5k_hw_update_mib_counters() but
> > + *     it seems we should also then do some noise immunity work.
>
> > + * @AR5K_INT_RXPHY: ??
> RX PHY Error
>
> > + * @AR5K_INT_RXKCM: ??
> > + * @AR5K_INT_SWBA: SoftWare Beacon Alert - indicates its time to send a
> > + *     beacon that must be handled in software. The alternative is if you
> > + *     have VEOL support, in that case you let the hardware deal with things.
> > + * @AR5K_INT_BMISS: If in STA mode this indicates we have stopped seeing
> > + *     beacons from the AP have associated with, we should probably try to
> > + *     reassociate. When in IBSS mode this might mean we have not received
> > + *     any beacons from any local stations. Note that every station in an
> > + *     IBSS schedules to send beacons at the Target Beacon Transmission Time
> > + *     (TBTT) with a random backoff.
> > + * @AR5K_INT_BNR: Beacon Not Ready interrupt - ??
>
> > + * @AR5K_INT_GPIO: ??
> GPIO interrupt used for RF Kill, we should handle this inside
> interrupt handler, until then i've disabled it because it results an
> interrupt storm in case RF Kill switch is off.
>
> > + * @AR5K_INT_NOCARD: signals the card has been removed
> There is no such interrupt, it's software stuff used in hal. We can
> always check for pending interrupts by reading that register (check
> out is_intr_pending) and get rid of this.

Since I'm resending, I've added these new comments. However I'm
leaving @AR5K_INT_NOCARD for now as it does seem to be read in hw:



        if (hal->ah_version == AR5K_AR5210) {
                data = ath5k_hw_reg_read(hal, AR5K_ISR);
                if (unlikely(data == AR5K_INT_NOCARD)) {
                        *interrupt_mask = data;
                        return -ENODEV;
                }
        } else {
                /*
                 * Read interrupt status from the Read-And-Clear shadow register
                 * Note: PISR/SISR Not available on 5210
                 */
                data = ath5k_hw_reg_read(hal, AR5K_RAC_PISR);
        }

        /*
         * Get abstract interrupt mask (HAL-compatible)
         */
        *interrupt_mask = (data & AR5K_INT_COMMON) & hal->ah_imr;

        if (unlikely(data == AR5K_INT_NOCARD))
                return -ENODEV;
