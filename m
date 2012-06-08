Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:33542 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751724Ab2FHGur (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 02:50:47 -0400
Received: by laap9 with SMTP id p9so1165056laa.36
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 23:50:45 -0700 (PDT)
Message-ID: <1339138243.7078.139.camel@cumari.coelho.fi> (sfid-20120608_085051_294206_8C211AEA)
Subject: Re: [PATCH 5/5] wlcore/wl12xx/wl18xx: make NVS file optional for
 wl18xx
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, coelho@ti.com
Date: Fri, 08 Jun 2012 09:50:43 +0300
In-Reply-To: <CA+XVXffU=rWHUAGpuyJh5ZFb0oRigWwYYOycJP7eF+CD4YypLQ@mail.gmail.com>
References: <1339137055-30095-1-git-send-email-coelho@ti.com>
	 <1339137055-30095-6-git-send-email-coelho@ti.com>
	 <CA+XVXffU=rWHUAGpuyJh5ZFb0oRigWwYYOycJP7eF+CD4YypLQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(added the list back)

On Fri, 2012-06-08 at 09:43 +0300, Arik Nemtsov wrote:
> On Fri, Jun 8, 2012 at 9:30 AM, Luciano Coelho <coelho@ti.com> wrote:
> > From: Arik Nemtsov <arik@wizery.com>
> >
> > Don't spew errors when we can't find the NVS file in wlcore. Instead
> > fail the wl12xx boot HW op if the NVS isn't found.
> >
> > Take this opportunity to remove some dead code from register_hw()
> > which looks for the NVS again needlessly.
> >
> > Signed-off-by: Arik Nemtsov <arik@wizery.com>
> > Signed-off-by: Luciano Coelho <coelho@ti.com>
> > ---
> >  drivers/net/wireless/ti/wlcore/boot.c |    4 +++-
> >  drivers/net/wireless/ti/wlcore/main.c |   22 ++++++----------------
> >  2 files changed, 9 insertions(+), 17 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ti/wlcore/boot.c b/drivers/net/wireless/ti/wlcore/boot.c
> > index ed718f7..7b8e61e 100644
> > --- a/drivers/net/wireless/ti/wlcore/boot.c
> > +++ b/drivers/net/wireless/ti/wlcore/boot.c
> > @@ -211,8 +211,10 @@ int wlcore_boot_upload_nvs(struct wl1271 *wl)
> >        u32 dest_addr, val;
> >        u8 *nvs_ptr, *nvs_aligned;
> >
> > -       if (wl->nvs == NULL)
> > +       if (wl->nvs == NULL) {
> > +               wl1271_error("NVS file is need during boot");
> 
> Can you fix this message as well? need -> needed (or you can reformat
> it completely).

Okay, I'll fix it before applying the patches.  Thanks!

--
Luca.

