Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483B049AA4B
	for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2026 21:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792357319; cv=none; b=RvDMGEL5q7ipfnF4VWepbgtM/53kmmrI5I6rU5ouQ5mdnse1Wtqb/ODqWv0r+aNpeCWjD/az/k4WZ3l9bB5AnZnlF5NTF14wv85QOcsL74KOkJNdNJRdcEBlpmI3sXvVvft30Y6P+M4Ko5rwRbaFo5Q4DLZLaj3TSQ0bovPLXpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792357319; c=relaxed/simple;
	bh=1E5iTU5FazhIcF7rD9PxkaayP9e6WL2hr+Dtgh0FYjw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QrxPYZ1irGI28R+CCI/yjv4hCRi+2NWcHOp/1d/j84ZIcKDfC896QRT1zYpwjRrp8Jeou7/W1uVgM8vy5HZHaMpNelIzQYqIy/WQegihuCRmZhN8USphYSXbww2R54Qpy5Otovl6ZyNuazt3qIVm9lmaxZZsAOi3e7JWGLsIedc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=xf2hAQg5; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="xf2hAQg5"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c2dcbcc546fso153701166b.3
        for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2026 14:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792357316; x=1792962116; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=p05I9ZTr0xocFHcXHKxdWxiCmf5s7sTPdQviWKawAQI=;
        b=xf2hAQg5x7sIlyD4ZWv/CfFGZsFumkguLobN2UcY9gYu76rfeDuqocraBsLtxM6h+J
         Kujzma6O5O82SqS7rd/Gwjg/gswVwFZrenHNMaZ0fZDG7l8IBOnN87dIonPaAqxzXyun
         u77cpNcjlHd0Lxa+obgyrDddX1sd52uh00lBcIAXVhP+uYoUvwtzDKHx8M+3JgIsT3VZ
         errILGbwVEtSHWx54b/8lQVZkT04HvpuIkcIyOjgLmOb+Qs0mlTQgvc0ixz4hpaCBYVV
         AOhKcFqcLsQNeL2hr1gvrQz7oXEfL5DO9ZiNclY2oyqJCtWhbYl8THChPOjDCEPouF5y
         gVIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792357316; x=1792962116;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p05I9ZTr0xocFHcXHKxdWxiCmf5s7sTPdQviWKawAQI=;
        b=fpCn570qZ5EKHtTO2GLgXxxvcwH1cEta0NDOI91c8FedR9g1CXbDkvto2p9LvnP//I
         jOaqp+ONX6SpChVzrLdaIq+p+9guePwfaUwHqpF9WLVCipX2HTmWOs/in3tHqrUn8x4H
         90/JX38NhDPQz2jI0Lc/JQX8M3hSF0k0YZBPAXCWSmvUsk/16FFKaNPLHHiUozaDa10b
         58N49VWOcvf5pLbrKPh7sf36kQ6EYSzCqYNBX65FUgZDPVcQwYC9dml8i13u24lt23lV
         Lq2T6bLoH8KsrRLEuNGEbJIxei1x6Dq2zG7HWwSxaYYGZe35V2033IosWPZ3XJHShXc+
         /tEg==
X-Forwarded-Encrypted: i=1; AKwUvBycNGasODY6q/YfaBedVAaR7SuWvVIy7CxiOL04p8kYycNYQjgQYrJDBwk7hprRToDcnkPyeVZ5yLTHiqqAxQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYK31YRvr00i8BYjbImyFSM+pz4PxATXh1dbQTEDpek9zeshQovc
	ByMWgy0sQQUczVFuGUwzBp3ufOW2sjGyYoDHOL30A80xbE2fy2/ZoGTrSgxXMQD6BA==
X-Gm-Gg: AYBFou27Hpon4slF2eK7009ZEtyZ+46A/L2kJd0fduQBoCNX+c+52njx3X2vxhdvnp4
	HT9qz2P0wTehUsMNBTVY58ZBAyd6f5np0f+z4/8oO6GoqAs6PjyWhxvMK0fs9pWb8uFaumfl+72
	pBrMLo1dji9EHppQnzwIa5khnrp9MoZaaZD2GfkOU9i3yKceQn9RyycCHMONXOUiO8NUeG+WaUu
	ihukOp1pW0UBE7EcgJxtN6cG7htquQdTaYF+rkhOvwxjVEbPLbo4B0ZAEGFRqA6NrHnI8/Lfplh
	l8MQohfN2xB3qtjbCoSUnaVrFabSlA1EpmKn9yY/fGy352gy8aBlYxtM6nOgjlws2mMhr/yc3Pi
	pm0jd2SSYdMEj5G9a3EvOxmURgC3iSg/x70N3O84OtI5E++ZgyokYM9E8QaTUtSNAyie8kiFc6a
	jpw1dokyBLZl40LRG+NHmR4+71HQRqyh69ZjQOzriMJtS/b5YkZpXF6Tk+8ZN4+fTlZh12otOA5
	js81+YInytlbnrg8ghBtmU7YtlGTaqSMrqz1TW80Ij2ZloXOEbcJ1gmr6/aH2NV1Nmuse+D7k5K
	ZtZKq9MzBe/kiR4xF64TIUPx+6qq7cjauTqDGsZr0lbKYNsjsL2/b97tIZu1e3wDhMog9/DYndt
	pbwO4myAknH2L60CVJ1Qe5u3wE1xqikZ8aT5JFPHcpnWkNJ9gBmdeFJIo3LBje++uPmd0u1t9NF
	DBeMjK5q+hig==
X-Received: by 2002:a17:906:c150:b0:c3f:d8f2:f08e with SMTP id a640c23a62f3a-c41a01f2fd9mr408627066b.44.1792357316312;
        Sun, 18 Oct 2026 14:01:56 -0700 (PDT)
Received: from Desktop.fritz.box ([185.181.130.213])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c40912cefd4sm291618666b.35.2026.10.18.14.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 14:01:55 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: ath11k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	P Praneesh <praneesh.p@oss.qualcomm.com>,
	Kalle Valo <kvalo@kernel.org>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	John Crispin <john@phrozen.org>,
	Sriram R <sriram.ramachandran@oss.qualcomm.com>
Subject: [PATCH ath-next v2 0/5] wifi: ath11k: firmware crash recovery fixes
Date: Sun, 18 Oct 2026 23:01:48 +0200
Message-ID: <20261018210153.1925962-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Firmware crash recovery on IPQ8074 resets a waitqueue under a sleeping
WMI sender (1/5), frees radios and ring memory still in use when it
fails (2/5, 3/5), sends on rings it has not rebuilt yet (4/5), and lets
cfg80211 commands crash the restarting firmware again (5/5). Patches 1
and 4 are v2 of the series linked below; 2, 3 and 5 are new.

Tested on IPQ8074 (WLAN.HK.2.9.0.1-02146) with the firmware assert from
debugfs. Without the series, every recovery reported list_del corruption
on the CE waitqueue (6 of 6), an RTS threshold loop during recovery
faulted in ath11k_hal_srng_access_begin() (3 of 3), and after a failed
recovery the next crash faulted in sta_info_hash_lookup() and rmmod in
ath11k_dp_rx_pdev_free() (1 of 1 each). With the series, 12 recoveries
(5 with the RTS loop, 2 with beacon updates, 2 after a failed recovery,
3 idle) showed no fault or list corruption, a failed recovery recovered
on the next crash, and rmmod and reload worked.

v2:
- 1/5: name ath11k_connect_pdev_htc_service() and ath11k_wmi_connect()
  (Baochen). Add Reviewed-by.
- 4/5: fix the recovery ordering instead of testing srng fields in the
  CE layer (Baochen). Drop the ath11k_ce_completed_send_next() hunk.
  Fixes: the first driver version.
- 2/5, 3/5, 5/5: new.

v1: https://lore.kernel.org/r/20260805192129.61113-1-julius@bairaktaris.de

Julius Bairaktaris (5):
  wifi: ath11k: initialise the CE descriptor waitqueue once per device
  wifi: ath11k: keep the radios when a firmware recovery fails
  wifi: ath11k: keep the srng allocations when a firmware recovery fails
  wifi: ath11k: clear CRASH_FLUSH only after recovery rebuilds the rings
  wifi: ath11k: hold back WMI commands while the firmware restarts

 drivers/net/wireless/ath/ath11k/core.c | 21 ++++++++++++---------
 drivers/net/wireless/ath/ath11k/wmi.c  |  5 ++++-
 2 files changed, 16 insertions(+), 10 deletions(-)


base-commit: cd026e68fdbf88b9cc522b76c7a9d92c9a41f709
-- 
2.53.0

