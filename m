Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:41851 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762132Ab0HFWxS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Aug 2010 18:53:18 -0400
Message-ID: <4C5C9252.7040007@bu3sch.de>
Date: Sat, 07 Aug 2010 00:53:06 +0200
From: =?ISO-8859-1?Q?Michael_B=FCsch?= <mb@bu3sch.de>
MIME-Version: 1.0
To: stable@kernel.org, Christoph Fritz <chf.fritz@googlemail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
CC: b43-dev <b43-dev@lists.infradead.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: ssb: 2.6.34.1 -> 2.6.34.2 regression
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The SPROM changes applied to SSB in 2.6.34.2 completely broke SPROM
extraction. This leads to broken wireless for my BCM4306 card.
All other BCM43xx and BCM44xx most likely are affected, too.
Symptoms should be wrong MAC addresses and broken transmission (for 43xx).

The patch changed the SPEX() macro and removed the offset subtraction,
but did not remove the actual 0x1000 offset from the SPROM defines.
This results in random memory poking rather than proper SPROM data
extraction.

I applied the following to my kernel to get it working again. However
this is not a proper fix. I suggest that the -stable SSB patch
is dropped and mainline patches being applied. They seem to
be correct (However I did not test mainline, yet).


Index: linux-2.6.34/drivers/ssb/pci.c
===================================================================
--- linux-2.6.34.orig/drivers/ssb/pci.c	2010-08-05 23:26:07.000000000 +0200
+++ linux-2.6.34/drivers/ssb/pci.c	2010-08-07 00:17:26.000000000 +0200
@@ -169,7 +169,7 @@ err_pci:
  }

  /* Get the word-offset for a SSB_SPROM_XXX define. */
-#define SPOFF(offset)	((offset) / sizeof(u16))
+#define SPOFF(offset)	(((offset) - SSB_SPROM_BASE1) / sizeof(u16))
  /* Helper to extract some _offset, which is one of the SSB_SPROM_XXX 
defines. */
  #define SPEX16(_outvar, _offset, _mask, _shift)	\
  	out->_outvar = ((in[SPOFF(_offset)] & (_mask)) >> (_shift))
-- 
Greetings Michael.
