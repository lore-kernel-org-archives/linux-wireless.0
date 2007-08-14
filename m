Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:42212 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753938AbXHNReg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 13:34:36 -0400
Message-ID: <46C1E790.3020807@lwfinger.net>
Date: Tue, 14 Aug 2007 12:34:08 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: [patch 0/7] SSB: New patch series for merge
References: <200708141900.31273.mb@bu3sch.de>
In-Reply-To: <200708141900.31273.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> Hi John,
> 
> This patch series catches SSB up to my
> current wireless-development patchset.
> 
> Please merge this into wireless-dev ssb branch.

I had a problem with #7. My copy of John's tree still has EXPERIMENTAL for ssb. Yours does not.

The differences are:

--- ../ssb_patch7_from_MB       2007-08-14 12:27:51.000000000 -0500
+++ patches/ssb_patch7_works  2007-08-14 12:26:31.000000000 -0500
@@ -15,7 +15,7 @@
  +
   config SSB
         tristate "Sonics Silicon Backplane support"
--      depends on HAS_IOMEM
+-      depends on EXPERIMENTAL && HAS_IOMEM
  +      depends on SSB_POSSIBLE
         help
  -        Support for the Sonics Silicon Backplane bus
@@ -50,12 +50,12 @@

  +config SSB_PCMCIAHOST_POSSIBLE
  +      bool
-+      depends on SSB && PCMCIA && EXPERIMENTAL
++      depends on SSB && PCMCIA
  +      default y
  +
   config SSB_PCMCIAHOST
-       bool "Support for SSB on PCMCIA-bus host (EXPERIMENTAL)"
--      depends on SSB && PCMCIA && EXPERIMENTAL
+       bool "Support for SSB on PCMCIA-bus host"
+-      depends on SSB && PCMCIA
  +      depends on SSB_PCMCIAHOST_POSSIBLE
         help
           Support for a Sonics Silicon Backplane on top
