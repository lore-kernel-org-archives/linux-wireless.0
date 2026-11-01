Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793569876;
	b=OVc8wOz3pUIjr+b2ks+0QXCg3G0c4ROw8+Gt1VYckCfOcZPTjqlFPN8VIWoAnDfoElYA
	 oyb8MY/4hF9ImGZ0eC+QMDbVqk2G/qfnKHEqNikvZ1a4dGFH0S48/ZdlGWcO1kwt1SVQ6
	 3aCM3GxP6oXfeaUaNbOpGEqynU5CW5qXG5QcbSNOaL+5vFNjHW5/VeTkBtD5TD8ZdKnM1
	 oE7lUIpXYtW625I9lMEXMtD2bDzjJTEmNw/BNo404eYHUWm6vwVL0/FK+dgmC7TPNipw8
	 8SmMkigqJRHbuBrQuLZc9quJr4bb9dEiZQlAwRuBVZGUE7kvLnwyo7EUeywtZLSLB3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793569876;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=vbvTT2zH16U4nvYl2r2md/wzDh4cRShpLVLIl3HVESY=;
	b=fiUFmBoRw5toIqrJbSphDVjUyxiPjLFyOXLBe5V74LDf4rJDvpcgW1wRRfCtP2mbwDN+
	 4kHmbcu6OXoYB/SZMyDLZQn9S7rNGTKp9gSxowFvbqEZDGpnqcQ1HyuxyTMHtypWD8jzd
	 O8rVhn7WAnR9sptW3PEKgd7bOgP56LqyGgQ36ehL80ydtcdC5ABspDDJl0HXPGzKHlsJs
	 o3s96sHUek9iGN1gFyw4KMCFYj6pSIuTiMnq+7gll98H72TpvMc/X4Oe7eED+KLGoFK+q
	 +2pcIJRPS74ShZXtCf6t+H9g6kqe+m8Sp5MayoRt472Hyd++iy/h+ARyCdfE1KIVPNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PJgYhnd4;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63384606A326
	for <linux-wireless@vger.kernel.org>; Sun,  1 Nov 2026 21:51:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63384606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PJgYhnd4
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a3517554f7so18070605e9.2
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 13:51:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793569875; x=1794174675; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vbvTT2zH16U4nvYl2r2md/wzDh4cRShpLVLIl3HVESY=;
        b=PJgYhnd4br5i71vpvxNrvjZ2zRZ6iaoaSIXouE3kG24s8k7x/nL3nTItvJ6U8EaJfU
         t7kCEhZH6lFSIu1MJxHFXBJ/3fHYORB2HSQTG635KoWGZmu31HPRRsRbtWgZBkMqhcXY
         m8yIl0NSLMrO9tlhF7M3PbzHgRyvwC5uO5CEeOPN64mgSm/PsQCiOiyzr50bDh+kjpyR
         QuGgVF2W1jZrJ+2UM15ZV2Rbr0qCCJ3BNB0mZ2Hn0rybnlwuc2mEqqmyRCbVwgFa6L+Q
         IhWgmGsyEjuSlvdKpZf0A82cAnUyqGVprDldf6b8gu7CAdB2fyuh+xlrKODCFqY3yA5b
         5ofA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793569875; x=1794174675;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vbvTT2zH16U4nvYl2r2md/wzDh4cRShpLVLIl3HVESY=;
        b=zakhti/j5/WyzmdC2lvR6dCHEt+Xphz256jJjji9XNQuBypLQizw2/xpCgMDemufbD
         0CK4MKWPi55lroJYcKd8T0S1lf+wdVeUEZROa3FFeRw3/W0TCo94bz4i/zgV/C0DNhy3
         TblAjNgHouRyFJ/XjeqosPMFYwV1gWT/eRPlRZwl6wKlJW2zcwZmAV/A4vXwoxjb+FQ4
         xZHLOkhml44oaN0gxAlQghqEhAmsus0hF/ILtxK32zTAdW4vB6RQR+jipGwBSvlb1maV
         YZtDI254dgNQz31kzvLtz08/5xdrkq9l1Z5tuYmbJ8oLEyDJPzmZg/LlR3Oo7ctnbkdT
         bDJQ==
X-Gm-Message-State: AFq9FYJIGvCNuVtP/sna3iym4vvu3K9HuXKChnnyM7+eyhQ8aRRiSbyD
	wFmnoPGfXxa3Q1jFLcipPTYaLyAO3FPTp9cRvADOACPJRbT8VmweXAanvzJr
X-Gm-Gg: AYBFou1GJSwTh/C45Hv1+0DwOVmCeqCY5Je7b0SHjqW7hjBclsPYsWY+fW/WEsbc4nk
	TmS4RuER5pkohux6G5eudxHjPkruw6KiSGae3bsM03JIZhY2+H7sHplE2nSA5Zje50lkImOwvUp
	+0Nl5cdyY71BMc1OH4RuU5d+oOBTuId98EnK2X0D82Etr+qWTautaw0va8Yn6E+sJ5z1rteKp5D
	eSssTaBMgYvkg42Ou95DdJkdVXh4iHjzVbuqplJST3K0I4+Ah2toxtq+KN5NOzkIzeHhmswrROd
	FfLaorKPSFyk1fEf0yyT4GDgftvjTjoCjshwS6HZ0t5jz8GNSP5bYVL/d1gm0ggOuFDGboAdDsG
	V6EhxbIg5/UnkGCxhA16/usq0v5aSQVL69kT8iUfDNeTpx5q/L1eUEyB5mCwXPAdgZBa67dRh30
	ZeC5szgyk0VTQcXRxq7Hj4sT8CQt/z9ju1Klz0xltTpnEO2ITJN+0DGIpD3Q9PgO9YVOGRKro+d
	sG4gF0lIQvK65OjfCN/i60ZNwQWY4W7yJm8Rxzcnzh5C3Axmxnb5YIjzqFgHmA9LqezplF8Xg==
X-Received: by 2002:a05:600c:1c0f:b0:4a2:150f:1601 with SMTP id 5b1f17b1804b1-4ac1709a7bdmr196538715e9.12.1793569874581;
        Sun, 01 Nov 2026 13:51:14 -0800 (PST)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ac09ad5ff8sm157249425e9.4.2026.11.01.13.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 13:51:12 -0800 (PST)
From: Tristan Madani <tristmd@gmail.com>
To: Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>
Cc: linux-wireless@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH wireless 0/2] wifi: mwifiex: firmware response validation fixes (WMM + sta_list)
Date: Sun,  1 Nov 2026 21:51:10 +0000
Message-ID: <20261101215112.3199197-1-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
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

From: Tristan Madani <tristan@talencesecurity.com>

Two input validation fixes for the mwifiex driver:

  1/2: The WMM status response handler uses the firmware-provided
       queue_index to index a 4-entry array without bounds checking.
       Values >= IEEE80211_NUM_ACS cause an out-of-bounds access.

  2/2: The AP station list response handler iterates over sta_info
       entries using firmware-provided sta_count without verifying
       the response buffer is large enough.

Tristan Madani (2):
  wifi: mwifiex: validate WMM queue_index in firmware response
  wifi: mwifiex: validate sta_count in AP sta_list response

 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c | 14 +++++++++++---
 drivers/net/wireless/marvell/mwifiex/wmm.c         |  3 +++
 2 files changed, 14 insertions(+), 3 deletions(-)

-- 
2.47.3
