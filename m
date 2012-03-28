Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227Ab2C1MPO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 08:15:14 -0400
Date: Wed, 28 Mar 2012 14:14:29 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Jakub Kicinski <kubakici@wp.pl>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 2/4] rt2x00: move disabling of DMA before loading firmware
Message-ID: <20120328121428.GA3333@redhat.com> (sfid-20120328_141519_930420_902741CC)
References: <1332859867-27921-1-git-send-email-kubakici@wp.pl>
 <1332859867-27921-3-git-send-email-kubakici@wp.pl>
 <4F7202BB.4000904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F7202BB.4000904@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Tue, Mar 27, 2012 at 08:11:07PM +0200, Gertjan van Wingerde wrote:
> >  	/*
> > -	 * Disable DMA, will be reenabled later when enabling
> > -	 * the radio.
> > -	 */
> > -	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
> > -	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 0);
> > -	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 0);
> > -	rt2800_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
> > -
> > -	/*
> >  	 * Initialize firmware.
> >  	 */
> >  	rt2800_register_write(rt2x00dev, H2M_BBP_AGENT, 0);
> 
> This basically seems to be a revert of commit
> 4ed1dd2a7ec880b301beb61cbc1e08811ec340e4 in the wireless-testing tree.
> That commit was submitted by Stanislaw, which basically does the reverse
> of what you are doing here.
> 
> I leave it up to you and Stanislaw to decide on what the state is that
> we need to be in.

When DMA was disabled before FW load, I observed frame receives before
->enable_radio, so looks like WPDMA_GLO_CFG register is overwritten by
F/W load. Although received frames did not make any damage, I prefer
not to allow hw to send data to driver, before driver will be really
ready to receive them.

Stanislaw
