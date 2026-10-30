Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336247;
	b=Hx/hVJy/64oSv68mXnRaySb+78dmIUEGjluoI+Qf18sicZEmZJuMQG7aFc8lRGSk5ZGO
	 iMmtjjoBt7KZGA3VFUZstxJFz+R2lok/0ub6ZCCBpyc4w3GTiNmgNCLy7QcUCm3fYutSw
	 tKyjsNJcSrbUpAWqtTILJDbi0O+Ox3gSrdTSEAiKOwriDXqhbTVNQzoVSZX48t+hI3GoR
	 vzcOXTfTi3bm2yTwfX454qYsbMpgsQZI3ZnbL5UBFk6hp0j4IMePb/Sl/3nfbq9quOz5o
	 aYR4L9hDRCZmy6fpm+PHLdt8xgxCst+3H5mHnwxRqewhG27d86wgQYPGYzfqMi30vjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336247;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=70j/JPno7B9xtvcJSe+D2llozuMkyOhwkjeWL10j++0=;
	b=ZCn5myAAl+VCNdEdM1T2apkLv7+ODnO5kwWXwmJV+eS3vYHwhI+c+q4WkEdXqEkDbrCx
	 rJ1/Vg2VHTmIYO1uyAJ9Q/asj42MkhU2tXr98z4LVWwC1qKdPsGx/KYeq3YdWgCTEIj1l
	 A61GtaVvS2GTHxaBDN6XUpvxbcZh0nQoXL1OqEDHOshnfaojDly6LgTAaFhupwZuSGC7Q
	 oti5oCOl6ObFwQGiq8xlRESWf2NXfvr+h6jijpTZ1M9sQ5W64jVyJDYc7rGlBwjdqBgBe
	 1jBhQ1vqcNQV5qzi0sMvj7gWVcOTWGtphgO6FLU1qMM43XQ6VFx83tdPjd3FJ/5ps9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GT2OOVBv;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFA3606A32F
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 04:57:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BBFA3606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GT2OOVBv
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a215e64962so2186145e9.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 21:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793336245; x=1793941045; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=70j/JPno7B9xtvcJSe+D2llozuMkyOhwkjeWL10j++0=;
        b=GT2OOVBvdT3z9u+/pbripoAEwpFuVFOqqNfAoyjHCu73ZSMYHOzDgvR9XlkaPGTCPS
         XLD2gqlEQHX936r96jYRj1rCkyW4HQmG6N6ylCe1rWYZGd5vaiwsWtXDqJgUTUXH1GRm
         00TdU2pH+4SmzjhIzvEcXPKKztmRihBfuLiQfEmo/05squBzemEue0mmIW3b3wBWLdR1
         jOV3LiVUmHwjVdfC5pJ/CKTT0IAAJ6ZgwbxPDpWpL6iEtLBOQwhKFKZg1auuafvDOAnL
         EHIUjcB31CCAEXpIhhkRQjffsS54nxPtXEi6PqZwpZKEQJItXX9YmBzIfW+dRTQWIiSM
         tiNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793336245; x=1793941045;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=70j/JPno7B9xtvcJSe+D2llozuMkyOhwkjeWL10j++0=;
        b=cDLS2ror+q4lOT9HqKqAjdY7O+ODpLNOW4O8zlBpFBrloSh1hsZuMM78Br8qE+yqoV
         Vmfd8HDFTrr6uEaZBvUUQ1NNOI1h1PUifxHf4kn/pbbleSF6uz4pfIM/qJlhn71IpW1y
         yn0UVUWSzQZXRHtXx6Ba+pVii2eF9sF93SSzsegSzmBATyaKEVePlFmvTa+SdUsjIK70
         zH27QZMrR9NrCy+kZCDpjEzh137IaWWjh7dBMNhwhZXC5WX8S2UQseXjUaYaRHgHGSnm
         xFJojEpqheCl1V57jY/SefDiII3tK3MFz58W9aIVJM4UriwXPCaLR49wpzgHz9MgV9ji
         zfsw==
X-Forwarded-Encrypted: i=1; AKwUvBzGrfiikCVKBipWxp8IberGH9cc3FIcvZR8MZnSUe53hqaZ/IjmsV+JPIG1CNaVT+JjqkTz+jryqc/J5QdF2g==@vger.kernel.org
X-Gm-Message-State: AFq9FYKdsR2D0aB7XW0tCy0VaKmjWEwl5HAlVf5J75O5Sa5+JG8fOrjd
	4sHZYWfnlV4rb8mcHlIOxUJ1DEyy3tn91XJITVITmWcMw1svWqkoI+4Q
X-Gm-Gg: AYBFou0i9CnJBFKShCnU8XA2ozcIkPUS15lrHkm0jsoJcOspR5JFg4l2lyWHbbJYSfu
	GH7TMA+AoqtKERoaNThzcQkzc00rTapK72nkgr3PN8W6Vzs0v39WKhj31V2oUdCcJXb253Q3Lv+
	XCbm3aEewHUYd5CD8v4Fui4GBA02zo1t6TkvuEPMA0PZsNlwvQOnCz/Yw6rnDi89kJxbNUxM+Sp
	/yu7hLGI4P9rjMiQJ2zlu1cTVDaJq9af2KU0eisQ5RyKbgCarRNDITeuCc55WOQe/2s0MTS/Hro
	v78PcveFP6aQqPfuq+CnPhcRWLrroDmkVftvNW8F+lV20eIF+hnVYE213IGeEq7TgMRB3WG1Bvm
	qIwvQpC5szfy62fr4IrHF1KeqgYVI+R68CDNlCifkRsS9vMTRPcjjSS/yXmam8cZ6UcGUlFMYZD
	5IvSZQRHfwW6vk0wzzWvgNXTn6ItHvCd+QV8d7SzPEWyXDAxDCtQLYvKXnVjLR+KbEm/MKX3vwT
	6OJfU7FIX/xetABdetvVudngePKdaGMxlCGzNEUOcOhHEYNsURD5LDePqUSGDDh34CB7M3drFJS
	/29+MvRAOQA9ivJ8veP3+L0hsmUBFp3U1tcXB+g8sodU6CnWDWA3YF8lbxvWzbDv0hxVmFVGdWw
	HLx5NPFkLA4ylPbaZmF6cWE4kGs3kNnmG4CSCVeHbXgPp/W6AW+oL25KEjB66vASdbyjd
X-Received: by 2002:a05:600c:8183:b0:49f:fdca:c361 with SMTP id 5b1f17b1804b1-4ac180f2ba7mr19414065e9.12.1793336244922;
        Thu, 29 Oct 2026 21:57:24 -0700 (PDT)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b789c6sm1116780f8f.26.2026.10.29.21.57.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 21:57:24 -0700 (PDT)
Date: Fri, 30 Oct 2026 07:57:20 +0300
From: Dan Carpenter <error27@gmail.com>
To: anthony.liu@mediatek.com
Cc: nbd@nbd.name, lorenzo@kernel.org, Leon.Yen@mediatek.com,
	Quan.Zhou@mediatek.com, Ryder.lee@mediatek.com,
	Sean.Wang@mediatek.com, emery.hsin@mediatek.com,
	jb.tsai@mediatek.com, kun.wu@mediatek.com,
	linux-mediatek@lists.infradead.org, linux-wireless@vger.kernel.org,
	litien.chang@mediatek.com, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] mt76: fix buffer overrun in pkt buffer
Message-ID: <auQjsDPP1PeJg5sV@stanley.mountain>
References: <20261020032201.568970-1-anthony.liu@mediatek.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261020032201.568970-1-anthony.liu@mediatek.com>

On Tue, Oct 20, 2026 at 11:22:00AM +0800, anthony.liu@mediatek.com wrote:
> From: Anthony Liu <anthony.liu@mediatek.com>
> 
> The last patch (d4e5ca3483a0) addresses mt7928 F/W 4 byte-aligment
> requirement by reducing pkt buffer by 2 bytes, causing the chance
> of buffer overrun.
> 
> This patch reduces incoming skb length limit accordingly.
> 
> Fixes: d4e5ca3483a0 ("wifi: mt76: mt7928: makes struct beacon_tlv 4-byte aligned.")
> Signed-off-by: Anthony Liu <anthony.liu@mediatek.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <error27@gmail.com>
> Closes: https://lore.kernel.org/r/202610172141.mmRmGqow-lkp@intel.com/
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
> index 26cdb3f0a98a..131585b3359d 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
> @@ -2479,7 +2479,7 @@ mt7925_mcu_uni_add_beacon_offload(struct mt792x_dev *dev,
>  		return -EINVAL;
>  	}
>  
> -	if (skb->len > 512) {
> +	if (skb->len > 510) {

I would probably use:

	if (skb->len > sizeof(req.beacon_tlv.pkt)) {

but, we do need to apply this patch in linux-next.

regards,
dan carpenter

