Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:28343 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbXKYLAw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Nov 2007 06:00:52 -0500
Received: by ug-out-1314.google.com with SMTP id z38so743800ugc
        for <linux-wireless@vger.kernel.org>; Sun, 25 Nov 2007 03:00:50 -0800 (PST)
Message-ID: <474955E1.30603@gmail.com> (sfid-20071125_110056_077029_279ABB93)
Date: Sun, 25 Nov 2007 12:00:49 +0100
From: drago01 <drago01@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>, Jouni Malinen <j@w1.fi>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	Zhu Yi <yi.zhu@intel.com>
Subject: Re: mac80211 / iwl3945 + dynamic wep (again)
References: <47494851.4070504@gmail.com>	 (sfid-20071125_100303_057404_A213DFC8) <1195987773.4149.214.camel@johannes.berg>
In-Reply-To: <1195987773.4149.214.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Hi,
>
>   
>> First  sorry for the late report, the patches from the old thread fixed 
>> the privacy mismatch issue and now I can connect to a dynamic wep 
>> network. But the connection is not very stable because I get tons of wep 
>> decrypt errors in dmesg (while the connection is working but slow).
>> The same network works fine with ipw3945. Also iwl3945 works fine with 
>> static wep. I tryed the hwcrypt engine (hwcrypt=1) but it did not change 
>> anything.
>> While connectiong with wpa_supplicant I saw that mac80211 does not 
>> support the IW_AUTH_DROP_UNENCRYPTED ioctl while ipw3945 (ieee80211 
>> based) does.
>> Could this be related? ie. mac80211 tryes to decrypt unencrypted frames 
>> instead of dropping them?
>>     
>
> Odd. I'll have to take a look. I recently noticed that mac80211 would
> always *accept* unencrypted frames but it shouldn't try to decrypt them.
>
>   
ok thx, let me now if you need more info / tests.
>> Second problem is that ssid is hidden. I was able to connect to it using 
>> iwl3945 (even with hw_scan) but only with ap_scan=1 (while ap_scan=2 
>> should be used for hidden ssid and thats what nm uses). Non mac80211 
>> based drivers do not work with ap_scan=1 but with ap_scan=2. So this 
>> needs to be fixed somehow so that nm can support both wireless stacks.
>>     
>
> Uh so say that again what works where and what doesn't?
>
>   
sorry for being confusing.
what works:
connect to a hidden ssid with ap_scan=1 in wpa_supplicant.conf
what does not work:
connect to a hidden ssid with ap_scan=2 in wpa_supplicant.conf
---
for non mac80211 drivers its the opposite ie.  ap_scan=2 can connect to 
hidden ssid while ap_scan=1 works
(thats also whats documented in the wpa_supplicant docs and what nm uses).

so NM can't support mac80211 and non mac80211 drivers at the same time 
without ugly hacks due to this issue.
