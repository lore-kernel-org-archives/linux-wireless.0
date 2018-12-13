Return-Path: <SRS0=opxv=OW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D85C65BAE
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 20:44:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9359620811
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 20:44:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="a4puRKvA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9359620811
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbeLMUoF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Dec 2018 15:44:05 -0500
Received: from mail-wr1-f51.google.com ([209.85.221.51]:37818 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbeLMUoF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Dec 2018 15:44:05 -0500
Received: by mail-wr1-f51.google.com with SMTP id s12so2938743wrt.4
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2018 12:44:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DfJqqqF92L5peiDucrhz2WiddnFZ1jF5DI+Xejdsq3Y=;
        b=a4puRKvA2HWriSEhudSugXdmJRr0cOccAK2zltsgb4VLZiOBsYb6q+npgdrnBScRdX
         nPPoTj8OjUxLVv0F1Xgvz7vHoNa235f9FJniOBmEAYUOqRQjkbHQgEtcBFfpghLHmzaY
         E5dEoPXS080PZzFSCtr1FKjzeYr1ZsdPwPP4g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DfJqqqF92L5peiDucrhz2WiddnFZ1jF5DI+Xejdsq3Y=;
        b=p8uAsC+XDs8ja6ISLZZdt+uPdXeTmBwpD4g8jWdT+PV+C/gebOPIls0tdrUeoPQ2yq
         V1l0TUBSgnTgJw+bh+r4p1A15UhDHRZvIqfzRgDVSqy81RAinQ6eo7Dp//JB/HepwfSa
         uTfGnY9Jktb18Ql3FXcp5krRKG4+YMBaZXVkb3PK1Z6hQcT0v7vLxHfJZNQOifb1JqrM
         Y8fgqGVbcjzEcFSCnSXKN5BBojFq1EGOomdQ4q+2HcPDsJoUJBXvQ+dRtZ9Oet7jYrjU
         +D9YAVEsVZRbPvLQksqA5HZZ91uPe+/t0UZbqyoIZvVhPe6mrJXQIND2oOhLNKkH16av
         4bIA==
X-Gm-Message-State: AA+aEWZlLggMSPEbH6EiHXxJT8Gx4qG7LmQE+seYaPUrbF1uO2id28UK
        RRdo8MTLwlvhg1OFhosp0thI8Q==
X-Google-Smtp-Source: AFSGD/V4CNs1DFzX75zIh016Hmbi6th+tWAzj9VyQ5qmLhBkDFwYy6kxXJv9m9gIZP0YPCI2MKpUPQ==
X-Received: by 2002:adf:ef0d:: with SMTP id e13mr239446wro.29.1544733843415;
        Thu, 13 Dec 2018 12:44:03 -0800 (PST)
Received: from [192.168.0.40] (77.37.95.92.rev.sfr.net. [92.95.37.77])
        by smtp.googlemail.com with ESMTPSA id r64sm3387569wmg.5.2018.12.13.12.44.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Dec 2018 12:44:02 -0800 (PST)
Subject: Re: NXP NFC version and ACPI
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
To:     Samuel Ortiz <sameo@linux.intel.com>
Cc:     linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        robert.dolca@intel.com, oleg.zhurakivskyy@intel.com,
        clement.perrochaud@effinnov.com, charles.gorand@effinnov.com
References: <c2d0d19f-d814-8f41-4860-77b9cc7f9d26@linaro.org>
Message-ID: <10e064d2-7d17-0509-ced7-cecaa6a80d0e@linaro.org>
Date:   Thu, 13 Dec 2018 21:44:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <c2d0d19f-d814-8f41-4860-77b9cc7f9d26@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


ping ... ?

On 05/12/2018 08:38, Daniel Lezcano wrote:
> 
> Hi,
> 
> the discussion reference is on github [1].
> 
> I acquired a Lenovo x280 with a NFC chip. It is unclear what chip is it
> really, it is called NXP NPC300 which could be a PN7xxx chip range.
> 
> A hacked version of an old deprecated out-of-tree module made the PN5xxx
> to work with my laptop but I suspect it brought some subtle instability
> on my system.
> 
> Now it would be nice to have this correctly supported upstream.
> 
> I dumped the ACPI DSDT table and got the id NXP1001. This one is not
> listed in the match table of the nxp-nci driver.
> 
>  - is the driver missing for the so called NXP NPC300 ?
>  - should the NXP1001 matching string to be added to nxp-nci?
>  - is my firmware sending me garbage ?
> 
> Thanks in advance for any input
> 
>   -- Daniel
> 
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

