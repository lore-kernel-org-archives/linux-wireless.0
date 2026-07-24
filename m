Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E0144C668
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 18:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784917158; cv=none; b=PcfjD+cR0yZhEfe2tYFBjc0P3dEp2CrNsmE5CitVz7zziCQQ7miB+XvXcJLaVi+GDvID5AvBa1ur6gVryfz1UqUTkgOKR4EnwM9THmOZ6Bu+S47okaDCv2lGiytDaVDZoG+7DdMBH5H+4p+2egK1MLA3j1u+H91QuWUECSoOb7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784917158; c=relaxed/simple;
	bh=RPAS19BQn6D2jKN9oF7RWZNltLAppNcCJvzKAY4SUFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sTSgR+ZliznxCVIbcTwz+jNO0zvxAyyCykFkiPxrgY7UlUK09QDB3RyVu83Q+68ggQfd1N3UnqEJ2jlvV8KqhjCkxuwI39OCSnl9YUKFtJlZru6fqnMRPmfD5P58GB3DHvFQRcsIJIW036oGRorDOREWAbWqmc46kx/Vo6g1esk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Zx1diqCQ; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Zx1diqCQ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784917154;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JAgfrB4EbWKayPt0Ak39z1eosxfFVKGvm8umgw8g0nQ=;
	b=Zx1diqCQMV0Me9g7+8PQrI5dz6eE9iz+zrJ56OgO4V2wnVLAVKeJWYHOOHSmOkVEZJGP25
	aGrXissS9p/f8yYN5yE6p7X3r8Y2J3wf9q0wuiOxQ2MCwvyMpT9bdorYMZan/ny2O++beU
	7tXSVmq1KX9FoR//3h/l9sgV8YOtDCU=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH 05/19] wifi: rtw88: fw: send rate adaptation and RSSI info in the vendor layout
Date: Fri, 24 Jul 2026 20:18:44 +0200
Message-ID: <20260724181858.192903-6-luka.gejak@linux.dev>
In-Reply-To: <20260724181858.192903-1-luka.gejak@linux.dev>
References: <20260724181858.192903-1-luka.gejak@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

The v41 firmware shipped with the RTL8723BS parses the vendor v5.2.17
MACID_CFG and RA_INFO byte layouts rather than the bit packed rtw88
ones, so the existing commands are misinterpreted and rate adaptation
never settles.

Emit the byte layout the firmware expects for this chip. The no_update
bit needs care: setting it tells the firmware to keep the rate mask it
already has, so a changed mask sent with no_update set is silently
dropped. Track the last mask sent and clear no_update whenever it
actually changes, while leaving it set for identical refreshes so the
firmware keeps the rate it has learned.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 drivers/net/wireless/realtek/rtw88/fw.c   | 47 +++++++++++++++++++++--
 drivers/net/wireless/realtek/rtw88/main.h |  2 +
 2 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index a81ff15218e1..495d26eafdd4 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -744,9 +744,19 @@ void rtw_fw_send_rssi_info(struct rtw_dev *rtwdev, struct rtw_sta_info *si)
 
 	SET_H2C_CMD_ID_CLASS(h2c_pkt, H2C_CMD_RSSI_MONITOR);
 
-	SET_RSSI_INFO_MACID(h2c_pkt, si->mac_id);
-	SET_RSSI_INFO_RSSI(h2c_pkt, rssi);
-	SET_RSSI_INFO_STBC(h2c_pkt, stbc_en);
+	if (rtw_is_8723bs(rtwdev)) {
+		/* Vendor v5.2.17 RA_INFO byte layout (H2C 0x42):
+		 * [1] mac_id, [2] 0x00, [3] rssi, [4] stbc?0x04:0x00.
+		 */
+		h2c_pkt[1] = si->mac_id & 0x7f;
+		h2c_pkt[2] = 0x00;
+		h2c_pkt[3] = rssi;
+		h2c_pkt[4] = stbc_en ? 0x04 : 0x00;
+	} else {
+		SET_RSSI_INFO_MACID(h2c_pkt, si->mac_id);
+		SET_RSSI_INFO_RSSI(h2c_pkt, rssi);
+		SET_RSSI_INFO_STBC(h2c_pkt, stbc_en);
+	}
 
 	rtw_fw_send_h2c_command(rtwdev, h2c_pkt);
 }
@@ -760,6 +770,37 @@ void rtw_fw_send_ra_info(struct rtw_dev *rtwdev, struct rtw_sta_info *si,
 
 	SET_H2C_CMD_ID_CLASS(h2c_pkt, H2C_CMD_RA_INFO);
 
+	if (rtw_is_8723bs(rtwdev)) {
+		/* The v41 firmware parses the vendor v5.2.17 MACID_CFG (0x40)
+		 * byte layout, not the bit-packed rtw88 RA_INFO below:
+		 * [1] mac_id, [2] rate_id | sgi_en(bit7),
+		 * [3] bw(bits 1-0) | no_update(bit3), [4..7] 4-byte mask.
+		 *
+		 * no_update(bit3)=1 tells the firmware to keep its existing
+		 * rate mask, so a mask that changes under no_update is dropped.
+		 * Force no_update=0 whenever the mask actually changes so the
+		 * update is applied, and keep no_update=1 for identical
+		 * refreshes so the firmware retains the rate it has learned.
+		 */
+		bool apply = reset_ra_mask || si->ra_mask != si->ra_mask_last;
+
+		h2c_pkt[1] = si->mac_id & 0x7f;
+		h2c_pkt[2] = (si->rate_id & 0x1f) |
+			     (si->sgi_enable ? BIT(7) : 0);
+		h2c_pkt[3] = ((si->bw_mode ? 3 : 1) & 0x3) |
+			     (apply ? 0 : BIT(3));
+		h2c_pkt[4] = si->ra_mask & 0xff;
+		h2c_pkt[5] = (si->ra_mask >> 8) & 0xff;
+		h2c_pkt[6] = (si->ra_mask >> 16) & 0xff;
+		h2c_pkt[7] = (si->ra_mask >> 24) & 0xff;
+
+		si->ra_mask_last = si->ra_mask;
+		si->init_ra_lv = 0;
+
+		rtw_fw_send_h2c_command(rtwdev, h2c_pkt);
+		return;
+	}
+
 	SET_RA_INFO_MACID(h2c_pkt, si->mac_id);
 	SET_RA_INFO_RATE_ID(h2c_pkt, si->rate_id);
 	SET_RA_INFO_INIT_RA_LVL(h2c_pkt, si->init_ra_lv);
diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index 8f86f7c12de5..9c435c160b61 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -782,6 +782,8 @@ struct rtw_sta_info {
 	bool vht_enable;
 	u8 init_ra_lv;
 	u64 ra_mask;
+	/* Last rate mask sent to the firmware, to gate no_update. */
+	u64 ra_mask_last;
 
 	DECLARE_BITMAP(tid_ba, IEEE80211_NUM_TIDS);
 
-- 
2.55.0

