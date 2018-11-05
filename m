Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B769C0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 14:34:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0630B2085A
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 14:34:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0630B2085A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729416AbeKEXyf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 18:54:35 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:40038 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727481AbeKEXyf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 18:54:35 -0500
Received: by mail-ed1-f68.google.com with SMTP id a14-v6so3477645edr.7
        for <linux-wireless@vger.kernel.org>; Mon, 05 Nov 2018 06:34:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/DAJpkMteFv3slSHNN+XYkULYpx6Z3xqkB1yXBgmZW0=;
        b=DgqZQ+8//VrAEEQ+kNGOeZ1q+ciUlLAjo/ki/AWljcq1dmirfu7/wu0OSnZOWHktfJ
         rRqURIoJCBAuD5Mm3gwF6DgtK42VZXTwHhJO68A8OeEeuS4LF1bNLLEcOD7DXfPPtEwp
         15jsQTqvWnZNmyw18DnbBf7fx1UHGVOws+uekXzAu1iptyNNynullhC5zL6i1pm4YV5j
         w5XnsAmWP4R/7MsSB4+iINa+uOJSXRznO4T1pOILEKZxuaSKvn4KxNB9/8/Y7MNDB8bT
         mdcXMHn7DfT6uhfsaGq22IeHJI0pJblUkKLPAZsN/PLjvAVi3wxVyE6kE8tUQAEOmy6O
         CpXA==
X-Gm-Message-State: AGRZ1gI3NzBC2hEKkd0yVw+Qyp5TmzwSxoq7CU6mm+nGQaZ6viP8f18Z
        oK25Yej5YuXMBWhPlUAvRaJNhw==
X-Google-Smtp-Source: AJdET5eMPPoWvuWkl3Mp0QWDU56Iw+rCeT9gAue5Cc13a5DfRF/Wsnj8EwSQkqZBbKLmy8RS9XpylA==
X-Received: by 2002:a50:8efc:: with SMTP id x57-v6mr17668331edx.177.1541428474271;
        Mon, 05 Nov 2018 06:34:34 -0800 (PST)
Received: from shalem.localdomain (546A5441.cm-12-3b.dynamic.ziggo.nl. [84.106.84.65])
        by smtp.gmail.com with ESMTPSA id t21-v6sm2603631ejk.33.2018.11.05.06.34.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Nov 2018 06:34:33 -0800 (PST)
Subject: Re: [PATCH 6/6] brcmfmac: Cleanup brcmf_fw_request_done()
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
Cc:     linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
References: <20181009124755.25402-1-hdegoede@redhat.com>
 <20181009124755.25402-6-hdegoede@redhat.com>
 <9741c4fc-fbe2-c45c-9775-18b71dbcfc85@broadcom.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <5859a801-2e69-4e6b-f946-2e269a26797e@redhat.com>
Date:   Mon, 5 Nov 2018 15:34:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.8.0
MIME-Version: 1.0
In-Reply-To: <9741c4fc-fbe2-c45c-9775-18b71dbcfc85@broadcom.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On 05-11-18 12:42, Arend van Spriel wrote:
> On 10/9/2018 2:47 PM, Hans de Goede wrote:
>> The "cur" variable is now only used for a debug print and we already
>> print the same info from brcmf_fw_complete_request(), so the debug print
>> does not provide any extra info and we can remove it.
> 
> I guess this could have been collapsed in the first patch introducing brcmf_fw_complete_request(). All-in-all a nice cleanup. Thanks.

The idea of doing this in 2 separate patches is to make the first
patch (which is non trivial) easier to review.

Regards,

Hans


> 
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>>  .../net/wireless/broadcom/brcm80211/brcmfmac/firmware.c   | 8 +-------
>>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
