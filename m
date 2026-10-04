Received: from mail-yx1-f99.google.com (mail-yx1-f99.google.com [74.125.224.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918173AE712
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 12:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791116915; cv=none; b=OB2mv43R0AUF16Lok60Mu6Cb2o9Hg3KysJfB/C5fztwRgz5ez2ToIOb6/bBzPVviWefQpfHtabVNXzFI40SD9cAfTFtp8/HrmEqtWMb6sl+zgW6e+ZB5tc0jgpj+S//ht3lrxiB8lDtDlzrUCbNuUOB0fjaKd+N5JGr/gy2cjjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791116915; c=relaxed/simple;
	bh=f2x68Pd7As1GqZKJQOjAKYNZhM/BwR7nOPBdxDi+i8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nXJUiDxtXC1WGWm6IfFA0EaOKNluLK4azgfcRM0PUtaqWJEQqdVlhB6H+DaIwRfh++ukbKtOG6Qou34W30/qP5fCrk2Z7VzQ76rjh5u0DHkLHMzYXLOlbcYLZbQNPhpbwsAWhJampJdc3SPZ00mxTs/COO+vbaBvxfl97f1itoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=X1oHkXKS; arc=none smtp.client-ip=74.125.224.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="X1oHkXKS"
Received: by mail-yx1-f99.google.com with SMTP id 956f58d0204a3-67583c777abso460483d50.1
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2026 05:28:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791116912; x=1791721712;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5vxCHe50qu0ZSP0ZUfgyqzcneNtbGphUCpsLuMQGyLs=;
        b=13bwqODQXlZSwS8wpzt4R2VYfZC2yu/3KKUNNvQtNiVgXmOdg7FF7U4QYUuOUkDsKo
         bBdIiPPCRqi9uCFqgtt0DmQqpcr+cRaTiY8v7eZLqMapwQVOgr+tpoS0AZQD14x2lyp/
         mXDwT9jRoPNWRMFGoxKGC5ds8iuqKTnoEPdqbp09JKPrCDh7pG2WWcv0ap4IRi0CX3zb
         Bq5TOF+3ows4P0RpR9xG9q9hXeVwqwmf3D9x694VRts2DTEGwZTFrq76nO/TEmhAUXD3
         9TLDPZc4aZJ9ygp7vrFFiRMT99Tt8WxQTTvnzhmLQwDZwV0mgF4Gu2xCZDbzUdrY00wL
         E7Pw==
X-Forwarded-Encrypted: i=1; AKwUvBy0DaaqZsqs9i9dkp5q/OmGABeZlCkCZXe1bTCmN/Y0ZFF+u5lroSIyPudn+EnTA8NiNlnB9wRFlayyalbsLQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYIudOERYhj/1V7PijXMlKtZo3FpLTYl8GX9fPoek8UeiyFEdSa+
	w2Y4S9EDP/A+VBk9bgqqQ7b1f9bhM7REozOiwkMxS5u2rxQkFbZ2jNxaNCXzVe5844TDxO1pdW+
	iSl1N/cIEEnax/bN0kEAvJfaLVUibIOlU5qzgg9Qdl8HFmDEMrUN8t/TzQPD2dp5Q4F1V6DxF+0
	Au9fV/dmHaMF6R/ZCkTyDKGOUI5a8zXyR3/Wp0fgvahXTyETLJhiU+m60q+u5+9v45Zv1/tmF3B
	lUP5+4Xh48TAlKyv/ZJDh+zc9Yg
X-Gm-Gg: AYBFou0CnaCswpoJ3Iaq8GafYKVCOgZoCDWmwsep0pPrs1LNAIP6a7sVQKRlk0n0pMc
	FofUeFAmxJJXUaUhqvGtF+w2s0oN5FhFQvCt/zr3ljm1qBABPk5yHX32EMHw0xrnh6IAPtRpT83
	HSMKLtxWaa1OcR3OpF9s7i5C6R/3OOM0cAoX9izXcYvAZPOL+moPxeGT8Kgr5mkYFtBjDiha9gR
	wuQPiQcw0vzbJXRtmfSRUdrO7vhx9jZYU0NAHTrhdqlRdj/d1Ft/Q/5Z1lnKvn8xRIbcKx0cEnT
	q75ortoxzUQxiRljtkTmkb70q712ZWf9p5eGi9UZyulzHbeCNy2gE19IXiDUzU/6BhNEMis4ABO
	DtP7eWsvCQ5y4Qn2MVm+X83GFSDhTkZADvG1eobmOzXwyw1FP/ZPYhpPbsmFVhB+w8u1z26i+QN
	WFROa1gqXFd07mHs6uXLt4cnX77+QmKBw/A9YcpmNiuw==
X-Received: by 2002:a05:690e:169f:b0:677:bfb5:44a6 with SMTP id 956f58d0204a3-677bfb56f81mr1935528d50.11.1791116912412;
        Sun, 04 Oct 2026 05:28:32 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-120.dlp.protect.broadcom.com. [144.49.247.120])
        by smtp-relay.gmail.com with ESMTPS id 956f58d0204a3-677c1b4352esm802365d50.19.2026.10.04.05.28.32
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Oct 2026 05:28:32 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-3282d5302ffso1270996eec.1
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2026 05:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1791116911; x=1791721711; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5vxCHe50qu0ZSP0ZUfgyqzcneNtbGphUCpsLuMQGyLs=;
        b=X1oHkXKSLckgpGA55a2xY9GUl1OHSH8mE1S2DahxzNLba4xIA2XlIkaIFY7bC/nAhv
         wSkl3xy/mptMU6tLDOfrU1MvUoZbuTxLdwXE86/I3gwpmE+4xSOWQZVtiDq5AL6/OCV2
         YugwicfaVV3sTlN+VLTVnYwK+CrJXoqojEsAc=
X-Forwarded-Encrypted: i=1; AKwUvByBXLMVkfVLyWwHvjEwgfYhGn5K5Kd8poWf60u0fprJ9/ELHDWnWuhS5PWSzCbO47n4U/Ei4Up7ScO5ty+H3A==@vger.kernel.org
X-Received: by 2002:a05:7300:d08a:b0:339:851c:4c1 with SMTP id 5a478bee46e88-34db6bfe0e0mr12512301eec.18.1791116910759;
        Sun, 04 Oct 2026 05:28:30 -0700 (PDT)
X-Received: by 2002:a05:7300:d08a:b0:339:851c:4c1 with SMTP id 5a478bee46e88-34db6bfe0e0mr12512267eec.18.1791116910074;
        Sun, 04 Oct 2026 05:28:30 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-351271847fbsm7734182eec.15.2026.10.04.05.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 05:28:29 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Andre Eikmeyer <dev@deq.rocks>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Aditya Garg <gargaditya08@live.com>,
	linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] wifi: brcmfmac: handle missing D3 ACK on BCM4377 T2 Macs
Date: Sun,  4 Oct 2026 05:28:24 -0700
Message-ID: <20261004122824.1390579-1-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261001085308.1688049-1-dev@deq.rocks>
References: <20261001085308.1688049-1-dev@deq.rocks>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Thu, 1 Oct 2026 10:53:08 +0200, Andre Eikmeyer wrote:
> BCM4377 on the affected T2 Macs does not acknowledge HOST_D3_INFORM.
> The current PCIe suspend callback treats this as fatal and aborts system
> suspend.
> 
> When this happens on BCM4377, mask the mailbox interrupt, preserve the
> bus-down state, and let generic PCI/ACPI suspend proceed. On resume the
> existing recovery path tears down and probes the device again instead of
> relying on a D0 mailbox transaction.
> 
> Tested-on: MacBookAir9,1, MacBookPro15,4, MacBookPro16,3
> Signed-off-by: Andre Eikmeyer <dev@deq.rocks>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 7 +++++++
>  1 file changed, 7 insertions(+)

Thanks for the patch. However, an earlier patch from Sebastian Reichel
already addresses this issue generically: "[wireless-next,v2] wifi: brcmfmac:
Improve D3 substate entering timeout handling" [1].

That patch makes the D3 ACK timeout non-fatal whenever Wake-on-WLAN is not
enabled, which covers BCM4377 as well and avoids the need for chip-specific
workarounds. I have accepted Sebastian's patch, so this one is superseded.

[1] https://lore.kernel.org/linux-wireless/20260915-brcmfmac-bcm43752-suspend-fix-v2-1-1bd84914998b@collabora.com/

Regards,
Arend
