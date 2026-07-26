Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FAA53314C4
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 07:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785051744; cv=none; b=lqmHqmV8LlTZ0IfjxcpcqlPehK1ZIf1sCNuHOM6HFZlAyO5rFSO4NCkCpeP63haaIYDvj5SjDryHjrtd9uJzVFb5NbNcrLOHnwHVTaSBV+nXUPxcuNMZBpi8i2EFuxqWEDsMl3EftZ30B7lk1UBTnQ1C0q2M4kZ/lScNcuDDKfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785051744; c=relaxed/simple;
	bh=JjZyO5oG7jnswUKnc/u6gUqlXcLGsveOxrqAB41Mbls=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qxPS+n8sv65EDY5EiRt8MD//Titr0ldInGLBRwsXxispWtMDyWGmuiXGeL97lbgE+0RIXz7cNnwmB/p3usrJ5q+J+KjhYOtM/pP8JBFS2z5+YYUAbZ3dDIgbMmSjDesM8TbrAxTkqGJoqAFwwwHJh5zqr+ATuIm1rmUHIfNSBrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lf8nIsa1; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lf8nIsa1"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-381c51fde6bso1866589a91.2
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 00:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785051742; x=1785656542; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CY2KLezyn1y2H9gGbxPam1CcaZPI7+IKKHx3q/PaK/M=;
        b=Lf8nIsa1V8Ba3WGIH/ZT7Wmaey/QqQhd1c794sslfelpTGQiZ0xOvFvUqPlf2aqXjB
         5i17K5vXpHPDwNniqAQWci/xBQIEnmb0XD4SxH02gkL0r3npKtKgxjaTKShhW6DDFBB2
         ebsDKUd+m0kPabEZ1ksEHpwuF92CyN5ZoYyDbgBK9rfgfEfLdZc9/3DKjXwvjM94Ohv/
         Yu8gupquu6orjx6qrYdOt95t8G91kbPp2xMYiirXVqmhew/3AMrSXvHrFzuTiChTBUI7
         mr/KvhRLU2c4XUsj8sk7LQtpr+5+YGEOndEPunUziyIjK0vFajkdRfLanPtwHXUvsAFt
         ebfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785051742; x=1785656542;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CY2KLezyn1y2H9gGbxPam1CcaZPI7+IKKHx3q/PaK/M=;
        b=DFm5pF/mO0ejiIA+xpavVbbRWeWcKParM+8m16qbM86gVBoSYvr/qhE7TTc2N2ecoZ
         88/xHJ+uY2wT8IRBcx+8P0J2GsQgFffeA/Xw1nzGUNWRnusc1o8mixHyxQuGorEiW5Dm
         CUOdAugj7qR3ERnENfTyiRBHeLsHveC2RAOMUG+g31uP/6Ju2MHPxtn/YRnmONd9QKXQ
         hmpEVOYzXVeWTZg9gsv6350iLjmoFIFNs3jGq3QOmelzGq9ZaCzTvH6pcUAe7bxeDSUZ
         xVKNiZp2S8CahNCiXdJjoclqxmZTcRjSXqKQQlnAsraw4WeekoovzsrvWaQoL4C+cmh2
         C5Lg==
X-Forwarded-Encrypted: i=1; AHgh+Rq+ugRaOvuI7sJCUssSymxKKhRK6CMxIBr6ni2eWA61q5sfgikN44UoP5H63TeVMBTvnaGezPm4rGQ0YPvF4A==@vger.kernel.org
X-Gm-Message-State: AOJu0YzTFwh/+4EQPrNwmLbHRzwVb4fKtZnGtCt4Fc9ShMf9+C5j1kQg
	GGicmBK2YprTm6W+USPz/4Z9M4RZ7ibRfsM9YJGiCh0qbCS7yIrTLR14
X-Gm-Gg: AR+sD11LQUT2mVZcpgf9z2QRT2SO9rBuSnJpAfv76pmXv6z4eGBi49g806JeZEhafYV
	k2ZT53L9YSLzkMCSu9XEi7GVAAvQeXzyKCdglO/Xny9RSItKPMDgkKcXF+biAQrwsXGjkteM6hG
	Od8HgLoI8KXVZcrZumSMaNduHXbtDnyaqJHpMQr/NbpO69glO5tMFONhJbskC/DEBVWwnjC5PoU
	9BmaxekRcK2rBW8jKe7vjcUzm1vjT3pdFBLmh1Akm6pOdGhGD8E4HuhcYwoUtASGvVlF2/s5Qp+
	yLOXr1f03ExL8mq5ZdFzq1ncy7RcS4o7Zqsd/pji3pP5JpcjuxTNGM0kIZsv65k7kj2vKhh925g
	1PEkqmNW/iMfpbiGzok9dNk0lPSPmkFHMmZeMlxQeB5gC+uYyJaObyEQ3oViRIP/zoajxEHumym
	pEHaFcezYyhX7+ZhFm6l+CFgg=
X-Received: by 2002:a17:90b:3c07:b0:38e:3fdc:62e5 with SMTP id 98e67ed59e1d1-38f29535ce4mr4102549a91.19.1785051742449;
        Sun, 26 Jul 2026 00:42:22 -0700 (PDT)
Received: from localhost.localdomain ([115.110.225.242])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13d130cc5ebsm54655079c88.12.2026.07.26.00.42.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 00:42:22 -0700 (PDT)
From: Shitalkumar Gandhi <shital.gandhi45@gmail.com>
To: jeff.johnson@oss.qualcomm.com,
	loic.poulain@oss.qualcomm.com
Cc: jjohnson@kernel.org,
	k.eugene.e@gmail.com,
	wcn36xx@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shitalkumar Gandhi <shital.gandhi45@gmail.com>,
	Shitalkumar Gandhi <shitalkumar.gandhi@cambiumnetworks.com>
Subject: [PATCH ath-next v2] wifi: wcn36xx: validate HAL message length in rx callback
Date: Sun, 26 Jul 2026 13:12:02 +0530
Message-Id: <20260726074202.103956-1-shital.gandhi45@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shitalkumar Gandhi <shitalkumar.gandhi@cambiumnetworks.com>

wcn36xx_smd_rsp_process() dereferences msg_header->msg_type to dispatch
an incoming message before checking that the buffer is large enough to
hold a struct wcn36xx_hal_msg_header. The length is controlled by the
remote firmware and can be shorter than the header, causing an
out-of-bounds read.

Reject messages shorter than the header. Return 0 rather than an error
so the SMD transport still consumes the malformed packet, matching the
oversized-message handling later in the same function.

Fixes: 8e84c2582169 ("wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680 hardware")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Shitalkumar Gandhi <shitalkumar.gandhi@cambiumnetworks.com>
---
v2:
 - Trim the commit message and drop the incorrect statement that the
   individual response/indication handlers already validate their own
   lengths. They do not; those over-reads (wcn36xx_smd_join_rsp(),
   wcn36xx_smd_switch_channel_rsp(), wcn36xx_smd_get_stats(),
   wcn36xx_smd_gtk_offload_get_info_rsp(),
   wcn36xx_smd_process_ptt_msg_rsp()) will be addressed in separate
   patches.
 - Add Assisted-by tag per Documentation/process/coding-assistants.rst.

Link to v1: https://lore.kernel.org/linux-wireless/20260725185740.56658-1-shitalkumar.gandhi@cambiumnetworks.com/
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index c0b477345832..32dec45dbb50 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -3254,6 +3254,11 @@ int wcn36xx_smd_rsp_process(struct rpmsg_device *rpdev,
 	struct wcn36xx_hal_ind_msg *msg_ind;
 	wcn36xx_dbg_dump(WCN36XX_DBG_SMD_DUMP, "SMD <<< ", buf, len);
 
+	if (len < sizeof(*msg_header)) {
+		wcn36xx_warn("Corrupted HAL message: length %d\n", len);
+		return 0;
+	}
+
 	switch (msg_header->msg_type) {
 	case WCN36XX_HAL_START_RSP:
 	case WCN36XX_HAL_CONFIG_STA_RSP:

base-commit: 90883c513ca01e77c56b8d94be7de11420c1dacf
-- 
2.25.1

