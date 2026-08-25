Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D76392C4C
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 17:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787679886; cv=none; b=Tq36uX+BaMIxm+ZqTeQcWlimygpmR/pH0MHzPe722zqESbx/m1PMxEA5zJxOAa3PlhjCOYVt/jLVE6qd1HlAG9rCbLpJWldmfCAcn03SkN1Pd4KJ9CZWA1QUSzg+V6ErrSi4PG41E8R/6j4ax5c333WEO16ja+p6ISuz5ilQFI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787679886; c=relaxed/simple;
	bh=xP5hC3EW+QrXcJ7cWu3d/5v7Pw2lYYABlggw/9Rw3Yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k7Xm/OhJpObv1gfUebFMpPf1As4DAYqFgtveHMvGJkCpV2yZaNFgGzJUCy19K/ZXZ7u4NZQNHNW9Tj5MdB5yb7tE+ruSiwZy7ezxcldT8BERPpK3kmyrvdJNDvdDwh0bf3aGki4MhW/AFWt2oH1oIxve+6pyuf5RIsvJ4s/etL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SwOIdaoM; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SwOIdaoM"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3964e480f76so186964a91.1
        for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 10:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787679884; x=1788284684; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7rCB6I5x4Roy9GfTsNUlX+UKlokaetwV2w4y3hwUUZs=;
        b=SwOIdaoMvWGkxIDqhyz//Hhrbs5yjavIwc5MXbFZNWYH08AtziNnJjTf/1M7xo6YW3
         mCr9SAp2zWrTQmzP7br8DjKyaUk58IQ2Wsu6/e4SqF0NmGPESOpQefME2F9FCFqeoDyb
         XlmfuZmxI5WjVE/9FlKEtkdl1cvNDaqRm8qkq6oJU0Wm7c10k6dSCZT6csPvZcEcx/r+
         YDJaaH2ZUuMGA9QTNVw/ih641KYQVOrgDusbwe24d9MCX60/qiDr3+m41UWRCShBHgEb
         g2BD4YjOVJubmGqY/XF97UNeCo0BeTytUJQArffKsK+Vz3t4+cjI79V8Kt36dVrx3Ry6
         5p8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787679884; x=1788284684;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7rCB6I5x4Roy9GfTsNUlX+UKlokaetwV2w4y3hwUUZs=;
        b=S7B+NA3c9+X/GOHpIK+6XDye/sfq/yLD+dRrV7GMIfWR8BabKxSavUp5mpdcdEj0tg
         hwzu/keKRugo2XHHrD4UMtwErka+1xamoYAmFXTqOL8F7RAjAPPXWAdouxeT6VjaypwF
         VO5DAUXfa2WSyt1gfXmm23l6P0aa/Nw8Do5PWW8u30fH7Im1zGoyfTfrqylG0UYWjpPU
         sSjS1tJn383P5N6+eM7aezodjwRTjauhwmRnOtBo+23gqqrynuAnhsvCdjmj/FLSwOuQ
         LZI9x6wdeTfLcuhM7Sxe7aZ+fGMNoOp3nmb5Anf06PxpbIdQ0o0cLduSfB82XovOcdj8
         Vw9w==
X-Forwarded-Encrypted: i=1; AHgh+Rrtar1qKhTH2jFq6am8J7zlBp0PquFDpeF76DHD0Tx5L8IijecWHHrGCiYzKqdPm4nro0VJTQjNhV5BZmXJiw==@vger.kernel.org
X-Gm-Message-State: AFuF++nspWTNpSXaoh82CtDjmcoKHFkKlyKl8Fu6AQFUzUAal/qDmYlv
	qbgYfvWEGF9bEPrHIoCIe0/7bDNWzUKBFy7Rce+NXS7RChC26MK3CulmPHT3pQ==
X-Gm-Gg: AR+sD11PBA+WwlrvMEqr9t6sYyEDkFgiBt45lyQpZRkFiEs/T3N5t52X+LexJGHo4oe
	WAhZiz2zzVQ0YPlbJlaG09cDwYCbrNyat6VLLE5Sg4mWMC04JCEFkI+DRinJq8cape0F3l1c6Hd
	CJZb9BeOP0sOrPqWHo45svuJLPjYWh4uI5myd0cKBdl/tmOFNWGEQgo7fihanZpShWHBmHoZX8d
	MmZe61EPc3Z8uowx7/dsaROM5tIDNB1eMaNhMnnj66P1KBvjhnSoO+wn8pTVbjIB5HbilyCefUE
	MpLdyC8AjH48NpBuZ0r+UyQz/UkkWvrt3hjXjzqrI86hW1+LARdFsiFmvtBky1cYBlN3/ZslZaf
	EVCNcANzrMgCKsiTeq79A49mFxkhepiXaC77Rur/O+e3Oh1tTABqg90ro6G5aYsH3KN4BbBgCqw
	+di39hVazs/6Vz+MjwL/p65SqRVt8sO8YLeeVqHCmqqZUPzIywBySRxoAaO4Ykw6Bw412/+sdKs
	hzNmJ4cyT9KVExMOxDO1fVncr7C0Li9eZeAcrZlECA5MwJ3gPMRtIVGCBJ2nnRsjcvucW7u+vmE
	AXgyPnRaUfM3oUL2nSNQMf+84CvDb6k7WV7Sym82eTQjt+3DQYxgUlqBCHLFZ0bDIg1+q416NO3
	DJX24O/Xpcv+i4YZ3gO4JucbBlNfRtF6/R0MTadvFWepo1jbR
X-Received: by 2002:a17:90b:1fd0:b0:38e:70d5:b12d with SMTP id 98e67ed59e1d1-3966d3ed042mr1750141a91.6.1787679884462;
        Tue, 25 Aug 2026 10:44:44 -0700 (PDT)
Received: from localhost.localdomain ([101.251.7.10])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-141a905b959sm775562c88.13.2026.08.25.10.44.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 25 Aug 2026 10:44:43 -0700 (PDT)
From: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@kernel.org>,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2] wifi: rtw89: cap firmware section_num before parsing
Date: Tue, 25 Aug 2026 23:29:38 +0545
Message-ID: <20260825174438.63168-1-acharyalaxman8848@gmail.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <26bf80f23bfa4fe49183d1f724fffc5c@realtek.com>
References: <26bf80f23bfa4fe49183d1f724fffc5c@realtek.com>
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

Fixes: e3ec7017f6a2 ("rtw89: add Realtek 802.11ax driver")
Cc: stable@vger.kernel.org
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
---
Changes in v2:
- Add the requested empty lines after the section table bounds checks.
- Add the missing Fixes tag and Ping-Ke's Acked-by tag.

 drivers/net/wireless/realtek/rtw89/fw.c | 32 +++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 0099c5c03e7a..b2991bc93f85 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -156,8 +156,24 @@ static int rtw89_fw_hdr_parser_v0(struct rtw89_dev *rtwdev, const u8 *fw, u32 le
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
+
 	info->dynamic_hdr_en = le32_get_bits(fw_hdr->w7, FW_HDR_W7_DYN_HDR);
 	info->idmem_share_mode = le32_get_bits(fw_hdr->w7, FW_HDR_W7_IDMEM_SHARE_MODE);
 
@@ -455,9 +471,25 @@ static int rtw89_fw_hdr_parser_v1(struct rtw89_dev *rtwdev, const u8 *fw, u32 le
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
+
 	info->dynamic_hdr_en = le32_get_bits(fw_hdr->w7, FW_HDR_V1_W7_DYN_HDR);
 	info->idmem_share_mode = le32_get_bits(fw_hdr->w7, FW_HDR_V1_W7_IDMEM_SHARE_MODE);
 
-- 
2.51.2
