Received: from vtj.irix.systems (vtj.irix.systems [82.76.27.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B0730E82B;
	Sun,  4 Oct 2026 11:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.76.27.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791113220; cv=none; b=KeteJVmk/7OJDrHdoB16Q3tjgaKHtF+TtXBqSQDGm4XOVbSE5os1hefOQCrtTgV34KC4mnJFi2Ouxff3RJNKYqTUbtrfdU0MGCJHs5btpsc4u8vBRRUnr7ZukHjIjCYw6iOkbNlXl+ZQ17N5koS00807J16d9Su72Kc06typnHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791113220; c=relaxed/simple;
	bh=LtncG4y4EZI0rYKOCA14KfkxKZycQBq67AKM0jYxRBE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Md4Yr5F6VIfa3HTONsB5AxKkKK+eDKjhIu4cEXPMenJNvcvcFCYc3tAkgbAhoqotzPOyQIJoK82QYQ1nbvmmyGMgsF6lf+RL/0g1UBQBxe9Fkh0WNq5WBmxptJd1AezYx2EjCgw+G3O6iuhAfaOGfSSlEK0X95Z2RlfDpW5qJws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com; spf=pass smtp.mailfrom=andrei-z.com; dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b=U2XIL5sB; arc=none smtp.client-ip=82.76.27.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b="U2XIL5sB"
Received: from MAILGW-HP.hp.vtj.corp.irix.systems (localhost [127.0.0.1])
	by vtj.irix.systems (Proxmox) with ESMTP id D6DF01BAC7;
	Sun, 04 Oct 2026 14:26:56 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrei-z.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=sig1; bh=ekKSSnB+ThUgyYskybv8
	jZBAtlopgihREQhdckc39dE=; b=U2XIL5sBuonaE6FT9Mg7HHy2h9Ox8eU32WMA
	ZGIgqOk7njHWS1lT0k9agDyBGZ3m5Sj+cc8gclkIEMI18yyMMPznac8DWOa5fTLz
	gMeCj5aEsUb3H5+JCVzmUHyUAGCNAScTmJpsAPJ7hSHXyV6wcZrAvpqLNvO5xqNt
	3oxSKfnwuC+sy0Wr+F6jNbU7Y8YE667e/wr60FCQ0KEWVy97AyGyFSTRKb160XZq
	XPiSDyKacRIDxT6s8yrdNQ3bkm7Kybh850MjwCgW/XsibJX8Q3RCgkpw/7KKaTW7
	Id1ExdpHOjmrIkGlCTws7NK4QBuVComD+xS8UmmpjZ9rbE+z3w==
Received: from VTJ-MX.corp.irix.systems (unknown [IPv6:2a02:2f04:1:9c24::6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by vtj.irix.systems (Proxmox) with ESMTPS id 26ADC1BAC6;
	Sun, 04 Oct 2026 14:26:56 +0300 (EEST)
Received: from workspace.corp.irix.systems (2a02:2f04:1:9c23::c) by
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 14:26:55 +0300
From: Andrei-Alexandru Bleortu <me@andrei-z.com>
To: Jeff Johnson <jjohnson@kernel.org>
CC: <ath11k@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@nbd.name>
Subject: [PATCH ath-next 2/2] wifi: ath11k: keep the BSS color while it is disabled
Date: Sun, 4 Oct 2026 14:24:40 +0300
Message-ID: <c180e6f0f96e4d27d96130aaef7d7d363b67e549.1791111136.git.me@andrei-z.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1791111135.3.git.me@andrei-z.com>
References: <cover.1791111135.3.git.me@andrei-z.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) To
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6)

While the BSS Color Disabled subfield is 1, an HE STA shall keep
advertising its nonzero BSS color in the TXVECTOR of the HE PPDUs it
transmits (IEEE Std 802.11-2024, 26.11.4). hostapd disables the color
while it counts down to a color change, and ath11k then set the vdev's
BSS color parameter to "disabled" with color 0.

Keep the color in the parameter and add the disabled flag to it.

Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Assisted-by: LLM
Signed-off-by: Andrei-Alexandru Bleortu <me@andrei-z.com>
---
 drivers/net/wireless/ath/ath11k/mac.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 183796ce1c..58d222a888 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -3812,12 +3812,14 @@ static void ath11k_mac_op_bss_info_changed(struct ieee80211_hw *hw,
 				ath11k_warn(ar->ab, "failed to set bss color collision on vdev %i: %d\n",
 					    arvif->vdev_id,  ret);
 
+			/* A disabled color stays in the PPDUs the AP transmits
+			 * (IEEE Std 802.11-2024, 26.11.4)
+			 */
 			param_id = WMI_VDEV_PARAM_BSS_COLOR;
-			if (info->he_bss_color.enabled)
-				param_value = info->he_bss_color.color <<
-						IEEE80211_HE_OPERATION_BSS_COLOR_OFFSET;
-			else
-				param_value = IEEE80211_HE_OPERATION_BSS_COLOR_DISABLED;
+			param_value = info->he_bss_color.color <<
+					IEEE80211_HE_OPERATION_BSS_COLOR_OFFSET;
+			if (!info->he_bss_color.enabled)
+				param_value |= IEEE80211_HE_OPERATION_BSS_COLOR_DISABLED;
 
 			ret = ath11k_wmi_vdev_set_param_cmd(ar, arvif->vdev_id,
 							    param_id,
-- 
2.47.3


