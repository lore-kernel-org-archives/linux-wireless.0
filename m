Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:17595 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbZGSNEU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jul 2009 09:04:20 -0400
Message-ID: <4A6319AA.7050700@nokia.com>
Date: Sun, 19 Jul 2009 16:03:38 +0300
From: Luciano Coelho <luciano.coelho@nokia.com>
MIME-Version: 1.0
To: ext Kalle Valo <kalle.valo@iki.fi>
CC: Bob Copeland <me@bobcopeland.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC PATCH v2 0/8] wl1251 sdio interface
References: <20090717184643.25883.95065.stgit@tikku> <87r5wfp1v4.fsf@litku.valot.fi>
In-Reply-To: <87r5wfp1v4.fsf@litku.valot.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ext Kalle Valo wrote:
> Kalle Valo <kalle.valo@iki.fi> writes:
>
>   
>> Here is v2 of Bob's wl1251 sdio patches. I have now rebased them on
>> top of wl1251/wl1271 split patches. Only compile-tested because I
>> don't have working test setup right now (neither spi or sdio), but I
>> should have access to one in two weeks.
>>     
>
> I forgot to mention that wl1251 most probably is still broken regards to
> bssid handling. I will fix this after my (current) vacation, unless
> someone else is faster. To get wl1251 temporarily working, this patch
> must be reverted:
>   

Wow! This is just what I needed to know.  I have been struggling the 
whole of last week trying to figure out why the wl1271 driver that I'm 
planning to submit doesn't work with the latest wireless-testing.  I've 
been using the wl1251 from wireless-testing as a reference and I was 
running out of ideas as to why wl1251 was working and my version of the 
wl1271 wasn't.  So, it's very good to know that wl1251 isn't working 
either :)

This is the only thing that is currently preventing me from submitting 
the wl1271 code.  Obviously I want to make sure that it works before 
sending it for inclusion in wireless-testing...

>     commit cc3ec8cb518534c1c593e5f2682710d33c903627
>     Author: Johannes Berg <johannes@sipsolutions.net>
>     Date:   Thu May 14 13:10:14 2009 +0200
>
>     mac80211: fix managed mode BSSID handling
>     
>     Currently, we will ask the driver to configure right away
>     when somebody changes the desired BSSID. That's totally
>     strange because then we will configure the driver without
>     even knowing whether the BSS exists. Change this to only
>     configure the BSSID when associated, and configure a zero
>     BSSID when not associated.
>
> Oddly enough I can't find this patch anymore in wireless-testing, I
> could only find a revert. I don't know what happened to it.
>   

The original patch *is* there, but it has been reverted.  In any case, I 
noticed that the change introduced by this patch is there, so I guess 
some other patch has replaced it later.

Now I need to read the archives of the linux-wireless mailing list to 
figure out exactly what has changed and what I need to do to get wl1271 
to work with the new API.  Or is anyone willing to give me a brief 
summary of what the driver is expected to do with the new API? (yeah, 
it's a sunny Sunday and I'm a bit lazy today :P)

-- 
Cheers,
Luca.

