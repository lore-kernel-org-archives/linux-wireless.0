Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.molgen.mpg.de ([141.14.17.11]:41724 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755093AbdLTLAw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Dec 2017 06:00:52 -0500
Subject: Re: UBSAN: Undefined behaviour in
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c:838:5
To: Luca Coelho <luca@coelho.fi>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        it+linux-wireless@molgen.mpg.de
References: <75bc638e-99a8-2f3f-6260-491f8a018af6@molgen.mpg.de>
 <1513175552.4827.365.camel@intel.com> <1513621815.4827.430.camel@coelho.fi>
From: Paul Menzel <pmenzel+linux-wireless@molgen.mpg.de>
Message-ID: <a08aa1b3-9d75-2f38-a0f0-aefe181137da@molgen.mpg.de> (sfid-20171220_120130_394009_703881DC)
Date: Wed, 20 Dec 2017 12:00:48 +0100
MIME-Version: 1.0
In-Reply-To: <1513621815.4827.430.camel@coelho.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Luca,


Am 18.12.2017 um 19:30 schrieb Luca Coelho:
> On Wed, 2017-12-13 at 16:32 +0200, Luciano Coelho wrote:
>> On Wed, 2017-12-13 at 14:25 +0100, Paul Menzel wrote:

>>> I enabled the undefined behavior sanitizer, and built Linus’ 
>>> master branch under Ubuntu 17.10 with gcc (Ubuntu 7.2.0-8ubuntu3)
>>> 7.2.0.
>>> 
>>> ``` $ grep UBSAN /boot/config-4.15.0-rc3+ 
>>> CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y #
>>> CONFIG_ARCH_WANTS_UBSAN_NO_NULL is not set CONFIG_UBSAN=y 
>>> CONFIG_UBSAN_SANITIZE_ALL=y # CONFIG_UBSAN_ALIGNMENT is not set 
>>> CONFIG_UBSAN_NULL=y ```
>>> 
>>> Starting the system the messages below are printed.
>>> 
>>> Starting the system and using the wireless device shows the 
>>> messages below.
>> 
>> Thanks for reporting! This shouldn't cause any problems, but I'll
>> fix it by checking that the mac80211_queue is not INVALID_QUEUE
>> (255) which seems to be the trigger for this warning.
> 
> Can you try the following patch to see if the problem goes away?
> 
> http://pastebin.coelho.fi/7b624f474846da52.txt

Thank you. The warning is gone now. Thank you. For the next time, it’d 
be great to provide the output of `git format-patch -1`, which can be 
applied with `git am`. The output of `git show` is with my knowledge 
hard to apply.


Kind regards,

Paul
