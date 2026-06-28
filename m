Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8DA2771E
	for <linux-wireless@vger.kernel.org>; Sun, 28 Jun 2026 00:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782605117; cv=none; b=F2yUxUQ0xbYb5tvH/JqQUtVWJtcP1/hvTv/Qj/WqkMG7vExCWuzykAQmaMZWA2vFHLjc8Lub+wdfctOnrf2z5Dmnw0wPJPWUAMX/ejEwR+vUVwRLNPrRXEOOjmd2eguBqSqIGSqIsNk8Hx5oezDARIjnH6O4wVNFgc5+DP38X0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782605117; c=relaxed/simple;
	bh=FB5wGAqoS2bX2ASLy/sBczt26iL9deLkDzWEdROLpMo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Sz77jlkNYoscqF7NQ+0+/NRCsRIjCAtSR06ObroR/jVprbFoAwspyN6/uDDLmVhpv3/WWN2QnMz1RZfE1VRqv0ET8JB0AK0FgWTd57hhIG3tVp4IU2RcBWXR/a323uMp4ILSWefOIKALj5191o6+Uy6UUIZev6YOnjJI/o8CKiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=lWpKw3iq; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="lWpKw3iq"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c964d52321bso168932a12.0
        for <linux-wireless@vger.kernel.org>; Sat, 27 Jun 2026 17:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1782605114; x=1783209914; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=okD/Agid8Qwsbynaw3O1TDujT2jmme0nOePqmfn3oMs=;
        b=lWpKw3iqh7u1zMHdTXM1s2M8r3eeHqvY0Z5rLJvYcHplCe/OTI9tibCGWf10+n7Ceb
         ++WeXtYgo4II873VT2yLcXQG9llELW2/Eef305Js/DAFe2LrVICe6mRptSg7F9cSHNqj
         tza+SOPZOcI9j6TWCRrSGFW9zc8H1VeVFK6bqzJH1Txsgx1M2JO/zal3no3130QYP/5i
         aGJYeEC4/oPN82oPNtSHlN+DKrAZYJ2lOWg49zwYzHAFKxMEk/b3b2VLE7mBHyDwETJV
         MBPjr7wc3xxWtbwJsZZsfZ15hM+3VVR9994iXEMBkani/JxQGvNrerf1N1qVxA/1qaqr
         gBxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782605114; x=1783209914;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=okD/Agid8Qwsbynaw3O1TDujT2jmme0nOePqmfn3oMs=;
        b=FXF/Q3yB7PB4YB4PP2aO05Vyw88STrHXrPkvb0LKt/ntFtWYP4qOeKGkaRyHPzgbqz
         rtv+9AjPBrIZVode3wdeQHt4yvhsxX3aPaSR6Qhp7te6Ro7bBrhYzK4qejh56uTwr+76
         vNQlG2CBvSkdF0frDQ8JwkVboNNs9eggCLfkDSFer++lKMciiQSt48K/Ji259uNW7/9V
         OHV6alUY8DNH9UfjwamaKLKZnVJfV2BN2hKEtzWIdS0uSLdHcm7rnGYHNSS1qpLM1vTh
         G9AtKF/uiihe0wy1J52nMCKlZoJneUREgfJHgWMrHLftAK7M1m8bm74qU8DlXISPe1Th
         eDWg==
X-Forwarded-Encrypted: i=1; AHgh+Rq7fzPHLCCEKZrh4UzqJmSGYBo1qDS52ElWfECWcif8fNUaTSB2wdgLgf9RIogA8IavBmhv43GyjURwFCxHfA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyyL0xYKF8YzovptcIxgBpcW7AeAGbLN0AJiRECMpuEwNTwldoV
	1YpUyJqXKhqYlE9O2dvfhAH/826gYS5TEVjOM2uzZPds0c361W+bc/gCU1gmAwADvw==
X-Gm-Gg: AfdE7cn1AsoL+PRCajHth1oBSauaLtoR87Oz3d7pm3YPx7vUZr9BUx1KI0n/2eW4sno
	kuDaOA4SjnMkVssW09f/d6gvOwVCm+2/VPu0bsMJxt5vbcj5syEFSFC6Zve5DlbThTmQy0RIq9D
	JG7wq+McopwFNzGy4N2uPGq+JNuxtMMgpge2dznGNYF7Iayp71Me0xpmgPfE8xa74e9xhSqVS7s
	w37qQNQZr+HdJIhQSse25kO2Vf7A73DeOKx3Unr/QmCZcylOnowzW1+1UsZFwitIOKSP+crkOt7
	xe4w0ny1PiuqoIOsuzQy32AeT8UC515O9AuDQKlL6QscyHWlA0N2HsLzdCxJFh7liBFHsfAQ9vZ
	mvqp8anZIT7Og39+Rij6qLabWvtCzp4OaIRP3UNkLZZ7PYjGfVOe/r/IWqqGdqCg/ADWzjcudjZ
	GPwq1Iijigbg==
X-Received: by 2002:a05:6a00:1382:b0:842:2419:6bfe with SMTP id d2e1a72fcca58-845b39a255cmr15532331b3a.7.1782605113558;
        Sat, 27 Jun 2026 17:05:13 -0700 (PDT)
Received: from p1.. ([172.56.108.113])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847702a9d70sm79900b3a.20.2026.06.27.17.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Jun 2026 17:05:13 -0700 (PDT)
From: Xiang Mei <xmei5@asu.edu>
To: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Arien Judge <arien.judge@morsemicro.com>,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>
Subject: [PATCH wireless] wifi: p54: validate RX frame length in p54_rx_eeprom_readback()
Date: Sat, 27 Jun 2026 17:05:10 -0700
Message-ID: <20260628000510.4152481-1-xmei5@asu.edu>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

p54_rx_eeprom_readback() copies the requested EEPROM slice out of a
device-supplied readback frame without checking that the skb actually holds
that many bytes. Commit da1b9a55ff11 ("wifi: p54: prevent buffer-overflow in
p54_rx_eeprom_readback()") closed the destination overflow by copying a
fixed priv->eeprom_slice_size (and rejecting a mismatched advertised len),
but the source side is still unbounded: nothing verifies the frame is long
enough to supply that many bytes.

A malicious USB device can send a short frame whose advertised len matches
priv->eeprom_slice_size while the payload is truncated. The equality check
passes and memcpy() reads past the end of the skb, leaking adjacent heap:

  BUG: KASAN: slab-out-of-bounds in p54_rx (drivers/net/wireless/intersil/p54/txrx.c:507)
  Read of size 1016 at addr ffff88800f077114 by task swapper/0/0
  Call Trace:
   <IRQ>
   ...
   __asan_memcpy (mm/kasan/shadow.c:105)
   p54_rx (drivers/net/wireless/intersil/p54/txrx.c:507)
   p54u_rx_cb (drivers/net/wireless/intersil/p54/p54usb.c:163)
   __usb_hcd_giveback_urb (drivers/usb/core/hcd.c:1657)
   dummy_timer (drivers/usb/gadget/udc/dummy_hcd.c:2005)
   ...
   </IRQ>

  The buggy address belongs to the object at ffff88800f0770c0
   which belongs to the cache skbuff_small_head of size 704
  The buggy address is located 84 bytes inside of
   allocated 704-byte region [ffff88800f0770c0, ffff88800f077380)

Check that the slice fits in the skb before copying.

Fixes: 7cb770729ba8 ("p54: move eeprom code into common library")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
---
 drivers/net/wireless/intersil/p54/txrx.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/intersil/p54/txrx.c b/drivers/net/wireless/intersil/p54/txrx.c
index 1294a1d6528e..9f491334c8d0 100644
--- a/drivers/net/wireless/intersil/p54/txrx.c
+++ b/drivers/net/wireless/intersil/p54/txrx.c
@@ -499,11 +499,19 @@ static void p54_rx_eeprom_readback(struct p54_common *priv,
 		if (le16_to_cpu(eeprom->v2.len) != priv->eeprom_slice_size)
 			return;
 
+		if (eeprom->v2.data + priv->eeprom_slice_size >
+		    skb_tail_pointer(skb))
+			return;
+
 		memcpy(priv->eeprom, eeprom->v2.data, priv->eeprom_slice_size);
 	} else {
 		if (le16_to_cpu(eeprom->v1.len) != priv->eeprom_slice_size)
 			return;
 
+		if (eeprom->v1.data + priv->eeprom_slice_size >
+		    skb_tail_pointer(skb))
+			return;
+
 		memcpy(priv->eeprom, eeprom->v1.data, priv->eeprom_slice_size);
 	}
 
-- 
2.43.0

