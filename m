Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.237]:17693 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbYCJWWI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2008 18:22:08 -0400
Received: by qb-out-0506.google.com with SMTP id o24so135635qba.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Mar 2008 15:22:05 -0700 (PDT)
To: Franz Apeltauer <franz.apeltauer@gmx.at>
Subject: Re: 2 compile errors: rt2x00firmware.c and mesh.c
Date: Mon, 10 Mar 2008 23:21:35 +0100
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
References: <47CB3B5E.4020701@gmx.at> <43e72e890803071859r2788075cp12272cad0920d2b0@mail.gmail.com> <47D5AAFC.80401@gmx.at>
In-Reply-To: <47D5AAFC.80401@gmx.at>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803102321.35909.IvDoorn@gmail.com> (sfid-20080310_222529_445463_C9853DA0)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 10 March 2008, Franz Apeltauer wrote:
> Luis R. Rodriguez schrieb:
> >>  b) Test on a PC with MSI PC54G2 ... RaLink rt2500
> > 
> > You can test this now, I've enabled rt2x00 drivers by fixing
> > dependencies on config.mk. Forced re-generation of new tarball based
> > on latest updates too.
> > 
> >   Luis
> 
> Loaded today's tarball (10.3.).
> The "redefinition of rt2x00lib_load_firmware" error is back.
> 
> I believe, that there should be 2 additional lines in rt2x00firmware.c:
> a) line #115, before "int rt2x00lib_load_firmware":
>      #ifdef CONFIG_RT2X00_LIB_FIRMWARE
> b) at the end of the file:
>      #endif /* CONFIG_RT2X00_LIB_FIRMWARE */
> to be consistent with #ifdef/#else/#endif in rt2x00lib.h lines 124, 127, 
> 135.
> Then it compiles fine. install, unload, load.
> ... and now I see wlan0 and wmaster0!  Yippee!

How about not linking rt2x00firmware.c at all when RT2X00_LIB_FIRMWARE
is not set? That should be a clean solution that can be made in the Makefile...

Ivo
