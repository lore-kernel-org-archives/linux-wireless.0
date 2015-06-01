Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:12184 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbbFALzV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 07:55:21 -0400
Message-ID: <556C4826.7060708@broadcom.com> (sfid-20150601_135525_146228_9B95BFB5)
Date: Mon, 1 Jun 2015 13:55:18 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	"brcm80211 development" <brcm80211-dev-list@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [BUG REPORT] brcmfmac: wrong logic in finding control/primary
 channel relative location
References: <1419099904-13303-1-git-send-email-zajec5@gmail.com>	<5496C525.7000000@broadcom.com> <CACna6rzk7MTXxhc7B5M8zmE+Xip2_M+uUG2pEKvmAuW7AeGkRw@mail.gmail.com>
In-Reply-To: <CACna6rzk7MTXxhc7B5M8zmE+Xip2_M+uUG2pEKvmAuW7AeGkRw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/31/15 10:18, Rafał Miłecki wrote:
> On 21 December 2014 at 14:03, Arend van Spriel<arend@broadcom.com>  wrote:
>> On 12/20/14 19:25, Rafał Miłecki wrote:
>>> Hi guys,
>>>
>>> Let me report something I think is a bug in this unusual-patch way ;)
>>> ---
>>>    drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c | 2 ++
>>>    1 file changed, 2 insertions(+)
>>>
>>> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
>>> b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
>>> index 39b45c0..2c9e88b 100644
>>> --- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
>>> +++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
>>> @@ -313,11 +313,13 @@ static u16 chandef_to_chanspec(struct brcmu_d11inf
>>> *d11inf,
>>>          case NL80211_CHAN_WIDTH_80:
>>>                  ch_inf.bw = BRCMU_CHAN_BW_80;
>>>                  if (primary_offset<   0) {
>>> +                       /* FIXME: We compare frequencies offset with a
>>> value -2. Looks like a wrong logic. */
>>>                          if (primary_offset<   -CH_10MHZ_APART)
>>
>>
>> You are right. The primary_offset is in MHz, but the logical expression is
>> for channel spacing (1 channel == 5MHz). So here it should be -10 instead.
>> Thanks for reporting this.
>
> Will you fix it?

Completely forgot about this one. Feel free to submit a patch for it.

Regards,
Arend
