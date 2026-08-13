Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FFF47A0B7
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 13:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786627130; cv=none; b=SZmWW84cUZV87Qcaeg/a2ouONiqDbdKHBJnj3WY3MdSsJ8R0DM00b6rmIsANOTMn/CwDbHg4PC26N5ZT6Vca1sNyi4ZKQLjnFo4pFjuWBotel2XSK3dpvmJwdPOCjQU4Zjg/LoQ5f+UnChi42ToSytENZbV79s73DHLJJ2awWzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786627130; c=relaxed/simple;
	bh=IgzU5nG+19vPkXH8D+e1/TsOIkhQUEQwkbr3QsZ1qOI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oPh35g3BtG6WIGhQK+ewPqBPcanHGn9Atjvl4VPxEemZkE6QDE1XDk10Ll7nXg7BGpSOgBBW93ezPaKMEfVv8c+NLa8aFxkyEvDGdx5ULCDv8pnaXb7mzdcRp9OHk8i5BUEp6Lgn5XDHDEfIyL62cpG84rTeBQtH06XUkwnP6iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lEtKvY1c; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lEtKvY1c"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-47f703a9d05so1447609f8f.0
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 06:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786627127; x=1787231927; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NHIC2WNshsHmkNk84taa0XjH0hARwcrGEdD93mjza+c=;
        b=lEtKvY1cRkuYRybexRKqjv3UFzAy00VgGdTiDGPKNKaHmgPM4uNl7hu4wWPEFq1dG9
         NXNH30Op9KmgWSy+pOKDH9SUdDmTINQerfPtC6MpS5AnuEnq9ou1YdOOHkMNp6RfipHq
         Fc2truNh/zeOdlEV+YNJfAZHiORCQxoOUysM6qvPuQNkyKiLG65f6V/EzFCuab6nXHt+
         uFoYlsYZmXiMbudgi5vu6KvWEKw4Zs2fh/aDpn9fZsoUQMNqGV7iZnkChSMgQtkR2McU
         HsL+l7fLR452NGCfmf2FOlvH96s+lw7pKgZY8iYRYJmiEeJDKw8/n1wfSUMoUgqhvPg+
         9NFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786627127; x=1787231927;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NHIC2WNshsHmkNk84taa0XjH0hARwcrGEdD93mjza+c=;
        b=PqPrl+c3ngo/RmLaqBIsH0205nRtpTZhXmRpazOQml4wkqWpT3YzX5GGUl6JicyIc3
         P4+AjTzkywjf23otu8r1bEZp1Ja1hC7zaGL9a9WGXXno6VVKggdQ/QTOxFrb3mNCoTWO
         JLTnp5rbICAc34teUt8RSLGR5q41h9ZpzdF/inf+gX5lZjNVaxF9d63qgscr3v7IgSHT
         JyLXMVWQOnyQ37En6sajPj6E2/4TQMKNhPX0Yhyrkz/zkAzwQf6j8Nx3XqjMP7nHbUNz
         QbJDOuWyGSTysnaTjVaOq9kQgKv6hrnHb7s4Icv8mr5skdN6T+zHtJsok9tMUX6NiLj2
         pZ8Q==
X-Gm-Message-State: AOJu0YyIvQkZPZE5OAeb+b7/IG2mxKpmkhSaV/ApuxCVtbeCY8wsLCI2
	MjDye7LDUftZnWZLWd2+UuCK4mRgA3coFbtE/HSqqs73FgWKxI4A8nMt
X-Gm-Gg: AR+sD123msIDwH9v2CMjE3ZrBhbUyC3uvRJvr7KxHnFUNDvGpIHlpP/c8IXXtPfxmPF
	D5zH8Pg5Nonfnc17MuhDCrA//NzN91A/vQ07OvjOVXAWmPfuG7mTStKmIciKrzzWhWzY7AkJDcG
	PvMKynm07DGxLmUWfACSIr6kOzFR2VJvLuzDvzb1Tm074gwdCmgrb8ySBUyPlJ3MS00qYRPFOes
	H8aVaXvRhRyaV1RAKbvap0xhdu0Msszf3OvorD2G4JO+17Z5lRfK1EjmO26hYrJVzX8Bd2CIifR
	V5/KF1ZrHk20/FnBqYUk18bYo4Ns+t3oOlyw/Bb9f20RY1ZCF0+QP3I6aYI2ns3aQbbvNIzIpya
	YPWMBC+kdiylyoYlnnZaSQ/oeYzSu2Sxj0F1YprDKTc2a6fDfylxW9MehvWmSrUhd70YK6vcrvK
	5ExH8xSQ/7AlkWuhxmeh6b/yO9gSHy2kt7wBNDbUNnrvQnfLtcjOrJJ+RRAYZ3DnbPDQ==
X-Received: by 2002:a05:600c:8b54:b0:493:a613:56b2 with SMTP id 5b1f17b1804b1-4998216b3bdmr84898375e9.8.1786627126889;
        Thu, 13 Aug 2026 06:18:46 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4998216d082sm63740045e9.13.2026.08.13.06.18.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 06:18:46 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Mehmet Fide <mehmet.fide@screeningeagle.com>
Subject: [PATCH rtw-next] wifi: rtw88: usb: send broadcast/multicast via the AC queues
Date: Thu, 13 Aug 2026 15:18:45 +0200
Message-ID: <20260813131845.1330003-1-mehmet.fide@gmail.com>
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
TX_DESC_QSEL_HIGH, the after-DTIM queue. The firmware drains that
queue at beacon pace, roughly a dozen frames per second, while a
single associated client's mDNS/SSDP chatter alone exceeds that.
The excess accumulates inside the chip until the shared TX page
pool is exhausted; measured on RTL8822BU, 14 of 1803 pages were
left. From that point every host-sourced frame queues behind the
backlog: authentication responses reach the air seconds after the
client has given up, so no station can associate anymore, and the
beacon reserved-page download fails the BCN_VALID poll ("error
beacon valid") because it needs pages from the same exhausted pool.
The AP keeps beaconing throughout, so from the outside this looks
like a silent receive stall, and only a reboot recovers.

On USB the HIGH, MGMT, BEACON and H2C queues additionally share one
bulk-out endpoint, so the jam also head-of-line blocks firmware
commands.

Route broadcast/multicast data through the regular AC queues
instead. They then leave at line rate and the page pool never
fills. The trade-off is that stations in power save may miss
multicast that the after-DTIM queue would have buffered for them;
at the chatter rates that trigger the jam those frames were being
dropped anyway.

On a bench AP (RTL8822BU, USB2, 20 MHz, WPA2, hostapd, a Windows
client driven through disconnect/reconnect cycles): reconnects fail
0/5 before this change and pass 5/5 with it, with the page pool
staying healthy and no beacon errors logged.

Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
---
 drivers/net/wireless/realtek/rtw88/usb.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
index 64e1c3420..f528fe0f2 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -565,9 +565,6 @@ static u8 rtw_usb_tx_queue_mapping_to_qsel(struct sk_buff *skb)
 
 	if (unlikely(ieee80211_is_mgmt(fc) || ieee80211_is_ctl(fc)))
 		qsel = TX_DESC_QSEL_MGMT;
-	else if (is_broadcast_ether_addr(hdr->addr1) ||
-		 is_multicast_ether_addr(hdr->addr1))
-		qsel = TX_DESC_QSEL_HIGH;
 	else if (skb_get_queue_mapping(skb) <= IEEE80211_AC_BK)
 		qsel = skb->priority;
 	else
-- 
2.54.0

