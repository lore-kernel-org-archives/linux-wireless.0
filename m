Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:52481 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751183AbZE1SDk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2009 14:03:40 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: "libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 28 May 2009 11:03:40 -0700
Subject: RE: [PATCH 3/4 v2] libertas: implement function init/shutdown
 commands for SD8688
Message-ID: <477F20668A386D41ADCC57781B1F704301E888DD76@SC-VEXCH1.marvell.com>
References: <1243465413-4997-1-git-send-email-bzhao@marvell.com>
 <1243495232.16631.5.camel@localhost.localdomain>
In-Reply-To: <1243495232.16631.5.camel@localhost.localdomain>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -----Original Message-----
> From: Marcel Holtmann [mailto:marcel@holtmann.org]
> Sent: Thursday, May 28, 2009 12:21 AM
> To: Bing Zhao
> Cc: libertas-dev@lists.infradead.org; linux-wireless@vger.kernel.org
> Subject: Re: [PATCH 3/4 v2] libertas: implement function init/shutdown commands for SD8688
> 
> Hi Bing,
> 
> > SD8688 is a WLAN/Bluetooth combo chip and both functions are supported
> > in a single firmware image. FUNC_INIT and FUNC_SHUTDOWN commands are
> > implemented to utilize the multiple function feature.
> >
> > When SD8688 card is inserted, the firmware image should be downloaded
> > only once through either WLAN function (Libertas driver) or Bluetooth
> > function (Bluetooth driver).
> >
> > This patch adds function init/shutdown for SD8688 WLAN function only.
> >
> > Signed-off-by: Bing Zhao <bzhao@marvell.com>
> > ---
> >  drivers/net/wireless/libertas/host.h    |    2 +
> >  drivers/net/wireless/libertas/if_sdio.c |   43 +++++++++++++++++++++++++++++-
> >  2 files changed, 43 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
> > index 8ff8ac9..fe8f0cb 100644
> > --- a/drivers/net/wireless/libertas/host.h
> > +++ b/drivers/net/wireless/libertas/host.h
> > @@ -86,6 +86,8 @@
> >  #define CMD_MESH_CONFIG_OLD			0x00a3
> >  #define CMD_MESH_CONFIG				0x00ac
> >  #define	CMD_SET_BOOT2_VER			0x00a5
> > +#define	CMD_FUNC_INIT				0x00a9
> > +#define	CMD_FUNC_SHUTDOWN			0x00aa
> >  #define CMD_802_11_BEACON_CTRL			0x00b0
> >
> >  /* For the IEEE Power Save */
> > diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
> > index e998c12..84fef6b 100644
> > --- a/drivers/net/wireless/libertas/if_sdio.c
> > +++ b/drivers/net/wireless/libertas/if_sdio.c
> > @@ -39,8 +39,12 @@
> >  #include "decl.h"
> >  #include "defs.h"
> >  #include "dev.h"
> > +#include "cmd.h"
> >  #include "if_sdio.h"
> >
> > +/* set this flag in if_sdio_exit_module() if user removes this module */
> > +static u8 user_rmmod;
> > +
> 
> what is this suppose to be doing? There is no description in the commit
> messages or the code. And it looks pretty hackish to me.
> 
> Regards
> 
> Marcel
> 


Hi Marcel,

I'm using this flag as the indication of module removal.

I have to distinguish these scenarios and handle them differently:
(1) user unplugs the card: As the card is unplugged, there is no way (no need) to send SHUTDOWN command.
(2) user removes the libertas_sdio module manually: Since the card is still in the slot, SHUTDOWN command will be sent to firmware.

When user rmmod the module, if_sdio_exit_module() is called and this flag "user_rmmod" is set to 1. When if_sdio_remove() is called this flag will be used to determine whether the SHUTDOWN command should be sent or not.

I hesitated to use this global variable in such a weird way. But I couldn't think of a better solution.

Thanks,

Bing

