Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A35376464
	for <linux-wireless@vger.kernel.org>; Sun, 15 Mar 2026 17:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773595519; cv=none; b=u1ADfFck1p4WI5f+SMoySDoGInpjfIFwX9ztZ9c+jyJxTxXah5NhnibGDAkLU3SpbJ4O/URlTHWX3as1rHXk4ZYmc3T6zhz1eHoqoNdNQ+MCNvcKPyb2TABEN+1krIFmAifaEO75Zufw9VkvtGOZbz76UhuqX27LFdz+SoYuy40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773595519; c=relaxed/simple;
	bh=xR1aQtJyjOGsb3F8bKi8GxD9ZWQvMlCBKAMwTQealv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YNdakRhuLtcEAeEbARP7xP5kscXDle2mqT1AZClif6SGt1sEs32fbO0eNh7iw+shLPQwLjNcwP5XMauWQO10AuLNkaDb+DnXHAe+3tTS3PYceBPwihBBsdsPUutVJFHmLDGRrk6X+W1+g/t47aNUT1ksqlbOCRQfxBpan+PS+24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DrTq3SzD; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DrTq3SzD"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-439bc14dcf4so3458085f8f.1
        for <linux-wireless@vger.kernel.org>; Sun, 15 Mar 2026 10:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773595516; x=1774200316; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2eNrBLnJJHbmPI7WkNJ6vq9A1HMj64DfR2iaRW7E89k=;
        b=DrTq3SzDwgDX0a37RPo6o/lql3oPGAHO2S+yv8kxsp3a6YtYN75Qt4fbVaKpwslDg7
         XGsRTLLBEDbauK8VtRwI19GKKIXr7AEqg0rH0xGIrvLQlgeoH9An9p4PPWi/+1E+NW2w
         NEeBbitW+XIQYxmMZXuZVaJHfZpqwlGf5ug5hWJ205vFrXLIj/SzNOTwIbvYE3z7jccj
         6X45KrVmz9wR1it9QgWo0tzDreXyPaiTcxwYwyUVNbZvs5VhRLcbXLk22emHCdCv4QeB
         s96r9tNhj9S0pMTsijrsq6ZvkTAukUjV5L5R6PLDOSCek9THJr/L2hRqJdyhg8CPwrGB
         80ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773595516; x=1774200316;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2eNrBLnJJHbmPI7WkNJ6vq9A1HMj64DfR2iaRW7E89k=;
        b=LdXIGfHKhovITe/qH7Wy2vO5UYyG/DwpkghIj4xeAY+eb0qyyR0so+5wlhlDew6RlT
         5apkUptWYWwQ9rHP7QQ6+SViDRrWu6MPYgeE7K3OqdtEdN9i+pM670gWT2dmufulMb7C
         tTBtyIyLM5R3S1LS1/2LlSML3nCo2OvC2uZdimO95LQomtfASpLkZOHw/u+JucjSUv3v
         EUgtDedv7+jriEcchKuyxQNVs411oA45VBdTXhn8395XPfEavAFePAalmFcygVnLu9Qu
         FY29v4d1QHNidNA/yOW24WK83PcE1KkQDVtFjg313pxCgdMSpSbSSu1FlSyggZ1GcGR2
         wOZw==
X-Forwarded-Encrypted: i=1; AJvYcCX/s2oLKYeQWO3iUFfz4MVbImhcIP3gr4/7VQaGnPbuwuuFEycmiFN4atjkwX6J+l0fsdq5iiQiWB/LeKcBHA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyo4HxqajBfHIkyar79FR0WJPmydAZo+B03r3FmU8SBbgUbuEBk
	k4uDeTS+3rhT7/fSrGaBbP5/nf4HY4zHGrBLx0OIUuw6kldvqa8qXhCC
X-Gm-Gg: ATEYQzyNq2k8H7hF5G2OOGmMxzbeE0MKd7KuH+VJjDSCWgiwWIBAzUB/eO1CjBAaJWK
	Wx/p/n4CMbQT0Q6hW39afZwX6Ki0zfmfHWv9S0ubQwb+fJYz1PVaNUEvB3uB8xYKm7RHEEFsmNX
	m4WmuPBPq9Nk4TBw/FaJszHqnHLod6fvWC6Gw9Jtz0iiQr2Kf49j5Xulygl5fobCnTG8LhTAoKm
	TbzJDtfgFGHbQGm34qhHv+84e8anvTNyxlGajWZrqYchjFCtiul3nGIkZ3tIbW2B4S2TQ5G4tqJ
	Jrv5aWT2VCxQ0ao5LQsnZ2yZe4bhdy3/iAuGq7CvjKZiZuaBxDhKrjZWl+V12pOxSunn0EW4O/y
	GJBM55uhg0QVQGLQW58peBKUrbMTSdJ6KzO9jAJo1pHuaj2oxmazfv/Xv1njeKOTPf9rm3lFtDV
	YKq4BuYEyMrhqQfUhP6YMBB6y6koKs2QhMY7Y=
X-Received: by 2002:a05:600c:8b28:b0:485:3c11:de84 with SMTP id 5b1f17b1804b1-48555b47ac7mr165571005e9.14.1773595515543;
        Sun, 15 Mar 2026 10:25:15 -0700 (PDT)
Received: from debian.lan ([171.22.84.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48541aa73easm457168325e9.3.2026.03.15.10.25.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2026 10:25:15 -0700 (PDT)
From: =?UTF-8?q?Adri=C3=A1n=20Garc=C3=ADa=20Casado?= <adriangarciacasado42@gmail.com>
To: Ulf Hansson <ulf.hansson@linaro.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Boqun Feng <boqun@kernel.org>,
	linux-mmc@vger.kernel.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Adri=C3=A1n=20Garc=C3=ADa=20Casado?= <adriangarciacasado42@gmail.com>,
	Adrian Garcia Cicuelo <adriangarciacicuelo@gmail.com>
Subject: [PATCH v2 1/3] wifi: iwlwifi: pcie: optimize MSI-X interrupt affinity
Date: Sun, 15 Mar 2026 18:25:05 +0100
Message-ID: <20260315172507.270480-2-adriangarciacasado42@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260315172507.270480-1-adriangarciacasado42@gmail.com>
References: <20260315172507.270480-1-adriangarciacasado42@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement a balanced RSS queue distribution by skipping CPU0 for
high-rate MSI-X interrupts when multiple CPUs are online. This reduces
contention with system housekeeping tasks on the boot core and improves
overall throughput.

Signed-off-by: Adrian Garcia Cicuelo <adriangarciacicuelo@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
index 4560d92d7..87149f29e 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
@@ -1683,7 +1683,17 @@ static void iwl_pcie_irq_set_affinity(struct iwl_trans *trans,
 		 * Get the cpu prior to the place to search
 		 * (i.e. return will be > i - 1).
 		 */
+		/*
+		 * Balanced distribution: skip CPU0 for high-rate RSS queues
+		 * to avoid contention with system housekeeping.
+		 */
 		cpu = cpumask_next(i - offset, cpu_online_mask);
+		if (cpu >= nr_cpu_ids)
+			cpu = cpumask_first(cpu_online_mask);
+
+		if (cpu == 0 && num_online_cpus() > 1)
+			cpu = cpumask_next(0, cpu_online_mask);
+
 		cpumask_set_cpu(cpu, &trans_pcie->affinity_mask[i]);
 		ret = irq_set_affinity_hint(trans_pcie->msix_entries[i].vector,
 					    &trans_pcie->affinity_mask[i]);
-- 
2.47.3

