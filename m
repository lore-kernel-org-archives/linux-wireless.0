Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:3668 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752864AbdLMOcg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Dec 2017 09:32:36 -0500
Message-ID: <1513175552.4827.365.camel@intel.com> (sfid-20171213_153304_199120_B54CF8F8)
Subject: Re: UBSAN: Undefined behaviour in
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c:838:5
From: Luciano Coelho <luciano.coelho@intel.com>
To: Paul Menzel <pmenzel+linux-wireless@molgen.mpg.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        it+linux-wireless@molgen.mpg.de
Date: Wed, 13 Dec 2017 16:32:32 +0200
In-Reply-To: <75bc638e-99a8-2f3f-6260-491f8a018af6@molgen.mpg.de>
References: <75bc638e-99a8-2f3f-6260-491f8a018af6@molgen.mpg.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-12-13 at 14:25 +0100, Paul Menzel wrote:
> Dear Linux folks,
> 
> 
> I enabled the undefined behavior sanitizer, and built Linus’ master 
> branch under Ubuntu 17.10 with gcc (Ubuntu 7.2.0-8ubuntu3) 7.2.0.
> 
> ```
> $ grep UBSAN /boot/config-4.15.0-rc3+
> CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
> # CONFIG_ARCH_WANTS_UBSAN_NO_NULL is not set
> CONFIG_UBSAN=y
> CONFIG_UBSAN_SANITIZE_ALL=y
> # CONFIG_UBSAN_ALIGNMENT is not set
> CONFIG_UBSAN_NULL=y
> ```
> 
> Starting the system the messages below are printed.
> 
> Starting the system and using the wireless device shows the messages
> below.

Thanks for reporting! This shouldn't cause any problems, but I'll fix
it by checking that the mac80211_queue is not INVALID_QUEUE (255) which
seems to be the trigger for this warning.

--
Cheers,
Luca.
