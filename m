Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793028597;
	b=E1N6KgDWKXqsqya90+MeyPz42zsePrg0XH5uBNmE7M91NCkg3z0slTd/zriSu0J8/57E
	 B397siWa24KHnsxTQl1GZNEEpVDQHvnChQ392+bhjIfnhl++z9UiHgmAdOhA8hW1Edx+J
	 5shbh4AdMecpZVI+eQyMOR2nCjdG8IkQVbuIZvFgomE4MbgosCJnpdNMPcCwolZG1oP1+
	 CLM9H/3ZoWtOWLxyLUCEZjL7GxrVQ2mQrqUi9If/BvJAmNVRf9FGExOaSIJ7st+hhHyor
	 YfXYyqQXNyLrewIj4AT9rsUerJ0RPpdp5iiF+uEVj52vWYZd2n4pV50STequrtFBuWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793028597;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=52rsN+P0RqpEFf5O2HXjmwx5luMSAaqLDyiXEcr10so=;
	b=Pq2ELQKfiuHBQXbUxWQMq//NQo2rDPS38y96PkKyB/As1lUODNq3LQ/Owv0PrPUMlXgx
	 WiYtaPZ7pHqhQ5Nf8RX1TzyZ0YSws4t9xmNCUFKE+JWVWf8g+wTHZ36lBx7U8+01yIs78
	 ccg41B9drwaN49PfTTX8YVyjTfcBeQSkDQ/ZIJ7QtsV+GQzszuTKzXO+KV8Wo1i6Rpod+
	 RLWkh69wF3dwmbzLJFG9LgM7cdi8bJJRRWOQUYxyyyopfVpSKxL4IUIuK1qh8KzgrLUO3
	 YgHl92zD7Y/n/XKMZ+VCij7pJQuoJIeHhxNwWpDONdl4JM6O/TuYHjXCgg3U2UW5EOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Jl0fg0OX;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32556606A31F
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 15:29:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32556606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Jl0fg0OX
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a1fbd52ab6so20092605e9.0
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 08:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793028585; x=1793633385; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=52rsN+P0RqpEFf5O2HXjmwx5luMSAaqLDyiXEcr10so=;
        b=Jl0fg0OX5NQsOHFm5iAlcwsq8gq516N68xqYGBEOJwDrpz5PaZ4wyn0LLfI//tXDDt
         xKyo9SPS7aQjfBdBNw6S7bYWv3j0UqdOYx15fYBKdEq8Yy4NgNEpuPcNBqIh0s158Qan
         HsbsSim3a2wyy6+BU4WWOPEXzpJdODtEMdQkOisx4JNfjnCl78sskWuF8TZkXaIPzUAa
         Z9zAVhUFouRRMpaJrDBM/UuKmMkWQoHR6v6zpO52Ms3Av4bhZblKMJoTlFycC+Sdz81i
         3x9SCXlAyHRiCxOH7ZJm4TXGwzMK7O+/jCFoTuDm5vpQyNiGkpaJ0Occl3eoebNab/73
         auyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793028585; x=1793633385;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=52rsN+P0RqpEFf5O2HXjmwx5luMSAaqLDyiXEcr10so=;
        b=jgRiAkwUcF5l0s2zRH7PQbTn5VDcvMcUBMnmrjUQH+WfzKkg0DMTVSc/ykiFufnrFP
         ToTw0qzeE00smDLXecxU44bo+XWyCIPpRNleT/Kd8oXgZgDi093CVitlXjxbXg4A8w07
         SCdD6X3YbQE5tGZuASFWhVAmtxC0wFtx7hpYBsxndX42XeBHs3Uz7iBwzqqkD65zHld7
         gym+tqO0iRRCsYYdbhxOIkri+YNARgOzMr/gcYjg55BfyyhJwZo1E6fYvIJ5hQb/7vTf
         Hg0x5oQgR3Str3GMfM2DY97CjZ4SP6PHhPTX5GoMLotgevE/4n7XDojFB6UsUZVoFo7g
         iiwg==
X-Forwarded-Encrypted: i=1; AKwUvBzV3eKYwzRt9HXaWVsAvJxuRaZ7G+sOhZGIp9pyodhex2yJpf1+vmGOay4Q40Pa3Y1sMFCRPNig+T9GPsz8Ow==@vger.kernel.org
X-Gm-Message-State: AFq9FYLIoM21ubbxJMIY2qVu6NUW8dnHeEyRiY/Gw3bFfCw1sAncrqa+
	zCjFGke5I9yQB77d76FU2TwKPf1e7vbgg+EoQ7g7Q3m7JoqbUOTaxoX1
X-Gm-Gg: AYBFou2TU5A9GONku2iHaYmcA8wrqUcEXgHWhhZsPsOH6JU/D8kCVt+J9XRel646BKN
	dWnFEor3dx7kjCVvpLpYsqOD5FssxVJjx/X1D9c3wlpk5WgyKIznMP8bOB47yvYX/Pe1sUnsP05
	BmHg4TaEBycfWHIgz9ybIfAv/sXncrHZ+HdJMMWWRKc/Kr+jRXRv0gn2DJoKPXnnXDA/zXsyPhP
	3pBFYWU50q0u6Ajr3qLDC7KvQKMv68BmiSgf9FbuaSmndoW1DbWrMs8lacG+U7dkeNtv+CHVwzz
	MJ3XWrvSTivwQBUypNfiUeoNGHK+DxuTbfrTTFFEvhf664jhr1Wr1MBRjZjvuevmQs1TJjM9RIg
	Xx/CojIGs6n/yUrsiwLfsCu7Vt7JES88JdT+Yg6BUulAvRYYr6cFHcbmuAFMk43PxkbGGWRvTm7
	4sYsboIKfc10lr/40nj2z0VHCujRbmB+lXJiXlRQTk/1zMvRRr0lcNmfF4yEC/3kPW+u5zkw8PL
	6nCG32X5tsQHY6xsvP7WZz+Kr0/KoANt6++1Mwk9udDXoYZkG872zKi5y0Kiw==
X-Received: by 2002:a05:600c:4e87:b0:4a2:cbe:beac with SMTP id 5b1f17b1804b1-4a35aca73dfmr134781025e9.23.1793028584438;
        Mon, 26 Oct 2026 08:29:44 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebd4ba7sm17255244f8f.33.2026.10.26.08.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 08:29:43 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: [PATCH rtw-next v9 3/3] wifi: rtw88: time the countdown downloads from the TBTT
Date: Mon, 26 Oct 2026 16:29:40 +0100
Message-ID: <20261026152940.1274382-4-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261026152940.1274382-1-mehmet.fide@gmail.com>
References: <20261026152940.1274382-1-mehmet.fide@gmail.com>
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
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Reviewed-by: Luka Gejak <luka.gejak@linux.dev>
---

Notes:
    Changes in v9:
    - Acked-by from Ping-Ke (on v8) and Reviewed-by from Luka
    
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

