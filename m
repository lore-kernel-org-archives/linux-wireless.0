Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9845E3ED5B2
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 10:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788345715; cv=none; b=swvgC1lnBCXHZhCTynDFaXSp48iOGaU745c/lSHgi4fOKWNZ5Eaa1pNCdF0BnLuK29EHhlfQFV56/rGAfCmu8xl9iQRWsvA9YhTIbROGFojx2yjkgOY8DoYFV3wTXlEIxzJAqOT1nIFwL78D0KaM0sJS7InoNq2mmhM1V5+TU4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788345715; c=relaxed/simple;
	bh=BM4UT3u7PBt1754sfAEsrFjRExntkck5ge2S0m6jB7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VErj6esLD25yYxMlOfcrTjRqACJsnrft7iNTi5aDEh98QlWVuUJhMRfvj5tVk9DaPWZGjyZPyQMQD84GdpQaSvpcScwnTuLwirnABFvqCKkdhbv1w1Yt4Ey46kT5BAQ6BhXpL+AMRX/YLCIA3kzBBR5CJoMnNuqV0cXf/Tzq67c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qPBdRGKf; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qPBdRGKf"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48444eff835so218458f8f.3
        for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2026 03:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788345710; x=1788950510; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=umCfMh2mdI5/NHdu5isq5L/FcWDog22dq3L2ilcBjkQ=;
        b=qPBdRGKfkegEP0VSFNC+ZTi9COFZffAyd8k6jbvJAJKRm2xLlHsE6DFtxCM4eZJkxD
         mq7U7DZa46kgvNJgLXkOPqaaS9SUlG8Jrc7CTeWee9PZ4yG8/Rq4tcJg3YlRRFw7B1HJ
         piu/dryhDSo7HEU7k7Dxkj605yjkJ4nnGKXI4LPDZ2nbveWBSh8zzr1hgctVeeLnMfqO
         Idtmk/nkyVCz9DmEWyFI6yib5HmMaDJC86jXYWR/XuiSzSRK6eOJudwF0q8a0pRo8SBo
         P6EcO3eblchVdVKpbnb89lkHorfB16US7ukCy/sI+9uKarqYswifE2Os9YRJdB+dqez1
         dL2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788345710; x=1788950510;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=umCfMh2mdI5/NHdu5isq5L/FcWDog22dq3L2ilcBjkQ=;
        b=EUbG9DNhRh4KjBnpG/032lNQuHP90slyuDlVVJc1ldx0MH9GHqYc+M7+0HM5qUdT9X
         +5SGCHyx/WcTM/ydhgu+wDzBJspRd3Jca5UiDSPN+m1o/2gIwrFh/4Z9tHzs9weOCplp
         qKJsSDHpMxGfcTGEqfkV6x5dXowKmZlHmTLbUjLFHalZsgDSBa+4ZRDn1X2oOakPse2A
         R0ykJpRA3qCOtzF7OWzJMZiZUU2gJK0il+6Q1KDBtvzvmneKX5xSPL59FTF6dXokFBwX
         wCD18fFS1eMjdlnUmrcN3UatGqk/tYIG6RKTTzoCllt2J8p8vj8m/kXJKd90JW4kkaGm
         vJMw==
X-Forwarded-Encrypted: i=1; AKwUvBxSTpUcmwlMRt+eamLTYUgNAaoE9s/c8I1gc/bdoNk0WrPi4baMZ2evMVbEKsoLvDQiXIyRwMcQFc4lrULBWA==@vger.kernel.org
X-Gm-Message-State: AFuF++mDjkVOe1NfkgN4qtima5I1NzO0EdaxNRRC8Av/WXsNfvxnlpBS
	PvUaSd7NpV80R7up4fdkKdqAFJcQGWg6iN26r/oaiAiiGqnA+cI9LtaoGJLimGus
X-Gm-Gg: AYBFou1/JZxX9La/SbCoX7IhVytW8tUxMTJXcaCi0MrAWn1wrHibYGZCLGaaKRh3fG5
	XNMhJnfam/Vbs542fW7B0AxoLN6wa2v4kuN1Lk/zFj4wGOMcAGIcuiot8J1+zIS4ioxPCeIH8jq
	nx6O6p+cL0JMN8ukaIiYoC/f/ztWWivTS7nOjhfxk6hJOFmhsfTqufUT/ElTGMejEnVW3946306
	heH3QDhS8jTNKDGVb+FQt+o4JQZwgfkEwFVNQ1doF7lGzwZ3PgYUJXq6TFuv3e6QqfPd7HcvNfK
	EJ9Rk5bECDI6GrSDicyiATiBk4+nS5DSgG+JiMZkUiMeqpOSz1EdhKsPll8+8fednlYO6LzqWmt
	1XzPrxuUhlJg80H78GUFVcvgllbSXwqzXML9JrNqFE9LVQY3rakUhXlVazcdoWNxdcMr6YQYwbo
	R2MWUPZRJxWDDtkC3vVvPjvd9CAyqyL7T5NzbLgoFG2imZaXtLm83DvzAtk2eI0WWcAz6h/qkj+
	cIwsQ==
X-Received: by 2002:a5d:5d88:0:b0:482:9dc6:16c4 with SMTP id ffacd0b85a97d-48488efe615mr7477305f8f.1.1788345709797;
        Wed, 02 Sep 2026 03:41:49 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48448e72df2sm5998947f8f.1.2026.09.02.03.41.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 03:41:49 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mehmet Fide <mehmet.fide@screeningeagle.com>
Subject: [PATCH rtw-next 2/2] wifi: rtw88: usb: only let the frames a dozing station needs use the after-DTIM queue
Date: Wed,  2 Sep 2026 12:41:46 +0200
Message-ID: <20260902104146.3853102-3-mehmet.fide@gmail.com>
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

With the budget in place the high queue can no longer take the chip
down, but ordinary chatter still competes with the frames a sleeping
station actually needs. mac80211 marks every broadcast and multicast
frame with IEEE80211_TX_CTL_SEND_AFTER_DTIM while a station dozes,
mDNS and SSDP included, so under normal traffic the budget is spent on
frames nobody waits for.

Do what the vendor driver does with its default "allow special" high
queue filter: admit only ARP, EAPOL and DHCP to the after-DTIM path,
the frames a station coming out of power save has to see; everything
else goes out on its access category queue at line rate. Encrypted
group frames carry the IV between the header and the SNAP header, so
the parser accounts for hw_key->iv_len. With the filter in place the
page pool stays at 1803 through the same 180 second storm, a DHCP
flood still takes the after-DTIM path (and is then held by the budget),
and join/ping cycling without power save is unchanged (10/10).

Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
---
 drivers/net/wireless/realtek/rtw88/usb.c | 42 +++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
index 80965e5ea778..dd65b304b2c7 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -5,6 +5,9 @@
 #include <linux/module.h>
 #include <linux/usb.h>
 #include <linux/mutex.h>
+#include <linux/ip.h>
+#include <linux/udp.h>
+#include <linux/unaligned.h>
 #include "main.h"
 #include "debug.h"
 #include "mac.h"
@@ -562,6 +565,43 @@ static int rtw_usb_write_data_h2c(struct rtw_dev *rtwdev, u8 *buf, u32 size)
 	return rtw_usb_write_data(rtwdev, &pkt_info, buf);
 }
 
+static bool rtw_usb_bmc_needs_dtim(struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	unsigned int hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	unsigned int paylen = sizeof(rfc1042_header) + sizeof(__be16);
+	const struct udphdr *udp;
+	const struct iphdr *ip;
+	const u8 *snap;
+	__be16 proto;
+
+	if (info->control.hw_key)
+		hdrlen += info->control.hw_key->iv_len;
+
+	if (skb->len < hdrlen + paylen)
+		return false;
+
+	snap = skb->data + hdrlen;
+	proto = get_unaligned((__be16 *)(snap + sizeof(rfc1042_header)));
+
+	if (proto == htons(ETH_P_ARP) || proto == htons(ETH_P_PAE))
+		return true;
+
+	if (proto != htons(ETH_P_IP) || skb->len < hdrlen + paylen + sizeof(*ip))
+		return false;
+
+	ip = (const struct iphdr *)(snap + paylen);
+	if (ip->protocol != IPPROTO_UDP)
+		return false;
+
+	udp = (const struct udphdr *)((const u8 *)ip + ip->ihl * 4);
+	if (skb->len < (unsigned int)((const u8 *)udp - skb->data) + sizeof(*udp))
+		return false;
+
+	return udp->dest == htons(67) || udp->dest == htons(68);
+}
+
 #define RTW_USB_HIQ_RATE	10
 #define RTW_USB_HIQ_BURST	16
 
@@ -605,7 +645,7 @@ static u8 rtw_usb_tx_queue_mapping_to_qsel(struct rtw_usb *rtwusb,
 	else if (is_broadcast_ether_addr(hdr->addr1) ||
 		 is_multicast_ether_addr(hdr->addr1))
 		qsel = (info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) &&
-		       rtw_usb_hiq_take(rtwusb) ?
+		       rtw_usb_bmc_needs_dtim(skb) && rtw_usb_hiq_take(rtwusb) ?
 		       TX_DESC_QSEL_HIGH : skb->priority;
 	else if (skb_get_queue_mapping(skb) <= IEEE80211_AC_BK)
 		qsel = skb->priority;
-- 
2.54.0

