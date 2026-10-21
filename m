Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792583149;
	b=f2Ebnhz9l7AGkxLv/+/4Q4VnSl0SS5XSWVWAiX4wb4gwepymnYSJjPbMc8zi4xC6bSC5
	 B2HRDKzIXTwaOeoPipKVxD8z/qKIzWy/ph81ZfzXKmlUay+HSqTjnxW2J3scUTYYzrpzA
	 XBoR2yVJaoxz27gLjysuysJlIVBuR21NavRJo1kQHgpYN6Mz2bMsIUZJGSB7SbIXh96GU
	 0F2ZTGO6iwCjguci2JL/3kd6JLNG5di7YM8W/T3aoLsfS5YNnfjDK/2D8nA6cQRzXYJr6
	 6VT4xH5qZwyyG64MmU8wWTwZvRw1ChKcLzpugSXWObc+D7dqKIgueiOwp/LFJXpnYqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792583149;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R0eHgsfU7qXBDz2l3eke7gewwI73Cj16ENClQlx46sw=;
	b=vwuNRH9vZU9YfHLIRYj3jwbn+CFA2LI5j1bH0g6tBpofzS4905rZSC3k8m/48XXoYrWG
	 C8bCrXakI2djVFWH/slL4waP5yHfXhAhyiur4qxNiASZfFQzkZj/SG+aGbDnj387nC8Ol
	 Z+9SmagxwQwU7wpJkqpGkk+6CrDhPPKUAPMuuoaeYiHhaz9R3I7I2Kl8ZL1xJxid3dx3C
	 vN/rAkcwpqTXHNqa4326GxSwIXD02hmdOrBR0pO15+M6szymO+nJ8m73LNUgkOwI8RFM0
	 807ByO9DhhhLucsYQa+XxLOu2tYeb8qcaszhAYXLyDa9pwi+xat9DtaUURh26JqI+JQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=QiYAgDsl;
	arc=none smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3FE760A2610
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 11:45:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F3FE760A2610
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=QiYAgDsl
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48df4e9d2d4so383577f8f.3
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 04:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792583147; x=1793187947; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R0eHgsfU7qXBDz2l3eke7gewwI73Cj16ENClQlx46sw=;
        b=QiYAgDslUA1DXE83yPJkQ7JwtRNiT4VxyKy7Lq7UgQsz5EFeNHcI+xHMWGtyDlm/qR
         hrHrjN79SqULLwRErlZQuAsy+SaebAplZd0rKt2wyeAfVE+HUhuH+Tx+KYRhpbfJ0ldz
         NBPs+OEWgNkCp8Gp7Rj+RGRF+VHsHpyn2lox8M8+uJVnCvHJOzJrCEHV0wyN6YfFQEmh
         ASy0egYm9VvIRDo/uT3+1OqsRLp3OryoD6IxFW5HipcuPcITfZfBmVk9LkS3TA9zYBxo
         qdUY40Gm1eDAQvtzMRPwSWVQE2uhAaR2YDkrKPlLieGvW/rtwfjJlQDYZbz4XxAA363G
         eqhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792583147; x=1793187947;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=R0eHgsfU7qXBDz2l3eke7gewwI73Cj16ENClQlx46sw=;
        b=MxbFt9dn5PAQ600oX0BgUf/oH5jeN2On+pQ0Qekm0P2bMMkSwaqjR2QW8O68PXJtDk
         1sMmJEWFDyBjw1xa6IltQvdrv6aCdeINa1I8e238gI7SF6+OikDp7NUXM/BfhmPOy/RD
         0EmkmcSIJ2YEBQUqzrOLrRgPJmxE6YnjXibV24EcHCv+b07YGM9H1EP1cQtUw+jfz7eJ
         PLK9uVBYK5z+M9DoAXYK5AAwEW/8TJvniooiJ5JyubKKwPV0Wffi4FC6SQV/P/pi7eeI
         2Y9SnfuVKn1O4UBes2pnzGx6u00CZSgAp5Yg4CwVmiJuO4xy62enSmFVagsIIU8lubVm
         pwzQ==
X-Forwarded-Encrypted: i=1; AKwUvBwUxp+qRjJVS4hvXkStUKqIlPfsSz/Fvgbm5YWcKSP/1wolpuNtSQRkolqa7UhtR6W5BcO7cIXRv7TJEsqx+Q==@vger.kernel.org
X-Gm-Message-State: AFq9FYKjUXIxF40r96F64IOA/H0tuCvitg+xWKpiSAbou62S9NA2iIvx
	pwek1Q0rgmms6j7LEpkyF8X2GfcV/wvT3p2oqxYsXYdnFRJyge4PzOpYjXlYN3waUcU=
X-Gm-Gg: AYBFou3Q9X4OimLgN2GAU2TECbmFpYa8DtVjdwGfoOIfNxCVWAoJCT7p0u0w0aRt1Ij
	C5HiPO13gSo3pl85PuMk4PZhY0zWnXHBIH/DbYha+WxsVhCq7zO5RBvzyk6H+i1TXCdw4OfP9L4
	EU0gnYK1+lemAPgaLGjQ8wAU8cE/Uiln2FJ2vK6xEiD9ZiWkNA+Et1QR/hsDEJESh4AtKOq6FKB
	U0IVLsBjION2GAch5DBngejjbBIouba9haBL66SUIYAhNoh/XLVOuQI1M20Q5MEJzM1vKlyuYH+
	SRlkYaYYKDBcH4xHGHfcIU43/rgslnyE6co2c1p03BZKnfzF2jyLja+H4thK7jAVeX+GhzkUSMT
	7BanePOEI6fl8iMFRa4gi8kGc3gjNl8pioDK7kJ0NO/O/0wyEtSDQGvomeAOHcLmJhzR/XLRVFN
	1wG6j8+C9eDtwBuikyyzvnr1Gxco4BCYSYt2kZkfdTrmM3SxzaplPCOU4Q3xrRA3njv7LaqqFMA
	IeIfXlNZPmPI6yWDUspljgw4zgyFF/OyUZjRZgrB/DLhlJ3BpbpfXvlx12iuw==
X-Received: by 2002:a05:6000:71c:b0:48a:fb55:416c with SMTP id ffacd0b85a97d-48e2649d51cmr3316575f8f.21.1792583147275;
        Wed, 21 Oct 2026 04:45:47 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e25828ca3sm4944112f8f.25.2026.10.21.04.45.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 04:45:46 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: [PATCH rtw-next v8 3/3] wifi: rtw88: time the countdown downloads from the TBTT
Date: Wed, 21 Oct 2026 13:45:43 +0200
Message-ID: <20261021114543.4132776-4-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261021114543.4132776-1-mehmet.fide@gmail.com>
References: <20261021114543.4132776-1-mehmet.fide@gmail.com>
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
    Changes in v8:
    - the TSF read retries once, if the high word changed, instead of
      looping (Ping-Ke)
    - rtw_fw_csa_queue() takes a start argument and reads the TSF once,
      also on start (Ping-Ke)
    - the port 0 comment is gone, the commit message says it (Ping-Ke)
    - empty lines where asked (Ping-Ke)
    
    Changes in v7:
    - new patch, from Ping-Ke's review of the countdown pacing in v6

 drivers/net/wireless/realtek/rtw88/fw.c   | 51 +++++++++++++++++++----
 drivers/net/wireless/realtek/rtw88/main.h |  2 +-
 drivers/net/wireless/realtek/rtw88/reg.h  |  1 +
 3 files changed, 46 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index 2d81aaeed0d7..9ba4f1c244ec 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -3,6 +3,7 @@
  */
 
 #include <linux/iopoll.h>
+#include <linux/math64.h>
 
 #include "main.h"
 #include "coex.h"
@@ -1809,14 +1810,50 @@ bool rtw_fw_csa_active(struct rtw_dev *rtwdev)
 	return !!rtwdev->csa_vif;
 }
 
-/* paced from the first download: a late one does not delay the next */
-static void rtw_fw_csa_queue(struct rtw_dev *rtwdev, struct ieee80211_vif *vif)
+#define RTW_CSA_TBTT_MARGIN_US	10000
+
+static u64 rtw_fw_read_tsf(struct rtw_dev *rtwdev)
+{
+	u32 hi, lo, tmp;
+
+	hi = rtw_read32(rtwdev, REG_TSFTR + 4);
+	lo = rtw_read32(rtwdev, REG_TSFTR);
+	tmp = rtw_read32(rtwdev, REG_TSFTR + 4);
+	if (tmp != hi) {
+		hi = tmp;
+		lo = rtw_read32(rtwdev, REG_TSFTR);
+	}
+
+	return ((u64)hi << 32) | lo;
+}
+
+static void rtw_fw_csa_queue(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
+			     bool start)
 {
 	u32 interval = ieee80211_tu_to_usec(vif->bss_conf.beacon_int);
+	u64 tsf = rtw_fw_read_tsf(rtwdev);
 	s64 delay;
+	u32 rem;
+
+	if (start) {
+		div_u64_rem(tsf, interval, &rem);
+		rtwdev->csa_tbtt = tsf - rem + interval;
+		/* a TBTT just passed may have sent the first count */
+		if (rem < RTW_CSA_TBTT_MARGIN_US)
+			rtwdev->csa_tbtt -= interval;
+	} else {
+		rtwdev->csa_tbtt += interval;
+	}
+
+	delay = rtwdev->csa_tbtt + RTW_CSA_TBTT_MARGIN_US - tsf;
+	if (delay > interval + RTW_CSA_TBTT_MARGIN_US ||
+	    delay < -(s64)interval) {
+		/* the TSF jumped: restart from the next TBTT */
+		div_u64_rem(tsf, interval, &rem);
+		rtwdev->csa_tbtt = tsf - rem + interval;
+		delay = rtwdev->csa_tbtt + RTW_CSA_TBTT_MARGIN_US - tsf;
+	}
 
-	rtwdev->csa_due = ktime_add_us(rtwdev->csa_due, interval);
-	delay = ktime_us_delta(rtwdev->csa_due, ktime_get());
 	ieee80211_queue_delayed_work(rtwdev->hw, &rtwdev->csa_beacon_work,
 				     usecs_to_jiffies(max(delay, 0)));
 }
@@ -1829,8 +1866,8 @@ void rtw_fw_csa_start(struct rtw_dev *rtwdev, struct ieee80211_vif *vif)
 		return;
 
 	rtwdev->csa_vif = vif;
-	rtwdev->csa_due = ktime_get();
-	rtw_fw_csa_queue(rtwdev, vif);
+
+	rtw_fw_csa_queue(rtwdev, vif, true);
 }
 
 void rtw_fw_csa_stop(struct rtw_dev *rtwdev, struct ieee80211_vif *vif)
@@ -1880,7 +1917,7 @@ void rtw_fw_csa_beacon_work(struct work_struct *work)
 	if (!ieee80211_beacon_cntdwn_is_complete(vif, 0)) {
 		rtw_fw_download_rsvd_page(rtwdev);
 		rtw_send_rsvd_page_h2c(rtwdev);
-		rtw_fw_csa_queue(rtwdev, vif);
+		rtw_fw_csa_queue(rtwdev, vif, false);
 	} else {
 		ieee80211_csa_finish(vif, 0);
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

