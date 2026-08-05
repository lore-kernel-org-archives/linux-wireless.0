Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D82E3E49F4
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 08:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785918416; cv=none; b=J4X08/e5dZhoqI7NzLwiZRVKEV1rfnoQLXeB5GsOZ2jkwDHV+ENnXu3AWSzSFPsIK7uzigPbvF0Myq0wrhWRH42wWDf2QB8U4LCHH6SosnwuJMGypZ3zKUGbWOOflowon+mAzyzIBXjhWjwhiZbCNpK2zm5GQN3oXR4db66TP1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785918416; c=relaxed/simple;
	bh=H2ueGBpKNnuryYzHaXv8zqEJaPP0wOpOcMhcerSG1BI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cR+dQMS3z9ETf/Mr4RzwSCEsoAiaAcUaF5NAyvShuaCLxKl7h7Qxa1iA+uwbQkBkcBlYjPxWjwrp8g6lGZXx50C37qhPwJz4SdzssRZwbIYpP5j9aLxoquhv7+oDNsOqNLNxUBlh8QM0MdDDY/RfHgrxFjAWm59hHK/pcVPhAyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l9CZ1cKF; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l9CZ1cKF"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-38dc69c74b8so765300a91.0
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2026 01:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785918413; x=1786523213; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rYomsqlGTKbFGFVO2mSphr/IfNChhNad8g6UC8Dwxng=;
        b=l9CZ1cKFlMWrGi4bdAd2EMaijRAs8bhvSDd14sov4cGucuvaAE/mHtXWWmOuU5xf6g
         Cpa/SmUYs6bitZhL95iQGrIR+7TvlIveCO/sc47ShDa1eqV99AmqqRom7FOWgrTUk+Qa
         XHk005GREdZBcGTyTC4B1T8XkINrRFcq3qbJTK+Hq+e8RUVeD2fuja7AE521vgEQ/xxE
         RB5ITqipLD0WqFfc/7fEhi8H8Fh5rRejaW/PLd22OgmxHBacqLTXM7ooMI5ePCwH8Hxj
         21h4XMwk5c9IKE7X4S+yR0MKWuc2nZV8nBAYKUxVgjPgUqW4PcRXto3vMNIYvpWGOe25
         evwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785918413; x=1786523213;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rYomsqlGTKbFGFVO2mSphr/IfNChhNad8g6UC8Dwxng=;
        b=a7hwxJOhz7/Te9VPpe66O800zYbBTp517ya/wweXGhJk8wZE0R4y3gvREVu35gWtuy
         NmzV60FDE+A7B9v2r1Yms88TWxx1iTyPFytwRToz4cZ2Crqdue3Xh52+fEn6N6C9eUaF
         HX9+V2BaX7eLGD+g0dTtlfFHVWr7i0g+ii6JHysnpDuE+gQCktC+1yiG7v/FE4jCbCdp
         pqH6qlHI6gxE3F3ty1StcmAxyASAdeFDewoUrbwXAJW87fCM1gdu+O0e961UWnX9tf/l
         d5/eNpj5KoBHi3C3AweKhfpAuLVYR9vXyp6VA5xzuWpZrSd+WNLq7kePLR4kkmwYEUoe
         2Cpw==
X-Forwarded-Encrypted: i=1; AHgh+RpSn+qOeKMpkZMxB9eXOfB0iEjJGIpnBOBY+8GImYnxcD3LK3tRBE50nl3E67w4nsTa10wJzBb517zFUvyUig==@vger.kernel.org
X-Gm-Message-State: AOJu0YwqSRy1HwlX7A7vMzyaxa4yJPN70ODvaUhuBYYO0voCuYDhc8fg
	weqT1zvQvdtpipSufGZjC9AzLJtTNtUdFCjujkElM2fc9yj3q86wzvoj
X-Gm-Gg: AR+sD120OTrnymsZ96eVYiNyYWj1VoK6P1+qO7CnZdPVndNdVOLqGqAK++D/0+m5JVG
	7sm8XjL1nUKxvFvlJWOB3QIT0aRsH/KAd1Ui1LDGpCelFxg9qKh7QjL7PPo8QaEDXYBZAh2eQu/
	gpZ4AM+918JAn6JJqAgjozDAejdGshjUiLMjMj3evFa+cVBYtrl0RZytOWQpcdhdk/lSSS2/kbE
	YNhKwZ9NtTooUoobZe5jD+8VWYEg+KOUloqnafiJK9U+91tPM/RLHshk/GOGzARdKHP9uC9tPSJ
	BAsLO/zt/kp/LNAt8r8oNVRgKXivR8P2knGlTxylyzBvALP9P9cXPayfYlLdSAWhqRfF0tA1REK
	U/1Dwj3xbu4Z7e4knKRetIarcJalgIsb1Z1Kho7/cBqx0qTUEs51aRLXVs63prKl8tU5pWR5qa5
	gV5Qy2pSbRwYZ3mD5OsFHmtU9Xp/CjAC4drAeb/nMC0zqLW//4/9dGjRyNbDs9rDD6HrsaD+mp
X-Received: by 2002:a17:90a:ec8e:b0:37f:be6c:f3f2 with SMTP id 98e67ed59e1d1-3903c53827bmr5571839a91.2.1785918412732;
        Wed, 05 Aug 2026 01:26:52 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3903f5fdfe5sm1263278a91.4.2026.08.05.01.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 01:26:52 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
X-Google-Original-From: Zhan Xusheng <zhanxusheng@xiaomi.com>
To: Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Richard Cochran <richardcochran@gmail.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com
Subject: [PATCH 2/2] wifi: iwlwifi: mld: Fix GP2 to nanoseconds overflow on 32-bit
Date: Wed,  5 Aug 2026 16:25:15 +0800
Message-ID: <20260805082515.4136842-3-zhanxusheng@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260805082515.4136842-1-zhanxusheng@xiaomi.com>
References: <20260805082515.4136842-1-zhanxusheng@xiaomi.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

GP2 is a free-running 32-bit microsecond hardware counter. The PTP code
converts a u32 GP2 value to nanoseconds as:

	gp2 * NSEC_PER_USEC

NSEC_PER_USEC is a plain 'long' (1000L), so on 32-bit builds this
multiplication is evaluated in 32-bit arithmetic and overflows once the
GP2 value exceeds ~4.29 million microseconds (~4.3 s). GP2 wraps only
every 2^32 microseconds (~71.5 min), so the product is truncated for
almost the entire counter range, producing bogus PTP timestamps.

Neighbouring conversions already cast to u64 first (e.g.
(u64)gp2 * NSEC_PER_USEC); these sites just missed the cast. Cast to u64
so the multiplication is performed in 64-bit, matching the existing call
sites. 64-bit builds are unaffected.

Fixes: d1e879ec600f ("wifi: iwlwifi: add iwlmld sub-driver")
Fixes: f1699ad5857d ("wifi: iwlwifi: mld: add debugfs for using ptp clock time for monitor interface")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/ptp.c | 4 ++--
 drivers/net/wireless/intel/iwlwifi/mld/rx.c  | 6 ++----
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/ptp.c b/drivers/net/wireless/intel/iwlwifi/mld/ptp.c
index 1ac85d6ce1d7..81645f8caa54 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/ptp.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/ptp.c
@@ -59,7 +59,7 @@ static void iwl_mld_ptp_update_new_read(struct iwl_mld *mld, u32 gp2)
 u64 iwl_mld_ptp_get_adj_time(struct iwl_mld *mld, u64 base_time_ns)
 {
 	struct ptp_data *data = &mld->ptp_data;
-	u64 scale_time_gp2_ns = mld->ptp_data.scale_update_gp2 * NSEC_PER_USEC;
+	u64 scale_time_gp2_ns = (u64)mld->ptp_data.scale_update_gp2 * NSEC_PER_USEC;
 	u64 res;
 	u64 diff;
 	s64 scaled_diff;
@@ -159,7 +159,7 @@ static int iwl_mld_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 
 	spin_lock_bh(&data->lock);
 	data->scale_update_adj_time_ns =
-		iwl_mld_ptp_get_adj_time(mld, gp2 * NSEC_PER_USEC);
+		iwl_mld_ptp_get_adj_time(mld, (u64)gp2 * NSEC_PER_USEC);
 	data->scale_update_gp2 = gp2;
 
 	/* scale_update_adj_time_ns now relects the configured delta, the
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/rx.c b/drivers/net/wireless/intel/iwlwifi/mld/rx.c
index 269439d789f4..108ac70bfb14 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/rx.c
@@ -1524,10 +1524,8 @@ static void iwl_mld_rx_fill_status(struct iwl_mld *mld, int link_id,
 		iwl_mld_add_rtap_sniffer_config(mld, skb);
 
 		if (mld->monitor.ptp_time) {
-			u64 adj_time =
-				iwl_mld_ptp_get_adj_time(mld,
-							 phy_data->gp2_on_air_rise *
-							 NSEC_PER_USEC);
+			u64 gp2_ns = (u64)phy_data->gp2_on_air_rise * NSEC_PER_USEC;
+			u64 adj_time = iwl_mld_ptp_get_adj_time(mld, gp2_ns);
 
 			rx_status->mactime = div64_u64(adj_time, NSEC_PER_USEC);
 			rx_status->flag |= RX_FLAG_MACTIME_IS_RTAP_TS64;
-- 
2.43.0

