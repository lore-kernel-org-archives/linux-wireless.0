Received: from mail-lr2-f7.google.com (mail-lr2-f7.google.com [74.125.230.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E754B48F00B
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 14:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789742179; cv=none; b=g52136Ss3e4JiFHkLGYQeNPXe7m4A8mQ4KtYtDXlfiWkUJDp/BjI7AecyU1LIMZfzoOtIMBBaKS+PMktiL6/lfMSbWVbhczCgJfocahR/m+x1zQ78CyTwkNDUAdXnSIH/hLnQmVEKoUm6pi6kVGQTdQsMrgrmVKQNVSCf49bPlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789742179; c=relaxed/simple;
	bh=oHK7jTtToiFcxA/9CIKnKR3YjDf4Xd/qP/4WmuFBlso=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YMMbsJ0EVouSa8odQRb3nbRFXRXSzqBofzety5tIIbMmmGGfe4l0FGYPTMpEYi63y/VgrNexbqmXByYnZMIm57dxH8TwXrz8B+VzZCk9jaTYxxKX8tRXmCWBqZ4ahKb5q+bitCRbqL+2tnJmV8qeQF811HVs1qBtncQmnARobOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=q6GZOzx+; arc=none smtp.client-ip=74.125.230.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q6GZOzx+"
Received: by mail-lr2-f7.google.com with SMTP id 38308e7fff4ca-3a5abfab93bso5181411fa.1
        for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 07:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789742174; x=1790346974; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=80thoqF6oWnfHU18nXpOy6DAO7B/ZBVuVLAIvy3f1Nk=;
        b=q6GZOzx+hzy2iRbWqUtd613E/F1RSqTkZy6oNpOtQiM22AldCxh7HS9KPHKzTq1dRn
         UPzCjtFO08wT2CY5eorcv/MRk7YDYX8yOi0qrltD/rGX31xNJacSz9UpTAraXANOUfBY
         zG+xBKDt4H/ok9tA3pJJHHPEkHGvLuuZcMlPgkEclOUph9KLFyRIXLaB75OxKiGPkVRM
         8FcNxB1I5WAt8C/vnCnrP2geeNujKK2WMoRIIkPOouSDvf4zIenD3BB49KIv9WREDHOn
         7fTSe7rZSeyhnq+Scx/a/NcFr8coe9JvsoXD9HOtOD976pxEL+zCo5F9xXPaNIS1BYX8
         G29Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789742174; x=1790346974;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=80thoqF6oWnfHU18nXpOy6DAO7B/ZBVuVLAIvy3f1Nk=;
        b=oJIlBRclMSHorpv+HOGshbC4clHy5RAr0O/zYjbzITus2YtiHaZRIWm6DRbyBT3SRp
         XWdhXfUxHwiPQNWOyCCjAAINyjznDAvQxaeFdYpSiDHGt1vj6aDpX4iIkOj84LkXJ8Oh
         h+nn1wNp+9uof8X7ye0S/cGoAhqPUmM7oxmgWASGCMvE2WDaeSFEBDt29NC+H2750Y3R
         vRGlsx+b/TSgipnTFD07r/1ocwbac5XDwNKAp1AXZEbakzmbFI8M90a3QuT+C95KOcG0
         vpmnd8xRCwAoED1gNSx/pfCFuB9cXlXp7dlJIVPeOf6mFa8YmFNSNGa4NhQknpVeJiNw
         UnDw==
X-Forwarded-Encrypted: i=1; AKwUvBz5fTVJnn1+OG0aksPxyA/Ugv/ybPZ0waNahfsUyzcCnnK43esUKTlRGH9O3nhmd4Rygd4v5fSj0QiCXoLsOg==@vger.kernel.org
X-Gm-Message-State: AFuF++l8X9IlJTmf3aTXP0ez3208GIJul7g/WJvQmQ1rgyXyqJFiWvQT
	iuUkdD+sBmq7sawRcemyhCHPsbEqE6f654H5/v1ZBzDuNYLgCbhJLXEt
X-Gm-Gg: AYBFou3wCicib6EErrDv2H8lTEtfp4yq1lwV2xuPFG+0ekY0cg723t6OQM/6M3kSr7c
	GFhWj9qjjZxF3KvOIVDi6XQYe87IumZ84+uQGUG3na01btcpVyWBmciRmOmwZuUwVQ0jFWQBsQF
	MqK0RFFvmYeC+JHPqXoLdCoYvVOOTE5MRx4fDsK6IBnh9GAzqxsZduWK87ULk7zpoeAtVHo5APS
	yl1Mtq92spYQBk6PxKQHwuZNSfRZ21t6O6cJVpT5pZo8GFOq4ZaK2vb3iZpPvmuIl75U6gCyj9a
	XCESmgQRGUrRva62IGwalbz0f/QBftOtOs0Ra8sw9bcIXkEKBx0VQBOqxh3I8ve2V/88ec1UpW8
	UI5JutEWYvzi9R1WoeYmtB1yR2YnrUST2jLw2wofT9FLm7KsI6uFcltq8uYj9boKJFEgb5AbxiP
	ZiPI4T6ERr3GgE0tjL5ZnXUgx7FVX02j6mtL6POus7mkOGbpuiutqwSSjSC+uRVLEhbRujDAWuJ
	HavUA==
X-Received: by 2002:a05:651c:150b:b0:3a3:749e:319b with SMTP id 38308e7fff4ca-3a5fbf55489mr5837501fa.15.1789742173556;
        Fri, 18 Sep 2026 07:36:13 -0700 (PDT)
Received: from linux ([78.40.184.2])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a5fd80eb8csm4784691fa.21.2026.09.18.07.36.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 07:36:13 -0700 (PDT)
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
Subject: [PATCH 5.15] wifi: wcn36xx: fix heap overflow from oversized firmware HAL response
Date: Fri, 18 Sep 2026 17:35:31 +0300
Message-ID: <20260918143539.97842-1-roman.demidov.nn@gmail.com>
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
index a778e3e0599e..6ab91ff8338c 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -3174,6 +3174,10 @@ int wcn36xx_smd_rsp_process(struct rpmsg_device *rpdev,
 	case WCN36XX_HAL_GTK_OFFLOAD_GETINFO_RSP:
 	case WCN36XX_HAL_HOST_RESUME_RSP:
 	case WCN36XX_HAL_UPDATE_CHANNEL_LIST_RSP:
+		if (len > WCN36XX_HAL_BUF_SIZE) {
+			wcn36xx_warn("HAL response too large: %d\n", len);
+			break;
+		}
 		memcpy(wcn->hal_buf, buf, len);
 		wcn->hal_rsp_len = len;
 		complete(&wcn->hal_rsp_compl);
-- 
2.53.0

