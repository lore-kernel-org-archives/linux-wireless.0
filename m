Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:59620 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751480AbdIEQlT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Sep 2017 12:41:19 -0400
Date: Tue, 5 Sep 2017 18:41:04 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: kernel test robot <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, wfg@linux.intel.com
Subject: Re: 915f3e3f76 ("mac80211_hwsim: Replace bogus hrtimer clockid"):
 BUG: kernel reboot-without-warning in test stage
Message-ID: <20170905164103.tkrhxzca4b5ulps2@breakpoint.cc> (sfid-20170905_184221_316527_ED0E0E13)
References: <59ade247.WzhbxWeytBOa6Xu4%fengguang.wu@intel.com>
 <alpine.DEB.2.20.1709050910150.1900@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <alpine.DEB.2.20.1709050910150.1900@nanos>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-09-05 09:12:40 [+0200], Thomas Gleixner wrote:
> Sorry, no. That bisect is completely bogus. The commit in question merily
> replaces the unsupported clockid with a valid one.

The bisect is correct. It just has problems to express itself properly. So
the table says:

| WARNING:at_kernel/time/hrtimer.c:#hrtimer_init  | 7   |     |    |   |                                                                                
| BUG:kernel_reboot-without-warning_in_test_stage | 0   | 12  | 6  | 6 |                                                                                

which means _before_ your commit it counted a warning in hrtimer_init()
(an unsupported clock id was used). With your commit, the warning was
gone and I *think* the userland then printed
"BUG:kernel_reboot-without-warning_in_test_stage" because it had no
warning.
It seems that the bot learned to live with that warning which was around
for more than three years. Now that you removed it, it seems to be a
mistake to do so because nobody complained about it so far.

> Thanks,
> 
> 	tglx

Sebastian
