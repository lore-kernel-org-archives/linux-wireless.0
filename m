Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:53303 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbZD1XUn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2009 19:20:43 -0400
Received: by ewy24 with SMTP id 24so924025ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 28 Apr 2009 16:20:42 -0700 (PDT)
Message-ID: <49F78F40.1060904@gmail.com> (sfid-20090429_012049_518961_EF5AE872)
Date: Wed, 29 Apr 2009 01:20:32 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: reinette chatre <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: 2.6.30-rc3: iwlagn probe timeouts (regression)
References: <49F4F5B1.4020201@gmail.com> <1240852777.29221.6.camel@rc-desk>	 <49F76DF2.5070704@gmail.com>	 (sfid-20090428_225846_755730_3AFA4A12)  <1240954959.593.5.camel@johannes.local>	 (sfid-20090428_234319_487972_6219E84E) <1240955255.593.7.camel@johannes.local>
In-Reply-To: <1240955255.593.7.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/28/2009 11:47 PM, Johannes Berg wrote:
> On Tue, 2009-04-28 at 23:42 +0200, Johannes Berg wrote:
>
>   
>> Ok, that's confusing. It doesn't even change any code that is normally
>> executed, at least not significantly since local->user_power_level is
>> usually 0; checking
>> 	if (local->user_power_level)
>> vs. checking
>> 	if (local->user_power_level >= 0)
>> shouldn't make a difference in that case (although I admit that I forgot
>> a few cases in that commit, will fix).
>>
>> Can you please verify that the code behaves correctly if you revert just
>> this commit? Unless you're playing with "iwconfig wlan0 txpower .." I
>> don't see a reason for this to cause a problem.
>>     

Hi Johannes,

Thanks for the help, reverting the commit did indeed fix things for me -
I tested that earlier this evening with the latest git kernel...
>
> Scratch that, try this patch instead. Sorry, stupid mistake! mac80211
> never asks the driver to set a txpower level, and keeps the variable set
> to 0, but the driver looks at it anyway. Bug on both accounts, I guess,
> but mac80211 should set the variable and tell the driver anyway.
>   
and so does your patch, although I had to patch by hand, as my version
of the file still looked like this:

   local->hw.conf.long_frame_max_tx_count = 4;
   local->hw.conf.short_frame_max_tx_count = 7;
   local->hw.conf.radio_enabled = true;
+   local->user_power_level = -1;

Can I more or less bargain that this fix will make in in time before the
final 2.6.30 kernel is released? (Sorry, I'm just not certain how the
rules work around test cycles that may be involved, if any for such a
trivial issue)

Regards,
Niel
