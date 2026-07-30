Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B26A468C2B
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 16:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427492; cv=none; b=jfG0Ijhqpa2ls/lXZzh9r+9krwA26q/klgj3lYTPKrziDf+bqL2yfEzgXWbUlvUiUUrrdHcfKghCkZlEyoga3tsiVCy7DV40LDS8chfQAVgUBV+m+5O0s9UYjtualIvCfqsnkRc+l95SR7qaaqqXhMIddIgIlusSZYFJQHoqwMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427492; c=relaxed/simple;
	bh=Ha19f45cKy4P+0OsFEr+btZcY5O+YERSKZjpgYlX3f8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DtQcqcR5FSr/QhR+hkTDoSeltn2N4zazMx+89KjRcnt9d/FFbBIcFphVxt2Iv7uHs9Kt7eBNkvteRyvWxsSOqTElTnz4wMGdE0mZ2p+KvaJB2DZa0ipWMY+itfBgtUG/vIgNxIWeYRHCsBngu7fpg57+T2lJC+VKGZExHe4mnWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=o5EX2o8V; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o5EX2o8V"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8484a24ccf8so4497b3a.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 09:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785427490; x=1786032290; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ts4xsj5jidC5xPXZCTNfYevbfQH6viS7Pn42+gUfDKI=;
        b=o5EX2o8VAdONPSgoi8ITux+jlge/VzCXlCy1pQnLbXSfA5JVJd5VUkj+PtXGbD41QM
         sUxIzXSh5q4R0B56h5BGp8l2CzOtFOzAxOVojuahVlPdAn4Npj9LBhyQBAZL3V7T2vOH
         ESqLnka1R9czPN6HRkTZsFEpTVCOnB7hrJSowzYcZ7vg7O5wdDzMrT6bauedPJIwEfPi
         MQjhWK4ruuITEmutrNiYVeC5VPM6h9ULxjamIdW8qH+edj4N2jsYGvsIyPdOCm/Qw5Pe
         OqPrEtqWLx382J//tEVnDMdZaGJPbZ9TVyPLrlKyCrM1pOVhO1hl0GYNhUJ2JvarB2eX
         mHEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785427490; x=1786032290;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ts4xsj5jidC5xPXZCTNfYevbfQH6viS7Pn42+gUfDKI=;
        b=BU9xVCnNrTY0eiguOYD0/htePRtqyhpOS/6hjehA7+gWxAEvKBU42qB36nnhimGK1U
         /dohcfg54Fm2DnTKEAtbPPXp9RCRP2PVUcOhyZw5CfVdyX9+Ha2ZGyG2iHdaPgJJraY8
         CI/VjrGxH3byQUAa/NEbm3NoGOgFxk+hclWTOwqXPari/j7YNFfSXD4bj6HAxok13RaD
         FbyydXH3VJMiNtT8kHGQ2NTImtJkznhwhWLfQY+dfnBb/0B81KCMjIwhPu+LKZEeA4Bx
         ZfmmdGjMeijVA4wFCLXrtgT/9oRi5PAcTRZ1U8yNiOd/PotkfPljX4QLOVYALxb39Igi
         bBww==
X-Gm-Message-State: AOJu0YyLRXoYosVH+FNfFhJ6RG18Hj/ttAYsjSlEy32AO2JrFMi6xQ58
	5IhmjI4i79CLrL2HBQN+SNUZs6FFFwkj0b3burFeYWVABP7ZTpj5BheK
X-Gm-Gg: AR+sD12ezbp6pi3Y7waK1Ro2L/wYL+UO+vAQ0uia/qMk8I3E9Y5nX3tK9tTG8wN2+JT
	u1YBY2Ihe7lji7yHL99+xkZCga0A69EIgVGmmJmxU7wFJnV+92Yx7r5LIjZW64yICsq87eG+Ub5
	1KQhEaYr7SR8xpUOXqvORyGJJg+gj0u5JrSIdhJCV00s+cgdQqnmnKLjqwASkwg3gtv3oCUhg3t
	cp3VBABt0aOC5VZRXicJo1WjJ/5pDtYehdEmiEIqfThyq1Poi2lgpfSs8QWGNAUTswA9qIew0r9
	uF9JpnbxSCkUgVoQhHtpu1M1zBfmTHYN4ONXqEYvIj3pYEQpcZcoZkNXSfk7206OmnwvP2K7O8g
	3InLUqa3CjCfAQJ9lNkKOpMImOTGsaL1FyOuiVtdd7hs6XXcdH8SNEMVCgRnF/wrHe7nLxVfADH
	2Nl5WoBY6ATrx6HIQzPJexjIdzdxpw1dYMizu8aFLWlLpmHdnuT5XN5rykRZyv/oguIrVoi5St4
	Yw=
X-Received: by 2002:a17:90b:1f82:b0:38e:6d4c:14df with SMTP id 98e67ed59e1d1-38fa7f26f3cmr902246a91.1.1785427490492;
        Thu, 30 Jul 2026 09:04:50 -0700 (PDT)
Received: from Potato.tail66a299.ts.net ([171.76.83.76])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13e72643a12sm35012783c88.5.2026.07.30.09.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 09:04:50 -0700 (PDT)
From: Shivesh <chanelshivesh@gmail.com>
X-Google-Original-From: Shivesh <shivesh@example.com>
To: arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Shivesh <shivesh@example.com>
Subject: [PATCH 7/8] wifi: brcmfmac: fwsignal: safe no-op on duplicate MAC add
Date: Thu, 30 Jul 2026 16:03:55 +0000
Message-ID: <20260730160425.11933-7-shivesh@example.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260730160425.11933-1-shivesh@example.com>
References: <20260730160425.11933-1-shivesh@example.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Removes technical debt TODO by safely ignoring duplicate MAC handle
ADD events from firmware.

Signed-off-by: Shivesh <shivesh@example.com>
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

