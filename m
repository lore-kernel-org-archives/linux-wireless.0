Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:33467 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbZKHTfh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 14:35:37 -0500
Received: by mail-ew0-f207.google.com with SMTP id 3so2544885ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 11:35:43 -0800 (PST)
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 8/9] rt2800: add eFuse EEPROM support code to rt2800lib
Date: Sun, 8 Nov 2009 20:34:58 +0100
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <20091108133854.23584.86842.sendpatchset@localhost.localdomain> <200911081947.53754.bzolnier@gmail.com> <200911082025.48707.IvDoorn@gmail.com>
In-Reply-To: <200911082025.48707.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <200911082034.59006.bzolnier@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 08 November 2009 20:25:48 Ivo van Doorn wrote:
> > > > > The purpose of the defines was to keep the EFUSE code out of the driver
> > > > > on embedded systems. So either rt2800lib should do the same with ifdefs
> > > > > in the rt2800lib.c and rt2800lib.h files, or we don't need the efuse specific
> > > > > wrappers in rt2800pci.c.
> > > > 
> > > > Said wrappers predate all of my rt2800 patches.
> > > 
> > > Actually the code inside the function was larger, since you removed multiple
> > > lines from the function (moved to rt2800lib). But as said above, the wrapper
> > > had the code inside the ifdef, while the this patch has the code outside the
> > > ifdef, and thus the wrapper has no need.
> > > 
> > > > I think that they shouldn't have been added in the first place and I'll be
> > > > happy to add patch removing them to rt2800 tree (since code savings seem to
> > > > be really marginal and not worth the maintenance cost). 
> > > 
> > > Removing the ifdefs entirely would be fine.
> > 
> > Like I said before -- this would mean driver's behavior change.  Even though
> > WISOC code is currently dead (RALINK_RT288X and RALINK_RT305X are never set)
> > I prefer to not "overload" patches with logically different changes.
> 
> The code is not really dead. RALINK_RT288X and RALINK_RT305X are platforms which
> are currently present in another tree, it is not the job for rt2x00 to set those defines.
> I don't know when these platforms will be merged upstream, nor do I know the status of them.

They are not really our problem then and said tree should maintain
RALINK_RT[288X,305X] specific changes itself. :)

> > If you feel strongly about it please fix it in rt2x00 code and rt2800 tree
> > will deal with it, or alternatively please send me an incremental patch.
> 
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

Thanks, I'll merge it later to rt2800.

-- 
Bartlomiej Zolnierkiewicz
