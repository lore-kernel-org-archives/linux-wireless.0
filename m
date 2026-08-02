Received: from mail-vk1-f228.google.com (mail-vk1-f228.google.com [209.85.221.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EB33909BF
	for <linux-wireless@vger.kernel.org>; Sun,  2 Aug 2026 08:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785659971; cv=none; b=s+kxZzNurT+q7pcVPf2RmW+B1SREwCoqWaU24FHj/qaifdb90jmR9q0v/4v8kQSbb2bBR8x5CUrgwSkSDQXxDy73IstmnBLl9Btc0vjviyYS4QwxBR4cYUcwxFkb6Ibda71r6MdcsegEoCWWBKWUffHDK7KzfSk47n/QBQkyzkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785659971; c=relaxed/simple;
	bh=x4Y8UA5H6X2wKOtHY8Z9P3bq/NuZ+t9aLxAr2agzmGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IDEtrUlgJKdOrhctcpkO7uh//GBocrejbX0pNpeEUI4JJtrlOGfvjJcKC6JW+QHBFOMuPtfy1i3np37AnaFmEQPLmAHdR/ti8INr+EztueFYr11nXWKEDcycI9OuuuJmGdTor1UvOSqbCCXzx2mhlUgzQ38VjrACva6p5KmXmx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=SUaFKJrn; arc=none smtp.client-ip=209.85.221.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="SUaFKJrn"
Received: by mail-vk1-f228.google.com with SMTP id 71dfb90a1353d-5c38568d9e1so700474e0c.3
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 01:39:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785659964; x=1786264764;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HU1HbP/1GwFKiZ4VPAfRk1yIp0CwwbjTWU4LCl4Ielc=;
        b=Hh8qFhXNpE5NHPxNrUMp/0/N3jlRTQIBHHUTP6zUS+HSARLhZv0Avcu2Q1VMBgzX+V
         nabdFaDZghxcXCyhMJio8/TT7SzEDwjMi634lV8almrcufkqD9CQLPIGsPBvda9vyXbT
         6tHiXVnSEDeYnmpC99ljD3rOTp5zuHgXhqNvmt4z2DboRRNhL1ChcUbMP0UlycOqdS6P
         s4Afo1JUh2o2W//bRzoKgO5ZrCIfOeAvq7FY9xCY3KHWShnCndsU1nizm//i5uBLGC1n
         nIe0ZZUCLtcnDj4u7lpTyBywWI3lDTfgTAgySUwFQ8CJKayokg+NuT/x+AIjmLWiNlQb
         Pg/Q==
X-Forwarded-Encrypted: i=1; AHgh+Rqn3oRLPRKEBZC0/ji81vrUiRMCecDBdKwO5BU2YtLlUpygSKtzOKUBno2z1ffezfwusf+C5Fai9gpGSNZmXg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzfQv2xdPO391nJBT/SIX+z1ObLmYZdmVnQr3JG6TvDAlQGlydp
	uUNR8G/eWkJ0vZ50etxqPyQEfQSMANdNkVhakznpKREzEma0fDV2eljtAy9caSoQYoUL6J+MF/A
	fsSWWoSs71O450rPd84eeUIU+gzVbxvhrXe8lgQOGwsuOXyvsHLN/4jfoWJog3VteO94WXb9nzc
	jayHXF4RNoUNRSbZPOcuBswAxtDC7O2z/asAafEh88yVWgJoy1hmZWKrbYTnnrfaHVFKvaWBJ4Y
	05WxwmAo8lUxCMxXwKAF2VEThRj
X-Gm-Gg: AR+sD12j/V+9hnr8WD0v+ouaTWWBTowS7GiDnyOTrr5Bz40HFTGr+rjxnDBwY0UsN1h
	Pp8jdTWBEwvJTTtOjemKsNW/n8rkgk/QLiZbxbuB34EqvCe4Huq4hiW94Y2tZB2x2BcKR43DzQc
	k2Uvj/xFeRDNOgpApF/1k/Dp6esTvg4BnSi0XTYgmDwHo7ekYm5N4485NSvIaPI7y6Ilxr+LctE
	2j/IAnorv4BcsleCsdBWKtvhEMQTShBC/IbSkVrVIo/n/EGhaCAozyvaFthKPAnVXwZd/9KgOzP
	b+3mTaeqNusljE3YGZwrLVdWi/4p008mjk+4sZrKHRyLa7pMXokz+XWdZXboTTJxvrtFQQWESzD
	BcRmwqNd+WWQ5RCcv4LI6wjvycFWoZMTuiBE5GuEdsrcu3urCtl+LfXYfhbwKw3/H9TsWSskcnR
	VsHvJVqTp+tROfZQyuVmO9wmzf8hiFzvgyBwcCLXM=
X-Received: by 2002:a05:6122:2804:b0:5bd:aba5:3830 with SMTP id 71dfb90a1353d-5c3873d76f7mr1509469e0c.0.1785659963898;
        Sun, 02 Aug 2026 01:39:23 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-22.dlp.protect.broadcom.com. [144.49.247.22])
        by smtp-relay.gmail.com with ESMTPS id 71dfb90a1353d-5c37eacf341sm839748e0c.1.2026.08.02.01.39.22
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Aug 2026 01:39:23 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-8ef18406878so22935126d6.2
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 01:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785659962; x=1786264762; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HU1HbP/1GwFKiZ4VPAfRk1yIp0CwwbjTWU4LCl4Ielc=;
        b=SUaFKJrn20rMNin5mVptfkQ/qNFtcSlkdQ2+0+B40jWhgtHPFen2hQiQqTZnwhAByi
         GSkBIqvOJPcpW1w0d9zj8/8iRYwF0mpKnNoaJ59BHAmcUJMh0FD1904VCSm6dfIaSp0L
         e2wGGnt3/qX+im5Sl1UtUcXxSm48BG5cbDnAY=
X-Forwarded-Encrypted: i=1; AHgh+RrVXI06kfckNW8Zg3eIG+tsTWn6l4R2JOqWMSh23c5fV922/oQwi28Y0gTBu6sBSerSapV8bChN5MvMyB2KSg==@vger.kernel.org
X-Received: by 2002:a05:6214:3da0:b0:907:c6bb:5ce4 with SMTP id 6a1803df08f44-908496b0b3amr146522016d6.32.1785659962502;
        Sun, 02 Aug 2026 01:39:22 -0700 (PDT)
X-Received: by 2002:a05:6214:3da0:b0:907:c6bb:5ce4 with SMTP id 6a1803df08f44-908496b0b3amr146521736d6.32.1785659962028;
        Sun, 02 Aug 2026 01:39:22 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908435def8fsm49457956d6.38.2026.08.02.01.39.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 01:39:21 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Rosen Penev <rosenp@gmail.com>
Cc: devicetree@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: wireless: brcm,bcm4329-fmac: add nvmem-consumer reference
Date: Sun,  2 Aug 2026 10:39:04 +0200
Message-ID: <20260802083905.3819981-7-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260727225311.266596-1-rosenp@gmail.com>
References: <20260727225311.266596-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Mon, 27 Jul 2026 15:53:11 -0700, Rosen Penev <rosenp@gmail.com> wrote:
> The brcm,bcm4329-fmac binding has unevaluatedProperties set to false
> but does not allow nvmem-cells or nvmem-cell-names, which are used by
> DTS files (e.g. bcm4709-linksys-ea9200.dts) to supply MAC addresses.
>
> The driver already supports nvmem-based MAC address retrieval via
> of_get_mac_address(), so add the nvmem-consumer schema reference to
> document and allow these properties.
> ---
>  .../devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml | 1 +

The problem is real but I think the fix belongs in network-class.yaml rather
than the brcmfmac binding specifically. ethernet-controller.yaml already
defines nvmem-cells and nvmem-cell-names for wired NICs, but the wireless
binding hierarchy (wireless-controller.yaml -> network-class.yaml) is missing
them. Fixing it in network-class.yaml would cover all network nodes at once
instead of requiring each wireless driver to add the same reference
individually.

Regards,
Arend
