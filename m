Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793565534;
	b=jnFohe7ovMCgGkXDolvPwNKHE8yNyaf0BpeYfJMEvRJ8Kwv1KOsPGzYpLK1Pr4N/7Haf
	 sIUecsNYlmYFwNiqvSJI6bBrsrOXCn2eJDJ8UrUinm45cXVWzxcznk6WJ8QFOSC+q8cTw
	 C30mbbkZownSq1IbdTKpre5vlwvZVa042cyuTP6z6mVGh/Nb2+zZtlYHk1s3DmLIA1Acp
	 8IDNQi44GtMhgVTA8zkLApFSQMMp33bu6ynUIF5VUZMvoqTNGe7P/Oz6nd3KsV/eTBx1l
	 bP8UuEgdXzOHR0ttv3KbV2V96IIRwNGCZ14mjLVX97YxpQgHcC/e4V1++AXP24mnJdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793565534;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uj5wOkKpVCiJDyEwPq73Wu031Kkj39ttXowWhA0DbaM=;
	b=RPr+vvxxtvwXMTJaAsm7rWXWRw7keVXc0L8bbK0Y/SrZ85jCGMtecz9rA/CL94XOpy5Y
	 0I1RzbVdQsEssEBa5ITzELhn+tksUwBAVfIWgH6Jfv7Poi28kmohDQkihKS3OqMa2nLH7
	 t5Ws9HMc6pqe3A0HzdkJ1I+qp+8Z7/H+G67Ezmkdfmlo/MYX47GW155ZcXP18cGVgldkF
	 jyC5cSu7WTVTqV0ZpQwIQRyuU/ThE1T5kQF97U/6V0QM4HIp9Lf1fl4KxdDFoU26JfU3V
	 BPhc/Yjcy2K+9/i4tX1chKZt5+mzCyRmrAOx668xhvj8FcrnNxgzo5t8LQApagux8FA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ESowRg6A;
	arc=none smtp.remote-ip=209.85.221.42
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B82606A326
	for <linux-wireless@vger.kernel.org>; Sun,  1 Nov 2026 20:38:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B9B82606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ESowRg6A
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48e00eee27dso1040831f8f.0
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 12:38:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793565532; x=1794170332; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=uj5wOkKpVCiJDyEwPq73Wu031Kkj39ttXowWhA0DbaM=;
        b=ESowRg6A+lK/gIIWPVk5lGgZ0HFExod/PFYaI7SBMeVe+Gut9yRl3BF9HoKBQw1gXp
         Hap/sQdqMWQRgVoUDVr/hiEiNnpAuH6E5KLo4CNV4t9dJivb5eBMZa2KKob7Af474+ai
         EigZOH89m+hBHyrRnxewhR/TsCrdpgFD/5GW93SLB5gtrFFePPIm4CSFyOTNFf8EPPDR
         80zHSL+ppR9HXSLditBy/wlsQDJA/7F0Khim93QtMg6qeSFlfsiwIdMC0G/JXAo3zQD4
         VOE09/SBq+6/tFvQDY8pXYvmcGs6x6ExJLuSKMFwtmCg2eEyQDMJEazY8t7k6mKKylxp
         ep3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793565532; x=1794170332;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uj5wOkKpVCiJDyEwPq73Wu031Kkj39ttXowWhA0DbaM=;
        b=0VekeK/psziXCX2EiL9d+AK5nrlcs96hsjWqQLDSCo7nGuJZQTgpZuqpGqHqt9BKA1
         C820Zx58b693+zfQmHGsGK3GxXeU+B+mNRVeBS4m646sw824JetrY+WYg2FjutK1Emyc
         16n+rXY/ezNMkYNsrTj8obowviqyHIAu+8eTDuLKtW+InSgCmk+i9q5iRhCeK6tmPo60
         RX4jc5gs3kYU0n1pNp4mo5CYlJUF6vvFNd6hXkgpJcPFkA+a+WlzdInXsIn8kTyNhMew
         Fmp1amSw6KIiXPzlzjDcHQFnnQbMY3Y/jaNH8I9Zq5dj9/TKuCg5AG9bMkoJ01sQG2GU
         0WGA==
X-Gm-Message-State: APuU4Z/NFB/n9rkV2r83XJxaWEjPsASAxk4akgZfh6g81K28XZB9Yg6q
	1qAcrbqOlkPUXxPrzHhmOeHNDhEMqXYCeu7r+Nbj/FzOEbweg7jVJI0mWMvY
X-Gm-Gg: AYBFou0S17Il7DRQ1OXYanzzGS4g8LOG2XHzpE41hvZXbIM1oKozvTdB1yU1r7V+tY0
	j8wzw9vtGCL/X6mvAq7D4G2syx/M7sh7MDYASGnAdeFWyZCVsFaOz1gkHewpPS0qNxzMUJ/+YXI
	KR9vjpBvW8h9GYdO0zEk33rack8NiHmsskOJAOPRA2H2gviQLnstQnnkdMleB03tqX+SlpTI2tP
	WC3oiCpBEGaOSlByJTf1G9OotIVNbkNK3OCs5hFykXicAl5ZansWXDKToJ3yBx9FKR181pad6AL
	DHYUoUlrWvr3amtmKYIixV7EE4TBFzbdMNrsVjn61hWwGsM5XWc95fWWfPPfLyGNXscBrZ8U9Mv
	zyTHV0jE3evs+Fi9xsTHLst2gYFai756q0bjgUD9Q0897VDhK+xkw8nhMASYa+kab5Vjxb+TYnP
	woBsfPOFb4lR72QPdbI7RMeK/kV8mE1TTvFSLZIgELkC5ullIsiHWWKwrKWFwd24dNOg5tTj/gD
	FzmigjITpxwUffxz/uy6v+m4cjG6oG9jbwkH3axyObcMfvZ0Tt7EdUKuyppBUg+j6Hh+5PUeLEj
	REUPiG5RcB7BNNfXY3EfW10aOauH2XpU
X-Received: by 2002:a05:6000:2085:b0:48e:7a41:d78e with SMTP id ffacd0b85a97d-48e7a41d798mr8820852f8f.19.1793565532007;
        Sun, 01 Nov 2026 12:38:52 -0800 (PST)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b72715sm15502295f8f.18.2026.11.01.12.38.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 12:38:50 -0800 (PST)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: Ajay Singh <ajay.kathat@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>
Cc: linux-wireless@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH wireless 0/2] wifi: wilc1000: add bounds checking for firmware-supplied fields
Date: Sun,  1 Nov 2026 20:38:47 +0000
Message-ID: <20261101203849.2807553-1-tristan@talencesecurity.com>
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

Two functions in the wilc1000 driver use length fields from
firmware-supplied buffers without sufficient validation. This
series adds bounds checks to prevent out-of-bounds reads when
the firmware provides unexpected values.

Tristan Madani (2):
  wifi: wilc1000: validate frame length in wilc_network_info_received()
  wifi: wilc1000: validate header fields in wilc_wlan_handle_rx_buff()

 drivers/net/wireless/microchip/wilc1000/hif.c  | 9 ++++++++-
 drivers/net/wireless/microchip/wilc1000/wlan.c | 3 +++
 2 files changed, 11 insertions(+), 1 deletion(-)

-- 
2.47.3
