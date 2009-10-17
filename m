Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:33296 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbZJQOyc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Oct 2009 10:54:32 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 2/2] rt2x00: Implement support for rt2800pci
Date: Sat, 17 Oct 2009 16:54:03 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Alban Browaeys <prahal@yahoo.com>,
	Benoit PAPILLAULT <benoit.papillault@free.fr>,
	Felix Fietkau <nbd@openwrt.org>,
	Luis Correia <luis.f.correia@gmail.com>,
	Mattias Nissler <mattias.nissler@gmx.de>,
	Mark Asselstine <asselsm@gmail.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>,
	"linux-kernel" <linux-kernel@vger.kernel.org>
References: <200910152137.58164.IvDoorn@gmail.com> <200910152204.16407.IvDoorn@gmail.com>
In-Reply-To: <200910152204.16407.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200910171654.03344.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


[ I somehow missed this one by not being on cc: ]

On Thursday 15 October 2009 22:04:14 Ivo van Doorn wrote:
> Add support for the rt2860/rt3090 chipsets from Ralink.
> 
> Includes various patches from a lot of people who helped
> getting this driver into the current shape.
> 
> Signed-off-by: Alban Browaeys <prahal@yahoo.com>
> Signed-off-by: Benoit PAPILLAULT <benoit.papillault@free.fr>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Signed-off-by: Luis Correia <luis.f.correia@gmail.com>
> Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
> Signed-off-by: Mark Asselstine <asselsm@gmail.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> ---
> http://kernel.org/pub/linux/kernel/people/ivd/patches/0003-rt2x00-Implement-support-for-rt2800pci.patch

First let me say that I'm very happy to see this patch finally being
submitted and I appreciate the effort..

(I'll give it a spin on Eee 901 w/ 2.6.32-rc5 sometime later..)


Now to the less happy part..

I also used the opportunity to take a closer look at this driver and
it seems that it needlessly adds around 2 KLOC to kernel by duplicating
the common content of rt2800usb.h to rt2800pci.h instead of moving it
to the shared header (like it is done in the staging crap drivers):

$ wc -l drivers/net/wireless/rt2x00/rt2800usb.h drivers/net/wireless/rt2x00/rt2800pci.h
  1951 drivers/net/wireless/rt2x00/rt2800usb.h
  1960 drivers/net/wireless/rt2x00/rt2800pci.h
  3911 total

$ diff -u drivers/net/wireless/rt2x00/rt2800usb.h drivers/net/wireless/rt2x00/rt2800pci.h|diffstat
 rt2800pci.h |  213 +++++++++++++++++++++++++++++++-----------------------------
  1 file changed, 111 insertions(+), 102 deletions(-)

Similarly it looks like most of the code between rt2800usb.c and rt2800pci.c
could also be shared (up to another 2 KLOC saved) by adding abstraction layer
for accessing chipset registers over different buses (again like it is done
in staging crap drivers):

$ wc -l drivers/net/wireless/rt2x00/rt2800usb.c drivers/net/wireless/rt2x00/rt2800pci.c
  3077 drivers/net/wireless/rt2x00/rt2800usb.c
  3323 drivers/net/wireless/rt2x00/rt2800pci.c
  6400 total

$ diff -u drivers/net/wireless/rt2x00/rt2800usb.c drivers/net/wireless/rt2x00/rt2800pci.c|diffstat
 rt2800pci.c | 2190 +++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 1218 insertions(+), 972 deletions(-)

[ for better visualization of issues raised diffs themselves are available at:
  http://kernel.org/pub/linux/kernel/people/bart/rt2800/ ]

All in all, the total amount of the kernel code needed for implementing
rt2800pci functionality should 1-2 KLOC instead of the current 5 KLOC.
