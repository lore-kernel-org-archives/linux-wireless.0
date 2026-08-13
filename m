Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4374749F6
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 21:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786657453; cv=none; b=QdLnMkQ5/YPXwzVFhoGgdAkH7M6pn4qy/e7wVLmiGKJjJDb99TJFxBrgUeMH+HZQZ9kVI8PmrK1bb1pV0LyRkQl01f9IsuU3WIAOc8EBtyKyLrwqLD9oF/fYc8aJ0Vn2o9dAh9EsaZgDRYHWFKj4GN37TkMCyNlfa4DF5VNjv78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786657453; c=relaxed/simple;
	bh=xXLOP676OB4EJ92wd17Rorty+J/yoWS9Ku/VxGH1O8s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lCLYcKMOslu6hgYZ1gHjFHlCX8W1e/KFJZNbGBGTbV8auwDy1oCMVKZK92PqGQS+F7goH3L6DqAGenFzhvZYFKwH6NBB1v3SMM2lf7i38jlZ/j3TMFW/Da05+WdnfJ1tH0iPVUlYQVNpPNU2DxFgDXYjQruKqCmYLOxszc3JWhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VsT4K92H; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VsT4K92H"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-47f7854678cso251112f8f.1
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 14:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786657450; x=1787262250; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=yi5qUyFjsWwIUVgVZHFCdwczIV0aqX/dQwzvLrxSz24=;
        b=VsT4K92HWAIW//6k5n/XDKwYTEvepodD/xV5e6fKIybIRpzXz9VdGqfY+eIhnQTktt
         d2k+YECjiVeJo8IFq9KtLnEgnGA95rVwYG8dtZbyEAQfvvKsZfllHTVgvQmVxTADQ/FN
         eFmD067QegIoFMxIT1qQ0H+LKXJVVIlyZSPgtnAJofgDfHmZclaibl+8h7bzq8Hsbk61
         j4zf8pnuYLHiqWl2W7m+vXPduWRsoVahDfHNxVL5QvcYlbuP4qgYlJHCIlS26r99vvFx
         0ihvywAurV7TSnhjULXgEPUX+WQN7jAsKn6pejAXQs6jzseJEJ/nOmLY/W/G5nwRZ11f
         pQ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786657450; x=1787262250;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yi5qUyFjsWwIUVgVZHFCdwczIV0aqX/dQwzvLrxSz24=;
        b=IqrY62jKR5+8/5NK00qngHa3l0nIA75lQ95w26vTUR5PNKwkYQLUuQaYC28Pg8lL/R
         6t+vv6z5qS95ypcAvKJHV3bWB+NZ9FNAT1sLnfaWPl6xSNcnJBFtAcGKfwcY3sr4cL5q
         f9S9x8CJZVEKIsxQVNZ+WNKAv0CoDT7ChuXOMufUsmGd/1+glIxKANBwkvrHhoZf2PqW
         g4ea+Znmxzi/hmyMIh9/Z2tDRdvKYweztZaeR/zCOUbtfqNBuYCCzU2zda6Cyyot5UKz
         Pg3ewDbaldA30F/qc33sbREX6u4QKcJZ4PYbxhXoUNrC6VngBxVk2Jed86gS+1co7ou8
         9h0w==
X-Forwarded-Encrypted: i=1; AHgh+RqURhY0dQiYJe7AkaOm/qL9usnBUz5np0VU5w7jV6yD/MR+KYyNAa3XjlQWn5wp5MT2Ts3Ap6wMjxeNSbvSsA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwctUay013Jo/8a6sGnDXCOXZsYkVSmsmiczZ87aYCENTWpM0bb
	ERcJ/rJfCaA9HgQhmZAzme1HKltN/M34TbQuVRvnBgcpW74VIXs5eN/5
X-Gm-Gg: AR+sD12xlv1/+3Dw/H/kc6B7imw0y7iY1ezZlvlCZ+/hEV+eO6rAkn1XgpS0duw0HP/
	hjlt6u3J6uaxTt8lVrQo8ajubj8cOX8dO6awHw6YYfFcTTaCqbMOL0PTo8+9WU3NMTfGcIT4qVy
	pxCH9ebFSsfpDjQsVaLkzNnjAJ2LMSij4q95SruE2jsP4yAZeMsy4pbMVlO8hJ7pQGTqHXpFTyZ
	5Ofr4yaGSYHaAvteTt/BVxynRwxqWDy20KguNAfQEutFf5qGXpSrIIebpMJ3YI+OeEp8vYpEeOi
	279ExDOVmDLOdODd5bQrA9uFJbFQDJkEHUWPhCOHkt6dv63WeKIjir8CwzAMBlzmuAuZ+5vWbpN
	mimIhcEmkWiqVSrwNvxVh/op1HiwQKONvUniYsKp8QtN9ezcUx+2OoptG41KA6Kdi4FUNSL4nTq
	rkDkdmbMJL36xFUVkHE9TCnh6Q72zVmDBraMjz1wxx1QpCjQn0zb0CQ4MkSW+hAwPO5Q==
X-Received: by 2002:a05:6000:2612:b0:47f:c648:e265 with SMTP id ffacd0b85a97d-48160758afcmr1569350f8f.17.1786657450038;
        Thu, 13 Aug 2026 14:44:10 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4815f219d3dsm2627094f8f.14.2026.08.13.14.44.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 14:44:09 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mehmet Fide <mehmet.fide@screeningeagle.com>
Subject: [PATCH rtw-next v2] wifi: rtw88: usb: route bmc frames via the high queue only for DTIM delivery
Date: Thu, 13 Aug 2026 23:44:07 +0200
Message-ID: <20260813214407.2438670-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mehmet Fide <mehmet.fide@screeningeagle.com>

In AP mode every broadcast and multicast data frame is routed to
TX_DESC_QSEL_HIGH, the after-DTIM queue, whether or not anybody is
asleep. The firmware drains that queue at beacon pace, a dozen or so
frames per second measured on RTL8822BU, while one associated client's
mDNS/SSDP chatter alone exceeds that. The excess accumulates inside
the chip until the shared TX page pool is exhausted (measured: 14 of
1803 pages left). From that point every host-sourced frame queues
behind the backlog: authentication responses reach the air seconds
after the client has given up, so no station can associate anymore,
and the beacon reserved-page download fails the BCN_VALID poll
("error beacon valid") because it needs pages from the same pool. The
AP keeps beaconing, so the failure looks like a silent RX stall and
only a reboot recovers.

mac80211 already decides when after-DTIM delivery is needed: it sets
IEEE80211_TX_CTL_SEND_AFTER_DTIM on bmc frames only while at least one
station is actually dozing. Honor that instead of routing
unconditionally: flagged frames keep going through the high queue with
the MORE_DATA and HGQMD handling introduced by commit 076f786a0ae1
("wifi: rtw88: Fix AP mode incorrect DTIM behavior"), everything else
leaves at line rate through the AC queues. This partially reverts the
usb.c hunk of that commit, whose unconditional routing is what lets
the backlog build up.

On a bench AP (USB2, 20 MHz, WPA2, hostapd, a Windows client driven
through disconnect/reconnect cycles): reconnects fail 0/5 on RTL8822BU
and 0/3 on RTL8821CU before this change, and pass 10/10 and 5/5 with
it, with the page pool staying healthy and no beacon errors logged.

Fixes: 076f786a0ae1 ("wifi: rtw88: Fix AP mode incorrect DTIM behavior")
Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
---
The flagged path is the code 076f786a0ae1 added and is unchanged by
this patch; I did not have a client entering powersave on this bench
to exercise it explicitly and will follow up with that measurement.

 drivers/net/wireless/realtek/rtw88/usb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
index 64e1c3420..c0990c125 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -559,6 +559,7 @@ static int rtw_usb_write_data_h2c(struct rtw_dev *rtwdev, u8 *buf, u32 size)
 
 static u8 rtw_usb_tx_queue_mapping_to_qsel(struct sk_buff *skb)
 {
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	__le16 fc = hdr->frame_control;
 	u8 qsel;
@@ -567,7 +568,8 @@ static u8 rtw_usb_tx_queue_mapping_to_qsel(struct sk_buff *skb)
 		qsel = TX_DESC_QSEL_MGMT;
 	else if (is_broadcast_ether_addr(hdr->addr1) ||
 		 is_multicast_ether_addr(hdr->addr1))
-		qsel = TX_DESC_QSEL_HIGH;
+		qsel = (info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) ?
+		       TX_DESC_QSEL_HIGH : skb->priority;
 	else if (skb_get_queue_mapping(skb) <= IEEE80211_AC_BK)
 		qsel = skb->priority;
 	else
-- 
2.54.0

