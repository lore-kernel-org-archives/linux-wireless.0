Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:37476 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709AbbG3Reb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 13:34:31 -0400
Message-ID: <55BA6024.4000307@hauke-m.de> (sfid-20150730_193440_272909_F4B1471E)
Date: Thu, 30 Jul 2015 19:34:28 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: [PATCH] b43: fix extpa_gain check for 2GHz
References: <1438205790-17629-1-git-send-email-hauke@hauke-m.de> <8738065hkb.fsf@kamboji.qca.qualcomm.com> <CACna6rySwFsFhSjRgyw_oVk3BX9sSHu81rPTusmGujOveehbiA@mail.gmail.com>
In-Reply-To: <CACna6rySwFsFhSjRgyw_oVk3BX9sSHu81rPTusmGujOveehbiA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/30/2015 08:54 AM, Rafał Miłecki wrote:
> On 30 July 2015 at 07:40, Kalle Valo <kvalo@codeaurora.org> wrote:
>> Hauke Mehrtens <hauke@hauke-m.de> writes:
>>
>>> On the 2GHz and and on the 5GHZ band only the extpa_gain setting from
>>> the 5GHz band was checked. this patch makes it check the property from
>>> the correct band.
>>>
>>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>>
>> Is this a regression? If yes, please add a Fixes line.
>>
>> Should this go to 4.2?
> 
> Not a regression. It's like this for a loooong time.
> 
> AFAIK PCI(e) cards don't have external power amplifier, so this code
> is most likely used for some fancy SoCs only. There are 3 known SoCs
> with N-PHY rev 5 or 6: BCM4717A1, BCM4718A1 & BCM4716B0.
> 
> So we may consider taking it for 4.2 without any "Fixes: " line but I
> wouldn't care too much about Cc-ing stable.
> 
> Hauke: do you agree?
> 
Yes, I do not have a device I know of which is affected by this error, I
just saw this while looking at code close by. Just put this into the
next Linux version and not to stable.

Hauke
