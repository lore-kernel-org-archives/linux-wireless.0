Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6993AFB0E
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 05:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791781530; cv=none; b=m/Y1yOYwzpGdoJvsW1voQdfWVcIUOGPK4mL7xQ+a1NcptwVb5LiwanfLT/lVWsrye8miq8E2fasuW2IAj2+mjXV8UL3zzoTBQufNSurnz80D+Vax5AwZgdwbsWoHaMRpvjo0J6uKZNsCEmAnQRkHDaj6mtj+MHIIRx5AxDduiO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791781530; c=relaxed/simple;
	bh=RhHdnm8RnMJtsb4Mn4w1XLaLle0vODhrgTirmFoDMtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRft2fo/qQ3XaSUa7eGox7MPqp6bnTwjY8aZiOnJHSznrC1+5I3hDvIqgA0GIn5FUc+pnPVgM49c47Az60xqCc86kmbWogYI5U3MM5YWakCiEk6I659BgpmdbbvppkroRtz/RH2NOvsaqo19td72gHERxuBmFsmTCY7Us7LdhTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZqYNfbuJ; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZqYNfbuJ"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8819033dbadso926752b3a.0
        for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 22:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791781528; x=1792386328; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b/5BGt+KW1rM09CksWyEMtJ7DGtKQm254W8uGFhGj2U=;
        b=ZqYNfbuJdq2bB/D72dzGmulPI4kvuE0boWqzDQnR/pDZCXFvW77jX3tPidE+GllJJA
         GPHS+D3L179s55Zc6MOaQiRxGQDlPWbnQ+ZfuQ5gwj31d787PggBy5K5uEmDG4zU68H5
         efkULSokMKbSX8dM1xLdEzqOoYg+9WA4eqtbPNLfALcuhfmbw5GzjnY4SeuT7oz94mUQ
         D0AGS74EUvAjZ2jln+qZTfwoG1fIDaNm+FJzQHhnss/ik7mSRvlpjITvilsTjJmCmIpX
         2ganYnBucuqAx9HFgSSSZ2BGwGG9tSDDB8EKKfq4yetOtsZ39A+LA5Kwun540v5eU714
         lbgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791781528; x=1792386328;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=b/5BGt+KW1rM09CksWyEMtJ7DGtKQm254W8uGFhGj2U=;
        b=EUyOylgTRXzisRg/JyNuTa+NZn3aJC+J7mXNC58VNAYRgbayoijOaFTsN29H8MMGWW
         rRlsNmbot7b11E8FfBd7SlVoFAKFZomWPD3KLFWHuK5SkMnbxpXo4Qd05OdpPLFuvGSy
         6rRmdFz2TDS5qgdK03uMAqtBG8HXaS9YnRi85ElAmuo6wbUeB5ZjcQTBWuIBEzpma/nD
         PFnK82K0TtOjLRyhTYSg4JKaRnCLfTNzLfg7xOnzWcH50Ud5e3POoSRezKhztwKJ4Umu
         qEf8pkoatuGtyvtHzhD5frwVuF6Yz57YuNjSn9bxOFwxzHGT4eI265T5Qs/vahhzKy0h
         /PpQ==
X-Forwarded-Encrypted: i=1; AKwUvBzwOZlVesbDvs/mvwbYg8TfdHxkkmRr2cGlyChewpuFsBchkHNh8AOp0EXQl4cXZx5PUuf6MpljvwiP0b0Pbw==@vger.kernel.org
X-Gm-Message-State: AFq9FYLMeNOaSgfC+vsB1tk08l9yuOA/aOGtyoXGVsAaPB/iCK974ISf
	46PUHu0Mc9VG9xkHTe6RBwh/2dvE4mfVymJV/vVxSw2AafywXr9Jrb0v
X-Gm-Gg: AYBFou1ceDSgQ1gGJ8aziQumthv3opkdKEXe/b/bvIgJUvZAS3L8dRS0ImsSoznctkB
	H9gkUWsX9Hynqj2uDJtLoZREIIzNTACJ0M27GfvxlM9mEJ/h3wIdHuflBHlP+p+fe5NIDGqyFPP
	lwG030FZzPD3MNPbC08cmZ7wkTZFviS3dw0ljbznlh52ybCnoLMaYX6klAFN+nXeXjnBHZWFkS1
	o1NJfYHzeoNOiD/zNEzOSxydj6Vv737Y8nYamrMPj6yOzpKubdL8yYsGO5S2QdeXLRi7BN5hVM+
	H+pZqBBwWIFFLA19ND9xq0+SQwhM88bB9RJ7XBVBXkvf7X4lK2XgUqA6dr61tR9bJQ5XmWJdSK3
	qeOLE+0hpLabO+B060jA5sIdMW6xS8ynv+iK1RTvKJ8FXiqYlmSlUiAuPU8axmaRWDflxiyzN7d
	CB2LxEF8z1JZMVzCM8QPAQtg0fQ0hMbIcU2t1L457LGGiON93SIr3Zw+NWzKeOrrRczQw5ioP+p
	aWsdTtJf1o=
X-Received: by 2002:a05:6a20:549d:b0:3df:f4a5:dca7 with SMTP id adf61e73a8af0-3e16bd88afdmr8608414637.16.1791781528067;
        Sun, 11 Oct 2026 22:05:28 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-896c3106de6sm3593668b3a.14.2026.10.11.22.05.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 22:05:27 -0700 (PDT)
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
Subject: [PATCH v3 1/2] wifi: iwlwifi: mvm: Fix GP2 to nanoseconds overflow on 32-bit
Date: Mon, 12 Oct 2026 13:05:15 +0800
Message-ID: <20261012050516.3803074-2-zhanxusheng@xiaomi.com>
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

A GP2 timestamp is a u32 in microseconds and NSEC_PER_USEC is 1000L, so
three multiplications are evaluated in 32 bits and truncate for any GP2
value above 4.295 s:

	u64 last_gp2_ns = mvm->ptp_data.scale_update_gp2 * NSEC_PER_USEC;
	iwl_mvm_ptp_get_adj_time(mvm, gp2 * NSEC_PER_USEC);
	iwl_mvm_ptp_get_adj_time(mvm, phy_data->gp2_on_air_rise * NSEC_PER_USEC);

iwl_mvm_ptp_get_adj_time() passes its argument back to
iwl_mvm_ptp_update_new_read() in microseconds, which treats a backwards
step of at least IWL_PTP_WRAP_THRESHOLD_USEC as a GP2 wraparound and
bumps wrap_counter.  A gp2 of 10 s truncates to a 32-bit product of
1410065408 ns, i.e. 1410065 us, an 8589935 us step back, so the 5000 us
threshold is passed and a wraparound is recorded.  Each spurious
wraparound adds IWL_PTP_GP2_WRAP microseconds, about 71.6 minutes, to
every later timestamp, and the error accumulates.

iwl_mvm_ptp_gettime() already holds its GP2 read in a u64.  Cast the
three u32 sources before multiplying.

Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Fixes: a2f49f7d52a9 ("wifi: iwlwifi: mvm: implement PHC clock adjustments")
Fixes: 0e49e940d1bc ("wifi: iwlwifi: mvm: add an option to use ptp clock for rx timestamp")
---
 drivers/net/wireless/intel/iwlwifi/mvm/ptp.c  | 5 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 4 +++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c b/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c
index 49dcb1388007b..c64d6327e76f1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c
@@ -47,7 +47,8 @@ static void iwl_mvm_ptp_update_new_read(struct iwl_mvm *mvm, u32 gp2)
 u64 iwl_mvm_ptp_get_adj_time(struct iwl_mvm *mvm, u64 base_time_ns)
 {
 	struct ptp_data *data = &mvm->ptp_data;
-	u64 last_gp2_ns = mvm->ptp_data.scale_update_gp2 * NSEC_PER_USEC;
+	u64 last_gp2_ns = (u64)mvm->ptp_data.scale_update_gp2 *
+			  NSEC_PER_USEC;
 	u64 res;
 	u64 diff;
 
@@ -259,7 +260,7 @@ static int iwl_mvm_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 	 */
 	gp2 = iwl_mvm_get_systime(mvm);
 	data->scale_update_adj_time_ns =
-		iwl_mvm_ptp_get_adj_time(mvm, gp2 * NSEC_PER_USEC);
+		iwl_mvm_ptp_get_adj_time(mvm, (u64)gp2 * NSEC_PER_USEC);
 	data->scale_update_gp2 = gp2;
 	data->wrap_counter = 0;
 	data->delta = 0;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 7f0b4f5daa214..7a9a63a76f382 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -2017,7 +2017,9 @@ static void iwl_mvm_rx_fill_status(struct iwl_mvm *mvm,
 
 	if (mvm->rx_ts_ptp && mvm->monitor_on) {
 		u64 adj_time =
-			iwl_mvm_ptp_get_adj_time(mvm, phy_data->gp2_on_air_rise * NSEC_PER_USEC);
+			iwl_mvm_ptp_get_adj_time(mvm,
+						 (u64)phy_data->gp2_on_air_rise *
+						 NSEC_PER_USEC);
 
 		rx_status->mactime = div64_u64(adj_time, NSEC_PER_USEC);
 		rx_status->flag |= RX_FLAG_MACTIME_IS_RTAP_TS64;
-- 
2.43.0

