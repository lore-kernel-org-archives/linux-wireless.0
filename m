Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792820366;
	b=tvQAuTi1n7lVrWQIkX+4pgNSgB12KZUkXpY/YPNrkBxFGKQ/ErhBNwAknCAHZ/azM0xY
	 Q+SBhmGAkYMxVM4NxzLDj9Y/dFcPVfysqeYEX5uaOAxEmVAVzBUr6pDBh8g3kgofpCyLH
	 20s7RJd6tNRz+ugpDC3GCYNmN7Wz1ouhV0dzYlrtJvoStEJX6WlQf7Eb/ZLRCnDUfP78c
	 k57+FPAI5v1R2cusBgMBDlQSjwEy+q/sszVeV5Bbsbt2Hp2QOa8u7kVo55hb3BqkWPMfg
	 xh3LPJC+8olLfH1OQxiRuqFQxK+xpdfACS5W0UW9sYb324mUQfu5JmoR18vi6AtqDdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792820366;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=NAlRJHzy1wsPSPz/FaTmSQg0jcdHnFgdak9YR0MMUoY=;
	b=jVIWY4LHyWWzCSB8tl6KPWx9K/V/EAmd5UWVVItoJcOJP3Fc58rOD0ILUMCRDzj8Awoi
	 z2xzuE9ndX2ZtyTj6+C2Nd9BsAdNL5lRxKfaH112yx8n36PPnuZqhBN8O/byyb8lL8i7B
	 975MrZZCdY6hJ7fZs2fLNd9g+IspHYTJTleHWC2YkoLHkKqYmb+K5vykk4sBYn44Q6mAG
	 Bi+Y/Flbdd+1qwLuivW3o7z4AcCvYZS4jxsVKMpSquxp/xfpg2TDWqnR65CQ9jrqjzhAO
	 hLYdMOl9tMPCsW2kvE+PsAalvQgH5dq+jCkVAh6zi1kj+s353UVHcC1930CGVTg7K+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=EtWcgvjg;
	arc=none smtp.remote-ip=74.125.82.182
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E5E606A31D
	for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 05:39:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 35E5E606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=EtWcgvjg
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-36661f953e4so2647313eec.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 22:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792820365; x=1793425165; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NAlRJHzy1wsPSPz/FaTmSQg0jcdHnFgdak9YR0MMUoY=;
        b=EtWcgvjggaTKu6c9xlUsSlUPQ6XVUNtVsXGVTtLyceX/QcXgGPbSXKY8XeO2FSGU8d
         VciVKo4mE+QmwXcFJK17qw3PZJvca5a+XpL3bfM28dRd5YnTJZ8D7Mm5d66V8NbPZjMe
         dqvXyiTC4D9CqynigaiyFXB3lqc4x51FqnkqnHA8ameVrie4P0WrFy4HLXRnpiPGVB2s
         Xuedp+gr5V5TRR0jOv/kTRom+sIznW2P/+AKjJ6DTxvyNS1sipl5zYsTJzJQnMmMJexz
         93sOWST6MHyjBHcu/uNB6dnhbSdVMJwqcTC3N+OOpw0Ys/r9SIHNDHbG24NuvR9ctKGX
         JUyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792820365; x=1793425165;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NAlRJHzy1wsPSPz/FaTmSQg0jcdHnFgdak9YR0MMUoY=;
        b=EWNoOCebi0ZzKMbYada9KtIDUoRiWLh5ZE+cWt4cYS9DUUHrJ5gkgHWi1ZSSFFsl4Y
         jpz/8E9fIH686TyRTsANyPEYB5ZlkWwlSJ4Y/Nu6vOd71M89EDy22IYqjMDW7X7bZuXW
         xPx/sXwNaxc/qP3AV2pYt09haDVlEpWLGSlcBTG1Q65yoFQ9DyGuqXALu/0K5jNRBlTT
         MM69zeWeK/lDUVCQMeY8fAlmxu+L1gXyB8P6PtPF3eXOYP2M4ThLFFBA2k+02EIqdKOs
         lKEIsJa+3HyFoHRIp2MWXmwSD80gQt3AsBZXvBwNtwYCGiT0QlBreAUb7Q1rAEyPaEFJ
         K2Rw==
X-Gm-Message-State: AFq9FYK1bJwHDZnVKk7CU0Os+FXCU5wHtw9bbzaB/yEYbjsUfF8+gmSS
	uGBPq6KnHfbI2jfszsHDA9gqCNq2G3iQWoMZQs3de0KmC7pVxbojC0unzDFd9w==
X-Gm-Gg: AYBFou3GFjjwy+kIhtck++7kq1KkWzI4Myo6cUHGwnvCL6CdiQlXDWn/NgaJPZTU3/n
	9GXkxwTcX0mM6ZoVstv6BudJ1/ht3so0za492iihV3g1eoiWCIM4+kKS4r/RKUmiBaIp4PJTgMj
	y/YhPZSg9+VEbRxW1nnoVwkV2x1H/DOphkuscojjtG6A3eEy1uAXk+I6C42POCS9inLZMmw+o+O
	D8a2afllGFw6DJaHF8iTBWWq0wxNFdKRlyRG+a6m500iGBcOdCUsmodT0xi+1A7HYDYUxR97OZN
	G7xhZpInLiTieferlcbiFM+aKvYqR9/UR9LqhHdJNuzwWpAPed7KtXnO7jd52Gx67j7Ogp81i6O
	Wyzk00HNpG+DlXLafqW1OeeHNvgg134saoGQt9PTA2vsw0+JFvDPnwfFsFhKi/CE1Kf2OMWNz+c
	RtZgxc4o/l4AmZMDz03rBuDDKOkRn1O5aEByG7LlxdIseW8P5tJxeGLDyVEG1BBzWFJl5zaz1lK
	T8upZhfLVFVHoB3hO/3+0pIsWYRZMfJlVdde72hw5h9Vz3bRjW5gOT4Kh8IuCP21kAK8xLuB+H1
	01DAU2dm/ZimryKQvW3idm9bFGsYAS8M+zh5wEFAUf/N520niJjhX9k+EdegsfgQe5nkUfDNpI/
	/s76xQYDAtIx57O/66FIJYxrnxQGzEg==
X-Received: by 2002:a05:693c:62d9:10b0:35f:2bc:82d3 with SMTP id 5a478bee46e88-369e84bc16bmr1906522eec.15.1792820365214;
        Fri, 23 Oct 2026 22:39:25 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:37f::e34])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8d56957sm7466859eec.5.2026.10.23.22.39.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 22:39:24 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org (open list)
Subject: [PATCH ath-next] wifi: ar5523: don't select ATH_COMMON
Date: Fri, 23 Oct 2026 22:39:23 -0700
Message-ID: <20261024053923.3585009-1-rosenp@gmail.com>
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

ar5523 does not use anything from ath.ko, the module does not depend
on it. Selecting ATH_COMMON only builds ath.ko for nothing when no
other Atheros driver is enabled, so drop it.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/net/wireless/ath/ar5523/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ar5523/Kconfig b/drivers/net/wireless/ath/ar5523/Kconfig
index 0d838c1e7b12..2ee9aadfe19e 100644
--- a/drivers/net/wireless/ath/ar5523/Kconfig
+++ b/drivers/net/wireless/ath/ar5523/Kconfig
@@ -2,7 +2,6 @@
 config AR5523
 	tristate "Atheros AR5523 wireless driver support"
 	depends on MAC80211 && USB
-	select ATH_COMMON
 	select FW_LOADER
 	help
 	  This module add support for AR5523 based USB dongles such as D-Link
-- 
2.56.0

