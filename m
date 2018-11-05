Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E476C46475
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 11:41:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2A3F20827
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 11:41:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="CLHD3CRl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D2A3F20827
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728970AbeKEVAZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 16:00:25 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42149 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbeKEVAZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 16:00:25 -0500
Received: by mail-wr1-f66.google.com with SMTP id y15-v6so9128352wru.9
        for <linux-wireless@vger.kernel.org>; Mon, 05 Nov 2018 03:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:subject:to:references:cc:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=g2MEib2koj9j6RwwO9EdH+5sYPvKs8jwxZbPUwo0Jus=;
        b=CLHD3CRlGcZiHA0zdfmuL2RIotd3w6zh0qeUNpovf5KUnn0SuXhl596y3jKzOeVg+1
         LOW7iRSRgOPV1UUFnJdcF5VWDfvDirYuWVEcEL7lM4sVnE4GNGSf/tQBksNdk3l0Oa4O
         /NwUqBP0tSbvwWxPYPEDxHS8W4b3/FQueFwTU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:references:cc:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=g2MEib2koj9j6RwwO9EdH+5sYPvKs8jwxZbPUwo0Jus=;
        b=CYvRzE1EgjTVPbgjuqR3cS2VO2ezVnAxUlflpX36CgrECe36mWCX+V/Y0RgQKhqrOV
         sXYgvTZDWuqRi4IGWXRZLYGUKbbQLX+axSkmogUXM7I7G2GRChIsmVJebNkmtfhysUGH
         LUkavhKa2HIUZWhaPlfGJjxnBGvsLwYgM7M+lEP1q1qHhcYWDCD28o81LcrJsZgyU6TP
         ufzxzo2i6yqBvA/KUWgASYGn83SWnRKwQvTEiBAVh1IJngcHcg637/bH/4UmNxOCkzCO
         qy53xXiHmgL6t5/qmwyRXtDHcMTkQCwnIO4uz5rNgQaUNAUJqPVC5Rs0jD5oSMutCiaG
         bUgw==
X-Gm-Message-State: AGRZ1gLHMlUr9i2fml6+wvypQE/dS51n0zbOefzS3TFr3UMd85XhUd29
        eb+RdkLjfS3yKNRKR9DgUOZF1A==
X-Google-Smtp-Source: AJdET5cyR4G0GXpm+row4Sd+FsPmvWIpo4kzZOfE/ZDi59ybF2FYpm5d3KFlqajJEuZy/FChZgyUrg==
X-Received: by 2002:adf:9d4a:: with SMTP id o10-v6mr16375880wre.94.1541418065596;
        Mon, 05 Nov 2018 03:41:05 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id l140-v6sm64540091wmb.24.2018.11.05.03.41.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Nov 2018 03:41:05 -0800 (PST)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 3/6] brcmfmac: Add support for first trying to get a board
 specific nvram file
To:     Hans de Goede <hdegoede@redhat.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
References: <20181009124755.25402-1-hdegoede@redhat.com>
 <20181009124755.25402-3-hdegoede@redhat.com>
Cc:     linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Message-ID: <c0415f15-d3cf-2693-be61-26151c5c030b@broadcom.com>
Date:   Mon, 5 Nov 2018 12:41:04 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <20181009124755.25402-3-hdegoede@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/9/2018 2:47 PM, Hans de Goede wrote:
> The nvram files which some brcmfmac chips need are board-specific. To be
> able to distribute these as part of linux-firmware, so that devices with
> such a wifi chip will work OOTB, multiple (one per board) versions must
> co-exist under /lib/firmware.
>
> This commit adds support for callers of the brcmfmac/firmware.c code to
> pass in a board_type parameter through the request structure.
>
> If that parameter is set then the code will first try to load
> chipmodel.board_type.txt before falling back to the old chipmodel.txt name.

minor comment below...

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  .../broadcom/brcm80211/brcmfmac/firmware.c    | 27 ++++++++++++++++++-
>  .../broadcom/brcm80211/brcmfmac/firmware.h    |  1 +
>  2 files changed, 27 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
> index 08aaf99fee34..6755b2388fbc 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
> @@ -532,6 +532,31 @@ static int brcmf_fw_complete_request(const struct firmware *fw,
>  	return (cur->flags & BRCMF_FW_REQF_OPTIONAL) ? 0 : ret;
>  }
>
> +static int brcmf_fw_request_firmware(const struct firmware **fw,
> +				     struct brcmf_fw *fwctx)
> +{
> +	struct brcmf_fw_item *cur = &fwctx->req->items[fwctx->curpos];
> +	int ret;
> +
> +	/* nvram files are board-specific, first try a board-specific path */
> +	if (cur->type == BRCMF_FW_TYPE_NVRAM && fwctx->req->board_type) {
> +		char alt_path[BRCMF_FW_NAME_LEN];
> +
> +		strlcpy(alt_path, cur->path, BRCMF_FW_NAME_LEN);
> +		/* strip .txt at the end */
> +		alt_path[strlen(alt_path) - 4] = 0;
> +		strlcat(alt_path, ".", BRCMF_FW_NAME_LEN);

why not string just "txt"?

> +		strlcat(alt_path, fwctx->req->board_type, BRCMF_FW_NAME_LEN);
> +		strlcat(alt_path, ".txt", BRCMF_FW_NAME_LEN);
> +
> +		ret = request_firmware(fw, alt_path, fwctx->dev);
> +		if (ret == 0)
> +			return ret;
> +	}
> +
> +	return request_firmware(fw, cur->path, fwctx->dev);
> +}
> +
>  static void brcmf_fw_request_done(const struct firmware *fw, void *ctx)
>  {
>  	struct brcmf_fw *fwctx = ctx;
> @@ -544,7 +569,7 @@ static void brcmf_fw_request_done(const struct firmware *fw, void *ctx)
>
>  	while (ret == 0 && ++fwctx->curpos < fwctx->req->n_items) {
>  		cur = &fwctx->req->items[fwctx->curpos];
> -		request_firmware(&fw, cur->path, fwctx->dev);
> +		brcmf_fw_request_firmware(&fw, fwctx);
>  		ret = brcmf_fw_complete_request(fw, ctx);
>  	}
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
> index 2893e56910f0..a0834be8864e 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
> @@ -70,6 +70,7 @@ struct brcmf_fw_request {
>  	u16 domain_nr;
>  	u16 bus_nr;
>  	u32 n_items;
> +	const char *board_type;
>  	struct brcmf_fw_item items[0];
>  };
>
>

