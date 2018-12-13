Return-Path: <SRS0=opxv=OW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25355C65BAE
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 21:11:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB21E20851
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 21:11:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OXGgWgwp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB21E20851
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbeLMVLq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Dec 2018 16:11:46 -0500
Received: from mail-wm1-f47.google.com ([209.85.128.47]:38105 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726461AbeLMVLq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Dec 2018 16:11:46 -0500
Received: by mail-wm1-f47.google.com with SMTP id m22so3834460wml.3
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2018 13:11:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0SrKNDJiV61oNEAopTWOeoAfDtQDKrZg7gmLCdvnDdc=;
        b=OXGgWgwpZctY7gh8amCQukOd7UM++os2MSJB1+g9g0CxCiH8vaE1gqHJZHhlvJ8g/C
         o4BBTqkUDNAmLctBbIxGgKmOD/L9f6TIaTgbDEM48m/Sr2kGb2YXnsiByC62iyBPbCnS
         oDsohu/dKKJBRuA44o5rWhSh72F7rGGgZXH2q/7kL18q3PYzgArMiejxyAQ5iAzoDpuw
         2QvbOosWz0P5/k+A8R4JsMfZrEY8y+Fy/2Tb7x2aHIIqHHMqaLA9/FFcMpM6DDWP8JZS
         jJhecFVeUT2VG/e4z3jwCNKf60k9Aj1BLnI7xvYJ8/5WXXBbN6UMBnVa+TKpjpRyTmnV
         c0gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0SrKNDJiV61oNEAopTWOeoAfDtQDKrZg7gmLCdvnDdc=;
        b=ZsTRVN9+fNQOyBc+3ow+jspm9nc2+LzGDer1kziG5vmdsk0QGv6lvzmJA7ZPlCrX2W
         5olU9DtvQ8u8JGUyNudp+lDKEYEqoycNnnU3waIBZDgAJsgDjJrE3bu9wfqsKxMSc+BD
         WO5ldAFwT9RSJJ7a6SAEsXE6D2XtR3xjLcTDyoq89hyHR3QJAUHiCAHjd6tEciaWFFnB
         WjHkeqM9ooVTZE4xuZX8RBjS758SEteEOMSOqkiJnrOqtzj+5dxX1eYZxpTpzTI5l3wc
         NRu/FZcpyD8qMTzZHh55Qo7BnKwl41a3T60xmsAlHS86pQFyPLsCh1Cl38qKLPG2SF2V
         +rhg==
X-Gm-Message-State: AA+aEWbg4NNmgkXTslLCgnFDa7gLPjuIq6p53oHvpVsC46o1xcCD6uag
        +g5ALRKhqFJElAzB1PyzFdY=
X-Google-Smtp-Source: AFSGD/Xfsc5Qb53JJiMD4zuitqYShStkwJE1Yv88vqpxpTuyX14TnMIMb+2J/XS6R8JjMWNk+sGPTg==
X-Received: by 2002:a1c:c64e:: with SMTP id w75mr1002823wmf.46.1544735504220;
        Thu, 13 Dec 2018 13:11:44 -0800 (PST)
Received: from [192.168.1.79] (25.131.146.77.rev.sfr.net. [77.146.131.25])
        by smtp.googlemail.com with ESMTPSA id n15sm4038336wrt.21.2018.12.13.13.11.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Dec 2018 13:11:43 -0800 (PST)
Subject: Re: [linux-nfc] NXP NFC version and ACPI
To:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc:     linux-nfc@lists.01.org, linux-wireless@vger.kernel.org,
        charles.gorand@effinnov.com
References: <c2d0d19f-d814-8f41-4860-77b9cc7f9d26@linaro.org>
 <10e064d2-7d17-0509-ced7-cecaa6a80d0e@linaro.org>
 <f4e257a6-876b-a8da-4e98-d662eb2b43de@gmail.com>
 <6b57b417-d65f-040b-49b1-5b2accb691bb@linaro.org>
From:   Anders Rundgren <anders.rundgren.net@gmail.com>
Message-ID: <77343b37-bd55-7249-2be1-f97e9d5de32e@gmail.com>
Date:   Thu, 13 Dec 2018 22:11:41 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <6b57b417-d65f-040b-49b1-5b2accb691bb@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-12-13 21:57, Daniel Lezcano wrote:
> On 13/12/2018 21:50, Anders Rundgren wrote:
>> On 2018-12-13 21:44, Daniel Lezcano wrote:
>>>
<snip>
>>
>> Since all other PC vendors have ceased supporting NFC (Intel made it
>> useless), why bother?
> 
> Well at least, I would like to have my laptop working correctly by
> supporting the NFC chip. I think it is not a big deal to have the driver
> supporting it.
> 
> For my information, why Intel made it useless ?

The only high volume use of NFC in a PC would be for Secure Payments and Authentication where you use a mobile phone as payment credential holder or authenticator.
Intel rejected this idea.  QR has (forever) taken NFC's place.

The QR phenomena is also getting strong in PoS terminal (shop) world since the NFC forum haven't realized that 7816 is an obsolete technology.  800 million Chinese have much better stuff than the West crippled by dated card level protocols.

Anders

> 
>>>>
>>>> I dumped the ACPI DSDT table and got the id NXP1001. This one is not
>>>> listed in the match table of the nxp-nci driver.
>>>>
>>>>    - is the driver missing for the so called NXP NPC300 ?
>>>>    - should the NXP1001 matching string to be added to nxp-nci?
>>>>    - is my firmware sending me garbage ?
>>>>
>>>> Thanks in advance for any input
>>>>
>>>>     -- Daniel
>>>>
>>>>
>>>
>>>
>>
> 
> 

