Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792529241;
	b=zly3WhrN2KT0U5uXDM6+kWVAD+eUKx27T4QWu+Z3jqivESPErmAFPA5gMiGzhtMQ+ZoZ
	 C1ZiS7wMXZEqBbhdlWZjXko8lZAeCEhaEQaCQv3wYzR6iUShmmDBTINWBiB+Ofjj2Qa4O
	 496TlDqj4j1fl+ZNl1DU0iLkyRSLMte2aRI/xriTz3jJxfxgcOruhhlVYdj26NLXRs1Hg
	 RtYS5zhadBcSopoVbeMatthD3v3YPyCnMs2sPiMDCEkfnvp2PJWr1HIiwliqnMLAIAh5N
	 6KjhyXDtcJTKRCeOsvLbC3yuzAhop2cBoBfTyIHeViv7z1KefY3rtwmTGceMpVc8nPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792529241;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oWwviS365/SZT8R8iYz/l+s4G9wz4nTTXfDlTu5N6sc=;
	b=F5kR1l9xrjWF4sezSh8cLARJ/R1zoNhYU5AA6tqgoYzkURbh5CnsKyyYwQvnOQhjJKJm
	 RM7pFzSVm0KLEr3kxiEi33w9TpL+SDO7oSJroDdRzTifbTi+7D9pa5Cswk65z/AibR8FP
	 Sf0JAHmJsg5CO15eYaFepcahjPOpNUFVNeLmsrI0MO4Hi0b6vWd03K8dHCUT5xjadXSTM
	 BPWWtZnT1Jb4dMIFVJFb2xQ/0l8TcqfYIX5Ha1lC4CB4ZP0mcfoTwmFNXwgo/LrXEOAod
	 OJhNiNoHNdsw2TdKuRa73+CGQgzTygeMLBFRW08bQrE0ugoHHlaxNguCl9GtwE0rRGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=FhevP0a2;
	arc=none smtp.remote-ip=209.85.219.44
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838F4606A335
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 20:47:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 838F4606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=FhevP0a2
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-91befbcad6dso1473686d6.3
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 13:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792529240; x=1793134040; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oWwviS365/SZT8R8iYz/l+s4G9wz4nTTXfDlTu5N6sc=;
        b=FhevP0a2EnYT7VkY5BrrEpazPlCmMZFUXvmI4mVAC67z/XSHorv5E+EAnW+5l/8YUp
         xmXbYdatTrKgM4NkcoSesc6RGWyhVdgSDznN0akmIUTfJTdT+yzwAfdlKxANDBqBkeQW
         4tf8k+FZjfTTIu/BfCcdngvIPlvj1dPMKInvg6cA5HQxqdMF7SUpVujxBJhsGQKEGMhd
         RGJYVn20bqfJkuSi+6kbRrrKXhb5pB3NKFr0D9EGLAkEk/3uSM1JCJKeQZK+vqpkc2Ch
         2L1gldVV5ozSqDN8Nmp6H4u94M6FeuxlRAtmPM3uLUl2t1edPMxG2xxe8GbT6gKML8wa
         VuTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792529240; x=1793134040;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oWwviS365/SZT8R8iYz/l+s4G9wz4nTTXfDlTu5N6sc=;
        b=XPtfre7yODpxpmJs+UmgwIkXdGJ9OWJnsAbm6iAMrGgChNdAqTQ/MhScTyUjKRASJr
         nd6FlLOuu/hwfvOWz1dhb+eqxC7VbI1EmCh3IXVmyFQvK52ucYTgajHpf4I0VEqb27q1
         kVnjwVpN4q+D5ExZRcsR0rTy0tB0cygGy0sPfhWhvQYRcG1n4o3xnGbfdvAD5Ows4TKD
         /3I5Ji+FCXq5p7wXqQ6kBcWGbk3J/ZVwkRdpmKhF4ssozxSk0rZ/9uj6BWgt6PzNfJSI
         QerbgykLCiPd4eBFqBKTDKdG8pS5J7j9OyWm4Los/F900QE9B0Yir6xedOt2P00p7wwT
         pAHg==
X-Forwarded-Encrypted: i=1; AKwUvBzH9u0S7WCbK9poSWMhD1sl5masP779Hj0Xu2oo0jvvCBTK9dhTZpcomRzOAIcM3LcLJLXwMSVtaM4JldHUYQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYI98WDVgZi5EACdKo/78zr9tyVpD+HlT8x0k4t+VoelsE2tKe+x
	x8kFjimkuiV5mVBCPvXcPadkEUPMvZjOVO5aE92dLKS+A8HzabtG7HhP
X-Gm-Gg: AYBFou3Hdw2EjBMeBw7+YJBs3MLkCeg0tjfpBMMbOOgBu+P5JSLAhceLj2M+ij+cP8B
	BKsY4McHlegx/rI2+0fh0zA8WANSBeYPw/kP24O9TIGdxHwxQEy55ZlCeiTWGQ1Iynlg/FSy2QV
	Pd6Nt4/brWB2v0dqLx1PfKwJTQ9df2dPVZhTXuiBlSirMP/pxt2HEPFrN/5KBzp1VxntPLbhI55
	19YyA+ILFzeLJGS21KNg3+v21tqY4ww/xWARuLSx5//dBQle30V8FmhWBimd0MxmOslPLauPUCW
	HzXglQhlW5EnUEOYhnF/XwqfLmN3/V0G7APyzYdZsARz5vsCWNHFzahpf7Xi1aPG4X7THWNHIy5
	ozriMyexElsU7QxqazB9dk5bBP4DBFai0qUklq36MmA9a/hYqxO2LgXAcqkiutp+Mffv5TaNGHo
	Xuv8MnX8FFfPWZyJOAmfZAsShq4TU/v3ZkN2X00Hcllk9XdOrlXtQvzTaCVbPakwlnYudCPjcGn
	6uVUwUQXkY7s1Q=
X-Received: by 2002:a05:620a:2712:b0:93f:1d5:9973 with SMTP id af79cd13be357-93f57f903c4mr67736585a.73.1792529240488;
        Tue, 20 Oct 2026 13:47:20 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f56c6f16dsm79336785a.4.2026.10.20.13.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 13:47:20 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: [PATCH rtw-next v7 3/3] wifi: rtw88: time the countdown downloads from the TBTT
Date: Tue, 20 Oct 2026 22:47:12 +0200
Message-ID: <20261020204712.3252023-4-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261020204712.3252023-1-mehmet.fide@gmail.com>
References: <20261020204712.3252023-1-mehmet.fide@gmail.com>
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

From: Mehmet Fide <mehmet.fide@screeningeagle.com>

The countdown downloads are queued one beacon interval apart, with no
relation to the TBTT. A download that runs late past the next TBTT
leaves a count out of the air.

Queue each download 10 ms after the next TBTT, read from the TSF, so it
may run late by almost a beacon interval; a later one is followed by
the next at once. A TSF jump, an IBSS merge or a reset, restarts the
schedule from the next TBTT.

A TBTT just before the start may already have sent the first count; it
is taken as the one that did, so no count is sent twice.

The USB chips raise no TBTT interrupt, so the TSF register is read. The
beaconing interface is always on port 0: rtw_core_port_switch() moves
an AP there, an IBSS runs alone.

Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
---

Notes:
    Changes in v7:
    - new patch, from Ping-Ke's review of the countdown pacing in v6

 drivers/net/wireless/realtek/rtw88/fw.c   | 40 ++++++++++++++++++++---
 drivers/net/wireless/realtek/rtw88/main.h |  2 +-
 drivers/net/wireless/realtek/rtw88/reg.h  |  1 +
 3 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index 2d81aaeed0d7..c5a106a59540 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -3,6 +3,7 @@
  */
 
 #include <linux/iopoll.h>
+#include <linux/math64.h>
 
 #include "main.h"
 #include "coex.h"
@@ -1809,27 +1810,58 @@ bool rtw_fw_csa_active(struct rtw_dev *rtwdev)
 	return !!rtwdev->csa_vif;
 }
 
-/* paced from the first download: a late one does not delay the next */
+#define RTW_CSA_TBTT_MARGIN_US	10000
+
+/* the beaconing interface is always on port 0 */
+static u64 rtw_fw_read_tsf(struct rtw_dev *rtwdev)
+{
+	u32 hi, lo;
+
+	do {
+		hi = rtw_read32(rtwdev, REG_TSFTR + 4);
+		lo = rtw_read32(rtwdev, REG_TSFTR);
+	} while (hi != rtw_read32(rtwdev, REG_TSFTR + 4));
+
+	return ((u64)hi << 32) | lo;
+}
+
 static void rtw_fw_csa_queue(struct rtw_dev *rtwdev, struct ieee80211_vif *vif)
 {
 	u32 interval = ieee80211_tu_to_usec(vif->bss_conf.beacon_int);
+	u64 tsf = rtw_fw_read_tsf(rtwdev);
 	s64 delay;
+	u32 rem;
 
-	rtwdev->csa_due = ktime_add_us(rtwdev->csa_due, interval);
-	delay = ktime_us_delta(rtwdev->csa_due, ktime_get());
+	rtwdev->csa_tbtt += interval;
+	delay = rtwdev->csa_tbtt + RTW_CSA_TBTT_MARGIN_US - tsf;
+	if (delay > interval + RTW_CSA_TBTT_MARGIN_US ||
+	    delay < -(s64)interval) {
+		/* the TSF jumped: restart from the next TBTT */
+		div_u64_rem(tsf, interval, &rem);
+		rtwdev->csa_tbtt = tsf - rem + interval;
+		delay = rtwdev->csa_tbtt + RTW_CSA_TBTT_MARGIN_US - tsf;
+	}
 	ieee80211_queue_delayed_work(rtwdev->hw, &rtwdev->csa_beacon_work,
 				     usecs_to_jiffies(max(delay, 0)));
 }
 
 void rtw_fw_csa_start(struct rtw_dev *rtwdev, struct ieee80211_vif *vif)
 {
+	u32 interval = ieee80211_tu_to_usec(vif->bss_conf.beacon_int);
+	u32 rem;
+
 	lockdep_assert_held(&rtwdev->mutex);
 
 	if (rtwdev->csa_vif == vif)
 		return;
 
 	rtwdev->csa_vif = vif;
-	rtwdev->csa_due = ktime_get();
+	rtwdev->csa_tbtt = rtw_fw_read_tsf(rtwdev);
+	div_u64_rem(rtwdev->csa_tbtt, interval, &rem);
+	rtwdev->csa_tbtt -= rem;
+	/* a TBTT that just passed may have sent the first count already */
+	if (rem < RTW_CSA_TBTT_MARGIN_US)
+		rtwdev->csa_tbtt -= interval;
 	rtw_fw_csa_queue(rtwdev, vif);
 }
 
diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index bc3ebfec11ae..3be0a96d1186 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -2096,7 +2096,7 @@ struct rtw_dev {
 	struct work_struct update_beacon_work;
 	struct delayed_work csa_beacon_work;
 	struct ieee80211_vif *csa_vif;
-	ktime_t csa_due;
+	u64 csa_tbtt;
 
 	/* used to protect txqs list */
 	spinlock_t txq_lock;
diff --git a/drivers/net/wireless/realtek/rtw88/reg.h b/drivers/net/wireless/realtek/rtw88/reg.h
index afcdb66fdb9a..3ff4ae0885ef 100644
--- a/drivers/net/wireless/realtek/rtw88/reg.h
+++ b/drivers/net/wireless/realtek/rtw88/reg.h
@@ -506,6 +506,7 @@
 #define REG_USTIME_TSF		0x055C
 #define REG_BCN_MAX_ERR		0x055D
 #define REG_RXTSF_OFFSET_CCK	0x055E
+#define REG_TSFTR		0x0560
 #define REG_MISC_CTRL		0x0577
 #define BIT_EN_FREE_CNT		BIT(3)
 #define BIT_DIS_SECOND_CCA	(BIT(0) | BIT(1))
-- 
2.55.0

