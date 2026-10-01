Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CEB3CCFCB
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 05:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790830878; cv=none; b=JbHf/qdBuAkFcZ7P4B3ZbAhaRo2f85uVWQWRbEfYP5BtO6/lZDxypUsXyosks9SSBJuSu49yxz0XC3pmCvSNZ7Ng4gDM417bhK4rRvCtnNAzrRTVq8e7S7gqwMo5a19nUs93H9oUiN66apDezoCPJiH+Oc5zQTNxX3AFztXnA9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790830878; c=relaxed/simple;
	bh=8YZJ69ey0sPd+XzFNKSH5elxOenalI+CtLxC5znIJ+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DK6nSFvKwWwGsa0O3E8F7k2rGCyHpwIOAtdk5GDS4RdExBOuPvooie3WLfPriWiukA4lyK8kvfw4ZH1orA38Qn4+Fd3q4K4REjNkrmIVKmALO3599BA8AVL6LjeC6t5aCj9T3y/I0lcgFOuJiEk1OLImzS06lrMm4oiPmwK5cGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JDt35WUa; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JDt35WUa"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d747ee1f9bso29225515ad.3
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 22:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790830876; x=1791435676; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SP7oNfhQpc8o2+FdFv2zFrXCBPchs9tdxw8AkWMX6rc=;
        b=JDt35WUaZmXzC6q8LMCJF8R/KU9Px3eRLWpaUnfazyID19xUUitmGq9lqy7OxxVoDn
         kSTxAfMObA32BqFEtZsCr82meQ3KluKv5KE+aDQbb33dTo/15QH8tz3GL/2uylo4O1ld
         UoQNM4boRh/F0jM7yEq3P/SUIj3UI/8CBIMpxZtZlaxGcG4WvkxCpmJxoAf+XqxvOlqt
         L1FhD2tEIXpZUodxvXspIaqcCcJVPk0Y/E8mb27ZS96qEMaDa/J0XlVz6jDglssF9M/N
         eK2zKbThCmaZwT7uWOnu8ru6Oyd6xa2Zsdgv6V2esu2TdnjJM2shsfCxfRlBMklHH+o/
         Drkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790830876; x=1791435676;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SP7oNfhQpc8o2+FdFv2zFrXCBPchs9tdxw8AkWMX6rc=;
        b=1bF1BwbqxWUkxhfRp6DT+hlhtX4pNFH20j4J0rgdKuxEj1Qf2wbWhty688jZXZyosb
         9iR+22HTAvC/RqZVEpOnSnnFbiCyeS56+x9zgHoiTZY42oyD6oqYokCU/Q/6Yz3KkuLQ
         362WUjvODqmnPtJYwIVfvq9GhSDcC3xfi+74q2mEsaTiCmSWJehosZ9XGBHPahvQg4Hq
         fgN7Ndrf7m3CIiwrR331x33Te9UV1zh4OjcT53nL83BxtlAvPu69NHrIAGEkPqZZPhPX
         G2ZQvv4IH+U6hSkCTgiFGajzsm2U62ayzun3IFvLrlyyLj2gVFF+/+MKCE/P8IVpUSwN
         ZVRQ==
X-Forwarded-Encrypted: i=1; AKwUvBwApjxsRQ+GlyTaEvZnuLffjWbb9/SWRfyumGGtmagf8o5K1TLruOB1tc3Z0YEjtWbX3zsPgNRCZZjdy6WcKQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYIOK9gX50ml5rIHpDXJxJ22X1Y66hUVVTysXidx6hy+jdnCVImH
	3d7G5rxvqh96RqCgGlE2UZxf7wznBlbFl4j9FKpAaOARK0+OxX//10U3
X-Gm-Gg: AYBFou057vfzLni7OpaxyfyjkqR1uDLz6VP+HYK1cA0QU+qa64WQvONUJDZ8UZVHfFy
	ivBbyOWix4SLW65inydYpH1inDA8dWd06sH/NW+8hWh3fs25//hQxcou0itzFDDhqu2/BugNW9g
	FAo2QCCzsy4LnU9WGSMunJcmdPvBQLvSeZ4djYJC9JotjTcq7KLDKWrUCaTJWsSUdXOfW+V8lep
	ROUeNb8XmvRN5nAP0Lbn3nynXO11Mdbw8WwB45cN3qLw2up3EXYK18ZqIuhyrPiNSG/LBunbdgu
	fZEwAENfvhQWseJpIyhEs5pKJQytWUxuf4SYnpyqoQm2S0ijKULaTnTw0LuftWIlmWhP9uFWmfD
	v8kaLjAVrG39xRcvo20qj2IqxZT+ygympf/YFOg/QHiB1okVqaHGQ5ju5UJMBmvgYShWUYXkN4s
	hF009JcNADUSoBZGQhNG34FTteLlvmZkE7ZBJ8CmxsAebx2OwOZMCInpJ8HirpMheQRUK8BCmg/
	c0OnJZjY5A=
X-Received: by 2002:a17:902:ebc6:b0:2dd:c100:7cc8 with SMTP id d9443c01a7336-2e2e4b34ae1mr32499205ad.68.1790830875905;
        Wed, 30 Sep 2026 22:01:15 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e300b21912sm5112085ad.54.2026.09.30.22.01.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 22:01:15 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
X-Google-Original-From: Zhan Xusheng <zhanxusheng@xiaomi.com>
To: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Daniel Gabay <daniel.gabay@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Avraham Stern <avraham.stern@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Richard Cochran <richardcochran@gmail.com>,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhan Xusheng <zhanxusheng@xiaomi.com>
Subject: [PATCH v2 1/2] wifi: iwlwifi: mvm: Fix GP2 to nanoseconds overflow on 32-bit
Date: Thu,  1 Oct 2026 13:01:02 +0800
Message-ID: <20261001050103.860584-2-zhanxusheng@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261001050103.860584-1-zhanxusheng@xiaomi.com>
References: <20261001050103.860584-1-zhanxusheng@xiaomi.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

scale_update_gp2 and gp2_on_air_rise are u32 GP2 timestamps in
microseconds.  NSEC_PER_USEC is 1000L, so on 32-bit the products are
computed in 32-bit arithmetic and truncated before being widened:

	u64 last_gp2_ns = mvm->ptp_data.scale_update_gp2 * NSEC_PER_USEC;

A GP2 value above (U32_MAX / 1000) us, i.e. 4.295 s, wraps.  GP2 is a
free-running counter that wraps every 2^32 us, so almost its whole range
is affected and the PTP clock jumps.

The neighbouring conversions in the same files already cast:

	gp2_ns = iwl_mvm_ptp_get_adj_time(mvm, (u64)gp2 * NSEC_PER_USEC);

Cast the remaining ones the same way.  The i386 build of
iwl_mvm_ptp_get_adj_time() changes from "imul $0x3e8,...,%ecx" to
"mull", i.e. from a 32-bit product to a 32x32->64 one.

mvm/ptp.c:219 is already u64 and needs no change.

Fixes: a2f49f7d52a9 ("wifi: iwlwifi: mvm: implement PHC clock adjustments")
Fixes: 0e49e940d1bc ("wifi: iwlwifi: mvm: add an option to use ptp clock for rx timestamp")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ptp.c  | 4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

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
index c01c704929ba..e9146c38a81c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -2021,7 +2021,9 @@ static void iwl_mvm_rx_fill_status(struct iwl_mvm *mvm,
 
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

