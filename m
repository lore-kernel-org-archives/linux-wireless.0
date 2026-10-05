Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C434B2049
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 14:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791212172; cv=none; b=R+BtHEMA2QOhqODvgZP8wb0BxQOxEHIrNQTKNParlWVSnZDyeyoaz4i5dzajA6urLvEyeouOgatWb2EJI8Bq0tPBCt3whuB5nFFl2SFvFvYIYi3nxk2TG3eu129QXgnL3hjcxiPfn/5bUGoiAjiDxgeS1l31jxNdTVUwwRXoxN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791212172; c=relaxed/simple;
	bh=EiBKd8GStOUfIpi/gjn/hGQ8S/hVfxafHK2alIdzNwA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ORSJ0SfxsVugMmD0wYR+D9okt6VBwyjVCO8bzjWNc7zFyTArX+eUxqNz9qr6U/T6e880KB9BcWwnGFSQDxlzSOYqHxK8YGfsqEoCV3ddNWf+Q4jCLTZbSNpVuK0jzLl2zWmxvzbXcyiA7ZMtSrG0Uxy8kJN99gAVtAysQ1kPQA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z7WsM2bQ; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z7WsM2bQ"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-49d05d51553so13681225e9.2
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 07:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791212166; x=1791816966; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VEexO2lvA+9AjS4iDd6WKJuFeAIzg+vRwOGVTItlkVc=;
        b=Z7WsM2bQuOZWo0SPiHgIrBU9rVRCOw4GciHSKe9Y8KC2b6yE+/mhUg3FR6AVaEqCb+
         ImiIK6fCbJcPDTF4uH9Uw+AALKtFhzphqWw5zg/EVOTgYvkGn3xMP7wCVqinktJLqg+S
         4vcqBqJ6tjIZvqw8Ddkgm2vwTUlfv1ArzQ1t1ppPzm3ai/ZSSe4lkM8RsGguVOHZyhBl
         /0U6UCla35XUNTtgo7ORpegTMeonTjcZO86Iet9fbuXB+j2Tt5tx+Bu6E1IeZsMzzJZ9
         MVwmClGlROIN4gV+nqgb/IcVR1DzhJ/pEItXFOkf0O+8UC2dVBGM6LUsg5UBSxUPMYg/
         CnLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791212166; x=1791816966;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VEexO2lvA+9AjS4iDd6WKJuFeAIzg+vRwOGVTItlkVc=;
        b=W6RqCZmRmF45QARCrJnLXY338siXshxE25lZOubyLQ2M1q8P/J166ka/XAi9JsgwiZ
         xwVA9elK2F63UjDb1lUPGBZD6YA8OxZJ4K461o4jY+DZs7FzEh3dGl/UL5LD9FMpX2Oe
         AtHlybWWeJBFj6IoyXluP6d+ZtmguFBhAzC3UfRr7oq2gd4G4uTqe+Q9KWFa+tMSx5Al
         eHTIwg1Mtv4H6tCUygJ56mx7pBvjIi9Ij/hJcnsYaDxzOQgrTRYuZ2GwiGPwxsMKh6C1
         EIyj7OCwslZLQXlC7rJcIjO9qv6X48UxYhHFdzO/8M64DP8Ssj5zGIjqnZDLSmA8jgt2
         KntA==
X-Forwarded-Encrypted: i=1; AKwUvBw9vo8N00TFBbn9TWpkL8wT3MGegHt/X5JfLLJ5E5UqVDV18D8ELYHdkqrjjlYsmQi/oeYru8xD6mE9ghmTTQ==@vger.kernel.org
X-Gm-Message-State: AFuF++m3rjW927dEZ2iGKH+5EWMeo4vij7zd0PKvQ7lcsyDErkt97Zp/
	HoN4ETzyYu+jRT03gIrRLu7gI0OQ4u5gpXK7o64ivpjjKOolwUtRoG8W
X-Gm-Gg: AYBFou1CYc6ybSmiv6GvIHEIS+/qTNAdh1FMZDpELVuJGLr2isuM1EbsrcvDRr7Vw7u
	t1A7jcgqRFxihSoHApxDGRUfH7J0YR7stZJDsQ5nblQqiWAu+r8ja+qEZq8IkRwQbyKVoEBx8Go
	pgp8GoYFT3BP1OfKFTU/YIzVMW4v2Y7b6q1e0FmAq2g0nKokL/UKXzDY2Zzy9BpHyVlNlzVz+tS
	0S6rh95dFPMtaG5hW4cxYweo71a0iXo9AgewGUJhfc5udKL68OuKSss6O86k91sPaaJInn2GZLJ
	l7lR5srnpixDc5l6XaJTdXui9Ihk9OyFic5IsK65+tcCZ6BsnMqbT6zSCbwyfkZ4yGpRtOmxn//
	VVa79/krDIQFKcoZ3zi+pz0W8pDSokUGiIi4oSzC02PHYjk6siiw3sCx6J4+EMnZuAe21iyqtE8
	9x3reFzeSamVgwTGsiTh3yv8iaPDasaoP08JuXYeKyL17wAXG6NMyndxkHoQ842YNLJfVyJvK+9
	DPd
X-Received: by 2002:a05:600c:c16d:b0:4a1:717b:7976 with SMTP id 5b1f17b1804b1-4a1717b79eamr47242805e9.35.1791212165729;
        Mon, 05 Oct 2026 07:56:05 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1776cfe45sm12380115e9.1.2026.10.05.07.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 07:56:05 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: stable@vger.kernel.org
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: Please apply 13221be72034 ("wifi: rtw88: Handle C2H_ADAPTIVITY in rtw_fw_c2h_cmd_handle()") to 6.6.y and 6.12.y
Date: Mon,  5 Oct 2026 16:56:04 +0200
Message-ID: <20261005145604.134614-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

please consider

  13221be72034 ("wifi: rtw88: Handle C2H_ADAPTIVITY in rtw_fw_c2h_cmd_handle()")

for the 6.6.y and 6.12.y stable trees. It is in mainline since 6.14 and
applies cleanly to both.

Without it rtw_fw_adaptivity_result() runs from the USB RX work: it
reads three registers as arguments of rtw_dbg(), which is an empty
inline when CONFIG_RTW88_DEBUG is off, so the reads still happen there.
Over USB a register read sleeps. On 6.12.112 with an RTL8822CU, the
only rtw88 chip with adaptivity support, this gave "Voluntary context
switch within RCU read-side critical section" in rtw_usb_rx_handler()
-> rtw_fw_c2h_cmd_rx_irqsafe() -> rtw_usb_read32() within a minute of
starting an AP, followed by "xHCI host controller not responding,
assume dead", which took every USB device on the board with it. With
the commit applied the same board ran the AP through a channel switch
test session without a message.

Thanks,
Mehmet
