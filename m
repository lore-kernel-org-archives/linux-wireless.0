Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B0B331ECB
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 03:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789703269; cv=none; b=tvOjKzHDyMkw4QggX7MjhBEv8rXGXssoRZEf+UZebhlbR/UMkMs6dKnzRt/Nclaf+++gMIqbPd2a8Lb+QFZuSFVNfyXsPLU+11xYG1dh44A+m/5hmXUmxAKsd9vy+9xLcap44Nd8378aG5w8iPYm4kttgHSDvm8EZQFBN6v1Szg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789703269; c=relaxed/simple;
	bh=OZFz7FV+Ns8YSEl8n3PTLzmOdx9IwQQiCOjBnJtXyTw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ck0zmOlmGsbkyGYZzS2YTSKC8X9irVArwSw3gSe3KoqHysH0AuEEOaIAbR9J0UK/lqpCl0oYMjLWMVmr4ZEOhzLNNwUupvUA9dxos+2JVV73RnqqM9hB2oIrRsUNfcXY9n+vXjkrw/4Nc7GVq+0EgzHiph0oW1t1zttG+zZBxfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nVQ6RmSo; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nVQ6RmSo"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc4d04d73b8so164108a12.1
        for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 20:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789703259; x=1790308059; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=qr1pHP/iCGIz1D7JJO5YGZs0OF8AJhVgDqynMNvIAUU=;
        b=nVQ6RmSov9B86grXopmjVPYQjdshjUaviDqQFeaopFJ4UnMAqJAch+7jsnEjBlItLo
         8YSpkxtsrSmoUE7NaobzlMSlAM7sn+1PhN24JFOLBtMpYj8Sbo5LyOdVLMmnna3ItTDi
         kyPr0z/yKyc5LdqyspvyQ08Rqe0zzxC999K1gue0VPrVqKWPkcBoHESfFI5nM7Tr0vLP
         dvoCJwjrpS37IQMlmE7KBDZ6PVP3p9TMzTOJ3K9+O0e6socPG7qv/KPXUvDJMxvnMHhU
         lcfIM4EaqqNBRQfMN7HT6pNxorGi9Ci9tNXA7x7RsBbaFzGzswEjMs3MDJTxYVmMO9pv
         kIvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789703259; x=1790308059;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qr1pHP/iCGIz1D7JJO5YGZs0OF8AJhVgDqynMNvIAUU=;
        b=aJCjLLfsSB45bJiGIQjixNTbXk8aHcdgcC2IO9M0E5wn+bbh1gv+abQEsCKY10oWGt
         H/Wh77U/6eS4IZ2VSQ9H4LdIMaFJE8DdRBwLl47AdO86QfWbvhId20wrX+zLskGZHrGy
         +fzMaQ8PQGLFbMYQj6MBfAkB1nC6aS54QyLvS4cikhpkyiAgbEBNDHqwcYOlGWBX03l0
         g732g2cM9ByB+DDZ9DaC3/3TtLSRFed2SgGGcl7JrtMstoMiGlwMbMWElUinMKvb4KES
         ZbBiDzgVCILwFqJR1FqAc2qvpiGyzhUtR0mnWxkCj7en9ksOBHWrbPEs6kcBleGdDZfh
         6J2w==
X-Gm-Message-State: AFuF++lCz2qv2vOwJ6Ra1R/666Clk4JCUbGeXfA57tGTgb0QKM7vmXql
	FnWHsIjJT+2zERgzd3e8mMhPID+IPiGUCTm48vZNU4WYmWFc/MKFjYCcwjToo2yl
X-Gm-Gg: AYBFou0mr1xRehpl/zN82mP1fIE4b8BnncR8ghUdP8CciTxLaStrpvDshmbtyAS2sz0
	5MbmReG4/p5q1mFlkdFnqrZtpC1EymfyPycDWJCI91kGzJrVUD8tRxcmpmmQq5dJlkHCA8C32OF
	RwrLkUEyP6ZrmEjlFInAHSMALFZnpkaCD4I1BDH/+0Yt+pIbQxPrVE4w2NKnG5W/Dzairc3+irh
	tfsuM/gaJr0Ar2Cq5o8fmxwhQ7TghHqK8Fu9eWyojkCa187RT7JUKFMx+kPMz7Y9g56GpXw4C3V
	QwijBfAykVL6mfEQ7yqMKJG1zszKAMnQFSB7lIVc+TyfEc01uWcvOfcIdR/1/PjVOCGmKW7of2O
	xxuHqibKrOYs6CIc94BBCpmu/imBrA/Vo8GEdMd5tFkb3cH3rALZc3IjiUGV1B6ESvUMH0rGsB/
	wUvwckYXLsGh9Q7I3ZRWVDJYGNEc1T0/CZycNAAOFRqSFL4/zDrEq6+KsRsSO0K8w=
X-Received: by 2002:a17:90b:3909:b0:39e:1f16:6167 with SMTP id 98e67ed59e1d1-39e54aa348bmr2812569a91.3.1789703259451;
        Thu, 17 Sep 2026 20:47:39 -0700 (PDT)
Received: from adi.. ([122.171.17.124])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33c284a8c65sm752205eec.4.2026.09.17.20.47.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 20:47:39 -0700 (PDT)
From: Adi Prasan <itsadi2409@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	linux-kernel@vger.kernel.org,
	Adi Prasan <itsadi2409@gmail.com>,
	syzbot+847847e76c6983a5b3dd@syzkaller.appspotmail.com
Subject: [PATCH] wifi: mac80211_hwsim: handle invalid tx rate index
Date: Fri, 18 Sep 2026 03:47:17 +0000
Message-ID: <20260918034717.22104-1-itsadi2409@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mac80211_hwsim_get_tx_rate() calls ieee80211_get_tx_rate()
without checking whether the rate index is valid.

A monitor frame with an invalid or missing legacy rate can leave
rates[0].idx set to -1. This triggers the WARN_ON_ONCE() in
ieee80211_get_tx_rate().

Treat a negative rate index like the existing MCS/VHT case and
return NULL. The caller already handles a missing tx rate.

Reported-by: syzbot+847847e76c6983a5b3dd@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=847847e76c6983a5b3dd
Signed-off-by: Adi Prasan <itsadi2409@gmail.com>
---
 drivers/net/wireless/virtual/mac80211_hwsim_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_main.c b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
index 02b6d81cccd1..e7bf91e06e40 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -1332,6 +1332,9 @@ mac80211_hwsim_get_tx_rate(struct ieee80211_hw *hw,
 	    (IEEE80211_TX_RC_MCS | IEEE80211_TX_RC_VHT_MCS))
 		return NULL;
 
+	if (info->control.rates[0].idx < 0)
+		return NULL;
+
 	return ieee80211_get_tx_rate(hw, info);
 }
 
-- 
2.43.0

