Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69646C32789
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 11:53:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E15A20892
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 11:53:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="bt0seOLv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E15A20892
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbeKHV2q (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 16:28:46 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:46441 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbeKHV2q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 16:28:46 -0500
Received: by mail-yb1-f195.google.com with SMTP id i17-v6so1889916ybp.13
        for <linux-wireless@vger.kernel.org>; Thu, 08 Nov 2018 03:53:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:subject:to:references:cc:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=SF0J1arw+DtvUBFqsvZRKWbquMI4DaRrX3eCBPNlmVg=;
        b=bt0seOLvRdZeX85WeEGdGjivB3cqLkS/Tx37d3B14Ll0wsw8yKkFWh57iZY4rgblOu
         wEQH/jRThCPzqkvsQ6ENiRW0NjBqDrw4A297Jf+d6Ihw5o/HAhAa/1pfQoSz/wEKrqa/
         +uHmgGQ3fi1CmVYdP+ElNkh49VokrTmqcZvSk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:references:cc:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=SF0J1arw+DtvUBFqsvZRKWbquMI4DaRrX3eCBPNlmVg=;
        b=n+mg3DxGUf4qPYFfIzwtR3E1GfCb5gSjev/gm509FC5DNJTipRwFHsR4fJNIShFYuf
         dHstHrOh0V9UDl1sGllyPmefBxha2wP3hBfaqWr7z8KmFomW/se97f/rQ6DC9vaPCI6x
         iPwiCSPmvT/rRzCVqs6ySse+WplrePGcfi8TM5B0Kuo6ZHk7b+pjIntv68M5y9oveIv8
         c4dbZBCU/Q7OMytsubzof8KoQiZyXcgZ5rlJjLP/2rlc7R0rfGDqtjqoCitpM7nNwSRp
         Svrsi1QJLjagZRTbFClhkSJ3cH5quj3qHl490C8YCOEA2zz1ECMkOjLLrj8HC1NWXtED
         Vcjg==
X-Gm-Message-State: AGRZ1gJVYiV0XACqLAPcNY3S24kEl0pYgd7TWeYvxfMNRKw/vrDdC+uN
        3bLNz5RWPfpVmLAdBUzGcuUBhg==
X-Google-Smtp-Source: AJdET5fz5uMwcTWwNIJ68fEij3uyn6w7WbwaGKIUGj3vvuTFq91YXs0PmZsd7aENlD7TltDzrV6EgQ==
X-Received: by 2002:a25:4e86:: with SMTP id c128-v6mr3804197ybb.186.1541678017068;
        Thu, 08 Nov 2018 03:53:37 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id 200-v6sm863571ywq.97.2018.11.08.03.53.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Nov 2018 03:53:36 -0800 (PST)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 04/11] brcmfmac: add support for CYW43012 SDIO chipset
To:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1541476188-75475-1-git-send-email-chi-hsien.lin@cypress.com>
 <1541476188-75475-5-git-send-email-chi-hsien.lin@cypress.com>
Cc:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
Message-ID: <faa2ef32-5816-506a-4ee0-d686e9ced4a8@broadcom.com>
Date:   Thu, 8 Nov 2018 12:53:34 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <1541476188-75475-5-git-send-email-chi-hsien.lin@cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/6/2018 4:50 AM, Chi-Hsien Lin wrote:
> CYW43012 is a 1x1 802.11a/b/g/n Dual-Band HT20, 256-QAM/Turbo QAM. It
> is an Ultra Low Power WLAN+BT combo chip.

comments below....

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> ---
>  .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |  1 +
>  .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |  9 ++++-
>  .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 40 ++++++++++++++++++----
>  .../broadcom/brcm80211/include/brcm_hw_ids.h       |  1 +
>  include/linux/mmc/sdio_ids.h                       |  1 +
>  5 files changed, 45 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> index 34a838fcc319..299f59f58d8c 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> @@ -677,6 +679,15 @@ brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on)
>  	/* 1st KSO write goes to AOS wake up core if device is asleep  */
>  	brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR, wr_val, &err);
>
> +	/* In case of 43012 chip, the chip could go down immediately after
> +	 * KSO bit is cleared. So the further reads of KSO register could
> +	 * fail. Thereby just bailing out immediately after clearing KSO
> +	 * bit, to avoid polling of KSO bit.
> +	 */
> +	if (!on && bus->ci->chip == CY_CC_43012_CHIP_ID) {
> +		return err;
> +	}

kernel coding style does not require curly braces here.

>  	if (on) {
>  		/* device WAKEUP through KSO:
>  		 * write bit 0 & read back until
> @@ -2436,9 +2447,20 @@ static void brcmf_sdio_bus_stop(struct device *dev)
>  		/* Force backplane clocks to assure F2 interrupt propagates */
>  		saveclk = brcmf_sdiod_readb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
>  					    &err);
> -		if (!err)
> -			brcmf_sdiod_writeb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
> -					   (saveclk | SBSDIO_FORCE_HT), &err);
> +		if (!err) {
> +			if (bus->ci->chip == CY_CC_43012_CHIP_ID) {
> +				brcmf_sdiod_writeb(sdiodev,
> +						   SBSDIO_FUNC1_CHIPCLKCSR,
> +						   (saveclk |
> +						    SBSDIO_HT_AVAIL_REQ),
> +						   &err);
> +			} else {
> +				brcmf_sdiod_writeb(sdiodev,
> +						   SBSDIO_FUNC1_CHIPCLKCSR,
> +						   (saveclk | SBSDIO_FORCE_HT),
> +						   &err);
> +			}
> +		}

I prefer we avoid checks for chip id as much as possible. Maybe have 
chip module provide helper function, ie.

		if (!err) {
			bpreq = saveclk;
			bpreq |= brcmf_chip_is_ulp(bus->ci) ?
				 SBSDIO_HT_AVAIL_REQ : SBSDIO_FORCE_HT;
			brcmf_sdio_writeb(sdiodev,
					  SBSDIO_FUNC1_CHIPCLKCSR,
					  bpreq, &err);
		}
