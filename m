Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A781C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 07:29:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF285214DA
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 07:29:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EF285214DA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727765AbeJJOtx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 10:49:53 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34470 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727419AbeJJOtv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 10:49:51 -0400
Received: by mail-wr1-f66.google.com with SMTP id l6-v6so4045125wrt.1
        for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2018 00:29:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vPZgsg2xXzYB8toueMQn9lqAbt02V4fxrGhnsWeelQ4=;
        b=f/prLY1G2OgEnvNc5FgL3MVwbPcjbDoIZpaJxiYQIf0he3puIPzQIEGgNkHx5eTIUQ
         D7wtUj7+tFUCKTOrON8utCo681GW1oCf/IH+AbM1/Fss4eeiJp05LvC0AH4HtMb00DoF
         nI5cXw9AF0bos8CNarzLX95fshxkEZRcxANOmSqlLlp4W4y4zmY1w7/uq8zaPP+1lctQ
         /Om+1c0EWmeVaEFsKQMh82ydwk3ubb4MAj20amWgHx54YgKihm5lRDo6JYbSfukvGyvW
         wvumBxGgiBdvUxcbMFK//HqjnFv15jxnOEPx9tVuG06oa7r/IvEILp/tbBRK6xM4xqXQ
         M3Pg==
X-Gm-Message-State: ABuFfogCsKLsrgHsoyH5eWaRDjxbRRIWssfVw+Fz4HD680teBPw4mFXh
        3YhQHaRIQTyGjzTQdZpvVW2tkg==
X-Google-Smtp-Source: ACcGV60PlTMOv4ExwgyEvmz/ym2kZpxUGVGidjtRLJMd1qatKV05Vc/z+DJBl6nBD91febpULQxYUw==
X-Received: by 2002:adf:81e1:: with SMTP id 88-v6mr25356448wra.19.1539156539526;
        Wed, 10 Oct 2018 00:28:59 -0700 (PDT)
Received: from shalem.localdomain (546A5441.cm-12-3b.dynamic.ziggo.nl. [84.106.84.65])
        by smtp.gmail.com with ESMTPSA id u191-v6sm17757440wmd.31.2018.10.10.00.28.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Oct 2018 00:28:58 -0700 (PDT)
Subject: Re: [PATCH 5/6] brcmfmac: Set board_type from DMI on x86 based
 machines
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
References: <20181009124755.25402-1-hdegoede@redhat.com>
 <20181009124755.25402-5-hdegoede@redhat.com> <87murmxop9.fsf@codeaurora.org>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <7397e1f5-5df6-4b49-78dd-ddc9774de16b@redhat.com>
Date:   Wed, 10 Oct 2018 09:28:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.8.0
MIME-Version: 1.0
In-Reply-To: <87murmxop9.fsf@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On 10-10-18 09:09, Kalle Valo wrote:
> Hans de Goede <hdegoede@redhat.com> writes:
> 
>> For x86 based machines, set the board_type used for nvram file selection
>> based on the DMI sys-vendor and product-name strings.
>>
>> Since on some models these strings are too generic, this commit also adds
>> a quirk table overriding the strings for models listed in that table.
>>
>> The board_type setting is used to load the board-specific nvram file with
>> a board-specific name so that we can ship files for each supported board
>> in linux-firmware.
>>
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> 
> [...]
> 
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
>> @@ -0,0 +1,104 @@
>> +// SPDX-License-Identifier: ISC
> 
> I don't see the ISC file in LICENSES directory[1] and I don't feel
> comfortable taking SPDX tags which which don't have a license file.

Ok. I need to do a patch for the LICENSES directory anyways, so I will
also submit the ISC license upstream while at it, I will hopefully
get around to doing that today.

So how do you want to proceed with this, do you want me to just
put the full ISC text in the header for now as the rest of brcmfmac
does?

Then later someone (me if I get around to it) can replace all of
the headers with // SPDX-License-Identifier: ISC once it has been
added under LICENSES.

Regards,

Hans

