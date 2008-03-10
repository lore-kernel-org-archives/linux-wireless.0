Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50054 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751086AbYCJVle (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2008 17:41:34 -0400
Message-ID: <47D5AAFC.80401@gmx.at> (sfid-20080310_214142_255747_4B58B346)
Date: Mon, 10 Mar 2008 22:41:16 +0100
From: Franz Apeltauer <franz.apeltauer@gmx.at>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: 2 compile errors: rt2x00firmware.c and mesh.c
References: <47CB3B5E.4020701@gmx.at> <1204504331.3917.31.camel@johannes.berg>	 <20080303035222.GP28995@ruslug.rutgers.edu> <47CF28F2.6050509@gmx.at> <43e72e890803071859r2788075cp12272cad0920d2b0@mail.gmail.com>
In-Reply-To: <43e72e890803071859r2788075cp12272cad0920d2b0@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez schrieb:
>>  b) Test on a PC with MSI PC54G2 ... RaLink rt2500
> 
> You can test this now, I've enabled rt2x00 drivers by fixing
> dependencies on config.mk. Forced re-generation of new tarball based
> on latest updates too.
> 
>   Luis

Loaded today's tarball (10.3.).
The "redefinition of rt2x00lib_load_firmware" error is back.

I believe, that there should be 2 additional lines in rt2x00firmware.c:
a) line #115, before "int rt2x00lib_load_firmware":
     #ifdef CONFIG_RT2X00_LIB_FIRMWARE
b) at the end of the file:
     #endif /* CONFIG_RT2X00_LIB_FIRMWARE */
to be consistent with #ifdef/#else/#endif in rt2x00lib.h lines 124, 127, 
135.
Then it compiles fine. install, unload, load.
... and now I see wlan0 and wmaster0!  Yippee!

Thank you very much!
Franz



