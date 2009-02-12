Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix.szarvasnet.hu ([87.101.127.3]:49469 "EHLO
	phoenix.szarvas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757744AbZBLNdu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2009 08:33:50 -0500
Message-ID: <49942516.2090607@openwrt.org> (sfid-20090212_143354_358923_01172224)
Date: Thu, 12 Feb 2009 14:33:10 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: soft-safe -> soft-unsafe lock order detected
References: <4991AC67.90104@openwrt.org>	 (sfid-20090210_173417_726855_7504F887)  <1234433807.16004.88.camel@johannes.local>	 (sfid-20090212_111736_123131_223B74EE) <1234434246.16004.90.camel@johannes.local>	 <49941C7D.6090600@openwrt.org> <1234444655.1327.3.camel@johannes.local>
In-Reply-To: <1234444655.1327.3.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg =C3=ADrta:
> On Thu, 2009-02-12 at 13:56 +0100, Gabor Juhos wrote:
>> Johannes Berg =C3=ADrta:
>>> On Thu, 2009-02-12 at 11:16 +0100, Johannes Berg wrote:
>>>>> to a soft-irq-unsafe lock:
>>>>>  (todo_lock){--..}
>>>>> ... which became soft-irq-unsafe at:
>>>>> ...  [<800b2248>] __lock_acquire+0x624/0x844
>>>>>   [<800b24c4>] lock_acquire+0x5c/0x84
>>>>>   [<8006b8c4>] _spin_lock+0x34/0x48
>>>>>   [<c0206d9c>] ieee80211_set_default_key+0x4b8/0x4f0 [mac80211]
>>>> That seems to be incorrect. ieee80211_set_default_key will have
>>>> _irqsave-locked the key lock, so the todo lock is here always lock=
ed in
>>>> an irq-excluded section.
>> Yes, seems to be incorrect.
>>
>>>> The lock is, however, possibly used that way in ieee80211_key_link=
,
>>>> which can be fixed easily and we can remove the todo lock too.
>>> Not true, but the todo_lock should be made to _irqsave in some plac=
es,
>>> it seems.
>=20
> Actually that doesn't seem to be true either...
>=20
>> Should we handle this as a false positive for now, because I have se=
en this only
>> once, and the transfer has not been interrupted? I will do more test=
s on
>> different platforms, and i will come back if this happens again.
>=20
> Yes, I think we should, something seems to be messed up with this
> report. All code paths are regularly executed on all platforms, so we
> should be seeing this a lot more if there was a problem.

Ok. Thank you for the analysis.

Gabor

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
