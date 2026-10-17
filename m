Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7D5377004
	for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2026 21:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792272655; cv=none; b=V3a+l0ZFfEg4b5UaWfXN0TVWbJyYmAe4cKpbJGmkR64bHqE2aqjRqJm5IkSePnGcPvc1qydOmIWnLPXw0fjYO5JtURrfQWfDKwBKu5eNzlZu3RJNOOo7JADxMs8xzdO+3dGqk1J6NmgsFOX+6duaoJ7xlS+PyMuemE+E2rBj9ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792272655; c=relaxed/simple;
	bh=5qhJN09YPyNt7EZtN1s5WGSWuaIkBGhCn6fyXrrantY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Cda7QLoU/Ds1yTHqZh1KRklYIBby8UwCGf5cR0DAbCego3jT0sNMVkcFxfto/6HAHRLp3PYlk3EaprVvcZSAMcihOUD02z2fYF658NvN0tDN8/rD9ayg0Z+8R8BPV0EO8zFZ97jfEIlE6sHAyFGa8R9DyOO/qpGoPVs9fxYNFzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SEuvMRao; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SEuvMRao"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2e95bd1c14cso7623365ad.2
        for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2026 14:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792272652; x=1792877452; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FiD6sMCpVV/13PjivmVbngyELUrVKdk1SGBNZwIKdms=;
        b=SEuvMRaoDnR70YxfH2R0kxKYCNctK3PbgeWEbr2METrXbf8L46/HGQ8KzMM9lOZlDq
         8/rTsz6ruJ56bVGshg8wAXbe1crTU26AOVym9d/Jk03HMue+MLEfqaWm81Ui6y4tJ+Pa
         0/MZSp7ZEk7f/TpxMTDg9qizaTPSkh1auObPVzoA6Ek+IoOj+GjZfdXrmHjgIKDIKNX8
         FJ+wmuPmg4JefDQ2IdLuZHBfzqLzwNr8w3ROBVkidUTbakDmKvh5twTy2x88TPcBmH6i
         Dhz+IQ3iyIvkLNHhOqOo8rHK/9im9zE55thOIljs6NolBzf2Gj0M+IeobH2N0MqJeOPa
         DtxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792272652; x=1792877452;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FiD6sMCpVV/13PjivmVbngyELUrVKdk1SGBNZwIKdms=;
        b=MYWJmCqs/FlQ3SRvAmA6U2H32dfE+j9rWbeLb7x1o5WtJZweKt29rHhNiyxNnTxQyr
         DDUC0sakmmRnUNehihZ1Nr170jTb9oOg+AiN7a2CBcjSlXNbSGwzqYyvlctRb7neuqtA
         HxKcRbriETPXFKaAX8vcj35eSzDquSjexuBbTqEjukuJs7oOfWolbPC+H5fERqq5WVea
         f5TLMLCaQRrfRilhhKa1RYtDq9BN0pHngz1s5SO0z1UIWYuMNu2K7Q0lxH/k8rErOGQn
         OSg0cABclxYleur2hIl2nQNC50T8TwplZaB/ulRs+nxmToMINRE1aZ6xgbdp43/pKMCM
         rvKQ==
X-Gm-Message-State: AFq9FYJGSiGFLiQDckgfctRxAY67rs+maUqDftZjHIWHWh6o9A+AHNj+
	DaW9+qpENbZw2Q09VffGDPHNw/4ifrJfnAqIv/nO446uGwO44GrkfplcFjjv4rv/
X-Gm-Gg: AYBFou0WMehF8Okzoaj+wKc29BqeVStwnBie7QLLxngXkYeMB/b3BYcNzLYwVUkdwFE
	z+d0qme0zp3XcY/8ulPIuWKSsutUWjP0ZH0sPMdYNpy8X1ZY1iy44uSoVMnUtx8/8Xyh2EGiS7x
	jnZNGlxT21KhSfbsqh+QlfX4Pnyc9KhQ1IemuuOTty2L39xZWkKvX9RbpUAdtw8ZA8wavgKdvcs
	T2L3gvBjFrxQjrjECnTYOjXH/6XMGyUU4I57Q6b/mIsdtXLX7KwFSi0zN8/C0S+W9RAL4vzJNxX
	kiAb3aeS5Xg3amBZbt6ON6Z6p2KZkOsDFjXeKuxccKeblsqxNhc1ycFOAJy4K7tk54gKqXXxEQp
	FM0ub9rcSYaPuhaoznm6KKbescSBVFRdh0XOuwuUsB3S9KU7NLlCb/655fwrGapp5qLiOcQ4urq
	ISXDClViAagT8dDvoKfDSRftamrtrFYpX4RP9oH9JOvQ29GUBt2JuzudJJDFBLeksJ578W/jmab
	cqe7miZVvLFHBdRplaBhwGuOVGhvFe7aGGfj8f1R4NL5APeVVejixaBhUFpk4R9S99N8ilOpDB6
	TjWKCrdX1BQFJjBcYSvJm8f3lSVpRJ1MSkJq7X/3l0Fg8It4
X-Received: by 2002:a17:902:d2ca:b0:2dd:c100:3133 with SMTP id d9443c01a7336-2e9a6c208f0mr34763315ad.47.1792272651972;
        Sat, 17 Oct 2026 14:30:51 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e37])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e97e8758efsm22848825ad.55.2026.10.17.14.30.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 14:30:50 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Kalle Valo <kvalo@kernel.org>,
	b43-dev@lists.infradead.org (open list:B43 WIRELESS DRIVER),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH wireless] wifi: b43: encrypt robust management frames in software
Date: Sat, 17 Oct 2026 14:30:47 -0700
Message-ID: <20261017213047.1160219-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

b43 sets MFP_CAPABLE, and uploads CCMP keys to the hardware with only
IEEE80211_KEY_FLAG_GENERATE_IV. mac80211 then leaves the encryption of
robust management frames to the hardware as well. The hardware
encrypts every frame as a data frame, but the CCMP nonce and AAD of a
management frame are built differently, so the peer discards these
frames.

Under MFP, this hits the block ack action frames. On a BCM4331 with HT
enabled, associated to an access point that uses PMF, the access point
never gets the ADDBA response of the BCM4331. It waits about 100 ms
for it, sends its frames without aggregation, and asks again with the
next frames it has queued, so pings take 103 ms every few frames. The
TX block ack sessions of the BCM4331 never start either. A capture on
a second card shows the protected ADDBA exchange before every delayed
reply, and a new dialog each time.

Set IEEE80211_KEY_FLAG_SW_MGMT_TX on CCMP keys, so that mac80211
encrypts robust management frames in software. Data frames are still
encrypted in hardware.

With this, the block ack sessions start in both directions, ping times
go from 146 ms average and 918 ms maximum to 2.6 ms and 3.2 ms, and
iperf3 from 11 to 43 Mbit/s down and from 11 to 41 Mbit/s up on a
BCM94311CD.

Fixes: 75d057bda1fb ("b43: Fix connection problem with WPA3")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/net/wireless/broadcom/b43/main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/broadcom/b43/main.c b/drivers/net/wireless/broadcom/b43/main.c
index 3825b6ad9f4f..6d7c81c98e43 100644
--- a/drivers/net/wireless/broadcom/b43/main.c
+++ b/drivers/net/wireless/broadcom/b43/main.c
@@ -4266,6 +4266,12 @@ static int b43_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
 		if (algorithm == B43_SEC_ALGO_TKIP)
 			key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
+		/*
+		 * The hardware encrypts every frame as a data frame, which
+		 * is wrong for robust management frames under MFP.
+		 */
+		if (algorithm == B43_SEC_ALGO_AES)
+			key->flags |= IEEE80211_KEY_FLAG_SW_MGMT_TX;
 		break;
 	case DISABLE_KEY: {
 		err = b43_key_clear(dev, key->hw_key_idx);
-- 
2.56.0

