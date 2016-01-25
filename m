Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:59939 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933013AbcAYPzR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2016 10:55:17 -0500
Message-ID: <1453737313.30130.39.camel@collabora.co.uk> (sfid-20160125_165609_980973_E25D2B4D)
Subject: Re: [PATCH] brcmfmac: sdio: Increase the default timeouts a bit
From: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
To: Arend van Spriel <aspriel@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: Paul Stewart <pstew@chromium.org>,
	Doug Anderson <dianders@chromium.org>,
	linux-rockchip@lists.infradead.org,
	Arend van Spriel <arend@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hante Meuleman <meuleman@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>, netdev@vger.kernel.org,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	linux-mmc@vger.kernel.org
Date: Mon, 25 Jan 2016 16:55:13 +0100
In-Reply-To: <56A64114.3010400@gmail.com>
References: <1453718849-3508-1-git-send-email-sjoerd.simons@collabora.co.uk>
	 <56A64114.3010400@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-01-25 at 16:36 +0100, Arend van Spriel wrote:
> On 25-01-16 11:47, Sjoerd Simons wrote:
> > On a Radxa Rock2 board with a Ampak AP6335 (Broadcom 4339 core) it
> > seems
> > the card responds very quickly most of the time, unfortunately
> > during
> > initialisation it sometimes seems to take just a bit over 2 seconds
> > to
> > respond.
> > 
> > This results intialization failing with message like:
> >   brcmf_c_preinit_dcmds: Retreiving cur_etheraddr failed, -52
> >   brcmf_bus_start: failed: -52
> >   brcmf_sdio_firmware_callback: dongle is not responding
> > 
> > Increasing the timeout to allow for a bit more headroom allows the
> > card to initialize reliably.
> 
> I would prefer to know where the 2 second response time comes from.
> Could be sdio retuning. Maybe the chromeos people can comment whether
> this has been root caused.

The only reference i could find for where the timeout came from was in
the bcmdhd which has:
  #define IOCTL_RESP_TIMEOUT  2000  /* In milli second default value
for Production FW */

But not sure if that's helpful :). 


> There is a mmc patch pending in which retuning procedure can be
> deferred
> by the driver. Using that API may resolve the issue as well and I
> would
> prefer that solution.
> 
> > A quick search online after diagnosing/fixing this showed that
> > Google
> > has a similar patch in their ChromeOS tree, so this doesn't seem
> > specific to the board I'm using.
> 
> As the retuning stuff is not in main line I guess we need this fix
> for
> now so...
> 
> Acked-by: Arend van Spriel <arend@broadcom.com>
> > Signed-off-by: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
> > 
> > ---
> Still would like to know whether it is firmware initialization or
> some
> mmc stack procedure. Any suggestions to debug this are welcome.
> 
> Regards,
> Arend
> ---
> > 
> >  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git
> > a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> > b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> > index dd66143..75ac4bd 100644
> > --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> > +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> > @@ -45,8 +45,8 @@
> >  #include "chip.h"
> >  #include "firmware.h"
> >  
> > -#define DCMD_RESP_TIMEOUT	msecs_to_jiffies(2000)
> > -#define CTL_DONE_TIMEOUT	msecs_to_jiffies(2000)
> > +#define DCMD_RESP_TIMEOUT	msecs_to_jiffies(2500)
> > +#define CTL_DONE_TIMEOUT	msecs_to_jiffies(2500)
> >  
> >  #ifdef DEBUG
> >  
> > 

-- 
Sjoerd Simons
Collabora Ltd.
