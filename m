Return-Path: <SRS0=G8on=RY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F95DC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 17:06:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C72521902
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 17:06:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="THlvYh0k";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="oKCRe3x9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbfCURGu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Mar 2019 13:06:50 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:58686 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbfCURGu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Mar 2019 13:06:50 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E2F5A61B5D; Thu, 21 Mar 2019 17:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553188008;
        bh=8df6kmaM/lxIeunygn87DAa8obJWVXEk5w1R/5N95eU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=THlvYh0k2CYdHSg7vOlH4uRMFhOHxty/5uHpKSnpC/H2sJPQSp0pqIQyInNj5cxRQ
         xHmNX7o1b38s4fZYhYZ8OttBRFeHGXZZjERvZTLhAuyxX+p/R4J/X4faOg3eD4yDJS
         ButMC11MnEQfw3a6nsXDJ+Ex8K+MTN78um6rVN8c=
Received: from x230.qca.qualcomm.com (unknown [195.39.71.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 76CAE61573;
        Thu, 21 Mar 2019 17:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553188007;
        bh=8df6kmaM/lxIeunygn87DAa8obJWVXEk5w1R/5N95eU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=oKCRe3x9Ch7MZSNcMqd9sxyVEVxETTIdLJoga2ONscHRwUIc17qJueTPYq4xRiE1y
         9lvZACbUilNCdanEgbRfIujTDChUudoedRPFLCZlyQTYy2d/vYxrO06dFGVlcTfCXa
         g5VV3BcJnoJoCHVJhFg1mZllKgw7ih0gMe2oRyZo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 76CAE61573
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: Re: [PATCH 12/14] qtnfmac: fix debugfs entries for multiple cards on the same host
References: <20190320100340.14168-1-sergey.matyukevich.os@quantenna.com>
        <20190320100340.14168-13-sergey.matyukevich.os@quantenna.com>
        <874l7xzlmo.fsf@purkki.adurom.net>
        <20190320151641.3477cx3kuc3ipqam@bars> <8736ngsms9.fsf@codeaurora.org>
        <5d1012ab-9c4e-3c14-05b6-f76e6fde2951@broadcom.com>
Date:   Thu, 21 Mar 2019 19:06:43 +0200
In-Reply-To: <5d1012ab-9c4e-3c14-05b6-f76e6fde2951@broadcom.com> (Arend Van
        Spriel's message of "Thu, 21 Mar 2019 11:14:59 +0100")
Message-ID: <87lg18nom4.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Arend Van Spriel <arend.vanspriel@broadcom.com> writes:

> On 3/21/2019 8:35 AM, Kalle Valo wrote:
>> Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:
>>
>>>>> Fix creation of debugfs entries for qtnfmac wireless card: use separate
>>>>> directories for different wireless cards. This commit enables support
>>>>> for multiple qtnfmac wireless cards on the same PCIe host.
>>>>>
>>>>> Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
>>>>> ---
>>>>>   drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c | 6 +++++-
>>>>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
>>>>> index b561b75e4433..56fc6d49c121 100644
>>>>> --- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
>>>>> +++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
>>>>> @@ -130,6 +130,8 @@ static int qtnf_dbg_shm_stats(struct seq_file *s, void *data)
>>>>>
>>>>>   int qtnf_pcie_fw_boot_done(struct qtnf_bus *bus)
>>>>>   {
>>>>> +     struct qtnf_pcie_bus_priv *priv = get_bus_priv(bus);
>>>>> +     char card_id[64];
>>>>>        int ret;
>>>>>
>>>>>        bus->fw_state = QTNF_FW_STATE_BOOT_DONE;
>>>>> @@ -137,7 +139,9 @@ int qtnf_pcie_fw_boot_done(struct qtnf_bus *bus)
>>>>>        if (ret) {
>>>>>                pr_err("failed to attach core\n");
>>>>>        } else {
>>>>> -             qtnf_debugfs_init(bus, DRV_NAME);
>>>>> +             snprintf(card_id, sizeof(card_id), "%s:%s",
>>>>> +                      DRV_NAME, pci_name(priv->pdev));
>>>>
>>>> Can you give an example for the path?
>>>>
>>>
>>> For instance:  /sys/kernel/debug/qtnfmac_pcie:0000:01:00.0
>>
>> TBH not really fond of that. What about
>> "/sys/kernel/debug/qtnfmac/pcie:0000:01:00.0"? IIRC iwlwifi used
>> something like that.
>
> In brcmfmac we used to have it like that, but I changed it to use
> wiphy debugfs, ie. /sys/kernel/debug/ieee80211/phyX/.

Yeah, that's much better.

-- 
Kalle Valo
