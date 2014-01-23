Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:51767 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbaAWUH4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 15:07:56 -0500
Received: by mail-we0-f175.google.com with SMTP id p61so1767946wes.34
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jan 2014 12:07:55 -0800 (PST)
Message-ID: <52E17698.9070607@gmail.com> (sfid-20140123_210805_844227_4CE9A91C)
Date: Thu, 23 Jan 2014 22:07:52 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: Petko Manolov <petkan@nucleusys.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
Subject: Re: iwlwifi crash with 3.13
References: <20140123091659.GE9077@localhost> <0BA3FCBA62E2DC44AF3030971E174FB303D56D70@HASMSX103.ger.corp.intel.com> <20140123123125.GA3424@localhost> <0BA3FCBA62E2DC44AF3030971E174FB303D57045@HASMSX103.ger.corp.intel.com> <20140123200045.GA4064@localhost>
In-Reply-To: <20140123200045.GA4064@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 01/23/2014 10:00 PM, Petko Manolov wrote:
> On 14-01-23 12:45:30, Grumbach, Emmanuel wrote:
>>>
>>> Ok - thanks.
>>> Can I see the output of
>>>
>>> cat /sys/kernel/debug/iwlwifi/*/iwlmvm/nvm_sw | hexdump | head -5
>>>
> 
> I don't have iwlwifi entry in /sys/kernel/debug.  My kernel is probably missing some config switches.
> 
>> If it easier - you can also reload the module and add debug=0x1:
> 
> Well, it wasn't easier.  I got multiple "invalid module parameter" sort of error before i realized CONFIG_IWLWIFI_DEBUG should be on. ;)
> 
>> modprobe iwlwifi debug=0x1.
> 
> Attached is the dmesg output.  It is 'xz' compressed as it was 150KB hog.

Unfortunately, I can't see the loading of iwlwifi.

> 
>> Note that you first need to unload iwlmvm, then, unload iwlwifi. After that you can reload iwlwifi.
>> I prefer the debufgs line above though, I'll get a bit more information.
> 
> Mgh, no such entry.  If you can point me as to what else i need to enable in my kernel config...
> 

Doesn't matter any more - I found the issue.
