Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793975106;
	b=DGyoqwJs0caAcJQVRM0BP53GJvNEt9jVo3M0FLqMSWAejzihadkJacUsZt/m6FFzhjJT
	 KsQMmlZIFkD8c2mq/7fe+MGPVyCXknb5xtEmGkOugvLTdTbceRiDY+9cwvLRa3xprDn2O
	 mHYlmcDcm9r0JEn9V5QqSdR4PGbKy+mJBKk/+ReQM3Qz7EVoZgRvqZoQcUVTDzhg3ylfy
	 zW2g4fXulU4d27JmYbt8B7ygRR6wGxYqHyiQRbJT7/I1a1TiB/nlicTsA+UrsL0f1w1MJ
	 MdEX0oPfB2do0h/qXfn3QJFZAHr8C+WNDKINVpOq+Lmcb+igHC2xBZkmq+vkGBbsdrg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793975106;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=1rAjoe/OmKd2MpDi3ESTZf1fGH1ZDtBlky8qyDD7VKo=;
	b=uAGlp88CBEMZRvD/gN/ATSQAukjhrnLaZQGZZ9izNvVMMYvYd7c9sMLoLEaVGv15tz3e
	 HyTMG02+fjGpFepw1CSYM1JLGdTsssgdb081ehHR0Y/v7GcTmW+id9lX7BJ+IYLnurpe1
	 z6acPE7zVDYAwahtIHYcb+veV4up0lUi8BgHwuuPqSp/HuxOg/Zc3JBtOkk9I18UvWsyh
	 TyPwkqagozdT3xn4At59EI3Y7hPvZkhwQW5fhxXToW3GJ2jGCbw5gwadRQia+K4VcMxKU
	 73MThtTOcI4XCSL7QfkohCs8JAgtsNpQr7wrufN9Dn22EBgouT65mSgEWo19hS3COIw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g03C+YfQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4863D606D83D;
	Fri,  6 Nov 2026 14:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g03C+YfQ
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793975105;
	b=0GZYaxuubkzn10Y65exUiD6wwltFDWl2yPCrBiwml0AMCw4F2d23j+vTxq02Nk+2wX3o
	 E75g1VGVOf6CwTatGSO9QPS4/nutgoqplVFo/EwYv8b5W7iDZSKqDAPoTw1xms96gzHex
	 VyIVACZszaCBCyQ3lfWo5C0MTTPGfdM2cHf8Wdf+GvkGLeXLh1KKCvCWDJSoks+sECXAK
	 UGEGeVMoi6tBg42PvWSgbXi0WO8svBENezCbsFHDCrN5U/FCrNYZmt9MSV7WlCg7k8eai
	 t4/44+joNu+Uy/c8r6PiZzpSmVCZZmZxd1kI27R18p6rpPIjid5v5kKQPPwGS606HkQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793975105;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=1rAjoe/OmKd2MpDi3ESTZf1fGH1ZDtBlky8qyDD7VKo=;
	b=fmqKgV7qWhUiNtX7JPs6hHWAo5kNPbjSUJAQkGH1bzyTp/zeXquENoJtTh3+eJhG9YSv
	 jHvYqdYcvjf3iro6VSB/+TxjTVPdeKEZA5S7GL+bKdBGO+EWc5M3ab8RaeZC1EpFmZP9X
	 1A2vGdpwqDFoVK0Ah7alV2cHZ9W68Ewtur8t+4eDPLz5cotwTJdaK6YBlRSZiILpEGq3X
	 1Y9guPxsROK3Mw/oiSKsaYnE6YvgYtkr3jHa3r9LBeSyB8rtfY0AALnfiUkTxYNmU2qKy
	 XMN6xKMz7YW4EX6/WIE6FMbgeyfedobTE1eBZQLh8rJLlJYmFT0Qsa1tHqhhxU83cyg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 823B11F0089F;
	Fri,  6 Nov 2026 14:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793975105;
	bh=1rAjoe/OmKd2MpDi3ESTZf1fGH1ZDtBlky8qyDD7VKo=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=g03C+YfQ2wDJCeuAcighxcNFuv6QMvWT1qY/MgPgioxoIFwBvJc+5ly5gjp9OJz/f
	 a2hwrCCJ2S4Icnud9GSrGodkdqpXprZn4OWvlayxk0du36Ex+zL6cmu7vii3BbHXA7
	 Cx3REI6Lxff/vtQ4OvtD3PCqRcWHHN75BI/IqBD7iomptQlTGGWr2thi57MbnB2IOr
	 okWU1wOpw4TmLjQKmz0Yw4ZGB/vw3Mp4icaKPNIRkkAxxtcRrJT1XuXC7QnM8ShQX6
	 EwgQnBlsVgv69ZOarLtVPiVC/XN5PXq+ZGo+CM690+Ga2BAM9pdsN2Qeg6iPyRSwPr
	 E8wE2u8PYE1xA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 160A845D87;
	Fri,  6 Nov 2026 14:25:04 +0000 (UTC)
From: Christopher Griffin via B4 Relay <devnull+christophergriffin05.gmail.com@kernel.org>
Date: Fri, 06 Nov 2026 08:25:04 -0600
Subject: [PATCH] wifi: ath11k: print each user's sounding counts in
 htt_stats
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-ath11k-sounding-stats-per-user-v1-1-6aa8e62fddf7@gmail.com>
X-B4-Tracking: v=1; b=H4sIAD/j7WoC/yXNwQrCMAyA4VcZORtYhk7nq8gOaRu3KHSjaUUYe
 3erHv/L929gklQMrs0GSV5qusQadGjAzxwnQQ21oWu7nqjtkfNM9ERbSgwaJ7TM2XCVhKVSOBz
 DwN5d3PnEUJE1yV3fv8Ft/LcV9xCfvyrs+weElegYggAAAA==
X-Change-ID: 20261106-ath11k-sounding-stats-per-user-94d9acb8b75a
To: Jeff Johnson <jjohnson@kernel.org>, Kalle Valo <kvalo@kernel.org>, 
 Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, 
 linux-kernel@vger.kernel.org, Jeff Johnson <jeff.johnson@oss.qualcomm.com>, 
 Christopher Griffin <christophergriffin05@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793975103; l=3065;
 i=christophergriffin05@gmail.com; s=20261024; h=from:subject:message-id;
 bh=c89X/CZkTuy4umNZacZz4q0MYqGlGh/C+IYiRrx7/hI=;
 b=1L3ijR4PS3qnP2Nje9ciC8eMBRgDHYfAjTdV7FHasLRnzFQGgYENXqb2aUTOUzHwXE7yDpHsI
 sYQfftSKB9jBFp3wixheBQYWu1Rf1TL0D4Y/y4DyF9tM6+Cp4Q1/U6I
X-Developer-Key: i=christophergriffin05@gmail.com; a=ed25519;
 pk=oa9tkTNpiGoFWdGvpDHXLSobApmsh9BfrJRJrRJAvWA=
X-Endpoint-Received: by B4 Relay for
 christophergriffin05@gmail.com/20261024 with auth_id=1309
X-Original-From: Christopher Griffin <christophergriffin05@gmail.com>
Reply-To: christophergriffin05@gmail.com
Content-Transfer-Encoding: 7bit

From: Christopher Griffin <christophergriffin05@gmail.com>

The TX sounding stats of htt_stats print a "Sounding User" line for
each of the 4 (11ac) or 8 (11ax) users, but every line shows
sounding[0] to sounding[3], the 20/40/80/160 MHz counts of user 0. The
array holds the counts of all users, at sounding[user * max_bw + bw]
as the comment in struct htt_tx_sounding_stats_tlv says, and ath12k
prints it that way.

Print each user's own counts. On an IPQ8074 AP that sounded one HE
client at 40 MHz (392 SU CBF), all 8 lines showed 40 MHz: 404 before;
after, user 0 shows 404 and users 1 to 7 show 0.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Christopher Griffin <christophergriffin05@gmail.com>
---
Found on an Arista C-360 (IPQ8074) while checking that beamforming
sounding ran after enabling SU beamforming: every "Sounding User" line
of htt_stats type 22 showed the same counts.
---
 drivers/net/wireless/ath/ath11k/debugfs_htt_stats.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/debugfs_htt_stats.c b/drivers/net/wireless/ath/ath11k/debugfs_htt_stats.c
index 731f3ca867111..5ddc1ff8492f6 100644
--- a/drivers/net/wireless/ath/ath11k/debugfs_htt_stats.c
+++ b/drivers/net/wireless/ath/ath11k/debugfs_htt_stats.c
@@ -1235,13 +1235,12 @@ static inline void htt_print_tx_sounding_stats_tlv(const void *tag_buf,
 				 cbf_160[HTT_EXPLICIT_TXBF_MU_RBO_STEER_STATS]);
 
 		for (i = 0; i < HTT_TX_PDEV_STATS_NUM_AC_MUMIMO_USER_STATS; i++) {
+			const u32 *snd = htt_stats_buf->sounding +
+					 i * HTT_TX_PDEV_STATS_NUM_BW_COUNTERS;
+
 			len += scnprintf(buf + len, buf_len - len,
 					 "Sounding User %u = 20MHz: %u, 40MHz : %u, 80MHz: %u, 160MHz: %u\n",
-					 i,
-					 htt_stats_buf->sounding[0],
-					 htt_stats_buf->sounding[1],
-					 htt_stats_buf->sounding[2],
-					 htt_stats_buf->sounding[3]);
+					 i, snd[0], snd[1], snd[2], snd[3]);
 		}
 	} else if (htt_stats_buf->tx_sounding_mode == HTT_TX_AX_SOUNDING_MODE) {
 		len += scnprintf(buf + len, buf_len - len,
@@ -1276,13 +1275,12 @@ static inline void htt_print_tx_sounding_stats_tlv(const void *tag_buf,
 				 cbf_160[HTT_EXPLICIT_TXBF_MU_RBO_STEER_STATS]);
 
 		for (i = 0; i < HTT_TX_PDEV_STATS_NUM_AX_MUMIMO_USER_STATS; i++) {
+			const u32 *snd = htt_stats_buf->sounding +
+					 i * HTT_TX_PDEV_STATS_NUM_BW_COUNTERS;
+
 			len += scnprintf(buf + len, buf_len - len,
 					 "Sounding User %u = 20MHz: %u, 40MHz : %u, 80MHz: %u, 160MHz: %u\n",
-					 i,
-					 htt_stats_buf->sounding[0],
-					 htt_stats_buf->sounding[1],
-					 htt_stats_buf->sounding[2],
-					 htt_stats_buf->sounding[3]);
+					 i, snd[0], snd[1], snd[2], snd[3]);
 		}
 	}
 

---
base-commit: 5c8eab13e391aaabd5a1ad58f3ee4bb10ce7573e
change-id: 20261106-ath11k-sounding-stats-per-user-94d9acb8b75a

Best regards,
--  
Christopher Griffin <christophergriffin05@gmail.com>


