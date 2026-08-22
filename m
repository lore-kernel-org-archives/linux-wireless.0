Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4073ACA4D
	for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2026 08:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787385624; cv=none; b=MgaqfjPNJG5tlK0hegd621PLEx3cFETQw8j0ziGGieH71BlXHq8ZnUrFngHDxjUkjqYfM9un9y0CZdEuD4kelwYJyTCN5HkUxfdzc2Ck/RyTGiiwXxd4f4GPuGwqboRU/tp5VEHtUltjiscO6g6MHYSMwGimm+lheC9+HmBzSBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787385624; c=relaxed/simple;
	bh=yAOiruEm9L8AjUBZGFt6yw9dAsrnsAkjYEMNNqDarWo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XvCwGkFbY0rsqLnqJZGsw7KvU5aw84DKIRQ1cIsNKAUPRpEFrBDguNsQek8akgD0kAGqJAn5sTGfIbOqqypG6JH3DhSLgRhBpWO7/qFBpHbdtd2R5lryPz0SIdCCCX/0+Aw9V4G0mQNNY8vn9HVWQOPravNSCvlmid0uZKcEhqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oagJeHyV; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oagJeHyV"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-38e041ea211so1567958a91.0
        for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2026 01:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787385621; x=1787990421; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vDG9YXYoRtMkAetCjmKzpnMDn+Xh8GlN8oNesgXLH1w=;
        b=oagJeHyVlwtClV7l2gpw8K0kF9mFeM0vIb0o/2l9raenmWa9RvIqYNjrt4XrGfpZFx
         MrOyb0TbA7pJREpdJ3cYl/ri5Wgl+3MlrYdR078YYiDnYjt3T4QZm7pkfAWVA+7xyoqX
         WnsCuCrCeODPRbXtadDlw44OtguiKjAJtE5BkimYdCHRNbHov52PM+5RaR4lqxEmsB0+
         jqDHthH3lTQFRHdyP/I+eyqdu4QYYJB5DJDnIJbFx5QifmLE6fBK8gqIJlYLkDDBcIkC
         CWAmzh3AOUu26Kh8VYPbK2Iwp/R35alXDOhtNIWDWLsqWsxpISeEiuoao+HCgF9xqJV1
         yl6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787385621; x=1787990421;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vDG9YXYoRtMkAetCjmKzpnMDn+Xh8GlN8oNesgXLH1w=;
        b=N0DQyI4zgjmzTF4NtneLZ2WqBVVh3ALIr5iNLVMTFBje070e1bSXpSjIXAjfY/rBeY
         E2x5xq0p/WuaxNlM+TH8Rc1nbYx7tg4aK22NHrMvM5Ij0oUA8Myhc2kkSP2aIgOkr/Ri
         UvrQDyUJBFkBBHjvD3v1jxJrF8K/Ii9aQUkkgAT7mkdbYZIaQ8hsk9ex61DITGyBN2Df
         EntYoBz6D8gzsvtBjlUYe3jqWIu9JIVIGQNrUXS9sxRVIl0oChiZeyhZEyTg9cxONsLs
         uSPPoQJ0vQCs6buwHm9aqD3zT1akuiryJI0bZY55ygECtQrG3ZpTq9HncqLYvw5HH6PH
         k4Vg==
X-Forwarded-Encrypted: i=1; AHgh+RqtDJBR2bYgUedDByx3OR67iLyIvQqQUJ15VsmvTKmxlVIq5e22Lst41Zw5TGvySdj9vKTN/fAbKSozfGoG+A==@vger.kernel.org
X-Gm-Message-State: AFuF++mNK2itGQ1ETV/bCuL3/hJK3X20w5z3LUPkrVzGmGeuN1gmpNP6
	czEzmZiFggQoV8cUlIUkIFn+ipWSVKtaBv9RX/P0L2yLwAqfXfceTg0N
X-Gm-Gg: AR+sD13zyynsUCBij0wc98FNaVvbHVe0EzkIlBo4ESBuUnBR7NyB/8QLZFW4hudiIzv
	Ndrpj2jeevzFY061JtXqE6msZ0YkkpaBhxu0mj2iNFlbiXlqvdmvIJG+yxidDgIRF9fEIIsoCLz
	d1Fb/c/A8Pcg+8Y2tf/TTkZKQNCQoPr9J8KYEKjF+Eset/oompblszJLdepynJfDuw+conQ6TUT
	nPSGg/ooyaErg44Sfh6JQ0vFsKGGljf5SI1AsEWB/S5UgY8dbDPihn/N4y9SNANw7p4StuVHPNe
	Vx7/MtQzvyjq4z/hepCIJa2dvtlAhw7vpYIj7t0waHh4zbGyU6v7CiowSg8uYfBY1Q/Jtn1oarV
	Etzs+nZ3jcxcpGhQZV4rbTgenxkWiPMBBUY1Em/5R/zThtXGoFDKHGquFjk8qUi7E6PPI/eSldO
	NnsUmUc0zqs4EDadxuDxDi8GkVwv/+VjEU9ODAEObpmAicrs/R9eye+Qasw/Yz8d+ayNPEPxQgP
	hhvYYlKLIhBQWai6I61hKYVWr8TeEuY3YEW2i8KKC9YwJ9fE1JlEHZidwqkuLrIV/hzW5N31MOF
	9Tf4ojkzOrbw7VdhzrDXA/pV2VzDC+18Z/9OomovNcPgmIjv9OaAg9rrCGcmKg5sOYHPcBwHs5U
	/zTDU14aqeds29Ai8nCYYQc6ADOnfpdIMbDn0PCjR3pubNeDi4VCs7Wn3gGtIrYCIOziz3w==
X-Received: by 2002:a17:90b:3bc6:b0:393:194d:5366 with SMTP id 98e67ed59e1d1-395c354da4fmr22617902a91.10.1787385620517;
        Sat, 22 Aug 2026 01:00:20 -0700 (PDT)
Received: from localhost.localdomain ([101.251.7.10])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327f909c6c9sm4897116eec.6.2026.08.22.01.00.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 22 Aug 2026 01:00:19 -0700 (PDT)
From: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] wifi: rtw89: cap firmware section_num before parsing
Date: Sat, 22 Aug 2026 13:45:14 +0545
Message-ID: <20260822080014.29611-1-acharyalaxman8848@gmail.com>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rtw89_fw_bin_info.section_info has FWDL_SECTION_MAX_NUM (10) entries.
The v0/v1 header parsers take section_num from an 8-bit firmware field
(0..255) and write info->section_info[i] with no cap.
rtw89_fw_download_suit() keeps that object on the stack, so a crafted
firmware blob overflows the stack.

Reject a truncated header and a section table that does not fit in the
firmware image before reading fw_hdr->sections[i].

Cc: stable@vger.kernel.org
Signed-off-by: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 30 +++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 0099c5c03e7a6..57d4252ee78f0 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -156,8 +156,23 @@ static int rtw89_fw_hdr_parser_v0(struct rtw89_dev *rtwdev, const u8 *fw, u32 le
 	if (!info)
 		return -EINVAL;
 
+	if (len < sizeof(*fw_hdr)) {
+		rtw89_err(rtwdev, "[ERR]fw header truncated\n");
+		return -EINVAL;
+	}
+
 	info->section_num = le32_get_bits(fw_hdr->w6, FW_HDR_W6_SEC_NUM);
+	if (!info->section_num || info->section_num > FWDL_SECTION_MAX_NUM) {
+		rtw89_err(rtwdev, "[ERR]invalid fw section num %u\n",
+			  info->section_num);
+		return -EINVAL;
+	}
+
 	base_hdr_len = struct_size(fw_hdr, sections, info->section_num);
+	if (base_hdr_len > len) {
+		rtw89_err(rtwdev, "[ERR]fw header truncated\n");
+		return -EINVAL;
+	}
 	info->dynamic_hdr_en = le32_get_bits(fw_hdr->w7, FW_HDR_W7_DYN_HDR);
 	info->idmem_share_mode = le32_get_bits(fw_hdr->w7, FW_HDR_W7_IDMEM_SHARE_MODE);
 
@@ -455,9 +470,24 @@ static int rtw89_fw_hdr_parser_v1(struct rtw89_dev *rtwdev, const u8 *fw, u32 le
 	int ret;
 	u32 i;
 
+	if (len < sizeof(*fw_hdr)) {
+		rtw89_err(rtwdev, "[ERR]fw header truncated\n");
+		return -EINVAL;
+	}
+
 	info->section_num = le32_get_bits(fw_hdr->w6, FW_HDR_V1_W6_SEC_NUM);
+	if (!info->section_num || info->section_num > FWDL_SECTION_MAX_NUM) {
+		rtw89_err(rtwdev, "[ERR]invalid fw section num %u\n",
+			  info->section_num);
+		return -EINVAL;
+	}
+
 	info->dsp_checksum = le32_get_bits(fw_hdr->w6, FW_HDR_V1_W6_DSP_CHKSUM);
 	base_hdr_len = struct_size(fw_hdr, sections, info->section_num);
+	if (base_hdr_len > len) {
+		rtw89_err(rtwdev, "[ERR]fw header truncated\n");
+		return -EINVAL;
+	}
 	info->dynamic_hdr_en = le32_get_bits(fw_hdr->w7, FW_HDR_V1_W7_DYN_HDR);
 	info->idmem_share_mode = le32_get_bits(fw_hdr->w7, FW_HDR_V1_W7_IDMEM_SHARE_MODE);
 
-- 
2.51.2

