Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45423 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab1L1WkO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Dec 2011 17:40:14 -0500
Received: by vbbfc26 with SMTP id fc26so9902345vbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Dec 2011 14:40:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EFB91B0.2070800@01019freenet.de>
References: <1325033604-26469-1-git-send-email-gwingerde@gmail.com>
	<1325033604-26469-2-git-send-email-gwingerde@gmail.com>
	<1325033604-26469-3-git-send-email-gwingerde@gmail.com>
	<1325033604-26469-4-git-send-email-gwingerde@gmail.com>
	<1325033604-26469-5-git-send-email-gwingerde@gmail.com>
	<CAOZOX0XauBTyaBR9j75de=BeTZ1v_rRfgdJc7BPYDsA9HYi-2w@mail.gmail.com>
	<4EFB7F6B.8050104@gmail.com>
	<4EFB91B0.2070800@01019freenet.de>
Date: Wed, 28 Dec 2011 23:40:13 +0100
Message-ID: <CAOZOX0V5V6O=GDydjmxn2YGAJGwqT5GU8GqVeshdbe=MJt4jwg@mail.gmail.com> (sfid-20111228_234037_548915_065C1BDE)
Subject: Re: [PATCH 4/7] rt2800usb: Let rt2x00usb handle USB padding
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	=?ISO-8859-2?Q?Jakub_Kici=F1ski?= <kubakici@wp.pl>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/12/28 Andreas Hartmann <andihartmann@01019freenet.de>:
> Gertjan van Wingerde schrieb:
>> On 12/28/11 21:12, Ivo Van Doorn wrote:
>>> On Wed, Dec 28, 2011 at 1:53 AM, Gertjan van Wingerde
>>> <gwingerde@gmail.com> wrote:
>>>> From: Jakub Kiciñski <kubakici@wp.pl>
>>>>
>>>> Older USB drivers does not append end padding to skb but instead report
>>>> it in size of data to be transmitted to HW. rt2800usb should follow that
>>>> behaviour. Custom write_tx_data callback which was adding pad to skb
>>>> is not be needed any more.
>>>>
>>>> Thanks to this patch frames handed back from rt2800usb to mac80211 will
>>>> no longer contain end padding.
>>>
>>> What happened to the reports that after this (and the next) patch, the
>>> non-2800 USB
>>> drivers are failing?
>>
>> I have seen only 1 failure report (from Andreas Hartmann), which seemed
>> to have been caused by not applying both patches. ISTR that Andreas did
>> not see any regression when both patches were applied.
>
> Yes, that's true. The behavior of a rt3572 dongle in my test with both
> patches applied was the same as without these both patches.
>
> Please note that the test I did was very short, because the rt2800usb
> driver works really bad with this device anyway.

Ok, thanks for the update.

Ivo
