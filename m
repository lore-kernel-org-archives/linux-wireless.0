Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:2743 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbZCFA0S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2009 19:26:18 -0500
Message-ID: <49B06DA6.7070000@canonical.com> (sfid-20090306_012621_686521_7AC3E406)
Date: Thu, 05 Mar 2009 17:26:14 -0700
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: reinette chatre <reinette.chatre@intel.com>,
	"stable@kernel.org" <stable@kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Please apply to stable: cfg80211: add support for custom firmware
 	regulatory solutions
References: <43e72e890903041335n47a70186u4a7aeb304f8b6979@mail.gmail.com>	 <1236275668.6612.134.camel@rc-desk>	 <43e72e890903051124t42ce5c7blfd741da4a2b4fa79@mail.gmail.com>	 <49B056FA.2020605@canonical.com> <43e72e890903051513n44cf5281y32cc11e06754aa3@mail.gmail.com>
In-Reply-To: <43e72e890903051513n44cf5281y32cc11e06754aa3@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> On Thu, Mar 5, 2009 at 2:49 PM, Tim Gardner <tim.gardner@canonical.com> wrote:
>> Luis R. Rodriguez wrote:
>>> On Thu, Mar 5, 2009 at 9:54 AM, reinette chatre
>>> <reinette.chatre@intel.com> wrote:
>>>> On Wed, 2009-03-04 at 13:35 -0800, Luis R. Rodriguez wrote:
>>>>> Forgot to Cc: stable@kernel.org for this patch during its submission,
>>>>> this is needed on 2.6.28 as otherwise there is an issue for Intel
>>>>> cards which get their channels 5 GHz disabled if OLD_REG is set to no
>>>>> (this is not the default) or the channels 12-14 are disabled if
>>>>> OLD_REG is set to yes (default) set to no and the ieee80211_module
>>>>> parameter is not used. The later issue is resolved by userspace as
>>>>> well but we cannot yet expect 2.6.28 kernels to have enough userspace
>>>>> interfaces to set the regulatory domain just yet. This is why OLD_REG
>>>>> is still set to default with 2.6.28.
>>>>>
>>>>> 14b9815af3f4fe0e171ee0c4325c31d2a2c1570b
>>>>> Author: Luis R. Rodriguez <lrodriguez@atheros.com>
>>>>> Date:   Wed Nov 12 14:22:03 2008 -0800
>>>>>
>>>>>    cfg80211: add support for custom firmware regulatory solutions
>>>>>
>>>>>    This adds API to cfg80211 to allow wireless drivers to inform
>>>>>    us if their firmware can handle regulatory considerations *and*
>>>>>    they cannot map these regulatory domains to an ISO / IEC 3166
>>>>>    alpha2. In these cases we skip the first regulatory hint instead
>>>>>    of expecting the driver to build their own regulatory structure,
>>>>>    providing us with an alpha2, or using the reg_notifier().
>>>>>
>>>>>    Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>>>>>    Acked-by: Zhu Yi <yi.zhu@intel.com>
>>>>>    Signed-off-by: John W. Linville <linville@tuxdriver.com>
>>>> Could you please also add commit
>>>> ea4a82dceec7b5782b1259079c8de508d0afe33a? This is the commit that
>>>> enables the Intel cards to take advantage of the parameter introduced in
>>>> previous commit.
>>>>
>>>> commit ea4a82dceec7b5782b1259079c8de508d0afe33a
>>>> Author: Luis R. Rodriguez <lrodriguez@atheros.com>
>>>> Date:   Wed Nov 12 14:22:04 2008 -0800
>>>>
>>>>    iwlwifi: enable custom fw regulatory solution
>>>>
>>>>    This enables the custom firmware regulatory solution option
>>>>    on iwlwifi drivers. These devices are uncapable of mapping their
>>>>    EEPROM regulatory domain to a specific ISO / IEC alpha2.
>>>>    Although the new 11n devices (>= iwl 5000) have only
>>>>    3 regultaory SKUs -- MOW, ABG (no N) and BG -- the older
>>>>    devices (3945 and 4965) have a more complex SKU arrangement
>>>>    and therefore its not practical to move this to the driver.
>>>>
>>>>    Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>>>>    Acked-by: Zhu Yi <yi.zhu@intel.com>
>>>>    Signed-off-by: John W. Linville <linville@tuxdriver.com>
>>> Doh yes that would be required or it would make this pointless.
>>>
>>>   Luis
>>>
>> Looks like it requires a preparatory commit:
>>
>> commit f3b407fba52e1b86ca286ee7c218a4fb00bd29e0
>> Author: Johannes Berg <johannes@sipsolutions.net>
>> Date:   Tue Oct 21 09:57:41 2008 +0200
>>
>>    wireless: remove cfg80211_reg_mutex
>>
>>    This mutex is wrong, we use cfg80211_drv_mutex (which should
>>    possibly be renamed to just cfg80211_mutex) everywhere except
>>    in one place, fix that and get rid of the extra mutex.
>>
>>    Also get rid of a spurious regulatory_requests list definition.
>>
>>    Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>>    Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> Ah crap. This may be too much for stable. Did you get a hang without
> it? Or is it not applying cleanly? If the later then a port may be
> required.
> 
>   Luis

I spoke too soon. Its doesn't compile even with
f3b407fba52e1b86ca286ee7c218a4fb00bd29e0 applied.

What is the downside of just turning OLD_REG back on for 2.6.28?

rtg
-- 
Tim Gardner tim.gardner@canonical.com
