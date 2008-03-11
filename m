Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:45969 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbYCKVYR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2008 17:24:17 -0400
Date: Tue, 11 Mar 2008 17:24:13 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Franz Apeltauer <franz.apeltauer@gmx.at>,
	linux-wireless@vger.kernel.org
Subject: Re: 2 compile errors: rt2x00firmware.c and mesh.c
Message-ID: <20080311212413.GA4810@ruslug.rutgers.edu> (sfid-20080311_212422_246934_8DDBCDDF)
References: <47CB3B5E.4020701@gmx.at> <43e72e890803071859r2788075cp12272cad0920d2b0@mail.gmail.com> <47D5AAFC.80401@gmx.at> <200803102321.35909.IvDoorn@gmail.com> <20080310233307.GT28995@ruslug.rutgers.edu> <47D5CD59.5050400@gmx.at> <43e72e890803101826m5b7cd55ao9f521a786a36c07@mail.gmail.com> <47D6E649.3010309@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <47D6E649.3010309@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 11, 2008 at 09:06:33PM +0100, Hauke Mehrtens wrote:
> Luis R. Rodriguez schrieb:
> > On Mon, Mar 10, 2008 at 8:07 PM, Franz Apeltauer
> <franz.apeltauer@gmx.at> wrote:
> >> Luis R. Rodriguez schrieb:
> >>
> >>> Frankz, I generated a new tarball with this applied. You can either
> >>  > patch your local tarball with this patch or just download the
> >>  > tarball again.
> >>  >
> >>  >   Luis
> >>  >
> >>  > commit d4097ab3593a721fc1d99823d2442464debf7f09
> >>  > Author: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
> >>  > Date:   Mon Mar 10 19:20:33 2008 -0400
> >>
> >>  Loaded the new tarball.
> >>  It compiles fine.
> >
> > And it works too I hope? :)
> >
> >   Luis
> 
> On my system the tarball is compiling now, on Sunday it does not so,
> with the error mentioned here.
> 
> It tries to find the .config for the kernel at /lib/modules/`uname
> -r`/.config, but it is only at /lib/modules/`uname -r`/build/.config on
> Ubuntu and Fedora systems.

Fixed, you can either apply this patch or download the new tarball
which I just regenerated.

	Luis

diff --git a/config.mk b/config.mk
index b9d537d..f6121e9 100644
--- a/config.mk
+++ b/config.mk
@@ -4,13 +4,13 @@ export
 ## Make sure to have each variable declaration start
 ## in the first column, no whitespace allowed.
 
-ifeq ($(wildcard $(KLIB)/.config),)
+ifeq ($(wildcard $(KLIB_BUILD)/.config),)
 # These will be ignored by compat autoconf
  CONFIG_PCI=y
  CONFIG_USB=y
  CONFIG_PCMCIA=y
 else
-include $(KLIB)/.config
+include $(KLIB_BUILD)/.config
 endif
 
 # Wireless subsystem stuff
