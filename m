Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590A5322C73
	for <linux-wireless@vger.kernel.org>; Sat,  5 Sep 2026 08:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788598740; cv=none; b=WCiZGTgNS8CISMx7Qy8/hMigBEzxRTH0UYXKvXaZ9/wFbR0yTGmERRegsZW5R3/qw+Aul2e+8sFWSrrcNlZdZJGDxRDzDQZKMsOkYGEgRUDaWBuxL2gJPb0AdQ8ta4X3xhV3CKGo0FpdsDVcbGLMG5FySGmzQIikFlJaQ+jM0NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788598740; c=relaxed/simple;
	bh=wwO1tiUatXUNiREkAKHOy4KgtEdLsUuk32neGIK+pVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XM7n5YdGUuP5qJZPEL8TsQ+ZNQLux1hHEWYu/OqaXU0cnwXyft0VzDBqPdsq8Zr6iK7bpP3Zmdjtj5bj3xc0MQd1MrWl+3vtpK6DJojSvpkGKXbdysMB2LfwSwulcwjV8rfcF6uH0bCTJBG82Obd7BtlwTGA0nkD5z01OVAkZ1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QEP7kryX; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QEP7kryX"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-47ddf7b09e5so1971917f8f.1
        for <linux-wireless@vger.kernel.org>; Sat, 05 Sep 2026 01:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788598734; x=1789203534; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=gvGhL3HZ4A6FyUQcqo6y9PFuXiif2pxtShOv+n9uw9o=;
        b=QEP7kryXnMSQRxg9RVwS1KJY3vLyUE0xdDqTyG6OoQi6zGM9a3fJm4kStxxu/V+nw+
         pL/0o5aaJZZWbGNovZyrBHlhAA/sm3ieYr8VDoTloEDfFhJGafoDHbqNz7NFD+yUQzH+
         MmxIoPBQ5f7vZyccQbXeMAb3shM5KWB9d7ep0HjJg9itf2KAuJp5OP6kfD9uhmQID6hW
         r46x5P6uV/tw9VFPng8Z0isW7w/gFmg+pWLo0dwGuIYVztPPGCDGo+Ow9VXSWfBcIvpP
         pb8y/K8zqdxI2MFfY6b3uQ1Lz97UYQ2U1Ao6jUmdKY8nbjyPKGyDs7CC0t3Qpj9YEVWn
         IaRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788598734; x=1789203534;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gvGhL3HZ4A6FyUQcqo6y9PFuXiif2pxtShOv+n9uw9o=;
        b=oCIOPvpqqN1vu38FwFS/BgzmtTf4BYuIGbjao/PXaigJs96jkaFNuvJ06J19Ssi6gS
         LdMUIjWeD4S4UcfpD31mRtsKMm1sK0ntB2rzJk0Er6ifytI4BO0UdZ/y17aSLcZ5IQ2S
         c0/rB0p/M0V6YS6Qlb7ed5wLQby/aeZvtI/iTFHkLn3EEqIUJokUcgyCv5wcbr2NMSnW
         x7yLdBrAcnAK/FOSde9DbjcSPV0OWj6LI6rTTR8ajUBwqI+n05o6hCo6thflVTfRvfgf
         VoXduy1+JNJvBrYu1p6fee16Z/7KBGvgmXz4crVYrfPVFoWrJsyp8opjtSZSRCrka5vJ
         delg==
X-Forwarded-Encrypted: i=1; AKwUvBx4ECX2xpvQ5L1Wm/L+kNcmPe1FOyag281cUHsGK3YZvhX0R20ZYVUqVTK0wCohZcLYuMQaeHayVw7FfjdFrw==@vger.kernel.org
X-Gm-Message-State: AFuF++mL1tnkIlQeJxW6wkiKfEGmrVvZgEn5o3YPCsNpzk1hudC4k9sA
	U0YPEC+RyQTrq/XoDdMGIMsqT5pF9K55I0hzZty9D1kS5t0RXo5ErK8vpWdj
X-Gm-Gg: AYBFou16BR46Pfen5kElLYjfptJ86EonV6MFVlzqRH8JkS/mXQO2KzTfPIcX7Sf4UqU
	nxoJNirC0EpsTmrf7aGApGiaFPSMgWaquFAoLlU5mPvXLSOUev3qIvmoALmfCM2fjGW1KULiARX
	BKHO5K48iHaYT86wjTQZ6o2yGqrZa2QI/ZL9NGUf8C0YfXR/BIbaY+Xc1at273F5OLsJfpDrgBk
	jKyjFKQKp02cMstUsh64TA8Mw9Wa8m9aCvjbGcmCFSq9eZmSgTCw+ArYX/2mDB6ZCf9jn3+Wi5x
	MzwQQ2uS0pzK7Vnd8WorGUg41l9frYj/bMCqCGT6aE9eTPCCeuKsNqONwD7Ms3epAWGpdgyj8g6
	kgUfYs+/NO3jEkQDPNdbSJt2/imJCa/J6YrRrhZS/r/O+94wVHSgPzr6Yw256ahHl7UCjuqXX4/
	J5bh76ZKmtms6j1YuM+7XMM8UQG58CdsQaSY/MrpdTkHhub1GI/UzOHjMAza0S5xx0ROYKzpyoP
	hPXsAR86qvs+QIXrnU/7w/zHgqVZkpqVxkdCG7qKRmdcXr4tVehAqkHu3tXdsTYU18S00JZljz6
	2BAmaQ==
X-Received: by 2002:a05:600c:35c3:b0:49c:fc6c:be10 with SMTP id 5b1f17b1804b1-49cfc6cc055mr83086845e9.22.1788598734103;
        Sat, 05 Sep 2026 01:58:54 -0700 (PDT)
Received: from nn ([2001:1ab8:1003:0:5454:f357:ba89:4e22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ce5952560sm228306435e9.3.2026.09.05.01.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2026 01:58:53 -0700 (PDT)
Sender: N B <gen.benner@gmail.com>
From: =?UTF-8?q?Nerijus=20Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@kernel.org>,
	Oleksij Rempel <linux@rempel-privat.de>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] wifi: ath9k_htc: fix the byte count of a full RMW buffer flush
Date: Sat,  5 Sep 2026 11:58:06 +0300
Message-ID: <20260905085807.384488-2-nerijus.bendziunas@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260905085807.384488-1-nerijus.bendziunas@gmail.com>
References: <20260905085807.384488-1-nerijus.bendziunas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The AR9271 PA calibration has been running with its last five
register writes dropped since the RMW buffer was added.
ar9271_hw_pa_cal() queues exactly 15 read-modify-writes, which fills
the buffer, and ath9k_reg_rmw_buffer() sizes that flush with
sizeof(struct register_write), 8 bytes, instead of
sizeof(struct register_rmw), 12 bytes. The firmware gets 120 of the
180 bytes and applies only the first 10.

Fixing the size alone kills the device. The command becomes
8 (HTC) + 4 (WMI) + 180 = 192 bytes, three full 64-byte USB packets,
and the firmware ends a command only on a short packet
(usb_reg_out_patch() in open-ath9k-htc-firmware). The 192-byte
command is never delivered: the device stops answering WMI and stays
dead through a warm reboot until power is removed. An AR9271 hangs
this way on the first interface open, with the linux-firmware 1.4.0
blob and with an open-firmware build alike.

So cap the buffer at 14 entries as well. A command of n entries is
12 * (n + 1) bytes, a multiple of 64 only at n = 15 within the
buffer's reach. The next largest RMW batch, ath9k_hw_4k_set_gain(),
queues at most 14 entries, 180 bytes, and a register write batch is
8n + 12 bytes, never a multiple of 64. The PA calibration then goes
out as 14 + 1 entries and all 15 writes reach the chip.
AR9271_AN_RF2G6_OFFS then reads 30 on 40 of 40 opens, where the
truncated command gave 32 on 78 of 80; a firmware with fixed
reassembly, given the full 15-entry command, gave 30 on 19 of 20. The
on-air effect is not measured yet. With the cap, 120 interface opens
ran clean: 60 with this patch, 20 of them on the linux-firmware 1.4.0
blob and 20 on a second AR9271, and 60 with a bench build of the same
wire lengths.

Fixes: 8badb50cfab6 ("ath9k_htc: add new WMI_REG_RMW_CMDID command")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Nerijus Bendžiūnas <nerijus.bendziunas@gmail.com>
---
Changes in v3:
- v2 said no caller fills the buffer; ar9271_hw_pa_cal() does, on
  every AR9271 reset.
- Cap MAX_RMW_CMD_NUMBER at 14 in the same patch: the corrected size
  alone yields a 192-byte command the firmware never delivers.
- Assisted-by in the form Documentation/process/coding-assistants.rst
  now asks for.
Changes in v2:
- Add Assisted-by, rewrite the commit message, rebase onto ath-next.

 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 2 +-
 drivers/net/wireless/ath/ath9k/wmi.h          | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 6de78ae85726..0b49d2cc99f0 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -405,7 +405,7 @@ static void ath9k_reg_rmw_buffer(void *hw_priv,
 	if (priv->wmi->multi_rmw_idx == MAX_RMW_CMD_NUMBER) {
 		r = ath9k_wmi_cmd(priv->wmi, WMI_REG_RMW_CMDID,
 			  (u8 *) &priv->wmi->multi_rmw,
-			  sizeof(struct register_write) * priv->wmi->multi_rmw_idx,
+			  sizeof(struct register_rmw) * priv->wmi->multi_rmw_idx,
 			  (u8 *) &rsp_status, sizeof(rsp_status),
 			  100);
 		if (unlikely(r)) {
diff --git a/drivers/net/wireless/ath/ath9k/wmi.h b/drivers/net/wireless/ath/ath9k/wmi.h
index 5c3b710b8f31..256f46098a6b 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.h
+++ b/drivers/net/wireless/ath/ath9k/wmi.h
@@ -126,7 +126,8 @@ enum wmi_event_id {
 };
 
 #define MAX_CMD_NUMBER 62
-#define MAX_RMW_CMD_NUMBER 15
+/* 15 entries make 192 bytes, three full USB packets: never delivered. */
+#define MAX_RMW_CMD_NUMBER 14
 
 struct register_write {
 	__be32 reg;
-- 
2.55.0

