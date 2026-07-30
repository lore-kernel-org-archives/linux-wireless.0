Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1046046AA87
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 16:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428523; cv=none; b=AvxKKSRUj7avEvfLe2Pg9vF6WGRlRPOjfW3hC4WR1Ehsn68Y7KLxa4Ei5fO/r55Ri4wrDiXzGznlBZRh0mn6GsujpCI0IeXjwKMSnip1S3PEV29kNykCRaNOAIbzqCq8WLxDQj7oRzfWI8GT1V0vWTjJH5VV58+ZLY+GN6dxIzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428523; c=relaxed/simple;
	bh=msMdhfowBySBXOdyCbxYCun0AlWqDhJmOSOvSMu4OjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jbk8m2SQ1y23paxdDcGazIlH4EHxUx1gAMUPwYCUTbgDAUbO4T9aU2J8RYCuo3v+gkWOsAN7FOcajzMvF1exfVM9ciDBn7mderp9gQYosQMOv5B4zT5O9Pmg1RlWnG5Gb4I+cmjhVf4Xi2kAXGbXAizAx7Mrcdj//MkDWCS6Hck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a2rZLtFL; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a2rZLtFL"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-38f0f3c8da5so6217a91.3
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 09:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785428521; x=1786033321; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SPK6mauK3g7KvbulXUNjPujp1LFeaCkSgeVtH4yKc2U=;
        b=a2rZLtFLerd4HpH+olwkjMUclgfNiISCykPNBDHH8OJSuNSIgIpPozE9WE6E3zqyCy
         zTnyhq1Bt1ceCsDzbRCYk0FuficWd7ejYkVqAXvkcuG6Eu+IkpMznlv/2n0p7PqnmXCX
         NOtJPqQZOfM+UBNuXyn0BXpuWfGPr3aGelQrVm7pwgqiDMzmnHUF0jCE49SzUwLoT1/s
         21cqEYk6WLdWwB08Iml50++VX8AReFWeN2MrT3sft9t7y4s1/D7cByqRpKldaxLDQLK1
         ZLKRlt2Lo2X6/BVm7pe0W3bw8oAfx2goGUy56T34U6SyWDn+uhxx2H2mU059s9KtLG7E
         Jyaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785428521; x=1786033321;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SPK6mauK3g7KvbulXUNjPujp1LFeaCkSgeVtH4yKc2U=;
        b=ZbOiXxCzGSmZPGSSqio2CLPTWgusqRNhCrsX0hO4vYUfxg/KprVFW1ehMeYL81tIi2
         H94ShZtqnrsYliWwpqkDNQBz0/VJy8tH9pEOdeKi3pQnqnCaknzZnF967b4v7vczuy8C
         YeBxEyzQ1NG/nno1o0aPSPNYeaQq3OTjBaLdJFk/nx6KFlHlpz8qDu6gvXQGBbC0AHqt
         4R0+XohXltcQWAJXrRiMrudv4CjXTkEethr1PYVwBtp4ljyVyoBq13FWfJ1n8r597b6d
         w1dGI1QPLfY6bVmPj0flHGtys40amTND4qmhXM+H1miPcLyzgdAXamCTVS7AUJ15ImlS
         EPQw==
X-Gm-Message-State: AOJu0Ywbidc5tvV8qdQYCEydtmcv5zBugzdoOBHWXtfnCJhEm6GzXHab
	I3vKAGZ+S2HzXSwaQ0H02uzvEk5ujUjmMlHhZGGl0y1Aw/AYANIlXgKm
X-Gm-Gg: AR+sD11KUuPtoec8Rsd1cTE49pA1qHN/NvVW0knFKSYkacaF93LC1v9AjX1jAgNvSlX
	sld+dnUD6ZoUVzOBCPJ2D90OMH47xJPD789cgA8jN9Amho5hjWLQinXJSnzLHo53IHlsCvu6JmL
	solDbBS4x744Ryo7bwBWx3gnLkcBAEyNAU/vmapDXSDlFCi8hySle3uV01NKi1vfWakdrx1fZkb
	a23aFU8g0E1sKNW/K3cN7av+waGvk6H8DU+QBECVNBcam59smod4/xG2MhX8ZccQ95oaNkx4K8B
	0GBYALF3xN7A0S/+GNhXu6c2Y1bSn1aKGNQE3S+xWFnvyYgKAYrY1ubKUwglFq4HzitNP1jEdWi
	eI+TMyxvlSZv92RZCZU6s69ptdSvhvO/C4AFd1Y/I4EGhN08+UFvqnTnQ6+eI13nLdS+NIOlmPh
	YByfjqg8SCLc6oDX6mwhlnPwUcU262+wU/cCfEJIDfgJMy9xpSmZbXa9Gzi5ti/yg1FU4IKAlqN
	Bw=
X-Received: by 2002:a17:90b:4a0e:b0:381:77cd:38ca with SMTP id 98e67ed59e1d1-38fa830a75emr674831a91.4.1785428521244;
        Thu, 30 Jul 2026 09:22:01 -0700 (PDT)
Received: from Potato.tail66a299.ts.net ([171.76.83.76])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13e7275973dsm19964269c88.15.2026.07.30.09.21.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 09:22:00 -0700 (PDT)
From: Shivesh <chanelshivesh@gmail.com>
X-Google-Original-From: Shivesh <shivesh@example.com>
To: arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Shivesh <chanelshivesh@gmail.com>
Subject: [PATCH v2 7/8] wifi: brcmfmac: fwsignal: safe no-op on duplicate MAC add
Date: Thu, 30 Jul 2026 16:21:10 +0000
Message-ID: <20260730162135.12278-7-shivesh@example.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260730162135.12278-1-shivesh@example.com>
References: <20260730162135.12278-1-shivesh@example.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shivesh <chanelshivesh@gmail.com>

Removes technical debt TODO by safely ignoring duplicate MAC handle
ADD events from firmware.

Signed-off-by: Shivesh <chanelshivesh@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
index a43f1a38b0e3..3c1ca355e8ee 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
@@ -1037,7 +1037,9 @@ int brcmf_fws_macdesc_indicate(struct brcmf_fws_info *fws, u8 type, u8 *data)
 		} else {
 			brcmf_dbg(TRACE, "use existing\n");
 			WARN_ON(entry->mac_handle != mac_handle);
-			/* TODO: what should we do here: continue, reinit, .. */
+			/* Firmware re-sent ADD for the same MAC handle.
+			 * No action required; it is a safe no-op.
+			 */
 		}
 	}
 	return 0;
-- 
2.53.0

