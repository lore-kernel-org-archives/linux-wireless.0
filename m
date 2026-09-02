Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DC5469833
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 10:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788345715; cv=none; b=DGsCoMU0t7G3jFrbGHDiBKe+QGu+xRnAB0xx/iG7U2hZrvpZ6gkit4uSO9QbVAYvOoUlKaZHz98+EHq0iSCKYWmirueIDrNICDDZjFl6ESD6Ljt0qgB9kzHh0Vrl9KuZU6ih5Va0epdYpYcXULyRSuxNgsklog3Z7Ny6lGpSRds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788345715; c=relaxed/simple;
	bh=6Y5dZk4fYdTfFsYzaoLTW53k180kqLYI8LAqtF3RXPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SFkduxfYBkcM52aGe2ZIQuin1+fmNpdKyXJTXj/xACqhYxbx8nXThtxNZhwwDHmDP5R1EDp9xV+mrv6w7B1mXMiRWUGcShrb2SyZ6nRAJpFz6turT/D6ZyHMW4dHd/Zxdrq0IwzpT2gsVyCDxeBysZz0UNCu7etuQGUAbO0wBBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eH5t7WcD; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eH5t7WcD"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-482e61a34e5so333048f8f.3
        for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2026 03:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788345709; x=1788950509; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=E7J+LYLRSNIiM9iUYMchgZFk3biexps8SwXQ2tzLjc0=;
        b=eH5t7WcD0WSRh6EdT9p/CfFZXRJbjkAS+XWURXykdhmM93cSLPqApzMc3rbEVQjgdS
         mtquDa8DUBDt/M8E9Ed7wUXP2wxCj0akHQ6HrhErdFKfqlScoXJm0jxSl+qAbmE2Ya9I
         cb47+p51/uMbOTK2NzzfVmt2LLvxmKIEEdLR1dg+RJJ2SAAVXAT60khSxHDV78pwvA2t
         UtKZY+0bWKbNjH+tevXq6YGRkhD9CSPsVKXpyzKF01rxdpZZKCws4RYy5nmb+uMPtom6
         14tgQhVpDgpAABi4eyJWyS4NtM3JYFwcCM281n8XLyfFY/Ml3YuDhXbZN1rhtYx183Ez
         nABg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788345709; x=1788950509;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=E7J+LYLRSNIiM9iUYMchgZFk3biexps8SwXQ2tzLjc0=;
        b=NnQaVm22s1XoASDvCFvajoGAXrRIRGOa3s6z3UMyVaGSuuq77Vk13hj16XVfy/mfrH
         vzfFpcmRSo9sGPcmZRHaPwX4MJeZF3aMsGMBzB+97ovk6iF/Kkeg1pHuNYPgeagExHKW
         vbbQ47r7h4AYrXg4bA4Rac5+9Az24ERnR3cywCiwQif/uewsZWIMMMijg01jjsx0bsHO
         ZpKtzvvk1TFS6GwU+qoNzOrQHaF7AnUe6UEvB+rzTgFyrFycumQeYZ/WzoTv3Fn3mpxR
         UZu7ehfUbui2d9EdA0zn0CFmH6RTWPrPzWERleGwBDPy1hqX7n2RaKztmfjm320c3RPi
         +7vg==
X-Forwarded-Encrypted: i=1; AKwUvBxwaXE/maLjdk+xYJszK0cRPRhi42EgO6/yYsDhaNn3hiekSf/U8hyxLo6hSTSIjKXrE7njuaSCXAhcgLmiFg==@vger.kernel.org
X-Gm-Message-State: AFuF++la+jYvAoESnZuX9g5wDqjilC25K3kMoCjdHeIm0Py5Du51sBs5
	zC/g8dhuP0Z8vqdiUwVAGWkn1aME2kAWM5j/GvpY6hO8jRTO4NGoFYuh
X-Gm-Gg: AYBFou1RrkF1hQk0FmhcxYTv+e2g4czlg9RmYfDXZ0VJDaTSKcFx6uQBmnNqvCl3lW4
	RkNx9JPklmT/5wPKAHR0VZ219z8NX/RYZKUDUY+Nd21lvMPwCLFzgCQ2XkRUcmyN3PtiKFpMwTt
	IGDCGCujFv1EklMdMYPetbYZLyUcCNFfjg/9ggNuP+iJ2qu+Au/MI5M7GuIy4pSoIs3x+/fE/t8
	pFPgRe28RFAaTsDh0JbDeYbM//CMpRCSJgnB7aqQPuCEwPC3l4E56Q/EBjMSbZtt55NCfi8IO9U
	/r7zKGBpBFoCrPV0HYQ7qjh7EKkg0NCVxKyKbckWYFQRe8dN5wVDrdcw85BV+bW3sUMZdqeast5
	62+FS5XhlJCIQsGd03eUm5kG9hws7FLXa3UoLl/ZXPPyrBS9LLzZbi+FrkAPY12sQQlUzqTI8jA
	jE4NgibW/QFQ6cmQCRtMacbw/CDnj2ELKRf9cfswhvLfLcouwhbofzWIUKNT10yYGORA==
X-Received: by 2002:a5d:5f52:0:b0:482:ea2b:c598 with SMTP id ffacd0b85a97d-48488dece54mr6202124f8f.6.1788345709018;
        Wed, 02 Sep 2026 03:41:49 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48448e72df2sm5998947f8f.1.2026.09.02.03.41.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 03:41:48 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mehmet Fide <mehmet.fide@screeningeagle.com>
Subject: [PATCH rtw-next 1/2] wifi: rtw88: usb: bound what the driver feeds the after-DTIM queue
Date: Wed,  2 Sep 2026 12:41:45 +0200
Message-ID: <20260902104146.3853102-2-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260902104146.3853102-1-mehmet.fide@gmail.com>
References: <20260902104146.3853102-1-mehmet.fide@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mehmet Fide <mehmet.fide@screeningeagle.com>

Frames routed to the high queue are transmitted right after DTIM beacons
only, inside the ATIM window, while they wait in the shared TX page pool.
The driver puts no limit on how many it hands over, so as long as one
station dozes, any sustained broadcast or multicast traffic outruns the
drain and empties the pool: measured on an RTL8822BU AP with a single
client in power save and ~40 frames/s of mDNS chatter, the free page
count at 0x240 goes from 1803 to 16 in about 100 seconds and stays there
for as long as the traffic lasts. From that point every other transmit
queues behind the backlog, authentication responses arrive too late for
anyone to join, and the reserved page download fails ("error beacon
valid"). The AP keeps beaconing and only a reboot recovers.

Feed the high queue through a small token bucket set below the measured
drain rate (about 3 frames per DTIM, ~15/s at dtim_period 2 on the
default 2 TU ATIM window); whatever exceeds the budget leaves on its
access category queue right away. The high queue backlog is now bounded
by the burst size under any load, so the page pool cannot run dry, at
the price that a dozing station may miss part of a broadcast storm.

Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
---
 drivers/net/wireless/realtek/rtw88/usb.c | 42 ++++++++++++++++++++++--
 drivers/net/wireless/realtek/rtw88/usb.h |  5 +++
 2 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
index c90802919473..80965e5ea778 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -562,7 +562,38 @@ static int rtw_usb_write_data_h2c(struct rtw_dev *rtwdev, u8 *buf, u32 size)
 	return rtw_usb_write_data(rtwdev, &pkt_info, buf);
 }
 
-static u8 rtw_usb_tx_queue_mapping_to_qsel(struct sk_buff *skb)
+#define RTW_USB_HIQ_RATE	10
+#define RTW_USB_HIQ_BURST	16
+
+static bool rtw_usb_hiq_take(struct rtw_usb *rtwusb)
+{
+	unsigned long flags, delta;
+	bool ok;
+	u32 add;
+
+	spin_lock_irqsave(&rtwusb->hiq_lock, flags);
+	delta = jiffies - rtwusb->hiq_refill;
+	if (delta >= HZ / RTW_USB_HIQ_RATE) {
+		add = delta / (HZ / RTW_USB_HIQ_RATE);
+		if (add >= RTW_USB_HIQ_BURST) {
+			rtwusb->hiq_tokens = RTW_USB_HIQ_BURST;
+			rtwusb->hiq_refill = jiffies;
+		} else {
+			rtwusb->hiq_tokens = min_t(u32, rtwusb->hiq_tokens + add,
+						   RTW_USB_HIQ_BURST);
+			rtwusb->hiq_refill += add * (HZ / RTW_USB_HIQ_RATE);
+		}
+	}
+	ok = rtwusb->hiq_tokens > 0;
+	if (ok)
+		rtwusb->hiq_tokens--;
+	spin_unlock_irqrestore(&rtwusb->hiq_lock, flags);
+
+	return ok;
+}
+
+static u8 rtw_usb_tx_queue_mapping_to_qsel(struct rtw_usb *rtwusb,
+					   struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -573,7 +604,8 @@ static u8 rtw_usb_tx_queue_mapping_to_qsel(struct sk_buff *skb)
 		qsel = TX_DESC_QSEL_MGMT;
 	else if (is_broadcast_ether_addr(hdr->addr1) ||
 		 is_multicast_ether_addr(hdr->addr1))
-		qsel = (info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) ?
+		qsel = (info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) &&
+		       rtw_usb_hiq_take(rtwusb) ?
 		       TX_DESC_QSEL_HIGH : skb->priority;
 	else if (skb_get_queue_mapping(skb) <= IEEE80211_AC_BK)
 		qsel = skb->priority;
@@ -593,7 +625,7 @@ static int rtw_usb_tx_write(struct rtw_dev *rtwdev,
 	u8 *pkt_desc;
 	int ep;
 
-	pkt_info->qsel = rtw_usb_tx_queue_mapping_to_qsel(skb);
+	pkt_info->qsel = rtw_usb_tx_queue_mapping_to_qsel(rtwusb, skb);
 	pkt_desc = skb_push(skb, chip->tx_pkt_desc_sz);
 	memset(pkt_desc, 0, chip->tx_pkt_desc_sz);
 	ep = qsel_to_ep(rtwusb, pkt_info->qsel);
@@ -1034,6 +1066,10 @@ static int rtw_usb_init_tx(struct rtw_dev *rtwdev)
 	struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
 	int i;
 
+	spin_lock_init(&rtwusb->hiq_lock);
+	rtwusb->hiq_tokens = RTW_USB_HIQ_BURST;
+	rtwusb->hiq_refill = jiffies;
+
 	rtwusb->txwq = create_singlethread_workqueue("rtw88_usb: tx wq");
 	if (!rtwusb->txwq) {
 		rtw_err(rtwdev, "failed to create TX work queue\n");
diff --git a/drivers/net/wireless/realtek/rtw88/usb.h b/drivers/net/wireless/realtek/rtw88/usb.h
index 9b695b688b24..67463a4d2f90 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.h
+++ b/drivers/net/wireless/realtek/rtw88/usb.h
@@ -75,6 +75,11 @@ struct rtw_usb {
 	u8 out_ep[RTW_USB_EP_MAX];
 	int qsel_to_ep[TX_DESC_QSEL_MAX];
 
+	/* protects hiq_tokens and hiq_refill */
+	spinlock_t hiq_lock;
+	u32 hiq_tokens;
+	unsigned long hiq_refill;
+
 	struct workqueue_struct *txwq, *rxwq;
 
 	struct sk_buff_head tx_queue[RTW_USB_EP_MAX];
-- 
2.54.0

