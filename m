Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8D91F91E3
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 22:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789080060; cv=none; b=ctVWWo5uqa3rOlRUKh/BujeIPRQhN5cm7E6Mopcu4Kc4WHuwaNUQH2AJ7ygSSe0SwoxiZFgr3AMOUYpYpY1uPoIjU1DBLSJqxyTq71PltlnT7tYRrBztcHYTNbZHyZw67+7WrGHiQX3c7Gfkc+Lh+q5yUHW6gZtjAyd41UiPTmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789080060; c=relaxed/simple;
	bh=r93eRd9OWbS4nHXU1mFaSd997OseLZ4lfRFJd1Ta4YQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PfC0plNPLY5UbciVpRQcktCnrSJhW4WeiSU4WGY2tzkj4WThv+pPUqLC0n8WwLB+oUk0Syo/7d5pA2Zqi+aRvr8ArycBdM4VYn9+KthtzwDDIS5BsBe72fqjvfTy2xICtFX8coPrI0U8lgAi+S6nIcH+2QglyLvx3+h489vGBpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GdZojuro; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GdZojuro"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-9377f717879so17448085a.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 15:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789080057; x=1789684857; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=e4FvO+R52vhSh1Vhlzg/VtVNHnWgOoy3sLOAYPmDuqc=;
        b=GdZojurox6swEG5OyvCDUbRlsiN36rO6yqsfyiSPKNmRZmtDT4wiM0nNZG2H3AoS/W
         QLl6XLI9hV4rISnPSxht1KhCpd9h7qktebKaiGagoF3bdSARCylf5rdBmxX9awTFxjiv
         g1lFtpqfMddrAzwMtfqWaPt0mwwbJsygAj/hYUIDjcZ30l0Y+cNvYoSf+FmEM31OIBZD
         2lIHV6Rj1npk1m3D/h6x3iI/LcBOwuL2uK9SaHxrLs9aqFSqhoF1PDYLYwJpRShWMq/6
         Fx7anYE15KWXOzVq7Wmk42hIIAIg1a5YzcrQG+6r8CZ/vLFN7WeftgFMikAQIc8gg8jW
         /B6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789080057; x=1789684857;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e4FvO+R52vhSh1Vhlzg/VtVNHnWgOoy3sLOAYPmDuqc=;
        b=AqcVVJMQP0oQGuilBcAiW2q8ldB2K50kNnQhy5NE7xJx4tSMbaCwpYVaNpc1Grbjbx
         pM02ObA0kYco078/kvegJYNTnd9mx4YxwTJ7GJYEtOj3BfcOVH/luiSYsENK4g+TWIW3
         WiBzcNT97n2DXVmi6K24+Hoa6nspuNou+BmsKaI8wGdebX6Qd+wSlTIBoC6cYyVTcNYY
         LgZjauXOBPrAg+1eiWQ/7m4csuT9DPS+l8O5e3NSSoGeay2mTfjrg1zdi7ZZdQBG2heZ
         fmkD/aBSLNNwNZLdGmwiipij+h3+zQPAUtUP/GiWIiR5EO/mtt0UqfCOzGJ1P+2XwvZc
         wDCg==
X-Gm-Message-State: AFuF++mJghJXHxqHOoiauNrjJAOakjG8fRnC7/uJhDYJwMrWpTp39crS
	sQWHWswan8/w4irhN2QAnMoiOWi8DHyZKPOaVKxqSdVg99pfbElXpLE=
X-Gm-Gg: AYBFou2NF+EQgfw9ylKhXVq6cEpBH5kkdQ9CTn3GKAI2RskV23wC+PivPsS1y7zRfQT
	Csau4/YD3THBQdC1q5e7YGR3RsO7MppUeQeT6pKc54fu1emJ39j3V/sAVYSH5dmcfMw757bUi19
	vrZdoVmNU/4eHkvyOeYVzQ23KldMaQv5qRGN0CFcJu+JBqBfdcaFCuJzWKauHsS9N8Bgtk2xjHl
	DLS4SAFaKI+k/PZa+L9tMued7+0wZsfq6OLk6ggX1aikdmlil05mdloRfnsl+4COxqRJe3Eba8X
	NqD465DPTcUAuTTi68r9VaY4G7YDeAFD0Kmr/filo08bfwCxCNiWqfcBdlI0dReJUk/7uMTWm5a
	L8vjnaZQ4ZE2C825EqganRUDleMWd5RzJp7or78P5KhqMSoMI7752znfNnOmrPEpn6dBAlsEE7C
	V48C336+FIX/Habx9iUw+kzTnm7Cz3fOlWunZQsTBtiuD6bd//io4Ds258FARX9vRqJyWGEKQkV
	jbsUUq+l5g2AyEyWEFPK9MLxE13YQmgMa3MpiFMe1Ft45M/7GIzCtTgqIwkMGPPjVgUUJ9CT1K7
	RjekT2o0YFA+NJLSQCXBX6IYIvAGxrzMUA==
X-Received: by 2002:a05:620a:4089:b0:939:c1d4:e2e1 with SMTP id af79cd13be357-939ea229368mr153601485a.25.1789080057494;
        Thu, 10 Sep 2026 15:40:57 -0700 (PDT)
Received: from localhost.localdomain ([104.39.73.78])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939ebda519bsm21300385a.26.2026.09.10.15.40.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 10 Sep 2026 15:40:56 -0700 (PDT)
From: Myeonghun Pak <mhun512@gmail.com>
To: jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org
Subject: [PATCH] wifi: ath11k: disable wake IRQ on AHB suspend failure
Date: Thu, 10 Sep 2026 18:40:48 -0400
Message-ID: <20260910224048.10294-1-mhun512@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ath11k_ahb_hif_suspend() enables the wake IRQ before sending the SMP2P
power-save-enter message. If qcom_smem_state_update_bits() fails, the
function returns without balancing enable_irq_wake(). The WoW suspend
error path does not call ath11k_ahb_hif_resume(), so its wake IRQ cleanup
does not undo this enable.

Disable the wake IRQ before returning the SMP2P error. Warn if disabling
it also fails, while preserving the original error code.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 69ccee619a38 ("wifi: ath11k: Add WoW support for WCN6750")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
---
 drivers/net/wireless/ath/ath11k/ahb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index ec5bf5c..3c9de95 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -742,6 +742,8 @@ static int ath11k_ahb_hif_suspend(struct ath11k_base *ab)
 					  ATH11K_AHB_SMP2P_SMEM_VALUE_MASK, value);
 	if (ret) {
 		ath11k_err(ab, "failed to send smp2p power save enter cmd :%d\n", ret);
+		if (disable_irq_wake(wake_irq))
+			ath11k_warn(ab, "failed to disable wakeup irq on suspend failure\n");
 		return ret;
 	}
 

base-commit: 08df884136f1c1197bab2a27814404fd329d9aac
-- 
2.50.1
