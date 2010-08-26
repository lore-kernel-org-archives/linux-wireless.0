Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from colo4.heeltoe.com ([207.210.93.145]:59782 "EHLO
	colo4.heeltoe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab0HZTSa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Aug 2010 15:18:30 -0400
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [rfc patch] libertas: fix if_spi_prog_helper_firmware()
From: Paul Fox <pgf@laptop.org>
cc: Dan Carpenter <error27@gmail.com>,
	Mike Frysinger <vapier.adi@gmail.com>,
	libertas-dev@lists.infradead.org, kernel-janitors@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Ben Hutchings <ben@decadent.org.uk>
In-reply-to: <1282837725.3642.1.camel@dcbw.foobar.com> (sfid-20100826_114702_532051_0C06391A)
References: <20100824120743.GG29330@bicker> <1282837725.3642.1.camel@dcbw.foobar.com> (sfid-20100826_114702_532051_0C06391A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 26 Aug 2010 14:52:13 -0400
Message-ID: <6529.1282848733@foxharp.boston.ma.us>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

dan wrote:
 > On Tue, 2010-08-24 at 14:07 +0200, Dan Carpenter wrote:
 > > The indenting is not correct here.  I don't have this hardware and I'm
 > > just guessing as to what was intended.  I think that if there is an
 > > error we should return an error code, but if there isn't an error we
 > > should return success directly without releasing the firmware.
 > > 
 > > Signed-off-by: Dan Carpenter <error27@gmail.com>
 > 
 > I've significantly changed firmware loading in wireless-testing which
 > should hit the next merge window.  It won't have this problem, and it
 > does correctly release the firmware later on.  It does preserve the
 > existing behavior of releasing the firmware after load, instead of
 > keeping it around for resume.  If there are fixes I think they should be
 > against wireless-testing actually since that's what's "next".

as part of the firmware and suspend/resume topic:  on the XO 1.5
laptop, running 2.6.31, we see an apparent leak of the firmware on
every suspend/resume where the card is powered down.  (our driver
keeps the wlan module powered acros s/r if there are wakeup events
configured, otherwise it powers down -- i can't remember if that change
has been upstreamed or not.) our trac ticket is here: 
http://dev.laptop.org/ticket/9928

i got as far as deciding that the leak wasn't in the libertas driver
itself before we decided we had more important fish to fry, so our
investigation is/was incomplete.  from what i found, it seemed like
perhaps the leak would go away if the driver cached a copy of the
firmware, as other drivers do.  but that still leaves the suspicion
that there's another copy hanging around in the download path still.

paul

 > 
 > Dan
 > 
 > > diff --git a/drivers/net/wireless/libertas/if_spi.c 
 > b/drivers/net/wireless/libertas/if_spi.c
 > > index fe3f080..123a541 100644
 > > --- a/drivers/net/wireless/libertas/if_spi.c
 > > +++ b/drivers/net/wireless/libertas/if_spi.c
 > > @@ -471,9 +471,12 @@ static int if_spi_prog_helper_firmware(struct 
 > if_spi_card *card)
 > >  		goto release_firmware;
 > >  	err = spu_write_u16(card, IF_SPI_CARD_INT_CAUSE_REG,
 > >  				IF_SPI_CIC_CMD_DOWNLOAD_OVER);
 > > +	if (err)
 > >  		goto release_firmware;
 > >  
 > > -	lbs_deb_spi("waiting for helper to boot...\n");
 > > +	lbs_deb_spi("helper firmware loaded...\n");
 > > +
 > > +	return 0;
 > >  
 > >  release_firmware:
 > >  	release_firmware(firmware);
 > > --
 > > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
 > > the body of a message to majordomo@vger.kernel.org
 > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
 > 
 > 
 > 
 > _______________________________________________
 > libertas-dev mailing list
 > libertas-dev@lists.infradead.org
 > http://lists.infradead.org/mailman/listinfo/libertas-dev

=---------------------
 paul fox, pgf@laptop.org
