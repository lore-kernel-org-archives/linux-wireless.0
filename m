Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CD8379C47
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 22:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788560776; cv=none; b=JLuym1Cs610+WhzAQBADcEXYApfZ4MWbvJDhMySduzcVpGft/sD39KjGaxrw+Jf6geT0sHAwDIWa/Xx80PCZvNsKGySk9tvpu6zg6pCPjlmC3ws6jed0QglKdyt6Wk3jOsrt7XwLVkDOS4pzHNaIU6zRV8XDdMz/Ybt5LrT0qEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788560776; c=relaxed/simple;
	bh=QXDjziV5jsAxFD0i2Nz836vwk9NS4JhR6oQGqwf4nK0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UjVGv7p/aTzfqzdmIPT1af8GI0yGQ6Nuzl3mgiv0ICxZA/V2jjURpvnzoSXew0Lq14XsE9W7zIaJ/Q+5ct/CpcbmnkXMKlGimXJVKfiF+0ZdupC6biQzvrX8+4tb3IjzTexjkkBi2oiaDZIQolvAAOeSgBJOPSfamB2nfJvdqlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N4X7V0Ft; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N4X7V0Ft"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5b15dcaca31so1481540e87.0
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2026 15:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788560772; x=1789165572; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6crAb0tNhcnqWfdHiB+qm3RL/vD3R/3sYirXmsIa7Kg=;
        b=N4X7V0FtLGtanNAV32ss4IxCrUEK3liVUYamjXxR3eDO+yIQ/Wj42p4+67p0YM0AF4
         bYRvRfyq6/iBuejxecE25S4j0SpDQLhM37RmqClWERA4U3Cs04lades9CTMwDizh8OH7
         ZYggfIuUX3aZQbMh+/6HWzSPRxPJfxPtpzrzYkxqnWfDL/97oK4W2VWbGzpb2HBbLfNQ
         bGBCYYpqEfsS2+JYcr25jWbli+Ii6L5tBeqNzw/HoUyFhsC6iC9DmPG8VsdWG8ptasOU
         Wso2yVIeUFoM5fRYPfYd+NnBSvxBCVy7D9IkQASgRtuJMyoJ8OsN+Ck5l8CthqPqLVt/
         sEpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788560772; x=1789165572;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6crAb0tNhcnqWfdHiB+qm3RL/vD3R/3sYirXmsIa7Kg=;
        b=gKIcn5+MmOwPkTiqlnFUBdzzwTeRBalwTKOjsZ5dUNg2N4/fWvdB9/aN7m7NBqh/yU
         ntQzSosIhRZRohb+UghOzKIBorAw1mSMdvO42NFv6ee/Mkm58muxH0hq9P+ago4BJICi
         dvQQ44StMbueVom0Yf4EiZYCpdUJThGqNcX3DgHFFXkh3vnvbl+f64YbHybfdH4ejUVp
         YlfmPy1yZwjHFvsPW5qEcesp7jx+EyXSRLDhPym1oCYAIHtK4LHdIdBqlIU3i29OwJOQ
         ht3ExYmeZ9TDq+nPrYqamn8FjxdxzkiRJQ+wNovYKjaWUwwv9ckuScAtm9IupmwiVYRq
         xZDA==
X-Gm-Message-State: AFuF++k2qsb2YGtMfV8iViy9t5OF6THufH7EUhnu31TQPRgc2exG5zFf
	Rzc3BC4+CcI4qyrZfM5Zyy5pdQUfAEvv3KhmzEIGwVCYGB3WyHGw1HCCjO9IcptbuUmOq1an
X-Gm-Gg: AYBFou0mVCbiWNlh0b0V3Fb5/xS2Gy9UQchcuQTPNzqg1qOqO5GsLnevDfzxEx0fh0J
	FPTxt8bFZA+mWOQ+a2VFP1oJbUQOQQABM8t0TlEphYEjM00SLeH+IH6M78KBoXiZuE6sTEJFZdw
	CDRMmHIDMXvjQhSv7kysTks+pFc+5C01D9syNnreRoODhSQUUek5VFo+Z0nsIG1XsmwnJuqz0Sg
	xaa9maFQXy+9TDLfgPFzwzSKOoudS4413B239VGPo/Vfr8QlavC7rHpryo/KiX+ghDETgo3+Kmy
	n9/EexwDjW2o/Zup4tQ23CsVSw7lbVmfJpCQjZWixSpfeMvasgF9ZE5v587Q3p5Hn65JaHH61qW
	l59UA6MZ86RedB6Y9Xzyp4ZbixRcvjRf5IfSOlGGKwq+wV3OFnUdAd/VFSJvxKZm5CSrWYZfMLh
	FI9/r+OTyFcW9u/BUivMllXfZHU9z8V+N/K4hBLIVRaOLsQ6iY5swLeHIv7luVwBy98fD/XEoaw
	POc
X-Received: by 2002:a05:6512:3d07:b0:5b1:58d6:4542 with SMTP id 2adb3069b0e04-5b616eec9fdmr2723564e87.14.1788560771955;
        Fri, 04 Sep 2026 15:26:11 -0700 (PDT)
Received: from localhost.localdomain ([80.66.93.26])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b61669b199sm767505e87.2.2026.09.04.15.26.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 15:26:11 -0700 (PDT)
From: Maxim Skokov <skokovmaksimevg@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Maxim Skokov <skokovmaksimevg@gmail.com>
Subject: [PATCH] wifi: rtw89: fix typos in comments, debug messages and struct field
Date: Sat,  5 Sep 2026 01:25:33 +0300
Message-ID: <20260904222548.19732-1-skokovmaksimevg@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Correct several misspellings found by codespell:

  moniter   -> monitor     (struct rtw89_btc_wl_role_info_bpos field)
  serach    -> search      (comment)
  Unsupport -> Unsupported (error message)
  nofity    -> notify      (comment)
  updat     -> update      (debug message)
  lagacy    -> legacy      (comment)

The renamed struct field has no users, so no further changes are
needed. No functional changes.

Signed-off-by: Maxim Skokov <skokovmaksimevg@gmail.com>
---

Notes:
    Found with codespell. Patch prepared with AI assistance; all changes reviewed by me.

 drivers/net/wireless/realtek/rtw89/core.h | 4 ++--
 drivers/net/wireless/realtek/rtw89/fw.c   | 4 ++--
 drivers/net/wireless/realtek/rtw89/phy.c  | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 2b21d969e..814f3b94c 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -1904,7 +1904,7 @@ struct rtw89_btc_wl_role_info_bpos {
 	u16 adhoc: 1;
 	u16 adhoc_master: 1;
 	u16 mesh: 1;
-	u16 moniter: 1;
+	u16 monitor: 1;
 	u16 p2p_device: 1;
 	u16 p2p_gc: 1;
 	u16 p2p_go: 1;
@@ -3925,7 +3925,7 @@ struct rtw89_btc_fddr_cell {
 struct rtw89_btc_fddr_result {
 	u8 wl_rx_limit;
 	u8 wl_rx_limit_step[6]; /* record search process */
-	u8 search_cnt; /* the rx-limit serach count */
+	u8 search_cnt; /* the rx-limit search count */
 	u32 wl_tp;
 	u32 wl_tp_step[6]; /* record search process */
 };
diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 0099c5c03..ecedfd6f6 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -306,7 +306,7 @@ static int __parse_formatted_mssc(struct rtw89_dev *rtwdev,
 		if (mss_hdr->defen)
 			rmp_tbl_size += FWDL_MSS_POOL_DEFKEYSETS_SIZE;
 	} else {
-		rtw89_err(rtwdev, "[ERR] MSS Key Pool Remap Table Format Unsupport:%X\n",
+		rtw89_err(rtwdev, "[ERR] MSS Key Pool Remap Table Format Unsupported:%X\n",
 			  mss_hdr->rmpfmt);
 		return -EINVAL;
 	}
@@ -11214,7 +11214,7 @@ int rtw89_fw_h2c_wow_request_aoac(struct rtw89_dev *rtwdev)
 
 	skb_put(skb, len);
 
-	/* This H2C only nofity firmware to generate AOAC report C2H,
+	/* This H2C only notify firmware to generate AOAC report C2H,
 	 * no need any parameter.
 	 */
 	rtw89_h2c_pkt_set_hdr(rtwdev, skb, FWCMD_TYPE_H2C,
diff --git a/drivers/net/wireless/realtek/rtw89/phy.c b/drivers/net/wireless/realtek/rtw89/phy.c
index c78107e92..43b3552f5 100644
--- a/drivers/net/wireless/realtek/rtw89/phy.c
+++ b/drivers/net/wireless/realtek/rtw89/phy.c
@@ -525,7 +525,7 @@ void rtw89_phy_ra_update_sta_link(struct rtw89_dev *rtwdev,
 		ra->upd_bw_nss_mask = 1;
 
 	rtw89_debug(rtwdev, RTW89_DBG_RA,
-		    "ra updat: macid = %d, bw = %d, nss = %d, gi = %d %d",
+		    "ra update: macid = %d, bw = %d, nss = %d, gi = %d %d",
 		    ra->macid,
 		    ra->bw_cap,
 		    ra->ss_num,
@@ -659,7 +659,7 @@ void __rtw89_phy_rate_pattern_vif(struct rtw89_dev *rtwdev,
 					  0, true))
 			goto out;
 
-	/* lagacy cannot be empty for nl80211_parse_tx_bitrate_mask, and
+	/* legacy cannot be empty for nl80211_parse_tx_bitrate_mask, and
 	 * require at least one basic rate for ieee80211_set_bitrate_mask,
 	 * so the decision just depends on if all bitrates are set or not.
 	 */
-- 
2.47.3

