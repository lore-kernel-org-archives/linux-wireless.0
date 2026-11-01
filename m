Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793540620;
	b=G6VBKp2qsq2CnMBoE4Tegx0tSgERYunY8oBxpj4a8+H08MUdnsTtVTJxL9PE+SHeRcrn
	 zxULIesN3qzqak7nI5YqqSeTJQjCBbzEQ9wAitC6OSunGcxHhcpyu+1triPITUO+V4XDL
	 TiftMrvuNEon2AmniJiV9TTvE+l0Bh1KVD3cQoz1O1uqwSUfriDcerUepz4rT8QytV8lB
	 3Ya95n9mle2IETWIJpmzh4CO+uMULh25kmomJyTkRIaZSHmflMamMS+ubKQnTI72aZZFz
	 +u3UYANI4pVMwlL5DTVhvxZAqsMYETi5uqEhgr8nxurCgrSSfOAHxXnj7OZtnVUhJMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793540620;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=4661m1xYP/jYEqHVXb2ZQHfA5Qdo4lmezgeOZnGqpSk=;
	b=A9wK2yPQkZYsrSbF/7lf44KZ8UDRj0MoOTZF072V7cEdbbvcmxG90Zf5gcK/vGRFXc1z
	 mD7idf6XPIKvixKhQw3UVUGloNkaDXJKx5YUHYj97hkMbBaSel99iZewdXAWHKWhHvog4
	 fR9iRJrSyB0mnoy9c9NYVAWLS96KLNhYowyFu/unTW3S93O4J8LbiMZRpV97t2FpFlwJ0
	 bGnnqMbdj3Y5Q83EitrydrB97RErtlDbAZUnf1O50Wb6j1Er4ymeVrwGNyhy7cr+yAMkB
	 fH580IYX/dLV3xTgJwsRQNaNl6o5sJpm0ueO4c30LU9AKQKbHnbC4ZMNmq6sA//FJrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eisKOQnv;
	arc=none smtp.remote-ip=74.125.82.169
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A66606A326
	for <linux-wireless@vger.kernel.org>; Sun,  1 Nov 2026 13:43:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46A66606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eisKOQnv
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-35b2c599f43so2934611eec.0
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 05:43:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793540619; x=1794145419; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4661m1xYP/jYEqHVXb2ZQHfA5Qdo4lmezgeOZnGqpSk=;
        b=eisKOQnvuhXLkFpTLtfmv29J4yIGP8l4y+CQnaDOTYY+ApcPlAkuI9OJbUqcBQazqM
         NGKpVY58FJd5KtwXwV7vqzHGC7Uo4fowQnAu3w/XfTq+YOj43laEFWiU+x7+QQJrrUnk
         ye8hz1U6Iku+8wJ1xBbiyyHtexPJdqQZOK879xmHeNb57yMpvfk3+HLNqqrN+EykPeoV
         Wk2BJwPkiZLUgeSLbvOAzK/ACa0oMRLy9GyCam3o3wLPUcvAjt26bMx+3j1LiuzRcSL1
         s6V1qqbVh//JrZi9xQb9lRm7UZFDEj2rMGSt3HNn321OUSHU4oTY51y0E4MAm5DjeN9k
         YTVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793540619; x=1794145419;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4661m1xYP/jYEqHVXb2ZQHfA5Qdo4lmezgeOZnGqpSk=;
        b=PgHJij0VtYWY4giBQDpTc8eZyspGMfevpAjYwwyF0z8tJFkjWVbi78MM7DEhu1RVXB
         cn2JtDNM/lOLWnL5kOAi9g6qEWNXPahL+pbUW5KcMdVFwhve0ZXmICqBKTvsU5oEcCCY
         ec5CIShcL+62HPWpP/H2J6Aq5vzE0Sv4pUqjP5ubWpgcthJduuX+oXw1d2aWRJSaImfB
         2ehBJZ7qYl5pQfSqynu87GlvJiZrC+QcD9Rypl8BWgQgIDFcE07Ldec9WlvAawbaS2rE
         XGF4YuFfXVXeNBj9NhAnEl5ApYNZA6T9Lz74JIbd1O8FB9g9DH6BGxid9P7S2BTXvd6L
         yr0Q==
X-Forwarded-Encrypted: i=1; AKwUvBwrTXCsgEYgl4O3wFzofD1dUk0tFcYjV8fbh8EkaCeuDS59kcrIhGUv/mrcdCtcv/22b3CFWMANSlxZBFqWqA==@vger.kernel.org
X-Gm-Message-State: APuU4Z+48XGSVLd3jjMXYpd3XZsj3aPtHg9Qe8BEWzBRfUXA0OwqHymi
	Qg5ii45CjSyM9eie35MwAR/GXVD9O/dQfvVi0yJCR63KfXuDOWNAT3eY
X-Gm-Gg: AYBFou0Vyn3V+mFHIPR9LRr34CTnRKdggJmVFT0rE0IHZMhwz9fku37YzMPkZcRNFUt
	Vo2lmN3d/dDPQCCfuaY4lbdCvS4n6a530mXPjzI+2Ajs6fHRaOpCMEWjjUnetHWUFPw9AZACBXJ
	YZLuSHy/IjUetdswrcpOe3mtEXWVAISAmJDwzSj2508cTY0+MPxhLd78cdqTgfRkP60dhVtf2Gg
	1xkH3KakpMFktfyTTH2CB5zQalhKYvZiyAcCQKPr98hCq1EuyRD5gHUH+DqfFgCSB2piGGs/+ix
	gjVuTaEY5WoHHtyF6agQk2xFzV3AfSbr561biL3t8qIEehaNYwM1kXFWDTDb0Ck1knG7JQDKu5S
	Ncs6PBL5iFjii1oyvCJvBubpJZDxc2h8V5xk4OofLgbCbtkiIorLnVRxq1ZsnptzrrpKhOGGq1k
	1cMgVt3c3g4cpTx0cPbl9KCHQe3nOSrSXPkq436gy+eaEWEeiktRBnHQdXpUZWlvJWuYUCXp4MF
	h/rQ/YlvQr62hpvT+oVBhGCWovJWI6mLUDXw6eMAF6QClKC9gLiKDDJbTbJsRGQ+JEqJsTomvyt
	HzSk+KX/lew1+glYxyEwtPQhXp7WXzCPF0LyM71aE0Ffjw==
X-Received: by 2002:a05:7301:7306:b0:366:2893:7421 with SMTP id 5a478bee46e88-36a4235f6aemr11038645eec.10.1793540618755;
        Sun, 01 Nov 2026 05:43:38 -0800 (PST)
Received: from KRHW1CJW23 ([139.177.225.243])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a42a98f65sm26717779eec.28.2026.11.01.05.43.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 01 Nov 2026 05:43:38 -0800 (PST)
From: Zhao Li <enderaoelyther@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	neo_jou <neo_jou@realtek.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Kalle Valo <kvalo@kernel.org>,
	Hans Ulli Kroll <linux@ulli-kroll.de>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2] wifi: rtw88: usb: stop RX work before unregistering hardware
Date: Sun,  1 Nov 2026 21:43:15 +0800
Message-ID: <20261101134314.39340-2-enderaoelyther@gmail.com>
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

Disconnecting an rtw88 USB device while RX traffic is active can leave
the RX worker running after mac80211 hardware is unregistered. A firmware
event can then queue C2H work onto a destroyed workqueue.

rtw_usb_disconnect() kills the RX URBs but does not cancel rx_work,
which their completions may already have queued. rxwq is destroyed only
after rtw_unregister_hw().

Cancel rx_work synchronously after killing the RX URBs. Only a
successful RX completion queues rx_work, and no RX URB can be
resubmitted at this point: rtw88 does not set soft_unbind, so the USB
core disables the endpoints before it calls rtw_usb_disconnect().

LLM assistance was used to find the bug and review.

Fixes: a82dfd33d123 ("wifi: rtw88: Add common USB chip support")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
Changes in v2:
- Drop disable_work_sync(&rtwusb->rx_urb_work): the endpoints are
  already disabled, so rx_urb_work cannot restart a killed URB (Luka)
- Correct the commit message accordingly
- Drop the 3e3aa566dd18 Fixes tag and the stable backport note; the
  patch now applies unchanged to 6.6.y and later

v1: https://lore.kernel.org/r/20261028141904.8707-1-enderaoelyther@gmail.com

Validation: A W=1 build of usb.o passed. Not reproduced; rtw88 USB
hardware was unavailable.
Sparse C=2 and Smatch introduced no new diagnostics.

 drivers/net/wireless/realtek/rtw88/usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
index 64e1c3420e0a..56ca4496b2e6 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -1371,6 +1371,7 @@ void rtw_usb_disconnect(struct usb_interface *intf)
 	rtwusb = rtw_get_usb_priv(rtwdev);
 
 	rtw_usb_cancel_rx_bufs(rtwusb);
+	cancel_work_sync(&rtwusb->rx_work);
 
 	rtw_unregister_hw(rtwdev, hw);
 	rtw_usb_deinit_tx(rtwdev);

base-commit: af32da41b0327b9c6a37856ba82b6760d6c8d10e
-- 
2.56.0

