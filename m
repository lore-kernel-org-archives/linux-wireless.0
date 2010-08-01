Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51067 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975Ab0HAT7p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Aug 2010 15:59:45 -0400
Message-ID: <4C55D22A.5040302@hauke-m.de>
Date: Sun, 01 Aug 2010 21:59:38 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Kshitij Kulshreshtha <kkhere.geo@gmail.com>
CC: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Subject: Re: compat-wireless-2010-07-28.tar.bz2 fails to compile with 2.6.34.1
References: <4C5184E8.30108@gmail.com>
In-Reply-To: <4C5184E8.30108@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 29.07.2010 15:40, schrieb Kshitij Kulshreshtha:
> Hello,
> 
> I downloaded compat-wireless-2010-07-28.tar.bz2 from [1] and tried to
> compile it with kernel v2.6.34.1 (config attached) that is running on
> my laptop currently. Unfortunately the package failed to compile with
> several compilation errors (compilation log attached, grep for Error).
> 
> I had to apply the attached 3 patches to make it compile. Please update
> compat-wireless and compat git trees accordingly.
> 
> Thanks and regards.
> 
> [1] http://wireless.kernel.org/download/compat-wireless-2.6/

Hi Kshitij,

thank you for your patches.

Next time please inline your patches into the mail. It makes commenting
on the patch easier. See:
http://wireless.kernel.org/en/users/Download/hacking#Sending_patches

0001-hex_to_bin-was-added-first-in-2.6.35.patch:
hex_to_bin should be backported in compat. Then we do not need to add an
extra patch to compat-wireless. Patches in compat-wireless are hard to
maintain, because the wireless subsystem changes very often and the
patches have to be fixes very often.

0002-Header-file-pcmcia-cs_types.h-has-been-removed-in-2..patch:
This should also be backported in compat and not in compat-wireless. You
can add include/pcmcia/cistpl.h and include the needed file
(pcmcia/cs_types.h) and the original with #include_next <pcmcia/cistpl.h>

Hauke
