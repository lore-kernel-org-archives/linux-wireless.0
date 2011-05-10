Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45566 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab1EJTxf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 15:53:35 -0400
Message-ID: <4DC997B9.2080400@candelatech.com> (sfid-20110510_215349_790205_EB9FDA2E)
Date: Tue, 10 May 2011 12:53:29 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath5k:  Fix lockup due to un-init spinlock.
References: <1304720674-27031-1-git-send-email-greearb@candelatech.com> <20110510194211.GG2520@tuxdriver.com>
In-Reply-To: <20110510194211.GG2520@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/10/2011 12:42 PM, John W. Linville wrote:
> When applied to wireless-2.6, I get this:
>
>    CC [M]  drivers/net/wireless/ath/ath5k/base.o
> drivers/net/wireless/ath/ath5k/base.c: In function ‘ath5k_init_softc’:
> drivers/net/wireless/ath/ath5k/base.c:2357:2: error: ‘struct ath5k_softc’ has no member named ‘irqlock’
> drivers/net/wireless/ath/ath5k/base.c:2357:2: error: ‘struct ath5k_softc’ has no member named ‘irqlock’
>
> Is this only for -next?

This is against wireless-testing.  Maybe I was confused about this being in 2.6.39-rcX.

Bug was caused by this commit as far as I can tell:

Author: Felix Fietkau <nbd@openwrt.org>  2011-04-10 09:32:19
Committer: John W. Linville <linville@tuxdriver.com>  2011-04-12 13:59:27
Parent: 5b7916ad8c29da9f30fbf03a8b61862acdba00ce (ath5k: clean up debugfs code)
Child:  8962d87129ec0a820d17ac44cbf3f51010ad8db8 (ath5k: improve comments for optimized tx descriptor setup)
Child:  1d4af019d920c838e4de81afa0b5d67879090fd5 (Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next-2.6)
Branches: master, remotes/origin/master
Follows: v2.6.37-rc1
Precedes:


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

