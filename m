Received: from mail-pf1-f226.google.com (mail-pf1-f226.google.com [209.85.210.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C00470EA0
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 20:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789416295; cv=none; b=slfbFnAPmHlmmNG+QrJ7RSFsMbewEJQk4fJMmhbHkuvSxF4K1WI0VNSYEzkdKkjJK6ABANTwtxqyERzKny2BOzOuV7z8Dq2guGYVeEa/XVzl1KTiVjgLl7RMqj+a02j5/JNPb6I2/MVj30nW9TwsLZCtxM0S8zXvQ+4zYO55ksc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789416295; c=relaxed/simple;
	bh=wA5npbt/0D/RB2shwDo8pZnhFtmbBXBtO12oh/kCjqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QXU0MxAtVveyDV7D95gcX1cD8JWdR2+3WeNu1Oj5ERQF/KaVeKxmRwP+CdXejqhBtzTK+z9OygIIo042mVJz00NpGocPO/K+qDM46T1jJN6e1Eht3uFt5SSIgyFB+AkyHlgGv3O9jKnPzULUKSdtnZIFOtJnUD/SC4JFmNrWDTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=fqGL21QE; arc=none smtp.client-ip=209.85.210.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="fqGL21QE"
Received: by mail-pf1-f226.google.com with SMTP id d2e1a72fcca58-852c481415fso2727011b3a.3
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 13:04:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789416290; x=1790021090;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GBdGfTu/DEGD7gyyD7eHAZgClVSFBbebOJCf/wl37k0=;
        b=haDdoX+MUMqa8KAzOPnzK2F21UQ77xBEbrALp/dh8KuzAGQ4f3QqAqah1vymTSN/ak
         L30gA7KwpkH5JKr9BlqWPFsImRi/l63kUHhuQk0FA15DA6atEGpg7JF76/m5cBj/Y32P
         RlonsD4DPkTFP+OnH4O01LVi5wwWZ1OHv09L82ODXSgITovfnmLxtDmbqNhG9QhzTn/v
         jrUehIZ4jm8Z4zXBSjrx6vmiav2Yv1af9VPn5ppnggJCIOz8RoSYazNiFT5E9ZF/ZXg0
         JrITqgVPFPNFNccaGt1jMXvCTiGdVKaAohixaBRcXRoSM+UX18Rc2B9ZVShVG+Pm9lC6
         PpkA==
X-Gm-Message-State: AFuF++mCDMO/aNa7kyChm5mrhzywpPwuzsNYWKB2gk76TbSTMvgL1th6
	5dERToGp5GSxrrD3gWtcHFR8g/3QiOdR85n83EK//fkVHdfmpaHIq+hb8OztzdEtkucorvdYE64
	mRHM86PYWbwosFrP27sn6QPqUO5EkYHN5GZ5oz07EOk0f1Febixh8eLRqDRUgqs4AG2Q4vVoW/M
	nCDAs1l0GQ5Ko7F9QsdPOtRJGh682H+5Os5plc7xOjZFFbfdwkoI6NkBn7YAsrwm8Pjqvdw0bBJ
	uab8pxGc+MFZ5vJ2kXIzLhvl5Zi
X-Gm-Gg: AYBFou3kMNks4XqB/F0+uIRtRzm9L5F/zPV4NmRH8S1w4ixqSwksn6ve8k0iWPsfLV8
	TC2vYDO/4/0hzXB9XaeatFgvDfZzLKt42ujqk2e8tU1t2WWXjXmwEfJEfhfq0Y8YBaJjTxb5Dbl
	sCWDMOoE24kX6nE7HPfa3v3oBs/qqnxAMm1wdlvIyggMyfJlNXxrZRN97kdgnwLOznw5AFxfksg
	VwSCpGaF75nqWbxOw9SAD+G8KlFta6Zfln1uc5JN2cLCCb8oYpHES2GsgRkJuxMKnLsr0Gv6nz+
	j1VqND3TcAowuccBtZ8BDTUPseEwXYhPrl/IwC5ESedWOPICFmpnwOd604DDHJlsupzTfSWGyju
	2U9KffdIf9KfJPe342u9KjdMQDy+GnK0BosgdBVqTuuiJqjzcFF68N71owmpHsAlfqbqBCl1YSs
	qOTkQpejgctLe/invqJInb3ly6uPzQMGvTR+lTB4M=
X-Received: by 2002:a05:6a20:2443:b0:3bf:7081:9356 with SMTP id adf61e73a8af0-3db4061ec93mr8200875637.17.1789416265160;
        Mon, 14 Sep 2026 13:04:25 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-29.dlp.protect.broadcom.com. [144.49.247.29])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39dfbac7303sm85096a91.4.2026.09.14.13.04.24
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Sep 2026 13:04:25 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-78fa7ff1a44so811371137.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 13:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1789416263; x=1790021063; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GBdGfTu/DEGD7gyyD7eHAZgClVSFBbebOJCf/wl37k0=;
        b=fqGL21QEbR0so+/loY/G03hzwZBnCNWC8rFulZcvs6t53DQawIrHE5lJ+7jZ1C0ULJ
         TSAteSlg/lEulhuVYv20gidQ2Gd0B8JNR21CZhJCm4LohY/HF2wVAVGhYWELfx5nRSsg
         7ADHtgCsLs+E+BKx9moC+nDutezYmpJpaAjgs=
X-Received: by 2002:a05:6102:38ce:b0:790:322:8a36 with SMTP id ada2fe7eead31-79b5b2916ccmr4709292137.8.1789416263426;
        Mon, 14 Sep 2026 13:04:23 -0700 (PDT)
X-Received: by 2002:a05:6102:38ce:b0:790:322:8a36 with SMTP id ada2fe7eead31-79b5b2916ccmr4709202137.8.1789416262887;
        Mon, 14 Sep 2026 13:04:22 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f47a6ebsm103068516d6.22.2026.09.14.13.04.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 13:04:22 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Jason Huang <Jason.Huang2@infineon.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	brcm80211@lists.linux.dev,
	wlan-kernel-dev-list@infineon.com,
	Darren Li <hsin-hung.li@cypress.com>,
	Chung-Hsien Hsu <Chung-Hsien.Hsu@infineon.com>,
	Chi-hsien Lin <chi-hsien.lin@cypress.com>,
	Carella Chen <carella.chen@infineon.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH v6 4/5] wifi: brcmfmac: report port authorization after offloaded roaming
Date: Mon, 14 Sep 2026 22:04:14 +0200
Message-ID: <20260914200417.1744264-2-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260911065656.1269623-5-Jason.Huang2@infineon.com>
References: <20260911065656.1269623-5-Jason.Huang2@infineon.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Fri, 11 Sep 2026 14:56:55 +0800, Jason Huang wrote:
> From: Darren Li <hsin-hung.li@cypress.com>
> 
> Firmware can complete FT or OKC roaming before the driver reports the
> connect or roam event to cfg80211. Detect those successful offloaded
> cases when the profile uses firmware 1X or roaming offload and the
> association request carries PMK cache state, FT is in use, or OKC is
> enabled.
> 
> After reporting the connect or roam event, call cfg80211_port_authorized()
> so nl80211 emits the dedicated NL80211_CMD_PORT_AUTHORIZED event instead
> of reusing the reserved NL80211_ATTR_PORT_AUTHORIZED flag in CONNECT/ROAM
> notifications.
> 
> Assisted-by: GitHub-Copilot-CLI:gpt-5.5

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Regards,
Arend

> Signed-off-by: Darren Li <hsin-hung.li@cypress.com>
> Signed-off-by: Chung-Hsien Hsu <Chung-Hsien.Hsu@infineon.com>
> Signed-off-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>
> Signed-off-by: Carella Chen <carella.chen@infineon.com>
> Signed-off-by: Jason Huang <jason.huang2@infineon.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 61 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 56 insertions(+), 5 deletions(-)
