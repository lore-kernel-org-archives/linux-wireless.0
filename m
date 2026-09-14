Received: from mail-pl1-f228.google.com (mail-pl1-f228.google.com [209.85.214.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C4749DB87
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 20:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789416271; cv=none; b=mDMWqF/wiZ0iF1fjZfP8IjILBf2HGXZyCMm0xcIPvMX6AoR5qagNnkZfFJXVnsAUqmpSXlSKfxDmvK1UZeKyd1Vx8F3E5p0Pd10sGSzaOs1zFKNIe2Ekg6LH1S6aIYH1kpZdn1NFSmMXdq7xWpEDfiwNE5y0028aUvALEvFFcF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789416271; c=relaxed/simple;
	bh=Wx70fEWB+1uw48fVGGi8fVV4K7wRL6TfTb69gbtw5VM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QtqHF9JX+s/edAOoETmBboEimniXv0oO+WQ7JBzpi+8WORyv1yqta5b9q7x9VCVGDXrCaSrZU0B5LflEGYTYDQIOC9X/7eWi+YOTbAMpn8dLtbpRpHo79xGAd2O5UUUGIgE/XVDiYV8Prfv8msebCrWbDYk1JUDyNXObEyEtFx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=J6uYPWcF; arc=none smtp.client-ip=209.85.214.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="J6uYPWcF"
Received: by mail-pl1-f228.google.com with SMTP id d9443c01a7336-2dd4b3c752fso37137805ad.3
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 13:04:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789416270; x=1790021070;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=++FAD+vvqLJLnQF1OXQZPWPJ1aNaoKmbxXpG1ktiVXY=;
        b=MGXgMDKOoUdTbFNyOP1LzAJNhlbHixRgSRWMkf6IpUfwQUKuy5E9n+RdEK2yuqfa17
         HvpVdio+nxD560ym8QhUD8jdS61hEd0On9lLLkHRQaYO7XB3JDzKYSLyb7i5kn7nymXd
         pL2gFgJWo7vPgMdWO5Dw5gq0h3m61iXzGjZQAYf3w/wpOn+gNa87BfsudE96SCYRzCVy
         DFbHN3fRRqj24v83TH9FGwTI0EN4BqxXwCRAMmsMkUNCQaH6Brms5SyJECR6sTwi/syN
         dfrZEmBeo32YvNUujxYOaCRz7ECKx2IxGLYlfXNTuCY/revm3c5+aNCRyVfcA/TzFoZB
         z/wA==
X-Gm-Message-State: AFuF++mjbk/A+J57fcSIaF9Rc2FYkx13drAWbDGTmYwHOY/RPm4Ck1DG
	gAkXWnv7PpfJSGx8MoxhJypE9ilC/5fwtOrDpVaBH+wgM3F9m9DbrSjx/LZWvrFnzcVq48HhsUm
	HWz4860ZJLCL7suUkTNZomijmpzzfp2ireGCQAdZdO5bBuZVtdVC59RSFvo/6BI+p5h9RYWk+fx
	QhPpKUopKXHJCiulkoW0sU3Tna32ZTdwVYl5thhzdH/1RzJk5K2Bep2gdlscxZQHJ7qdChYzECr
	ZUYshOYMKVVZIe4GDJwqKW4A7LR
X-Gm-Gg: AYBFou0eA7HgUEvN8c3yukZAdEZwWFWdkdixIsVMlenFbswkCsVLQmO1n5joGBey72q
	htPsVVW3GRpN4jjfPVwZSHMKz3Wvet29hMBsx4tAMkKNkRm3PUPzbXC+Orq91UuM7DvfbWWOYPy
	B4BIarUdYQTC2eMJ8I+2cyCj+WGJU3nJ5T4aEZ2Tn2V3B/TTbS+PdTQVlyCANkvv467I+cxo5Cu
	kcnEE4MFc4lCdc4DejLoBRDIgcbfTsJJsVBj0UaZr2rO31N6BIgzJw97D1B0mQ9l5Rg2p67hfuJ
	1NrHxrUbIlBZfuzX3H1DTNKVAEyakxnytHHCEwKMBcRdZnJSBwxN+XUjGV8Z0rRfqbHI7Hw8u+2
	eVVYdCVt+bdBHPXnsQacZDJyjq5q4uDujoldXbNbVLokwXnxFL/WcUwjt57ciUxUl0L75wplLOf
	VUiRTwwg5I0xwNwiDfKjFgQnrdwVcc/GMUE1ceBEA=
X-Received: by 2002:a17:902:e949:b0:2d9:1dee:43db with SMTP id d9443c01a7336-2dd6c7310e6mr81028815ad.15.1789416269571;
        Mon, 14 Sep 2026 13:04:29 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2dd2d0343adsm4935225ad.45.2026.09.14.13.04.29
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Sep 2026 13:04:29 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-912054a1c29so43894176d6.2
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 13:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1789416268; x=1790021068; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=++FAD+vvqLJLnQF1OXQZPWPJ1aNaoKmbxXpG1ktiVXY=;
        b=J6uYPWcFnbPuq5vkEAeEz6kSoRucj2F4YqOP8LArpTEChL66HWZEoQcihNPYA2xfhj
         rfWk8G1XulLTaxRsbGeWFa7TNfcYh+gi8aPkup9EhRb7eerqJYfSb6sJGoJ+ltpbnGPJ
         qZt/5kNkmO8GL3VqAa58VoM8Sm9JawY+mN270=
X-Received: by 2002:a05:6214:c69:b0:910:7026:3f9d with SMTP id 6a1803df08f44-9122e55387amr65691536d6.19.1789416267733;
        Mon, 14 Sep 2026 13:04:27 -0700 (PDT)
X-Received: by 2002:a05:6214:c69:b0:910:7026:3f9d with SMTP id 6a1803df08f44-9122e55387amr65691016d6.19.1789416267213;
        Mon, 14 Sep 2026 13:04:27 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f47a6ebsm103068516d6.22.2026.09.14.13.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 13:04:26 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Jason Huang <Jason.Huang2@infineon.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	brcm80211@lists.linux.dev,
	wlan-kernel-dev-list@infineon.com,
	Carella Chen <carella.chen@infineon.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH v6 1/5] wifi: nl80211: add fast roam offload extended feature
Date: Mon, 14 Sep 2026 22:04:16 +0200
Message-ID: <20260914200417.1744264-4-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260911065656.1269623-2-Jason.Huang2@infineon.com>
References: <20260911065656.1269623-2-Jason.Huang2@infineon.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Fri, 11 Sep 2026 14:56:52 +0800, Jason Huang wrote:
> From: Carella Chen <carella.chen@infineon.com>
> 
> Drivers can offload FT or OKC roaming without necessarily advertising
> full 802.1X 4-way handshake offload. Add an extended feature bit for
> that capability and allow PMK configuration when it is present.
> 
> This gives userspace a way to provide PMK or PMK-R0 material needed by
> fast roaming firmware implementations while keeping the existing 4-way
> handshake offload capability unchanged.
> 
> Assisted-by: GitHub-Copilot-CLI:gpt-5.5

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Regards,
Arend

> Signed-off-by: Carella Chen <carella.chen@infineon.com>
> Signed-off-by: Jason Huang <jason.huang2@infineon.com>
> ---
>  include/uapi/linux/nl80211.h | 5 +++++
>  net/wireless/nl80211.c       | 8 ++++++--
>  2 files changed, 11 insertions(+), 2 deletions(-)
