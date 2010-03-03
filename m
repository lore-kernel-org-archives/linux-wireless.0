Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f197.google.com ([209.85.211.197]:38295 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380Ab0CCXNW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Mar 2010 18:13:22 -0500
Received: by ywh35 with SMTP id 35so632724ywh.4
        for <linux-wireless@vger.kernel.org>; Wed, 03 Mar 2010 15:13:21 -0800 (PST)
Subject: Re: [PATCH] airo : Print of firmware version
From: Jose Alonso <joalonsof@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: matthieu castet <castet.matthieu@free.fr>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
In-Reply-To: <20100303201411.GF23920@tuxdriver.com>
References: <4B8A80EE.6000102@free.fr>
	 <20100303201411.GF23920@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Mar 2010 20:12:53 -0300
Message-ID: <1267657973.6254.11.camel@laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-03-03 at 15:14 -0500, John W. Linville wrote:
> On Sun, Feb 28, 2010 at 03:42:54PM +0100, matthieu castet wrote:
> > For the firmware version 5.30.17 the log file shows:
> > Firmware version 5.30.11
> >
> > The variable softSubVer is binary.
> >
> >
> > Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
> > Signed-off-by: Jose Alonso <joalonsof@gmail.com>
> 
> > Index: airo.c
> > ===================================================================
> > --- 1/drivers/net/wireless/airo.c	(r?vision 47)
> > +++ 2/drivers/net/wireless/airo.c	(r?vision 48)
> > @@ -2993,7 +2993,7 @@
> >  	ai->wep_capable = (cap_rid.softCap & cpu_to_le16(0x02)) ? 1 : 0;
> >  	ai->max_wep_idx = (cap_rid.softCap & cpu_to_le16(0x80)) ? 3 : 0;
> >  
> > -	airo_print_info(dev->name, "Firmware version %x.%x.%02x",
> > +	airo_print_info(dev->name, "Firmware version %x.%x.%02d",
> >  	                ((le16_to_cpu(cap_rid.softVer) >> 8) & 0xF),
> >  	                (le16_to_cpu(cap_rid.softVer) & 0xFF),
> >  	                le16_to_cpu(cap_rid.softSubVer));
> 
> Why should the last segment be in decimal form if the other two
> segments of the version number are in hexadecimal form?

The airo.c shows the usage of hexadecimal and binary form:

        /* Test for WPA support */
        /* Only firmware versions 5.30.17 or better can do WPA */
        if (le16_to_cpu(cap_rid.softVer) > 0x530
         || (le16_to_cpu(cap_rid.softVer) == 0x530
              && le16_to_cpu(cap_rid.softSubVer) >= 17)) {
                airo_print_info(ai->dev->name, "WPA supported.");


