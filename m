Received: from mail-pl1-f227.google.com (mail-pl1-f227.google.com [209.85.214.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6B13126B2
	for <linux-wireless@vger.kernel.org>; Sun, 12 Jul 2026 22:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783895735; cv=none; b=ekEU/oYcZzViNdJ+6dO3Aq6/MIJOHS9RVL6HSLDyLP23fvpRi0cUIk3w5ueC5boMcmxwrSjdZmwWOrUAhQz1J1jLIxM1MqYow1lkUFGNTCoKoQtq5I1u6Uc+JP2DnmGQI1fyBN5KkPpuhMuHXoHnuolXh2Et+JzZK5SHrR7uq+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783895735; c=relaxed/simple;
	bh=Du+qb64uWThYzPhk54cXQ87/7uxBxrgbN8LKMjJzD/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGOWl/s54tTWniGB9u3hgsPB48kU6koE3j6Nqbrfx+YNpYUotDzJkdLZt+KtOwAXsQsc8Rh7pIR6I5S/2ANdTSGY/eNIV6D17NWLyN5VEZtBva0fN8nDlHYged7cO2wMRNxVB0v+YJjT9v46v1mDeruJiT8QrKSn+SJAdTPMCBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=O4e0TEYV; arc=none smtp.client-ip=209.85.214.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="O4e0TEYV"
Received: by mail-pl1-f227.google.com with SMTP id d9443c01a7336-2cc6dd436c6so30425385ad.2
        for <linux-wireless@vger.kernel.org>; Sun, 12 Jul 2026 15:35:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783895733; x=1784500533;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KubE9klKqieCjuCiH0MctfLK6hj7OQiSTq4hMK+gcPg=;
        b=pIMX3tuzmuy5iBJTCJmK4R7THRDPZYDd2HW5M19VCN5paPYI3VlOWAztReyMQf7X8U
         O/e4v0TFCeQcHhsLYxtvCGC6fMNgywobPjjBnicV7qrIJRfa07nTOhPtzJv7UPi/Et+h
         pxqViCZLw1NXP5y/UOIqN89I5tuW6ZdgxLq/oYRYX15ReegEhwDmdNbar3IeRszIOioL
         dZLPhEf0kbFlDn5RipbbA3pRnhtWHHGiGrcTJ2Zd7qTPQEyfWFytWh5BxIWd4zSORsDh
         Zxzw+bGA6nBjqtUSiMLdAzFrSR7Zm1mtf9fWPjTqEk+e1i4NjMUWZWWcEPxe72LFjTJD
         eZuw==
X-Forwarded-Encrypted: i=1; AHgh+RqltjMucVfFDVMYlv+cZKY233KKNLPhRUuFoZvz149qNjJZQ7ptjZkNnPSFXrbAB5eM9IUl987yegBA2/mJ8Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YydpQaWOpFQfKkZM+pwv0MOz5SHbvvoZBd9Uzaj7eO+fPzGHrQh
	ANPLQ6HaPnxyMGSKbweqQfn3sdgX0UeMAUGhx83VTddNslPU5HYbfktX3cKQ+FUIhYEENLpvIzh
	DmXsdb/hZwz9S/v3KRUwxBALLQ/arf4vhcA6m0SfATcQrpQCbuK3W/sWTuPGKOAsxRf4A75v7aN
	A7Fd17XCGY2Dj5IV1eHKy3O31iNpucaAqhUdxeP6ZdfJtuh2bWuzPi40/zloh01fBnXMFtxsDY8
	7oEB4Am8MoTCoCaLT+R3RR2JOLh
X-Gm-Gg: AfdE7ckmewof+gNN5EUhi6OQZmokI9AI1U5WrniRCw9m5fGRlvcYwODzuFKRoOow/cE
	ySKh7A3nAwgnrStkj/H+agH0e+ZckTv7Ls1ixb4lnrUxtilV8dw6UHojdzXdPkn118W8xPOHx4x
	FdKIl3AuLaxbZwkPN6PxB3m30htJMtKC6YOKKiVZco2iQ9mKxu2LOD4AOiC2awuKtcrT9V4CaIk
	1oPQgPg6amAamhR4MCur5fxtdz+q7hYFYYmvpcUHiw3i14G+G6pSXkI+ufGax7yW+JgjxyMsCyx
	QRrNeqAcS2o0okjTIK1eTEpHNQHUJuE7EwIXDcmHGXaU8TmjiRpv4wX0Wn/sBVkSZXcQjCN/na+
	1QuPH3f8Wm1vl95/PBcj83cCz4ImbZfknwmL3pE5kKuOzR+hTNL12JNgDnbo4b04vVqI5yTTrI0
	kUPaTD0n9K6EM+5DS1hscJZ9YUCPoirfnQuYpPq1fYdhUZTpcNP7MR
X-Received: by 2002:a17:903:2a88:b0:2c9:d8c6:1db8 with SMTP id d9443c01a7336-2ce9f284e45mr67240795ad.28.1783895733449;
        Sun, 12 Jul 2026 15:35:33 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-117.dlp.protect.broadcom.com. [144.49.247.117])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2ccc9bdce31sm17329505ad.12.2026.07.12.15.35.32
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 12 Jul 2026 15:35:33 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-92da6f3cc81so298271985a.2
        for <linux-wireless@vger.kernel.org>; Sun, 12 Jul 2026 15:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1783895732; x=1784500532; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KubE9klKqieCjuCiH0MctfLK6hj7OQiSTq4hMK+gcPg=;
        b=O4e0TEYVJRE2pySb31Swh5qzE9XAbQ7cG2dGuqHBQzJ9Yd2P6t+igWxG0R+2hgHkY+
         PchmzYZErse+RT4ezVQkGmKoPSRxutz8vHImbd1rZI/uWrE8kqrHs2ecqfTiYiY7xudN
         PMLMI50h/YD2ieKstUVxIJ03i/+OkWueMSz1E=
X-Forwarded-Encrypted: i=1; AHgh+RpGQRnsxJnBk2UvNoSD8mVqhs+YkGWZKj4Ln9dyhlQO6yj7ApR1Q1OvnCyBC6XGPtbuKSKRt0t0SLt8WnMnGA==@vger.kernel.org
X-Received: by 2002:a05:620a:1a07:b0:92e:f09a:90da with SMTP id af79cd13be357-92ef2cbffe2mr718629185a.81.1783895732050;
        Sun, 12 Jul 2026 15:35:32 -0700 (PDT)
X-Received: by 2002:a05:620a:1a07:b0:92e:f09a:90da with SMTP id af79cd13be357-92ef2cbffe2mr718627685a.81.1783895731600;
        Sun, 12 Jul 2026 15:35:31 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92eeff38acfsm761274485a.29.2026.07.12.15.35.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 15:35:30 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Guangshuo Li <lgs201920130244@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Peddolla Harshavardhan Reddy <peddolla.reddy@oss.qualcomm.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	Piotr Haber <phaber@broadcom.com>,
	brcm80211-dev-list.pdl@broadcom.com,
	brcm80211@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wifi: brcmfmac: guard P2P device vif in action frame search
Date: Mon, 13 Jul 2026 00:35:27 +0200
Message-ID: <20260712223527.2184308-1-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260708063929.718152-1-lgs201920130244@gmail.com>
References: <20260708063929.718152-1-lgs201920130244@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Wed,  8 Jul 2026 14:39:29 +0800, Guangshuo Li wrote:
> brcmf_p2p_send_action_frame() checks the P2P device vif saved probe
> request IE when deciding whether to perform a peer channel search. The
> P2P device vif is not guaranteed to exist, for example in standalone AP
> mode where no P2P device interface has been created.
> ---
>  .../broadcom/brcm80211/brcmfmac/p2p.c | 1 +

This fix is already part of the pending DPP series by Jason Huang / Kurt
Lee (Infineon/Cypress), which I reviewed on 2026-07-06 and asked to be
split out as a separate patch with a Fixes: tag. I expect the DPP authors
will be addressing this in their next revision.

Could you clarify what your relation is to that series and whether you are
working with those authors?

I am not applying this patch.

Regards,
Arend
