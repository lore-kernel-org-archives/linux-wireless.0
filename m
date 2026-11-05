Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793902346;
	b=gNdxojrdzb785AP39BUQh9mbi+TL932Th5JtdfIUinKNceIQo2hmWZ0z/YTYfXmb8gop
	 zTqTqilyRRGT7qTFNEVhdSO6QMAFiAfjQc+M9Zp37cDg8HddeSKhDDVpNeJI7TqghwhlT
	 49gcxrNUAz4xmvntYsHYNQmHrJjqCCabPllwM4r0zOffRJzrDruaq4vqZpRuc9uqiOGKy
	 98lGp944//FHIIWYAw2x9AuNLsXTaHnNM/luZZooVVrCcnTp24/Ev5qyMaG2Ff/k263dn
	 ayMTdHKkXAGE9jHQnpWlm5i9WkxFO5rMog3EiJqc1k5qSWJqZiFBtcqVur+1mF6ecbw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793902346;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=zuDBG2J86Bfrzi1zRqTx4H/EMGzTj9dsgHnGFtwMspw=;
	b=4nHVBBujqI2jfuVQUBleYPPdH4ERq6EXDaxEj1TO/kRPbUemW686dH0YneY8Vb583oPn
	 iqa2yrSLua1vFSK+2qKpUdox84P9tDixcVesZumUCM0S9Fo2jbJ9MLRlELtmq7JsR6vP9
	 UIRRuDnqrVedljKS7C8GLTvZXCouTzGLXjLSp3Rdb1Hd8vnydlKRadypk8YF5y8w+gKnI
	 /e7FLejyks15oT8f7IpZRQ+g3qcQzjm8fyCln0uuHj1N2ZxY5dOaJsR+kFRcQNqjKRXb4
	 4mn6QAv5RRINWSvb1NXnBUqLNfCmKzIQxTtTghnxQvXTHhGcBv6Rba/gG6LzD18cXLg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XkRxK8TS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BB7606A32F;
	Thu,  5 Nov 2026 18:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XkRxK8TS
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793902345;
	b=z9Mfb7vH8KWXPb05RaOdSRfmPMFzYe3EJqahohS3D4ujsZhq/gyROXvVBb/oYQIB7pMu
	 0/3Daw3+q/XWINxARzTUWiM78B0KTVG8+sFKSdRalDEje/M+ctOt2ie2swuJCa4HMB1Sx
	 DLfx0VxlfYlmNc0+9a2rG9or/bTaHXiYQ68EFFZBIiH+GKiA6W8eBoeW/XD0PHJG+WfgX
	 7uPDij+ckporsSU+yr904RJHqi3f8bnaFBC44ASzN6Ah4z4hgmCYKX7TxNZufvY9F5hxh
	 kbLQI56y9r6Wnbwr83roQkNcDgCQfONMONAQMQQQEUFDHZZUWve8tUUnzgN047a43Pg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793902345;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=zuDBG2J86Bfrzi1zRqTx4H/EMGzTj9dsgHnGFtwMspw=;
	b=SURN7wU2+lSqVB2XhHXfsmvOxLCmnM+Txt++8bfzFNjoog1QayHwJRsj7+kaOsA7BgQg
	 NPn4atMC1cp3DYJeq0UKq1t7gQAqZq7OUdY3T5f59NrnY4ICrVPeZK5F+jO88BrSaqReS
	 26qXokE6w9Z8ubi2qgMeThBOPQDJSqMaSVmWR7xNkUdUlVr0ZyO/tXLKe1qgi/CS5/dd8
	 GL6XqMu8htmw1+HiCcIzGT8REMU5ZxhmWVdoI8vKZTYKWOaxu2jPujoPAnaLIrSRL9gYr
	 wiDZw2gTFD+FDLQxW453n/AIOq7TXWFPhBbtxueF+w/GGf4/D6SS488V23e9GE5fXvA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 36DAE1F000C1;
	Thu,  5 Nov 2026 18:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793902345;
	bh=zuDBG2J86Bfrzi1zRqTx4H/EMGzTj9dsgHnGFtwMspw=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=XkRxK8TSIwNqDCLpuvXi44sXt1ZzBZz5arGGs6EkIznkAkKUKftH5FVcxWMs+8gSi
	 Ahf3347znqPZ6Z9/lXHWyeLsUwvnkuJkJFmxuF/BBO+FflHrXKinCeedOJvpOYNyoP
	 9zsjaCJLqpjH7hE3mejy7/nxkOXpQKxh/i3+22RWNo4zEpf0RbX7D4EnJF67lD7CMN
	 525ldwBF9fcijJIvEU5xEXW4d38ld/A0g8a4XMEaBXT5Q6tegZx6005Mavgh7jS3Vr
	 LCs7G3b05h/B3j3w3xRyZr8bim3oEjBdqj0WT/AQ/2Q5VGcl7yxlipLGEYkrfx+7yC
	 M0QIe14tl2GWQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id BDF6D473C1;
	Thu,  5 Nov 2026 18:12:24 +0000 (UTC)
From: Christopher Griffin via B4 Relay <devnull+christophergriffin05.gmail.com@kernel.org>
Subject: [PATCH 0/2] wifi: ath11k/ath12k: don't leave a monitor started
 when its stop fails
Date: Thu, 05 Nov 2026 12:12:21 -0600
Message-Id: <20261105-ath-monitor-unassign-v1-0-277f0fbadb91@gmail.com>
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
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAbH7GoC/yXM0QqCQBBG4VeRuW7ANRLpVaKL0f50gmZjZ5VAf
 He3vPwuzlnJkRRO12qlhEVdoxWEU0XDJDaC9VFMTd20IdQXljzxO5rmmHg2cdfRuAXk3PVAkI5
 K+kl46ve/vd0P+9y/MOTfi7ZtB7y3T654AAAA
X-Change-ID: 20261105-ath-monitor-unassign-6eea38bee1a8
To: Jeff Johnson <jjohnson@kernel.org>, 
 Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>, 
 Jouni Malinen <quic_jouni@quicinc.com>, Kalle Valo <kvalo@kernel.org>, 
 P Praneesh <quic_ppranees@quicinc.com>, 
 Ramya Gnanasekar <quic_rgnanase@quicinc.com>, 
 Wen Gong <quic_wgong@quicinc.com>, 
 Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, 
 linux-kernel@vger.kernel.org, 
 Baochen Qiang <baochen.qiang@oss.qualcomm.com>, 
 Pradeep Kumar Chitrapu <quic_pradeepc@quicinc.com>, 
 ath12k@lists.infradead.org, 
 Christopher Griffin <christophergriffin05@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793902344; l=1139;
 i=christophergriffin05@gmail.com; s=20261024; h=from:subject:message-id;
 bh=WeRf9b45ChxpBsM73VYTLNwPQgkMOLOEYToX9qAV0xk=;
 b=hnoBS4p00Pof2V4tXGckfxiEGJHvqOtZd66HQTJSo5geyMHYnenMRX4tGqdAvAmcM1y8UDW4a
 4+0m/a3PaDNAlMwjJa6OUBU8qaHxusjCF6xCj5hwHRuJcDvdg/tkqZt
X-Developer-Key: i=christophergriffin05@gmail.com; a=ed25519;
 pk=oa9tkTNpiGoFWdGvpDHXLSobApmsh9BfrJRJrRJAvWA=
X-Endpoint-Received: by B4 Relay for
 christophergriffin05@gmail.com/20261024 with auth_id=1309
X-Original-From: Christopher Griffin <christophergriffin05@gmail.com>
Reply-To: christophergriffin05@gmail.com

If the monitor vdev stop fails in unassign_vif_chanctx(), ath11k and
ath12k return with the vif (link) still marked started, although
mac80211 has released the channel context. The next assignment then
warns and fails with -EBUSY.

A firmware crash during a monitor channel change hits it reliably:
three of three simulated asserts on a QCN9074 with a monitor interface
changing channel every few hundred milliseconds took this path. With
patch 1, none warned and every recovery completed (before: a WARNING
each time). Patch 2 makes the same change in ath12k, compile-tested
only (W=1).

---
Christopher Griffin (2):
      wifi: ath11k: don't leave a monitor vif started when its stop fails
      wifi: ath12k: don't leave a monitor link started when its stop fails

 drivers/net/wireless/ath/ath11k/mac.c |  6 ++----
 drivers/net/wireless/ath/ath12k/mac.c | 12 +++++-------
 2 files changed, 7 insertions(+), 11 deletions(-)
---
base-commit: 5c8eab13e391aaabd5a1ad58f3ee4bb10ce7573e
change-id: 20261105-ath-monitor-unassign-6eea38bee1a8

Best regards,
--  
Christopher Griffin <christophergriffin05@gmail.com>


