Received: from mail-ej2-f8.google.com (mail-ej2-f8.google.com [74.125.228.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9DD371899
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 07:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789024724; cv=none; b=m/H0Sk/CpKNRjnHDAe6yCN4okVZV1GqgvkEJnd0yUo41fqfB/1An7mvLz+u/y8gveWGEDDeVdSAusjNOAmpNnyjCTqutddHpREoD7HHSEt7emQAibKq1obojT0yc89urKYl3t5GmFms14kc8MJbN7/OTkQ4s+8OMxB8ra5l+7IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789024724; c=relaxed/simple;
	bh=pamRlI1Wz6QJkE8gV6GbMQG8h50VP0VBtfbUrUjnIGE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VYTPasEhtwHOwRrz6Mf4u8BO6yME20uhBbVKaqAAL2Ooxvg1Fn+IPVnoRG+CMFfZOwS8PoeYqF63O95QNsqsfEwsep0c5JMzNTaa83+rnSPuZA/kD3385XW5s9QBXZssVJaM+FKrTQy1nWPXKfUWVfP4+Yk60WT5rc0Ug3hn03k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=PYV1cocW; arc=none smtp.client-ip=74.125.228.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="PYV1cocW"
Received: by mail-ej2-f8.google.com with SMTP id a640c23a62f3a-c2532688fceso282560266b.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 00:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1789024721; x=1789629521; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=g3oKadEwUB89/gkFFNEt4XJ5XQBlxybI+fNNIa++1CA=;
        b=PYV1cocWP9Unx1mMD89Si+b5j+EsRrGy+FPaYnahGs/YRlWDOcyHUur+hvIa/Tw+Rf
         eASOACUiBoGzm7akWEkP/zXUtRdkIlC4LPrNaQefM+iGV5EI54xblRz9fk2rqgKkQQpi
         4Tk2FDZsPWh/49JwAAnrs/riNWj3uJz6oTf9pB1FncQ3u51/rolvqeOw/4RJoug4GiNi
         X2v1bnp/Mj0y3y4UPA68GvQ4BcwvinrBL6TKP+qlJsTWe6NwnpzXDcoJtfopZk16GmKU
         pXmu+Y1icxFztWsCOVItkTm5OiaHu6No6xG32UBM2QYc9upr3oJk5OrKd1KySp37qchW
         Oj7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789024721; x=1789629521;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=g3oKadEwUB89/gkFFNEt4XJ5XQBlxybI+fNNIa++1CA=;
        b=HYXPCYShR1kedIEXC2ZkSaQgRynsUzmndrksrjMjrDnQPNRq6TsVexJ0TzfLuh2gZz
         GSshCibDiVwk679Md5B+x/3xlWrcexj8JyxAlIHIwPrwh4b893zq8orejAaK9GtXKLEm
         sgu12BPi3qAm+FRVps1aK7Zh9v7e7HaiwZttqWA776fBBy0eMWZl/Rh8AJHCel4Jk8Bu
         b+/gTRTsce1NobMCr1elvEfgcNL4s5yF/kFMIp6rCEbz/rPCLgN0X4rsj+pBHMp+SN1D
         zPXvanv0+qIav3TT6HfN+mn/+rnLqiSNLACAgj8nogbUxdkSdm+BMbIsFLovZU0VnURD
         T0XQ==
X-Gm-Message-State: AFuF++ntTP9Kxi8Oz5NFDVRETV390BFh0g+pfLGaQBZDi6r5PqxF0rwd
	ro7Up46t2fmLdqkvIXVy/1G1xZLo1eSKDBGFl/ap4+FVv6p74ysQIOmVl7l9r9in8x4LOFLSGip
	MNoATxdDcEPfyKno1
X-Gm-Gg: AYBFou3BM1Qh27nXmWe8IVQLRVBP09hlJL3cEMLYz0EVVbB08hpM+iOCi/fPw56wxXZ
	Cv79VfxKQBlbB7STP4ZOV0/wmQAp2EiMsquaUkCjjr73KCqywKcCq+4Qn9pt1qZpZcPtcvmfAo3
	6y2gYx8ac+hSqyTab4bj8z6gTkVje3pQCtJvEtX2842JcKjY3JM/+VZ6Vb6dYEHzW9JyP0mL+8n
	pl74WwcFF7hKHre2sHb6px+DHRGMZj6ryT45PWPG49sws/cNSilwB0qVcFhqzAB9jttm/Ah/lk+
	4jS9M2AYh0HoK0RY/ZLAhU4CC3yi7ONoh5st2peYEa1CrVpShAPUr/o0L5SQysfUIrIbU0dFZuz
	d7RhR/TLyERpeNEL+F2CPEFFQQAsXj9QVT+DVlBAnpIHgZZ99inoP8cBOd5nUyhi93YjSFrWeG9
	t2j8dzBpoE3FkldY1tELIDLAPwjdP6d8jjM7tp+rgTYfqrTjdnvaDOwuWA+SRoZEhVFBQQwiw9u
	XO2lDO6OwcrZ0j1XUqjZ9t0SROmbzH7Tw9R0JrFM6WZFsFy+q8PTmuQ7f9R4VGsLO+eQ3sGcPCx
	FaCIpQds2dlXAEOcJtWjSasDgCIHiWqK13BzVEZAIeKJdxjWZzjxoSmboOs+tpBQaoosEuflR5X
	J86mRUZ1XfS+5C8UMP7Q15a7CvxkSYJcMDHA4iGNuF6UB55mblyngFaxbKEd0tBTf1CwetNVxfR
	gVcSPd9A==
X-Received: by 2002:a17:907:1c09:b0:c25:2fb9:b897 with SMTP id a640c23a62f3a-c260ca1e763mr1519573166b.18.1789024720961;
        Thu, 10 Sep 2026 00:18:40 -0700 (PDT)
Received: from Desktop.fritz.box ([217.26.235.87])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2938a59134sm170305966b.51.2026.09.10.00.18.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 00:18:40 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: ath11k: request firmware-2.bin directly
Date: Thu, 10 Sep 2026 09:18:38 +0200
Message-ID: <20260910071838.1983652-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ath11k treats firmware-2.bin as optional and falls back to API 1 when
the file is not present. Request it with request_firmware_direct(),
which does not fall back to the userspace firmware helper.

Closes: https://github.com/openwrt/openwrt/issues/24743
Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/fw.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/fw.c b/drivers/net/wireless/ath/ath11k/fw.c
index ef1b4c81843a..88ec2ffd9f00 100644
--- a/drivers/net/wireless/ath/ath11k/fw.c
+++ b/drivers/net/wireless/ath/ath11k/fw.c
@@ -16,10 +16,12 @@ static int ath11k_fw_request_firmware_api_n(struct ath11k_base *ab,
 	struct ath11k_fw_ie *hdr;
 	const u8 *data;
 	__le32 *timestamp;
+	char path[100];
 
-	ab->fw.fw = ath11k_core_firmware_request(ab, name);
-	if (IS_ERR(ab->fw.fw)) {
-		ret = PTR_ERR(ab->fw.fw);
+	ath11k_core_create_firmware_path(ab, name, path, sizeof(path));
+
+	ret = request_firmware_direct(&ab->fw.fw, path, ab->dev);
+	if (ret) {
 		ath11k_dbg(ab, ATH11K_DBG_BOOT, "failed to load %s: %d\n", name, ret);
 		ab->fw.fw = NULL;
 		return ret;
-- 
2.53.0

