Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD900429003
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 08:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785315467; cv=none; b=JXSS/Is+WIeSW9PypBB2OA/L0FxQpgy/AMSjLrf9c7u30f3jsVnycIfkGUFNnpkuB3/HDGS3S5qicOUDX41FPouqhw9cadAvTCI5mLISG3Hd+dGwvlqqJMvL6YOgGU/yrVueBLslXQcAUFe/SH+FFW/MjIFoPPKJtUCqAJN6N20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785315467; c=relaxed/simple;
	bh=LnrIl9n8Waw67xWX/ez9Lp1twG5ExZPatFbFQOgEmsk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JtnPxMVw3H2c95yGwx1A0IUVCEb/rYHdmJbpTtZdP7deCCrzoVlB2i/qzZm1Sg2CY6RadiMO92fdFRYDHPC/HE+JxmwUjlko8/mOTfnOzwP/3xhy7EOiZbCQ/bX6KdjnUIcFmh2Jb5cVgBgTt5skKKTwqtxMoCGFdI+Dm/YZziI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DZ4l9eq8; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DZ4l9eq8"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4956869750eso4880745e9.2
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 01:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785315462; x=1785920262; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+tWtt5LHOZ3EZZG9CR6BME0z+/0CE+s/sYD1S1X5wvU=;
        b=DZ4l9eq8KOi553AJVIB7Ypp6TtMIpf7kK4GaH4LgHG/+u8ONtVkoVbEw/pPT5nyIED
         rABF6Q6l+Ap4xKQo+3pO5oaBNX9W1k6hsFoDtzYuWwTnJGK/8KsKQhW70RquTSfaAUGt
         ngVW4s9A7lctz+GgmP0uhAqWSSVuheDzVLzx+SKTJ3imHopxpvd5JzS1zgk9wfcfzB7j
         zTcOHJhxR7DHoji8fsCqfkoYfNFC8OT6HUGwaNgd8Jp9TJWIaYQ5dQPrF8gu/jD3dRwU
         y1n3sLGxsJ+DbxS3dOujv78mwyoP2HzAH+h9xvO7uYUSsf6Bjd/VNuw8NOW6XlO+Cvrh
         lBAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785315462; x=1785920262;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+tWtt5LHOZ3EZZG9CR6BME0z+/0CE+s/sYD1S1X5wvU=;
        b=U/Bk536Y+mlZFvHWpAOjmKhFmX8YFuK+eYxywPt4dhS7vag+Gxj5GHkns0KktCi2c1
         uLAsqw8JrAaXsCvrJkHp3j0kHRJM7a5L5Os4mmfCF6kUlgdXEoW0sEtBkA8RLJPLr8Id
         nx4kK0HfXIk5Gq2zvj/wHvX5qj3gmmRUuoHIXLV1XqSrGheK3aCg/23gTWdKJt52yjqu
         zdFGJ6X/zyIZ3k7aFdNSuifaVOkTnitc2lUmffgYnNRPQ9qS6jKQwpRBfyVmh5Isnrsg
         ToEbZrE7YQThfRl1oxBcwrj7edeHWU17icM+pLqKLZl0OecpU7Itu6Jv2mVQNr/UaNiS
         ADYg==
X-Gm-Message-State: AOJu0Yw7wjghi2umn5/6oMJuyh+V1pax70gPnV8oTzHu66nT7DndYCMr
	KgaCDiIPT03m22bLowTmmKlpb6EtPiAoT4MkGcyXvaI1LjxQVQXvG/sK
X-Gm-Gg: AR+sD135KmSs6aXDxHp7zQoRMleMQG547NalQIqmA5D9Ny0FTcdT0+UNutUfQz52hrX
	3JFYo3rvKJavsKQ0JfXcFJ8AMg0SId701vz726rsRHY0Igmur2qC1pYOJdhKEikd+aGZgjKpALF
	QIPR/4R46XBLgKulbI35bXmv3kCf6ENSXkKznhxEXCSLNNAnSD1kalvWo1fep4mXWE7VCVj+sP6
	oWlFzHJgwB6FmFJEPPTniqk2jPg7SrMNYddSvrX9w3945TD4hV5RwR2UJLh9A6hpY0Zv2KUldS2
	dNmKwKCjFavxjgLd4W7xpe3zu1yvZjw//BCftkn2WVs2cZdXpO3/cbBbuPnY4tNzouBoLU6PyIA
	lnDtTfuoaqlNHMUNcu29Mu3xKAsW1f14HPeQdGaJ1GYA5stHlyP25nnTuvJkUMRtZbcG37qGN4f
	Xz9CUxO8ygHhsy+OnL44FurwtCkrD5ovLKjbvUaKvkWEkMylRoN1lAMudVKtwZl3eyRKySfolXm
	+EaDNpF83b33iMyXgwIAg==
X-Received: by 2002:a05:600c:46cf:b0:495:699:84ca with SMTP id 5b1f17b1804b1-496c657391emr64189195e9.28.1785315462175;
        Wed, 29 Jul 2026 01:57:42 -0700 (PDT)
Received: from syracuse.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496c45b1c2asm138614115e9.5.2026.07.29.01.57.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 01:57:41 -0700 (PDT)
From: Nicolas Escande <nico.escande@gmail.com>
To: ath11k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Maxime Bizon <mbizon@freebox.fr>
Subject: [PATCH ath-current] wifi: ath11k: fix locking problem in ath11k_dp_rx_tid_del_func()
Date: Wed, 29 Jul 2026 10:57:41 +0200
Message-ID: <20260729085741.3485711-1-nico.escande@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Maxime Bizon <mbizon@freebox.fr>

In this function, we iterate over dp->reo_cmd_cache_flush_list using
list_for_each_entry_safe(), and for each expired entries we call
ath11k_dp_reo_cache_flush() then free the entry. As this can be called
from multiple CPU we protect for concurrent access using dp->reo_cmd_lock.

The lock is dropped to call ath11k_dp_reo_cache_flush() and taken again
before keeping iterating over the loop. That is broken.

The list_for_each_entry_safe() protects over deleting the entry being 
iterated over but does not protect for concurrent access. So another
thread might have taken the lock in between and modified the list, leading
to a crash (see bellow). 

So fix it by restarting iterating over the list from the start once the
lock is retaken.

	BUG: Unable to handle kernel paging request at virtual address 00000010ddbeef8c
	Mem abort info:
	ESR = 0x0000000096000045
	EC = 0x25: DABT (current EL), IL = 32 bits
	SET = 0, FnV = 0
	EA = 0, S1PTW = 0
	FSC = 0x05: level 1 translation fault
	Data abort info:
	ISV = 0, ISS = 0x00000045
	CM = 0, WnR = 1
	user pgtable: 4k pages, 39-bit VAs, pgdp=000000000593f000
	[00000010ddbeef8c] pgd=0000000000000000, p4d=0000000000000000, pud=0000000000000000
	Internal error: Oops: 0000000096000045 [#1] SMP
	Modules linked in: ath11k_pci XXX
	CPU: 1 PID: 1775 Comm: napi/-29 Not tainted XXXX
	Hardware name: XXXX
	pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
	pc : ath11k_dp_rx_tid_del_func+0x164/0x3c8
	lr : ath11k_dp_rx_tid_del_func+0x2a0/0x3c8
	sp : ffffff8020c2fb90
	x29: ffffff8020c2fb90 x28: ffffff80207ae910 x27: 0000000000000080
	x26: ffffffc00861ebe4 x25: ffffffc008cefb88 x24: ffffff800d701b2c
	x23: 00000010ddbeef84 x22: ffffff800d701448 x21: ffffff8030e22d00
	x20: ffffff800d700000 x19: 0000000000000080 x18: 0000000000000000
	x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
	x14: 0000000000000026 x13: ffffff801958a100 x12: 0000000000000000
	x11: 0000000000000001 x10: 0000000000000001 x9 : fffffffe0081eba0
	x8 : ffffff801cc49300 x7 : ffffffc008f87130 x6 : ffffff80207ae900
	x5 : 0000000000210d00 x4 : 0000000000000000 x3 : 0000000000000000
	x2 : 000000010024519a x1 : 00000010ddbeef84 x0 : ffffff800d701b08
	Call trace:
	ath11k_dp_rx_tid_del_func+0x164/0x3c8
	ath11k_dp_process_reo_status+0x1d4/0x2fc
	ath11k_dp_service_srng+0x334/0x338
	ath11k_pcic_ext_grp_napi_poll+0x30/0xc0
	__napi_poll+0x34/0x184
	napi_threaded_poll+0xb4/0x1d8
	kthread+0xdc/0xe0
	ret_from_fork+0x10/0x20
	Code: b946e2c0 7101001f 54fffe29 a94002a1 (f9000420)

Tested-on: QCN9074 PCI WLAN.HK.2.9.0.1-01977-QCAHKSWPL_SILICONZ-1

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 8e2abc7b8383..b8f939f7c04b 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -784,6 +784,7 @@ static void ath11k_dp_rx_tid_del_func(struct ath11k_dp *dp, void *ctx,
 	dp->reo_cmd_cache_flush_count++;
 
 	/* Flush and invalidate aged REO desc from HW cache */
+retry:
 	list_for_each_entry_safe(elem, tmp, &dp->reo_cmd_cache_flush_list,
 				 list) {
 		if (dp->reo_cmd_cache_flush_count > DP_REO_DESC_FREE_THRESHOLD ||
@@ -796,6 +797,7 @@ static void ath11k_dp_rx_tid_del_func(struct ath11k_dp *dp, void *ctx,
 			ath11k_dp_reo_cache_flush(ab, &elem->data);
 			kfree(elem);
 			spin_lock_bh(&dp->reo_cmd_lock);
+			goto retry;
 		}
 	}
 	spin_unlock_bh(&dp->reo_cmd_lock);
-- 
2.55.0

