Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu0-omc2-s25.blu0.hotmail.com ([65.55.111.100]:5825 "EHLO
	blu0-omc2-s25.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753351Ab2EEHux (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 May 2012 03:50:53 -0400
Message-ID: <BLU0-SMTP3963C1457D4A5496FC3C3A3AC2D0@phx.gbl> (sfid-20120505_095129_339589_259E54B7)
Subject: Re: [PATCH v3 6/6] bcma: Add flush for BCMA_RESET_CTL write
From: Nathan Hintz <nlhintz@hotmail.com>
To: Arend van Spriel <arend@broadcom.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	hauke@hauke-m.de
Date: Sat, 5 May 2012 00:50:49 -0700
In-Reply-To: <4FA4C2CA.8000401@broadcom.com>
References: <1336193796-32599-1-git-send-email-nlhintz@hotmail.com>
	 <BLU0-SMTP198AA334D9A1CD0C329E1A5AC2D0@phx.gbl>
	 <4FA4C2CA.8000401@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-05-05 at 08:03 +0200, Arend van Spriel wrote:
> On 05/05/2012 06:56 AM, Nathan Hintz wrote:
> > Adds a missing read to flush the previous write (per the Broadcom SDK).
> > 
> > Signed-off-by: Nathan Hintz <nlhintz@hotmail.com>
> > ---
> >  drivers/bcma/core.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/bcma/core.c b/drivers/bcma/core.c
> > index 893f6e0..c4e6deb 100644
> > --- a/drivers/bcma/core.c
> > +++ b/drivers/bcma/core.c
> > @@ -30,6 +30,7 @@ void bcma_core_disable(struct bcma_device *core, u32 flags)
> >  	udelay(10);
> >  
> >  	bcma_awrite32(core, BCMA_RESET_CTL, BCMA_RESET_CTL_RESET);
> > +	bcma_aread32(core, BCMA_RESET_CTL);
> >  	udelay(1);
> >  }
> >  EXPORT_SYMBOL_GPL(bcma_core_disable);
> 
> Hi Nathan,
> 
> The read after write is only needed on (certain) SoCs. As bcma is not
> being used just for these SoCs I suggest to make the flush conditional.
> In brcmsmac we introduced "flushed write" function, which does the read
> only for those SoCs.
> 
> Gr. AvS
> 
> 
There are several other occurrences in core.c that are the same
implementation as what was added in this patch.  Is there a reason
why the existing code isn't the way you have suggested already?
Would it be better to submit your suggestion as a separate patch, or
just roll it all into this one?

Nathan


