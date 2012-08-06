Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58817 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756297Ab2HFUdR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 16:33:17 -0400
Message-ID: <50202A06.7090308@hauke-m.de> (sfid-20120806_223320_883608_8E99FAB8)
Date: Mon, 06 Aug 2012 22:33:10 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ben Hutchings <bhutchings@solarflare.com>
Subject: Re: [PATCH v2] compat: deal with backported codel
References: <1344095900.5982.0.camel@jlt3.sipsolutions.net> <1344162581.4513.1.camel@jlt3.sipsolutions.net> <CAB=NE6XLMTwG65EhExSES-rPsKK7SDBx4+MgwqxuJL__ZtN=zw@mail.gmail.com>
In-Reply-To: <CAB=NE6XLMTwG65EhExSES-rPsKK7SDBx4+MgwqxuJL__ZtN=zw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/06/2012 09:53 PM, Luis R. Rodriguez wrote:
> On Sun, Aug 5, 2012 at 3:29 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> From: Johannes Berg <johannes.berg@intel.com>
>>
>> Some distro kernels (in particular the Debian 3.2.0-3
>> kernel I'm running) backport codel already, so trying
>> to backport it again causes issues. Protect the compat
>> backport with #ifdef TCA_CODEL_MAX.
>>
>> Also link the flow_dissector code into the codel module
>> which then won't be loaded on kernels that already have
>> codel backported.
>>
>> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> 
> Applied and pushed, thanks!
> 
>   Luis
> 
This breaks my build if net/codel.h is not in the kernel headers:

In file included from
/home/hauke/compat-wireless/compat-wireless/compat/sch_fq_codel_core.c:27:0:
/home/hauke/compat-wireless/compat-wireless/include/net/codel.h:5:28:
fatal error: net/codel.h: No such file or directory
compilation terminated.

TCA_CODEL_MAX is defined in include/linux/compat-3.5.h and this file is
included ever time, so the check around #include_next <net/codel.h> is
never false.

You could define something like COMPAT_CODEL_BACKPORT in
include/linux/compat-3.5.h and extend the check in include/net/codel.h
that this has to be unset.

Hauke
