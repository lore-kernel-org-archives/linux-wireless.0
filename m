Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6432A39DBE5
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 05:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791781533; cv=none; b=kPvCTnVDpFyo9J2zuGrWqJLRJm9Ud8tZxuEpTg53/ig/y7AK3hMq8i9fM9qwUerbIkQKhKfaj1lZGLnLau/ntPI4NqZualX0e8z+WREjwNMGMm+QaiIX4a6Cm11EEHGB9bdbQTYB0jI9xRn6mSK8KchNW5S6pGfqOOxiVQ5kb1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791781533; c=relaxed/simple;
	bh=yJqMVXMUOetINackjZo98OM/4dyZZUw95vG1H/z45N8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRYQjj+R5P4wee5OAcC4cKCTDrvsL84YvLBQqDUwI6utcpr22bC6bybh/G26vpO00bgQ3wcYS0S1ArPhZET0sf2R7MWjQdkdkCYKCGhQ9FlwW76zs8LFbBF9ff/Nk+bStkXsyuPsnQOp6T5Go0LdumQ4sc1bpiwZ7he7w3PrNrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LzHOXiqK; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LzHOXiqK"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-8819033dbadso926771b3a.0
        for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 22:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791781532; x=1792386332; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SchT4fFbVHXJLcmuds777iB8GRkCImTCzsdYd+pPxgk=;
        b=LzHOXiqKzKDqW0fQ8nKbdtfaCAEJHvywJTZ/UQp7BTqjBGZAZYzi2QP/IPnucFVx7/
         9sMG5Wj46h5IEUiu/yTgzvzzeoRoiJnnDka05NKuCvy156iRdTNWdZJOxBOg7VnFTyWo
         5JmM+oMwa86I9TiAvnw5KYIxgPdFBJuCOsh3SVlFxTgRqpwo5MNS3tzTfAfWQGh9tzSO
         mKJPuk2/B2x9Zer8BNrYjbLVuSkU0/x5494uyZF69dIYxFve3CWV8mCqexEsk4WNUaUQ
         F7LxS0pazOAyKqewWzxwd/FxRcuGrTnfaEjcqnEeEpyLtW2BTy8uxN9o+L0uyFFP2gYk
         PqTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791781532; x=1792386332;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SchT4fFbVHXJLcmuds777iB8GRkCImTCzsdYd+pPxgk=;
        b=ne7gqeTcngQv2hwSPeBTgzVt1DPyew+lmwePVawf/TVWjDmuwATJbPh54cO12cZe3w
         h0AHOQsHCJxCxXhM7RtiVwi1JxvejhljDL+V+1J781oA9pVFqxseUVk/um9JQBjOMT2I
         YSMCIzpH8T+2yhWudjpFV84DbB0pGMiGU+GNh9Yf4r2btxskaPlUnKubjBMRzRn6wg0s
         wO7ZwWLwEte/6UwJ3eMdjz8ALPfYhCxDkqb1pKaZnw4j5G2722hOIuIU+1oluEdg/wAb
         Wh+L4G6XkmNbAf2zAiotyKu7Qlth42JVbAO01VfVx7AGhEUqOR713EuW/fA9vkxL9jwr
         pJqQ==
X-Forwarded-Encrypted: i=1; AKwUvBzeopo88EFQ2z/11PWBzHWauhyPDglbKJ/Tv8O47b9EhUYp+D2dG3ozdjSNJNszXDXVJHL38p59HXQ2QUfigQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYI+sevGfNOp+qbnjy7YF6N3evvYmsb49kLzTHMMsZCGxRJc29pL
	1cA+g7WwjZ/f7WqzpyDe9vVte0sJ3wrb3LigNP71MprjoUD4l8KW3Mk5
X-Gm-Gg: AYBFou2t0vPK91V8+ijtuJaMY7chf2BJxljroQzqOSn6F2aLnA1qzVHLLLLB7NPeZtR
	1c255rvCKY4zfVFf+5zIwFVfyikcNv0Z2KbqaOfWtWPAwQO0zNIYjc6OsxN7RP2RUMnwJ7yvsRv
	kkjEEqObvGIsU7RBqEBlPD1UTYC3+PuY1k3YYd8Kl/rbzsOSoDpCzCM8ATErkLzdQ70ugsAYopg
	pohbEcXU/ZGvCR4h6DUTe6lRXakAheIKWivkkV2311mtD++8lvNMfs8OgZdqI28DIv+cfkAgz5A
	ssRH3PSteQTCEqqXCMcOZ6MoEszKhe9XrUWRv0TZlL+o7unblA0G/WRvG+kZCuOBPJQ83WVvcBz
	xHkrF88dgG5/vGRMV2Qlzx5iwN+u0qS1yFEn4ICKOgioKlWhPn/CrcJYs2noPmpcUKRrR+ynALM
	kZgCDOyyea31XguEM7JXvDClSC9Z9Eb3UcjEvfmmZbYi8QQjnUjtIoKKTKEFqMi811JMOH9oxXh
	jgWpnivHVs=
X-Received: by 2002:a05:6a00:3d88:b0:898:22b4:c8b8 with SMTP id d2e1a72fcca58-89822b4d170mr5055420b3a.3.1791781531584;
        Sun, 11 Oct 2026 22:05:31 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-896c3106de6sm3593668b3a.14.2026.10.11.22.05.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 22:05:31 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
X-Google-Original-From: Zhan Xusheng <zhanxusheng@xiaomi.com>
To: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Benjamin Berg <benjamin.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Avraham Stern <avraham.stern@intel.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhan Xusheng <zhanxusheng@xiaomi.com>
Subject: [PATCH v3 2/2] wifi: iwlwifi: mld: Fix GP2 to nanoseconds overflow on 32-bit
Date: Mon, 12 Oct 2026 13:05:16 +0800
Message-ID: <20261012050516.3803074-3-zhanxusheng@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261012050516.3803074-1-zhanxusheng@xiaomi.com>
References: <20261012050516.3803074-1-zhanxusheng@xiaomi.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhan Xusheng <zhanxusheng@xiaomi.com>

Same problem as the mvm driver, in three places.  A GP2 timestamp is a
u32 in microseconds and NSEC_PER_USEC is 1000L, so on 32-bit

	u64 scale_time_gp2_ns = mld->ptp_data.scale_update_gp2 * NSEC_PER_USEC;
	iwl_mld_ptp_get_adj_time(mld, gp2 * NSEC_PER_USEC);
	iwl_mld_ptp_get_adj_time(mld, phy_data->gp2_on_air_rise * NSEC_PER_USEC);

are evaluated in 32 bits and truncate for any GP2 value above 4.295 s.

The last one matters most.  iwl_mld_ptp_get_adj_time() passes its
argument back to iwl_mld_ptp_update_new_read() in microseconds, which
treats a backwards step of at least IWL_PTP_WRAP_THRESHOLD_USEC as a GP2
wraparound and bumps wrap_counter.  A gp2 of 10 s truncates to a 32-bit
product of 1410065408 ns, i.e. 1410065 us, an 8589935 us step back, so
the 5000 us threshold is passed and a wraparound is recorded.  Each
spurious wraparound adds IWL_PTP_GP2_WRAP microseconds, about 71.6
minutes, to every later timestamp, and the error accumulates.

iwl_mld_ptp_gettime() and iwl_mld_phc_get_crosstimestamp() in ptp.c
already cast to u64 before multiplying.  Do the same in the three
remaining places.

Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Fixes: d1e879ec600f ("wifi: iwlwifi: add iwlmld sub-driver")
---
 drivers/net/wireless/intel/iwlwifi/mld/ptp.c | 5 +++--
 drivers/net/wireless/intel/iwlwifi/mld/rx.c  | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/ptp.c b/drivers/net/wireless/intel/iwlwifi/mld/ptp.c
index 1ac85d6ce1d79..41ba49f525845 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/ptp.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/ptp.c
@@ -59,7 +59,8 @@ static void iwl_mld_ptp_update_new_read(struct iwl_mld *mld, u32 gp2)
 u64 iwl_mld_ptp_get_adj_time(struct iwl_mld *mld, u64 base_time_ns)
 {
 	struct ptp_data *data = &mld->ptp_data;
-	u64 scale_time_gp2_ns = mld->ptp_data.scale_update_gp2 * NSEC_PER_USEC;
+	u64 scale_time_gp2_ns = (u64)mld->ptp_data.scale_update_gp2 *
+				NSEC_PER_USEC;
 	u64 res;
 	u64 diff;
 	s64 scaled_diff;
@@ -159,7 +160,7 @@ static int iwl_mld_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 
 	spin_lock_bh(&data->lock);
 	data->scale_update_adj_time_ns =
-		iwl_mld_ptp_get_adj_time(mld, gp2 * NSEC_PER_USEC);
+		iwl_mld_ptp_get_adj_time(mld, (u64)gp2 * NSEC_PER_USEC);
 	data->scale_update_gp2 = gp2;
 
 	/* scale_update_adj_time_ns now relects the configured delta, the
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/rx.c b/drivers/net/wireless/intel/iwlwifi/mld/rx.c
index 269439d789f46..33c8cfa95962e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/rx.c
@@ -1526,7 +1526,7 @@ static void iwl_mld_rx_fill_status(struct iwl_mld *mld, int link_id,
 		if (mld->monitor.ptp_time) {
 			u64 adj_time =
 				iwl_mld_ptp_get_adj_time(mld,
-							 phy_data->gp2_on_air_rise *
+							 (u64)phy_data->gp2_on_air_rise *
 							 NSEC_PER_USEC);
 
 			rx_status->mactime = div64_u64(adj_time, NSEC_PER_USEC);
-- 
2.43.0

