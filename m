Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01FDA322C73
	for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 05:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786685671; cv=none; b=kaWDDEn9AeMXT9qj6OeEimfK36qAHvdRWvgy1e12ZTc/lp1YcK0GJgqg8sfM9acnwNuOG8GB0sw3m5/pv5BbAF47coZwX+p5u3VlbnXEEb9JiDWLJpDD/VHmKFDwPo6+jRyz6O/W8LtaZRho4bxH+2T5VKhK9KEchx1F9jgxbYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786685671; c=relaxed/simple;
	bh=suc85FrtLbQf22brsB88D7OYPOdq4ICoJ0e4DPW6Pm4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c4PwaCI386ogWiCsVNf1BcNCChEAwiFwYh1Ti8mqE0pfoQPNq3+UM49Z3zm6xn6fIvbs/dGWGNrnYKlM5qZN4DSAocCw+GwrLnQ47792k14DALNTak1HfTG2ZqXu5CevtxcnDl3zgwLmFNomTCE28Q3I9Rg/D58mb3znihNwnIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T5eFXajf; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T5eFXajf"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4954a2e73a9so4343065e9.3
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 22:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786685668; x=1787290468; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NweZTATsw473HUSw2qvH+SmBzWknsDyQl1KkkpxMyrQ=;
        b=T5eFXajfTv9dmPFT1mIOUSK2x67gjqVmEe5rC5rz82FbaWEBVX9uJ94cyzidXjvSYK
         WhFlmsQt3XjS57YYFJt2Bav7sjtua4LCAKQKxiezfhtbJRht8cZQpFUVfkmlMsSIfGmG
         CFSfZCh1bU347J8AqyCcCD93Syh5GYQ4CDmH/CiOKyxVcl+TE653nB1sztnygWwAafm+
         V0hxtgKE3Nvm8ZFYtbKjGZW70atmZtuznVEfOe+iwH1WBIIWARch8YzqaBCcsamfR6sn
         nV0gphbiI/pPhh0EP3Rd42GGoUxaxdTlSIXbFXP7Azv7ZpJjANhgUFT+Ky6uQPZVwOIK
         xVjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786685668; x=1787290468;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NweZTATsw473HUSw2qvH+SmBzWknsDyQl1KkkpxMyrQ=;
        b=qzH7Q8vzIkceoz5PP+7iTz8QLZPgi49ogaOhbMLrnSWdnxfyIU8t6CM29qmgtdZhI2
         LnT4Cndkus4egcNprdTgM1zEAUbrsPdcvAJxGe0v0azLaXREHcFtPJZ1XiIuJsL5L3KQ
         5qj3shyCbykW5CZ4lBWhQ2NR/CeTdjfsdfAqy+RsBqK4xS+JH8YG2GoywbAEHfMD6Gn3
         fHlk9TpuFBO+HubHA6T0XMjhPlGd1+0pcsv8xalnVvgWxQKcJJXnTyqY9Qb/W1w34l9W
         D60UzsV7MmpD9pFfc39sHiymBaXcHElsqYkqT7Vo5GjLMpL5+yCjTX52mCHKBPYP1i8Q
         Ycmw==
X-Forwarded-Encrypted: i=1; AHgh+RozRtES3eOgEi7TRNtvNa3Q3fW9OrpPVIzsLXekK3UX/b9fVgjkgWm2czQwsKUzhQX4XvyyYWdODbRK1IISZw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4OdRB/w826y8nedwbKl2XeQM4XeEr23Gl/bBY25ypN/SAAblS
	CRIhbgS9ALuqkSXLvGBqm2jXkl7JtuMWBnMQ3SsZIqhnPdg8/1b3HcYE
X-Gm-Gg: AR+sD12rjifek790nZbxgMMfzpIDquRmuSlR15v852gCHfe1bH1kw/6jnh3IZDokqAf
	4GgqpHAGEq4TaKbIyLOvHYApJDL69c/lF5ELLN+CeQymIRxLoe5UsMnIiCNxcIMY8R+SNErAfD+
	qTZx5hq6So9lI36v1xiJerSGC8rJBca4XkMnEq+9Zseztu7JMliQ7+NnRPyXmP8qny7CrCM8rww
	SrjE5ZY+2zxU9o4b8hHNKZSoere0t+7E8BlKPdqiVPWM7Nk3HexQMnTrW9yQk2IV0HZBPzfL2Fl
	qHc9XMXZclHtvT5kZJtqFEN7x6M50T04Lc2Olgmjpniioi6Szs2rOoBBl+YNbc88X8qchwijD/l
	/P9vjSeiIzBMk++XKTuCCzkNFSpVd6eLXoC6L19X3r0MbqY1T82WfJiC9xwmgIEjbh8LRPsQ95F
	ENDvbJcqm3bv2nAZ+SxkSENVm7L+0ttIMLA1IpuL1T3ALHAHRuR//mHauScBJNPfifQQ==
X-Received: by 2002:a05:600c:1385:b0:499:5220:db3d with SMTP id 5b1f17b1804b1-499879a50afmr31079585e9.16.1786685668014;
        Thu, 13 Aug 2026 22:34:28 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4815f20058fsm5914247f8f.4.2026.08.13.22.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 22:34:27 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mehmet Fide <mehmet.fide@screeningeagle.com>
Subject: [PATCH rtw-next v3] wifi: rtw88: usb: route bmc frames via the high queue only for DTIM delivery
Date: Fri, 14 Aug 2026 07:34:26 +0200
Message-ID: <20260814053426.2473247-1-mehmet.fide@gmail.com>
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

Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
---
v3: drop the Fixes tag (Ping-Ke), reverse xmas order for the
declarations (Ping-Ke).
v2: honor IEEE80211_TX_CTL_SEND_AFTER_DTIM instead of routing bmc
unconditionally to the AC queues.

The flagged path is the code 076f786a0ae1 added and is unchanged by
this patch; I did not have a client entering powersave on this bench
to exercise it explicitly and will follow up with that measurement.

 drivers/net/wireless/realtek/rtw88/usb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
index 64e1c3420..43b9cdb4a 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -560,6 +560,7 @@ static int rtw_usb_write_data_h2c(struct rtw_dev *rtwdev, u8 *buf, u32 size)
 static u8 rtw_usb_tx_queue_mapping_to_qsel(struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
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

