Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:51475 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbZKHR7V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 12:59:21 -0500
Received: by ey-out-2122.google.com with SMTP id 25so32267eya.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 09:59:26 -0800 (PST)
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] rt2x00: Mark rt2800pci as broken.
Date: Sun, 8 Nov 2009 18:20:18 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
References: <1257679734-25160-1-git-send-email-gwingerde@gmail.com> <200911081338.34697.bzolnier@gmail.com>
In-Reply-To: <200911081338.34697.bzolnier@gmail.com>
MIME-Version: 1.0
Message-Id: <200911081820.18251.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 08 November 2009 13:38:34 Bartlomiej Zolnierkiewicz wrote:

> On Sunday 08 November 2009 12:28:54 Gertjan van Wingerde wrote:
> > The rt2800pci driver is currently only marked as experimental, and only the help text explains that
> > the driver is basically non-functional. Make the driver depend on CONFIG_BROKEN so that users cannot
> > enable this driver without knowing that it is broken.
> > 
> > Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> 
> > @@ -78,9 +78,6 @@ config RT2800PCI
> >  	  This adds support for rt2800 wireless chipset family.
> >  	  Supported chips: RT2760, RT2790, RT2860, RT2880, RT2890 & RT3052
> >  
> > -	  This driver is non-functional at the moment and is intended for
> > -	  developers.
> > -
> >  	  When compiled as a module, this driver will be called "rt2800pci.ko".
> >  
> >  config RT2500USB
> 
> This help text could have stayed, anyway..
> 
> Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

It turned out that CONFIG_BROKEN is no longer an user visible option so by
applying this change we would lose the advantage of having the upstream build
testing and early detection of breakages related to upstream API updates.

[ I've just noticed now that rt2800pci was no longer included in the build
  and dropped the patch from rt2800 tree. ]

-- 
Bartlomiej Zolnierkiewicz
