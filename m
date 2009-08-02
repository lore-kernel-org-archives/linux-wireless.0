Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from imr-da03.mx.aol.com ([205.188.105.145]:47782 "EHLO
	imr-da03.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbZHBBsZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2009 21:48:25 -0400
Message-ID: <4A74EEB2.6040400@netscape.net>
Date: Sat, 01 Aug 2009 19:41:06 -0600
From: Patrick Simmons <linuxrocks123@netscape.net>
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: mb@bu3sch.de, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, dsd@gentoo.org, kune@deine-taler.de
Subject: Re: [PATCH] Fix SPARC64 unaligned access in zd_mac_rx
References: <1249029583.29587.46.camel@johannes.local>	<20090731.222350.254918321.davem@davemloft.net>	<200908011240.17229.mb@bu3sch.de> <20090801.091207.217317135.davem@davemloft.net>
In-Reply-To: <20090801.091207.217317135.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Miller wrote:
> From: Michael Buesch <mb@bu3sch.de>
> Date: Sat, 1 Aug 2009 12:40:16 +0200
> 
>> On Saturday 01 August 2009 07:23:50 David Miller wrote:
>>> From: Johannes Berg <johannes@sipsolutions.net>
>>> Date: Fri, 31 Jul 2009 10:39:43 +0200
>>>
>>>> On Fri, 2009-07-31 at 01:59 -0600, Patrick Simmons wrote:
>>>>> I'm running zd1211rw on SPARC64 and was getting a lot of "unaligned 
>>>>> access" messages in dmesg.  I tracked the problem down to this line, and 
>>>>> changing the cast to a memcpy fixes the issue.
>>>>>  
>>>>> -       fc = *(__le16 *)buffer;
>>>>> +       memcpy(&fc,buffer,sizeof(__le16));
>>>>>         need_padding = ieee80211_is_data_qos(fc) ^ ieee80211_has_a4(fc);
>>>> Please use get_unaligned instead.
>>> And, more specifically, one of the endian get_unaligned variants.
>> No. fc is supposed to be LE.
> 
> Ok, I see.

Revised patch below.

Signed-off-by: Patrick Simmons <linuxrocks123@netscape.net>

--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -694,7 +694,7 @@
                         && !mac->pass_ctrl)
                 return 0;

-       fc = *(__le16 *)buffer;
+       fc = get_unaligned(buffer);
         need_padding = ieee80211_is_data_qos(fc) ^ ieee80211_has_a4(fc);

         skb = dev_alloc_skb(length + (need_padding ? 2 : 0));


-- 
If I'm not here, I've gone out to find myself.  If I get back before I 
return, please keep me here.
