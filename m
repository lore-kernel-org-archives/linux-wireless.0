Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:39922 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab3BDPs1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 10:48:27 -0500
Date: Mon, 4 Feb 2013 09:48:22 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Jonathan Nieder <jrnieder@gmail.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	=?utf-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>,
	Milan Bouchet-Valat <nalimilan@club-internet.fr>
Subject: Re: [PATCH for 3.8] brcmsmac: rework of mac80211 .flush() callback
 operation
Message-ID: <20130204154822.GC12491@thinkpad-t410> (sfid-20130204_164830_955119_41D4A83C)
References: <1359812210-31658-1-git-send-email-arend@broadcom.com>
 <20130204153712.GB12491@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20130204153712.GB12491@thinkpad-t410>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 04, 2013 at 09:37:12AM -0600, Seth Forshee wrote:
> On Sat, Feb 02, 2013 at 02:36:50PM +0100, Arend van Spriel wrote:
> > This patch addresses a long standing issue of the driver with the
> > mac80211 .flush() callback. Since implementing the .flush() callback
> > a number of issues have been fixed, but a WARN_ON_ONCE() was still
> > triggered because the timeout on the flush could still occur.
> > 
> > This patch changes the awkward design using msleep() into one using
> > a waitqueue. The waiting flush() context will kick the transmit dma
> > when it is idle and the timeout used waiting for the event is set
> > to 500 ms. Worst case there can be 64 frames outstanding for transmit
> > in the driver. At a rate of 1Mbps that would take 1.5 seconds assuming
> > MTU is 1500 bytes and ignoring retries. The WARN_ON_ONCE() is also
> > removed as this was put in to indicate the flush timeout as a reason
> > for the driver to stall. That was not happening since fixing endless
> > AMPDU retries with following upstream commit:
> > 
> > commit 85091fc0a75653e239dc8379658515e577544927
> > Author: Arend van Spriel <arend@broadcom.com>
> > Date:   Thu Feb 23 18:38:22 2012 +0100
> > 
> >     brcm80211: smac: fix endless retry of A-MPDU transmissions
> > 
> > bugzilla: 42840 <https://bugzilla.kernel.org/show_bug.cgi?id=42840>
> > bugzilla@redhat: <https://bugzilla.redhat.com/show_bug.cgi?id=799168>
> > bugzilla@redhat: <https://bugzilla.redhat.com/show_bug.cgi?id=787649>
> > 
> > Cc: Jonathan Nieder <jrnieder@gmail.com>
> > Cc: Stanislaw Gruszka <sgruszka@redhat.com>
> > Cc: Camaleón <noelamac@gmail.com>
> > Cc: Milan Bouchet-Valat <nalimilan@club-internet.fr>
> > Cc: Seth Forshee <seth.forshee@canonical.com>
> > Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> > Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
> > Reviewed-by: Piotr Haber <phaber@broadcom.com>
> > Signed-off-by: Arend van Spriel <arend@broadcom.com>
> 
> I think this makes sense and is an improvement to how the flush works
> now. In the past week I've become pretty well convinced that all
> instances of the flush timeout warning that I've been seeing are
> actually due to brcmsmac continuing to get frames for tx rather than any
> kind of problem with actually transmitting the frames, so demoting this
> from a WARN_ON to a debug statement makes sense.
> 
> Acked-by: Seth Forshee <seth.forshee@canonical.com>
> 
> I do have one minor comment below.
> 
> > diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
> > index 9f3d7e9..8b58390 100644
> > --- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
> > +++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
> > @@ -7511,25 +7511,16 @@ int brcms_c_get_curband(struct brcms_c_info *wlc)
> >  	return wlc->band->bandunit;
> >  }
> >  
> > -void brcms_c_wait_for_tx_completion(struct brcms_c_info *wlc, bool drop)
> > +bool brcms_c_tx_flush_completed(struct brcms_c_info *wlc)
> >  {
> > -	int timeout = 20;
> >  	int i;
> >  
> >  	/* Kick DMA to send any pending AMPDU */
> >  	for (i = 0; i < ARRAY_SIZE(wlc->hw->di); i++)
> >  		if (wlc->hw->di[i])
> > -			dma_txflush(wlc->hw->di[i]);
> > +			dma_kick_tx(wlc->hw->di[i]);
> 
> While it won't hurt to call dma_kick_tx() here, it really shouldn't be
> necessary. It already gets called anytime brcmsmac handles a legit
> txstatus interrupt, so I suspect calling it here will has effect.
> 
> The call to dma_txflush() was intended to move queued A-MPDU frames into
> the DMA fifos at the start of the flush. This is no longer happening,
> but if the driver continues getting frames for tx while the flush is in
> progress then the flush doesn't really help. Removing the call renders

Sorry, confusing wording here. I mean that calling dma_txflush() doesn't
help if the driver continues receiving frames during a flush.

> dma_txflush() unused though, so it could be removed entirely.
> 
> Cheers,
> Seth
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
