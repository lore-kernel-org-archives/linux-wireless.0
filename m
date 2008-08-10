Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sorrow.cyrius.com ([65.19.161.204]:3489 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218AbYHJMUP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Aug 2008 08:20:15 -0400
Date: Sun, 10 Aug 2008 15:16:56 +0300
From: Martin Michlmayr <tbm@cyrius.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org
Subject: Rewrite SSB DMA API breaks compilation on ARM
Message-ID: <20080810121656.GF2486@deprecation.cyrius.com> (sfid-20080810_142021_753315_346DC565)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Michael,

Your recent change "ssb, b43, b43legacy, b44: Rewrite SSB DMA API"
http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3D=
commitdiff;h=3Df225763a7d6c92c4932dbd528437997078496fcc
breaks compilation on ARM in the following way:

  CC [M]  drivers/net/wireless/b43/main.o
In file included from drivers/net/wireless/b43/b43.h:8,
                 from drivers/net/wireless/b43/main.c:45:
include/linux/ssb/ssb.h: In function =E2=80=98ssb_dma_sync_single_range=
_for_cpu=E2=80=99:
include/linux/ssb/ssb.h:517: error: implicit declaration of function =E2=
=80=98dma_sync_single_range_for_cpu=E2=80=99
include/linux/ssb/ssb.h: In function =E2=80=98ssb_dma_sync_single_range=
_for_device=E2=80=99:
include/linux/ssb/ssb.h:538: error: implicit declaration of function =E2=
=80=98dma_sync_single_range_for_device=E2=80=99
make[4]: *** [drivers/net/wireless/b43/main.o] Error 1

--=20
Martin Michlmayr
http://www.cyrius.com/
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
