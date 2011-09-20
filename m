Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:37348 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab1ITWkl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 18:40:41 -0400
Date: Tue, 20 Sep 2011 15:40:23 -0700
From: Andrew Morton <akpm@google.com>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH -next] bcma: needs export.h
Message-Id: <20110920154023.c90396d8.akpm@google.com> (sfid-20110921_004057_164423_C36CAF5F)
In-Reply-To: <CACna6rxGrd-ORWZrc0xsAOKptU_Xj3eGh9qSfX9vJYCPTZrCRg@mail.gmail.com>
References: <20110920173102.d38155c7defbbc29beaae7c0@canb.auug.org.au>
	<4E78CFC0.4020003@xenotime.net>
	<CACna6rxGrd-ORWZrc0xsAOKptU_Xj3eGh9qSfX9vJYCPTZrCRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 20 Sep 2011 20:45:57 +0200
Rafa__ Mi__ecki <zajec5@gmail.com> wrote:

> 2011/9/20 Randy Dunlap <rdunlap@xenotime.net>:
> > From: Randy Dunlap <rdunlap@xenotime.net>
> >
> > bcma/driver_chipcommon_pmu.c needs to include <linux/export.h>,
> > so add it to the headers that are included by bcma_private.h.
> 
> Please take a look at discussion in:
> [PATCH -next] bcma: main.c needs to include <linux/slab.h>
> thread (by Andrew).
> 
> I believe that according to the discussion, such a includes should be
> done in .c files.
> 
> Andrew: can you comment? Am I right?

Ordinarily, yes, it is preferable to include the needed .h files from
within the .c files.  However quite a mumber of kernel subsystems do
take the #include "everything.h" approach.

However, drivers/bcma is a bit odd in that it has bcma_private.h which
includes delay.h (the everything.h approach) but most .c files
explicitly include other things, including export.h.

There's no real pattern here and yes, I agree that the minimal and more
typical approach is better.

--- a/drivers/bcma/driver_chipcommon_pmu.c~bcma-needs-exporth
+++ a/drivers/bcma/driver_chipcommon_pmu.c
@@ -10,6 +10,7 @@
 
 #include "bcma_private.h"
 #include <linux/bcma/bcma.h>
+#include <linux/export.h>
 
 static u32 bcma_chipco_pll_read(struct bcma_drv_cc *cc, u32 offset)
 {
_

