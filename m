Return-Path: <SRS0=opxv=OW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDCF6C65BAE
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 20:57:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B24AF2086D
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 20:57:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="DhyPm+DB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B24AF2086D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbeLMU5e (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Dec 2018 15:57:34 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37582 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbeLMU5e (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Dec 2018 15:57:34 -0500
Received: by mail-wr1-f66.google.com with SMTP id s12so2970373wrt.4
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2018 12:57:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5jsWFAx2cyDZFIr89FMGdfIlce04dcgtoyM+vHYh6bw=;
        b=DhyPm+DBp+M+tjxs/KIcrDtt1UJ75TCyckb71FS97RiHcFrqo3UN/Z2VzBhV2hWN51
         WLmMFwUmoM0RBeZhql9afEKmIlApZQH0VTYjbcVjcZY+EBQxC1s63P13oViSmDyaN1E/
         5/0AtD9HkjK3JZplY0ky/kRYRFfJcHcHUXqK4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5jsWFAx2cyDZFIr89FMGdfIlce04dcgtoyM+vHYh6bw=;
        b=tK9PBjD9uvNbZwJaqgUDScoARBX9k+SY+AgYTANGP2cb9/kRDhcSNqVJKv7fAhcgSy
         M4RGJaz6duJAYQ3A17e+cQDBOdXsVzf74nq540y58YYhpOK0N0eqMzzFyEsBCJmSWFVr
         6IwR+cRoxDDjQEf4xPEPp/oWszH8Q3GSnGaeblx51gTokMuQYaxl2BQeErllDLH3ps1p
         +694QfI2rQuEfD7zIqkEvSe0pdQPYl4P6R66eY7ciEynzOxtFkmlmk9/cvUdzlndizGv
         tNsQy+erS2Oxejyn2nnkPmSOMvH4C2nKCZgiuzsmTIowYkrI7kdRWtI0DcoVHKcSQIUO
         gKRQ==
X-Gm-Message-State: AA+aEWYFWDWElXu7bZA9uLYhx2PN1o6Xj1Vq3zS9B2q6v05oo6aDgtdg
        hw/rwQJOmIdHqmi9ETPSBuOd1Q==
X-Google-Smtp-Source: AFSGD/VUROi5TAjre7qvRk/5I9e5V8hHEJBU0Ek1SjVjCWtE8cYZV/0e0Q/M29rt4bPG2at2bU1Z0g==
X-Received: by 2002:adf:a211:: with SMTP id p17mr268499wra.179.1544734652427;
        Thu, 13 Dec 2018 12:57:32 -0800 (PST)
Received: from [192.168.0.40] (77.37.95.92.rev.sfr.net. [92.95.37.77])
        by smtp.googlemail.com with ESMTPSA id g129sm3343866wmf.39.2018.12.13.12.57.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Dec 2018 12:57:31 -0800 (PST)
Subject: Re: [linux-nfc] NXP NFC version and ACPI
To:     Anders Rundgren <anders.rundgren.net@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc:     linux-nfc@lists.01.org, linux-wireless@vger.kernel.org,
        charles.gorand@effinnov.com
References: <c2d0d19f-d814-8f41-4860-77b9cc7f9d26@linaro.org>
 <10e064d2-7d17-0509-ced7-cecaa6a80d0e@linaro.org>
 <f4e257a6-876b-a8da-4e98-d662eb2b43de@gmail.com>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
Message-ID: <6b57b417-d65f-040b-49b1-5b2accb691bb@linaro.org>
Date:   Thu, 13 Dec 2018 21:57:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <f4e257a6-876b-a8da-4e98-d662eb2b43de@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 13/12/2018 21:50, Anders Rundgren wrote:
> On 2018-12-13 21:44, Daniel Lezcano wrote:
>>
>> ping ... ?
>>
>> On 05/12/2018 08:38, Daniel Lezcano wrote:
>>>
>>> Hi,
>>>
>>> the discussion reference is on github [1].
>>>
>>> I acquired a Lenovo x280 with a NFC chip. It is unclear what chip is it
>>> really, it is called NXP NPC300 which could be a PN7xxx chip range.
>>>
>>> A hacked version of an old deprecated out-of-tree module made the PN5xxx
>>> to work with my laptop but I suspect it brought some subtle instability
>>> on my system.
>>>
>>> Now it would be nice to have this correctly supported upstream.
> 
> Since all other PC vendors have ceased supporting NFC (Intel made it
> useless), why bother?

Well at least, I would like to have my laptop working correctly by
supporting the NFC chip. I think it is not a big deal to have the driver
supporting it.

For my information, why Intel made it useless ?

>>>
>>> I dumped the ACPI DSDT table and got the id NXP1001. This one is not
>>> listed in the match table of the nxp-nci driver.
>>>
>>>   - is the driver missing for the so called NXP NPC300 ?
>>>   - should the NXP1001 matching string to be added to nxp-nci?
>>>   - is my firmware sending me garbage ?
>>>
>>> Thanks in advance for any input
>>>
>>>    -- Daniel
>>>
>>>
>>
>>
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

