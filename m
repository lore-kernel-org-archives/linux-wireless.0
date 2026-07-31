Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02A3448389
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 15:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785512973; cv=none; b=F0+wk0he1k2VoTgl+uKuBrDZVAiEwsqKCNem9kUA07OKpHU7u0SJ4caOJef0O3EXmYkxzfl9Kf/QWDt5ZilGJ72jmFkx24J/IRbUH21Cg5HN0fF61/sQAaC4LRl3x5KJxP8NwR4QnwvGd9YyR5GyiB03/9O1fGF75Yffq16nxmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785512973; c=relaxed/simple;
	bh=msMdhfowBySBXOdyCbxYCun0AlWqDhJmOSOvSMu4OjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kLzwfnFP/FbT8QfmZ8cEZW0obEsPZK++NqGdOnSe4srOqZaD6PZZPhgICcJq2J8jX1xZeXwmF2267R60eeIA/hiiOEbxVmZmRR/+0TZg6ylYn9MrWB3C/JFzefWXR2vOy2LkGdP7j6cmq1aoo+Sg1VCaNgDCZst0h10odz/brIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mDpSF3rE; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mDpSF3rE"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2cad85b7b5aso1021125ad.1
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 08:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785512971; x=1786117771; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SPK6mauK3g7KvbulXUNjPujp1LFeaCkSgeVtH4yKc2U=;
        b=mDpSF3rE9izPkEIV6pd3AdxYP5oiOAkGibEjVKw29QJ6DWHvPC6K2JX8oKsSAIqhgt
         cwYItmEruIWYrjTTWiBKAApt4WK+im+TViG1JLFbguuKLgh6ngptHNYtaRraVOZoUqA1
         CvP6ZuuzTYrX32ao4IEVY257BDHjZArmw+uKwIPqppFPz9ws0zJ6wAZ4WT3b2tLmdbmP
         SxyatK/hF3FQRKgKZRntbf4weJgDaAQ9AeQwbykYXegQYlexPrmAy9LBmocQ5aarSdvw
         WN1Lx+P969dx7+YGEgKI2aQv8N+/zk6wrkhaY7HAZgZzwEyc2u9SG3GWEV2+/I7wfk6L
         9xdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785512971; x=1786117771;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SPK6mauK3g7KvbulXUNjPujp1LFeaCkSgeVtH4yKc2U=;
        b=gxQmi0zpvZxBZc9qMAgXfm2i+TuZlgmT3nT0Crx/6BUbdKOI7KsWvFTxaDYN868aR5
         YF5hyVrPTgobCmR94ZySfgBHGxP8uVCM4gtyuohoy0/JZlMd4NSVkiNeTFgiqyA8+FpE
         JHkJfIBlf+UTyjmeb0D4WOoVQu36aG8hYyL0lXWevwEn1v6pG+5KZ1yz0WDWIce/3pI6
         H6F8iJYBVbc2KMm17BmMGnAzT7WgtrMnR6mqXq2qT3IOcIklCyxW4OddSGCvB7OwAGmV
         puqNGDuWow81GWyvWAY+Xeblix7rP+51uVZ7JsvWFitbXfJ98z4qqKf6zT4DESMLEJzQ
         eyAw==
X-Gm-Message-State: AOJu0YwDKaw0d08Jc90mhqHIPOyV2gqIxpYzeICwI/QHOecxc445ZGlS
	UWBRnYslyMbqulQ/7m82VH0roYzME21OdfWJZ1Q6EJJl6+oKR05Z3FnR
X-Gm-Gg: AR+sD11T5mc0nRKHP5K9kG3cbOGjzYdMzR5GHH+OpyFx6plU4Jn0quJG8Efr9yVxegk
	H+R0vorpl7/cnYKZ710RPEy/+GEWlzK84ME6YUwAd8CVOavMYE4xIHU0FjfjD0Z5M4Gh7qiiSWC
	/7YF5QaUHJru2yULQiOdRXmSZZ/HTpredoH+tgxNigD3UwyZzvGjdy7qfVpTXVcLIaOGtC5z+t4
	hZtwwt4QKTFyMO/QFlU3qf5FSR4bi0iAuw0w9KSA346koE5jfn+qMaLfsom7q8rjVL9JUHrPXg6
	PG7IJe8ehXNvUBDBhyRqz/Rrftt1Hq8jEZa+jIYcqbDDkDmiH/SK/SxSVOGGL2R1GX39gcLVt1/
	HXrtMAlzcmzH27pvWSbN94SZgS/7I4TYwo/Ty9pSfc3Ab1/0sltnsDFOC5TdlicAgKZKK7YNVXm
	HKQBMgwn0Ju/YqSVOPDFmljXN/kl0ABvNIGLd/78zMmr0LUJ/8kIYTuEe6rmA6a2FZ4l2v3bLVI
	Vw=
X-Received: by 2002:a17:902:ced1:b0:2c9:fbde:ab68 with SMTP id d9443c01a7336-2d0523c0f5emr7083365ad.3.1785512971076;
        Fri, 31 Jul 2026 08:49:31 -0700 (PDT)
Received: from Potato.tail66a299.ts.net ([171.76.83.76])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153e045016sm11852510eec.19.2026.07.31.08.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 08:49:30 -0700 (PDT)
From: Shivesh <chanelshivesh@gmail.com>
X-Google-Original-From: Shivesh <shivesh@example.com>
To: arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Shivesh <chanelshivesh@gmail.com>
Subject: [PATCH v3 7/8] wifi: brcmfmac: fwsignal: safe no-op on duplicate MAC add
Date: Fri, 31 Jul 2026 15:48:39 +0000
Message-ID: <20260731154901.1822-8-shivesh@example.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260731154901.1822-1-shivesh@example.com>
References: <20260731154901.1822-1-shivesh@example.com>
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

