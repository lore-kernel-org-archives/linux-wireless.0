Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:58936 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932847Ab1KCRqr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 13:46:47 -0400
Message-ID: <4EB2D383.8030903@neratec.com> (sfid-20111103_184650_818484_1F7AA0A8)
Date: Thu, 03 Nov 2011 18:46:43 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com
Subject: Re: [RFC v2 2/2] ath9k: integrate initial DFS module
References: <1320328553-28066-1-git-send-email-zefir.kurtisi@neratec.com> <1320328553-28066-3-git-send-email-zefir.kurtisi@neratec.com> <201111031651.46073.chunkeey@googlemail.com> <4EB2CE96.4060702@neratec.com> <4EB2CFB3.2060802@openwrt.org>
In-Reply-To: <4EB2CFB3.2060802@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/03/2011 06:30 PM, Felix Fietkau wrote:
> On 2011-11-03 6:25 PM, Zefir Kurtisi wrote:
>> On 11/03/2011 04:51 PM, Christian Lamparter wrote:
>>>  On Thursday, November 03, 2011 02:55:53 PM Zefir Kurtisi wrote:
>>>>  [...]
>>>  where? There's no kconfig option, yet it has the CONFIG_ perifx.
>>>  So people will be looking for it.
>>>
>>>  This is exactly why I made such a big fuss about CONFIG_XYZ issue last time.
>>>  <http://www.mail-archive.com/ath9k-devel@lists.ath9k.org/msg06825.html>
>>>  Just drop the ifdef.
>>>
>>>
>> Hi Christian,
>>
>> I just followed Luis' request to follow the regulatory statement and
>> make non regulatory certified code unusable by the 'common user'.
>>
>> Therefore, not (yet) selectable as a kconfig option, but for devs and
>> testers to be easily enabled.
>>
>> At this stage, removing the ifdef would not harm, because all the
>> code does is counting events. But for the long run I understand it is
>> a sensitive topic and requires to be disabled (at least as default
>> setting).
> I don't think it's a sensitive topic at all. Just leave out all the ifdef stuff. In the long run when we actually get to the part where we can test a full DFS implementation, the only thing that needs to be left out for normal users is the flag announcing support for it.
> 
> - Felix

Yes, and that's what is done here: just let the HW pretend having no DFS capabilities until enabled.

Anyhow, DFS channels operation is not supported so far (and will be controlled) by hostapd, it's therefore safe to remove the remaining ifdef in v3.


Thanks
Zefir
