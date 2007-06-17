Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:28168 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbXFQPtX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jun 2007 11:49:23 -0400
Received: by py-out-1112.google.com with SMTP id a29so2608195pyi
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jun 2007 08:49:22 -0700 (PDT)
Message-ID: <467557E4.7050509@gmail.com>
Date: Sun, 17 Jun 2007 10:48:52 -0500
From: "Jory A. Pratt" <geekypenguin@gmail.com>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: Please pull latest and greatest bcm43xx
References: <200706162017.47516.mb@bu3sch.de>
In-Reply-To: <200706162017.47516.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> John,
>
> Please pull for-linville branch of my tree.
> It contains a lot of bugfixes and makes a _big_ step towards
> mergability for mainline.
> It's not 100% ready for a merge, yet, but we are making good progress.
> The transmission power problems on the 4306, that were one of the big
> merge blockers, seem almost all fixed. I get good performance now.
> I also added lots of txpower debugging stuff so one can actually
> see what's going on and how it's scaling.
> Together with Michael Wu's sta-locking rewrite patch for
> mac80211 we have the most critical merge blockers resolved now.
>
> I'd like people to test this code.
> It will spew a big assertion failure and a stacktrace on loading.
> Ignore that for now. It's known and considered nonfatal for now.
>
>
>
> The following changes since commit 9181e959da76d85d688d8ec763702ed2f3b4edf9:
>   John W. Linville:
>         rt2x00firmware.c: include delay.h to avoid build error on ppc64
>
> are found in the git repository at:
>
>   http://bu3sch.de/git/wireless-dev.git/ for-linville
>
> Michael Buesch:
>       bcm43xx-mac80211: Don't stop the mac80211 software queues in pwork.
>       Merge branch 'master' of git://git.kernel.org/.../linville/wireless-dev
>       bcm43xx-mac80211: Use the mac80211 provided workqueue
>       bcm43xx-mac80211: Fix mutex leakage in pwork.
>       bcm43xx-mac80211: Flush the workqueue to make sure periodic work has finished.
>       bcm43xx-mac80211: Implement runtime debugging mechanism.
>       bcm43xx-mac80211: Code to inject TX ring overflows.
>       bcm43xx-mac80211: Rewrite the attenuation adjustment.
>       Merge branch 'master' of git://git.kernel.org/.../linville/wireless-dev
>       ssb: Fix maxpwr and itssi read.
>       bcm43xx-mac80211: Add more txpower debugging.
>       bcm43xx-mac80211: add debugfs file to manually control txpower
>       bcm43xx-mac80211: Some LO cleanups
>       Merge branch 'master' of git://git.kernel.org/.../linville/wireless-dev
>       bcm43xx-mac80211: Use the dynamic min/max values for adjusting the attenuation.
>
>  drivers/net/wireless/mac80211/bcm43xx/bcm43xx.h    |   29 +
>  .../wireless/mac80211/bcm43xx/bcm43xx_debugfs.c    |  210 +++++++++
>  .../wireless/mac80211/bcm43xx/bcm43xx_debugfs.h    |   21 +
>  .../net/wireless/mac80211/bcm43xx/bcm43xx_dma.c    |   63 +++
>  .../net/wireless/mac80211/bcm43xx/bcm43xx_dma.h    |   10 
>  drivers/net/wireless/mac80211/bcm43xx/bcm43xx_lo.c |  107 ++--
>  drivers/net/wireless/mac80211/bcm43xx/bcm43xx_lo.h |    6 
>  .../net/wireless/mac80211/bcm43xx/bcm43xx_main.c   |   64 +--
>  .../net/wireless/mac80211/bcm43xx/bcm43xx_phy.c    |  515 ++++++++++++-----------
>  .../net/wireless/mac80211/bcm43xx/bcm43xx_phy.h    |   23 +
>  .../net/wireless/mac80211/bcm43xx/bcm43xx_xmit.c   |   18 +
>  .../net/wireless/mac80211/bcm43xx/bcm43xx_xmit.h   |    2 
>  drivers/ssb/pci.c                                  |   12 
>  include/linux/ssb/ssb_regs.h                       |   12 
>  14 files changed, 693 insertions(+), 399 deletions(-)
>
>   
I am pleased with the performance on my pcmcia 4306 by all means now :) 
great work in that department. I test my bcm4318 as well it worked, but 
very unusable bit rate fluxuates so bad that you can not do anything 
consistent. Just want to make sure you know the code has been tested on 
both cards and were it stands ... Once again great work Michael.
