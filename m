Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:49896 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751473AbXCEBrW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2007 20:47:22 -0500
Date: Mon, 5 Mar 2007 02:47:24 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, linville@tuxdriver.com
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: 2.6.21-rc2-mm1: drivers/net/wireless/ compile error
Message-ID: <20070305014724.GM3441@stusta.de>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20070302030026.5eef0c92.akpm@linux-foundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 02, 2007 at 03:00:26AM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-mm2:
>...
>  git-wireless.patch
>...
>  git trees
>...

Multiple copies of the same drivers are a problem:

<--  snip  -->

...
  LD      drivers/net/wireless/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `zd_chip_switch_radio_on':
(.text+0x303b8): multiple definition of `zd_chip_switch_radio_on'
drivers/net/wireless/zd1211rw/built-in.o:(.text+0x1fc): first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_dma_tx_suspend':
(.text+0x128b6): multiple definition of `bcm43xx_dma_tx_suspend'
drivers/net/wireless/bcm43xx/built-in.o:(.text+0x17d94): first defined here
...
make[4]: *** [drivers/net/wireless/built-in.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

