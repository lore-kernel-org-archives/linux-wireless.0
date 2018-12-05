Return-Path: <SRS0=FjVT=OO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1AC4C04EB9
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 07:38:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96ED3204FD
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 07:38:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="i7UNurSI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 96ED3204FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbeLEHiQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 5 Dec 2018 02:38:16 -0500
Received: from mail-wm1-f50.google.com ([209.85.128.50]:40237 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726351AbeLEHiQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Dec 2018 02:38:16 -0500
Received: by mail-wm1-f50.google.com with SMTP id q26so11724172wmf.5
        for <linux-wireless@vger.kernel.org>; Tue, 04 Dec 2018 23:38:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=CVA/iyTTZkux/GBNFtba3BZauyBeFjyPxFP/pB7ACQ0=;
        b=i7UNurSIGx9adsEBRzZUM0G08RIIuyw8KaeC/aEyPUxyErdAua9gRzLSdBRDXg7tW6
         QjvWdZQ95cqWtQelzGHu6ge010WnHRj2EjGHZ9k3JOEIVp7YEdI9wkZ1UYx3yRhVRLob
         P0XyWDC1oRP4fiQiFWuLH190c/bPcvSed0Xcw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=CVA/iyTTZkux/GBNFtba3BZauyBeFjyPxFP/pB7ACQ0=;
        b=Dmeq/TLWXEthRXtlB+PpFeuwPx+yKHEJOUPRP65esUGBeltyyaojx53qXKEC4QdCtd
         7BEqZOuufscsJEed7sSZvIJpAiEMTe0KOuFfK/i1CyM5btSWu6VUXC5KRtWz+afOH5Bw
         N1A3zh2UAC5ZNyeK4Ki77NhMu5fkqPeI8cERACJAltLUWXZbL/cocIrM9faAMg9LrCNH
         en9En9A8v35M9QB0pdXdnlyyd32WZuMvZCxwNOW+woncCAxHab7TbuQ2HebdHgzIhk8j
         OlEgsG1A45STzaneU/HOHuCDXSve8h/VhwgXTXzS34UFsylHCSnFZsEXGcW3QS2tOfFM
         H9nA==
X-Gm-Message-State: AA+aEWa+UiZbgZTFjUEN9C+LpdSd6vxlnzpml/j3lSUGYc03cbxD6YaQ
        f5Jg3YeOoaQdnILd4eNb4hd2yA==
X-Google-Smtp-Source: AFSGD/WIUlOu30fHYz6vSdwafOb/gqAvGzub1S/Utvi4jFdfQHhB8Qx/gh+AomeEGEgn8lu/XRjBiA==
X-Received: by 2002:a1c:43:: with SMTP id 64mr15925359wma.72.1543995494338;
        Tue, 04 Dec 2018 23:38:14 -0800 (PST)
Received: from [192.168.0.40] (sju31-1-78-210-255-2.fbx.proxad.net. [78.210.255.2])
        by smtp.googlemail.com with ESMTPSA id k7sm21111692wrl.51.2018.12.04.23.38.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Dec 2018 23:38:13 -0800 (PST)
To:     Samuel Ortiz <sameo@linux.intel.com>
Cc:     linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        robert.dolca@intel.com, oleg.zhurakivskyy@intel.com,
        clement.perrochaud@effinnov.com, charles.gorand@effinnov.com
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: NXP NFC version and ACPI
Message-ID: <c2d0d19f-d814-8f41-4860-77b9cc7f9d26@linaro.org>
Date:   Wed, 5 Dec 2018 08:38:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


Hi,

the discussion reference is on github [1].

I acquired a Lenovo x280 with a NFC chip. It is unclear what chip is it
really, it is called NXP NPC300 which could be a PN7xxx chip range.

A hacked version of an old deprecated out-of-tree module made the PN5xxx
to work with my laptop but I suspect it brought some subtle instability
on my system.

Now it would be nice to have this correctly supported upstream.

I dumped the ACPI DSDT table and got the id NXP1001. This one is not
listed in the match table of the nxp-nci driver.

 - is the driver missing for the so called NXP NPC300 ?
 - should the NXP1001 matching string to be added to nxp-nci?
 - is my firmware sending me garbage ?

Thanks in advance for any input

  -- Daniel


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

