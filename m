Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:38390 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751153AbXKVEpc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2007 23:45:32 -0500
From: bruno randolf <bruno@thinktube.com>
To: ath5k-devel@lists.ath5k.org
Subject: Re: [ath5k-devel] ath5k: more consistent debug, info and error logging
Date: Thu, 22 Nov 2007 13:45:30 +0900
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Jiri Slaby <jirislaby@gmail.com>
References: <1195549767-21983-1-git-send-email-bruno@thinktube.com> <43e72e890711201757m159a5147j3984c3f1555e5444@mail.gmail.com> <200711221311.42072.bruno@thinktube.com>
In-Reply-To: <200711221311.42072.bruno@thinktube.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711221345.31261.bruno@thinktube.com> (sfid-20071122_044541_202451_21B2EAAD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > > > +     ATH_DEBUG_RESET         = 0x00000001,   /* reset processing */
> > > > +     ATH_DEBUG_INTR          = 0x00000002,   /* ISR */
> > > > +     ATH_DEBUG_MODE          = 0x00000004,   /* mode init/setup */
> > > > +     ATH_DEBUG_XMIT          = 0x00000008,   /* basic xmit operation
> > > > */ +     ATH_DEBUG_BEACON        = 0x00000010,   /* beacon handling
> > > > */ +     ATH_DEBUG_BEACON_PROC   = 0x00000020,   /* beacon ISR proc
> > > > */ + ATH_DEBUG_CALIBRATE     = 0x00000100,   /* periodic calibration
> > > > */ + ATH_DEBUG_TXPOWER       = 0x00000200,   /* transmit power */ +
> > > > ATH_DEBUG_LED           = 0x00000400,   /* led management */ +
> > > > ATH_DEBUG_DUMP_RX       = 0x00001000,   /* print received skb content
> > > > */ +     ATH_DEBUG_DUMP_TX       = 0x00002000,   /* print transmit
> > > > skb content */ +     ATH_DEBUG_DUMPSTATE     = 0x00004000,   /* dump
> > > > register state */ +     ATH_DEBUG_DUMPMODES     = 0x00008000,   /*
> > > > dump modes */ +     ATH_DEBUG_TRACE         = 0x00010000,   /* trace
> > > > function calls */ +     ATH_DEBUG_FATAL         = 0x80000000,   /*
> > > > fatal errors */ +     ATH_DEBUG_ANY           = 0xffffffff
> > > > +};
> >
> > While you're at it can you move these to use kernel-doc? You'll have
> > to name the enum, perhaps ath5k_debug ?
>
> o.k.

while doing that i question myself, what is ATH5K_DEBUG_FATAL /* fatal errors 
*/ supposed to mean? shouldn't fatal errors be reported as errors, and not 
only in debugging mode?

the only place where ATH5K_DEBUG_FATAL is used is in the code i moved from 
ath5k_rx_stop() to:

void
ath5k_debug_printrxbuffs(struct ath5k_softc *sc, struct ath5k_hw *ah)
{
	struct ath5k_desc *ds;
	struct ath5k_buf *bf;
	int status;

	if (likely(!(sc->debug.level &
	    (ATH5K_DEBUG_RESET | ATH5K_DEBUG_FATAL))))
		return;

	printk(KERN_DEBUG "rx queue %x, link %p\n",
		ath5k_hw_get_rx_buf(ah), sc->rxlink);

	spin_lock_bh(&sc->rxbuflock);
	list_for_each_entry(bf, &sc->rxbuf, list) {
		ds = bf->desc;
		status = ah->ah_proc_rx_desc(ah, ds);
		if (!status || (sc->debug.level & ATH5K_DEBUG_FATAL))
			ath5k_debug_printrxbuf(bf, status == 0);
	}
	spin_unlock_bh(&sc->rxbuflock);
}

so would it be ok to remove ATH5K_DEBUG_FATAL alltogether?
i might make that as a seperate patch once the first two are thru.

bruno
