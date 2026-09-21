Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CFC24DB540
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 16:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790009632; cv=none; b=jrX4O8I/je4OREvT+YGEQaq7fQ4XKZ68YGVUF9tsaKB2UgMOkIeKwajk8abiOPpQpbeD/ucNbw4yK27/mrgVkqEzRDamPPBoOZSBmLDf2fVn9LJUje4drmDpLQVNYnk59+A6pta77t+z7wcrEoemE9FASCf+1nXK/NlaT+yOY/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790009632; c=relaxed/simple;
	bh=ju4kV/UpOwL8oMIpHIU1WCk1ZKgKQot+tLOvqmfDh78=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ssv18XOyp30LDYNBRLsFE/ZO0ifLqs9TLY2cc1GbkTDapQfc3Nr+Df9FnfEBXJOjp+fP9D7Dwh411v34bJfyGAXD1oSXZw+1ETK0Qa0AX7ooRuQM8R0oH45ygjFhBsb9fwETG4ytMk0HVfu0tAji7JlRztk8zVv1qqjDuXMSrI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CldKV2AS; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CldKV2AS"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f633cd78so1807432f8f.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 09:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790009627; x=1790614427; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZdA+1AeVbFR/VasdQmXDBGDGpERDE8jftK4ovd1dF6Q=;
        b=CldKV2ASVBt0iUtnOxiJmgSntKlhD8WFTVrmqrvTBwQYXaL//2kJolI/5uf5kJFxXJ
         UrIBqqE5AwXBQK5RR2QJruullEHa4nnQ5jzDKVhjYAPg85ywt5mAtTGx0tWUZEYDYmuK
         7Q10ElKi0gMo/hJUIui84fR1vwqn9+azvbNatdRHddWj+GLSuZ15BxdeO0Uh2t0eIWSH
         PBowixFGckrQQRqgcOGgldJ74dsHdewslNSNB5g4GQvbNI9QSmmTrnVOjThT1pM9e1zr
         g7dF4Y7/kNii+Mtb2WdPTTwbnHSCadAANOP8+F9NHUr+R0DLR+aDmmd/PVGXwDqugqjM
         cOJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790009627; x=1790614427;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZdA+1AeVbFR/VasdQmXDBGDGpERDE8jftK4ovd1dF6Q=;
        b=um7V7XTakFmzBm78BFWd8C+yP/enz7LUAMzBupbli0h8ygrsvYD8Q7bX4aN4l6TcAj
         NaDyJ6SqWzmr30Pi+bcQnaIXGOHYpmEg9TnJ5hC1LLUVRMMaOOind4zH9mMC539d4XLN
         Km9wBUZA2dYXJP2rRyIy0obK84NmCflEYf8rpphlurCEQI4LRgRevg7CSEF4eIPM4ea7
         XDjCBjHQL7H40KrMYUNb/4GjiAm5sCO2AHcqKzBcFIyoua8nZHfwCZhVj9B24mNO22sz
         rxTJL+C/LAPlGbZbam1KUb2JZl9HNXqvKpW/ZVGpndgxsWVoySrN1A6SNaHsyzHtkoSO
         xF8g==
X-Forwarded-Encrypted: i=1; AKwUvBw8NC+Xa5KYl0HxqwJ/Bsdd7AKlyHqwTug4SHnfAph2kwTHLqozw1jVNP03WlAa+T0aev3NzSM3Kd1309m1QA==@vger.kernel.org
X-Gm-Message-State: AFuF++n588cMtzhYS79zWzeMVqr/hJL5lLv9qKCH7zplTEQGdGRFe5AE
	L3spxCzWZN23yJfAcBpLeFS8FY39cRzXPLP9eXjnzrwKISb3qOhbddu/
X-Gm-Gg: AYBFou06s5/2JTg/yppK8fKiL8OaxUA7F1k+XhLMU36RMb0nkDiZjZdDVIMxiDrAUfE
	zndrob5rN0xef5M6FC6kF9F49fSOZQknLxtLYnXMcsPPZAVVJxO8YrmC7Q3c0Kd1JYFDY8Auv+8
	6ITTj64gWPP9TntJL53/MprLk9Gxy0/KqDJcDPfiNjMgbIuHN46zCBFSo5cqoN0BtgPlHFChg/k
	2oVsbiL7rSDh4MAiJh2KQ4mFNMhorQ6kKmzvsre82BjhDT3INfhQhjgTsXwhCzED1ku7xF79Ho7
	1IEpcn5JbHiY9rGacc2lm01MG8zZ1eJlvgcp6VtGa6fQXcw2do101JYGQZAarOdNEgFxP3PfrRO
	4VkmQcC8eIt/Ior4eW/Xj9ooiDE/lnv2Yi9INnHeNAt8nETNm1f8XXX55t11AGaH1emwayymHdA
	bwPHjYyL0JP8dvP5JiG7U/K6c4OO7aI9y/FzUPtc2bEN/eyRPFDIUTurh9Wd6Aqwp20YlThnEpB
	jVjCyONF7IjBF+fgmM0wzDqMx+KaBWNGNaP5sezGfcOJVBEF2pM3Xpp1doR+WWshqvijv1y5B4D
	tJs47AuJrudaZgwL9Theaqw1DnP8hRWAecOkje2pl54KH5kad/U7O/DixFygs5V7pIqbYWW09Gc
	yCEzNMdets7A29ALtcbM6/rs=
X-Received: by 2002:a05:6000:2f84:b0:487:1254:8202 with SMTP id ffacd0b85a97d-4871e26948emr15904940f8f.30.1790009627377;
        Mon, 21 Sep 2026 09:53:47 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a00-1028-8388-a84e-5013-2bb8-9841-6147.ipv6.o2.cz. [2a00:1028:8388:a84e:5013:2bb8:9841:6147])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4872459f446sm22763142f8f.35.2026.09.21.09.53.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 21 Sep 2026 09:53:46 -0700 (PDT)
From: Josef Schlehofer <pepe.schlehofer@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	Josef Schlehofer <pepe.schlehofer@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH rtw-next] wifi: rtw88: extend the TX report timeout to RTL8822BU
Date: Mon, 21 Sep 2026 18:53:43 +0200
Message-ID: <20260921165343.8131-1-pepe.schlehofer@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The firmware of RTL8822BU does not always report the TX status of a frame
within RTW_TX_PROBE_TIMEOUT (500 ms). The purge timer then drops the
tracking skbs and the driver warns

    rtw_8822bu 3-1:1.0: failed to get tx report from firmware

every one to three seconds on an access point serving clients that use
power save.

The dropped skbs never reach ieee80211_tx_status_irqsafe(), so mac80211
never learns the ACK status of the frames it asked to track. hostapd uses
that status to tell whether a polled station is still there, so it can
treat a responsive station as inactive and eventually disconnect it.

Commit c80788f7c5ae ("wifi: rtw88: increase TX report timeout to fix race
condition") raised the timeout to 2500 ms for RTL8723DU, where the
firmware stays off-channel during background scans for longer than the
original 500 ms. RTL8822BU needs the same treatment. A similar change was
proposed for RTL8822BU in May 2026 but was never resubmitted, see the Link
below.

Tested on a TP-Link Archer T4U v3 (RTL8812BU, handled by rtw_8822bu) as a
2.4 GHz AP with six associated clients: the warning appeared about once
every 2.3 seconds before the change and not once in 67 minutes with it.

Fixes: a82dfd33d123 ("wifi: rtw88: Add common USB chip support")
Cc: stable@vger.kernel.org
Link: https://lists.openwall.net/linux-kernel/2026/05/31/713
Signed-off-by: Josef Schlehofer <pepe.schlehofer@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/tx.c b/drivers/net/wireless/realtek/rtw88/tx.c
index 4e110a457..55d7923e1 100644
--- a/drivers/net/wireless/realtek/rtw88/tx.c
+++ b/drivers/net/wireless/realtek/rtw88/tx.c
@@ -208,7 +208,8 @@ void rtw_tx_report_enqueue(struct rtw_dev *rtwdev, struct sk_buff *skb, u8 sn)
 	__skb_queue_tail(&tx_report->queue, skb);
 	spin_unlock_irqrestore(&tx_report->q_lock, flags);
 
-	if ((rtwdev->chip->id == RTW_CHIP_TYPE_8723D &&
+	if (((rtwdev->chip->id == RTW_CHIP_TYPE_8723D ||
+	      rtwdev->chip->id == RTW_CHIP_TYPE_8822B) &&
 	     rtwdev->hci.type == RTW_HCI_TYPE_USB) ||
 	    rtw_is_8723bs(rtwdev))
 		timeout = msecs_to_jiffies(2500);

base-commit: 73e3b1c94c7d5b4a113e7cbb42665dc2fe3b9d78
-- 
2.54.0 (Apple Git-157)

