Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:33467 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbZKHTfP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 14:35:15 -0500
Received: by ewy3 with SMTP id 3so2544885ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 11:35:19 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 8/9] rt2800: add eFuse EEPROM support code to rt2800lib
Date: Sun, 8 Nov 2009 20:35:17 +0100
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <20091108133854.23584.86842.sendpatchset@localhost.localdomain> <200911081947.53754.bzolnier@gmail.com> <200911082021.32455.bzolnier@gmail.com>
In-Reply-To: <200911082021.32455.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200911082035.18197.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > > > I think that they shouldn't have been added in the first place and I'll be
> > > > happy to add patch removing them to rt2800 tree (since code savings seem to
> > > > be really marginal and not worth the maintenance cost). 
> > > 
> > > Removing the ifdefs entirely would be fine.
> > 
> > Like I said before -- this would mean driver's behavior change.  Even though
> > WISOC code is currently dead (RALINK_RT288X and RALINK_RT305X are never set)
> > I prefer to not "overload" patches with logically different changes.
> > 
> > If you feel strongly about it please fix it in rt2x00 code and rt2800 tree
> > will deal with it, or alternatively please send me an incremental patch.
> 
> BTW the patch's impact is _320_ bytes increase of rt2800lib (on x86-64 so
> it is probably much less on the affected embedded architectures):
> 
>    text	   data	    bss	    dec	    hex	filename
> before:
>   16916	      0	      0	  16916	   4214	drivers/net/wireless/rt2x00/rt2800lib.o
> after:
>   17281	      0	      0	  17281	   4381	drivers/net/wireless/rt2x00/rt2800lib.o
> 
> for the _completely_ dead code (because embedded WISOC support is never
> enabled) that probably will be changed over anyway later during development.

As mentioned: Wisoc is not dead code, it is there for the platform devices with
integrated rt2800 chipsets. If you look at KConfig you can see the
RALINK_RT288X RALINK_RT305X are dependencies from configuration options...

> IOW something like this is completely not worth to be worried about
> and I would personally just skip it during review to not waste people's
> time needlessly..

Well dependencies from/on other drivers is something important...

Ivo
