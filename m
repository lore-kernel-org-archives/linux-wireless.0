Received: from mail-pg1-f228.google.com (mail-pg1-f228.google.com [209.85.215.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F59E392C48
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 06:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785909921; cv=none; b=XQ/eWFwgkygmJlrE0naIjgqp2hbfOF8YoygDrhbnP0KbCUd+W9RbPrZJjUeqPu9JVrFM430fd1yWbGXDsLhkRIu27yHPlIfFVNYuD86GPmzCEj4trHss9XZXNjNmwsuAtL6KMLA5soPqQ7HRNPsiyObcOy5d2T7Pt29dtnZ3AT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785909921; c=relaxed/simple;
	bh=OriPhg6YGIwEW9hmmH46YSgFHuBbRMq19BdArA9MZD0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qlPDFTMPB+OuTx/oUCg/bx3H0Z9g7axRwRNs3+PkkxeFM5ild8H+VrSuHFBFsaLndj7IQXCEjUSTDhWXFTPZuzm5wiPZOQQbRyLTJ3sew22x3Ra9Z18IAdm0ZwN+cDbkAdzDoxWVvk2Gjd9gOu9VaEgctp8coPoDEMy+Jg86CEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=f+ow04oh; arc=none smtp.client-ip=209.85.215.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="f+ow04oh"
Received: by mail-pg1-f228.google.com with SMTP id 41be03b00d2f7-cbb85186d43so296647a12.3
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2026 23:05:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785909920; x=1786514720;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=ixvJyzHf6CwQR78Vnc98OrtjL5Qm3qHKniNH1npgOPE=;
        b=VfdSMoV2PofQjPmHwxBbUz4BjvW3O9YBZuyQ4RfJ+OELPV1C7jhSUPxBRI7SUfRwrJ
         UfzvAdODU8G7/qQNHfLo0oLjMfRkpcCXDhYp2s8o3EJRnQDZ8Np/hr3TUXUpw7AbJzZQ
         cJ7Pp6RHKp1+ry5SsRh2l1RKqJQBbouzWvDhIPpFW6SymPgfWL1hvFcrYJABXLU02L6X
         V8ETIyh5PTv/rLpK+cwQ3nSZGfudDvxRRvhh9fbP2Qodr2pjhYUQByQvH6qX90NJq9hy
         /LXqV8xUjU6DxTdKzVvPRF1B2L1nyjsyHA5Zk+ogmmMpHOP4LoomkW6HpuEghuZ6U2xi
         5j2Q==
X-Gm-Message-State: AOJu0YzS4YcujSarnVdfqFKwXFgBoO4RJcO+KG+S1S8VsulbfNbIlGwU
	OhBZtqWePSnmsCSDoZapJQAIUp0PgKTeoysvzIIcNJBclQ5DuKYq6F0elc3qSGU23235XXcmkFo
	ch696xBXXEnPYK3G6N1GNKkWVCwIEh2gCkmX4BBZr+0vwEzIf8K7Doj298qLqcBCRX5gRrWVF8Q
	VgdLc37fuMzSHvZSvlXuWqrKy6AFE4oME5wZX3Lel3M+rPZ8vIZfs2RuTOSyf23IcbH6RwNT40G
	BOVGCYzx9xECMhBlPIRBuP0MAgg
X-Gm-Gg: AR+sD11zAtYQuMES7XHaJCh0JTNOShhnOArfSte8YyShEI7BDexovrMdJljIlVvHNQG
	bDOLsUZRlE7g59c3MDdMB4+cRR3MhcorBvamL9dj/6myv0AXxe8PIeVbtEVluArz4wty85OQ2bx
	0Ky/jYaplfig6k9zbM10AQ5+oKjRG3KUxhgfL+o7eUmvpqZCGTHrX7dq06ZSbQD3LXtArKynvXu
	VeWx++H+BoicLaI90td/tN5j8GvtqZ5n223UzEL4ADG0/pmA+dzUB/i28eiHt6T9g/jNvtSEFd3
	ID0x1w5YoZ6B93303YK5NIjxzx2mSTP+S8UZBQTZsm0ExlbvvsRFAOK2a/z+BW6XiM3kLpYQi6q
	cUWyOt+xoDbm6PeIq2CQWCAY2rdiqIYDDFGRvxaWw/pPfRaheA+60J93Kr5bL8PoPk6YlTUHoyx
	t1Zqfo/uIsROxs+/TlLZKyqFkAM3NuMg+cFLBelVw=
X-Received: by 2002:a05:6a20:9183:b0:3b3:486f:f2d1 with SMTP id adf61e73a8af0-3cb85dee539mr4769321637.3.1785909919583;
        Tue, 04 Aug 2026 23:05:19 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-27.dlp.protect.broadcom.com. [144.49.247.27])
        by smtp-relay.gmail.com with ESMTPS id a92af1059eb24-13fca5090cdsm361703c88.1.2026.08.04.23.05.19
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Aug 2026 23:05:19 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-5276aa86d00so5915771cf.2
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2026 23:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785909918; x=1786514718; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ixvJyzHf6CwQR78Vnc98OrtjL5Qm3qHKniNH1npgOPE=;
        b=f+ow04ohqJqfSxh3Rfm1dIJfTvahqicxT1Yjyj5VvMwcw1cO4JAYH80Q4AH8TekJY4
         sU4VAqpVIiE9hJAneuomLOq4RtnCsOGWR/2GUXhuCPZpZ0sk3yAF3B87ONGnDYTuueMh
         Kne1tBHUVhW+nzHCMD/ztWxMnSsgR/S2dZLak=
X-Received: by 2002:a05:622a:a06:b0:51c:844f:28da with SMTP id d75a77b69052e-52ce5f8fa54mr48932071cf.5.1785909918297;
        Tue, 04 Aug 2026 23:05:18 -0700 (PDT)
X-Received: by 2002:a05:622a:a06:b0:51c:844f:28da with SMTP id d75a77b69052e-52ce5f8fa54mr48931731cf.5.1785909917851;
        Tue, 04 Aug 2026 23:05:17 -0700 (PDT)
Received: from [192.168.178.26] (f215227.upc-f.chello.nl. [80.56.215.227])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52ce8975b3dsm12228941cf.30.2026.08.04.23.05.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2026 23:05:17 -0700 (PDT)
Message-ID: <367ced51-be75-4e21-8e8f-6ed31331a0d2@broadcom.com>
Date: Wed, 5 Aug 2026 08:05:14 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] wifi: brcmfmac: cyw: pass PMKID to firmware if present
To: Bogdan Nicolae <bogdan.nicolae@gmail.com>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev,
 brcm80211-dev-list.pdl@broadcom.com, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260804060859.412348-1-bogdan.nicolae@gmail.com>
Content-Language: en-US
From: Arend van Spriel <arend.vanspriel@broadcom.com>
In-Reply-To: <20260804060859.412348-1-bogdan.nicolae@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 04/08/2026 08:08, Bogdan Nicolae wrote:
> Zero out auth_status on initialization. Otherwise, garbage will
> leak from the stack to the firmware (when ssid is less than 32 bytes
> and/or when params->pmkid is set). Then, pass the params->pmkid to the
> firmware (without it, the firmware caches a garbage PMKID on successful
> authentication and denies a subsequent association request that includes
> the PMKID).
> 
> Fixes: 66f909308a7c ("wifi: brcmfmac: cyw: support external SAE authentication in station mode")
> Signed-off-by: Bogdan Nicolae <bogdan.nicolae@gmail.com>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

The checkpatch results on patchwork still show one failure [1].

Regards,
Arend

[1] 
https://netdev-ctrl.bots.linux.dev/logview.html?f=/logs/build-wireless/1139831/14729070/checkpatch/stdout

> ---
> v4: Fixed indentation
> v3: Added Fixes, Cc: stable, and Acked-by tags
> v2: Split into a separate patch
> 
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
> index 873754be5..2c59b5e57 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
> @@ -200,7 +200,7 @@ brcmf_cyw_external_auth(struct wiphy *wiphy, struct net_device *dev,
>   {
>   	struct brcmf_if *ifp;
>   	struct brcmf_pub *drvr;
> -	struct brcmf_auth_req_status_le auth_status;
> +	struct brcmf_auth_req_status_le auth_status = {};
>   	int ret = 0;
>   
>   	brcmf_dbg(TRACE, "Enter\n");
> @@ -208,6 +208,8 @@ brcmf_cyw_external_auth(struct wiphy *wiphy, struct net_device *dev,
>   	ifp = netdev_priv(dev);
>   	drvr = ifp->drvr;
>   	if (params->status == WLAN_STATUS_SUCCESS) {
> +		if (params->pmkid)
> +			memcpy(auth_status.pmkid, params->pmkid, WLAN_PMKID_LEN);

The line above exceeds the 80 column limit.

>   		auth_status.flags = cpu_to_le16(BRCMF_EXTAUTH_SUCCESS);
>   	} else {
>   		bphy_err(drvr, "External authentication failed: status=%d\n",

