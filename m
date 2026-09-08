Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8797E5476D1
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 13:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788875614; cv=none; b=nA1ammC75EnSYCWrWMnms9ebXjiFdCvEk62Qd7E8imrINuLUdPnGDtfzspAitxaF1A3HJ0jCSW47Ts92ZVT2QzAUali13nmZ19R64b53AlvXAopdMTNQX68o8850m8Hm8pnTXmRDmsgf/KkER/lt4dTGEIAb3w5oepZBpwhayWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788875614; c=relaxed/simple;
	bh=AMm5/0s+MwH5AZ/fwZK85cp5dRkmGH+8cbgH0A9qRT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gBOI38flAx1cQpRGB0e+pqRVcckgPJ1yyOyIkUiwq1G1n/tpjE1/gKRDeN7dJ2MOMpZKJ6DgWnqSSXiIl8Fh1keDv7LTDiNK3dd4o0hl8wz6Gibdq0v2ofLcx9uktQqOFCqpGfBibnolqWyFoqohrkafL+l/B9NMIH/rAnQYRBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=PxY8U2zR; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="PxY8U2zR"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f9c60d5so89809666b.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 06:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1788875603; x=1789480403; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R+9FqYSQ2L7Zu1nAHB7ZI+rj9iphBqw0F7t6xJ4R1Qs=;
        b=PxY8U2zRuW1e+6xuouy3XN6GaXVICPAS+HSnWZNnL4cvMV+pyFvr2GagE/hIAGbMdN
         P8YEgh5X9CqwgvkeiiuhLl5+w0ESqxOCp1r24SX5Jp/Ct6nYQUc0iWVaFSGcvnwR5AsZ
         LlDba6aNd6icKIgL4YEzzawTFWaWqvN1bPUBmp3gydul+tSukwm92JtHFopQJG2aidqm
         or+SZq5WlsqLvrVqJ4Mh69YYbe/epBrPCQTULq36CVGiRKoW828lBXCyycn22sTIUD64
         93frtwePj9CLBiA+9m76JczyhKYH4lVN8DAOKZUgpaK3lSgOwAeit9ggRnkLD9XnJlgq
         L6TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788875603; x=1789480403;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=R+9FqYSQ2L7Zu1nAHB7ZI+rj9iphBqw0F7t6xJ4R1Qs=;
        b=K9q6PAXIj4QB0ARNcBpRs+4+9HqhIKmOQCD7j3jzTirpb2t8j3EnuG50qQ6YaSITXH
         YWcP3MbRa/Frvf8ci8m7Y3Gr2SJI9cqR1Uxu5Auf36l+dD8+XIVRCcuelNm55Y5fax23
         A0yhOtKP0FgKJSUUNMgU9gbYbjgt+S6htjjHfy/FFY9KKoYR/VVEFlyRFRhfF3xpZmsZ
         J9/TtAC7fo8d0vjKsqFcqN3R+lAxvQJHw1SB5/1i7PHMypO9QLAyV/44MWByZ+vwnZ4j
         WM67sMVy7RBhsMBVk5ZLKO4oKjusLnWGeglpl3AQK6AGO553DQZvvrJnO4i3WMrtWKt1
         GYRw==
X-Gm-Message-State: AFuF++nq+mIBqmxHXVlMD6ZfRFoRYCWRm7ogBGgx47EtjncyMlWaU+p9
	vlK+jrZKx723py3+HAbJvX5t45L5dxYz0VyQEkthYMYTdU8KQEMwwYQVaRGyjNhCSw==
X-Gm-Gg: AYBFou3MoFeVx/cC+uINMQ3q1XC0p5h97INxDmOqhCtPwm+wKPQprFshpOY3byhPrwj
	XzCLyosGdz4Cfj/sar7kIKzmBZqBP/35mlIMoYqtFWB/reyD6DCM42AonRy/z2PusRcan4E9Yr6
	ETVdZjukARZBY+Qy/dR7cKRLSkl4+EtkJiwh216WTcNDbfSR3w2aAUEwZ2cIymLq8sFaX0n7O4y
	UycdErjJL0PsnR7goN2KSukwvYmAmG3MRPqIYN381XNNSE0V2rawVZTrv2D5zDKRs5Hs2CKjgEC
	cISWlzrvVgw/Y/e1RwfS27i4A+z/lnwAWZFJGesxYde2fn740vRcwr6na4AYwidsGJaQ4RbhbkO
	L+aRlAYbYhLlaQivIvAwZXlPMIGP5FAwer8KJU2ln4Itw//PNj44xBcLT3o6nAu61++cu6TEqWC
	EKv3ccRWCYIvhp7mPTRdx3Cr3FZEUiQL6nQY7cAG7sYhOPoI3XBx3afuBbA4bU3u3S1sKKWTtCA
	f6qgo6HuhP6lS71b8SfZZfEkncOtjjQgC7PZvG9pQ3/tq7T/S9cc7xhUm7J0wX6pIIf1RsN6eHw
	tfm78nqVw1LxudQruFoOQ7n9MPkcAAiZUWch9IBLnyqQw7R+4JscO/w+PaohgUlftmILSiUwthe
	b0ImfGTjETcwHt6brCw9xotJJptLQj1Ah4og9vHW90q+kRhOs3O9AcKQBKrpIY2lu06A2bfDlzj
	tiTn7iE24fHOfK
X-Received: by 2002:a17:907:930c:b0:c25:f7db:4bee with SMTP id a640c23a62f3a-c29044f2780mr326114266b.20.1788875602673;
        Tue, 08 Sep 2026 06:53:22 -0700 (PDT)
Received: from Desktop (pd951346e.dip0.t-ipconnect.de. [217.81.52.110])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d5cdf7asm647602666b.58.2026.09.08.06.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 06:53:22 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	toke@toke.dk,
	sven@narfation.org,
	quic_vthiagar@quicinc.com,
	john@phrozen.org
Subject: [PATCH ath-next v4 3/9] wifi: ath11k: report the pending tx MSDU count in soc_dp_stats
Date: Tue,  8 Sep 2026 15:53:12 +0200
Message-ID: <20260908135319.754140-4-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260908135319.754140-1-julius@bairaktaris.de>
References: <20260908135319.754140-1-julius@bairaktaris.de>
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

soc_dp_stats can therefore say when the transmit path overflowed - TCL ring
full, misc transmit failures - and not how deep it is at this instant. The
count added here is bounded by the tx descriptor idr, one entry short of
DP_TX_IDR_SIZE per ring, which is large enough that occupancy rather than
exhaustion is what characterises the path under load.

Print it per radio, beside the failure counters it complements.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/debugfs.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/debugfs.c b/drivers/net/wireless/ath/ath11k/debugfs.c
index 70922612d3fb..ffe1f466aefb 100644
--- a/drivers/net/wireless/ath/ath11k/debugfs.c
+++ b/drivers/net/wireless/ath/ath11k/debugfs.c
@@ -714,6 +714,16 @@ static ssize_t ath11k_debugfs_dump_soc_dp_stats(struct file *file,
 			 "\nMisc Transmit Failures: %d\n",
 			 atomic_read(&soc_stats->tx_err.misc_fail));
 
+	/* Descriptors the hardware has not completed. */
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

