Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793254174;
	b=usQYN1r3Eb9a6nMLyertTY7K6QCeXwBYeZBlszTBzeJGlc5isB2nlU20ce6zvRm398Ml
	 UO6y/YArPSa1dnbuIn/BniqOC0Z6o/9uqPzfBfCt0YGpyqxjmucfTwBf2DgxaA4yqYPyZ
	 qWK7oqNOimL9pgXvL3wXR7A7bEYMtZ+PDMSEBUIID7iQMqI4iof8OG+nz0W78fuynB2ZD
	 sWgMK6zImQ7DKE0oeLrCnWCnl8WPGIPHyCOeIUKhkxTHAhqKAl+ATGx1MRbIwdrFNeGvp
	 VuIC6BzsbCH88iV1JTj+9ggbWNa7hP/dbHcDefAHr4OboVhcrggZD5443poXzbK+LGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793254174;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=YCPm+iCjwwz/etWInAbqD6BxLDrRx2vPQrublQewzII=;
	b=IR/no3+40WbHNNQ7nsf0KfzlgygAYyPZc3ZxmlhCKndOGtwW+MLgullFE9E8QXEOvbVt
	 SqCTEBj4xkPfqUIHdRoNpxsEIedhC6yni7Y3lm6dxpSWA7HUr/D0Bwgvr7KMCtXTLhUQY
	 s16BmlxQyutlHicwBi6pwuvdCFyEPQo5r0m1Z1wdDQ9esM34emEG2acGV1fXyC5v0FKIN
	 3yxe/YYpgkiNHANBiUpORaBfHPjKafkiw/OPbWOAGj73/z7tenTHToEUpoFgHmW/lGaMS
	 XoNhrzS24lssVjOHuhWU0XW19xC+/yDgGEuHJmiOdued41kxS7EVuFQmp3s/UQTWdEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="w/seO13A";
	arc=none smtp.remote-ip=209.85.214.177
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93C7606A31C
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 06:09:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B93C7606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=w/seO13A
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2e8b20a899fso12136235ad.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 23:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793254173; x=1793858973; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YCPm+iCjwwz/etWInAbqD6BxLDrRx2vPQrublQewzII=;
        b=w/seO13Anx4lNG1V9PLBvMyfBwZXco/lhaGEfzXQUuqo0s/VUn5D1WSGDvw5GZGqdv
         cRgqDV4fmbFJr7mgWYoNRBLA5Fs02FHsvkdsEuxMTCyYM29F1EtAnfam+R0FO/+oNGC5
         zR/ypedoZEnyd9yPaYwEDT0/6TIa6F1iaT0rCuSaDd5v0mTGMm3lnMVhZWOKSbAg5AEN
         r/CAOzUW6P2nbtPTNqd+Zzjbt9svBfGJPyntSX8m0uiMyPPe/1B84EyPauL07w4FhRXh
         SkV7l+/x89Ax+ePzULLNjQ8LHc3JZnYeLsays3JnLyG2voTMCVTaoCb+k+lF9ZUBwxC3
         3rNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793254173; x=1793858973;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YCPm+iCjwwz/etWInAbqD6BxLDrRx2vPQrublQewzII=;
        b=SkAzG7Aw3O3IUHcvz6HzlllD5xkZ23iZLD+DFDk2gsRD+UMKYDsCaUhDlDP2ASvNkZ
         t1oeZr5fgLWfGvEpL2sgmBtElrVcpCGJxG5P9G6LFTrIkUjxpmFZrN7LqXpengL5qSep
         DJ9R9gSrlkVMQnto5LvqNhiXyVUaT1EB8BYDU9OTTO+Lh8+c2uAOxHqddd3ljb8eMuZx
         mwzP7/yZ2W4J+ovXzryulFWCragIs26KMDzrqjPp+yeviKEiyvsBIZ1UDtn4Wi+x6l2h
         5ZAHDqHPe0GgY3lrsXdC4PljuAe5fCSpK8c3jouizj4WCjTN+xzCbP4U3no39HyufIfI
         +wPQ==
X-Gm-Message-State: AFq9FYLmAM0663sFnvo2F6dKRvPZnQUCIyTzUREmx/OAKeh1bCu0m/oW
	aWIhkNdIh1DY1pwMcpOruZPBaESPeqhQ37iNUQaziF7EouEHGcuRq4Iu
X-Gm-Gg: AYBFou3ibjRn4EiXRdE6DgFwmdIBDzTRx7vz8O8NI8D0D4IuF+FN3Gblo7JmYUyogNL
	ghC3OyWxyzRZnOyTdeGXJNxWHEVu2HL0+02qe1b7uuCfKspevof45zoVv9+zExaZcWqHGrgqh6Q
	VnxvdCOFDHL+xGRXnqF3rlbaekqJI4Dedr55fyC40XMclUGvedsKutg81ydKHVDvtxnEXVzc4TK
	zIemqZHtXqGb82C4ozwT32N0whSx5K+YGtXcHLRHRcHyMhnx0G+PnJ0sLqVw+lL/fokU1F3gvSx
	WZySuRkAhaQrw+RYP5CAFGE8wtx+Z+xFUOF+/DI11y/+SyjthHjEYz+dk5lgwc4x9QZDJhfmyKx
	8/SRUshdw8GgXxNA+T0F/xq5Aygukywt3+Nfdv5omW2adAwyoX3kQ/8HxHCKb/zRU0Y/5qusazF
	8lfveCWt+o0iEMESxwTfYJp9X1i4El2CsjN1wYBxFT8PI3wbug/xEatrm9eUTFCUkTEm3+G66LF
	OLV8VTbP4DlaivSiy6FxmECKlv61j+1q3cJlO/RG4BIOI4lHo21LfTaEYRsLH8IYWs4WlYBMu4+
	wR5+PHmDn3MqM0Xj/gs3HhtFpdeOnl18Sx+fqsYdev9wZcKPl5wcskl4FXdtfe5ZbG4fmjirDxD
	fhB+9WX+Zuce3SzmzbhYyDkBYrg==
X-Received: by 2002:a17:90b:3c0d:b0:3a7:ecab:c4c7 with SMTP id 98e67ed59e1d1-3ae581d6ca9mr3629224a91.34.1793254173037;
        Wed, 28 Oct 2026 23:09:33 -0700 (PDT)
Received: from hostname.tail4fb79.ts.net ([2401:7400:c804:b668:65cc:625f:9c43:1e88])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3ae6e83a4f1sm2697459a91.12.2026.10.28.23.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 23:09:32 -0700 (PDT)
From: Ho Jie Feng <hjf3108@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	Ho Jie Feng <hjf3108@gmail.com>
Subject: [PATCH 0/2] wifi: rtw88: keep driver-owned buffers out of mac80211 TX status
Date: Thu, 29 Oct 2026 14:08:55 +0800
Message-ID: <20261029060859.90002-1-hjf3108@gmail.com>
X-Mailer: git-send-email 2.55.0
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

Complete driver-owned transmit buffers without reporting them to
mac80211. For USB aggregation, report TX status only for the original
frames, not for the aggregation buffer.

Tested on RTL8812AU.

Ho Jie Feng (2):
  wifi: rtw88: allow driver-owned TX buffers to bypass mac80211 TX
    status
  wifi: rtw88: usb: don't report the aggregation buffer as a frame

 drivers/net/wireless/realtek/rtw88/main.h | 1 +
 drivers/net/wireless/realtek/rtw88/pci.c  | 6 ++++++
 drivers/net/wireless/realtek/rtw88/pci.h  | 1 +
 drivers/net/wireless/realtek/rtw88/sdio.c | 6 ++++++
 drivers/net/wireless/realtek/rtw88/sdio.h | 1 +
 drivers/net/wireless/realtek/rtw88/usb.c  | 9 +++++++++
 drivers/net/wireless/realtek/rtw88/usb.h  | 1 +
 7 files changed, 25 insertions(+)


base-commit: 9b0be45d4d52fd223994e151f169743a97abd290
-- 
2.55.0

