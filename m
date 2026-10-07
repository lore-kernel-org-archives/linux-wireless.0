Received: from mta1.migadu.com (out-235.mta1.migadu.com [95.215.58.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7030830C359
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 21:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791407404; cv=none; b=an1pl+2Exgj7mdRINm5jtyd40rE3Tj/MtlupuqDXh2KU0H+waKmeQunaMRZU1kbpw+nXzs5enlyYmwSRC9gGgXoWJCX6bGc5dUeh0T24P+HiliAseudpAveWwOH4fUOGVNa7q8rRwvd0n9KBjpd2xcEG9O6BwDPTPM3uEazJ3lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791407404; c=relaxed/simple;
	bh=NwrbUxko5wpu95YSC5WlbTNALnckzqRmBDz7S6ynThE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QdwbEb8HwfDjoeS3/5DwARxLRMsg75Q2hWyPcs89GQy2DRPTWH64zCnN/gG/Z2p1YF/6za4zGNs2s2ZUxDAxRuUL00DWw2Ro9md5jsO4cwlxvNijphvccO9Vvkzps4yKUoI+MNl+vgSkNu1hDLd3LfoCjAIYMWinZ8F48iU6okE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=WzmuaQ9v; arc=none smtp.client-ip=95.215.58.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="WzmuaQ9v"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=NwrbUxko5wpu95YSC5WlbTNALnckzqRmBDz7S6ynThE=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791407400; v=1; x=1792012200;
 b=WzmuaQ9vbDVHlLE1Mmfx1DFw7tffcd/TheNEllgN7oF+lOFbgh+dMXlDwCv1qpPo5xzssPtC
 r2kGYsUZLLtl5R1WLnw03ATbzme7PocQ1BSbKB5G1mehNWzkLBVJE+4kTCbgCZvSTKXneGNv0Y4
 HCn1fQ4+xeIKGXW0pF0860bvfAgHt+C5npA8XqNqe8r5rIjg2n77e67xe3pytFL18w3v0yGrIRT
 DTG8qCUZJulsKZGSMm1ja+9pJKIqA8ljp9P3gODpEH0xg960DB684qEWPerRiIUlW+L/3eQk8J7
 vPYW6ZP8Aaxv+nmZK/GKqmR5x79hO/lDpt5O2y4vdGZPg==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e0a5c07a63e6fb29;
	Wed, 07 Oct 2026 21:10:00 +0000
X-Mizu-Trace-ID: e0a5c07a63e6fb29
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Nick Morrow <morrownr@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH rtw-next v2] wifi: rtw89: usb: shorten the RX aggregation hold on RTL8922AU over USB 3
Date: Wed,  7 Oct 2026 14:09:58 -0700
Message-ID: <20261007210958.56528-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The RTL8922AU holds received frames for up to a millisecond before
handing them to the host, a value carried over from the RTL8852CU.
On USB 3 that adds up to a millisecond of round trip, and under load
at 160 MHz the access point drops to lower rates and download suffers.

Shorten the hold on USB 3 only. On USB 2 the bus is the limit, and a
slow host needs the long hold to keep up.

RTL8922AU on USB 3 at 160 MHz, power save off for the round trip:

                         x86, 6 GHz    x86, 5 GHz    Pi 5, 6 GHz
                        before after  before after  before after
  TCP down, 1 flow        613  1002     579   948     587  1010  Mbps
  TCP down, 8 flows       656  1187     629  1080     605  1122  Mbps
  round trip             2.33  1.29    2.25  1.18    1.42  0.84  ms
  busiest core, UDP 200M  8.4  12.8     8.3  12.9     2.1   3.3  %

RTL8922AU on USB 2, Raspberry Pi 1 B+ at 5 GHz, 80 MHz:

                        long hold  short hold
  TCP up, 1 flow            102.3        87.7  Mbps
  CPU, UDP 20M               50.5        77.4  %
  loss, UDP 50M               3.8        85.7  %

Fixes: 32cee8a9bb66 ("wifi: rtw89: usb: Enable RX aggregation for RTL8922AU")
Reported-by: Nick Morrow <morrownr@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
v2:
 - short hold on USB 3 only
 - Pi 5 column now includes a run on v2
 - dropped Ping-Ke's ack, since the patch changed
v1: https://lore.kernel.org/linux-wireless/20261006190618.258037-1-lucid_duck@justthetip.ca/

Ping-Ke, thanks for the low-end CPU point. A Pi 1 on USB 2 showed it,
second table above.

The USB 2 numbers you asked about, 6 GHz, 160 MHz:

                         x86            Pi 5
                         long  short    long  short
  TCP down, 1 flow        328    327     297    296  Mbps
  round trip             2.27   1.21    1.47   0.65  ms
  busiest core, UDP 200M  7.2   10.8     1.9    2.5  %

Small-packet mode is at the link below. It sets both the hold and the
size to 1, and nothing in that driver selects it.

https://github.com/morrownr/rtl8852cu-20251113/blob/fcb70aac55585a8e63c72da4e6d24c39d7494307/phl/hal_g6/hal_rx.c#L805-L808

 drivers/net/wireless/realtek/rtw89/usb.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/usb.c b/drivers/net/wireless/realtek/rtw89/usb.c
index dbad42c17761..8dc2c93e502e 100644
--- a/drivers/net/wireless/realtek/rtw89/usb.c
+++ b/drivers/net/wireless/realtek/rtw89/usb.c
@@ -819,10 +819,15 @@ static void rtw89_usb_rx_agg_cfg_v2(struct rtw89_dev *rtwdev)
 
 static void rtw89_usb_rx_agg_cfg_v3(struct rtw89_dev *rtwdev)
 {
-	const u32 rxagg_0 = FIELD_PREP_CONST(B_BE_RXAGG_0_EN, 1) |
-			    FIELD_PREP_CONST(B_BE_RXAGG_0_NUM_TH, 255) |
-			    FIELD_PREP_CONST(B_BE_RXAGG_0_TIME_32US_TH, 32) |
-			    FIELD_PREP_CONST(B_BE_RXAGG_0_BUF_SZ_1K, 20);
+	struct rtw89_usb *rtwusb = rtw89_usb_priv(rtwdev);
+	u32 rxagg_0 = FIELD_PREP_CONST(B_BE_RXAGG_0_EN, 1) |
+		      FIELD_PREP_CONST(B_BE_RXAGG_0_NUM_TH, 255) |
+		      FIELD_PREP_CONST(B_BE_RXAGG_0_BUF_SZ_1K, 20);
+
+	if (rtwusb->udev->speed == USB_SPEED_SUPER)
+		rxagg_0 |= FIELD_PREP_CONST(B_BE_RXAGG_0_TIME_32US_TH, 1);
+	else
+		rxagg_0 |= FIELD_PREP_CONST(B_BE_RXAGG_0_TIME_32US_TH, 32);
 
 	rtw89_write32(rtwdev, R_BE_RXAGG_0_V1, rxagg_0);
 	rtw89_write32(rtwdev, R_BE_RXAGG_1_V1, 0x1F);
-- 
2.55.0

