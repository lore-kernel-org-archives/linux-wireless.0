Return-Path: <SRS0=G8on=RY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C12EC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 10:15:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF5FC218AE
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 10:15:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ZKm0s6Yf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbfCUKPF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Mar 2019 06:15:05 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41567 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727575AbfCUKPE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Mar 2019 06:15:04 -0400
Received: by mail-pf1-f193.google.com with SMTP id d25so3986048pfn.8
        for <linux-wireless@vger.kernel.org>; Thu, 21 Mar 2019 03:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nhdEiFL0ASiP05JdpuKEDuSySDlHai0ufjYYoY1ZDPs=;
        b=ZKm0s6YfHNx/aRGNq4DgFFKYGwON5JOcLO29VSWSuz6hi2UiPJxALI94JV9YBLdMfE
         fus1kvdLQAFtarObxmeZ6T2r+wHXQV86U2q6OnlyyTXGKVT9vzPgZ/GKFgfr8klcSjTR
         yuRLbCTdyqfpwZ2PVWqrFlA3IognMavQQgQyg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nhdEiFL0ASiP05JdpuKEDuSySDlHai0ufjYYoY1ZDPs=;
        b=lNskTpPNDhUG/N9Yyfbd3SJQmlNtGtWAace8Hrtnc5+Xpicp0yjzkwhK7TsE3y+atB
         YDahuXE4GDnMnjxF+QrlLMz/c6jCyM0gT4qhWqU+3RLgsgccLCdIMOShflEZQAC64wSr
         1A7uUP7GdjYstUsolE9OLl7xZ20C+6NutqmTdqfOLmo9Lry+kpSufX/COIGuODfEPa+r
         izDYspHrs53qREwnBxwMejGaCMC+hODhC0PYEqP1C6CmEK8G/EvmrxvAn5MG6WJnPB00
         GqDNDYZ2mdq5Nn8gFpNnIaNic0WznUN76+z/hqmxlzdqWWZ/ggXgCs8U4AKHGZy9+Nej
         CEwQ==
X-Gm-Message-State: APjAAAXmrGLXsZXRpzaIow7jFyl37sI6pFQIWk9VUw26X61efv070r/O
        7001yWftyLms6FslfbqOaFdb3Q==
X-Google-Smtp-Source: APXvYqz2FjpZSDgL4UtNmYIi3t5asRaF5AXNCyjDisICXoUc4h+4UzCTvR94T8O7SoY1kEo4R8Wc5A==
X-Received: by 2002:a65:5c46:: with SMTP id v6mr2554409pgr.309.1553163302975;
        Thu, 21 Mar 2019 03:15:02 -0700 (PDT)
Received: from [10.230.40.234] ([192.19.215.250])
        by smtp.gmail.com with ESMTPSA id j20sm10693657pfi.27.2019.03.21.03.15.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Mar 2019 03:15:02 -0700 (PDT)
Subject: Re: [PATCH 12/14] qtnfmac: fix debugfs entries for multiple cards on
 the same host
To:     Kalle Valo <kvalo@codeaurora.org>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
References: <20190320100340.14168-1-sergey.matyukevich.os@quantenna.com>
 <20190320100340.14168-13-sergey.matyukevich.os@quantenna.com>
 <874l7xzlmo.fsf@purkki.adurom.net> <20190320151641.3477cx3kuc3ipqam@bars>
 <8736ngsms9.fsf@codeaurora.org>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5d1012ab-9c4e-3c14-05b6-f76e6fde2951@broadcom.com>
Date:   Thu, 21 Mar 2019 11:14:59 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <8736ngsms9.fsf@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 3/21/2019 8:35 AM, Kalle Valo wrote:
> Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:
> 
>>>> Fix creation of debugfs entries for qtnfmac wireless card: use separate
>>>> directories for different wireless cards. This commit enables support
>>>> for multiple qtnfmac wireless cards on the same PCIe host.
>>>>
>>>> Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
>>>> ---
>>>>   drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c | 6 +++++-
>>>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
>>>> index b561b75e4433..56fc6d49c121 100644
>>>> --- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
>>>> +++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
>>>> @@ -130,6 +130,8 @@ static int qtnf_dbg_shm_stats(struct seq_file *s, void *data)
>>>>
>>>>   int qtnf_pcie_fw_boot_done(struct qtnf_bus *bus)
>>>>   {
>>>> +     struct qtnf_pcie_bus_priv *priv = get_bus_priv(bus);
>>>> +     char card_id[64];
>>>>        int ret;
>>>>
>>>>        bus->fw_state = QTNF_FW_STATE_BOOT_DONE;
>>>> @@ -137,7 +139,9 @@ int qtnf_pcie_fw_boot_done(struct qtnf_bus *bus)
>>>>        if (ret) {
>>>>                pr_err("failed to attach core\n");
>>>>        } else {
>>>> -             qtnf_debugfs_init(bus, DRV_NAME);
>>>> +             snprintf(card_id, sizeof(card_id), "%s:%s",
>>>> +                      DRV_NAME, pci_name(priv->pdev));
>>>
>>> Can you give an example for the path?
>>>
>>
>> For instance:  /sys/kernel/debug/qtnfmac_pcie:0000:01:00.0
> 
> TBH not really fond of that. What about
> "/sys/kernel/debug/qtnfmac/pcie:0000:01:00.0"? IIRC iwlwifi used
> something like that.

In brcmfmac we used to have it like that, but I changed it to use wiphy 
debugfs, ie. /sys/kernel/debug/ieee80211/phyX/.

Gr. AvS
