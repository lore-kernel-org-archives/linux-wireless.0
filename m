Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793518276;
	b=h6As4DRZwWnnlVk5oryxgLJEQw0IhftJcNkDzXbgnFyhWEq3MGGYDfx+aGClNiOKOddg
	 nmoWSnnzbgLUUSFF+RNzc2S/G5ZPUOwLU8hMMLwi+oex1C60CBd4mmT+H8+i3EtOgtV5x
	 tIpaWNOlp0z3hNBWUmdRRx7ZFrRsVm26AO8NdASQOe/o8XJwl+6+e5AlkjavSPY2Efd92
	 BURljoWar4JMyCTl5ulU/ZBCrVkoQKj1tAc3zqaE3QdGsATFctLEas8h+hGoQYFEKzfeX
	 RlCLfsglskThx8iJJHywTOD+NiouM09nVI6TJnx1vJLJnyiwGVgWj1+IjhDdx0DgqBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793518276;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=qQT7JBE5+Rrkn8T6JJ1MYI7wx1Y5+AlUnuXG+mJ68Jo=;
	b=VRVTyBmJln38do3LgtGam/PaCjQLJD0xR0hRapyLU+FsHtikKRig7FwWCtt/AwQjYfmD
	 +swCux9UedV04Jrwbhz0l5XMTqeJEx4jDOlADQ/QkC7km7oTgoPXnA6FNBIgPEBblRpZ0
	 Ph2SKr8nuHivCzqEKfnInZROylSJKucYW8fbxfPw7VbPCvl13yy17pHRDNp6NGJXy6DeV
	 f9oVYSnsdiNZk+bC0EFOh90F1yIuCh/qPbdqPxu2Mp2pivXoAGXLKdnvYeA7kyB7a1sYx
	 uu/EV1LSz+ptL1HDJtAjLB6avcIIgltSFIh4vsDC2OWEBxv07O5oiaSmFn+86KxehyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b="RDIveEV/";
	arc=none smtp.remote-ip=220.197.31.5
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C51606A324;
	Sun,  1 Nov 2026 07:31:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8C51606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=RDIveEV/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=qQ
	T7JBE5+Rrkn8T6JJ1MYI7wx1Y5+AlUnuXG+mJ68Jo=; b=RDIveEV/gx9QCMeRow
	A55kCa71SaILfxx7KeWaLJVDSmc/QDU8pSHAwEGp82H+Do0Ic2p/MomeVEzuGbzC
	PGpR6ZJUwx9+6h5mvskFlkc7Owh1cxHdgU/u1R56UKMHf7BIh6FrO/f9wwgmtPIP
	rN1rfJ1vffuM0tYTizF7X4ELc=
Received: from LAPTOP-BJS5C4G0 (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wBXX5ih6uZqsXx5Dw--.8007S2;
	Sun, 01 Nov 2026 15:30:44 +0800 (CST)
From: Heyang Tan <thy15333007817@163.com>
To: linux-wireless@vger.kernel.org,
	jeff.chen_1@oss.nxp.com
Cc: jeff.chen_1@nxp.com,
	francesco@dolcini.it,
	johannes@sipsolutions.net,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] wifi: nxpwifi: validate monitor RX extra-header length
Date: Sun,  1 Nov 2026 15:30:38 +0800
Message-ID: <20261101073039.589-1-thy15333007817@163.com>
X-Mailer: git-send-email 2.51.0.windows.1
In-Reply-To: <20261030113042.3895883-1-jeff.chen_1@oss.nxp.com>
References: <20261030113042.3895883-1-jeff.chen_1@oss.nxp.com>
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
X-CM-TRANSID:_____wBXX5ih6uZqsXx5Dw--.8007S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxXF1fGFy7Xr1DuF1DKF48JFb_yoW5ur1DpF
	Z7Ga4jqwsxJw4qqF4kGa18ZrW5JanayF1UZr95ua45JFZ0gFy8tFWIyFyF9a4DCw4fAFnI
	yr4YvF9rJFZ8W3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UQXoxUUUUU=
X-CM-SenderInfo: 5wk1ikatttiiixyrlqqrwthudrp/xtbC4gU44Wrm6qULoAAA3W

nxpwifi_recv_packet_to_monif() assumes that rxpd_extra_info fits
between the rxpd header and the start of the 802.11 frame.  It ensures
that rx_pkt_offset is at least sizeof(*rxpd), but the following check
only proves that sizeof(struct ieee80211_hdr) bytes starting at
rx_pkt_offset are present.

If a malformed descriptor sets RXPD_FLAG_EXTRA_HEADER with a
rx_pkt_offset below sizeof(*rxpd) + sizeof(ext), the 32-byte copy from
rxpd + 1 can extend past the descriptor-reported end of the frame.  For
example, when rx_pkt_offset is sizeof(*rxpd), skb->len can be only
sizeof(*rxpd) + sizeof(struct ieee80211_hdr), while the extra-header
copy reads through offset sizeof(*rxpd) + sizeof(ext) - 1.

Reject such descriptors before copying rxpd_extra_info.  A single check
next to the existing flag extraction also covers the HE copy site.

The normal skb allocation has enough slack that the over-read stays
within the allocation, so this is a defensive bounds fix.

Signed-off-by: Heyang Tan <thy15333007817@163.com>
---
 drivers/net/wireless/nxp/nxpwifi/util.c | 4 ++++
 1 file changed, 4 insertions(+)

Changes in v2:
- Use sizeof(*rxpd) + sizeof(ext) for the extra-header bound.
- Clarify the descriptor consistency requirement and the conditional over-read.

Hi Jeff,

Thanks for the review. My original wording was incomplete.

The new condition enforces the descriptor layout implied by
RXPD_FLAG_EXTRA_HEADER: rxpd_extra_info is immediately after rxpd, so
rx_pkt_offset must cover both structures. The existing validation only
proves that rx_pkt_offset is at least sizeof(*rxpd) and that the
802.11 header fits after rx_pkt_offset; it does not prove that the
32-byte region copied by memcpy() fits before rx_pkt_offset.

For a malformed descriptor with the extra-header flag set and
rx_pkt_offset smaller than sizeof(*rxpd) + sizeof(ext), the allowed
802.11 header length can therefore end before the copied structure. In
particular, when rx_pkt_offset equals sizeof(*rxpd), skb->len may end
at sizeof(*rxpd) + sizeof(struct ieee80211_hdr), while the copy reads
through offset sizeof(*rxpd) + sizeof(ext) - 1. For the 30-byte
ieee80211 header in this tree, the maximum logical over-read is two
bytes. The normal skb allocation has enough slack to mask this, which
is why I described it as a defensive consistency check.

A compliant device already satisfies the new condition, so valid
firmware behavior is unchanged.

I updated the check to use sizeof(*rxpd) + sizeof(ext), as suggested,
and reworded the commit message to describe the descriptor consistency
requirement and the conditional over-read explicitly.

Thanks,
Heyang

diff --git a/drivers/net/wireless/nxp/nxpwifi/util.c b/drivers/net/wireless/nxp/nxpwifi/util.c
index ae8444a14..a343df0c6 100644
--- a/drivers/net/wireless/nxp/nxpwifi/util.c
+++ b/drivers/net/wireless/nxp/nxpwifi/util.c
@@ -616,6 +616,10 @@ int nxpwifi_recv_packet_to_monif(struct nxpwifi_private *priv,
 
 	has_ext = rxpd->flags & RXPD_FLAG_EXTRA_HEADER;
 
+	if (has_ext &&
+	    rx_pkt_offset < sizeof(*rxpd) + sizeof(ext))
+		return -EINVAL;
+
 	if (has_ext)
 		memcpy((void *)&ext, (void *)(rxpd + 1), sizeof(ext));
 

