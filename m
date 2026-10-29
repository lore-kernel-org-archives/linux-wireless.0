Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793281717;
	b=pFHbz/Bc0IrKWyU1/CG6Ym4y0u2F64u8g/sJcr6sLkdBUsyjVbBQKMw7jUlQ2yTq1fBN
	 iP1Gi6kgccC1qLNipE0qxHY1oLFVNu1Wj8cOV38J5zBvcClVD727JVIFrE6AjKz0UaOWl
	 Kd257J3zobCXkcW6naWapxW/2rWGK6OqRp4HvTNPjUZmWhtLnIMsIOktlmtr7fzCDZaBq
	 yMQIfb18cnSaH1Qn8mne/jf8ShLMIxZK796gHEG9QopdA9wroXd7+fXc7ewk88KJmODmZ
	 df6837WUWUfbrH7ETLjK5rVL/XYkcaIvRfmiGgmSjND2SPQ1DI3BmeN2VRXClbEU7LQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793281717;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=lTNzjj5RXp4oZpl4oAxMzOJeDQHpmOcQuGYre6iPlX8=;
	b=TlpkSrhjYmdTPjDe+D33RLnIlx8WkkjeUt5NUB3l69UlWbyev9b/9y1WtmDkFmaumirc
	 95gm67EoJ7MwLjqomOJLqTnko4Ou0JXc5UAaOofm0hKiGi9muNJIb8YJyZjCidc9S3XX0
	 qRx0bCH9Q25/BOBLDWFJ1Si0MqfjaYPkjnAZud3WyeoDwiuNDTSpZVW7zbs6lQ9pjjaaE
	 C4tmJ+9I5wQcETdy/IP6694fSSGlWFxXHGpXbIAUDrdJqeO4HIbkHnij7HB2vfGyP5foT
	 Bu4O1cNwQhRYPgPmFWI+faIKWBKP4cyFdeNu/F3Ke8x5CfpvpGoyJMrKTs8JjQnUD/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XHU10XTY;
	arc=none smtp.remote-ip=209.85.210.180
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B71660A2605
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 13:48:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B71660A2605
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XHU10XTY
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8a070755c8cso1207348b3a.0
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 06:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793281717; x=1793886517; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lTNzjj5RXp4oZpl4oAxMzOJeDQHpmOcQuGYre6iPlX8=;
        b=XHU10XTYOELX7RDqGgN+sEsm81rhvRClEAGzhxP6NgcUjO91e0vUXDaAEhrTSdHVbC
         QAahsvwFDV0Ga/bWysK9toNAzPv+05T5MNFinUS1pRsEXLu9UH0/x7ITjFVSSuHhzsS4
         RIjhCu4jACBALzT5iaBXfbC+vpUL45V9ahl4VeoRPRHZTywM+xzM7+mUkTt+3FpNeuBz
         tvkEC5t3Wyg4cQB53HVGzMjgDy1CGUSEZvDXWOOfmHqnpqwX1/nuJ5VQHed/5AZndNOG
         DQW1iaOkeEJ79/c4eLi/QIdXN9owq2FvJ92BT7i3b1njuM9jZik2zwrIzPyF/TxMkcDo
         NULQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793281717; x=1793886517;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lTNzjj5RXp4oZpl4oAxMzOJeDQHpmOcQuGYre6iPlX8=;
        b=TRJRgljk0ixgRKJBG5+So5HbV9tgHvb0RPLOEIKjTll2kiiKTS+/0BuaDznrulngs3
         BRsbLwmBEDttJNTcqhokd045ZeIp8j9RYCIVaz3T7FcEaRSeEdfOcRd+MlikpXh1tZQA
         4LeEAda72Yk6PMSlnVsLiig6GatOTtZIg1zS1M8AhWtzWPGQcVeiBMZa8cTsFFahJSXU
         55hRlsfoXT9QRobJMMVb5juaKRXtp1RfZ1iYsNWR+tADZW7gX3OMf9yC3tCNArcqOlg9
         Ur/MQb1mPs3MXggTqcIH5PpExd9iOhyT0w+ClflHHVspBtJCc1C4HI29PGEIpUFkboKj
         3Bdg==
X-Gm-Message-State: AFq9FYI4Nr+nhVFTu9by7xlIJ+m++6hKI28G5UCsQF8XeDYJXeEQ/oJ5
	20KfH3qZftoMiPF5pZGdKTBQ9AzHLEh5EtViVWDoy29HA3RlePXNYNsj
X-Gm-Gg: AYBFou0crDBvYpupRIzfm1DIeEOzNxIQfGwdT1/ClZ2HwZSM6bVAq+jI9QZfifiP0Sp
	Gsg4QR6QEHEnWhQf2DoJTZTIfHdcYnn7/i6QOYfBaII5J4+oqs4aMv95Ckp1q0hrrdt4WyvKq+y
	7AVOBBdIfAR/dhsND5C8+tBP2SuuAnepK0SMgfKKYEcY6J1s0KGxJ+XaI9T+m81pwJ81VbwWVVF
	+vLSYbp9nmF1tXXwlAs6qYUAPkYekU2vgDYUBJ6LmB9jgNtfJ1wsA5y5R/HwHQzqCQCmzd3jiey
	qF5MInCpDWs/G9jqjeZzC5dM9hl3im18SjND8m4lPmEIPxSqwSvJIQtLDnuleapIL2EeHEnlMa7
	jy3WXo8Hd3+XU4U32KdgLalVH6JEn6iLQU/NRArx4/WSscl56SIJ2OO4JFrOs21qOP2b2wqz1hx
	l9xtinwnX3UbxVt5rCwbmMDSw+9t9Gcc5RLc3GCm8p/hdANq5Ccv+Pkx4qnlmcjcIZf6WSyRZvf
	35XjjMMLESHDJK0HdlhMYuYLXPO96AS/xIMY1Ny+m+JsVaaPjg32ExNXs0d4q/35QGRVrP/HqpG
	3bzcJ1XMuJxEkKSr6s3xHpvti9jQIm7t9JJjpkB/RV/ZfoGNM6KrvOHY2SM17uZ9ADIOSkRehNf
	DbHf9BdVclmWX6BwfCxcs1oekuurz3Q==
X-Received: by 2002:a05:6a00:b56:b0:899:394d:2976 with SMTP id d2e1a72fcca58-8a6e78d158bmr4556674b3a.39.1793281716645;
        Thu, 29 Oct 2026 06:48:36 -0700 (PDT)
Received: from acemagic-m1.tail4fb79.ts.net ([2401:7400:c804:b668:ab4c:c3be:c4b6:67cd])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a6a3d5baf4sm2455023b3a.1.2026.10.29.06.48.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 06:48:36 -0700 (PDT)
From: Ho Jie Feng <hjf3108@gmail.com>
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: linux-wireless@vger.kernel.org,
	Ho Jie Feng <hjf3108@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next 6/8] wifi: rt2800: set the mac80211 fast-xmit and aggregation flags
Date: Thu, 29 Oct 2026 21:47:47 +0800
Message-ID: <20261029134752.1299130-7-hjf3108@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261029134752.1299130-1-hjf3108@gmail.com>
References: <20261029134752.1299130-1-hjf3108@gmail.com>
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

Enable AMSDU TX/RX support for this driver, which can increase
throughput.

Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 032cd6ac345f0..8b4458a74d33d 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -11861,6 +11861,9 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	ieee80211_hw_set(rt2x00dev->hw, SIGNAL_DBM);
 	ieee80211_hw_set(rt2x00dev->hw, SUPPORTS_PS);
 	ieee80211_hw_set(rt2x00dev->hw, TX_STATUS_NO_AMPDU_LEN);
+	ieee80211_hw_set(rt2x00dev->hw, SUPPORT_FAST_XMIT);
+	ieee80211_hw_set(rt2x00dev->hw, TX_AMSDU);
+	ieee80211_hw_set(rt2x00dev->hw, SUPPORTS_AMSDU_IN_AMPDU);
 
 	/*
 	 * Don't set IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING for USB devices
-- 
2.53.0

