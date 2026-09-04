Received: from mta1.migadu.com (out-38.mta1.migadu.com [95.215.58.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B05481650
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 13:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788529188; cv=none; b=cVCh8OZMXnPj/80eBkVexOROJWfx9shijJWxwES7bXrxca5cJyHfKoj1CYJrvuiJhXTqmK5aPH2XePtXJS4PKTHggRGl5I9UMPB/r+Zaplowdf5kW/oNzVnErms5ykFiT/VHkwmlUu1pwKN+C85oQrB33AwOdYB83uJuaxesbtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788529188; c=relaxed/simple;
	bh=JzSIGCnXkUnsi3bCYP4ZwoF0IaKCQBGqBC1R9+m4ROA=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc; b=FF9A5C2GRKNpFws2vB2Pqgmi6ThjXwPcaXW7FOQGWYTe7V1znW3kDL08n8f8IWWnKuEbJH7FBF1Ng9b+UjLFrIr06499xKi3OQwgN3cf0yJxpi7v2wSAl7SJ7ZIYrIJ7OTesKkaTdtWFfjYGh0pe5cjB2Fg3KVUAmbzu9Dpp9P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=v1KyDkda; arc=none smtp.client-ip=95.215.58.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="v1KyDkda"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=JzSIGCnXkUnsi3bCYP4ZwoF0IaKCQBGqBC1R9+m4ROA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788529184; v=1; x=1789133984;
 b=v1KyDkdakWsakKyOeRxx3Dq08bH5+YeORpeoPk+krlt8ZJvQvlk9+u9kWHC/viiD2c7U8NAD
 A3WEkhbfmgMmgjtPfmO2hxpWkIOgjwnM8qd3DVHqvUS1qOuNn98NIibIe07LT5+3Nh8Feyj1GzZ
 srftZ0Yar4GGCBXMh2/K1FOk=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 4f8e3b1482d32937;
	Fri, 04 Sep 2026 13:39:34 +0000
X-Mizu-Trace-ID: 4f8e3b1482d32937
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 04 Sep 2026 13:39:34 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Tianchu Chen" <tianchu.chen@linux.dev>
Message-ID: <7c971924c6bdccf6c2f75704a5a746e9303aaf64@linux.dev>
TLS-Required: No
Subject: [PATCH] wifi: wilc1000: fix RX buffer OOB-write in
 wilc_wlan_handle_isr_ext()
To: ajay.kathat@microchip.com, claudiu.beznea@tuxon.dev
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org

From: Tianchu Chen <flynnnchen@tencent.com>

wilc_wlan_handle_isr_ext() takes the RX transfer size from the
device-reported interrupt status register (a 15-bit field shifted left by=
 2,
up to 131068 bytes) and reads that many bytes from the device into
rx_buffer, which is only WILC_RX_BUFF_SIZE (96K) large. The wrap
check only handles the current offset; the size itself is never
compared against the buffer, so a bogus SDIO device can make the driver
OOB-write rx_buffer by up to ~32K with data it controls.

The oversized transfer also leaves rx_buffer_offset past the end of
the buffer, after which the unsigned wrap check stops working and
the overflow can repeat.

Drop any transfer whose size exceeds the RX buffer, acknowledging
the data interrupt and re-arming the RX engine so the bogus frame is
discarded and reception can continue. This also restores the
rx_buffer_offset <=3D WILC_RX_BUFF_SIZE invariant the wrap check
relies on.

This is not expected to change driver behavior in most cases:=20
without=20this check, an oversized transfer would most likely
corrupt neighboring kernel memory instead of completing anyway, and
the drop path performs the same interrupt acknowledgment and RX
engine re-arming as the normal path, so subsequent transfers are
received unaffected.

Discovered by Atuin - Automated Vulnerability Discovery Engine.

Fixes: c5c77ba18ea6 ("staging: wilc1000: Add SDIO/SPI 802.11 driver")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>
---
 drivers/net/wireless/microchip/wilc1000/wlan.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net=
/wireless/microchip/wilc1000/wlan.c
index 4b116fe6f9ea9..55a77a2e32887 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -1197,6 +1197,15 @@ static void wilc_wlan_handle_isr_ext(struct wilc *=
wilc, u32 int_status)
 	if (size <=3D 0)
 		return;
=20
+=09/* A size exceeding the RX buffer is bogus; drop the transfer
+	 * instead of overflowing the buffer.
+	 */
+	if (size > WILC_RX_BUFF_SIZE) {
+		wilc->hif_func->hif_clear_int_ext(wilc,
+						  DATA_INT_CLR | ENABLE_RX_VMM);
+		return;
+	}
+
 	if (WILC_RX_BUFF_SIZE - offset < size)
 		offset =3D 0;
=20
--=20
2.51.0
