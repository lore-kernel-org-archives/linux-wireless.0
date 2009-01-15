Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f31.google.com ([209.85.219.31]:63305 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755622AbZAOTML (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 14:12:11 -0500
Received: by ewy12 with SMTP id 12so423989ewy.13
        for <linux-wireless@vger.kernel.org>; Thu, 15 Jan 2009 11:12:09 -0800 (PST)
Message-ID: <496F8A83.8000605@gmail.com> (sfid-20090115_201216_841915_FF46AB79)
Date: Thu, 15 Jan 2009 20:12:03 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: Artur Skawina <art.08.09@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
References: <494698AF.4020204@gmail.com> <496D163B.5030307@gmail.com> <496F7887.8070203@gmail.com> <200901151953.49053.chunkeey@web.de>
In-Reply-To: <200901151953.49053.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> On Thursday 15 January 2009 18:55:19 Artur Skawina wrote:
>> Artur Skawina wrote:
>>> Artur Skawina wrote:
>>>>>>> reboots, but locks up after only a few packets go over the hostap driven
>>>>>>> p54usb device. I need the box to be up, that limits the number of tests i can
>>>> after switching from SLUB to SLAB and enabling some debugging i finally caught this:
>>> and slub debugging gave something a bit more useful:
>>>
>>> =============================================================================
>>> BUG kmalloc-4096: Poison overwritten
>> tried reproducing (using the old w-t/pending pull) on different machine,
>> but no oops or crash there...
>> (similar connectivity issues though, such as connecting only works
>> exactly once after starting hostapd, to reconnect i have to restart
>> hostapd)
> hmm, maybe Windows Mobile uses another PS mechanism, e.g WMM-PS.

hmm, i'll have to set up another device to sniff the traffic i guess.

>> Upgraded to current wireless-testing/pending on the problematic box
>> and almost immediately got [1]. No slab corruption this time (at least
>> not yet). Will switch to GFP_ATOMIC and retry w/ the new fw.
>>
>> artur
> yes that's a bug, p54_set_tim must use GFP_ATOMIC, do you want to post the patch?

nah, too trivial :) fwiw i used this:

diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
index 635b423..579bc6c 100644
--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -1295,7 +1295,7 @@ static int p54_set_tim(struct ieee80211_hw *dev, struct ieee80211_sta *sta,
 	struct p54_tim *tim;
 
 	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*tim),
-			    P54_CONTROL_TYPE_TIM, GFP_KERNEL);
+			    P54_CONTROL_TYPE_TIM, GFP_ATOMIC);
 	if (!skb)
 		return -ENOMEM;


Will try to do some more tests in the next few days.

Thanks,

artur
