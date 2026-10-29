Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.3
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793244624;
	b=PPqlBWKetJsFkHvVKdFh2iGGNNlBgOQViG8JM11hUWifsHHm/BVcP30oXo9ndAfY9C41
	 2QCiqLG3eb7n9Ji+TNoee4kwGBKnjZC6+IdyyJvbKoyCbJhNtKUroqOfYgmxdd16WAKuW
	 36+w6eBqZxKLrjZLYhGhFWg2fWHzNMdQlpLn/bLD4N8ux0Zaga4NObvWdAoCo/OM7owfq
	 yFvN7UrobNZjaDjMcGtfm9XvtHG+RrbnoVjv9tGLJcS0K00ZC8RMVgHrHIoiJBFFXzeas
	 oIengw+In32gJZj86hGX3V7nByhqcUXi6Ahy2PHLL4ljsdcz6JJc0m6CyXPh5l2NXDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793244624;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=/KBsFfO+dZZxUtdz8wSB5Vnn3P288pX2h/Ai0feaKE8=;
	b=yi0tE6e+Anex5AL+twbHtZ/YRWum9HmkFJ6ZdPnZdDdrXlfZEEmS5uBkatdVoIVlVLYP
	 esHaUXST/zYnyuBqepD6loPcrk90GtYE624JS6MTCxFFUMxA1Y7O/4lPDdBn07Jm3J/7p
	 7Sv0PZiYrgItHkwMl5TM3mKhMWDVx9JFDPYwI5HapVMx8w9clEqF1oyHN2SE/GhQkCSgg
	 ohvAOHAwAD5uxffpha8TqKR4x+RHc5EnbUUwGrpe2PceuhpSU9JyX1PDuXgNK6EVbqa+N
	 JCc/MO0XtucQJZRhjuQG4nAz9CqBJ+3XYOqtd8k166Sr5WYCiWM8x+fGh7/4t7PFA4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=GHwoA60m;
	arc=none smtp.remote-ip=220.197.31.3
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A71606A31C
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 03:30:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E8A71606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=GHwoA60m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=/K
	BsFfO+dZZxUtdz8wSB5Vnn3P288pX2h/Ai0feaKE8=; b=GHwoA60mE+SfDCigKB
	xrfH7sLUuINqUT6N0CKe7+px6WztBhXlHKhXD+i03rWoEPqhpjdpG+vOOetcrB+3
	dLtc+vky3oMbzCxkAO7S6Gch4vEFAOnNnKWjA9XmgIPQKTMNYxFreFZZf2E1PFur
	eQk1foaMIOGy4AjZC4XU7r/bI=
Received: from LAPTOP-BJS5C4G0 (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgCH7Bu3veJqZ003Cg--.56976S2;
	Thu, 29 Oct 2026 11:30:03 +0800 (CST)
From: Heyang Tan <thy15333007817@163.com>
To: linux-wireless@vger.kernel.org
Cc: jeff.chen_1@nxp.com,
	francesco@dolcini.it
Subject: [PATCH] wifi: nxpwifi: validate extra-header length in monitor RX
Date: Thu, 29 Oct 2026 11:29:57 +0800
Message-ID: <20261029032957.1422-1-thy15333007817@163.com>
X-Mailer: git-send-email 2.51.0.windows.1
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
X-CM-TRANSID:PSgvCgCH7Bu3veJqZ003Cg--.56976S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ArWxJFy7GrykZr1rKw1Utrb_yoW8Wr48pa
	97G3Waqr43Jw42qF4kGF4kZ3y5Xan3KFWUZrZY9a4rtFs0kF1rtas2vFyYvrn8Ga1fGa4a
	yr4qvasrCF93XrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07Ug4SwUUUUU=
X-CM-SenderInfo: 5wk1ikatttiiixyrlqqrwthudrp/xtbC-RvwmmrivbuK1QAA3d

nxpwifi_recv_packet_to_monif() reads the rxpd_extra_info structure
right after the rxpd header when RXPD_FLAG_EXTRA_HEADER is set, but it
only validates that rx_pkt_offset is at least sizeof(struct rxpd).  When
the descriptor reports rx_pkt_offset smaller than
sizeof(struct rxpd) + sizeof(struct rxpd_extra_info) while the extra
header flag is set, the memcpy() of the extra header runs past the end
of the received frame and reads beyond skb->len.

Reject such descriptors before copying the extra header.  A single check
placed next to the existing flag computation covers both the regular and
the HE copy sites.

This was found by static analysis and confirmed with a KASAN
reproducer; in the real driver path the over-read stays inside the skb
headroom/tailroom slack, so it is a defensive fix rather than a memory
corruption issue.

Signed-off-by: Heyang Tan <thy15333007817@163.com>
---
 drivers/net/wireless/nxp/nxpwifi/util.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/nxp/nxpwifi/util.c b/drivers/net/wireless/nxp/nxpwifi/util.c
index ae8444a14..bc85846d5 100644
--- a/drivers/net/wireless/nxp/nxpwifi/util.c
+++ b/drivers/net/wireless/nxp/nxpwifi/util.c
@@ -616,6 +616,10 @@ int nxpwifi_recv_packet_to_monif(struct nxpwifi_private *priv,
 
 	has_ext = rxpd->flags & RXPD_FLAG_EXTRA_HEADER;
 
+	if (has_ext &&
+	    rx_pkt_offset < sizeof(struct rxpd) + sizeof(struct rxpd_extra_info))
+		return -EINVAL;
+
 	if (has_ext)
 		memcpy((void *)&ext, (void *)(rxpd + 1), sizeof(ext));
 

