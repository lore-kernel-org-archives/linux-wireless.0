Received: from mail-lr2-f11.google.com (mail-lr2-f11.google.com [74.125.230.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39F73B47E3
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 14:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789742199; cv=none; b=WrVFsBNLIYKy6Ce5+U1Qgsj3D8XASS+7vQvLKPPAVgDyn9wuCzv+Symiuj3HaWGoS04dTYyzB0iqxT6Ej+iVo0xAkuv9CJLBvrr8e6FTp5SDhUqJVjnN/epmcvIM83rgpdazLqw641F+hJ4ZKdOl4fC6Hg3mxAAvT1KioJcPmoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789742199; c=relaxed/simple;
	bh=LNSIAKB/LfKHM4jWjZllEh8pyKx290EXKu4c57L9ets=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ixaua5kQNZgsoqkyVOv6ynWOn2j72eUYV0vfXH9EvuW7XZq5Qve0Avdisd6SuVPAsQVVubZT9IsttnzmwLGtmY5aJG8WmqLOKMj/iPrgNLGUKAHCl56kpUjx6wx5J2mWErAJpN6lmRXYS7oRHPALroZGISkY7liAu6ZRQvZBmA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZG8nbHw6; arc=none smtp.client-ip=74.125.230.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZG8nbHw6"
Received: by mail-lr2-f11.google.com with SMTP id 38308e7fff4ca-3a5b0adf48fso4622211fa.0
        for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 07:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789742195; x=1790346995; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LOhMfXD0/BBBcEGxBgCARg4zRQIYPTh+PJcHIjkoFCo=;
        b=ZG8nbHw63g6tsfb1KRT6C3GtJw+1TN/i3RVhFommchjBKT4KAdmWAL7CgqjTiA2QUG
         Z2ELc4J6Z3WPB30jqiyqlceqmxFU0x+HXfPZCeO4GISGGnUW+Ye/f7Eo0gu5PSfS2Bk+
         gdrAXfnmt44QIwj76/FSd6KNhssshpSikpjFwj+sFH5a/s9AokRiHzKQJeAUzdM42nQK
         TgSJsZW0JOkpuaLAnWieJNxvQxd0ki8S+p8kksDGvQsmKtRLvZLoRxOq2EZcfOwO9nrf
         AIy/RtKE5CAKvbpy5KPxzkfuOv8viKBHbzQgl0dYgiiSn0yQXi9DqaWfB38YcibIbUOJ
         aPMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789742195; x=1790346995;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LOhMfXD0/BBBcEGxBgCARg4zRQIYPTh+PJcHIjkoFCo=;
        b=1kuYVvY3VZpZE6CoPHu88iJFIl7SYtQDg5zy1pezPEBF097afx6xQGh+Rsf0UgDOpy
         ruoX8YPDF/EaBlmp8gHHI5PIysgZlreMxlpiYrYkpErfUOjabz6s8QRlQr7stGRb15nY
         FtxPd8DJMJxDAT6iCLQQhHTFoP/eh4QWXUegr76BDkcGBJrs8PF00PrAEZPJuG6ls2Hn
         sCK2eC9O1JSc1U6DZM46IQA1mVwWGAP0trsLXZuVJ41Ngz4bxMcYk5iGABn7CrBtzJzD
         Pf3JExEI9JoCP3Qs72KiPkClPIbECBqR8R9AmYFeHAFFFH9yPEOGeTNOP7Xhcb/UxaXt
         aZxA==
X-Forwarded-Encrypted: i=1; AKwUvBzbbV0mFKSoIZgCqC7tElMRH3hdJuqWqQsbvrMwm4dlzGb0RMPZt/TZjd173aJ8pPge+sD6MpQB4kg6C4MPQw==@vger.kernel.org
X-Gm-Message-State: AFuF++nVcT1tl+0oPHxCypYOdhSOk7ka2uytFjqduT1lmrg2mudj01mr
	Z6YAb5jWWUoNd3a3lFtP/CfTFMMP0PaYHuLaB58NlMTSp9HoQWR0RbPRXzOy857xSvw=
X-Gm-Gg: AYBFou21zOuI0m7B0Hfp7y3ZXFeHQOWYKwWZ64eUDbShfWQBXJCJZfzU997g68hpCn8
	baQHPu5U/fiAd9QbAPUPAagHMIApGOCqCzHURdUZHJwZQzD39XOVMIq+skUU900yM8C7R0EQ4O/
	67AdBazUqLIw/WJ+QjZ+LfOuvu0R4oaTG2SFZW+faKhNFDeIiWtNsrjzsgG/tv9dMSRpi+SZYsJ
	INVjsDMuav2l3EurwbRNbEsKvrvwS1QznFiA9XqCDhp9nzT0eS5/p5HLso8cGDrs+1EZrdrUcYe
	PeqCQERY2ktopI6c/xagQf21ZFZ+datE1+M0iODAo1MhFO2E+x/7CERP1RfgfwYYJ95MiKAWOrR
	9mSNY7kYgxiiTdWDRCL0fBnbY5ovhDx/ebKDtVtBuuZIWMLZxl8QiNOYx1jZVfABVDOD8ObtwvV
	vBdHaD7DAqhi9UWdLhsjfhpGXkf35d/tEq0E0K2bKIJ2B2rVjD6DVdKH9Bjsd3b17IfiCm6odz4
	CPGww==
X-Received: by 2002:a05:6512:3985:b0:5ae:bf3b:c98 with SMTP id 2adb3069b0e04-5b8c1813cc2mr949113e87.10.1789742195038;
        Fri, 18 Sep 2026 07:36:35 -0700 (PDT)
Received: from linux ([78.40.184.2])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8c276dd43sm475819e87.83.2026.09.18.07.36.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 07:36:34 -0700 (PDT)
From: Roman Demidov <roman.demidov.nn@gmail.com>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Roman Demidov <roman.demidov.nn@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Eugene Krasnikov <k.eugene.e@gmail.com>,
	wcn36xx@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	Tristan Madani <tristan@talencesecurity.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10] wifi: wcn36xx: fix heap overflow from oversized firmware HAL response
Date: Fri, 18 Sep 2026 17:36:25 +0300
Message-ID: <20260918143627.97927-1-roman.demidov.nn@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tristan Madani <tristan@talencesecurity.com>

commit 88a240d86d3d64521f9194abe185ac71cc74d0bd upstream.

The firmware response dispatcher copies all synchronous HAL responses
into the 4096-byte hal_buf without validating the response length. A
response exceeding WCN36XX_HAL_BUF_SIZE causes a heap buffer overflow
with firmware-controlled content.

Add a bounds check on the response length.

Fixes: 8e84c2582169 ("wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680 hardware")
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Link: https://patch.msgid.link/20260421135018.352774-2-tristmd@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
---
Backport fix for CVE-2026-74341

 drivers/net/wireless/ath/wcn36xx/smd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 900ee1e8ffdd..c02526468c9c 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -2835,6 +2835,10 @@ int wcn36xx_smd_rsp_process(struct rpmsg_device *rpdev,
 	case WCN36XX_HAL_8023_MULTICAST_LIST_RSP:
 	case WCN36XX_HAL_START_SCAN_OFFLOAD_RSP:
 	case WCN36XX_HAL_STOP_SCAN_OFFLOAD_RSP:
+		if (len > WCN36XX_HAL_BUF_SIZE) {
+			wcn36xx_warn("HAL response too large: %d\n", len);
+			break;
+		}
 		memcpy(wcn->hal_buf, buf, len);
 		wcn->hal_rsp_len = len;
 		complete(&wcn->hal_rsp_compl);
-- 
2.53.0

