Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F219438C406
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 07:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788939092; cv=none; b=dSxNhIleXuczpYFfwJD4bdgIAU9dpRN9ocEvWvBTSA62wdwA6Yap0Mkp6LkF8EOuDSD+324kfXw6BqgfdLcVqhSdK/BgTGrtT+pvRdTg+CZk7a6ckSZBCwN7Zx+pDZsylPhk9utB/McCHOgoP8AQkI1200hilGvbYJc6xVQLqF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788939092; c=relaxed/simple;
	bh=bCusDzs0q1We6S07HBbp5uRzympFoZljKyTe9myO0MA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NytUA2gC2adwZzdnRFeS3tncXp54ZIEsyculC7O5K4hlH0DfZxgxYW4TVxHxIINZMtWr9EkjV1QSv/XsRholRKU5i3Abq16usPCyLb+Gj+ksuS0ch9aRNbM6FerAoLxXj+jDOd1vsExbEUjHE2+DvDsvkXFIyWtmKTZ4kS4LwnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=sSuEC7qR; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="sSuEC7qR"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccafb74fso779601a91.3
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 00:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1788939090; x=1789543890; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GF5Az0SsfYV0xndvc6khwcqNiKli3zPQvxWo2uSN5Ps=;
        b=sSuEC7qRafPgNz/C83jzIKDRu3BCDKnlxvjnOvQIetSvQgo6dfADGCBkGvaMc6WRIC
         +VaMCpfbxgX+V3zHDnV1IXylVrgJroPRcpdhUjGV/5+gSesvU0mXCqFAmXkTtKU3Xz3k
         9RlRIoRKXtDBSBIaS1em7ZRUpQG2kXCUEAnCSjdRRO0QsuGcpP4x7mpDm/CjRcatoMKP
         B3VoC6Q5vdnNNFTUaRa8fWOi7Y7u+mXJckry38lTAI8TjmkqBHWaSkI67y9TaCui7i/s
         Qu4H8jQNwxlgdUuRoVxWPNdW616Epq+K/Hs7EFH2rUmoMKana1pbeNxCzn8KtznMUHpX
         IZrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788939090; x=1789543890;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GF5Az0SsfYV0xndvc6khwcqNiKli3zPQvxWo2uSN5Ps=;
        b=q1Sxx5/sGwPHkZEFCpXXkbbbj6PLajLveVsZd+O5S9eK6putjdNd/BPlHxRZ4zByZH
         eysbcpHQsJ1BJIJrwJeEONO1X9Ck1I1fjiryEnT4Qs443cnrVwVBkOu2H+kU+4mDU8TF
         NMC1/cp00lLukt0Upq5kdL2C072DSpGWW6MLfziS08yLmcygjhJgclFABeTDIoxCxq5Y
         Kn9uvQAkQ/6Zb5EUk+XDoXMt0chtqyv57ii7T9PLci0nXVzsGjV3uCSztiafropMgrnh
         Ny/q9xZnAOX/zoEs2335jByERYUSAbRKb71iS4BjY8NAleHYQsFjHtod6RwA+0yAKDbv
         SKyg==
X-Gm-Message-State: AFuF++lDlk8LKBvEYWHIeszXIGjkmF1Rv1cUmSmQWBXXWG0NRiYHQsu/
	vlR+zEWvZnCPNEhrBojrCx0x/D8omVjfxdXdWbYK5K7vIbu9uiZc/woyX0+Wo6AlswKI1rKcu4n
	kfVNpRPI=
X-Gm-Gg: AYBFou3IEjTFY5XGeiJF3XAY40RvmTeHaHMJJfVJEXxo8fi/YLNwP16Z8IluM6ID/QZ
	9Kylfr7azgBOMzIM56RxvXBTSefI5XlMAN21VAwvEU0bf8eKDCX3//URqmWv8WXO1ZgKS2ZCUke
	7QliAZT/iueXloelecVZROfPZgTqAuHDByag5AQWbx0v/cBDNJMxHpt5T6VmVp1i58FItQ16sW0
	1AkUg09IwKBPxs/84+xM+pveyLWNDPLadYEF9G/if4w1gK9Vr9yEUEFImuEemfj9yBV0FfDFAY1
	iJ1munfdBcbWSR8MZKIbDoEFn/baxgKn8MAkgwUqTkdh7O9GAb7QOcehYrE2q+dztnR9D0X7hZ8
	9ZLLVJXYecuQ1v9Q3tLA7NKKgKTdO8NDrBmQbmODCmWjJWiNkf1vPuwTgyhQPclOLY0ThXkWoZ9
	rGes4pKqOyaJienucu05N0KlpykW0c59zTKOdsgSqxYw6TeNp8rOvCcI+roYXMPZQOUGFymH97y
	4Q/ZRCS2LWi0kVbdPCkR/IVBu6XB5pBQJQJjmu9tYy4pHEZSN9qWFHhgoEZ0Vr8q7lU1hloyzoc
	W8Q=
X-Received: by 2002:a17:90a:d60b:b0:390:8361:a532 with SMTP id 98e67ed59e1d1-39bac197a01mr6281569a91.7.1788939090010;
        Wed, 09 Sep 2026 00:31:30 -0700 (PDT)
Received: from mma-H9MHD44.lan (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b2615039asm30891776a91.15.2026.09.09.00.31.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 00:31:29 -0700 (PDT)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	arien.judge@morsemicro.com,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>
Subject: [PATCH wireless-next 0/2] wifi: S1G radiotap support
Date: Wed,  9 Sep 2026 17:30:12 +1000
Message-ID: <20260909073014.53344-1-lachlan.hodges@morsemicro.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Definitions for S1G radiotap fields and report the channel as 900MHz.

lachlan

Lachlan Hodges (2):
  wifi: radiotap: add S1G TLVs and channel frequency
  wifi: mac80211: report 900MHz channel for S1G band radiotap header

 include/net/ieee80211_radiotap.h | 66 ++++++++++++++++++++++++++++++++
 net/mac80211/rx.c                |  2 +
 2 files changed, 68 insertions(+)

-- 
2.43.0

