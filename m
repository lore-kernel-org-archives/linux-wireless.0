Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:8517 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755655AbXFGAeu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2007 20:34:50 -0400
Message-ID: <4667364A.4040803@linux.intel.com>
Date: Wed, 06 Jun 2007 15:33:46 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: NetDev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: warnings in git-wireless
References: <20070605020614.3f06b2ab.akpm@linux-foundation.org>	<46671E5D.9070304@linux.intel.com> <20070606163534.6a6cffb7.akpm@linux-foundation.org>
In-Reply-To: <20070606163534.6a6cffb7.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrew Morton wrote:
> On Wed, 06 Jun 2007 13:51:41 -0700 James Ketrenos <jketreno@linux.intel.com> wrote:
> 
>>>>  * make C=2 CF=-Wall will complain if you use ARRAY_SIZE on global data
>>>>  */
>>>> #define GLOBAL_ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
>>> This is identical to ARRAY_SIZE.
>>>
>>> And if there's some problem with ARRAY_SIZE then fix ARRAY_SIZE!  Don't go 
>>> off and create some private thing and leave everyone else twisting in the
>>> wind.
>> The code was resolving the sparse warnings.  
> 
...
> Your GLOBAL_ARRAY_SIZE() is, afaict, identical to ARRAY_SIZE().

>From include/linux/kernel.h

#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))

>From drivers/net/wireless/mac80211/iwlwifi/iwl-helpers.h

#define GLOBAL_ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))

The '+ __must_be_array(arr)' part of ARRAY_SIZE was causing sparse to complain 
with:

drivers/net/wireless/mac80211/iwlwifi/base.c:4646:22: error: cannot size expression
...

When I had run my builds, I had restricted the sparse checks to just iwlwifi 
(vs. checking the rest of the kernel).

I just ran it C=2 CF=-Wall against the rest of the kernel and do see other code 
with the same problem, eg:

sound/core/memalloc.c:521:14: error: cannot size expression
...

I had erroneously thought it was just a problem with iwlwifi...

Thanks,
James
