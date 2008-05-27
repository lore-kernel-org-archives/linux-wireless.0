Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:41371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759385AbYE0UUj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2008 16:20:39 -0400
Subject: Re: [PATCH, take 3] libertas: fix compact flash interrupt handling
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1211919275.555.25.camel@localhost.localdomain>
References: <200805261250.23580.hs4233@mail.mn-solutions.de>
	 <1211919275.555.25.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 27 May 2008 16:20:28 -0400
Message-Id: <1211919628.555.35.camel@localhost.localdomain> (sfid-20080527_222045_814926_44F93CE0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-05-27 at 16:14 -0400, Dan Williams wrote:
> On Mon, 2008-05-26 at 12:50 +0200, Holger Schurig wrote:
> > The old code misbehaved because it polled card status and always called the
> > "tx over" code-path.
> > 
> > This also fixes a hard lockup by not allowing and card interrupts while
> > transferring a TX frame or a command into the card.
> 
> So I still get stalls with this latest set on my Fujitsu, but that
> doesn't mean the patch shouldn't be applied.  It doesn't work any
> _worse_ than before.  It also worked better than before the first time I
> tried it.  I have logs.
> 
> Behavior is basically that the TX watchdog timer fires, then the
> libertas TX timeout handler tries to send the RSSI command, which also
> times out and gets requeued forever.
> 
> The first time I got a few hundred MBs into an ISO before the stall, and
> got an interesting WARNING from the kernel while in the TX timeout
> handler when attempting to send the RSSI command.
> 
> The second time I started a ping of machine B (where the Libertas CF
> card is) from the machine B (on which the ISO image is), while scp-ing

"from machine A" that should read...

> the ISO from machine A to machine B.  This got only a few MB in before
> the same behavior occurred.
> 
> I really don't know what to do to trace it further.  Is there a way to
> reset the CF card and kick the firmware in the head that I can try from
> the TX handler, like a USB port reset or something?  I also might be

and that should be "that I can try from the TX timeout handler"

> able to set this machine up for remote access so you can play with it if
> you like.
> 
> But again; if the patch works better for you, I'll ack it because it
> doesn't work any worse for me.  Logs with libertas_debug=0x443af
> available if you want to see them.
> 
> Dan
> 
> > Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
> > 
> > Index: wireless-testing/drivers/net/wireless/libertas/if_cs.c
> > ===================================================================
> > --- wireless-testing.orig/drivers/net/wireless/libertas/if_cs.c	2008-05-26 08:53:27.000000000 +0200
> > +++ wireless-testing/drivers/net/wireless/libertas/if_cs.c	2008-05-26 10:27:24.000000000 +0200
> > @@ -215,9 +215,21 @@ static int if_cs_poll_while_fw_download(
> >  
> > 
> >  /********************************************************************/
> > -/* I/O                                                              */
> > +/* I/O and interrupt handling                                       */
> >  /********************************************************************/
> >  
> > +static inline void if_cs_enable_ints(struct if_cs_card *card)
> > +{
> > +	lbs_deb_enter(LBS_DEB_CS);
> > +	if_cs_write16(card, IF_CS_H_INT_MASK, 0);
> > +}
> > +
> > +static inline void if_cs_disable_ints(struct if_cs_card *card)
> > +{
> > +	lbs_deb_enter(LBS_DEB_CS);
> > +	if_cs_write16(card, IF_CS_H_INT_MASK, IF_CS_H_IM_MASK);
> > +}
> > +
> >  /*
> >   * Called from if_cs_host_to_card to send a command to the hardware
> >   */
> > @@ -228,6 +240,7 @@ static int if_cs_send_cmd(struct lbs_pri
> >  	int loops = 0;
> >  
> >  	lbs_deb_enter(LBS_DEB_CS);
> > +	if_cs_disable_ints(card);
> >  
> >  	/* Is hardware ready? */
> >  	while (1) {
> > @@ -258,19 +271,24 @@ static int if_cs_send_cmd(struct lbs_pri
> >  	ret = 0;
> >  
> >  done:
> > +	if_cs_enable_ints(card);
> >  	lbs_deb_leave_args(LBS_DEB_CS, "ret %d", ret);
> >  	return ret;
> >  }
> >  
> > -
> >  /*
> >   * Called from if_cs_host_to_card to send a data to the hardware
> >   */
> >  static void if_cs_send_data(struct lbs_private *priv, u8 *buf, u16 nb)
> >  {
> >  	struct if_cs_card *card = (struct if_cs_card *)priv->card;
> > +	u16 status;
> >  
> >  	lbs_deb_enter(LBS_DEB_CS);
> > +	if_cs_disable_ints(card);
> > +
> > +	status = if_cs_read16(card, IF_CS_C_STATUS);
> > +	BUG_ON((status & IF_CS_C_S_TX_DNLD_RDY) == 0);
> >  
> >  	if_cs_write16(card, IF_CS_H_WRITE_LEN, nb);
> >  
> > @@ -281,11 +299,11 @@ static void if_cs_send_data(struct lbs_p
> >  
> >  	if_cs_write16(card, IF_CS_H_STATUS, IF_CS_H_STATUS_TX_OVER);
> >  	if_cs_write16(card, IF_CS_H_INT_CAUSE, IF_CS_H_STATUS_TX_OVER);
> > +	if_cs_enable_ints(card);
> >  
> >  	lbs_deb_leave(LBS_DEB_CS);
> >  }
> >  
> > -
> >  /*
> >   * Get the command result out of the card.
> >   */
> > @@ -330,7 +348,6 @@ out:
> >  	return ret;
> >  }
> >  
> > -
> >  static struct sk_buff *if_cs_receive_data(struct lbs_private *priv)
> >  {
> >  	struct sk_buff *skb = NULL;
> > @@ -367,25 +384,6 @@ out:
> >  	return skb;
> >  }
> >  
> > -
> > -
> > -/********************************************************************/
> > -/* Interrupts                                                       */
> > -/********************************************************************/
> > -
> > -static inline void if_cs_enable_ints(struct if_cs_card *card)
> > -{
> > -	lbs_deb_enter(LBS_DEB_CS);
> > -	if_cs_write16(card, IF_CS_H_INT_MASK, 0);
> > -}
> > -
> > -static inline void if_cs_disable_ints(struct if_cs_card *card)
> > -{
> > -	lbs_deb_enter(LBS_DEB_CS);
> > -	if_cs_write16(card, IF_CS_H_INT_MASK, IF_CS_H_IM_MASK);
> > -}
> > -
> > -
> >  static irqreturn_t if_cs_interrupt(int irq, void *data)
> >  {
> >  	struct if_cs_card *card = data;
> > @@ -394,10 +392,8 @@ static irqreturn_t if_cs_interrupt(int i
> >  
> >  	lbs_deb_enter(LBS_DEB_CS);
> >  
> > +	/* Ask card interrupt cause register if there is something for us */
> >  	cause = if_cs_read16(card, IF_CS_C_INT_CAUSE);
> > -	if_cs_write16(card, IF_CS_C_INT_CAUSE, cause & IF_CS_C_IC_MASK);
> > -
> > -	lbs_deb_cs("cause 0x%04x\n", cause);
> >  	if (cause == 0) {
> >  		/* Not for us */
> >  		return IRQ_NONE;
> > @@ -409,9 +405,9 @@ static irqreturn_t if_cs_interrupt(int i
> >  		return IRQ_HANDLED;
> >  	}
> >  
> > -	/* TODO: I'm not sure what the best ordering is */
> > -
> > -	cause = if_cs_read16(card, IF_CS_C_STATUS) & IF_CS_C_S_MASK;
> > +	/* Clear interrupt cause */
> > +	if_cs_write16(card, IF_CS_C_INT_CAUSE, cause & IF_CS_C_IC_MASK);
> > +	lbs_deb_cs("cause 0x%04x\n", cause);
> >  
> >  	if (cause & IF_CS_C_S_RX_UPLD_RDY) {
> >  		struct sk_buff *skb;
> > @@ -422,7 +418,7 @@ static irqreturn_t if_cs_interrupt(int i
> >  	}
> >  
> >  	if (cause & IF_CS_H_IC_TX_OVER) {
> > -		lbs_deb_cs("tx over\n");
> > +		lbs_deb_cs("tx done\n");
> >  		lbs_host_to_card_done(priv);
> >  	}
> >  
> > @@ -430,7 +426,7 @@ static irqreturn_t if_cs_interrupt(int i
> >  		unsigned long flags;
> >  		u8 i;
> >  
> > -		lbs_deb_cs("cmd upload ready\n");
> > +		lbs_deb_cs("cmd resp\n");
> >  		spin_lock_irqsave(&priv->driver_lock, flags);
> >  		i = (priv->resp_idx == 0) ? 1 : 0;
> >  		spin_unlock_irqrestore(&priv->driver_lock, flags);
> > @@ -449,10 +445,11 @@ static irqreturn_t if_cs_interrupt(int i
> >  			& IF_CS_C_S_STATUS_MASK;
> >  		if_cs_write16(priv->card, IF_CS_H_INT_CAUSE,
> >  			IF_CS_H_IC_HOST_EVENT);
> > -		lbs_deb_cs("eventcause 0x%04x\n", event);
> > +		lbs_deb_cs("host event 0x%04x\n", event);
> >  		lbs_queue_event(priv, event >> 8 & 0xff);
> >  	}
> >  
> > +	lbs_deb_leave(LBS_DEB_CS);
> >  	return IRQ_HANDLED;
> >  }
> >  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

