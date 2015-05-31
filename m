Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:33736 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757446AbbEaISt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2015 04:18:49 -0400
Received: by igbpi8 with SMTP id pi8so41784716igb.0
        for <linux-wireless@vger.kernel.org>; Sun, 31 May 2015 01:18:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5496C525.7000000@broadcom.com>
References: <1419099904-13303-1-git-send-email-zajec5@gmail.com>
	<5496C525.7000000@broadcom.com>
Date: Sun, 31 May 2015 10:18:49 +0200
Message-ID: <CACna6rzk7MTXxhc7B5M8zmE+Xip2_M+uUG2pEKvmAuW7AeGkRw@mail.gmail.com> (sfid-20150531_101855_841132_8C7CC016)
Subject: Re: [BUG REPORT] brcmfmac: wrong logic in finding control/primary
 channel relative location
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 December 2014 at 14:03, Arend van Spriel <arend@broadcom.com> wrote:
> On 12/20/14 19:25, Rafał Miłecki wrote:
>> Hi guys,
>>
>> Let me report something I think is a bug in this unusual-patch way ;)
>> ---
>>   drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
>> b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
>> index 39b45c0..2c9e88b 100644
>> --- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
>> +++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
>> @@ -313,11 +313,13 @@ static u16 chandef_to_chanspec(struct brcmu_d11inf
>> *d11inf,
>>         case NL80211_CHAN_WIDTH_80:
>>                 ch_inf.bw = BRCMU_CHAN_BW_80;
>>                 if (primary_offset<  0) {
>> +                       /* FIXME: We compare frequencies offset with a
>> value -2. Looks like a wrong logic. */
>>                         if (primary_offset<  -CH_10MHZ_APART)
>
>
> You are right. The primary_offset is in MHz, but the logical expression is
> for channel spacing (1 channel == 5MHz). So here it should be -10 instead.
> Thanks for reporting this.

Will you fix it?

-- 
Rafał
