Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51116 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1760072AbdLRSaU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Dec 2017 13:30:20 -0500
Message-ID: <1513621815.4827.430.camel@coelho.fi> (sfid-20171218_193121_016606_F373F961)
From: Luca Coelho <luca@coelho.fi>
To: Paul Menzel <pmenzel+linux-wireless@molgen.mpg.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        it+linux-wireless@molgen.mpg.de
Date: Mon, 18 Dec 2017 20:30:15 +0200
In-Reply-To: <1513175552.4827.365.camel@intel.com>
References: <75bc638e-99a8-2f3f-6260-491f8a018af6@molgen.mpg.de>
         <1513175552.4827.365.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: UBSAN: Undefined behaviour in
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c:838:5
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-12-13 at 16:32 +0200, Luciano Coelho wrote:
> On Wed, 2017-12-13 at 14:25 +0100, Paul Menzel wrote:
> > Dear Linux folks,
> > 
> > 
> > I enabled the undefined behavior sanitizer, and built Linus’
> > master 
> > branch under Ubuntu 17.10 with gcc (Ubuntu 7.2.0-8ubuntu3) 7.2.0.
> > 
> > ```
> > $ grep UBSAN /boot/config-4.15.0-rc3+
> > CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
> > # CONFIG_ARCH_WANTS_UBSAN_NO_NULL is not set
> > CONFIG_UBSAN=y
> > CONFIG_UBSAN_SANITIZE_ALL=y
> > # CONFIG_UBSAN_ALIGNMENT is not set
> > CONFIG_UBSAN_NULL=y
> > ```
> > 
> > Starting the system the messages below are printed.
> > 
> > Starting the system and using the wireless device shows the
> > messages
> > below.
> 
> Thanks for reporting! This shouldn't cause any problems, but I'll fix
> it by checking that the mac80211_queue is not INVALID_QUEUE (255)
> which seems to be the trigger for this warning.

Can you try the following patch to see if the problem goes away?

http://pastebin.coelho.fi/7b624f474846da52.txt

Thanks!

--
Cheers,
Luca.
