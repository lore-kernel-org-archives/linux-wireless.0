Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45663 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab0GLNpT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jul 2010 09:45:19 -0400
Date: Mon, 12 Jul 2010 09:43:36 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Philip Prindeville <philipp_subx@redfish-solutions.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Ath5k breaking in ath5k_pci_suspend_compat going on 2 weeks
Message-ID: <20100712134335.GA2442@tuxdriver.com>
References: <4C3926F7.5070606@redfish-solutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4C3926F7.5070606@redfish-solutions.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 10, 2010 at 08:05:43PM -0600, Philip Prindeville wrote:
> This still seems to be broken, a couple of weeks later:
> 
>   CC [M]  /home/philipp/kernel/build_i586/compat-wireless-2010-06-26/drivers/net/wireless/ath/ath5k/attach.o
>   CC [M]  /home/philipp/kernel/build_i586/compat-wireless-2010-06-26/drivers/net/wireless/ath/ath5k/base.o
> /home/philipp/kernel/build_i586/compat-wireless-2010-06-26/drivers/net/wireless/ath/ath5k/base.c:243: error: 'ath5k_pci_suspend_compat' undeclared here (not in a function)
> /home/philipp/kernel/build_i586/compat-wireless-2010-06-26/drivers/net/wireless/ath/ath5k/base.c:244: error: 'ath5k_pci_resume_compat' undeclared here (not in a function)
> make[6]: *** [/home/philipp/kernel/build_i586/compat-wireless-2010-06-26/drivers/net/wireless/ath/ath5k/base.o] Error 1
> make[5]: *** [/home/philipp/kernel/build_i586/compat-wireless-2010-06-26/drivers/net/wireless/ath/ath5k] Error 2
> make[4]: *** [/home/philipp/kernel/build_i586/compat-wireless-2010-06-26/drivers/net/wireless/ath] Error 2
> make[3]: *** [/home/philipp/kernel/build_i586/compat-wireless-2010-06-26/drivers/net/wireless] Error 2
> 
> 
> and from today's tarball:
> 
> 
>   CC [M]  /home/philipp/kernel/build_i586/compat-wireless-2010-07-10/drivers/net/wireless/ath/ath5k/base.o
> /home/philipp/kernel/build_i586/compat-wireless-2010-07-10/drivers/net/wireless/ath/ath5k/base.c:243: error: 'ath5k_pci_suspend_compat' undeclared here (not in a function)
> /home/philipp/kernel/build_i586/compat-wireless-2010-07-10/drivers/net/wireless/ath/ath5k/base.c:244: error: 'ath5k_pci_resume_compat' undeclared here (not in a function)
> make[6]: *** [/home/philipp/kernel/build_i586/compat-wireless-2010-07-10/drivers/net/wireless/ath/ath5k/base.o] Error 1
> make[5]: *** [/home/philipp/kernel/build_i586/compat-wireless-2010-07-10/drivers/net/wireless/ath/ath5k] Error 2
> make[4]: *** [/home/philipp/kernel/build_i586/compat-wireless-2010-07-10/drivers/net/wireless/ath] Error 2
> make[3]: *** [/home/philipp/kernel/build_i586/compat-wireless-2010-07-10/drivers/net/wireless] Error 2
> 
> 
> Can someone please have a look and fix their regression?

Judging from the function names, this seems like a compat-specific
patch.  Judging from the type of build failure, I would suspect that
those functions are defined inside of a #ifdef block somewhere and
need empty definitions for use for the opposite configuration.

Perhaps you could use my cursory analysis as a starting point for
investigating the source of the build failure?  And propose a patch?
Or at the least you might figure-out how to change your build
configuration to avoid the issue.

Good luck!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
