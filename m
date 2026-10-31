Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.156.86
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793438191;
	b=XLWCMef8CM7JLtP28AV4sv8Q6T0q5dLyMbvQEDS1g0pBNWNs7BqNpDmCt0QOgMHaxe08
	 N4c6GkB/b+8cGvdyiIBjV/zxx7jJ80Z3CIQBJGz7UKVn0AL70kGNwYcLS82OmdpxKATpU
	 Os/DfiCSSlLRazYU+OFuYKFsyYQJaM7iXhkNKhAXvPz1Gkr7VJKPk3Yayzfi+sUX7JtwG
	 VYZRmHD004AVJAPuS3wCaoBTSiv9Ke3cZTb1z8B82wUY9AQo8hKr0o2QKnyrj9zgOdfAQ
	 IpvbYW7S7iOavtebLMokAR1P2hfMVyLg73l+7S3erdYE85Kn17d0rtE1+zdOiG9hqEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793438191;
	h=DMARC-Filter:Received:DKIM-Signature:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-CMAE-Envelope;
	bh=0yfNB7BetGJUPFCGgRETSxE53+j8qHGLWT2yboJbayA=;
	b=ZbKkOfwPGaOsqUtf83eHKeKueCJbmJX4/3dEF/oQAYn7uNT34zZqn7g7fCRHVPiW/0xd
	 i0TtFX3KhRjI4yv3rMmhsGsGndCLHw6x+HnM24d/pvbUdLZIF8ad+a0FPd5xcMQvR8/1z
	 H/Z/Skx/NtVrwQ1JrbiTMrfXL9h3ubOc2kbE9tf0PCpygLoxTeqj8Wg+I37HM3fHxvO4+
	 VM7KI3+RXe6O74q0YTLsiC8nhFzWHcbNKYq/yxymnakEZ7MLuN4LyraITgNpd026ieWU0
	 RYs5vweS8aIe6ZdRj0DQXyqjgXmsBM11KKwdEtqU8MyCtVYnMCD5ZF8LRReaKC3E5gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mythread.it;
	spf=pass smtp.mailfrom=mythread.it;
	dkim=pass header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=JfWrNDPi;
	arc=none smtp.remote-ip=62.149.156.86
Received: from smtpcmd0986.aruba.it (smtpcmd0986.aruba.it [62.149.156.86])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6D5606A326
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 09:16:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C6D5606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=JfWrNDPi
Received: from [127.0.0.1] ([79.43.52.162])
	by Aruba SMTP with ESMTPSA
	id N5BMx1hYL6q8sN5BSxVoVi; Sat, 31 Oct 2026 10:15:30 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1793438130; bh=YvD/5o0kIL8eg+UeJCLpfHxjhPtXaJEyfsbOW6bzSO4=;
	h=From:Date:Subject:MIME-Version:Content-Type:To;
	b=JfWrNDPiS2/l4AtTV4VjPHKPKgRZdhYr6vumFTyIcQgPXjXClul1nVK3Rx/GcO4Ny
	 ylFzOyYSHPoonWhsiqJqXdXfewnLX4A8/AilndYpM9tvjbsTJPp00O5Ta8CKBV7km8
	 p6FAysZSogVd60kE4S5DvlZHIE1EKdSsVTvQmF+a7OT0VUHgoHln4WaxBoD/O2hump
	 zMjjc/ppIm3O12Jc9xRDWM1aMkYW8fEpsAhXR06Cjs5FdmqffEOTeJyI3Q5UyK92fj
	 T983h7ydK24mJH7Xhqt6o+MLbOcC5mahaa0ZN3Cyujnl3vlU5eOg418hPSzLyp63Ep
	 juW+F4sG31wpw==
From: Alessio Ferri <alessio.ferri@mythread.it>
Date: Sat, 31 Oct 2026 10:15:32 +0100
Subject: [PATCH wireless-next v3 10/10] wifi: b43: add the 2.4 GHz
 BCM4352/BCM4360 to the supported bands
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-bcma-ac-rev1-v3-10-1fbe38e8179b@mythread.it>
References: <20261031-bcma-ac-rev1-v3-0-1fbe38e8179b@mythread.it>
In-Reply-To: <20261031-bcma-ac-rev1-v3-0-1fbe38e8179b@mythread.it>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>, 
 Michael Buesch <m@bues.ch>, vit9696 <vit9696@protonmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mips@vger.kernel.org, Alessio Ferri <alessio.ferri@mythread.it>, 
 b43-dev@lists.infradead.org
X-Mailer: b4 0.15.2
X-CMAE-Envelope: MS4xfPBZNLEo71l/QFE82efaGzWt4iqwpfNEwXROuM2bg59CONH1IJq3AxNNmSxPglw/dZLw03jjAo6BQVJ67qxc0knWYrpo2bXZF0BwhGj3xuE6bWolradr
 0XyUXfvGxcNf9qgaIO8aj8Xg940oIeY3xqpjwGQlsUcvBdLIdHFyHxcjs1TAMVxki4ZcivUnFVOeAbf8VcUVzOaJBDQs+hAaDGgo/13vrPztWASl83/LgZlB
 eFI5HyLFmvlBuApDenByz9pDtmJYuljaqII2+BC0Z8BabjD4+9qQOBLjHZKg/gStorIyM/x8YP+EyAHfunDwz/qEDdOH/obgMxinALeFv5iG92zUow1k/vMG
 IrfAojJ9yZLxDH88G7pWbt52BiTLMm04bpTud3K6AZL9Nqo3U8g61yIQl2ip6dkHMywCVNkG/JoUh6PPbbag01HeyyXcRw==

Report the 2.4 GHz BCM4360 (0x43a1) and BCM4352 (0x43b2) as 2.4 GHz
only devices, as their 5 GHz variants are reported as 5 GHz only.

Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
---
 drivers/net/wireless/broadcom/b43/main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/broadcom/b43/main.c b/drivers/net/wireless/broadcom/b43/main.c
index 817448e58..2620210bf 100644
--- a/drivers/net/wireless/broadcom/b43/main.c
+++ b/drivers/net/wireless/broadcom/b43/main.c
@@ -5366,6 +5366,12 @@ static void b43_supported_bands(struct b43_wldev *dev, bool *have_2ghz_phy,
 		*have_2ghz_phy = false;
 		*have_5ghz_phy = true;
 		return;
+	case 0x43a1: /* BCM4360 */
+	case 0x43b2: /* BCM4352 */
+		/* 2.4 GHz only devices */
+		*have_2ghz_phy = true;
+		*have_5ghz_phy = false;
+		return;
 	}
 
 	/* As a fallback, try to guess using PHY type */

-- 
2.34.1

