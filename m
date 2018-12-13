Return-Path: <SRS0=opxv=OW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4D28C65BAE
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 20:50:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7433120811
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 20:50:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VzISfw/a"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7433120811
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbeLMUuI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Dec 2018 15:50:08 -0500
Received: from mail-wr1-f43.google.com ([209.85.221.43]:35307 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbeLMUuH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Dec 2018 15:50:07 -0500
Received: by mail-wr1-f43.google.com with SMTP id 96so3395842wrb.2
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2018 12:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vVTpe3wz5cvQumiykqXQTZ/6IXMHj216D6H9sSFK47Q=;
        b=VzISfw/aL5PCV2tx7Nam0k3yBvR/S/nHQ7Soo12fbQGGHKImbFpQi7EUiCVWMwWxd+
         KCjfUhOgoO1aTyAcwSQfH9GQ7SQaVERG7yRgEDLwiEob+97Dnpa8716MPdb0MpXnabfF
         l+whXsewDlueARvp5W7X++5bmYvgzAFdDEnlNn8BGsZtmAUQh4SuMT+UbSZd2DxHIeL5
         fDPdu0NLCMXaoaH5O4DiymlPGfnzarlo7pIiL93krEiVRPuMKAcHk1tM37rrrvwPriy+
         uLes2rbg5PH/pO5VB7inVDOdoh6AOl+X4L1i0oY2eAHSRbq3+sgHiTelyPmIqV9FTtSh
         1yWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vVTpe3wz5cvQumiykqXQTZ/6IXMHj216D6H9sSFK47Q=;
        b=mSSfJ8AnTAD6anmuWJsZ9/XR1VW22MxQ+nAirVdgk8v9Ns/Xv9V2NdAWH/qiPkN8um
         BouoeOf7LUyrD/BzHgR7e6ty2IlXLkjhFPxIx05Fw/4meP9RBzbu8YWdC7ZYaHbxaikX
         5by9v4XYwr1t1XBmMsc/+OIryrbtblLfiiqYcnDQC+qarobOJKk5I9TuYkm76HuBzS37
         R72djzWyU7cKfWDYgi9emkZNkt1R7LKfjpjk6vJl/oX4a1NNclgrrwrgi8sDI8Xo7A6k
         SnOqoJ9CFFwhVvsL7reYwbhNoZhT4FbHNQ8VTkjz145CUu2Z0DshVZpGFyuPQHvTPaHD
         b3oA==
X-Gm-Message-State: AA+aEWan+bllb2YZpVH3PabRJBZoIbnm+SXv81l0qMwBXhnKB26FdM3x
        XCNsgOUqefCfuSGQbxasRZ0=
X-Google-Smtp-Source: AFSGD/XmuhUPF4quptWlCFlwhVBwLcWtCeOU+yi39gh/1AJdBMXn7AUjIaqgDva7zXTPhX5hFgcOag==
X-Received: by 2002:adf:dec4:: with SMTP id i4mr229467wrn.307.1544734206026;
        Thu, 13 Dec 2018 12:50:06 -0800 (PST)
Received: from [192.168.1.79] (25.131.146.77.rev.sfr.net. [77.146.131.25])
        by smtp.googlemail.com with ESMTPSA id x12sm2358867wrt.20.2018.12.13.12.50.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Dec 2018 12:50:05 -0800 (PST)
Subject: Re: [linux-nfc] NXP NFC version and ACPI
To:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc:     robert.dolca@intel.com, linux-nfc@lists.01.org,
        linux-wireless@vger.kernel.org, charles.gorand@effinnov.com
References: <c2d0d19f-d814-8f41-4860-77b9cc7f9d26@linaro.org>
 <10e064d2-7d17-0509-ced7-cecaa6a80d0e@linaro.org>
From:   Anders Rundgren <anders.rundgren.net@gmail.com>
Message-ID: <f4e257a6-876b-a8da-4e98-d662eb2b43de@gmail.com>
Date:   Thu, 13 Dec 2018 21:50:02 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <10e064d2-7d17-0509-ced7-cecaa6a80d0e@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-12-13 21:44, Daniel Lezcano wrote:
> 
> ping ... ?
> 
> On 05/12/2018 08:38, Daniel Lezcano wrote:
>>
>> Hi,
>>
>> the discussion reference is on github [1].
>>
>> I acquired a Lenovo x280 with a NFC chip. It is unclear what chip is it
>> really, it is called NXP NPC300 which could be a PN7xxx chip range.
>>
>> A hacked version of an old deprecated out-of-tree module made the PN5xxx
>> to work with my laptop but I suspect it brought some subtle instability
>> on my system.
>>
>> Now it would be nice to have this correctly supported upstream.

Since all other PC vendors have ceased supporting NFC (Intel made it useless), why bother?

Anders

>>
>> I dumped the ACPI DSDT table and got the id NXP1001. This one is not
>> listed in the match table of the nxp-nci driver.
>>
>>   - is the driver missing for the so called NXP NPC300 ?
>>   - should the NXP1001 matching string to be added to nxp-nci?
>>   - is my firmware sending me garbage ?
>>
>> Thanks in advance for any input
>>
>>    -- Daniel
>>
>>
> 
> 

