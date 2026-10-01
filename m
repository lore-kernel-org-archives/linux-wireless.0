Received: from mail-oo2-f35.google.com (mail-oo2-f35.google.com [74.125.231.163])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDBF3BF689
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 16:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790872941; cv=none; b=KTBxFH+RJYzAJ+SuFs6wVVBcW2ae5wHuPfbn5ILf1TPp1bzprk7bMEdCSxQ1M6HNqOnDDOF75y+MQaLNiczc8goShEPbtOA0rMlzazyzLgjW67hYg8s/5FVkIntkbFrU8rROjeLE/Lk9ndfFRUcM2oBU9UxYwclzLo27ubeXYW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790872941; c=relaxed/simple;
	bh=EDHXUIjjM6UdMy4A+k4tbeIVtiVh/qfCZjN8Dc/wE4o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VifnPIF7gqKXMcWiMsNaZm9z/TfGGCVrz9gzYnLls9ZTQOH9YpmrRrLJ1ZlU1kDhFtlyafl3fsHQBAo/1MjxAda22x0c5kIYyAkKXF/283f/qJ8AuoN1TJmvnz2QNjjk3GlCrN8hl6ykDR4WBzrh8auPRnYS6ehrDgSzvS/3CPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NRsNp+38; arc=none smtp.client-ip=74.125.231.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NRsNp+38"
Received: by mail-oo2-f35.google.com with SMTP id 46e09a7af769-8212a719d15so732549a34.3
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2026 09:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790872937; x=1791477737; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8ErsgCdjJpA/DlSdvk3QC3jh560CNo6DjQxt2VzypIM=;
        b=NRsNp+38+1f6jJTaAh3BwgF3pTKrDJAvW6nHzh3IdzTl+X5ToYoPOtCI5B5wjHJU/I
         ROtctn4BUNuy+baTk701YHxydq1f4YRKNg961J9+utw7SAk9mHhlhNQjVfpMEkTWAEzz
         NBbZPKVI0eKP864vZSgnOz4q/Ubc9rKx39JojmsczQGc2OPxk82gNL4hLeEMKYN7bbIz
         ndqORyA2CALdCsuFQ+wT0o/JvKZ1SF+GNiGVzRa7nCg5JPBwtE/eLpEts2Xx2SRBEGY9
         fvBftY1JiIKaMTaK/Qg0qMDtrauSScX2t9vCG+Vt9c2hwFLr4/SlYyckj1UDCJgn/+VN
         W6ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790872937; x=1791477737;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8ErsgCdjJpA/DlSdvk3QC3jh560CNo6DjQxt2VzypIM=;
        b=nNgWEJZE9+jwbTh3taQvIwK77AVm2dusHgaQaE9Is47WgT3gIlKaL15v5gwn90Jv/P
         M79YKvqUfz1Q/XMk6SW6qyvwbh0RluScNw+nNLBhgZ0a5/yEL52pm9/FjblM15RuiTC0
         3GrYRNuTmGkUSrI7VLHTMFzn/qoYlkzg9KskISIR20eGLDMZNTcMWVLIAy7+zmK+M5Ky
         sb+A1bAREu5jXxtBFq64Jy2NDV6ilG/qge4lLAU1CMIrQVAizY+rz2de9GsmCJROmNqE
         pOr0/i4tWy2DJ/D4tX6LnUcSBRaC4FEfji9jBaohD7WLn1a+8apIAgQfdOlLb5hCEnUs
         yOWA==
X-Gm-Message-State: AFuF++lBhO8a7mhNylZF3l355IHlE/AgAKZBNW5NOpu/dHHQFdwc1Eyk
	w82v4sYJb/LVwHs5ZxXlh0HcUihHU/8rljYEba5LCpVUM82zSM/mfU8x
X-Gm-Gg: AYBFou1e0qyJngQhFtQ/nJgO+jPuEn4vVm0ggZkTZwJvoU4xRuSM21F/ZBRzMmqGVQM
	SuOgDMK3mGb6dxW+Gg4SZtVAWnUft5Z61Ms7VmMwWEftXUHcmULw6AVJy0dWshXDjlzweNOHcO2
	XlipjGbzUgMdQIWFFhgv2PqoVG41qkhAjl3UXKnQUAH6lKK0Xpvk0RSdIv9JshaP0CDL/aN9GG5
	lLlggsTx61C2o6D/alDLyPeZMHhMZHuIzGHihAPCvGK7otnDY7mNO8GBYhDCf0LaBVL8RaCtmcm
	Xj4/pXn50H+FLYeXq9F2gpyeB1o0vkxBmL8iPfSqULKnkluJfxfBEh2gRKrzGoGv6QXyR0pQ4ks
	R3KjWnWOKkz0k51wT29O41C+cl1kjCVj3WdO/vmkRZFAc84Knikd/2choAVzQv/sNA5mmDPsDWz
	I4ZA4cuh0QU4P4Eeu3cwHkytY+GNlrzD8mPrEKgowaGPtFhKDSpvsAVMrvkrACzWKoZE3y/XtXm
	wJXZlzPUSMf5PFjuRiDbV+78DyCMi7oweF3u7A=
X-Received: by 2002:a05:6830:3498:b0:81c:5aac:798a with SMTP id 46e09a7af769-82284552ff7mr195697a34.13.1790872937467;
        Thu, 01 Oct 2026 09:42:17 -0700 (PDT)
Received: from cachyos-a.lan ([216.212.36.213])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-8227a16aaadsm304424a34.18.2026.10.01.09.42.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 09:42:17 -0700 (PDT)
From: Patrick Lawler <patricktlawler@gmail.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Patrick Lawler <patricktlawler@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH ath-next] wifi: ath11k: require unique station addresses per radio
Date: Thu,  1 Oct 2026 12:41:39 -0400
Message-ID: <20261001164139.370144-1-patricktlawler@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 1e744bf218b5 ("ath11k: fix duplication peer create on same
radio") made ath11k_peer_create() refuse a peer whose address already
exists on the same radio, because the firmware asserts when asked to
create it. Commit d673cb6fe6c0 ("wifi: ath11k: fix peer
addition/deletion error on sta band migration") reduced that check to
the same vdev, so a second peer with the same address on another vdev
of the same radio is sent to the firmware again.

This happens with several BSSes on one radio: hostapd adds a station
to the driver when it receives an Authentication frame and only
removes it from the other BSSes once it associates. On an IPQ9574 with
four BSSes on the 2.4 GHz radio, Tuya Wi-Fi devices trigger it while
they are being set up: the firmware asserts, ath11k logs "failed to
find peer ... after creation" and every following WMI command fails
with -ESHUTDOWN. Any station in range can do the same with
Authentication frames from one address to two BSSes of the radio.

ath11k registers one ieee80211_hw per radio, so set
IEEE80211_HW_NEEDS_UNIQUE_STA_ADDR: mac80211 then refuses the second
station with -ENOTUNIQ before the driver or the firmware is involved,
and hostapd rejects that authentication. A client moving between BSSes
of the same radio has to leave the first one before it can join the
second, as before d673cb6fe6c0 and as with ath12k. Stations on another
radio, the case d673cb6fe6c0 was about, are not affected.

Tested-on: IPQ9574 hw1.0 AHB WLAN.HK.2.9.0.1-01977-QCAHKSWPL_SILICONZ-1

Fixes: d673cb6fe6c0 ("wifi: ath11k: fix peer addition/deletion error on sta band migration")
Cc: stable@vger.kernel.org
Signed-off-by: Patrick Lawler <patricktlawler@gmail.com>
---
IPQ9574 support is not in mainline ath11k yet; this was tested with
OpenWrt's ath11k (backports 7.2) plus its out-of-tree IPQ9574 patches.
With the patch, re-adding the device that had crashed the radio gave
29 refused authentications and no firmware assert, and the device
joined its intended BSS 39 s later. The cross-radio case from
d673cb6fe6c0 could not be tested here: IPQ9574 has one ath11k radio.

I used the mac80211 flag rather than restoring the driver check from
1e744bf218b5 because it refuses the station before any driver or
firmware state is touched. I can send the driver check instead, or as
well, if that is preferred.

 drivers/net/wireless/ath/ath11k/mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index ae91b57c8..a7574803e 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -10518,6 +10518,7 @@ static int __ath11k_mac_register(struct ath11k *ar)
 	ieee80211_hw_set(ar->hw, QUEUE_CONTROL);
 	ieee80211_hw_set(ar->hw, SUPPORTS_TX_FRAG);
 	ieee80211_hw_set(ar->hw, REPORTS_LOW_ACK);
+	ieee80211_hw_set(ar->hw, NEEDS_UNIQUE_STA_ADDR);
 
 	if (ath11k_frame_mode == ATH11K_HW_TXRX_ETHERNET) {
 		ieee80211_hw_set(ar->hw, SUPPORTS_TX_ENCAP_OFFLOAD);
-- 
2.55.0

