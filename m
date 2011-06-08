Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:21354 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518Ab1FHPO6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2011 11:14:58 -0400
Subject: Re: iwlagn aggregation problem when stations are removed/re-added
 quickly
From: wwguy <wey-yi.w.guy@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Daniel Halperin <dhalperi@cs.washington.edu>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1307544781.30277.6.camel@jlt3.sipsolutions.net>
References: <BANLkTiki+y2uoeyqX7BE0W+7RA9hHhgTLA@mail.gmail.com>
	 (sfid-20110514_005657_579238_E23F3390) <1307531276.3961.8.camel@jlt3.sipsolutions.net>
	 <1307543824.5115.10.camel@wwguy-ubuntu>
	 <1307544781.30277.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Jun 2011 08:11:23 -0700
Message-ID: <1307545883.5115.23.camel@wwguy-ubuntu> (sfid-20110608_171503_866259_C63D1E95)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-06-08 at 07:53 -0700, Johannes Berg wrote:
> On Wed, 2011-06-08 at 07:37 -0700, wwguy wrote:
> > On Wed, 2011-06-08 at 04:07 -0700, Johannes Berg wrote:
> > > On Fri, 2011-05-13 at 15:56 -0700, Daniel Halperin wrote:
> > > 
> > > > I'm running an experiment where a client connects to the AP (both HT
> > > > iwlagn devices), starts a large transfer that gets aggregation going,
> > > > disassociates, and then reassociates and restarts the transfer.
> > > > 
> > > > When mac80211 stops the queue (as part of the client's disassocation
> > > > process), it goes into the following code:
> > > > 
> > > >                IWL_DEBUG_HT(priv, "Stopping a non empty AGG HW QUEUE\n");
> > > >                 priv->stations[sta_id].tid[tid].agg.state =
> > > >                                 IWL_EMPTYING_HW_QUEUE_DELBA;
> > > >                 spin_unlock_irqrestore(&priv->sta_lock, flags);
> > > > 
> > > > but if the station is removed right away the packets stay in the
> > > > queue. Indeed, when the client reconnects, the packets are then
> > > > delivered! But then the queue gets stuck and the AP issues a firmware
> > > > reset, which doesn't actually get traffic flowing again. Below,
> > > > there's a log with IWL_DL_HT set. It may be something racy; adding
> > > > DL_INFO and DL_MAC80211 I haven't been able to reproduce the bug yet
> > > > in a few tries.
> > > > 
> > > > I suspect this will also be a problem with P2P, and not just my klugey
> > > > use of AP mode. Any suggestions as to how to fix?
> > > 
> > > Sorry I'm replying this late. I'm not sure what the best way to fix it
> > > would be, but it makes sense that this would happen. Maybe we can flush
> > > the aggregation queue (asking the ucode to drop all frames) when the
> > > station is removed, but I'm not sure how we'd do that -- Wey-Yi do you
> > > know if that's possible?
> > > 
> > flush the queue might be a good solution, I was being told (I don't
> > remember who and when which is bad), the "tx flush" command is needed
> > especially for P2P
> > 
> > btw, there are 2 type of "tx flush", flush all the frames in uCode, or
> > just flush the frames in specified queue.
> 
> Right, but the flush seems to be implemented per FIFO and queue, so it's
> a bit confusing. In this case we should drop all frames out of the
> aggretgaiton queue.
> 

It is confuse, it will drop all the frames on the request queues 

flush_cmd.fifo_control = IWL_TX_FIFO_VO_MSK | IWL_TX_FIFO_VI_MSK |
			 IWL_TX_FIFO_BE_MSK | IWL_TX_FIFO_BK_MSK;
if (priv->cfg->sku & EEPROM_SKU_CAP_11N_ENABLE)
		flush_cmd.fifo_control |= IWL_AGG_TX_QUEUE_MSK;

But it did not consider different context, I will submit a separate
patch to fix it

Wey
 


