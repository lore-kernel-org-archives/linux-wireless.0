Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792501228;
	b=0rmJifzRYPK2bT8P1g/irL336FWt8cCryEGuYIj9S3N22PtDeS/iOic6nTMRYXJ+z56W
	 BrStPRsl5SLAGDyPd+yoVgz1CXjKfKYXXt+/MaChKD3COgCRRpF5RuvGlFU9l3rjZ3HPb
	 9JFYWcC8k+QzbIINAJrvS2suciMlSf30aB0Gg++ESmrshuSCUeBC4b5zCI0rOTLYVpt4C
	 I18UZY4UDgI5BqiGZW0kce2WHw1kYbMOkZAqNmdxppNrwsy4ednIHppiUhbKau/XbzSCA
	 dmF0tAgLeHOcaGtQk98fO3oLmcXfFmk+93TVU4XD9we0s+p4CavZnKChE680PScs+oQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792501228;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=kkTLnONnchTntVNrB8RYf/J+dMFVwPgfmw/rJ8aQygk=;
	b=A7Tw5bzy1BfzBiTNa5/0QGxSAeGmoOBTxaXIsZgS4vGJ4YM/eBX6HBfduhfdDfHf0re2
	 Bp3SLf3PkIKRrwqaSl9uHX+qwns3fA/xFyCkppO4eP9UPSAYimocBOWbISnNk093x+zdj
	 U/yDpNgmTsbTpkQcNBeYyGyUAKBX3t8H/nMZGBuTCz+kCmO9FvDtvnWG38RFDXXRi3Hee
	 iTcw0Wzg2hM2XaaLMhpWqWOnTgjDj6Fncd3IBsEza3dm9zNNQqm2+IWsnUyQM+QHwlr6X
	 pchqJiF8b1e3CAECjT9Gwz3AA904nJ+o1NgxUHGq65iXyMG1g04oPRLOKz8APmZ3Mpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=acio.nl;
	spf=none smtp.mailfrom=acio.nl;
	dkim=pass header.d=acio-nl.20251104.gappssmtp.com header.i=@acio-nl.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=K3fUmtGr;
	arc=none smtp.remote-ip=209.85.218.46
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A77F60A381C
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 13:00:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A77F60A381C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=acio.nl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=acio.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acio-nl.20251104.gappssmtp.com header.i=@acio-nl.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=K3fUmtGr
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c413dea9ca6so498161066b.2
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 06:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=acio-nl.20251104.gappssmtp.com; s=20251104; t=1792501225; x=1793106025; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kkTLnONnchTntVNrB8RYf/J+dMFVwPgfmw/rJ8aQygk=;
        b=K3fUmtGrQrQSkTDxl2R95elxv2xm20SwV9A1+Gx6vSooVl1WbzihBTTlf5eBW3IWQM
         9aXdZLb4em6lMg/4IJY5kR9sktr4UUM/0kXw8insJNsNJvd48XJMXrnde3rT1+BDPTV5
         FzTzmSkju/gwoICROjJ6lJpxx8Qj8+kJZF+fJLcknM7/k6wZ32w2ldlzDiZc+G58eJIC
         QlDYciMr3nv58wzvQWUiVFR+3PURVMCo9H5qFxMLNJmOmHDiXfK1DGp034AwWHSy76MX
         SChYcPUYSjUV5dujvl2Q0LNPmfYPWQze3v22XR8+GAo10UmeqDaCxscboQsQGPigHzhC
         /APw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792501225; x=1793106025;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kkTLnONnchTntVNrB8RYf/J+dMFVwPgfmw/rJ8aQygk=;
        b=V62Gr8cMSQJugz01+ABByJOL+8uGtlKZxN8H2Q/3EWBTQAx1haCF81Wnt581Z09fNk
         cDVPN9XetDNNKcR3gfbZjj+pmYHCmLdUkPIUXjho7oGrYHkRq6nhSvCQNlBuVf9LGSQp
         PB9vqzzhlGAmin8ldkFS05uKXyAxuHIVjAo3T/nBQa4+tkjzvN4ftabSxEVDrRfI/vCG
         7etiQujWIqpblvGRw0uL/H8VlfD5bjvyTctABw/00dpLWScxyLnvVCupTyf7smMK2MA/
         FVdfQZoSPEo+XnwpVSEA7KJcqRrl5FquZdS29haQ+auOd3FZuCHg1L97bXdLQNrzuaBz
         5DDQ==
X-Gm-Message-State: AFq9FYLLbBpJbW8hc0Bd7erXJtHNF28ydYN6SaBNIEETIJxmKrrCHXxv
	/9fkmGy2hJHYBUrsFlUKFer6sycOdxsP4PCf/RoGRVYlLEe57o5RJZ0yzI1SxnJNJw==
X-Gm-Gg: AYBFou0KBHrzLi88NaspfQnvx4gcKN8qjEeg5f/Od8NaIbV8zYuoSf9/zX22UHg3D1s
	zcFBRC6Rzg7GamRijuUsfCseTTuG7vsDq0JalToG74a6AUxRmnUO4t5bxNHfsIpKMBaZXgBDfq2
	WCVR5wgmN0hQ3guZlYEpNKBiBTDmGF8tEKfHZhSG60Sk595PzY58E3hTyD/Nemuj9pHGTDnBH3r
	/E7AjIfKClyoJe36nEDHUHUcOXEm9cY28llYOeRm5gskJg7Yf/XpuST7eVvx3Y0qgPsA4kEGJ1Y
	g8qHh0Fp+TiBEMG/8NIzxzpiV5qMHG8+ZzfNzEpoeKTIh1T/nvX73iPyKQH3cgopon1FXY3LHzw
	5kH8PFfZmZxQkJmqlqUmxIgNjT/D0+d2xmhyp7N/HqfPiW2aiYpc39/Ckur0cVoeypBK7gZOBri
	4OdFBhV3VTlGcALrxNsEo4T8qndXxAJPNYXOR2qQi3C9YaSsgCLaXs64YUdcutgT15Bd6VKhj1u
	+IR
X-Received: by 2002:a17:907:9617:b0:c40:3a99:3f96 with SMTP id a640c23a62f3a-c419d9314d3mr779477466b.10.1792501224250;
        Tue, 20 Oct 2026 06:00:24 -0700 (PDT)
Received: from vschurink-Latitude-5550 ([186.247.75.132])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c40918c5f47sm482904466b.51.2026.10.20.06.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 06:00:21 -0700 (PDT)
From: V schurink <spam@acio.nl>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	V schurink <spam@acio.nl>
Subject: [PATCH rtw-next] wifi: rtw89: do BIP in software when not in station mode
Date: Tue, 20 Oct 2026 15:00:19 +0200
Message-ID: <20261020130019.137170-1-spam@acio.nl>
X-Mailer: git-send-email 2.53.0
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

rtw89_cam_sec_key_add() installs the AES-CMAC key (BIP, 802.11w PMF)
in hardware. rtw89_core_tx_update_sec_key() has no case for
WLAN_CIPHER_SUITE_AES_CMAC, and the driver does not set
IEEE80211_KEY_FLAG_GENERATE_MMIE. Thus, an AP with PMF sends each
protected group-addressed management frame without an MMIE, for
example a broadcast deauthentication. For each frame, the driver logs
"key cipher not supported 1027078". PMF clients discard these frames.

An AP sends these frames. Thus, return -EOPNOTSUPP for AES-CMAC when
the interface is not a station, so that mac80211 does BIP in software.
A station only receives these frames, so it keeps the IGTK in
hardware. This does not change WoWLAN, which uses the IGTK of a
station.

BIP in hardware does not work for an AP on RTL8922A. The test used
IEEE80211_KEY_FLAG_GENERATE_MMIE and RTW89_SEC_KEY_TYPE_BIP_CCMP128 in
the TX descriptor. The client did not accept the protected broadcast
deauthentication.

Tested on RTL8912AU (RTL8922A, USB) in AP mode with hostapd 2.10,
WPA2-PSK and SAE, ieee80211w=1. The client accepts the protected
broadcast deauthentication, and the driver does not log the warning.

Fixes: 940cd99625de ("wifi: rtw89: wow: support 802.11w PMF IGTK rekey")
Signed-off-by: V schurink <spam@acio.nl>
---
 drivers/net/wireless/realtek/rtw89/cam.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/cam.c b/drivers/net/wireless/realtek/rtw89/cam.c
index 22f21a0..58a7e8f 100644
--- a/drivers/net/wireless/realtek/rtw89/cam.c
+++ b/drivers/net/wireless/realtek/rtw89/cam.c
@@ -514,6 +514,12 @@ int rtw89_cam_sec_key_add(struct rtw89_dev *rtwdev,
 		ext_key = true;
 		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
+		/* TX does not support BIP. An AP sends group-addressed robust
+		 * management frames, so let mac80211 do BIP in software there.
+		 * A station only receives them; keep its IGTK in hardware.
+		 */
+		if (vif->type != NL80211_IFTYPE_STATION)
+			return -EOPNOTSUPP;
 		hw_key_type = RTW89_SEC_KEY_TYPE_BIP_CCMP128;
 		break;
 	default:
-- 
2.53.0
---
Also discussed in the out-of-tree repository:
https://github.com/morrownr/rtw89/pull/135
