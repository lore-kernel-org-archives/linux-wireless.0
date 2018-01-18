Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:49628 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752955AbeARVJ3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Jan 2018 16:09:29 -0500
Subject: Re: [PATCH] cfg80211: stop demanding lots of new stuff
To: Hugh Dickins <hughd@google.com>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <alpine.LSU.2.11.1801171448510.5433@eggly.anvils>
 <1516258057.410.55.camel@sipsolutions.net>
 <alpine.LSU.2.11.1801181242280.14771@eggly.anvils>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <4eface89-e34a-c71a-a240-1a4015160508@infradead.org> (sfid-20180118_220948_061375_93F6A187)
Date: Thu, 18 Jan 2018 13:09:26 -0800
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.11.1801181242280.14771@eggly.anvils>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/18/2018 01:07 PM, Hugh Dickins wrote:
> On Thu, 18 Jan 2018, Johannes Berg wrote:
>> On Wed, 2018-01-17 at 14:55 -0800, Hugh Dickins wrote:
>>> "make oldconfig" from 4.14 (when CONFIG_CFG80211_CERTIFICATION_ONUS
>>> is not set) to 4.15-rc, gets into asking lots of new questions, and
>>> configuring in unwanted stuff: I'm unsure of my Kconfig skills, but
>>> it looks like CFG80211_REQUIRE_SIGNED_REGDB's "default y" needs to
>>> be toned down when we don't even have CFG80211_CERTIFICATION_ONUS.
>>
>> No, this is wrong - we want default configurations to be able to load a
>> signed regulatory database and validate the signature.
> 
> Great to enable that, but not so great to force new stuff on everyone.
> It doesn't surprise me at all if the patch here is the wrong one,
> but something needs to be done differently in this configuration.
> 
> Perhaps you did not try on a system without SYSTEM_DATA_VERIFICATION
> already enabled - that "select SYSTEM_DATA_VERIFICATION" seems to be
> taking effect even when CFG80211_REQUIRE_SIGNED_REGDB is not enabled,
> and pulls in a boatload.  I agree that seems strange: perhaps the
> Kconfig problem is somewhere else entirely.
> 
> Attached my old 4.14 config, so you can see for yourself - thanks.

NOT attached.....................................


> In fact, I cannot even build the resulting config, without scurrying
> around to update userspace with stuff I never needed before:
> 
>   HOSTCC  scripts/extract-cert
> scripts/extract-cert.c:21:25: fatal error: openssl/bio.h: No such file or directory
> 
> Hugh
> 
>>
>> johannes
>>
>>>
>>> Signed-off-by: Hugh Dickins <hughd@google.com>
>>> ---
>>>
>>>  net/wireless/Kconfig |    2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> --- 4.15-rc8/net/wireless/Kconfig	2017-12-03 10:22:51.928845056 -0800
>>> +++ linux/net/wireless/Kconfig	2018-01-14 19:20:22.595472965 -0800
>>> @@ -89,7 +89,7 @@ config CFG80211_CERTIFICATION_ONUS
>>>  
>>>  config CFG80211_REQUIRE_SIGNED_REGDB
>>>  	bool "require regdb signature" if CFG80211_CERTIFICATION_ONUS
>>> -	default y
>>> +	default CFG80211_CERTIFICATION_ONUS
>>>  	select SYSTEM_DATA_VERIFICATION
>>>  	help
>>>  	  Require that in addition to the "regulatory.db" file a


-- 
~Randy
