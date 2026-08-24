Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16A5399351
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 07:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787557377; cv=none; b=dOPZENcniBJVItKwLzWWMK1OsWBHV3koKJBScgu9Ob3HP8RuVur2xW/I7M7OrYJCm9DzN+pJ40mb1DW/x+ZIi0YfDfIWA8GvlLA6Zn/EKhS8Xj0UllMitymlG3aS1oS+i/9uYBTM/w2tALeKhX3VPzXzEuJC3ecmYpzfc9HYjUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787557377; c=relaxed/simple;
	bh=szRQI05HgxKaZ6DD6iGBYhm/R7wACl49f6sU49pF69Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CLKCy05GqKTEXwloDyh9vcqPXm4KJHICsdx5IZBrAa6NlnqILpp58jJpyNbWvs7e0gsrGDW7xuvxKSp3hteA51jGwXONa+8SqE53C1TZT6OciO2AYJuxLKQD9AbMn1Y36Y1tOKjww8hZyHRdOfRHCkZBdH8Zv4aJwAaAXTlKh8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=hXAEl2sh; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="hXAEl2sh"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c197e7e4e94so555350666b.2
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 00:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1787557374; x=1788162174; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RRfRf2Fgkto2eylatQTpTDlM8qkBEZ0zYa2j5Lueb1w=;
        b=hXAEl2shXRZ/IGAwWhqjRH36ZqZCnuElboQ2SsYbSUn48IXk9kLQpQn5caIdE4UXkJ
         nQr38kkVePilKI/fBW5dDiMcPTYAEvYyOIdOVydzxy5xs3VS8JzxZreWMm+VrDA9Iu/5
         EUjL0n3OzdTfZ+dq+3r8DkkHf2OcBsf42oWSv8Ms5HCf/rlx7qSBoNIAWrminLs9VSEQ
         In5cSf+eV9kQtbgR5d8Eg/M496kuEcOO7A918uOQgRO/SfMgR7NE5jmdbgvQ8Ml5bGMQ
         E72ldMpAHGrp6xuwDTOV2HJ8J4P+2keK0heDZT+CO/Dkv1uNBH74DNMjhGLBucjS1ufw
         Lr3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787557374; x=1788162174;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RRfRf2Fgkto2eylatQTpTDlM8qkBEZ0zYa2j5Lueb1w=;
        b=LcP2uf5Sz95+kSUp0bHr8onDwtoICPwHq2rxg78kxD3EVaWNfUe51ZE90ZYMaOpgi1
         RTejohxV+DFXIt/h+MM90OkgGVCfjxrUpg5Lt2sLzIPxCby8PaPmPjXsEO8o9Ue6Nogp
         0ZlJ3hNrjHNlk6YtqEDztYbb7zF/Fkm1WYudVEIYK/iNa7l1Noahl7x1j+tAlUXCFUbJ
         SaAJZslVCz67bVhU/du4tXo5qst3p37iL+33stbh639p1BhUTYR3aZGNSAZFS25ly5Rq
         pEd2TuwGs4uU/czbB9YOqzJt5kSKiplIYrIA2pHkkVIM5EtIfulSAO82cxzktJTTZKep
         JvAQ==
X-Gm-Message-State: AFuF++k1t5AtTgeJouDwXnikuWynMh5YVh6vHwxTo4uu3PGwxg/TAAVY
	d5FVWB9WXWoySROXnGJsoRXbQ0LCLXTOnu1T2uThmMms3f4aRCK75itSGlOxXic4gg==
X-Gm-Gg: AR+sD11pzrL8iqmJjQMlBHEoNzJc/EAIH8fXccP/cLmv2HEQamxBvL0lIVhpQD/n2X/
	lcaEV2im3sdAP3wkgCSkrqq/aLB2XDAlBQgM7JgUsDvXqLczHoC9M0gx6Zqj7U7NeFagJXRAmJ2
	+FXP7iPJaMg8L7euDbsGy25VFIs+NuH1vwAOYYX+9BLnh3Ryrlxdm7Z0+gUNCEykmgLKgOBsc3v
	AAYcTeWUR02Xrx4waAE4GpFyO1UuJ9HWHByQxK8fo3G2F9ddHesr0k2+Ie4D/pCvHAHZitFVA4R
	3otSjf+2mNqVAJzccKvZmSHdLhjWvhYzhTYn8j5F3WiAd4yNaxhSx9boXdchlVRxNQ83MsksZZo
	bv7XbJ2+Ko6/2oZRNeIIwWvzkmr02j4Gk5Pl68n3bLYuoLs4FFpbtYkZDlJMCAbbjDNqDm+ih8i
	JS0Abt4o5Nat2or8AltWDwh1NAQgyCJT/oXURUMdoR+Pf7PxhBxkj5m14QbZuWJF98Y34YoV36C
	HEwfpIb5WSCTR9h8gDDrm9ayjL9oXoqQR66PpvYPokvh3v/RGuyqIy4e0YVnzcyVo6db7Av/KqE
	6pBzB1D/KXfurECZRR6C6da2fv8eTRsC0ZyHtw7PMq1aTvYvoz4hEg6GnT6uYZy3bT2krdzwo3X
	t6/dSZjLKsT+sKs1ETbmBWVVd92NAk3t3u8I9ZxgtWuJEHhTm3w9WRptXwvpm7O0O6yqvo0oPAH
	8uFYWACKwmJN90X9vJOJtFmGdd
X-Received: by 2002:a17:906:9c93:b0:c24:6687:bf6a with SMTP id a640c23a62f3a-c2492663ee3mr1794089366b.21.1787557373753;
        Mon, 24 Aug 2026 00:42:53 -0700 (PDT)
Received: from Desktop (p54affeee.dip0.t-ipconnect.de. [84.175.254.238])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249685ef7bsm1261549266b.52.2026.08.24.00.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 00:42:53 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH ath-next v2 3/9] wifi: ath11k: report the pending tx MSDU count in soc_dp_stats
Date: Mon, 24 Aug 2026 09:42:22 +0200
Message-ID: <20260824074228.2114579-4-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260824074228.2114579-1-julius@bairaktaris.de>
References: <20260824074228.2114579-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ar->dp.num_tx_pending counts the MSDUs the hardware has not completed
yet, and is used to wait for the transmit path to drain. It is never
shown.

soc_dp_stats can therefore say when the transmit path overflowed - TCL
ring full, misc transmit failures - and not how deep it is at this
instant. The bound those counters report against is the tx descriptor
idr, DP_TX_IDR_SIZE entries per ring, which is large enough that
occupancy rather than exhaustion is what characterises the path under
load.

Print it per radio, beside the failure counters it complements.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1
Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/debugfs.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/debugfs.c b/drivers/net/wireless/ath/ath11k/debugfs.c
index 70922612d3fb..9dc586b68136 100644
--- a/drivers/net/wireless/ath/ath11k/debugfs.c
+++ b/drivers/net/wireless/ath/ath11k/debugfs.c
@@ -714,6 +714,18 @@ static ssize_t ath11k_debugfs_dump_soc_dp_stats(struct file *file,
 			 "\nMisc Transmit Failures: %d\n",
 			 atomic_read(&soc_stats->tx_err.misc_fail));
 
+	/* What the hardware still owes a completion for. The counters above say
+	 * when the transmit path overflowed; none of them says how deep it is.
+	 */
+	len += scnprintf(buf + len, size - len, "\nPending Tx MSDUs:\n");
+	for (i = 0; i < ab->num_radios; i++) {
+		struct ath11k *ar = ab->pdevs[i].ar;
+
+		if (ar)
+			len += scnprintf(buf + len, size - len, "radio%d: %d\n",
+					 i, atomic_read(&ar->dp.num_tx_pending));
+	}
+
 	len += ath11k_debugfs_dump_soc_ring_bp_stats(ab, buf + len, size - len);
 
 	if (len > size)
-- 
2.53.0

