Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12453DAACF
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 05:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791349225; cv=none; b=c4P8n8s7jBAXGOxYFE7O/5G2ZBJcCcNkqCSHBvW2KC024ZidAn52c/aA45ox4/mKECGjoN4novROa1dAkR5G+9UsLplXnQl/6WcZ2rf46AALtT40J6L0kymUdZv8WUqCNC0Lp7Cb25Rum9U/x0P5mFj7fFNnXH1SAf7CiXkG7/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791349225; c=relaxed/simple;
	bh=P2uQS3QwzSVtKRdIDPyCnmzQflAxFOpevMZy13R3TF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6IkSaI+qZCH481VYUixU2jdCUGskzTuwvdTGQEnPqL8HCEdWNt6uvs2Rb/uT/AEPKWEkWIWLHvZND/3raSPIPh7tUYIEMO0h/pmAhGroVaWYCKnF3/1ulPno7wy92vHRXPbf7jt3Lc/bfTn+RG2PXz1REoNzbdTX6AceIX93xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=By1GAEhy; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="By1GAEhy"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-38e42560ebcso2127113a91.1
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2026 22:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1791349216; x=1791954016; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Qhxh8hWE4CgegN4rbGctmYtTKYKzbJEsAx4VAjhKh18=;
        b=By1GAEhyWVc5CI1Bi2JSy7yJGyO4HjKYfqt06o6rwzOACyRSnYtTleh0tGirCsp+gY
         rzj5MSpZU0xlkrtIt+5lDy2n0V2RhTXxS17jHUBYpqJ5SL8ymS5igLo5lWy1Drm1rZxR
         WM9ueH6+uebdiNYmgj4wDhTKqjD+RHH/Y6Fsm0ZzPjHkVcY9mLXlDdbeofu/TjRzfC4F
         /Sgwsj81oWyCvCQtHxbMIGEYO27ckKt4j+NkhsStHOW00rgR3Y4gGHGaj8SR6NHwdrni
         XyrYQhJGuvhsjujpwFDaeR8Ow/zeffkD8iDTVMKbnv6FRcSeVwN1EJpDEV9+x0d/RV2o
         abyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791349216; x=1791954016;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Qhxh8hWE4CgegN4rbGctmYtTKYKzbJEsAx4VAjhKh18=;
        b=FElj7HXFlfaNXu0/XoWa4Zy3WAa2d+eOr0QvcR+cBgBvuFNfp8QWVEBqVZ8D7EImDy
         IqfDD64edAYH99BNjMdByDoTKWx+gRUu/SSYkMofAD69OoL1QctErdC7Q3mVS8ritGsG
         +8iD/AGvbZuaEMVjjRiGGCPNikxwGuNEqQSRgyO+tuvs/+qUJkD2OAuG9SG3kyy4d5ik
         k2yiVS+y+LfgBSvXu69+TNPKrQLjPU0wN9F3CO/pyYN+BYslzSN05J53tt2BpzoCnc8b
         WyWYSnjbw4ORHnkd0q2p0pIX2No3aEnsGONJIJiYnd0e6hSQ4DtVQG8pIaYy9Lb9pedq
         5+Mg==
X-Forwarded-Encrypted: i=1; AKwUvBwvMD2FV/xHuhR6OG1OLVnSK0NFN8cLWapzB7T0h6tbb1aMCuhHSMdapxX21T0RebEPum0UAg9019dbdUQ43w==@vger.kernel.org
X-Gm-Message-State: AFq9FYIizuoV6ZbxCgTz360uPwU7ob9Jd/ubIGbUn2TcPsESuNVviHK7
	L6YqviDzGkik9oq5EhMMAWDYPkvWJZGQoVmBP9BXcbHDS1hUt49sMb2AuVGZGyPdlzJeVpTIP7J
	fqOtm9HU=
X-Gm-Gg: AYBFou0Zhe+5cugK1ycEafWmA9fNkLFYF7ja6K5Z2vUpRXWiGBPCPmahlKgRdS47sAq
	2Bk4qAhRdQ5Ac0+RpF8ogA5CxPWiut8ztrh9JwTlZa2M1Wcj9WiBgdTeXgls+inD9FYDcPTXeqk
	kSK6dL0h1oe2ArI3Gw/+NlJj+20N/LHQp6tsi0JjIjRf8XLTVTuZdFlsaFlRrAmZBOiBFpM8LbV
	lkhxqynqG9+sDO/rfGge2bn2PUfwGgdHeowQU72i3mBKyvbQOmklmpDrIxBeJ3dEQP89WdOFKRS
	ALMndo6yDmPFgVoug9JV5X6QnGyequioESWYz/KEOdCfbtKCm9ZxBa1vzeqAGEWU4b74wDv/NlX
	nH2mJKKXAAV5TjR33ZuHBTcRRKkVaCjLtTCmS3AbQ4uq5rvWxrUJYZGGDDS0lupcoscxN9ncSU5
	7uZTVeQuXu+pmPGGUjlSmvdcMOICVxOx/uKu5BHlMlzh1LA4k7qu4Z82CPa9g+dMoRR9hADWMS/
	hE7Dief/w4+NVnKpq78hd5d80U2bYCY/6mXF8QTsx8kwuYhC/t/ReAwB8T0v9KxFCp83yp+flYi
	iMrs2pc0zIK1WkNt
X-Received: by 2002:a17:90b:4b07:b0:3a8:1d47:7a99 with SMTP id 98e67ed59e1d1-3a8a1c9ca69mr976990a91.38.1791349215875;
        Tue, 06 Oct 2026 22:00:15 -0700 (PDT)
Received: from mma-H9MHD44.sydney.mm.lcl (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8a4b1abbfsm696011a91.4.2026.10.06.22.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 22:00:15 -0700 (PDT)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: lachlan.hodges@morsemicro.com,
	dan.callaghan@morsemicro.com
Cc: arien.judge@morsemicro.com,
	linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next 3/3] wifi: mm81x: copy new sband for each module
Date: Wed,  7 Oct 2026 16:00:00 +1100
Message-ID: <20261007050000.127009-4-lachlan.hodges@morsemicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261007050000.127009-1-lachlan.hodges@morsemicro.com>
References: <20261007050000.127009-1-lachlan.hodges@morsemicro.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

the sband information existed as a single static struct and was
directly modified in place by both the stack and the driver. If the
regdom was ever changed to 00 where all the S1G channels are NO_IR
and a bus module then removed, these flags would remain even after
changing the regdom and prevent channels from being used.

Instead, make sure we copy the sband each time we init our mac80211
hw such that when a bus module is removed the state is reset and
flags don't persist.

Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
---
 drivers/net/wireless/morsemicro/mm81x/mac.c | 45 ++++++++++++++++-----
 1 file changed, 36 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/mac.c b/drivers/net/wireless/morsemicro/mm81x/mac.c
index 2f1e03c9312b..e9e87dccacdb 100644
--- a/drivers/net/wireless/morsemicro/mm81x/mac.c
+++ b/drivers/net/wireless/morsemicro/mm81x/mac.c
@@ -84,7 +84,7 @@
 	.max_power = 30,					\
 }
 
-static struct ieee80211_channel mors_s1ghz_channels[] = {
+static const struct ieee80211_channel mors_s1ghz_channels[] = {
 	CHANS1G(1, 902, 500, IEEE80211_CHAN_S1G_NO_PRIMARY),
 	CHANS1G(3, 903, 500, 0),
 	CHANS1G(5, 904, 500, 0),
@@ -115,11 +115,9 @@ static struct ieee80211_channel mors_s1ghz_channels[] = {
 
 /* clang-format on */
 
-static struct ieee80211_supported_band mors_band_s1ghz = {
+static const struct ieee80211_supported_band mors_band_s1ghz = {
 	.band = NL80211_BAND_S1GHZ,
 	.s1g_cap.s1g = true,
-	.channels = mors_s1ghz_channels,
-	.n_channels = ARRAY_SIZE(mors_s1ghz_channels),
 	.bitrates = NULL,
 	.n_bitrates = 0,
 	.s1g_cap.cap[4] = 0x80 /* STA type sensor only for AP & STA */
@@ -269,8 +267,10 @@ static void mm81x_mac_check_fw_disabled_chans(struct ieee80211_hw *hw)
 	u32 i;
 	struct mm81x *mors = hw->priv;
 	struct host_cmd_resp_get_disabled_channels *resp;
+	struct ieee80211_supported_band *sband =
+		hw->wiphy->bands[NL80211_BAND_S1GHZ];
 	u32 resp_len = sizeof(struct host_cmd_disabled_channel_entry) *
-			       ARRAY_SIZE(mors_s1ghz_channels) +
+			       sband->n_channels +
 		       sizeof(*resp);
 
 	resp = kzalloc(resp_len, GFP_KERNEL);
@@ -283,8 +283,8 @@ static void mm81x_mac_check_fw_disabled_chans(struct ieee80211_hw *hw)
 	if (ret)
 		goto out;
 
-	for (i = 0; i < ARRAY_SIZE(mors_s1ghz_channels); i++) {
-		struct ieee80211_channel *ch = &mors_s1ghz_channels[i];
+	for (i = 0; i < sband->n_channels; i++) {
+		struct ieee80211_channel *ch = &sband->channels[i];
 
 		if (ch->flags & IEEE80211_CHAN_DISABLED)
 			continue;
@@ -337,7 +337,8 @@ static int mm81x_tx_h_get_max_tx_bw(struct mm81x *mors)
 static void mm81x_mac_caps_init(struct mm81x *mors)
 {
 	struct mm81x_fw_caps *fw_caps = &mors->fw_caps;
-	struct ieee80211_sta_s1g_cap *s1g = &mors_band_s1ghz.s1g_cap;
+	struct ieee80211_sta_s1g_cap *s1g =
+		&mors->hw->wiphy->bands[NL80211_BAND_S1GHZ]->s1g_cap;
 
 #define __FW_CAP_N(_n, _cap, _bit)                \
 	do {                                      \
@@ -2470,7 +2471,6 @@ static void mm81x_mac_config_hw(struct mm81x *mors)
 	for (i = 0; i < NUM_NL80211_BANDS; i++)
 		hw->wiphy->bands[i] = NULL;
 
-	hw->wiphy->bands[NL80211_BAND_S1GHZ] = &mors_band_s1ghz;
 	hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_AP) |
 				     BIT(NL80211_IFTYPE_STATION);
 	hw->wiphy->reg_notifier = mm81x_reg_notifier;
@@ -2548,6 +2548,28 @@ static void mm81x_mac_stale_tx_status_timer_init(struct mm81x *mors)
 	timer_setup(&mors->stale_status.timer, mm81x_stale_tx_status_timer, 0);
 }
 
+static int mm81x_mac_set_sband(struct mm81x *mors)
+{
+	struct ieee80211_supported_band *sband;
+
+	sband = devm_kmemdup(mors->dev, &mors_band_s1ghz, sizeof(*sband),
+			     GFP_KERNEL);
+	if (!sband)
+		return -ENOMEM;
+
+	sband->channels = devm_kmemdup_array(mors->dev, mors_s1ghz_channels,
+					     ARRAY_SIZE(mors_s1ghz_channels),
+					     sizeof(*mors_s1ghz_channels),
+					     GFP_KERNEL);
+	if (!sband->channels)
+		return -ENOMEM;
+
+	sband->n_channels = ARRAY_SIZE(mors_s1ghz_channels);
+	mors->hw->wiphy->bands[NL80211_BAND_S1GHZ] = sband;
+
+	return 0;
+}
+
 int mm81x_mac_register(struct mm81x *mors)
 {
 	int ret;
@@ -2562,6 +2584,11 @@ int mm81x_mac_register(struct mm81x *mors)
 		return ret;
 
 	mm81x_mac_config_hw(mors);
+
+	ret = mm81x_mac_set_sband(mors);
+	if (ret)
+		return ret;
+
 	mm81x_mac_hw_scan_init(mors);
 	mm81x_mac_stale_tx_status_timer_init(mors);
 
-- 
2.43.0

