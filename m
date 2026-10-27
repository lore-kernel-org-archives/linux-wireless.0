Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793087751;
	b=luV6KOSO0iRAqkw53xQ/b/ARRwlbdZph5vwlXR6+rR/Rk9MnbVkrC6Tp1qEi+gkeVx0M
	 BnobnnICOm6WXtHZZHt9bdP2TZ7zpi8fj52OaFhK9/qW47XnpWvHAmSkxNnCyeKPmqd7l
	 YGxI21Uo73ZU/JYrNDhTx7i4RjWHugCTkl4PfbdhFTJnPqhtxBxoNjzd/O4dS6vtyxIrj
	 vVWYTvD2KVOWYCaRelByd0RF272G9fnonfnT2K5BQQyjJ+755Jzv6VkauZBVZbAF4xIg/
	 eBrKdA9BS/Riktwa74Fcim5UTvsduPoFn2RFdARmzSGZEkFvFukfpP7J07pbXGeCWsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793087751;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i1SNxIXweOOqIgbJIjQEMXKXOyJJ3/czuTf5ENSChcw=;
	b=3XWJpHtTsgsLk80HIlp9qA9DKMJCakA2xUD7HIKBBvHGtkizLWqiIVmnGGGCnnrFzbfa
	 JdxvrsHxYekGDStjlScB+QWO+nvHdHpFgaGP22bSMBn8FtGkvPjLAR6Sk2KUx6+67Ht4f
	 Fk5nhp1caIs0goDBvtRIfY2zJrAX4XQFOgoJNKLAhbm7ttqbsGsuG9k1XubuwurVEf6+T
	 Bfdp3k/wxmI5PdJMRJdjOgb2RyyNgXu8idNqZpA0BTcItqrFo9aDZWda2j1k8CK5GY8HY
	 KAmanh7EAKaMI4mbEOJZ5FVk19nnF34Cz+w2Kw36Bwv41N69PtGnZHpB/dB08DDr6Hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bairaktaris.de;
	spf=pass smtp.mailfrom=bairaktaris.de;
	dkim=pass header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=pSY2Q3T6;
	arc=none smtp.remote-ip=209.85.208.43
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9B160A2603
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 07:55:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7B9B160A2603
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=pSY2Q3T6
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b488586facso87490a12.2
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 00:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1793087750; x=1793692550; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i1SNxIXweOOqIgbJIjQEMXKXOyJJ3/czuTf5ENSChcw=;
        b=pSY2Q3T6FDl7dyuG7HgMVjOEE9WHeZ3ynaBIN4Vf1SwMPKIic8k6M/D3ow/y/kWS3m
         s+CHiIXBPPEqBePTH6n8I0+qs9Hz9Dxx9O3xjUvv9T53x1OnEDWr9aCFgWGR6ICZ1TkO
         wLFhkHyOU4Fkwud/SudssFYiMZey6Q2wHigv5nGLIcOOL62kE3+iQHFnzoWAXOMLWpNV
         wyVqEMid2eM1qSmU/5/33ek2E6yWBM6vYjNxTdHmhTM9ukpXKWEJnZDhPBm+NMkxoMJ7
         iXZMYifle4Kf5Rg4tjP0fYfaQHPO0Tky8sH5sdQS8bl+ktw3Fz6bFtKK0y32XWCqByxq
         c3sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793087750; x=1793692550;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=i1SNxIXweOOqIgbJIjQEMXKXOyJJ3/czuTf5ENSChcw=;
        b=OXOFtDLf7Kw25qRoVgloFkmuMVeUB2SNL89JSm4/2cMuDg3rawgWnra8YZuithaTCe
         xy5qNf2tJ16DuNmkAqPo0XFEvrnAoPpq0HMEwf50QCaEoe4pgMX5ti4xgIN/AJwiURKQ
         r1KHUo64HbQf8rp8lM9Cjkq3+PG7a0smHKQuiRbEMEnvgzC9twXtb9Hix/KzgCSMYxzC
         DYibmQFJKbbSFWGqb3aNQ7ahZs/deMRYoB4Lt+B4COciWMMri1FxQDVVXL20Pg5HWEx3
         WUwwhMh5lWNW2kur+hC6o4HxxtXvB0TMAIzSpf9mPcf4Tc3+14PeB7vRZjSXRMwuclVm
         eBvA==
X-Forwarded-Encrypted: i=1; AKwUvBxp6h7oz0vdik4xOSbiwRP0bwFKFV5mW9sIjQnNPtpHljzAgfJJLPpiBooEBdkJI+le7l4RVdK8PapFtcSTpw==@vger.kernel.org
X-Gm-Message-State: AFq9FYKDFjt1E431IgB9eKBmuNngPalOMechxIvQW2jbvr2v3mHL4+JP
	ISLKHYMwl/lusMs+YfpfREJeODO8BmydAjjk9YVB8XHVbGH213jQXOZzQ4wX/TV1Xw==
X-Gm-Gg: AYBFou2j1aK0jpXIfBWxGSGaG//sy0I3ZDWouh9QMAmv2iKY58xdWLTF0NSO8v3ZLfE
	OhV258ok0spunHsULRs0eRem3G8Xafhms71NKNRlwXtBgcxfz32ho36c5ZXEjc7tIyN9J1EY2lG
	oY2yOLAgBO71+ZYK4lPyQg3o+O2Vo5PvTun9ue95lx29ErSFiMhnasDLXXoblWG3jiBTxJD4qA3
	xjr4RGCSFmSVPS9DIGbopkgNhA86a6IgPEjO96hsM4+XT35tNJXWvXmW7njCaxqiDHwzpojq0XB
	AENJXhEFSaXoILX/5gUdl6DsEYg6kis9ShG7PodI4SSCxXDF+x9N71x2WGUvQOJJ2jBkcl+60BW
	YnijEa2SJ7vPknhC6BGNi2g8BGKSaMGl4Dcfi7FvjxSWIQ4daFCOgMKmmggxT0VAbkfTIcoGgwe
	T/6i0oYkOUqFZFYhA/r7VidnT2rO/T3CKDXSKzKbbG8iSFL7TFN/iBCMpVOMleMXxxiOs/+53nc
	d0Rgpv2r/jrKY9g0MgNG5du0ZO1DD8Qtf4CgpcwfpPcZWNKtmi5ZQ8DfMBXIfGhz2Z9H52AETNK
	Di3SD1M74H28vNXh1/NtnxgH0k1aKn3z3l1t9f5KFkJZW80I55Hf0fN1eBx1WHNj/5wBGx4q9Gi
	dWAnrKP10iSmSA2AbITQtKR4uQgKdbkGOUiLu5b399Kl9VXjvzZogY+FuN017cxxRacR7v7Jllp
	8RAaSqCDDG516yE5Q/sAXTDrnpt6GnEQKzITANPUKbkEPJrkulcYL5KF52MV2N9744cSJ91u0hn
	2Fyfbpq
X-Received: by 2002:a05:6402:c18a:b0:6b1:c774:58c4 with SMTP id 4fb4d7f45d1cf-6b442fe1896mr5512109a12.7.1793087749785;
        Tue, 27 Oct 2026 00:55:49 -0700 (PDT)
Received: from Desktop (pd9513dae.dip0.t-ipconnect.de. [217.81.61.174])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b445971a9esm4669251a12.19.2026.10.27.00.55.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 00:55:48 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: ath11k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Semih Baskan <strst.gs@gmail.com>
Subject: [PATCH ath-next 3/3] wifi: ath11k: add a module parameter to select the hardware mode
Date: Tue, 27 Oct 2026 08:55:44 +0100
Message-ID: <20261027075544.19144-4-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261027075544.19144-1-julius@bairaktaris.de>
References: <20261027075544.19144-1-julius@bairaktaris.de>
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

ath11k always uses the highest priority hardware mode the firmware
advertises. On the Zyxel NBG7815 that is DBS+SBS, which splits the
eight 5 GHz chains between two radios, neither with a 160 MHz channel
width. The firmware also advertises DBS, which gives one 5 GHz radio
with all eight chains and 160 MHz. Add a hw_mode parameter that selects
any mode the firmware advertises; for a mode it does not advertise, warn
with the modes it does advertise and keep the default.

On the NBG7815, hw_mode=1 brings up the 8-chain 5 GHz radio. iperf3
from the router to a 2x2 HE client with 4 streams gave 1.22 and
1.20 Gbit/s at 160 MHz (two 20 s runs), against 886 Mbit/s at 80 MHz
with the unpatched driver (one run).

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Tested-by: Semih Baskan <strst.gs@gmail.com>
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/core.c |  6 ++++++
 drivers/net/wireless/ath/ath11k/core.h |  1 +
 drivers/net/wireless/ath/ath11k/wmi.c  | 17 +++++++++++++++--
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index 766ae27306f43..e1a6085a065a6 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -38,6 +38,12 @@ bool ath11k_ftm_mode;
 module_param_named(ftm_mode, ath11k_ftm_mode, bool, 0444);
 MODULE_PARM_DESC(ftm_mode, "Boots up in factory test mode");
 
+/* hw mode values are mapped as per enum wmi_host_hw_mode_config_type */
+unsigned int ath11k_hw_mode = WMI_HOST_HW_MODE_MAX;
+module_param_named(hw_mode, ath11k_hw_mode, uint, 0444);
+MODULE_PARM_DESC(hw_mode,
+		 "Hardware mode (0: single, 1: DBS, 2: SBS passive, 3: SBS, 4: DBS+SBS, 5: DBS or SBS, default: preferred mode the firmware supports)");
+
 static const struct ath11k_hw_params ath11k_hw_params[] = {
 	{
 		.hw_rev = ATH11K_HW_IPQ8074,
diff --git a/drivers/net/wireless/ath/ath11k/core.h b/drivers/net/wireless/ath/ath11k/core.h
index a0d725923ef24..0d81212770019 100644
--- a/drivers/net/wireless/ath/ath11k/core.h
+++ b/drivers/net/wireless/ath/ath11k/core.h
@@ -59,6 +59,7 @@
 #define ATH11K_SMBIOS_BDF_EXT_MAGIC "BDF_"
 
 extern unsigned int ath11k_frame_mode;
+extern unsigned int ath11k_hw_mode;
 extern bool ath11k_ftm_mode;
 
 #define ATH11K_SCAN_TIMEOUT_HZ (20 * HZ)
diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index b3c778eb15876..615a8fc0b9937 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -4760,9 +4760,9 @@ static int ath11k_wmi_tlv_hw_mode_caps(struct ath11k_base *soc,
 				       u16 len, const void *ptr, void *data)
 {
 	struct wmi_tlv_svc_rdy_ext_parse *svc_rdy_ext = data;
-	struct wmi_hw_mode_capabilities *hw_mode_caps;
+	struct wmi_hw_mode_capabilities *hw_mode_caps, *requested = NULL;
 	enum wmi_host_hw_mode_config_type mode, pref;
-	u32 i;
+	u32 i, modes = 0;
 	int ret;
 
 	svc_rdy_ext->n_hw_mode_caps = 0;
@@ -4783,6 +4783,10 @@ static int ath11k_wmi_tlv_hw_mode_caps(struct ath11k_base *soc,
 		if (mode >= WMI_HOST_HW_MODE_MAX)
 			continue;
 
+		modes |= BIT(mode);
+		if (mode == ath11k_hw_mode)
+			requested = hw_mode_caps;
+
 		pref = soc->wmi_ab.preferred_hw_mode;
 
 		if (ath11k_hw_mode_pri_map[mode] < ath11k_hw_mode_pri_map[pref]) {
@@ -4791,6 +4795,15 @@ static int ath11k_wmi_tlv_hw_mode_caps(struct ath11k_base *soc,
 		}
 	}
 
+	if (requested) {
+		svc_rdy_ext->pref_hw_mode_caps = *requested;
+		soc->wmi_ab.preferred_hw_mode = ath11k_hw_mode;
+	} else if (ath11k_hw_mode != WMI_HOST_HW_MODE_MAX) {
+		ath11k_warn(soc, "hw mode %u not supported (modes 0x%x), using %d\n",
+			    ath11k_hw_mode, modes,
+			    soc->wmi_ab.preferred_hw_mode);
+	}
+
 	ath11k_dbg(soc, ATH11K_DBG_WMI, "preferred_hw_mode:%d\n",
 		   soc->wmi_ab.preferred_hw_mode);
 	if (soc->wmi_ab.preferred_hw_mode == WMI_HOST_HW_MODE_MAX)
-- 
2.53.0

