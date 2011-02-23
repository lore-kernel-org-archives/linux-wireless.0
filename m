Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38201 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab1BWOpd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Feb 2011 09:45:33 -0500
Date: Wed, 23 Feb 2011 09:41:35 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Luciano Coelho <coelho@ti.com>
Cc: Sebastien Jan <s-jan@ti.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] WLAN: fix the path to the wl12xx firmwares
Message-ID: <20110223144134.GA2729@tuxdriver.com>
References: <1298467516-9092-1-git-send-email-s-jan@ti.com>
 <1298471599.2104.44.camel@pimenta>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1298471599.2104.44.camel@pimenta>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 23, 2011 at 04:33:19PM +0200, Luciano Coelho wrote:
> Hi Sebastien,
> 
> On Wed, 2011-02-23 at 14:25 +0100, Sebastien Jan wrote:
> > Validated FW loading on a Ubuntu Natty alpha image, on a pandaboard
> > (embedding a WL1271).
> > 
> > Signed-off-by: Sebastien Jan <s-jan@ti.com>
> > ---
> 
> Thanks for working on getting the wl12xx driver to work on the
> pandaboard!
> 
> > diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
> > index 9050dd9..8ceb6a0 100644
> > --- a/drivers/net/wireless/wl12xx/wl12xx.h
> > +++ b/drivers/net/wireless/wl12xx/wl12xx.h
> > @@ -112,8 +112,8 @@ extern u32 wl12xx_debug_level;
> >  				  CFG_RX_CTL_EN | CFG_RX_BCN_EN |     \
> >  				  CFG_RX_AUTH_EN | CFG_RX_ASSOC_EN)
> >  
> > -#define WL1271_FW_NAME "wl1271-fw.bin"
> > -#define WL1271_NVS_NAME "wl1271-nvs.bin"
> > +#define WL1271_FW_NAME "ti-connectivity/wl1271-fw.bin"
> > +#define WL1271_NVS_NAME "ti-connectivity/wl1271-nvs.bin"
> 
> You're right.  Our firmware is (unfortunately) inside the
> ti-connectivity in linux-firmware.git.  So it would make sense to
> include the ti-connectivity/ directory when requesting for the firmware,
> but it's just damn ugly. :( The driver should not care at all where the
> firmware is to be fetched from, that should be up to the userspace.
> 
> Dunno what is the best thing to do about this.  Add the directory to the
> driver? Move the wl1271*.bin files to the root of linux-firmware? Does
> anybody have opinions about it?

I think there are a number of other drivers with embedded pathnames.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
