Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:24130 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627Ab2C1MyN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 08:54:13 -0400
Date: Wed, 28 Mar 2012 14:53:59 +0200
From: Jakub Kicinski <kubakici@wp.pl>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 2/4] rt2x00: move disabling of DMA before
 loading firmware
Message-ID: <20120328145359.4bd5d098@north> (sfid-20120328_145428_281080_C595118C)
In-Reply-To: <20120328121428.GA3333@redhat.com>
References: <1332859867-27921-1-git-send-email-kubakici@wp.pl>
	<1332859867-27921-3-git-send-email-kubakici@wp.pl>
	<4F7202BB.4000904@gmail.com>
	<20120328121428.GA3333@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 28 Mar 2012 14:14:29 +0200
Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> Hello,
> 
> On Tue, Mar 27, 2012 at 08:11:07PM +0200, Gertjan van Wingerde wrote:
> > >  	/*
> > > -	 * Disable DMA, will be reenabled later when enabling
> > > -	 * the radio.
> > > -	 */
> > > -	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
> > > -	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 0);
> > > -	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 0);
> > > -	rt2800_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
> > > -
> > > -	/*
> > >  	 * Initialize firmware.
> > >  	 */
> > >  	rt2800_register_write(rt2x00dev, H2M_BBP_AGENT, 0);
> > 
> > This basically seems to be a revert of commit
> > 4ed1dd2a7ec880b301beb61cbc1e08811ec340e4 in the wireless-testing tree.
> > That commit was submitted by Stanislaw, which basically does the reverse
> > of what you are doing here.
> > 
> > I leave it up to you and Stanislaw to decide on what the state is that
> > we need to be in.
> 
> When DMA was disabled before FW load, I observed frame receives before
> ->enable_radio, so looks like WPDMA_GLO_CFG register is overwritten by
> F/W load. Although received frames did not make any damage, I prefer
> not to allow hw to send data to driver, before driver will be really
> ready to receive them.

Hm. I obviously did check whether FW load does overwrite WPDMA_GLO_CFG
and it didn't. Maybe it's device dependent? What bothers me is that now
we have a (very) short window between FW load and disabling DMA.

  -- Kuba
