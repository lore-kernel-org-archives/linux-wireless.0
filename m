Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00B6372058
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 06:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788761614; cv=none; b=E8iTh0zux+T7zyDd7tPIfCatIGt/i49CrDHa/roc/tOkifFaPeYnOf4wGHKX8Tkgt+nBDpHKCCyD/bxl0TF5gjjcQ/sDkakk+bJtg71mNYWQ3ERumfG4mfDlmMlaLus5X4pujtiUnTG+VypuVH7A3i6hNkPnoVMYAKw3C6firy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788761614; c=relaxed/simple;
	bh=JkhQsDhUIEm/FKGqUwTqIifZDkdcapBU6FPgynLGqZE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lu4TaQ/ZbMz0+xJOLabq12amRt9IR2PCFDKWkQh50G5Z+3suNn0hU1RbGhHmFAFAohV6r37sdR/R7n610qWbUaXppYZaBiEFycWDqr24hpupqFjPyoT+Fj1tJk/U0nLCTk1piMD8nC2xXuNcDctKw5R+Wr7bv5K9Iv6YaaGLw1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VnI9920P; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VnI9920P"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8568e3ecfc3so2069240b3a.3
        for <linux-wireless@vger.kernel.org>; Sun, 06 Sep 2026 23:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788761612; x=1789366412; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gMd2WrlSwtLrj+YkB5SmHSB5gQaJTN683ra2r4lrfrw=;
        b=VnI9920PuV8QuJmwL6JMOPre5HEQXSiwjp6lpOC9GloH49xlUA71x3A29EPSECSmIH
         xLlHX8XLFNc27dbR8F0il0K/sBGKmBP8otShCMDqqBHwc7ym/c1JdTu3OvyzXYSMVrcD
         cZE5Z7ry67+O+aA2YKp6r9oTuHB9atp8quPVTgYYXGMC4PUUfXwD00xrqaQgEosFfHNq
         g6fgTf6FoZyPe7YPmA4iavBMEaTkhbmx+E7B1fAsjOlzCVPbSdEFKh83RUMHddmE2PV4
         EVfNFi2P5/h58aDg4Y2OS8ULWGNeyeRlAN4VxZ1NKk4q1PawlgfGSejgMMBGowbzmozI
         hvCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788761612; x=1789366412;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gMd2WrlSwtLrj+YkB5SmHSB5gQaJTN683ra2r4lrfrw=;
        b=q+4ac2ji0JN6MIl7uy3/OX4CotAH0d9OXvMN6yUI+N99J5NxcBnhDrtbFH2yS84qJR
         peLcgANi4Xf0Nid2BerW+boe4N4I7aYxwZI8gceu50mef9SCFllPbUsz7FthCtdmVFnj
         pR28XZtbLXT2f8yEJobpLOLyhMxUjjSqa09mzde5EYdk1zGXi6ruggU8GzPGJOl7lX78
         yD02eScfIgKYkzSmt+IXszlTSppdbOZFPOjcbuFdSlcyi0hmuFuwHNkUtiuoXo5yvGi3
         B0uc5/oPwVwQPe5L3urIAH8eOz4/QskMwtpTV3JW7Qf/GmyL0pPQLCb6OAr+jyemJFvV
         EbAg==
X-Forwarded-Encrypted: i=1; AKwUvBwl8ATwwC8e67imTA2O+CQnKgrvbQGIOt3ORLqGy4x/WwtdDRTADlkBSyK7Nv4fdnq+DqOdeQMeYiUP+dFv0A==@vger.kernel.org
X-Gm-Message-State: AFuF++mHWep7uZDHFc5Sc5RXlwFVk9q12yHMWb/lRnaSUQnHfeN1yEsX
	jHMFN3W48QO4A5u7dM8oHSauOTsPVxlSFHXMGtM3c+q9NqmA0fiLzHrB
X-Gm-Gg: AYBFou0ol2PnkKNWPyFoHbblWHjrVOrFRbiDOlmnfnGs0PWxJhAGI1X99NkvPLRsnhU
	2oZOIx03+j/ndgrMdaANPHBw4SmchPFMujtj8BbooaAOWr6YgmIDODvsjrEuorQJqyKytvj6a27
	az2NhnZ5+T5J6AFi1JXib9Rm8kXlC6ahFf7NMk4pva9TFvonUK9E6KoKmMGEjBCGhd5LZetw3qO
	gOEIujYjS0iRhAThU4T9q4C6ymOqqxo4VN2K46U955Br45dLnLlMjHmdGEeAPVQ/al4uwt8vCQ7
	8G5hgSbhZV6h7TDVOe3yf8whDIhxb/7XZHncrG7OkU72sAjnjDyKfPlU5uKUMav3+2vh4kWVCfR
	DUBFusH8KfCqfVG9j83pUrPoDN0yKsJ5LuprCdBJPA1OUuVbxR4yAYaK2QstUAwXMKdV6mWc4F/
	Ff+1yPhRN2onLHzpN48ncrNU+7yoeJT5z8GSB0Leh+naKXvwU5rYl5CHUH1ivokFkMNP4LQMKDC
	c1txVyRnAXO8Mw=
X-Received: by 2002:a05:6a21:e58b:b0:3b4:8880:2089 with SMTP id adf61e73a8af0-3da3a0aa620mr33657982637.16.1788761611960;
        Sun, 06 Sep 2026 23:13:31 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339885d29esm27514156eec.2.2026.09.06.23.13.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 23:13:31 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: wcn36xx@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: wcn36xx: fix typos in comments
Date: Mon,  7 Sep 2026 11:43:27 +0530
Message-ID: <20260907061327.31452-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix typos in comments, reported by scripts/checkpatch.pl using the
misspelling list in scripts/spelling.txt.  Only touches comments, no code
changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 drivers/net/wireless/ath/wcn36xx/hal.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/hal.h b/drivers/net/wireless/ath/wcn36xx/hal.h
index ef9ea4ff891b..50c7b2ffb064 100644
--- a/drivers/net/wireless/ath/wcn36xx/hal.h
+++ b/drivers/net/wireless/ath/wcn36xx/hal.h
@@ -2650,7 +2650,7 @@ struct ani_global_class_a_stats_info {
 	 * shall be the same as the supporteRates parameter. */
 	u32 rx_input_sensitivity;
 
-	/* The maximum transmit power in dBm upto one decimal. for eg: if
+	/* The maximum transmit power in dBm up to one decimal. for eg: if
 	 * it is 10.5dBm, the value would be 105 */
 	u32 max_pwr;
 
@@ -3133,7 +3133,7 @@ struct wcn36xx_hal_nv_img_download_req_msg {
 	/* Fragment sequence number of the NV Image. Note that NV Image
 	 * might not fit into one message due to size limitation of the SMD
 	 * channel FIFO. UMAC can hence choose to chop the NV blob into
-	 * multiple fragments starting with seqeunce number 0, 1, 2 etc.
+	 * multiple fragments starting with sequence number 0, 1, 2 etc.
 	 * The last fragment MUST be indicated by marking the
 	 * isLastFragment field to 1. Note that all the NV blobs would be
 	 * concatenated together by HAL without any padding bytes in
@@ -3275,7 +3275,7 @@ struct wcn36xx_hal_send_beacon_req_msg {
 	/* TIM IE offset from the beginning of the template. */
 	u32 tim_ie_offset;
 
-	/* P2P IE offset from the begining of the template */
+	/* P2P IE offset from the beginning of the template */
 	u16 p2p_ie_offset;
 } __packed;
 
@@ -4139,10 +4139,10 @@ struct wcn36xx_hal_dump_cmd_rsp_msg {
 	/* success or failure */
 	u32 status;
 
-	/* Length of the responce message */
+	/* Length of the response message */
 	u32 rsp_length;
 
-	/* FIXME: Currently considering the responce will be less than
+	/* FIXME: Currently considering the response will be less than
 	 * 100bytes */
 	u8 rsp_buffer[DUMPCMD_RSP_BUFFER];
 } __packed;
-- 
2.48.1

