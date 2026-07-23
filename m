Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB8E3C3C15
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 09:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784798607; cv=none; b=kAueJWcEDkd+FNAlc1jwK5EhA0YkbzwcJjmSSQMTZfowReLjfyB9qD1zKpEt4JnWqpyCePhffcjmV3mxgsp3hlCKRUMkrX6vz2cbPtYUb7r3daJWeKmtdw0x9d/EUWc2YJU3rSbFX5OtlZVDrJNelFbTWKWy+HpefeKWc62LhOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784798607; c=relaxed/simple;
	bh=UuWU14RrqrYHqcamOKypXwqzu8lVvpVuj0zo7lDdmrQ=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nkORCEaaqkhspBThU9wbinAw/YHcrrnab+sl5tELLaJ0FmpM6JeP6oncTVERHN4dOLP8RenjXuCvbpXrSEfd5+vqrhDNTpXHuaXxChN/BE26AGwenXCQq6ihO6GdGNW4R5kCtEnscNYBZnLDYfsduyVzqptc9rCIpDIBoYrw5js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=slropv/e; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="slropv/e"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-38759bcd877so378029a91.2
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 02:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784798606; x=1785403406; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=s+63IXBW/hPn74oYRNKsdJ0IozU9pSKHV5tOID1oTJM=;
        b=slropv/eSl3NzMNA+UPCgDqwK8H7LvCJEjrEnaUL5Z2Z1E+CfSVzp7GKNm5WlS3V7G
         U7IPXH49ic3U+oEUFPrXSdnzsHAOhIsqEpuxs3Jg1ClgLz1n+hdBpZlv4NaF+ZH1Rbjt
         SyLvQteeWRJjhpLXdo3WLBmxLuA2x0DgySuXauolKxF7ILdgYNA53+fGcmBBhobteUOi
         N9opYK1fOusvafu9rJtv2MACIYtcsn6unUItxovalmOj1m/FOrMUz6ofmU07P2UaNh7m
         GWab7P1DZPl0tkVnTXMxPxj4QVNG5DXbELN+2VLpncZmxeYsv4IbRcdHBnayHKoqasH6
         nXpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784798606; x=1785403406;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s+63IXBW/hPn74oYRNKsdJ0IozU9pSKHV5tOID1oTJM=;
        b=V+RFGm8GciZWlVuH2tDu5wfDw0QciVXpmowgsihHsF2dakg7SwARl2TzrNttdsQ6T3
         r4SxTXBuGTYGgojUO/6uJ+/kDY/zbOOKJ8d8V/bUGNTAeE8t2ga5L7kXf7te6hW0Uh7y
         OKDrkAP04KENASPRXfXQeZUVBe8G64bM1B5qkMVnhqkp+CedzemJtb5QbhVAJ9B9RbuV
         sMipyViLvIVAenbcVBkIeNeFlQMZ7TxzpD2EiHOpvIq2PJ1oJ1Ij2Q62pYow82ZxyvfX
         q9pe0tQYDxwu8O4+/9ojXtoJNdRY17M7bPjdHvgzaA3bxpqYUlDSHV/HopuCaPZd0MT/
         /vBA==
X-Forwarded-Encrypted: i=1; AHgh+RqZYVJuLjr4E2xYtOzpPCe7B37koYXI7k0UaUwAEEQuIkESl8fDkYTIEWWumJaVxjXGReCq+WGZgiF11wTZWA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyM/fJHFyR8m+8IN5EbzwVN3xG+X2G/7tyCrpRx8P177YkVz+cp
	DJP0yn2UmR/XEPiCVaegzbBDFIML02gs6xIiU8T4snDbsEYn1Q0wgrZyKaYSgWKF
X-Gm-Gg: AR+sD11sJ3RdcIP01qJ9xloBx3ANeH2xcm7WaAt9oTMwjvMmUjOjeXL+5YhZ3MmTWw3
	x0SC6ZY4uXEsRAHkr4Om6DF7zgCtFX++5dnK3ZYZ5qQmjvy3a8GQ/hQKD+zj9Fo4TsB9/aWzSF1
	LpO3MtpaeDtpIgnpgfxPP1t1O6II7lyCK0R0lANkzwQdQv9Rw9r+T2XtbqS/67CRfc83tEXvc3I
	9uQaDtQ2/EIT3duJFT4MDgQNCJ+F8nfXSqKW1C61ANagKc2h+ByBbcPVUpOx2lw88iLxgM1oRme
	IDM+64hQ35R1NcHFsJSYewcqOHk+Qstsqc7gHcEKd3G72kWYJeBTTCkUdJ0qaEsP0AkanM0xW4+
	1OJB6XE1jkFl1lHDa0GYSXd4wXgucMzd+HysCzTCR6cEwXuO9USVCOEDdg9l1Pm5NCg37C9X87v
	2hnDvHWYNbOMr+a8JjQrzpAM7jfqUExaGygQcqOeHXetdYH9hUATTIUWw09PbQBQVl0nyFxCs/A
	9dtY0Q=
X-Received: by 2002:a05:6300:95:b0:3c4:42d9:58e3 with SMTP id adf61e73a8af0-3c44afcd237mr2411249637.13.1784798605970;
        Thu, 23 Jul 2026 02:23:25 -0700 (PDT)
Received: from nxpwireless-Inspiron-14-Plus-7440 (61-228-225-163.dynamic-ip.hinet.net. [61.228.225.163])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbb8f18c39csm2406904a12.15.2026.07.23.02.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 02:23:25 -0700 (PDT)
From: Jeff Chen <chunfan.chen@gmail.com>
X-Google-Original-From: Jeff Chen <jeff.chen_1@nxp.com>
Date: Thu, 23 Jul 2026 17:23:23 +0800
To: Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] wifi: mwifiex: validate event lengths before copying
 bodies
Message-ID: <amHdiy0tuh55F0ug@nxpwireless-Inspiron-14-Plus-7440>
References: <20260723103510.3-mwifiex-event-v3-pengpeng@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723103510.3-mwifiex-event-v3-pengpeng@iscas.ac.cn>

On Thu, Jul 23, 2026 at 10:40:05 AM +0800, Pengpeng Hou wrote:
> mwifiex event packets contain a four-byte event cause followed by the
> event body. The USB and SDIO paths copy from data after that header using
> the full packet length, so the source range extends four bytes beyond the
> skb. The SDIO path also reads the event cause before validating the
> packet and publishes oversized events without a copied body.
> 
> Reject SDIO events that are shorter than the header or larger than the
> event buffer limit. Discard them through the same free-and-break contract
> used for unknown upload types. Retain USB's existing error path and copy
> only the bytes after the event header in both paths.
> 
> Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
> ---
> Changes since v2: https://lore.kernel.org/all/20260720115119.80059-1-pengpeng@iscas.ac.cn/
> - replace the new SDIO return -1 with free plus break as requested
> - preserve USB's established error return contract
> - rebase onto the current wireless tree
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
> index f039d6f19183..3588c36f64cf 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sdio.c
> +++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
> @@ -1712,12 +1712,19 @@ static int mwifiex_decode_rx_packet(struct mwifiex_adapter *adapter,
>  	case MWIFIEX_TYPE_EVENT:
>  		mwifiex_dbg(adapter, EVENT,
>  			    "info: --- Rx: Event ---\n");
> +		if (skb->len < MWIFIEX_EVENT_HEADER_LEN ||
> +		    skb->len > MAX_EVENT_SIZE) {
> +			mwifiex_dbg(adapter, ERROR,
> +				    "EVENT: invalid skb->len %u\n", skb->len);
> +			dev_kfree_skb_any(skb);
> +			break;
> +		}

skb->len includes the 4-byte header, so the body size is
skb->len - MWIFIEX_EVENT_HEADER_LEN. The upper bound should be:
skb->len - MWIFIEX_EVENT_HEADER_LEN > MAX_EVENT_SIZE

Otherwise packets with a full MAX_EVENT_SIZE body are incorrectly
rejected.
