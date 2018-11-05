Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59009C0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 14:42:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A88B20685
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 14:42:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2A88B20685
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729375AbeKFACQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 19:02:16 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:34919 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727128AbeKFACP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 19:02:15 -0500
Received: by mail-ed1-f66.google.com with SMTP id d6-v6so7708769edi.2
        for <linux-wireless@vger.kernel.org>; Mon, 05 Nov 2018 06:42:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EgnkbYtcDash2nw98Kh6sqUbhbhr+F2xMl1r1m671W8=;
        b=cNaorOVU7gmWPKPe26aS+qgzS75nzD+l+7Id7ai6QcsjE+nKkofOKbGmHakg184FnV
         IvesESOc7S0GM5E96iL/+DydnF/NBd041nmaSX0drJibOE48fXJtC7+20n6lLQNJ8gws
         XBxyy9zEetYr2CLkob8eW0oPRUeszwr5QDOUZM3/+56Q33dfJqGPnVV1xBlq6GcI1qLY
         5Mz0BFg51wL0hYbVntDI861UotzVz3/bEpRxpWvWn4nzfsIBgJSj8c4TEB/ozkFwTYY2
         K9iMzxMvcvZtmmOSd7kxJhsPIwcvTSEAA0SY2tW3PZuM/3fmii5pQUvuvcVk0q3Rz8Zg
         rZHA==
X-Gm-Message-State: AGRZ1gLoKQM7H2rNFW1cpSOr1Uyw6PLdxRuE7uMnsBEP7JMjuFItnL2D
        5r9Ak4UYjkVyNFT3RR5Z4fMLYg==
X-Google-Smtp-Source: AJdET5flngp/FBrIuVVL+ozudPdupV59cbpRavclrHIBki/gYx/qUkvKAyiyABdzqi+B+7dokpRdIA==
X-Received: by 2002:a50:a881:: with SMTP id k1-v6mr4332868edc.296.1541428932166;
        Mon, 05 Nov 2018 06:42:12 -0800 (PST)
Received: from shalem.localdomain (546A5441.cm-12-3b.dynamic.ziggo.nl. [84.106.84.65])
        by smtp.gmail.com with ESMTPSA id b2-v6sm11053418edy.52.2018.11.05.06.42.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Nov 2018 06:42:11 -0800 (PST)
Subject: Re: [PATCH 5/6] brcmfmac: Set board_type from DMI on x86 based
 machines
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
Cc:     linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
References: <20181009124755.25402-1-hdegoede@redhat.com>
 <20181009124755.25402-5-hdegoede@redhat.com>
 <39789888-ddad-afcb-3abd-104ef544ca26@broadcom.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <84ddea24-4e1b-fade-5310-118383453279@redhat.com>
Date:   Mon, 5 Nov 2018 15:42:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.8.0
MIME-Version: 1.0
In-Reply-To: <39789888-ddad-afcb-3abd-104ef544ca26@broadcom.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On 05-11-18 12:41, Arend van Spriel wrote:
> On 10/9/2018 2:47 PM, Hans de Goede wrote:
>> For x86 based machines, set the board_type used for nvram file selection
>> based on the DMI sys-vendor and product-name strings.
>>
>> Since on some models these strings are too generic, this commit also adds
>> a quirk table overriding the strings for models listed in that table.
>>
>> The board_type setting is used to load the board-specific nvram file with
>> a board-specific name so that we can ship files for each supported board
>> in linux-firmware.
> 
> some comments below....
> 
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>>  .../broadcom/brcm80211/brcmfmac/Makefile      |   2 +
>>  .../broadcom/brcm80211/brcmfmac/common.c      |   3 +-
>>  .../broadcom/brcm80211/brcmfmac/common.h      |   7 ++
>>  .../broadcom/brcm80211/brcmfmac/dmi.c         | 104 ++++++++++++++++++
>>  4 files changed, 115 insertions(+), 1 deletion(-)
>>  create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile
>> index 1f5a9b948abf..22fd95a736a8 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile
>> @@ -54,3 +54,5 @@ brcmfmac-$(CONFIG_BRCM_TRACING) += \
>>          tracepoint.o
>>  brcmfmac-$(CONFIG_OF) += \
>>          of.o
>> +brcmfmac-$(CONFIG_DMI) += \
>> +        dmi.o
> 
> Assuming OF and DMI are mutual exclusive, right?

Not necessarily ACPI tables can embed of/devicetree data now, so an x86
machine could have of-data, but having both compiled in is not an issue
I would expect only one of them to actually be present (so either of-data
or an entry in the DMI platform-data table).


>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
>> new file mode 100644
>> index 000000000000..fadc0ec745b8
>> --- /dev/null
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
> 
> [...]
> 
>> +static const struct dmi_system_id dmi_platform_data[] = {
> 
> maybe call this dmi_platform_quirk as in brcmf_dmi_probe() you call this a "quirk table".

OK, will fix for v3. I will also switch back to the SPDX license header
for v3, since the ISC license text is now in Linus' tree.

Regards,

Hans
