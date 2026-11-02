Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793590379;
	b=2PARSYMqH4rWjMpgDxFnVcN1zi3vntQfes+6O8PYmVQrAWBOPQFdSI5SKPO5BrtJIcCJ
	 1laxpREO+lnKUEiLRM4Tg9pmP3pTrPqH5uFixMmYtz+/A+YUJulcyYFMXeRbipVtADzkX
	 hYEziAQwbzLpoLdDJxwM04PtOO0QsNhz2uouF8IvMOBalyoPufgt9L6At+wIBDVjim/ek
	 /MCqvlNxlGpJVHKeDYcDu6oHEoE2+4mn9z4TmyR5OKTh/pZk6UpQko0SGzza+GRNMbA8s
	 3WQp58v1A6mjnCvQZREAdyK7NK0G3M/3KdI7QvFKunzALWpvddUWgc4DkmS7+h9XTLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793590379;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=S7SJ5Fy16dS9ma34ZFjczTKK5q3vqU0jFNFBbWoQo8U=;
	b=jwLKYzJj0b0hRB3WdFSGP1IdFdblLUSxC5mJ8+QpjYgNPCaZwzH0XBqk8cVEjG9BW+af
	 cy2avq3YaWoKtYEUq+8Dqetga8/VRrO3dQpLN/ezf6/uAfjhyf5ymowLcELZTCurwJCIR
	 8jT2mRRMf4XsQPYW7lAI3VsW2OWqZuev2ReMTFP6vf0ui/aPlbVs1LVs0QnhCsU4e9MP9
	 zKwhA0EKnXk+fEhjiJTbZHvQB4Kofk4C4hiZSoEUzjFjGzjAIdIWSlkLrBm/ztlIieFNN
	 Il8SqAjcT0UJ53aM7AzfovYL8LZPyABH76R+DaAYGrncGxq3zlYrsjLZvxQ8AbM2jxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EIswVT3q;
	arc=none smtp.remote-ip=209.85.215.173
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE54C606A32F
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 03:32:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CE54C606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EIswVT3q
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cd6a7e1f4e4so996092a12.2
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 19:32:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793590377; x=1794195177; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=S7SJ5Fy16dS9ma34ZFjczTKK5q3vqU0jFNFBbWoQo8U=;
        b=EIswVT3qttYkfY9/tRLTww5O5jMBDZAu5CwAHtMCuf6zhej3VJ/hWrxg3193ECgw+/
         RMJ13Pzv8RHtT1dgJ8mtOXuKIlgD3IvHObYFPm+JmkYVswDwe3k/u5BPQemTuOD9mk3J
         4MykYhFepS5AETp+V/LMYZ5RQwFMC6IiXZoreZM5nXWtyRZtaAUK8ikU41oQACPtIsaH
         rnH0chzUxzRosOi/I5F58mMgTugt9QIjDrpYYaCQViVkxELjXNTIeIZbqWcIHXOsUvu1
         jUsdCmIcda5SO/SeLmjPePe/ETORYZMSrBYpAi2oWVk0eh0hy6J7y2YLQfrnhtFIlRv0
         A9GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793590377; x=1794195177;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S7SJ5Fy16dS9ma34ZFjczTKK5q3vqU0jFNFBbWoQo8U=;
        b=aDdfP+8tEDzGSeRGI0Kybj2D6arGqIaWARUFJniDFXTKrewM0nbFfLsYmpWQGp4FNx
         sAcMbnzGRuIMMV3drGweMZL+A/f6WpfYbmHAQHYpgF4sB1nd3R46R/KEGzbzDumt0oxb
         FtowEWmOwJWR2I1/H2DO/F44BwYOLgd1Qs0tMbYQcmQPLys0rAgyGQBja1sDHck6Be4b
         zu/qcLzLBkzbvr8o3/S+Ys/nFKft5NMa+oHqXzmRUgdQPXuNB7jrwg8YSUIiBaPbV7hK
         jEQSFwUpmV2YT2Np3iwN1wdCWgMp21Pn7poXm/xJk1XnudRuo4IJPzviKtwm6QVtpqah
         CWeQ==
X-Gm-Message-State: APuU4Z8gdQI/4vqlCnbZZgJmcPJz9jOgKsw3gv5kf4mFF/35z3reCFc8
	K2RTpT0thLDu3qk83dRviYXG+rQCA7RFVSWv6yAKsy6odlhmkfLJTVbN
X-Gm-Gg: AYBFou2qJgoFjqdTwGtOk+AwwYikT2EpJ/4DQKB/LdUsgx8OfsezywFUAy4BDvcFuk4
	DmDUhDLfOb4QbUn4+QNiZgGVLm2puwHrzlfnLkEGPTklmDmP6FDuJObBrIL8n5yE5zMAsXBV8VB
	3ZJK8UxYXRacbS3uKoub7GR3fMF2dYvpsjL6webMVlZbydSktFY9EKqEJw5md/H3FnGEuHs34rP
	DEeyYbTLhUC9CoMIcfMXfeZ6pe3EibKtXNBaO7FINecTmTGmMKtaozisbIKdszqgmLkoa/48Anq
	54BRhdz2BfA8/3PDScUdje83PjILqtKTj3R0IrrQcjaOe2oWr1Afemv+kJ2qSIEf34G7TK40oXd
	MdUEujnTBOSROebG4l1giLA7Wstr3zXqdq6APc6p1bv2x7U3WFF6TBPvIjb79qW5JKxyBxR4JMH
	q81BNS6eLhqLEQUmNeF/AOosiG15mSqFgK3v8wN8IEi8eQahEa/EW9/gZz0FVM22l7yvAN2Eklo
	XRVyZABO/8COxfNlAq/EhVSyE/ejrzAMTnmLWKuM+5VTG9jhNC/kPLPqhHSCofZFE9cWCvRD8To
	GYJzq3vL1gmnyIGTjc4+yrMacbrG29lJbcLG1bSFRPLqm8ueOruD/4CMOWaMDPHWH3DI8WctC0e
	O9YaT
X-Received: by 2002:a17:90a:e7cf:b0:3ac:9a54:e3ce with SMTP id 98e67ed59e1d1-3ae8986e718mr7841574a91.63.1793590377119;
        Sun, 01 Nov 2026 19:32:57 -0800 (PST)
Received: from hostname.tail4fb79.ts.net ([2401:7400:c804:b668:65cc:625f:9c43:1e88])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3ae845432e4sm12087044a91.3.2026.11.01.19.32.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 19:32:56 -0800 (PST)
From: Ho Jie Feng <hjf3108@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	Ho Jie Feng <hjf3108@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Hans Ulli Kroll <linux@ulli-kroll.de>,
	Kalle Valo <kvalo@kernel.org>,
	neo_jou <neo_jou@realtek.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH rtw-next v4] wifi: rtw88: usb: don't report the aggregation buffer as a frame
Date: Mon,  2 Nov 2026 11:32:44 +0800
Message-ID: <20261102033244.9330-1-hjf3108@gmail.com>
X-Mailer: git-send-email 2.55.0
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

When rtw_usb_tx_agg_skb() has more than one frame queued, it copies them
into a new buffer. That buffer was also handed to mac80211, as one
additional TX completion.

Report TX status only for the original frames, and free the aggregate
buffer without passing it to mac80211.

In the case the ieee80211_purge_tx_queue is called, the frame is
passed to ieee80211_report_used_skb. Since it fulfills none of the
conditions within the function, the frame is freed as normal without
a TX status in that case too

Fixes: a82dfd33d123 ("wifi: rtw88: Add common USB chip support")
Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
Reviewed-by: Luka Gejak <luka.gejak@linux.dev>
---
Changes in v4:
- Add reviewed by
- Add description for ieee80211_purge_tx_queue
Changes in v3:
- Change to dev_consume_skb_any from a suggestion by Luka Gejak
Changes in v2:
- Remove unused drv_frame members in structs drivers/net/wireless/realtek/rtw88/usb.c | 9 +++++++++
 drivers/net/wireless/realtek/rtw88/usb.h | 1 +
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
index 715a2ce342d92..10f6d3bea0dfd 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -342,6 +342,11 @@ static void rtw_usb_write_port_tx_complete(struct urb *urb)
 
 		skb_pull(skb, rtwdev->chip->tx_pkt_desc_sz);
 
+		if (tx_data->drv_frame) {
+			dev_consume_skb_any(skb);
+			continue;
+		}
+
 		/* enqueue to wait for tx report */
 		if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS) {
 			rtw_tx_report_enqueue(rtwdev, skb, tx_data->sn);
@@ -431,6 +436,9 @@ static bool rtw_usb_tx_agg_skb(struct rtw_usb *rtwusb, struct sk_buff_head *list
 		goto queue;
 	}
 
+	/* report TX status only for the original frames */
+	rtw_usb_get_tx_data(skb_head)->drv_frame = true;
+
 	while (skb_iter) {
 		unsigned long flags;
 
@@ -655,6 +663,7 @@ static int rtw_usb_tx_write(struct rtw_dev *rtwdev,
 	rtw_tx_fill_txdesc_checksum(rtwdev, pkt_info, skb->data);
 	tx_data = rtw_usb_get_tx_data(skb);
 	tx_data->sn = pkt_info->sn;
+	tx_data->drv_frame = false;
 
 	skb_queue_tail(&rtwusb->tx_queue[ep], skb);
 
diff --git a/drivers/net/wireless/realtek/rtw88/usb.h b/drivers/net/wireless/realtek/rtw88/usb.h
index 94ff21dd08463..e861e9a66ab22 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.h
+++ b/drivers/net/wireless/realtek/rtw88/usb.h
@@ -59,6 +59,7 @@ struct rx_usb_ctrl_block {
 
 struct rtw_usb_tx_data {
 	u8 sn;
+	bool drv_frame;
 };
 
 struct rtw_usb {

base-commit: 9b0be45d4d52fd223994e151f169743a97abd290
-- 
2.55.0

