Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:33775 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbbFDT7x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2015 15:59:53 -0400
Received: by igbpi8 with SMTP id pi8so154350igb.0
        for <linux-wireless@vger.kernel.org>; Thu, 04 Jun 2015 12:59:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5570688E.8060307@broadcom.com>
References: <1432813063-30922-1-git-send-email-zajec5@gmail.com>
	<5570688E.8060307@broadcom.com>
Date: Thu, 4 Jun 2015 21:59:52 +0200
Message-ID: <CACna6rxtNdhOgYfEQuKR4j4qkjAvF1nuXjQR=XgorxKgWT1KHQ@mail.gmail.com> (sfid-20150604_215958_345191_D9662BC2)
Subject: Re: [PATCH] brcmfmac: use direct data pointer in NVRAM parser struct
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4 June 2015 at 17:02, Arend van Spriel <arend@broadcom.com> wrote:
> On 05/28/15 13:37, Rafał Miłecki wrote:
>>
>> As we plan to add support for platform NVRAM we should store direct
>> data pointer without the extra struct firmware layer. This will allow
>> us to support other sources with the only requirement being u8 buffer.
>>
>> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
>> Signed-off-by: Hante Meuleman<meuleman@broadcom.com>
>> Signed-off-by: Arend van Spriel<arend@broadcom.com>
>
>
> This look a bit contradictory. You mention below you written this from
> 'scratch' so it seems odd that it is signed off by me and Hante.
>
> You may add:
>
> Acked-by: Arend van Spriel <arend@broadcom.com>

Sorry, I wasn't sure how to handle it. Will fix it.


>> ---
>> Tested on router with BCM43602-s using
>> /lib/firmware/brcm/brcmfmac43602-pcie.txt
>>
>> I've written this patch from scratch, it's inspired by the dropped:
>> [PATCH 6/6] brcmfmac: Add support for host platform NVRAM loading.
>> ---
>>   drivers/net/wireless/brcm80211/brcmfmac/firmware.c | 40
>> +++++++++++-----------
>>   1 file changed, 20 insertions(+), 20 deletions(-)
>>
>> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
>> b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
>> index 7ae6461..b72df87 100644
>> --- a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
>> +++ b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
>> @@ -43,7 +43,7 @@ enum nvram_parser_state {
>>    * struct nvram_parser - internal info for parser.
>>    *
>>    * @state: current parser state.
>> - * @fwnv: input buffer being parsed.
>> + * @data: input buffer being parsed.
>
>
> So you are not adding the data_len to the structure, which means you found
> it is not needed? Just checking as it is different from the aforementioned
> patch.

That's right.

-- 
Rafał
