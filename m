Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:33476 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547AbbG3GyL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 02:54:11 -0400
Received: by ioii16 with SMTP id i16so44782729ioi.0
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2015 23:54:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8738065hkb.fsf@kamboji.qca.qualcomm.com>
References: <1438205790-17629-1-git-send-email-hauke@hauke-m.de>
	<8738065hkb.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 30 Jul 2015 08:54:10 +0200
Message-ID: <CACna6rySwFsFhSjRgyw_oVk3BX9sSHu81rPTusmGujOveehbiA@mail.gmail.com> (sfid-20150730_085421_199776_3A3F52B4)
Subject: Re: [PATCH] b43: fix extpa_gain check for 2GHz
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30 July 2015 at 07:40, Kalle Valo <kvalo@codeaurora.org> wrote:
> Hauke Mehrtens <hauke@hauke-m.de> writes:
>
>> On the 2GHz and and on the 5GHZ band only the extpa_gain setting from
>> the 5GHz band was checked. this patch makes it check the property from
>> the correct band.
>>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>
> Is this a regression? If yes, please add a Fixes line.
>
> Should this go to 4.2?

Not a regression. It's like this for a loooong time.

AFAIK PCI(e) cards don't have external power amplifier, so this code
is most likely used for some fancy SoCs only. There are 3 known SoCs
with N-PHY rev 5 or 6: BCM4717A1, BCM4718A1 & BCM4716B0.

So we may consider taking it for 4.2 without any "Fixes: " line but I
wouldn't care too much about Cc-ing stable.

Hauke: do you agree?

-- 
Rafał
