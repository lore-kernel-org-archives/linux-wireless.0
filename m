Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793891091;
	b=iyHD26f5wzK6PPs4WjbtAg3LWSjM2f7+G93st2SNr6E9qRCm9Pc5HHCD2UUCLE6BtaE/
	 PYZvvzodzEzTliQSU+1LWyVTOaPxYSVU6F2yl825ssuxIp1RptRgYLudhwZ+ipf2yyMDO
	 /3B3oFoqA5euHKmH9DUfBl0PM32RQFOCjWCHnz3zlNzCU0turq8CJMyveVMimy2nIqAiu
	 0JpsuDlEGTUGnqaE4T4CJzLXJ2jOj7dfm3AJ3A4IASDymB+Mh21Hmdw2HGJvbfP0N/NzW
	 hl2puTRR/MA9wu9XWv7/kezo2zQKD3zjB+4v1aoR5lSgbqWuOxs4fH2CEeirGoxlHiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793891091;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=bfpdbUUIX16VN5mCBIU3OZ+av/8U5ZQPuLtnxoG4U/M=;
	b=zZo0qRl2Wj8Ip64auf6Aj7mu5ANaPFABLol9gvKqyzFL1R+zrbRTiB3Or9opQQeEAkR0
	 H0DE6WThicHAySXiqCZJ3t/t41r7rVJx22MRoCCn70hm0DfPS/KTEjgWUFCmOoVywwALr
	 DypYtAl+JNQTKgTH5tYnfRxDGikEZehucoIBr90WlQUF8BIk507qSyI38O79g0P9L0n7X
	 6EbZg1TMaFY4OrXwuuVHGual2FoUf3Et5ufKNup3T1p2Txj0EgEoxm4NVzt3qKOuhlT5H
	 QP47NbcSkzoPkcXvuZJENXbDm2DrLVlfNqzC6X7m7P0vK+LgADETVayIo1zlsFsMN9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bzFOeGay;
	arc=none smtp.remote-ip=74.125.82.170
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D498606A31B
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 15:04:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D498606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bzFOeGay
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-36d6765756fso2341537eec.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 07:04:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793891091; x=1794495891; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bfpdbUUIX16VN5mCBIU3OZ+av/8U5ZQPuLtnxoG4U/M=;
        b=bzFOeGayjr/M5InmbjnG+mZzsQJNJyGjTjP8LVB8WONzHZ7oSs8qa0N9nw2STWV8bi
         0yCpaqQA1Kr363JXv1yq++tKnGLSMxNrzMyCdn9zWauPDQHW4/1nDqrMFhEDNaDYWgtC
         gClU0IA/e8md0gpkNY62b+BeH2ZOH7xEIX+c2PC6cRif+rdndbxt5zC43niNl0WWEjLs
         lxq7dKIJBSFtulQKRfKN82gMNktOjMsfhbze4OdtyKgSNDM+2duIwoOPPDxEYlK2Us5o
         Gc2tEf5oF8IJuOR/HqVT+KU/2PCUDPkRmXWRAYrN4EVE/CoS4bBq4xQ6LXl5wsFVxFsy
         JPzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793891091; x=1794495891;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bfpdbUUIX16VN5mCBIU3OZ+av/8U5ZQPuLtnxoG4U/M=;
        b=yIiBLA009j23bnKMggzbW6LtQsp6QgQjn0zz9QZR3o2GM+EVgb5XR9H8DmsBq6vwtU
         uRh/NI4Pny4XXfgMV5Ll8uLb5/Fxp0oFKNT1psalTFTqtXhohTqUV2UUt2jGAlirI6iN
         agTRLCfPnfKsiNd4jjqGBMqlx6XK0JsMbQavyj0ny8OKrsRa47EN8MPIlXZd10Plndyk
         RgQR/hfd6AIE5/69RICPtwN6G+dQcDs05SLpB+lYErWLMqkG1OgRIrKWhpJdA6Ff7Uw+
         Cxuh3lB7+yKjWcOw0Zh8BPgXU4SQ5x7ZpCWj6z7muQoxnjom9NvFyPFW5JvwOazzhPJZ
         VPWA==
X-Forwarded-Encrypted: i=1; AKwUvBxCZ/vcejmFW+u4SwuOCmgepZv/5YzEdgYATw3AaErWqafIq4qfuSDlyr6hmxOvZgg8UrLTlmoBgEoydKRAkw==@vger.kernel.org
X-Gm-Message-State: APuU4Z/iRaJuokYeeyKdArJ9qL1EfBlQBv0599YKPxxJWsP+Lta0Rz3G
	WAY61Twd+tPi0PeD9uj9p0Ev4o6zaTg+oRjDgCD5VTOZQAGGRnh0OZ3OvGsv2iwGM2U=
X-Gm-Gg: AYBFou3biG/QAGIRN6dQFRPfOwDn+WkD2uqePNQcmixl54ATAausutgAyHuJOMpz6ZP
	804wQ+PAX2P2i+sb6tfdUvfa9scVzqoIPmE7X0jA4mF5E3cm3wXwm9BAE/k4KOvpvzh5Rkya4Bw
	PyhVisTkD4OAuDQuX3zOU5CHesGm7bSk69o+xBUUWzYR+bvBjFxyl5L8qE+vD6diP0JoC0tV1i1
	8zfvfNHD1tGgOAm4+EJ1zrnuVIcNhxAFTIGYITEH/YLXtdcxBsfCNxP+eoPjjzesUVAgrm5wRQs
	fJakCSniJ5Th697/NXREUbEwRgppIrfZTSxzkfuw2qUWuvPUVTfm1V3oqZo2SOBtWNMLAkdEjNg
	Gpr6N7nX9KI2epvviE1NhyeiAc+j8HrQyZuECDazuRKzl4qWNHreDjNe/2ovK6Kxq8T3KCapV4e
	RjyOcm2MnvkrQKfbH7miuRvfTnCVIn99Mq586ULE/s3nj/ByCPIdSeaIWWl1Sx+VfwluWMomtGz
	XvcH+CLXfFUweG6TuBSEJqMRuNZhxHd93FBsI0AiK3jCY4yqIrIIis0yo3KvaJ6/6KTrUGddJjT
	UA/SotccuCZydPxkf91O4deWG23R8n8AacB84qC/gqaQqhB3oWm8IQ==
X-Received: by 2002:a05:693c:4145:20b0:36f:551:2bd5 with SMTP id 5a478bee46e88-36f05512dbfmr772632eec.32.1793891090524;
        Thu, 05 Nov 2026 07:04:50 -0800 (PST)
Received: from Anonymous.localdomain ([223.181.63.167])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36d34d5960esm18325064eec.5.2026.11.05.07.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 07:04:49 -0800 (PST)
From: Hussain Sitamouwala <husainsitamuwala21@gmail.com>
To: outreachy@lists.linux.dev
Cc: johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hussain Sitamouwala <husainsitamuwala21@gmail.com>
Subject: [PATCH] wifi: mac80211: remove unused drv_offchannel_tx_cancel_wait tracepoint
Date: Thu,  5 Nov 2026 15:04:33 +0000
Message-ID: <20261105150433.10816-1-husainsitamuwala21@gmail.com>
X-Mailer: git-send-email 2.53.0
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

The drv_offchannel_tx_cancel_wait tracepoint is defined but never
used. Its only call site was in drv_offchannel_tx_cancel_wait() in
driver-ops.h, which was removed by commit b4ca6084a84d ("mac80211:
remove offchannel_tx API"). That commit left the trace event
definition behind.

Remove the unused tracepoint. It was found with "make UT=1".

Signed-off-by: Hussain Sitamouwala <husainsitamuwala21@gmail.com>
---
 net/mac80211/trace.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index ea46c3cca21a..f34d079f3d38 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1472,11 +1472,6 @@ DEFINE_EVENT(local_only_evt, drv_tx_frames_pending,
 	TP_ARGS(local)
 );
 
-DEFINE_EVENT(local_only_evt, drv_offchannel_tx_cancel_wait,
-	TP_PROTO(struct ieee80211_local *local),
-	TP_ARGS(local)
-);
-
 TRACE_EVENT(drv_set_bitrate_mask,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
-- 
2.53.0

