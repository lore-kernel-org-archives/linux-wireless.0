Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61334 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab2DRDF5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 23:05:57 -0400
Received: by iagz16 with SMTP id z16so9808290iag.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Apr 2012 20:05:57 -0700 (PDT)
Message-ID: <4F8E2F92.7010102@lwfinger.net> (sfid-20120418_050601_178447_7FFF4B8F)
Date: Tue, 17 Apr 2012 22:05:54 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John W Linville <linville@tuxdriver.com>, ilw@linux.intel.com,
	wey-yi.w.guy@intel.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: Fix compile when CONFIG_IWLWIFI_DEBUG is not
 defined
References: <4f8dfa7b.3JI0H3iulrLPUzPs%Larry.Finger@lwfinger.net>  (sfid-20120418_011958_143805_CDD81257) <1334715794.3725.39.camel@jlt3.sipsolutions.net>
In-Reply-To: <1334715794.3725.39.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/17/2012 09:23 PM, Johannes Berg wrote:
> On Tue, 2012-04-17 at 18:19 -0500, Larry Finger wrote:
>> If CONFIG_IWLWIFI_DEBUG is not defined, the following error results when
>> compiling iwlwifi:
>>
>>    CC [M]  drivers/net/wireless/iwlwifi/iwl-agn-tt.o
>> In file included from drivers/net/wireless/iwlwifi/iwl-agn-tt.c:40:0:
>> drivers/net/wireless/iwlwifi/iwl-core.h:97:19: error: static declaration of ‘iwl_alloc_traffic_mem’ follows non-static declaration
>> drivers/net/wireless/iwlwifi/iwl-agn.h:513:5: note: previous declaration of ‘iwl_alloc_traffic_mem’ was here
>> make[4]: *** [drivers/net/wireless/iwlwifi/iwl-agn-tt.o] Error 1
>> make[3]: *** [drivers/net/wireless/iwlwifi] Error 2
>> make[2]: *** [drivers/net/wireless] Error 2
>> make[1]: *** [drivers/net] Error 2
>> make: *** [drivers] Error 2
>
> Totally fine with me. We have a pending patch to completely remove that
> functionality though :-)

Until your patch hits the tree, mine will allow everyone to build the driver.

Larry


