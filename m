Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:27282 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbYDNKOm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2008 06:14:42 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: Alternative Libertas SDIO driver seen
Date: Mon, 14 Apr 2008 12:11:43 +0200
Cc: claud_yu <claud_yu@yahoo.com.tw>,
	"Harvey, Timothy" <tharvey@irobot.com>, feng.tang@intel.com,
	linux-wireless@vger.kernel.org
References: <252063.3227.qm@web72209.mail.tp2.yahoo.com>
In-Reply-To: <252063.3227.qm@web72209.mail.tp2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="big5"
Message-Id: <200804141211.43539.hs4233@mail.mn-solutions.de> (sfid-20080414_111459_860753_BEB78F3E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 14 April 2008 11:12:38 claud_yu wrote:
> Hi ,
>
> Currently I use wi2wi W2SW0001, I send Murata module
> back. I still try to port the libertas driver to mx31.
> Wi2Wi provide a SD card development card on wi2wi
> website. I also try another 88w8686 driver from
> project moblin (http://www.moblin.org/). The driver
> should based on marvell SDIO driver. But the driver
> still have some problem while firmware download.

Okay, I find a kernel tree there which, in 
debian/patches/0019-marvell_8686_8688.patch contains another 
libertas driver.

Unfortunately, the (Intel created) moblin.org webpage only 
supports the "http://" access protocol to the git tree, which is 
rather inefficent. I'm currently trying to get this tree 
with "git clone --reference /usr/src/linux-git 
http://www.moblin.org/repos/projects/kernel-mid-2.6.24.git/", 
and takes ages. Maybe they also made this tree from scratch, so 
that the reference to Linus' git tree won't help the 
downloading.



Okay, to the driver:

* it's GPL, so we can copy from it
* it's an if_sdio.c only-driver (and also contains something
   with bluetooth stuff)
* it's weird, as this patch contains two wlan_11.c files
  which differ. This is true for effectively every wlan_XXX.c
  file.
* it looks similar to what Marvell donated originally to OLPC
* compared to the current in-kernel libertas driver, it has
  some more code for 802.11a frequencies
* older Marvell drivers contained firmware as *.h files, this
  driver now uses #include <linux/firmware.h> as well

As this driver is sdio-only, and we have already other libertas 
drivers supported in the kernel, it would never accepted as-is 
in mainland kernel. Therefore I invite Marvell and Intel to 
participate with the in-kernel libertas driver. I understand 
that for Intel this might not be possible immediately, because 
the current libertas driver might not work on their 
Atom-reference platform, but I guess in the long-run could be 
beneficial.

I CC'ed feng tang from "git log 
debian/patches/0019-marvell_8686_8688.patch" therefore :-)
