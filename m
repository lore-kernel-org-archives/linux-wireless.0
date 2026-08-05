Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6FF3E0097
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 08:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785918410; cv=none; b=RkuWWZViwCxKGj9tNXwtQauH+0VEd80f8gwcpOwXGncw9yd+jiLbpXHVfhVSS3lEr5oUyp4URn7/ZqwdVf6UWt+1DqRrhpDRDlSrENTrv8YAN5sbZIuz5Bz0rucWSfYgt1cW9oFjsGIAfEDZkci2sFX8KCaQyOcOhXnTr8rUdgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785918410; c=relaxed/simple;
	bh=yxjNkZ8RDtnKLLBtUDzry9ka1J/AonCMd8VeTUNrAR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XMeTdW8bPBkNNs4GEEe/16s6dqKaAlRSNYiv21ATDRHQ5j9Oo3VJjemT6WyWqupZECNtc86IuXMu8+ArqJ2+eQmO4KIOX1lmMY0ch1hGon7k7mbd1hVmtE+CKcN1fXsXA7jhclutbLp2fKxsjhtZ8yrFNgFVMXHIHUouB1FOYQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sfdQaw33; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sfdQaw33"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-382ef647e20so755291a91.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2026 01:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785918408; x=1786523208; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4KvgqB1WiIQ06bt23ukkBqvaJLYhdGYjoetwwW9XLQg=;
        b=sfdQaw33hPMtMJ6/e0qQUyufva0MlSQLM4/Undv+XnclVtF+BXqOcqUVqeyRNk9dzE
         5NFjgHcOZ383S6umRG2qPmFOH4Wqu9jskeWYtdX6gQmraE5jvjetFeDJI3tEWbqx/I+Y
         uZb5DjujXay7WYE4USF2+HWwtk0w9nX8bx5V5xmX4s8NqkgeWCla4H5lE8x/aLuBuK/X
         ESzUShuh7PN4T7OmpQL5l3Q4nZOamFkdWCQF8dd2whnanS2rhHyAIDI8nasD9vNLPdxX
         /r7j/HOCq1+gvmd0suBNWw47hPcUEtPQ+4eWbT7vg2sSFvp/GR/7WVvKYHWzeh39SUI2
         tA0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785918408; x=1786523208;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4KvgqB1WiIQ06bt23ukkBqvaJLYhdGYjoetwwW9XLQg=;
        b=Lb8EnNvOJzzflLL0/SIuMPqvHf+UXMSlItJD3vhmoTiiy7d7pYuMVHlqFn4JIXqwHE
         IqQuShe8C1LkMp0td2FtJMOgS89+bwzFCLuDmTxK47hIEYJBlKtRAlDfmpihHg/EygsP
         pRGtN1+lEfI9kcJJEC9VQFB6IroJHSk6irwXRkNr14PnGdxVLQZkIaCzuNJ3ASYFSC5i
         kO8BcaYSSOLTeeZy/f/DjD0vRVa8/xD+Dv1SIHmWkZcDaQT7EuqyKrkTcHcpu9Hu1mTr
         MJNtQSEKJHrHSxyPuNP6zGmlFG57EIUKdwC4a9KR8uZOS5dvJcjRyCA0IbuZcTPrhHgv
         uV6A==
X-Forwarded-Encrypted: i=1; AHgh+RpiM9iJiwXRw6+EXbRKfHy7NqK9RmVj601YOsKnY/Nm39uFpe7dOeJfhRYKq610ODsQMi/0HqcyD9/LPYDqKg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxA9D5jNvaxYw+3rPCqI/tKg1w7jPw4OvN4zLtb8cLIdtOown5x
	VbL6r08rNmIyOyloj2pz46L61XmwiJm9qk3+vD4OLp2A3/1zp9imfBWb
X-Gm-Gg: AR+sD117rP60Kbl5oDVG/o6i6u1792pj67mJf2K1+l1EXUMFpLhTZKskkOq+Ccu8D/N
	Row4OSXkuylrGkj07jyh2p5bIUpHcY4T0ZcItr8RD5OoY+AVySaumh2cHcZ4Tzp/Jv93U3SqWXH
	e2nFxIkvdc7RUm9grV61Z1BbHoC3f27FmAlqwbFZYG02LkP52EmFpSYJCz+isQoBW8rIpJ6GkAQ
	GTsEUJpGMgieHPYUDokfVyFxM1mbtrJKJ+jr4lXfOADLEXk6+l68sF0PpSozc7UrVGoGqg5FSTH
	ZFNE2XiclCv1m4969ivmOKuA+ZMZYdgHjoOglVN3WIvBMAxW4dubcUG2Bw9FpeDeTDOfxaH0XRr
	35rH0hymWPVSGDQOWmyQ2ohW7yGn/yjkzQNczYMMyV1Kz3w+Se4RpKqmIi7PcTIguow0sAIU4y/
	1pwD4E3KteL/7a4T7LOpBLjAKWria/3mna5dqBexXtF2bTTCEc6VdodF0D0YTHHZeq2OwBwz4Tf
	RF6UUvbbasE
X-Received: by 2002:a17:90b:2782:b0:36a:8240:2477 with SMTP id 98e67ed59e1d1-3903c60c488mr5311472a91.19.1785918408334;
        Wed, 05 Aug 2026 01:26:48 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3903f5fdfe5sm1263278a91.4.2026.08.05.01.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 01:26:47 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
X-Google-Original-From: Zhan Xusheng <zhanxusheng@xiaomi.com>
To: Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Richard Cochran <richardcochran@gmail.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com
Subject: [PATCH 1/2] wifi: iwlwifi: mvm: Fix GP2 to nanoseconds overflow on 32-bit
Date: Wed,  5 Aug 2026 16:25:14 +0800
Message-ID: <20260805082515.4136842-2-zhanxusheng@xiaomi.com>
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

Fixes: a2f49f7d52a9 ("wifi: iwlwifi: mvm: implement PHC clock adjustments")
Fixes: 0e49e940d1bc ("wifi: iwlwifi: mvm: add an option to use ptp clock for rx timestamp")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ptp.c  | 4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c b/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c
index 49dcb1388007..5f33e2f8fb2a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c
@@ -47,7 +47,7 @@ static void iwl_mvm_ptp_update_new_read(struct iwl_mvm *mvm, u32 gp2)
 u64 iwl_mvm_ptp_get_adj_time(struct iwl_mvm *mvm, u64 base_time_ns)
 {
 	struct ptp_data *data = &mvm->ptp_data;
-	u64 last_gp2_ns = mvm->ptp_data.scale_update_gp2 * NSEC_PER_USEC;
+	u64 last_gp2_ns = (u64)mvm->ptp_data.scale_update_gp2 * NSEC_PER_USEC;
 	u64 res;
 	u64 diff;
 
@@ -259,7 +259,7 @@ static int iwl_mvm_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 	 */
 	gp2 = iwl_mvm_get_systime(mvm);
 	data->scale_update_adj_time_ns =
-		iwl_mvm_ptp_get_adj_time(mvm, gp2 * NSEC_PER_USEC);
+		iwl_mvm_ptp_get_adj_time(mvm, (u64)gp2 * NSEC_PER_USEC);
 	data->scale_update_gp2 = gp2;
 	data->wrap_counter = 0;
 	data->delta = 0;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 7f0b4f5daa21..7c21cd89db93 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -2016,8 +2016,8 @@ static void iwl_mvm_rx_fill_status(struct iwl_mvm *mvm,
 	rx_status->device_timestamp = phy_data->gp2_on_air_rise;
 
 	if (mvm->rx_ts_ptp && mvm->monitor_on) {
-		u64 adj_time =
-			iwl_mvm_ptp_get_adj_time(mvm, phy_data->gp2_on_air_rise * NSEC_PER_USEC);
+		u64 gp2_ns = (u64)phy_data->gp2_on_air_rise * NSEC_PER_USEC;
+		u64 adj_time = iwl_mvm_ptp_get_adj_time(mvm, gp2_ns);
 
 		rx_status->mactime = div64_u64(adj_time, NSEC_PER_USEC);
 		rx_status->flag |= RX_FLAG_MACTIME_IS_RTAP_TS64;
-- 
2.43.0

