Return-Path: <SRS0=3nVx=R2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D857C43381
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Mar 2019 07:20:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31B7D218B0
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Mar 2019 07:20:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="CbLLBghk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbfCWHUK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 23 Mar 2019 03:20:10 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:43245 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbfCWHUJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 23 Mar 2019 03:20:09 -0400
Received: by mail-ed1-f65.google.com with SMTP id d26so3483355ede.10
        for <linux-wireless@vger.kernel.org>; Sat, 23 Mar 2019 00:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sFVgfGhHpWfpMO6brJVUK+bYMbf2CpnViSGhcuPtNwU=;
        b=CbLLBghk3t1k9gCCIJswcQsarQ4OEVoWtIzmwOrfGMU4dM2qbfFidbjKjXiNV9id70
         QHX6J/8adY4wSJJHVfN7Qs906eDBtDGMZgR0Ju9ywTDJdUUpczE4UEfu1fchobv2mjF7
         1eUMlqHmUSIQFJcW7kuuu0IRsvSIsl/qWXSuw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sFVgfGhHpWfpMO6brJVUK+bYMbf2CpnViSGhcuPtNwU=;
        b=e+w6MDcm2YU7iRruOZLUr4Ls4pgB6Q00WNpyGlJHOY/pYRtYCSCwZwYCim6DxBb6BE
         QS5LAQW8ikOci+LMDZbZzr+Tn+7V1plJZLDxchNyNHhUaA+ZFe7HnuysGWev1MHgbyrs
         2Okbf83XuIDAMzppMrZek96RxDgLe1JxB9F3PbYUwBDlZeIQFSyCqq6fSCPQ6UDFYNyq
         eeZtLMIu4zLMbSVSVYjd/rKilwmgv85vczigKWSmYvLqb+0/VpLC2zoID0DLlaIYWuip
         fp/+5/PsoPscA7/2rY909fglnK/eD8nWatMqw5YtGVJziTvTFm+Qx2A89fZnnXHKtmjW
         WvIw==
X-Gm-Message-State: APjAAAVpoWFimEht4Cnapo12GzRBpPGrGvMCcEMzQJ/loVD4DvATUE3q
        Rsqlsy4rrarBWwtNisGOQdOvyw==
X-Google-Smtp-Source: APXvYqw6B+ha233J8H/7d796pKqRGtgwShT1+V7ymHxbEUYpAhc6h5IpcM+mf6H+wJov7OI2KDrrLA==
X-Received: by 2002:a50:9e61:: with SMTP id z88mr9302109ede.100.1553325608420;
        Sat, 23 Mar 2019 00:20:08 -0700 (PDT)
Received: from [192.168.178.129] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id a2sm3246441eds.45.2019.03.23.00.20.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Mar 2019 00:20:07 -0700 (PDT)
Subject: Re: [PATCH] ath10k: reset chip after supported check
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
To:     Christian Lamparter <chunkeey@gmail.com>,
        =?UTF-8?Q?Tomislav_Po=c5=beega?= <pozega.tomislav@gmail.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        openwrt-devel@lists.openwrt.org, Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?Q?Micha=c5=82_Kazior?= <kazikcz@gmail.com>
References: <1553281120-22139-1-git-send-email-pozega.tomislav@gmail.com>
 <3337086.qEUs9xMCTV@debian64>
 <fe853ec8-0dca-d931-8632-fbe4df5cfaf8@broadcom.com>
Message-ID: <edc38f32-977a-53f5-babd-605775326a20@broadcom.com>
Date:   Sat, 23 Mar 2019 08:20:07 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <fe853ec8-0dca-d931-8632-fbe4df5cfaf8@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

* resending with corrected email address from Kalle
--------------------------------------------------------------------
+ Michał

On 3/22/2019 8:25 PM, Christian Lamparter wrote:
 > On Friday, March 22, 2019 7:58:40 PM CET Tomislav Požega wrote:
 >> When chip reset is done before the chip is checked if supported
 >> there will be crash. Previous behaviour caused bootloops on
 >> Archer C7 v1 units, this patch allows clean device boot without
 >> excluding ath10k driver.
 >>
 > You need
 >
 > Fixes: 1a7fecb766c8 ("ath10k: reset chip before reading chip_id in 
probe")
 >
 > too

Looking at the commit subject makes me suspicious whether this is a 
proper fix.

 >> Signed-off-by: Tomislav Požega <pozega.tomislav@gmail.com>
 >> ---
 >>   drivers/net/wireless/ath/ath10k/pci.c |   12 ++++++------
 >>   1 files changed, 6 insertions(+), 6 deletions(-)
 >>
 >> diff --git a/drivers/net/wireless/ath/ath10k/pci.c 
b/drivers/net/wireless/ath/ath10k/pci.c
 >> index e24403c..ec681da 100644
 >> --- a/drivers/net/wireless/ath/ath10k/pci.c
 >> +++ b/drivers/net/wireless/ath/ath10k/pci.c
 >> @@ -3619,12 +3619,6 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 >>   		goto err_deinit_irq;
 >>   	}
 >>
 >> -	ret = ath10k_pci_chip_reset(ar);
 >> -	if (ret) {
 >> -		ath10k_err(ar, "failed to reset chip: %d\n", ret);
 >> -		goto err_free_irq;
 >> -	}
 >> -
 >>   	bus_params.dev_type = ATH10K_DEV_TYPE_LL;
 >>   	bus_params.link_can_suspend = true;
 >>   	bus_params.chip_id = ath10k_pci_soc_read32(ar, SOC_CHIP_ID_ADDRESS);

It seems to me the chip reset was done explicitly *before* reading the 
chipid for a reason.

"""
ath10k: reset chip before reading chip_id in probe
There are some very rare cases with some hardware
configuration that the device doesn't init quickly
enough in which case reading chip_id yielded 0.
This caused driver to subsequently fail to setup
the device.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
"""

Might be the ath10k_pci_chip_reset() function needs to be modified to 
work properly for Archer C7 v1 units.

Regards,
Arend
