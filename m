Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D54444CAE4
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 18:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784917159; cv=none; b=RSCex4+8n2LifSEYjIYFoLhFQg+UX7HPlnBVI4ywYFvu3MRU9pZ8APfyaYYwhO+TYuDtU8ApiF+7NEdDdzkyXIPjlaIMtM5rkYAft3bHdCHfAulcVyYW4GMi9VICNPKHIlYHzVLVSWtqfNn/yIArcj9IxZojVjjZ3dPoCUklUPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784917159; c=relaxed/simple;
	bh=HLwd3LgcYMjmVZ76USxis3srXnn/4MY2lW36HJOXR/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E51Vxq0TC1tVps+BHVsMXCmBVf0VQrD82upZXCEjwjev9LynbKn2mYiH5rN/aiC5GSv0WowGd1oIL1KwUxRsXvpubJwWbpPIP+Xr7VsgAutfo9NpJBh7V0f0MP5Bx0aWyhy/BkE3tGrkh3o0JD8naFMxiY6lYlaBQ/JbvIjBD9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tfMhWqes; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tfMhWqes"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784917156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X3oT0ww5N164CyGglk1FHr+XnwryzhKFyPO2gBmqbU0=;
	b=tfMhWqesxF1vBmJFpeQDkyu1mBKyz+g9HGb8BhxCGmb9/API4NqldvjzRxjDk1BvIqcNyn
	G+RbEmSJk0HULl3UV14Zh19QIJT99K+LkqYmuSl3oBe6OMqowAf74KBbYiMaMeOtzenNhH
	9UqzFouJE+bCUX49+0y0+ISMZLeuJYk=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH 06/19] wifi: rtw88: fw: send the media status report in the vendor layout
Date: Fri, 24 Jul 2026 20:18:45 +0200
Message-ID: <20260724181858.192903-7-luka.gejak@linux.dev>
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

As with the rate adaptation commands, the RTL8723BS firmware expects the
vendor v5.2.17 byte layout for the media status report. The bit packed
rtw88 form leaves the firmware without a valid connect indication, so
emit the layout it parses for this chip.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 drivers/net/wireless/realtek/rtw88/fw.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index 495d26eafdd4..87da0dd82aaa 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -839,8 +839,19 @@ void rtw_fw_media_status_report(struct rtw_dev *rtwdev, u8 mac_id, bool connect)
 	u8 h2c_pkt[H2C_PKT_SIZE] = {0};
 
 	SET_H2C_CMD_ID_CLASS(h2c_pkt, H2C_CMD_MEDIA_STATUS_RPT);
-	MEDIA_STATUS_RPT_SET_OP_MODE(h2c_pkt, connect);
-	MEDIA_STATUS_RPT_SET_MACID(h2c_pkt, mac_id);
+
+	if (rtw_is_8723bs(rtwdev)) {
+		/* Vendor v5.2.17 MEDIA_STATUS_RPT: connect = 21 00 00,
+		 * disconnect = 00 00 00. Byte1[0]=OPMODE, [5]=ROLE(STA=0),
+		 * [1]=MACID_IND; byte2=MACID; byte3=MACID_END.
+		 */
+		h2c_pkt[1] = connect ? 0x21 : 0x00;
+		h2c_pkt[2] = mac_id & 0x7f;
+		h2c_pkt[3] = 0x00;
+	} else {
+		MEDIA_STATUS_RPT_SET_OP_MODE(h2c_pkt, connect);
+		MEDIA_STATUS_RPT_SET_MACID(h2c_pkt, mac_id);
+	}
 
 	rtw_fw_send_h2c_command(rtwdev, h2c_pkt);
 }
-- 
2.55.0

