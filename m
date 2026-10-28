Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793197072;
	b=0GUBwmJgWxuxZdV94wjUBoThgYEPFLigz1SEc85F1JWb+Huq/zGVafSpwZtnubCP5RFG
	 XtkOnmHfD36BV8GXjqSHTfQ2QleXNJ3uTzuDtnRh6jlrAJXQGmk9GyYhovblTmWgsd2MR
	 MUh3u11DM8EDizmgAWxC8uaddCEfk4qC9RP0xb5UNd15DE9eGddO9IC+eGtclfGLmSQ5z
	 /i1YJKfksmK/wkTc7MwnZ7cajC861i08tIcu+vg2F96ibRnP1225WLfJau9M7z+IXnGg9
	 IYKYpQC8xupijbQuWx/SOTITKJHeMY+j9coJ/IrdvWLo1GbI7L/5oTMiM8U9qq+Q9Rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793197072;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=TQGM9otKFbe0v/ZMqO3QRr7VPtgpLnjAfvMxrL4LM9E=;
	b=DKrPZJ2d3sIlOPEGkXBI4gP1cElcVvL4jvPdpsS0tieIcczeweEKHKxY7s7pguK+uApt
	 xkYKvT27THP6IxbL3NRua8hU+WhY06QXlDnTOFtW5WcWqjXF/YCM6/xK6kV6ugccHx1ns
	 pjIKGr0eusydeZV5gIVwj87v+Whnxaf7S5LcquxUTbsrV9mcaGxdy5jLYtX9qw6UcVxTu
	 FQUhHrr9PFzb4crR7upmgTbRX7/A/99QZovTnlNZH6xyA9V2ZHqveSa8YyjX8pGCBFy9T
	 4qbpgUs9ooVFsoyz7M5k0AmuGNaceG9bTwXEBBFQHrOq3pVabDexHc5pHyUuDH6pu4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tpKoM6jp;
	arc=none smtp.remote-ip=209.85.216.41
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99537606A320
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 14:17:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99537606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tpKoM6jp
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3856d6fbcb3so620520a91.2
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 07:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793197071; x=1793801871; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TQGM9otKFbe0v/ZMqO3QRr7VPtgpLnjAfvMxrL4LM9E=;
        b=tpKoM6jpGJRdzPveFMYHzJVSbJ48ERnNDwLSEnp9gQ+hLWhvyR8YDV1noTRZL7W6zt
         ZoJRmhMyMfBLdppluggHtQPzYwLnN5El+UkWKxSTjL1A5ui+C99UhDEvpczuZbmV8kzD
         3l1KvipLcIa7+yICyE8Pi694UyQtglAfGBwOEbD0+S5aJV6IJ+0XmQEB3sUDgBSRHLnw
         t1In+xUy5j6IjFGUAgFjoGEb9H3DhbC6mB5hmo67Zzu4iEEGesct/5g248hu04Nm3HEq
         NCPAGhX+atRpuHybq/BCkIcNTYBuDM2R9P81c8FfMeEwPzZ93Uc6LhAqEqLsSssBR6kQ
         VsyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793197071; x=1793801871;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TQGM9otKFbe0v/ZMqO3QRr7VPtgpLnjAfvMxrL4LM9E=;
        b=wKRWC0r5vS5Jom45ixelQbraQoV2HyO1b8S1htSb9mkcH7/3P8Rw9+1L3lKqhj5tdT
         gjHEK2IYXLob/K+g06HIQB56W32GH6LwZDNH5ICpRkkEdWFhwo9bf32sNrwdMA4mPvFP
         ds7zS8a8OWYA3aeybTN/w7N+wRB4htgdyqz8N141Qm8xGbbZ7T5/hyW0990F4+XY6tRJ
         YwrvaZc10xhL5nyAVqP7LTEdmU5prXTIWxcA/xaBawi9xHUdHUCKvpaXLL8Vkj5ccJgO
         B4+AbVvhneAa8wmlZYbOznt8N9KKVsps4LhDSeEFe431xLo4Mw7mXeVmzZEdisS95Pv/
         3zeg==
X-Gm-Message-State: AFq9FYJ4MoI2zPwUw+0AGx1fY0QmZzddSwz2j8CPaMy7eDedLWhgHaye
	T5AIF7mx107iuxwV9nZrzBBNgmAu2QnZxInDnJEEHroJCDgWNUh+eQhW
X-Gm-Gg: AYBFou0/G7jz0vAHAqgrrNSG/afAZ19i+qq26Z/259q6GyLOXNYqD0Ussiw2XfGVeAD
	4HZNKW2UNF64xUQbaXpb7QDv8LkEx4AtMQM7kOclS8FDHjCRb1lbiRRHj72XVe7Ot0siAyresMH
	Y1t86cOoE8c6Q9EMNj8CBYR8DrKoIktlRPlu4SCSP52qZ4hoM6iiP8l6726tDjx+de8nIl1l+Uq
	MmT29wjG42M4qZcfn9M+A6PcutW4sKUXMPvem6gByGSgo6axqjqjNk8MIHzK4JEN+rcYERc6YTV
	HKA2FK/IWaXDY4dsD/9CdgFLzZ1h9iUGtVbA8N6P0TVd1oHmUvge9dezEoU3UXTPWUgUiTi9Ue7
	3usXYn4SnsI5DdCqEKlT6fXd+KYdhlzLmJf8GGRfwJnHbwzMd+02zy1n3bkoSpJPxsGp3WKuzu1
	ThQc7nXSQKqedFgv4Qsr5kAn0BHPhdpOkQFHF7d99G2ISFHajSQyGWZAelyp3yC/Csfd9uutJ22
	rQ4Vta/ZWhgrSXgngb4dNAVwJ8zIgHOGWaaWtTfs/5wW8w4tBcYB97oVHTDjBiGs8N6bmIdxhr7
	hYYo5gFPOCF7LjiWMvmrfIBBMIO9f8zsNfFzmoxdmWY67nrsfvlyPpKSXogzfqyMDezUTA==
X-Received: by 2002:a17:90b:4b0e:b0:3ac:85be:cd56 with SMTP id 98e67ed59e1d1-3ae57f9b343mr1819072a91.12.1793197070417;
        Wed, 28 Oct 2026 07:17:50 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae5a5839besm3288028a91.11.2026.10.28.07.17.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 07:17:50 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] wifi: cfg80211: release rejected nontransmitted BSS reference
Date: Wed, 28 Oct 2026 22:17:31 +0800
Message-ID: <20261028141731.6185-1-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.56.0
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

Repeated MBSSID reports without an SSID can leak BSS entries outside the
scan cache, where the BSS entry limit cannot account for them.

__cfg80211_bss_update() returns a referenced BSS. If adding it to the
transmitting BSS list fails, unlinking drops the cache reference, but the
caller reference is lost when res is cleared.

Release the caller reference before discarding the unlinked BSS.

LLM assistance was used to find the bug and review.

Fixes: 0b7808818cb9 ("wifi: cfg80211: fix BSS refcounting bugs")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
Validation: A W=1 module build with MODPOST passed. In a QEMU
guest, 20000 rejected BSS reports retained 589--594 bytes each before the
change and 14--19 bytes each after it; the transmitting-BSS reference
ended at 20001 and 1 respectively. A reproducer is available on request.
Sparse C=2 passed. Targeted Smatch introduced no new diagnostics.

 net/wireless/scan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index d35c826c4b1a..36f8521f8d60 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2452,6 +2452,7 @@ cfg80211_inform_single_bss_data(struct wiphy *wiphy,
 		if (cfg80211_add_nontrans_list(data->source_bss, &res->pub)) {
 			if (__cfg80211_unlink_bss(rdev, res)) {
 				rdev->bss_generation++;
+				bss_ref_put(rdev, res);
 				res = NULL;
 			}
 		}

base-commit: 25e73f1d6868c759c8eb56cad4e411692c5341b4
-- 
2.56.0

