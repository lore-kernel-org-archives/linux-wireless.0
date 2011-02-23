Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:53705 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752615Ab1BWOyb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Feb 2011 09:54:31 -0500
Received: by mail-ww0-f50.google.com with SMTP id 26so7961466wwf.7
        for <linux-wireless@vger.kernel.org>; Wed, 23 Feb 2011 06:54:29 -0800 (PST)
Subject: Re: [PATCH] WLAN: fix the path to the wl12xx firmwares
From: Luciano Coelho <coelho@ti.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Sebastien Jan <s-jan@ti.com>, linux-wireless@vger.kernel.org
In-Reply-To: <20110223144134.GA2729@tuxdriver.com>
References: <1298467516-9092-1-git-send-email-s-jan@ti.com>
	 <1298471599.2104.44.camel@pimenta>  <20110223144134.GA2729@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Feb 2011 16:54:25 +0200
Message-ID: <1298472865.2104.48.camel@pimenta>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-02-23 at 09:41 -0500, John W. Linville wrote:
> > > diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
> > > index 9050dd9..8ceb6a0 100644
> > > --- a/drivers/net/wireless/wl12xx/wl12xx.h
> > > +++ b/drivers/net/wireless/wl12xx/wl12xx.h
> > > @@ -112,8 +112,8 @@ extern u32 wl12xx_debug_level;
> > >                               CFG_RX_CTL_EN | CFG_RX_BCN_EN |     \
> > >                               CFG_RX_AUTH_EN | CFG_RX_ASSOC_EN)
> > >  
> > > -#define WL1271_FW_NAME "wl1271-fw.bin"
> > > -#define WL1271_NVS_NAME "wl1271-nvs.bin"
> > > +#define WL1271_FW_NAME "ti-connectivity/wl1271-fw.bin"
> > > +#define WL1271_NVS_NAME "ti-connectivity/wl1271-nvs.bin"
> > 
> > You're right.  Our firmware is (unfortunately) inside the
> > ti-connectivity in linux-firmware.git.  So it would make sense to
> > include the ti-connectivity/ directory when requesting for the firmware,
> > but it's just damn ugly. :( The driver should not care at all where the
> > firmware is to be fetched from, that should be up to the userspace.
> > 
> > Dunno what is the best thing to do about this.  Add the directory to the
> > driver? Move the wl1271*.bin files to the root of linux-firmware? Does
> > anybody have opinions about it?
> 
> I think there are a number of other drivers with embedded pathnames.

Indeed.  And, as discussed with Johannes on IRC, the / will be just one
more character in the FW name, regardless of whether it means a
subdirectory or not.  It's just part of the FW name string.

When I apply the patch, I just need to brace for the loads of people
complaining that the FW cannot be found anymore and explain the issue a
hundred times. ;)

-- 
Cheers,
Luca.

