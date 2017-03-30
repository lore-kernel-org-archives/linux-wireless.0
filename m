Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:34626 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932347AbdC3Jdk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Mar 2017 05:33:40 -0400
Received: by mail-wr0-f175.google.com with SMTP id l43so52953964wre.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Mar 2017 02:33:39 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: wrap brcmf_fws_(de)init into bcdc layer
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170321134422.888-1-zajec5@gmail.com>
 <c5a57e90-8884-8976-fd3f-5b157abb4189@broadcom.com>
 <fc201610-06ac-ec65-1ec4-7c593a91f935@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <817455f7-aad2-f94e-c08c-0f59f12c2f04@broadcom.com> (sfid-20170330_113344_838012_662A7DA5)
Date: Thu, 30 Mar 2017 11:33:37 +0200
MIME-Version: 1.0
In-Reply-To: <fc201610-06ac-ec65-1ec4-7c593a91f935@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 29-3-2017 13:27, Rafał Miłecki wrote:
> On 03/22/2017 08:43 PM, Arend Van Spriel wrote:
>> On 21-3-2017 14:44, Rafał Miłecki wrote:
>>> From: Rafał Miłecki <rafal@milecki.pl>
>>>
>>> fwsignal is only used by bcdc. Create new protocol interface functions
>>> for core code to perform proto specific (de)initialization. This makes
>>> core agnostic to the protocol which will allow further optimizations.
>>> We will be able to avoid compiling unused protocols or modularize them.
>>
>> Thanks, Rafał
>>
>> Franky had tackled this with two patches, which are queued to be
>> submitted.
> 
> Given that your implementation (you now published) doesn't do any magic, is
> there any real problem with my patch except of /not invented here/?

You could see it like that, but no. These two patches were already
reviewed and I requested more testing as explained in another email
response. Your patch needed a bit of rework and you can safely assume
that my remarks on your patch would make it even more like the one we
already had queued up. So it seemed unreasonable to have Kalle apply
yours and then the two from Franky. It would only be for the sake of
kernel git stats, which is not something I want to factor in.

Regards,
Arend

> [0] https://en.wikipedia.org/wiki/Not_invented_here
