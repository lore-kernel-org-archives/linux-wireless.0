Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFD33C4360F
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 23:06:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D825206C0
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 23:06:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="McjvCXV4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbfBVXGe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 18:06:34 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:37040 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbfBVXGc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 18:06:32 -0500
Received: by mail-yb1-f195.google.com with SMTP id i205so1508271yba.4
        for <linux-wireless@vger.kernel.org>; Fri, 22 Feb 2019 15:06:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6S6rmP1K8sK0doULcmm6vnedXQXIRz5FE7A4KC6EF60=;
        b=McjvCXV4afZ7Rqupqqq1fJeySdFv686s+xdZENfaBQyzPG90V+gBkzpmg+fWFA2xcW
         ZUsdWug3EyfIA7tlA3K0FaN5ll+r1A+il/yxf3LwSfexbjoFp3D6cydG71LZ835CuwHV
         Eu3JGm+BB3QXmT4+Rnbe/cLfd+rSAJsH2mUpQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6S6rmP1K8sK0doULcmm6vnedXQXIRz5FE7A4KC6EF60=;
        b=Ywz7eXKtkcVq64yzL+lid43yHiT5X1BRDDNy+RfFQnA4yZPY/k/EMQdB/vYmKjg3yl
         HOHno3k+BNdajcw7nnyvg3ex9W6mIKopQsVXHiRuA0N0rPYVM5PBMgUDJwmLfmTFT+9H
         /XBev20Px1G5l43teBXaz+mQVoBLSlBowho/PFpcPG22lvXBJ60jJcNx/3XTkJ2LBrcx
         lrd/vSOnCmRaVTxuukXqQkiUlglf7ePT1R+Km+MRSl326M0xy+p/HMa7A9vC0RacNkL9
         Nmn2dyssmNC4niDqKZWr7kMRZvqUrpcM/lv0wN7VvggmHtZhvMbpylQVJ7HckdhDhkgu
         aupg==
X-Gm-Message-State: AHQUAuaF3zke8uWU29N6hepFnJp9h+k+oBqXzKHwmh3gVKplqVeHwEso
        kXSWMNbcx/ph32KqkgauAAbpyw==
X-Google-Smtp-Source: AHgI3Ia/6OJGBnp3/rUpXSXjCEq9gdBJQKaTKjWCpVJnIGTfkPDnHh/ginUQrCHjMK9BqhBWJeduGA==
X-Received: by 2002:a5b:9cd:: with SMTP id y13mr5397639ybq.197.1550876791671;
        Fri, 22 Feb 2019 15:06:31 -0800 (PST)
Received: from [10.230.40.234] ([192.19.215.250])
        by smtp.gmail.com with ESMTPSA id h189sm885050ywd.24.2019.02.22.15.06.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Feb 2019 15:06:31 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: run firmware state watchdog on the host machine
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20190222170739.14266-1-zajec5@gmail.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <751f8cc0-3ec2-9aad-2c21-c52d5098272a@broadcom.com>
Date:   Sat, 23 Feb 2019 00:06:27 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190222170739.14266-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2/22/2019 6:07 PM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> FullMAC firmware may happen to crash due to some potential bugs exposed
> by e.g. a specific traffic or host-requested setup. It usually results
> in various timeouts & running our of resources (e.g. ring slots).
> 
> Monitoring firmware state allows handling such a situation more
> gracefully. At this point the watchdog:
> 1) Prints a clear error message about a firmware crash
> 2) Tries to dump a crash info data

Hi Rafał,

I like the idea of having firmware crashes detected, but not sure I am a 
big fan of the watchdog mechanism.

> That should be helpful for users & should allow providing a valuable
> reports for the Broadcom developers. It obviously doesn't really fix
> anything.

Agree on the value of it and it is new functionality indeed and not a fix.

> This watchdog is important for USB & SDIO devices which don't have
> anything alike implemented yet. It's also there to complement PCIe with
> its FWHALT signal which does not work in all situations.

Actually, SDIO does already have a watchdog, but it serves different 
purpose (get firmware console, idle detect). There is also a 
brcmf_sdio_checkdied() function to detect a firmware crash. It is being 
called in brcmf_sdio_bus_rxctl() when firwmare does not respond as 
expected [1]. Similar thing can be done for PCIE and I actually started 
working on that last week. USB is a bit different as it will switch to 
bootloader image when firmware crashes.

Regards,
Arend

[1] 
https://elixir.bootlin.com/linux/latest/source/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c#L3144
