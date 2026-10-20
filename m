Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792525829;
	b=B1RB8SIZ6quSO8p+huvNHNLnS74RuEGAzrvq4IW06v9VzJnQoHb9CPud8QrwTkodvc/7
	 cY5pH1SFdTvJMsPcHn538l0bXqWuAf/kji/DCj42iVHXLTUujT+kWb9UJvh8AfH7955Ld
	 7YCdDsg3TSjdkniCLWVvmUngkgLSMc9kLYZdX19pbl3FT56dIqYkFs76AjfwJOatCKOYn
	 FfUpjEoLOzz7HsGpKIOvmQN6BvBIfapryXjXN7PN4LjBhsRiSLmVwqJylhICxUHiFPCqY
	 Fn1yV8h33cwpvqrSSuq132sWg3QpGsGMKMY/blJefCv+PGIYy9jIQc4ZcTeILmy2rCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792525829;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hPa4PG254yePdehpmJWqML5hqKXw+sws5WB7y+lwM98=;
	b=gasjgl8EFDWKFv9DQ0z3UcMk7w98asUziuPjEZvYaMB4/c7tdMacZbS3412FpnBB0j1i
	 bUfhtf8ssYIoLBloD5lIzBlxv9z0fFFE0/hSGa618TUjo2sN3JujSJkIPXJynn3Ssfl+1
	 ClN4icljnD1Tg+Pii0BP/ih4NOmk6jZetVHaIb07jkE1eEssO2K/PdzDNx2TCu/U1Wv7P
	 lV9PAbO1hI3/n1bcpfsQqgSdBdc1GJTwKtZoqiLpV2Sy6wb/YXcDlN+WKJD79qXJ0J42a
	 IopzqOX32/sYqZEY2jFGD2eaoAxf3HOc62ff5eD1tnPUwB1wEaRdFZ36NxIPLPMa+ZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=NuIBbCyO;
	arc=none smtp.remote-ip=209.85.167.51
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B15606A319
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 19:50:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7B15606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=NuIBbCyO
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5bccb867d6fso3324668e87.0
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 12:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792525827; x=1793130627; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hPa4PG254yePdehpmJWqML5hqKXw+sws5WB7y+lwM98=;
        b=NuIBbCyOHLjMgBRgN0U2pccaR1TZLAsQhr1eI7b9dpYjk5TlNnN94DdOAXN19YkR7D
         FAf8nTaWqBcQbkylIxVI5KyXHkXknkDYt7DbtIn1A08do1AD1oVysJRCpy81PHz37BEm
         x014kEN3iJ04lFyi8hElEoVGeEPXX/8cBi5LcFdm5PQXylCE54Y2pr0yKGA4R6VQAHdi
         /HLYIHUAF/4tIGEKKW05bLQEnDiGo1snPRRas0w4qeATPZuUYn9RTZssEOckbbc6bnQ0
         pDMMs1XJUDvJJslhQxV2fG2OAscyUOSOnaNVGwJjLjWHyWx9fVUSKYloowuqwMfn+P9z
         ydRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792525827; x=1793130627;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hPa4PG254yePdehpmJWqML5hqKXw+sws5WB7y+lwM98=;
        b=ai+qyVvJ6MsVHeFoSxjYTHbYiu5MGQSbF/BKSkdFOQcgdZErYK4jv2XG1NKUq2ia+h
         C9lMh92iWYykpAwi9KngsmBioJxBYQbsbHXcFfJKSHDgXBbIKVTz+/zuCvHxJL5xA5TB
         FKnHqgFdkYmi806VCRAuRwOXlEaWcFEU7W8dk8cNcn1Fjq6vCuZVFdt/kWWsQnvHsxgz
         Ryo2qloJfXMQf+BHV9wFxKK1UQS5Br8XFjXb2A/yV4bp1cr4zSPlNQBWnkmUbgaIdFtg
         iFOrOV8+/MTrSxLgiQF0KetdpXPxU+64uH3bRv/a+J3DywPNNXyqdlsIqLzLa8bfngPn
         DRmg==
X-Forwarded-Encrypted: i=1; AKwUvByGFmM5Csimf787hddyPTLpSv/P+C1c1aGJhbMuEK95LPQyf17gLyCdKDFKBrkAT49yxD2Cc84f11FgpPOZZA==@vger.kernel.org
X-Gm-Message-State: AFq9FYLzr05XkpgcHB9kVujGmzBtvTfhrr2o9ire7DqgHcNPXQUKdH3A
	piK4SYm0QUev7oKg/vsO2+lChsyzuYFqP1dd09Fi1XboU/R6GsZOTqKy
X-Gm-Gg: AYBFou398DM4shhyxNdsGbVYAKGqS6/EYER4XJwo75iHocmK9ZgKjykRMpeLEhpI5hc
	ZCMk6ePUHVA5qEafRytFdpMtuYe/ZJ6wrGEQMDiQwZycLCjv9ThpyfExF7svywOUNnMJ/2U+Chk
	54JIUQBngksTZAB+V0QerXv+ADODi0i/PHH6YlM0Zp7cXvmbmiAnLhNqSF1ioibc7+SQtfipuox
	Lmv2TN1P4h1yiwE7cx84uNFZ/Hy84cOPHl1J2WQ+Kpeo7yhceLajmd2FaFQrazahkWcsK9CYHUk
	R9tt8L0zd+KYQ0+Q/EcORDkJo3M8LyISTSt21Zki4nzBItCAZPUZFIjkJ+iYttBS9/mxcFptM11
	cquaeiaRifTEm53UU6ibQ1JggA3PKYsy6IoIKXreg+rG5e19FhLcKravskUk/H2hB0WE7vSdTOq
	+qn8iDyFIAVe5oBMB94h+Os3hOu/E2vaBJDutBCLwfKjXjBSogfbJWKO8U1v9DzIva6jiQO1Ih2
	OWVF0kfIIPfFLNHjBMk9ZBxIX9trtw3yOqN1Lw8AENyS56UUACi0YcNpSVdy+5zBq6uzNZE2LUn
	C9Mi+SOC+l482YU4v3DvLVn3u3hyjdgWWddrjLo4S3WChwqjskaXocGUGWvQf9hzdi2nRwqBo2D
	jMw==
X-Received: by 2002:a05:6512:3a8a:b0:5b8:bc5e:b57f with SMTP id 2adb3069b0e04-5bfa1c1fb76mr4379e87.55.1792525826617;
        Tue, 20 Oct 2026 12:50:26 -0700 (PDT)
Received: from kompukter-Systems ([83.142.235.16])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bfa11a8caesm75345e87.5.2026.10.20.12.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 12:50:26 -0700 (PDT)
From: Andrey Derkach <gabin278@gmail.com>
To: David Heidelberg <david@ixit.cz>
Cc: Jeff Johnson <jjohnson@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Michal Kazior <michal.kazior@tieto.com>,
	Richard Acayan <mailingradian@gmail.com>,
	linux-wireless@vger.kernel.org,
	ath10k@lists.infradead.org,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	phone-devel@vger.kernel.org
Subject: Re: [PATCH v4] wifi: ath10k: make in-order rx amsdu buffers persistent
Date: Tue, 20 Oct 2026 22:50:20 +0300
Message-ID: <20261020195021.1133728-1-gabin278@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261020-ath10k-a-msdu-v4-1-670b69d39059@ixit.cz>
References: <20261020-ath10k-a-msdu-v4-1-670b69d39059@ixit.cz>
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

On Tue, 20 Oct 2026 20:52:07 +0200, David Heidelberg wrote:
> The WCN3990 firmware may split an A-MSDU across multiple HTT "in-order"
> indications. Mainline drops these ("failed to extract amsdu: -11",
> rx_confused, recovery), collapsing throughput under load on affected
> devices. Stash the MSDUs of an incomplete MPDU in the driver state so
> it can be completed by the next indication instead of being dropped.

Tested on a Lenovo S5 Pro (SDM636) with a 7.2.3-based tree, on top of
"wifi: ath10k: trigger hardware recovery upon rx failures", replacing
the older out-of-tree version of this patch we carried before.

During TCP downloads the firmware split an A-MSDU across two in-order
indications (once in about 39,000 indications so far, counted with
kprobes on the stash and resume paths). The patch stashed the MSDUs and
the next indication completed the MPDU, with no warning and no
recovery. Throughput is the same as with the old version, about
60 Mbit/s here.

Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.1.0.1.c2-00455-QCAHLSWMTPLZ-1

Tested-by: Andrey Derkach <gabin278@gmail.com>
