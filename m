Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87D16C46475
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 11:41:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C61C20827
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 11:41:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Tvm8ac20"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4C61C20827
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728870AbeKEVAs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 16:00:48 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36832 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbeKEVAs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 16:00:48 -0500
Received: by mail-wr1-f67.google.com with SMTP id z13-v6so6752201wrs.3
        for <linux-wireless@vger.kernel.org>; Mon, 05 Nov 2018 03:41:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=66xr50aaG3/Q+U1POs6d8CYHEZJY0aHTQ/8ucxC48kg=;
        b=Tvm8ac20GcKAypBjf1tbgJb6u4XBbvrQIFjg6ovAs9lQaxeA/7M9emfzrpjgJsiXyZ
         v5K88Sm/gJtdIFdMmUCa8QOBCElHSYreJTP4Wb7YruzwDdan9rRRJzSeQPfH2/JWMZny
         6lq/99jygVwRVc4hRsA26m+JR5txNX01IXi6E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=66xr50aaG3/Q+U1POs6d8CYHEZJY0aHTQ/8ucxC48kg=;
        b=QY3QKvOMYYWWshiiJSmo+oOoZ5I/+XlXRwxUViAzDwBNmF++1HTgKD7U0m4WgmXH0R
         JdiLKatcmsFIeImsCH9APdNWZL5fJFwtvTCthzMF7PEjeleynPpGIx6pxgyldqxLIsMF
         kRzizbmGS3gFTRAGELnyO5kjjPLwI0NdTsvsNiVsb2E7G80qfz51d+NQvn7jm+wqFYU5
         dN9JTVnnWIsad0NDsWMkFMizb2d+imzOJqrNck8EGhotyNLX/Qcuv1+VYlaD8H2c5VAa
         SVFTGjbjzpk/HAybqwOIKGxZAkCtfPCoLcAGzbMnUM7QaUW0UW/q3oq3hy1fjt4FUX9b
         mb2w==
X-Gm-Message-State: AGRZ1gIiPHkQhVMbGraH1oZC1HnuhbNOiw1eOxuc8x7Ei1ey2hp/RrvZ
        gJPHSrJktE+yAqxZPj43d5aWEw==
X-Google-Smtp-Source: AJdET5fE0Kr3ldDzHU1Gu5ZqDSktmhUtQnNB2C1W/CpbniTPMqEkoRWBB0lJd37hJbzIAVqtfXSsYA==
X-Received: by 2002:adf:a31c:: with SMTP id c28-v6mr19478841wrb.195.1541418088483;
        Mon, 05 Nov 2018 03:41:28 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id o9-v6sm49018424wra.42.2018.11.05.03.41.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Nov 2018 03:41:28 -0800 (PST)
Subject: Re: [PATCH 5/6] brcmfmac: Set board_type from DMI on x86 based
 machines
To:     Hans de Goede <hdegoede@redhat.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
References: <20181009124755.25402-1-hdegoede@redhat.com>
 <20181009124755.25402-5-hdegoede@redhat.com>
Cc:     linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <39789888-ddad-afcb-3abd-104ef544ca26@broadcom.com>
Date:   Mon, 5 Nov 2018 12:41:27 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <20181009124755.25402-5-hdegoede@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/9/2018 2:47 PM, Hans de Goede wrote:
> For x86 based machines, set the board_type used for nvram file selection
> based on the DMI sys-vendor and product-name strings.
>
> Since on some models these strings are too generic, this commit also adds
> a quirk table overriding the strings for models listed in that table.
>
> The board_type setting is used to load the board-specific nvram file with
> a board-specific name so that we can ship files for each supported board
> in linux-firmware.

some comments below....

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  .../broadcom/brcm80211/brcmfmac/Makefile      |   2 +
>  .../broadcom/brcm80211/brcmfmac/common.c      |   3 +-
>  .../broadcom/brcm80211/brcmfmac/common.h      |   7 ++
>  .../broadcom/brcm80211/brcmfmac/dmi.c         | 104 ++++++++++++++++++
>  4 files changed, 115 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile
> index 1f5a9b948abf..22fd95a736a8 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile
> @@ -54,3 +54,5 @@ brcmfmac-$(CONFIG_BRCM_TRACING) += \
>  		tracepoint.o
>  brcmfmac-$(CONFIG_OF) += \
>  		of.o
> +brcmfmac-$(CONFIG_DMI) += \
> +		dmi.o

Assuming OF and DMI are mutual exclusive, right?

> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
> new file mode 100644
> index 000000000000..fadc0ec745b8
> --- /dev/null
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c

[...]

> +static const struct dmi_system_id dmi_platform_data[] = {

maybe call this dmi_platform_quirk as in brcmf_dmi_probe() you call this 
a "quirk table".
