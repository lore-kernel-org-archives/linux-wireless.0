Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21483F6C3E
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 19:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785957788; cv=none; b=p6eEM7aYCdlIRKapXpSj9xNSHc4DDGEa4JXfjvnzLmsEc4ho2xPpY6uozJi2VXR4d4ZOJLBBRbevH+vnG1I1/5wLk1HcO/bgGCXvWw2ZLUp47rolR0eQvyMMA/R9QYhwkchFzqULKkV+yWBhXsYRx658zmfHwCkF3ioMcjtbbj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785957788; c=relaxed/simple;
	bh=aIP8NyPcw/fsc4YyGQAoe/a33AyfDrD6h/dW+wIuRYg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gUq+wMIJoL4P0TXNdVh7K0mxtBFjdBsknbjpf1fG/M2iN3xHxXSLTBKadCM2cNMx3W40oZ6iAyNF1DmNZ//NFTRTOTVLMtb/Fjhd/e2+fRIYBjj9rZc/4rYiv0HDUdmCdBpQrQbFqfn5mYGBZQcTg+2x8Fi71/tKPeyeXhSlOZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=wGXoxR2W; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="wGXoxR2W"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c1c52d920b8so220129366b.2
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2026 12:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1785957772; x=1786562572; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vFVpN+bB4EEuxs813hnK+WuPIS45ZqdvBVCb5hchvAg=;
        b=wGXoxR2WseKcaxM/iwmCUb5to7NOBwyw9xqrSzMcyzqktdFjbClr4J4CEcH3pbHMTx
         u+xpWUhMFMMl7aKxbARnUL41nrwJSvBoI223g4FiqjSOPywT1zUyzgaNGXufwVRduhVN
         TzwWtqiYmCU6ZOqCPxEG4ljLbRu/e/0OwDnswZxKcyRgCLUJWZOt3kga3tSdcKItWOnJ
         xwGGw7qBtG6AmXCZoPxpmlld3eW3QstO189XIvO4WrTZd0mGHxTCBhPpaLi7kC/MbumK
         YiVZjwdCd0BlV0EeD6CgOpJRh3CT8e2b7KNsxHK9eYtxvH6XS8qnTaW+X1asz3VJ+KUj
         lLbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785957772; x=1786562572;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vFVpN+bB4EEuxs813hnK+WuPIS45ZqdvBVCb5hchvAg=;
        b=ksXgXzsJzd7CVnkhU17Sq8RqX15Xtsc/BCaF36qIz5PXIVuSV7IwqC0DttBrsHcCRo
         P0DBTZSpknZg5VhKmwpPiJwkUQ+X6gT1++2BeHpvBDBuAyFV779n/4aKVkhS5/0tvtHg
         cQC0hx3kA83AuUA7hw8h3nlbRSbTzPiz2JKelyBApu0r5q2yp6h6lvWVs+n6eDy5ohK4
         SYB+wnOvbcv9xW5q75txWOu73XkWlXPfprJjrhJ1k85dLHL+c5UJwoRHWtsd98KEBxBs
         SBnpNkCSQWKDvJyQBTOffSvGyebjeqWaamuGOGd0su8eW2CW060FgowZLnK/iMRHyAGO
         hUNw==
X-Forwarded-Encrypted: i=1; AHgh+RpT83n4aul9E6nrnIgJFjSohTnzSv1GPID5oXbgLDIkGBQsy9SfDAcLYWXjOJyX3Si6TUTft9Ywzx2mO15b2A==@vger.kernel.org
X-Gm-Message-State: AOJu0YwcP6Q5/zO70RDsZu+LtguveMupMJTFramDp3gDEdi/jnpFuOYa
	K6Uqhe1mC0ModFRRCyQpWgBuKQ5DmE+IYymV1cf1TVaqS6LmXckBcCmY49LZleoj+gp2ebxAe8E
	Po37NYQ==
X-Gm-Gg: AR+sD12NPfYlGCPV7NJBhCv06A0POrUghoMYEbTYL6TuMSczk6BWSvzgd1hwMMu1jr8
	HjoXycTMqS9qF9ktGzpJC6Ry8Aaoy2sPBG56W6/wW4dsGvjtN7o1WlOInsYlFfRCV/pXHMxj2YZ
	nocM2LKhcF8B9FRAU7DGybmfkBfGxjYd1CnjLsKlMX1rEz4yfQWcFoWrt0KV2BPxjF5Zl90ilPx
	9Cb1Kxrs+CWKxjPmsACO/lo5OwVEeGvkhOJnsfPRSukRt/xieeneRucV2wJHK/pIqPs8SOru/Io
	GsMbyy1CWrJuVKQ6sF1m68es5aX18F5G9J//mg1XYc3mLQ1+8M6nh2n4edWciFUdVhw96ujWZuA
	/CFMK7jOynpJk0sGujLBT/0skqqNZYVp4qTnrm+6qQ71fvAvNeqb/Ayd2H2aOKjDECK2YWz5IX9
	dY7sNf9aKu0FnBzTwaP4B2LSjjI3KIOvdRyK6S/Bsg8mukQoyRhyx48DFTXnC3VMhghMRjtPnV+
	ZGiA3nMnoJCbF6NxtE10eVleJhDajSvS2CzMDEUY2XFseNNX3IUMyy5wip1Pk7d7PjWk36Bw/gx
	GZcd4ioYSCWGdJkChc6k+7ST/nzsqTV2HhiZD1wN8xQmFcWidn15vWsxjLsnwGF6EUjoo9naLuX
	9KJ+ExpHE0qURrc9rpevmRr6IbhnSzK8c1n3Lu/qp5jZKT0FJKItC+rl+h5wKuDVn2vmSkn5O3B
	Zf/PO92q2Wz9N55A==
X-Received: by 2002:a17:906:99d4:b0:c19:611c:fa8f with SMTP id a640c23a62f3a-c2039c1f2b9mr464669266b.18.1785957771812;
        Wed, 05 Aug 2026 12:22:51 -0700 (PDT)
Received: from Desktop (pd9513cee.dip0.t-ipconnect.de. [217.81.60.238])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a17d6216cesm1180713a12.31.2026.08.05.12.22.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 12:22:50 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baochen.qiang@oss.qualcomm.com,
	vasanthakumar.thiagarajan@oss.qualcomm.com,
	rameshkumar.sundaram@oss.qualcomm.com
Subject: [PATCH ath-next 1/2] wifi: ath11k: guard copy engine access against a cleared srng
Date: Wed,  5 Aug 2026 21:21:28 +0200
Message-ID: <20260805192129.61113-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ath11k_core_reconfigure_on_crash() zeroes the ring list with
ath11k_hal_srng_clear() and only rebuilds the copy engine rings later,
inside ath11k_core_qmi_firmware_ready() -> ath11k_ce_init_pipes().

ath11k_ce_send() is gated on ATH11K_FLAG_CRASH_FLUSH, but that flag is
cleared before ath11k_core_qmi_firmware_ready() is called - it has to be,
since the firmware bring-up itself sends WMI commands through the copy
engine. For the whole of that bring-up the gate is open while the ring is
still zeroed, so any WMI command issued in that window dereferences the
NULL u.src_ring.tp_addr in ath11k_hal_srng_access_begin():

  Unable to handle kernel read from unreadable memory at virtual address 0
  CPU: 0 UID: 101 PID: 1846 Comm: hostapd
  pc : ath11k_hal_srng_access_begin+0xc/0x60 [ath11k]
  lr : ath11k_ce_send+0x114/0x350 [ath11k]
  Call trace:
   ath11k_hal_srng_access_begin+0xc/0x60 [ath11k] (P)
   ath11k_htc_send+0x188/0x3c8 [ath11k]
   ath11k_wmi_cmd_send+0xc8/0x2f4 [ath11k]
   ath11k_wmi_send_peer_create_cmd+0x78/0xe0 [ath11k]
   ath11k_peer_create+0x138/0x500 [ath11k]

The caller matters: this is a command issued fresh during the recovery,
not a task that was already blocked in ath11k_wmi_cmd_send(). A blocked
one sleeps through the whole window and never re-enters ath11k_ce_send(),
which is why hammering beacon updates does not reproduce it and a station
associating during recovery does.

ath11k_ce_completed_send_next() has no gate at all, and
ath11k_core_reconfigure_on_crash() calls ath11k_ce_cleanup_pipes() before
anything else, so a crash arriving after a previous recovery already ran
ath11k_hal_srng_clear() reaps rings whose tp_addr is NULL. This is a
different entry into the same dereference from the one fixed by
commit e8d85672dd7e ("wifi: ath11k: fix NULL pointer dereference in
ath11k_hal_srng_access_begin"), which stops a successful bring-up from
being repeated; it does not close this window.

Test u.src_ring.tp_addr rather than srng->initialized in both places:
ath11k_hal_srng_setup() publishes ->initialized before ->tp_addr with no
barrier between them, so an ->initialized check can be true while the
pointer that is about to be dereferenced is still NULL.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.12-01460-QCAHKSWPL_SILICONZ-1

Fixes: 32be3ca4cf78 ("wifi: ath11k: HAL SRNG: don't deinitialize and re-initialize again")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/ce.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/ce.c b/drivers/net/wireless/ath/ath11k/ce.c
--- a/drivers/net/wireless/ath/ath11k/ce.c
+++ b/drivers/net/wireless/ath/ath11k/ce.c
@@ -472,6 +472,17 @@ static struct sk_buff *ath11k_ce_completed_send_next(struct ath11k_ce_pipe *pipe

 	spin_lock_bh(&srng->lock);

+	/*
+	 * ath11k_ce_cleanup_pipes() can reach this on a ring that
+	 * ath11k_hal_srng_clear() has zeroed and that recovery has not
+	 * rebuilt. Bail out as for an empty ring rather than dereference
+	 * the NULL tp_addr in ath11k_hal_srng_access_begin().
+	 */
+	if (unlikely(!srng->u.src_ring.tp_addr)) {
+		skb = ERR_PTR(-EIO);
+		goto err_unlock;
+	}
+
 	ath11k_hal_srng_access_begin(ab, srng);

 	desc = ath11k_hal_srng_src_reap_next(ab, srng);
@@ -750,6 +761,19 @@ int ath11k_ce_send(struct ath11k_base *ab, struct sk_buff *skb, u8 pipe_id,

 	srng = &ab->hal.srng_list[pipe->src_ring->hal_ring_id];

+	/*
+	 * ATH11K_FLAG_CRASH_FLUSH is cleared before the copy engine rings
+	 * are rebuilt, so the check above lets a send through while the
+	 * ring is still zeroed. Test the pointer that would be
+	 * dereferenced: ath11k_hal_srng_setup() publishes ->initialized
+	 * before ->tp_addr without a barrier, so ->initialized would still
+	 * race the rebuild.
+	 */
+	if (unlikely(!srng->u.src_ring.tp_addr)) {
+		spin_unlock_bh(&ab->ce.ce_lock);
+		return -ESHUTDOWN;
+	}
+
 	spin_lock_bh(&srng->lock);

 	ath11k_hal_srng_access_begin(ab, srng);
