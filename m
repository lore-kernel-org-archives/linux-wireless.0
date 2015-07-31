Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36818 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbbGaGKr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 02:10:47 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: [PATCH] b43: fix extpa_gain check for 2GHz
References: <1438205790-17629-1-git-send-email-hauke@hauke-m.de>
	<8738065hkb.fsf@kamboji.qca.qualcomm.com>
	<CACna6rySwFsFhSjRgyw_oVk3BX9sSHu81rPTusmGujOveehbiA@mail.gmail.com>
	<55BA6024.4000307@hauke-m.de>
Date: Fri, 31 Jul 2015 09:10:39 +0300
In-Reply-To: <55BA6024.4000307@hauke-m.de> (Hauke Mehrtens's message of "Thu,
	30 Jul 2015 19:34:28 +0200")
Message-ID: <87egjo3li8.fsf@kamboji.qca.qualcomm.com> (sfid-20150731_081059_924589_71CBBD9B)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hauke Mehrtens <hauke@hauke-m.de> writes:

> On 07/30/2015 08:54 AM, Rafał Miłecki wrote:
>> On 30 July 2015 at 07:40, Kalle Valo <kvalo@codeaurora.org> wrote:
>>> Hauke Mehrtens <hauke@hauke-m.de> writes:
>>>
>>>> On the 2GHz and and on the 5GHZ band only the extpa_gain setting from
>>>> the 5GHz band was checked. this patch makes it check the property from
>>>> the correct band.
>>>>
>>>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>>>
>>> Is this a regression? If yes, please add a Fixes line.
>>>
>>> Should this go to 4.2?
>> 
>> Not a regression. It's like this for a loooong time.
>> 
>> AFAIK PCI(e) cards don't have external power amplifier, so this code
>> is most likely used for some fancy SoCs only. There are 3 known SoCs
>> with N-PHY rev 5 or 6: BCM4717A1, BCM4718A1 & BCM4716B0.
>> 
>> So we may consider taking it for 4.2 without any "Fixes: " line but I
>> wouldn't care too much about Cc-ing stable.
>> 
>> Hauke: do you agree?
>
> Yes, I do not have a device I know of which is affected by this error, I
> just saw this while looking at code close by. Just put this into the
> next Linux version and not to stable.

Ok, I'll send this to 4.2.

-- 
Kalle Valo
