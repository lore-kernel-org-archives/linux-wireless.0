Received: from mail-pl1-f226.google.com (mail-pl1-f226.google.com [209.85.214.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B1B340402
	for <linux-wireless@vger.kernel.org>; Sun,  2 Aug 2026 08:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785659953; cv=none; b=BNgtwTt5NUUUxGPcECICMOXG6VUQA9s1dTU0CzfMhXmP2SW5hvxii4TRqznFvYRcwpyFqLx+jhc1SxxMUO0uZml0VNMdqTdirbiBf5x1jzd7yVm70LbGIBV5rF88d6GprJdS95Rkp0aU0EPoHKrkXKuL+VE5OTVfPosV9AagL98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785659953; c=relaxed/simple;
	bh=UKrW9nXcUEOoZsQi1eBYDxrgEKEtHJTn83NEJj/UUrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aK7v6H96W5MxuPb1byfV2ZevjPy5DsBQDRXhafrrLAj7l5rWJMWhyPYzn3MzedagAQJLFum5vh/Nq29VAK+ehVRdApfsZKdJyNN6iAjaz+rrJFF4MpnLnD6hTQLV9aR1KoqR0HNqR45JXgUygwyujrSY2QioFhFuen5I/82pJLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=SS9lNWRs; arc=none smtp.client-ip=209.85.214.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="SS9lNWRs"
Received: by mail-pl1-f226.google.com with SMTP id d9443c01a7336-2cacf197759so35290855ad.2
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 01:39:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785659952; x=1786264752;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QcNqyGzkZccinhf/pClfyqDVf/rDURIGbJC6+/X1yug=;
        b=fxgUhmzSRx1l8LUortxSm592QReaSAWNl5wlxQe7bjZoTbibp3IQU7qJ+yj8VBGqBX
         5cyQ8SX8s7gIqvE1uayhk25sjfsO953AgtqZW70Dw4BbYz8XE/6KJgBAl/Xolre01EyW
         5CeT3WqLsynHqfpNqWoRqISVpNa7mfirOqywkxVCFGHt5Dz3WxRceRrJWR/YV6bv3uXI
         YZuWhkwGUNEDZBHxm/V6PfJrsS+gX5m8Kh7BQ6rLNt6cU2mkeh3gznmzIGQeaKGW50Yg
         Xcqs2fJPBrRpoCfOHCm72CqRN0Ac/+bXDSJJmLVZDEA5R6AgV6LKvT/M9FmLwHWRU+cH
         Of9A==
X-Gm-Message-State: AOJu0Ywb5dUewc6vPl1arQdQmGuHwCxlkFuyApAufrSO1nWn4JeDaUvV
	WN+NNSPaiAj6HOmEpJd8DWC7BeQXxF6xtFsAquPoaB9P+trjwpfPhq27ZbFEoj0oxv4+6JQrQ6c
	3okAhM2k0lIwXLhAMIe0o/sMCewrtwNzzEiQXw21WOisA/fMap1d4yg6VRQfl6NYQ3vrFET2VvE
	36I7T+N6cgcIOeQdyD7EXW7OqAmv3Go5NN+CEHF3F1mTND6xexdXv6u8uBL9BNd57sMkXss5e19
	3rP0OenW+crkdkCXoDR+sVMY/p8
X-Gm-Gg: AR+sD10e+ikLXn2HnqLxFYEGCiVVFLiRb26TjH3g4YXJZAiUjUqovXciGKucxiD+nNF
	utJYSTtddW9Kt/1e0u42L38lRbHGvSwsLpF5u/wxnRvzsAIjSg3OUBRnD8zbfOHgGrWCNUQ4eqy
	07Cq1/P2lOkP9EWOxv40eyeCLAKs92C937sWWQ4NrTZ9emI0dUBMAyU073edZj615NDpYL4NPNM
	nZgS37RVl49EocVOfmTDICUaGlP7r2GEyVghh3EiDvJooKUEb90WSRvWySbfkHVgrTng9UMOjIp
	z7ajOI+48MLDwUESEKCYWB2Uha1OrcYUGIzsB2Qvup2tyfVCskcFJoJguegLcjorqgwFk4+/iLC
	ZnKc5FxKEHLJloaRGd5ZQOIi1U78fgIK22iXbt/dYD1/YyaTamhvrHfzjjjbgUEb5ciWrpnE57D
	ywmerWkbtRswL8xXeZDetdRJmnUhLVDUARmu4nG2k=
X-Received: by 2002:a17:903:124c:b0:2ca:5d9a:ecc6 with SMTP id d9443c01a7336-2d0523b7dbamr55369265ad.28.1785659951655;
        Sun, 02 Aug 2026 01:39:11 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2d04ae3f6a5sm6288075ad.2.2026.08.02.01.39.11
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Aug 2026 01:39:11 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-8fdace20927so22891926d6.2
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 01:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785659950; x=1786264750; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QcNqyGzkZccinhf/pClfyqDVf/rDURIGbJC6+/X1yug=;
        b=SS9lNWRseoG2to4aZhSbBPVKfU1Jb3FJwcWfe6/CcmGyLPS6C6zld23LbGcXnb05BT
         PtJP4Fy4Zv8VK66aGHJ5d4uiFJ+5HwfnCac2bxuvwe2dhFuz5s01Jkh+mLbOfSkQ2LUE
         pOWibaHRABe0/bRBqi8jIZqUDOfYGFhv0G3gw=
X-Received: by 2002:a05:6214:c8d:b0:907:e7e6:9544 with SMTP id 6a1803df08f44-908495bbd60mr101854716d6.9.1785659950083;
        Sun, 02 Aug 2026 01:39:10 -0700 (PDT)
X-Received: by 2002:a05:6214:c8d:b0:907:e7e6:9544 with SMTP id 6a1803df08f44-908495bbd60mr101854556d6.9.1785659949617;
        Sun, 02 Aug 2026 01:39:09 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908435def8fsm49457956d6.38.2026.08.02.01.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 01:39:09 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Jason Huang <Jason.Huang2@infineon.com>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH] wifi: brcmfmac: fix P2P action frame handling without device vif
Date: Sun,  2 Aug 2026 10:38:58 +0200
Message-ID: <20260802083905.3819981-1-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260722082608.412472-1-Jason.Huang2@infineon.com>
References: <20260722082608.412472-1-Jason.Huang2@infineon.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Wed, 22 Jul 2026 16:26:08 +0800, Jason Huang <Jason.Huang2@infineon.com> wrote:
> Some P2P action frame paths assume the P2P device vif is always
> available. That is not true when userspace sends non-P2P public action
> frames through the primary interface, or when action-frame abort runs
> after the P2P device vif has not been created.
>
> Fall back to the primary vif when aborting an action frame without a P2P
> device vif, and guard P2P device saved IE access before using it for
> peer channel search.
>
> Fixes: 30fb1b272909 ("brcmfmac: use actframe_abort to cancel ongoing action frame")
> Fixes: 6eda4e2c5425 ("brcmfmac: Add tx p2p off-channel support.")
>
> Signed-off-by: Jason Huang <jason.huang2@infineon.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 4 ++++
>  1 file changed, 4 insertions(+)

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Provided Johannes is willing to fix the blank line once again. Fingers
crossed ;-)

Regards,
Arend
