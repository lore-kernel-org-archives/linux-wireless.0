Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A403954CF47
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 13:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788875611; cv=none; b=njYALyQf72sZiVgJ+koyQGT43dh3w2YY18QgtMu6je7GOAMK7b3OO6/Pc4YTeUT/G+mhKN/NgPDe4gTFXhDOIR/hVBW+EO1Sd5y7j8Kb5yAVPcBzzS9tmAv8HvK/epPvyN1JMEYnO2zkEy7PVtb0ukvgt0aB+AvxuVgL0ksgJmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788875611; c=relaxed/simple;
	bh=kdVxD0Sn0JGGvcH4lSaVygnhhbO9+3zMVzTXM3Prh8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qWaKyREWB0receQpKHnCnwBxfjRQAqq+j/JfJ0fPNkeQ5IFrRWb6tKZupr6+v3iDYSMsYQ+bN7aiVR4KHtysf1Gs5KV+3aua/n2E/uDgqyFr+gMB4HgX1Cb0hlXZNJkqp5vOiitWNLtk9O4uZ5QG39ik/k1qTqX6vWlvy6QJ7rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=RAFZCJY8; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="RAFZCJY8"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6a623987d32so6916005a12.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 06:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1788875599; x=1789480399; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hw+5cnd4ki5dnOjOOpMKffR2NH2On0qgbSYRCUSuV0A=;
        b=RAFZCJY8JPe8diSBiii+PQA/n0YXRiMcAa/3En65zJdRG0WMhPIuakde9MS6Ntll4H
         4MIWq0snRA7kNZyWPs62CwTxo6w20/F+EP7RtPa7ivpFVS1iHNPBd7uZinzwjFd3EPCr
         Djr5OSUqP5hV0Xi4Sv7dnpAiE6sz27oWMrCBhIC1LVs7eHaeQ1G9TnWXR49Z55iJOO2j
         iWpBzrOWN1T/rBKxCBZBvN77fswKO9hnQfe0PEzkVpEmmf1AKcoDzPlg2eX9VFkvoQTs
         CXn5UfLpfSkEaB/R0KZL5hbjrhtLA5CUSBafwzrGVOlBeqqllVBKOonGVzIfYgfQ0YgD
         NBBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788875599; x=1789480399;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hw+5cnd4ki5dnOjOOpMKffR2NH2On0qgbSYRCUSuV0A=;
        b=hKdGk6Qq/GLghJuiHL7rylbpLnnGDe7KbKtyAcvhxvMTmtuWRcRkn2kNGR2bfarJPF
         DRSM43vhQwh1moVS2yzIfESXhr7zduwYURB+CxjR50Y8cqqFee4gDz12bOPP04dMuGe+
         GlUPz9EwmKeRs6VL1738iI6y53e7CUv15knCBX+I8vzA95OI8jniC4xs5OtCr8JhblFB
         1WtpmUYQCi28AY/pMfKPh7xEkgBXQs6qJZVnFD7HjI3Ef3CIwGRZVbDfq30vOQkCYBEV
         BY50U4d0lyt4chUsodNxPEKPNQwC8VQLh0FOFV0WN7pW6bzSM+HeHm1hfppFUmX320Aw
         V0ng==
X-Forwarded-Encrypted: i=1; AKwUvBwqS+RydKEIcnLsa3N/NnvpZmNIYLE/mTTvh+N9ZGF8ywGR4eSl1GtYUjFGCS0uOQSKMxcNZlFTo0EuBbwfmw==@vger.kernel.org
X-Gm-Message-State: AFuF++kcgY4BinX8hDo75ddYJBwJXVwi/FcCcKbqsejNk3rvq+6j3cmY
	4+jbM0bLdgXSsXjUwiJyxx+HtuARoqtT4ZHvxS5urxNBabWpgQsnfdbdIvON9TFKcA==
X-Gm-Gg: AYBFou1tj3dfP3UzeQsoE1Z4TEjKZPtkImM/TsmO87Ew3qcXxvmKAQXGe5FshiuYbhp
	YhcF2JCm8TLDnvsHZ8M8Wzlv5NJ+5CFXS13aNMfiSm8J2hIkZsZBDQIkKPb70KwSwH2btG+APXV
	4Zr33lP1Ny8s+4F+/0In70GY9umjqIM3u9LFZZFMt6YGHSLLa1GVgN7U17SvOupF97VECcdlzqS
	JmELoszFZZgRSar7OauvN107gHyNXwEJ3LuNwacPl5Guy7kwJmPWQxC5HOPdLcnebi8EC5SzK1/
	tHCPu+Mn7kje0DdZ7mNFQLqbbGtanrCh9jrJaR9Nhb/qDuCtNisu9a+FrE45NzSkhEbnls9tAxf
	PKofYWZHtaOmYcYbGXlhF7EzaNuSyFBa0C4pPLnequJZbiD+Xv3SCApYYvVgP2SivJJZdGhDMrK
	z7vKzGSB/doelpIdNQkS1akRPspyCLs0VelkhL3JYrIY7Dl5NugdjH0VUesaMSO8tlzLoaxKLHn
	ESOFqzlHAf904EfKyFwaC1oVnkp9aaJwuvZ6NFw2uk6e5SJfSBx0RnwqxieBK1z59+LaxanKdLJ
	WbtQRybwGTywB7dSH9ooNmhjSIdRuIwoi2OE7+8MRPVpBST7ivxJIo4Un7UTDocvMAyPMoBDFs6
	zsfqImQDybRA8kXSVMv83FHcO043/P3++wLH5nGO0G1sk/gMdkrat6BbT/1BAZoR6w/Rw2teQcO
	hooKT4vHyaPtaQ
X-Received: by 2002:a05:6402:2316:b0:6a9:857b:888a with SMTP id 4fb4d7f45d1cf-6a9857b8bd3mr352363a12.13.1788875598772;
        Tue, 08 Sep 2026 06:53:18 -0700 (PDT)
Received: from Desktop (pd951346e.dip0.t-ipconnect.de. [217.81.52.110])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a7e68a6e19sm5519140a12.10.2026.09.08.06.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 06:53:18 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: johannes@sipsolutions.net
Cc: toke@toke.dk,
	jjohnson@kernel.org,
	ath11k@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH v2 2/2] wifi: ath11k: declare that tx has no pushback
Date: Tue,  8 Sep 2026 15:53:15 +0200
Message-ID: <20260908135315.754126-2-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260908135315.754126-1-julius@bairaktaris.de>
References: <20260908135315.754126-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ath11k hands every frame mac80211 dequeues to the firmware at once and
the firmware picks the station it serves next, so the order in which
mac80211 schedules the queues does not reach the air. Set
IEEE80211_HW_TX_NO_PUSHBACK so that mac80211 applies the airtime weight
to the airtime queue limit. The flag has no effect until ath11k
advertises NL80211_EXT_FEATURE_AQL, which "wifi: ath11k: airtime queue
limits, fairness and a driver TXQ scheduler" does.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1
Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 2d55cdc4d165..87e6062c5550 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -10494,6 +10494,7 @@ static int __ath11k_mac_register(struct ath11k *ar)
 
 	ieee80211_hw_set(ar->hw, SIGNAL_DBM);
 	ieee80211_hw_set(ar->hw, SUPPORTS_PS);
+	ieee80211_hw_set(ar->hw, TX_NO_PUSHBACK);
 	ieee80211_hw_set(ar->hw, SUPPORTS_DYNAMIC_PS);
 	ieee80211_hw_set(ar->hw, MFP_CAPABLE);
 	ieee80211_hw_set(ar->hw, REPORTS_TX_ACK_STATUS);
-- 
2.53.0

