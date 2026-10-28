Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793150785;
	b=LFHYnZefUtA4uLm6lp27wIThOAdrPeG9j5F7fG/MyQo8Plw9zcLvbgmzcizi1qTx+qg3
	 nIU4wCaq9dPselVH/cKQYxX0dFcwcFI1cM9WMQ6678rbHiKWwg0pkHfA8cjO8ajhRyuTf
	 3xKEbcZjS3hU7Dm0W/QGjuyOgTvU5eboGvuEPhaz/Zm156RxKjGuoT7zrupkOGoCUyS90
	 cbvhdlnpMj8WCx8wFScc6ytf1t9rM2yeB+ZBjIAsjkHmuJ9+c/DcHmJ1BWFSjwlvQsq0E
	 jU5sZsZ1ke2/uec1gQTZk2UHWlgX3ZNxBKXocqbmI48qFbwnCy8tta20n7zIbUGG/KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793150785;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=uOuX8lmp0xof0e0xCWW+uMkqG0cNoPc1tk+upESwVAA=;
	b=Z3tJCo1e2hKrMW6f6Ps5atx13IF8oHhO0qttHuci9IWb/joFBj5qo7QdEXMLfZ6AaQZx
	 q3idVNr8MKhYlnfuKiOeyuGkaUEvUZ59tGvY1cB4o8clsUiBUnKZKVyGV6uY+4UwFHP8j
	 UUYMS8bqy/GF8glQDEKP05tGMfngWqJ3QwxqVg2jKSOLKRImpzFBV07OOutK6lxiSoTv5
	 uqABZJJm3nfuDXUNskiiaqvq1UrlfkF/or1q8bPAEGNZ27MmqTmYPf5OrHzy/MTrYR4pZ
	 PvBBwMbkpVzGN1OIvO8y23b9FwK5L9H+77Qaj4fcP/aFcDSFsy2TJVMMjRAsGLtVs+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wD6nmJjk;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAD7606A31D
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 01:26:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EDAD7606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wD6nmJjk
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a7992e2f7dso3562645e9.3
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 18:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793150783; x=1793755583; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uOuX8lmp0xof0e0xCWW+uMkqG0cNoPc1tk+upESwVAA=;
        b=wD6nmJjkfOYRuScAAjWuroVnw8/yb8cS2myqAQz8AU6cn6hJkgnYxaQpjxl6D9mRMJ
         ZcFMgRHJ5n73SPLY5hE3oPlainPIQ32aabs5/Mxinv4xNdV0R/0GdT810Kwqc9Wy/EnQ
         qrMdqyCIlZXQ+Rux1I0L6w7iCGx6F7GJGDyF7v9+KHClhIml6bdDHOIBYwd3mJhMybRo
         zOIVMSncRPdj2Na19D+2eikNW36sXxRY/PmjRoU1FI9D299oP4KeSoVGJa3t8mtHK8cc
         E9J6Oj1RDgUTrpn8i3Pnmg/qojF1p5V0l2cjZOyAKigv9Z0dMRnemAUvzY9fLpGiM58T
         bY6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793150783; x=1793755583;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uOuX8lmp0xof0e0xCWW+uMkqG0cNoPc1tk+upESwVAA=;
        b=yvwHw/Dh899pSOolwQPWe/PflYrnP2w4cBhaGisfubAAXJeATtDxXvxvcs/fLD7fqt
         CSSkEQdfUQRP90l83k04U8hc7vo4dDHWJDqldHBFHz3IAFFUMB6OMeQDpVt5X8kUjT9W
         poBitg59bYulMhZbTlfAiyx73FiSuHSRQx13U3JY3nabc3AhE/Fb8I92SbQWLwxvZVI1
         5bugrc1GKR+/G++FIrJhm7wxzlA5eHm1XnfoJDaZ5OZDgdLowXhPLniIsLUmtMx0hjZL
         nmc73nk+mH8PvzEuWmpjWBIZUvqnCmIMT2+f2McyIUWtW6yGkpNLR4zZXJ5piXlcLOPC
         Tz1g==
X-Forwarded-Encrypted: i=1; AKwUvBzfU9bQsSYq4GQDF+rW+NerGBz/nZ3/wpaP9l4hK9LElIi8nVUaYXdbGk7tJKLdYQwOSQd9NUq903ZLe5PilA==@vger.kernel.org
X-Gm-Message-State: AFq9FYLO0STsGbmixmpezM76syWqHyZqPrRf0N0imNDzv+hsqSypzElD
	Smu3bLxSx09Fjy3OyyPwrg3cLJjVN5hwdmW3VjSI17lB/V7NWIs10Z9d/YAR
X-Gm-Gg: AYBFou3d00lGWSqZkT9LEFjmEdyU9u3Qz0f9Cg17fRgb07fd1cDYWQrWEY4bKTSY06X
	e+He4mz3vWGqQYxCi6mGxf+bU4/jqgGn99LyWSugrJ9LdQ/fby8pHwFAkBTXiKQI0mqUl5CQhLZ
	44fUiJpdJX2FprjCv2FP8N+6azf/MZRflxALVgqhGEuTB72l2dG5LrZAEPjkCpWYIDyksfNmoiU
	NmrHqPcjAQ1FvXCk2vTf2RPXUX3P9Jb3ezv/iC6YendY/UIYoc4jALZjvwn7IwZ/lMhJMmpDi2u
	eTR/wRhs6V91L/KX2aYu/FGvfAcGGJ4hf1XR3KRkMaQpO/DqS4n3OyyIPehYzLdgMSHoBlPxnLm
	T1daP8pT73rSfPVUMpdRqm+dgStPAoxbTmkIW/RsIHu5TR5MngihHCiLJhkqFPLmQi3D2wwwAlj
	nHxDSIqzXSk4244eMKahea3nhxMU7SO/o1qRTw2BZpV1rEhmI0cUBQp90ScSguOR+mBW63XbNBn
	0DMT5n10L/Gb+fvr2brhI9O4ZWFu72f4SDLxf8kRzgU7QuV4jsxqzGPpOwRDWOMftWhR51qxpac
	DU+d/VmKsdM=
X-Received: by 2002:a05:600c:190a:b0:4a2:150f:1601 with SMTP id 5b1f17b1804b1-4a966586d1bmr13640805e9.12.1793150783182;
        Tue, 27 Oct 2026 18:26:23 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a97c9f150fsm7935155e9.10.2026.10.27.18.26.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 18:26:22 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: Jeff Chen <jeff.chen_1@nxp.com>,
	linux-wireless@vger.kernel.org
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH v2 wireless] wifi: nxpwifi: validate scan response TLV sizes before indexed access
Date: Wed, 28 Oct 2026 01:26:20 +0000
Message-ID: <20261028012620.3762590-1-tristan@talencesecurity.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261025181531.3744345-1-tristan@talencesecurity.com>
References: <20261025181531.3744345-1-tristan@talencesecurity.com>
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

The scan response handler indexes into TSF and channel-band TLV arrays
using a loop counter derived from the number of BSS entries, but never
checks whether the TLV data is large enough. A firmware response with
fewer TLV entries than BSS entries leads to reads past the TLV buffer.

Add bounds checks that verify each indexed access falls within the
TLV's declared length before dereferencing.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
Changes in v2:
  - Fix From:/Signed-off-by: email mismatch.
  - Add missing Cc: recipients (Francesco Dolcini).
  - No code changes.

 drivers/net/wireless/nxp/nxpwifi/scan.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/scan.c b/drivers/net/wireless/nxp/nxpwifi/scan.c
index 67d7ff2f10c59..a8d3387320af4 100644
--- a/drivers/net/wireless/nxp/nxpwifi/scan.c
+++ b/drivers/net/wireless/nxp/nxpwifi/scan.c
@@ -1999,12 +1999,22 @@ int nxpwifi_ret_802_11_scan(struct nxpwifi_private *priv,
 		 * was received.
 		 */
 		if (tsf_tlv)
-			memcpy(&fw_tsf, &tsf_tlv->tsf_data[idx * TSF_DATA_SIZE],
-			       sizeof(fw_tsf));
+			if ((idx + 1) * TSF_DATA_SIZE <=
+			    le16_to_cpu(tsf_tlv->header.len))
+				memcpy(&fw_tsf,
+				       &tsf_tlv->tsf_data[idx *
+							  TSF_DATA_SIZE],
+				       sizeof(fw_tsf));
 
 		if (chan_band_tlv) {
-			chan_band = &chan_band_tlv->chan_band_param[idx];
-			radio_type = &chan_band->radio_type;
+			if ((idx + 1) * sizeof(*chan_band) <=
+			    le16_to_cpu(chan_band_tlv->header.len)) {
+				chan_band =
+					&chan_band_tlv->chan_band_param[idx];
+				radio_type = &chan_band->radio_type;
+			} else {
+				radio_type = NULL;
+			}
 		} else {
 			radio_type = NULL;
 		}
-- 
2.47.3

