Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714404;
	b=kFLCNjdBFhfDnyemteeBOgW3ncJ0UGlSWgvbgdRZpFwCd8+3zYhJUsqunM/V90GxehRA
	 /tydtWpby3zXFg6ErJwlydJfw5+52KdKrNoaBa1c6Nzyi65QVGQX0uHjchqjc7AOc+Acy
	 EkEGDC1V/K4bw4EObSA9xQOwDnXhgSCLBR05BQExTLcKufmVAmn+71mW2RUpfdYvyLzw1
	 u/jlYvN80or6f0i8uhOrQDK5mksx35/p4blp5fgVwbMg6hbKp0Am36+32yRQIeO3/nLZy
	 EqaV1d+lRoMRfg4zGaC/Hv5d0xq5MQjUgDhV/g2R0WxOO3a2R+UospnlxoYsX/WFzyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714404;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=qw4Aw0jcq5gAZzmvQPuYkoKDSkJMWpxQEuocOLkzgts=;
	b=UJ+rdCtFdTnhcQmw+u6nAqE/pDadpiKPtfxzOMAkLUWluhP7Tsb+yisQRXLSeqUNjOx0
	 VeKNfgf1b2Ppsb9q2g4VAvjB6m5Nj2uPYETXPa6bwhiqjEOA0/DHCLgn5utWH8I0HKcY+
	 snO0+VrRdT2uW3zbpjI+DHonb/rRPSLQrTws+0q1klPfW/AJVGsUvU61UjF+USxouyAXG
	 NBW51DRagul4Wz7JT0jytF3i40Ar1G4f5/+F8cSyMV799K5F4Lg4KfAm3DO0O7f31+Dw/
	 7mrS+B0zegm4DceyMyFrvkqQRTnkyWl2xYwnonzBsi2fVcDKNMzpCxqtw7kXj+bUB5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=bsXp1poO;
	arc=none smtp.remote-ip=209.85.215.225
Received: from mail-pg1-f225.google.com (mail-pg1-f225.google.com [209.85.215.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E497960850B8
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 14:00:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E497960850B8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=bsXp1poO
Received: by mail-pg1-f225.google.com with SMTP id 41be03b00d2f7-cdab9e9761cso2426425a12.2
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 06:00:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793714403; x=1794319203;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qw4Aw0jcq5gAZzmvQPuYkoKDSkJMWpxQEuocOLkzgts=;
        b=EF45iF796JNd+viq97z0Zy4BZiS/LD8l6kkz9XhCCuHeQG3GRQk61iP2aXJzVhBcEr
         IfuDBhl28CgIH25Bxv9UcgR+/alIBB/bjcWdWBbu+UEKuGVGUMbzIJIeACk962ING58N
         JZDucDIqJf0WPYM1tuXwhePSHm8er7LFFDpRiafvp/IRoEZZq7MBG4oUB4LVz8bahp84
         DCza7Gae0PVeKu1Cbc+JGgsK3OhASI4Uq18PbhswchMtgtBOGAvtjze+MB4lOskCugZt
         MYoWTArWPIikqOVMYLMewKTWxPF7PgmLNWSKCoyYOXgz3BuIaJpIPXCX9Wd9K2vaA9BM
         2AqA==
X-Forwarded-Encrypted: i=1; AKwUvBwi6sUar0c7TyS0DtT4Hh194ar5egWUeU0o1er1Yba3z2LMjPzUpKQ2tuxEnzf49yByfDKecOQfHEY+xV57cw==@vger.kernel.org
X-Gm-Message-State: APuU4Z/bLWRkkPQVLgPSwtu5Vwimn+7g81uyqZijfNAs8jEScQTUqNkf
	Y2aJSmtRFTAjL/TiwjqCHeGG3gnbZWzFSKeeyPWkb5GWMMyrnY0/VA89gTpJXcf+qnxWooVa2YQ
	KnIrNp07S9xbpwYsuM4fPPr66E8+e2RmPqNzfsHsoXivV/7mydiR57iCfoj5JJFw/1w76cQJ2c7
	ekN+J9ZLkwsCp6Yg+XLj/AMTufkgZL40mHjqRRYMOoJ5avroA7sO1rLULalhnKJH4nBtPJBemJo
	QcFN2nt4/wwcB16EeEqammXLQ==
X-Gm-Gg: AYBFou0lZOtaP1OahKawJWyT6nxcpcAApkBjjt0ZV9jSpYAjWp8GsPEedfE/bc4iZM0
	lGIxvdLTYoFgoQHUg43GWjGMqA33qrPmP2h6AwxHY8eEXB4LkWFyVnvBYrz0XflZUmG40vDiZog
	5WJjkA0r4XlScDVO8eaCN5wLFaCdxp4noPrAXkZVxwZBJHc2C4Rwta++Oilq+c+M4aqRva24lzH
	I6Ma2Q70OzA4ogLzgdApoE54Je37kSCK8tCAbX00ur1CBL9sFTbxPFeJShj1DJtOC36N9kVJVBo
	xXnquEtqYFtzXiYhHV0dQpBOk3BAZd/9I4/EOsSxSPOdEQHiY0JHu47i8LQyhxbWLqTfMvDjr9d
	q7UAUDOJJIO808KlhRF64uR3JNanMAi4JzfDE1QQHMJhSOT3irt/n8IeElvcaAvu/eS7OT6rcrC
	tmXaGVtZXYsQFhBPbP9QClVMjipaTwe7Dy9VFr19g=
X-Received: by 2002:a17:90b:1d05:b0:39e:53a:c8d4 with SMTP id 98e67ed59e1d1-3ae897ec640mr10562641a91.12.1793714403122;
        Tue, 03 Nov 2026 06:00:03 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b07c7aa9c6sm1922005a91.1.2026.11.03.06.00.02
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Nov 2026 06:00:03 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-30bcb065bfdso7626922eec.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 06:00:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793714401; x=1794319201; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qw4Aw0jcq5gAZzmvQPuYkoKDSkJMWpxQEuocOLkzgts=;
        b=bsXp1poOV8qg0cdbZn14/0NL6F0eOk7Sdr1LkDO9dbMo6UXkRW/NLAOXRO6+WfO+lx
         pu36WNwOA7kC/Iw9V+lo5rjvl2fqueUMYHKEZ0aNte0ohmIvIkppUOkxQ8hm+5VO5QaZ
         egCnHKiH1Ulv97Ufza+R/mTLjWUpAOiCdSeRs=
X-Forwarded-Encrypted: i=1; AKwUvBw1zW0ijvNHB/Ji1+wwZ/+n64yVTgT0cVZtM6wqZ/kBPZxrZDAXj7MYt0kCbh3ld7GF+Sy4/HqDoW0j1I6Rtg==@vger.kernel.org
X-Received: by 2002:a05:7022:c43:b0:1ae:b906:7733 with SMTP id a92af1059eb24-1aeb9067966mr14495780c88.23.1793714401173;
        Tue, 03 Nov 2026 06:00:01 -0800 (PST)
X-Received: by 2002:a05:7022:c43:b0:1ae:b906:7733 with SMTP id a92af1059eb24-1aeb9067966mr14495751c88.23.1793714400382;
        Tue, 03 Nov 2026 06:00:00 -0800 (PST)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac18458e07sm41658755c88.8.2026.11.03.05.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:59:59 -0800 (PST)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Michael Reeves <michael.reeves077@gmail.com>
Cc: Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	"Franky Lin (Zhenhui)" <frankyl@broadcom.com>,
	Mathy Vanhoef <vanhoefm@gmail.com>,
	Kalle Valo <kvalo@kernel.org>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	asahi@lists.linux.dev,
	Hector Martin <marcan@marcan.st>,
	Daniel Berlin <dberlin@dberlin.org>,
	Janne Grunau <j@jannau.net>,
	linux-kernel@vger.kernel.org,
	Hante Meuleman <meuleman@broadcom.com>,
	linux-hardening@vger.kernel.org,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 12/13] wifi: brcmfmac: Handle extended PMK command payloads
Date: Tue,  3 Nov 2026 14:58:56 +0100
Message-ID: <20261103135856.3676311-13-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260925-brcm4388-submit-v1-12-b5cbc2cde2fb@gmail.com>
References: <20260925-brcm4388-submit-v1-12-b5cbc2cde2fb@gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Fri, 25 Sep 2026 23:43:47 +1000, Michael Reeves <michael.reeves077@gmail.com> wrote:
> From: Michael Reeves <michael.reeves077@gmail.com>
>
> Some firmware rejects the legacy BRCMF_C_SET_WSEC_PMK payload despite
> advertising firmware supplicant support.
>
> Add the extended PMK layout. Try the legacy payload first when the key
> fits, and retry with the extended layout only after -EBADE. Use the
> extended layout directly for larger keys and reject keys that exceed its
> capacity.
>

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Regards,
Arend

> Co-developed-by: Hector Martin <marcan@marcan.st>
> Signed-off-by: Hector Martin <marcan@marcan.st>
> Signed-off-by: Michael Reeves <michael.reeves077@gmail.com>
> ---
>  .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 39 ++++++++++++++++------
>  .../broadcom/brcm80211/brcmfmac/fwil_types.h       | 18 ++++++++++
>  2 files changed, 46 insertions(+), 11 deletions(-)
