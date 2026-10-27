Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793087749;
	b=tg1ip81Rcq1pJZXGTrXR4LHJ/4GzRFGtKaOumbNl19lgx8KVx5mLt8UFvSkCYTuLBz72
	 lmc1SYI58ktrp2Xr64A7+/s1ssT1YWpV6WUhD7zUH9R59RK81FV8lyTUPHR7K1AoTxd/j
	 v2YATGoz/XfXYXHZZcgqcVPaC6V95cRt+zSN29YNpz76LA0+pVEMnHjbz8x694+9H0CS1
	 K9g0pzN7Vpr4Sv2mlYIMy9DMxxxSLjOCjr7Ef/VdH6q8oo4wrWeqS93vGxPhLmAfELRJp
	 4C06M1TRbGPY9I7CFdD5DSVWTMd624dD6U5num9fwVPse1yjIezj3CcZwZAV2MkZh6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793087749;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n0TwnzTIHDwFQ2i6Elssq13LiQ4D8uWjLOq+Ut0imnI=;
	b=Jt2Ru8cp/xMVddL0Ru8HhaTeol285csifLvMUC2UcELbS6VkqQFvdz/aQKVGi1esnmZG
	 fWpG2I8+NOFBvKeS+yqVQQyTYB87m9vY1MZ+oFx0W7WAzSeDbGSucd4ylEOQNjkkrxy1G
	 tW3DqsHlkcmySWNlbjCxc9ZrdBM62EuqIZOTuRT2XmVMICMsyK1OpIIsjaAv7dwiTwF9c
	 CWPdLq7CdiRWCpF8t7xSgOqsdBWOlLk7ZV/kRZXl3m0KlIKY9IwOtiGXQw6zW7oXGHTr0
	 RIm1Ob7y9NaavfFG1pyL2OeqUoN4Nicqcltr+vS5h7aaFszjP+YcXp1TrIdYdk87rcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bairaktaris.de;
	spf=pass smtp.mailfrom=bairaktaris.de;
	dkim=pass header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=PiBSa8rS;
	arc=none smtp.remote-ip=209.85.218.48
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCF8606A324
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 07:55:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ACCF8606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=PiBSa8rS
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c45551fa84eso559769966b.3
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 00:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1793087747; x=1793692547; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n0TwnzTIHDwFQ2i6Elssq13LiQ4D8uWjLOq+Ut0imnI=;
        b=PiBSa8rSvy54KWsN+ho1LC/FHhJynbYcwVoKLdey84bQgVuWUJvYtnGQ5/D6Y4dmrp
         67B0g9HuEMsDwqkBa+TSPzpUCRXE3aVI8N+T82NHNoovbd3TTIzkdT+10ACK6zgnmeh6
         CCHt7Ye4dz3snQu1xQg0roB6Tl45V8CgMbsqh1+ww9ZpasJHiK5fkcLjQqx/Itlh9kWT
         Tvlncnyktg8j0hkUwF1tyPQ+HF9AkuTNBCzMKc7NQJj8uRGj2JMbm3QW4Np+z3ht1zE0
         h4eo+j44yNsdAto/YyFYEx8hyA3zNAb3rtg+0a4ykw+Z1Ykhg2jtXZmUT6gU2dSYxgxn
         3yAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793087747; x=1793692547;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=n0TwnzTIHDwFQ2i6Elssq13LiQ4D8uWjLOq+Ut0imnI=;
        b=Ij55PwJNsvHX/i9ftjeyj0k4HVuOE6JvjOq3tJSZmODn5KuBZfA0HE6t1Va9pQ0IFM
         R+GANm5cLgooy0JGzaAROM2qeqTpPCsN/xfh7K86nQ5ZdxLfr9HbIVfh31rruETEfIVO
         6tqMb6m2eDRcZNops+4TYwK4UNMqug4s5CTvkJJ3rCTjZCPXh24eU/hqfb+6BLNArCPb
         bxCS/y61BPTirH1a4n5ebtPa0ls3ZtX4BXDebs2XqFPD7HyaleKO+ov9YflTL9QJJP9h
         eZ4stSq2EYuKAgyKORFTnjz9q9lxy5+yBQM1teDtleIxTP+7ArAz3sT/qt0Km9e8svg8
         YrFA==
X-Forwarded-Encrypted: i=1; AKwUvBwrx5QEn4ofVs/K4rTrA7lAOKkf4mxnfp9K0Ydd41Fna7Znd5rcq8bZQ3M/TSC6DWl5JO8CV7D4ajNWsHUktA==@vger.kernel.org
X-Gm-Message-State: AFq9FYIWV4xgM0wym1lm4RVtirREnyid6TsHd7cl9vtZtEGl8+pc7M72
	335PthoiCI697ABQWg49TH3U1bHDYvdaaHLSGfMsGXbqDHnpfYHlQsiN+sck1BUBmg==
X-Gm-Gg: AYBFou2r1FZObeLPVFLLU0+/fJ11vGXPep9Xhpw8zHtda/CI36kgm/J4M4oSei4ba8w
	7nYE/Z+SQS8aWCEzLV/WCydSya0q7HYiOHFwoo6GZwICBoYqjlcIFRQMTXWy0WAs4Fo+hcSPoEm
	iLUygQAnW3YW3mm0h5IqkGb/sKXRGPGnv/AjUHSGFLaCxtYsAiPweEtZCX2R+udQLTAvBEYGOiQ
	FGOiI+xgcN8AGBAaI3K2wjqGTngyXGCybFUXiBdeFsh62+7DW0I/A2n2x9wcJTz+2bOaQ/RyiS7
	M/VJtXQBW6iQGMk7QLH5LP9Jul8zPLJihORFUoo14olZ4Nzo7irykD9v1zobP0EGOc7afYYMNDI
	/umaGMno9tToClkwbLfbE7jw65We5dIjxjqV5Wl3FTteiNx/7CKDbYYE76N7iZuQX1VTybDzGs8
	Y2gV5MvN3AUYiq0r+UOgM+eTFnaznMx0iF3zZ8/F9YJx4kEha4Yx5YRaOFmx4reqWKhri5v6EyF
	NAP1KadCe1gNtSEUTZkLjSoa7TRJF7Q9OB+36qzuxvzK3H4NnsjQLQ8U1Chca2mr6FumdtTQCcs
	yGWjy1e+pNyu92ESHlkhgH3NJfUMVsk9+wJzCLuQ4Q3/Ky2NZd4ipu22Xxp1MTYS4mf0+qpq9xu
	XUxPMJGKN6doepTzmzHd00PNYctzRKyPotKOwn09V3pLpL4d8z/FRzDYIegZU8fmzoeFYKESGI6
	ZrlGYXSVhmbVyEw2OnQ+qzaGoE2BAa/RfIxg6RW/YIDIuNIfS0R9hdBMScOiswopHcXEPFCPWlb
	fHGMMzq
X-Received: by 2002:a17:906:ee82:b0:c32:414:b72c with SMTP id a640c23a62f3a-c46bde461b5mr926740066b.45.1793087746615;
        Tue, 27 Oct 2026 00:55:46 -0700 (PDT)
Received: from Desktop (pd9513dae.dip0.t-ipconnect.de. [217.81.61.174])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b445971a9esm4669251a12.19.2026.10.27.00.55.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 00:55:45 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: ath11k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Semih Baskan <strst.gs@gmail.com>
Subject: [PATCH ath-next 1/3] wifi: ath11k: skip unknown hardware modes
Date: Tue, 27 Oct 2026 08:55:42 +0100
Message-ID: <20261027075544.19144-2-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261027075544.19144-1-julius@bairaktaris.de>
References: <20261027075544.19144-1-julius@bairaktaris.de>
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

ath11k_wmi_tlv_hw_mode_caps() indexes ath11k_hw_mode_pri_map[] with the
hw_mode_id the firmware reports, without a range check. A firmware or
board data file that reports a mode above WMI_HOST_HW_MODE_MAX reads
past the end of the array, and the result decides whether that mode
becomes the preferred one. Skip every mode from WMI_HOST_HW_MODE_MAX up,
as ath12k does since commit 1e9b1363e2de ("wifi: ath12k: avoid array
overflow of hw mode for preferred_hw_mode").

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 08fd6795ed9e7..b3c778eb15876 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -4776,17 +4776,19 @@ static int ath11k_wmi_tlv_hw_mode_caps(struct ath11k_base *soc,
 		return ret;
 	}
 
-	i = 0;
-	while (i < svc_rdy_ext->n_hw_mode_caps) {
+	for (i = 0; i < svc_rdy_ext->n_hw_mode_caps; i++) {
 		hw_mode_caps = &svc_rdy_ext->hw_mode_caps[i];
 		mode = hw_mode_caps->hw_mode_id;
+
+		if (mode >= WMI_HOST_HW_MODE_MAX)
+			continue;
+
 		pref = soc->wmi_ab.preferred_hw_mode;
 
 		if (ath11k_hw_mode_pri_map[mode] < ath11k_hw_mode_pri_map[pref]) {
 			svc_rdy_ext->pref_hw_mode_caps = *hw_mode_caps;
 			soc->wmi_ab.preferred_hw_mode = mode;
 		}
-		i++;
 	}
 
 	ath11k_dbg(soc, ATH11K_DBG_WMI, "preferred_hw_mode:%d\n",
-- 
2.53.0

