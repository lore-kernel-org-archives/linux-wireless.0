Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793621974;
	b=QhVj7Ayd8MnuXSd3YqYyZX713IvXIaNmP5H4RAtyo6voGvbKZb3PYYCDuZfqa2TJSZAa
	 9Cz/hD5XZC4WLjWjfQMzTHeapoqGIgkuJ08bZLF3JW5g28lKz4S6FmG7yne55+M/NsPU8
	 OyOLtFflx0M2cF709FZXWRWHqMBRD3v1uY0n0Ok+WBOI1YQz6Bsp4yLAw8FpO05eZbjVG
	 thou80haexArDUp10C7XdhDCqPyg33XTNx1xo/W33mX0DsUOqMcJxCpTl6OeoaGowXS1W
	 Cd4FJFd4OivDDUxTHp4g01zxaZUs1pazdyz9YsO2K5xAodAvYSfInhQGfIRWJZ2CyfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793621974;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=NOwKFTDoEguLb3kIIHfznAhArwn4FDch8KZcfkKCFSQ=;
	b=cvsQLyUofo+UEZ7t4v2C9r1duZ5HNcGrlnmEMdMp+IfAO3Hxjgc5tJtm69glMEJB8mt5
	 yN6xL/8c6plDv0MVD82ct5e0nE/WzAkmIqSMfZqEvouqBP6tfTbAR99zSCBJpnKIQRsL5
	 2rko1j5xCWDPPZ6pRqc/CmUfxHw4JbhnDjNvVZnokY0bda/6/5Xb+4lon6JzgoKcLmA0o
	 aEoAnXHreeQ6G/6fgyJROv29vtPrmKKBLpOy3kT4jcbdqGZ3d1qbwdyOVs8WVjVv6f6cg
	 CWpHGnkl1wyeLBH43GzZdjrMQ3dsdmaYusR/QwK/Z8uAR50CpUk/SjxaUp8XLTiBGog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=remarkable.no;
	spf=pass smtp.mailfrom=remarkable.no;
	dkim=pass header.d=remarkable.no header.i=@remarkable.no header.a=rsa-sha256 header.s=google header.b=FyN4u5Aq;
	arc=none smtp.remote-ip=209.85.218.45
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32769606A84C
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 12:19:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32769606A84C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=remarkable.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=remarkable.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=remarkable.no header.i=@remarkable.no header.a=rsa-sha256 header.s=google header.b=FyN4u5Aq
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c414e5d282eso344188066b.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 04:19:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=remarkable.no; s=google; t=1793621972; x=1794226772; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NOwKFTDoEguLb3kIIHfznAhArwn4FDch8KZcfkKCFSQ=;
        b=FyN4u5Aqva1CpQZyIrjtbRqokvPeaCfdwazIeEWS+Q6H1J1wVqsjWNQR5bECcBlnr3
         yExLuqdVEPM7ILYbZszmI3/buLIiZnKtyjQiElIdX3FpsWXkEPuWqWh+SFYeWtUr06KJ
         gFqzUSaHCl5cn9AhALgmanUIDciCdHRPXwhqz/7sUyII0h/ire/a48OY+10Uhch5ZECT
         Ruu9pk7lRo3Z6fA69Z6aTDtonMzD/1otKa8YJXYk7hlSTlrKEiSVhWjzceFGMcFsEpVF
         eKcqWvhgzh0BNlf/TP+DBjFojFhnGE2KL55UaGAZf8YgtDAoNBsWjkDReDhy9ccqGAVv
         StYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793621972; x=1794226772;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NOwKFTDoEguLb3kIIHfznAhArwn4FDch8KZcfkKCFSQ=;
        b=hWCbXYP8S4TOn8p+aPu+nmPiVHUn2HDl9r4gXpDHHWVT+nLrHHKFmIpA1SvyCfrL4F
         g7PFW44pXIaCIU7Drf/0AZtQNBXu2ueAmcbMis0kZoqC7/4Ey/jzx/4to8p59aqPgbPs
         d7ZKv3+Fv796EZePJPgxYiYiHz+IGBQy5sgz9cP6+4+TN3h2aIpgd7/Yb1Aq1F5kXV+z
         Oz/wuzVQ+i1YulyqZdB4HgfHBg9NyuSzKnLkVkVSlUKzmfpp76USgnwa2s7Vd+Ub/b2T
         iIQYHJM/aEfaxU4ybTGSDej1zvZMTGVzChYgiZx8tAeof6JUCrgu1bRMki2B/heNMaOG
         qneA==
X-Forwarded-Encrypted: i=1; AKwUvByE9nBvgZyprqKMU19/SPYXipPKykrTpyzJbhiyEgS8eqWvg5Ils3Fgllhq052FXqtQCB76Q4avt+mGvs3bXg==@vger.kernel.org
X-Gm-Message-State: AFq9FYJ+/2ytJsIwdbUyHfLEv91qjhd8OJV0hJ/W+uql77sjiF/Auxqa
	1IdfR6wulELAsDc1qGwoHMbYe0gWPjO19Qfb92aVeIbSh8ERylQ+FV3lyDH6P34Q+cs=
X-Gm-Gg: AYBFou0S0AsqKSPDLciwXLAyGS+P3wGGoAijdSHfhB+S3JhGNQKB5YJP3NYx1nWiTpd
	1c4BeC+jY+yAOmdy5SMI8FW63V9YbjheFWiRFWCCwxaejN0TDuZ3hpbH1/rO6fQOmaicjux/bKd
	YGXlkFSsZhGt/ZCZP0zJmF4IHnlVHDphnHOR1mp38c9whezdBAizWSHqsKdC00vJpS36wZ/M0oW
	hJZj/WBVZ6zZ5gKKXhMM74F7Priv1ngs8sVvSkuNNeqGT6fj22wtXH4uboH4HVNpgosCqBoXcUi
	+FPFD2c66UPbZHXTCP0QMacS/IXwqNczVd0oNPKf8cp+Evgpp2C4dlOfHHnnRIT/ppRnFPwFXO8
	h58JXv1tP3AVwCkxilbcvwKtR5zqLswAmMpp8Jdmg/C81yo6z5XrhgknpDONHo8nbGtNtxkM+OC
	mve3W38i9r0KCOGkyYtetZzDpqSKpebJb+J9FmQMIAxgvWPogdliX1P5opp2qUgsbi5Nq0NiiEP
	x5rJjF/bHr0Q5V5r/RnWrx9NeqGECqXg1cbjfYvdO7w5bV12MSJkWV3HSlBIjp+DoYES4hz5eI5
	2pqKdlqTH0HtC6y5Twh5UwxKrD4XEZdfQNeW6l4TTjPf
X-Received: by 2002:a17:907:7294:b0:c42:fc8b:6c7a with SMTP id a640c23a62f3a-c4ca7b601d3mr772506666b.41.1793621972466;
        Mon, 02 Nov 2026 04:19:32 -0800 (PST)
Received: from vkn-desktop.lan ([213.52.63.204])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4cabcfd22bsm378293666b.28.2026.11.02.04.19.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 04:19:32 -0800 (PST)
From: Viktor Korsnes <viktor.korsnes@remarkable.no>
To: Jeff Chen <jeff.chen_1@nxp.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Viktor Korsnes <viktor.korsnes@remarkable.no>,
	Francesco Dolcini <francesco@dolcini.it>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless 1/2] wifi: nxpwifi: fix hex parsing in nxpwifi_parse_cal_cfg()
Date: Mon,  2 Nov 2026 13:17:59 +0100
Message-ID: <20261102121856.1011263-1-viktor.korsnes@remarkable.no>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nxpwifi_parse_cal_cfg() passes a pointer into the raw firmware buffer to
kstrtou8(). Because kstrtou8() requires a NUL- or newline-terminated
string, it fails with -EINVAL as soon as it encounters a space after the
first byte, causing nxpwifi_parse_cal_cfg() to return 0 bytes.

Use hex2bin() instead to parse each two-character hex byte, bound the
output buffer to the command buffer capacity, and return -EINVAL when
no calibration data is parsed.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Assisted-by: GitHub-Copilot:Gemini-4-Argon
Signed-off-by: Viktor Korsnes <viktor.korsnes@remarkable.no>
---
 drivers/net/wireless/nxp/nxpwifi/sta_cmd.c | 23 +++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/sta_cmd.c b/drivers/net/wireless/nxp/nxpwifi/sta_cmd.c
index 5e8ffd306b31..f3cd5a51c438 100644
--- a/drivers/net/wireless/nxp/nxpwifi/sta_cmd.c
+++ b/drivers/net/wireless/nxp/nxpwifi/sta_cmd.c
@@ -1391,7 +1391,7 @@ nxpwifi_ret_sta_mem_access(struct nxpwifi_private *priv,
 	return 0;
 }
 
-static u32 nxpwifi_parse_cal_cfg(u8 *src, size_t len, u8 *dst)
+static u32 nxpwifi_parse_cal_cfg(u8 *src, size_t len, u8 *dst, size_t dst_size)
 {
 	u8 *s = src, *d = dst;
 
@@ -1401,7 +1401,8 @@ static u32 nxpwifi_parse_cal_cfg(u8 *src, size_t len, u8 *dst)
 			continue;
 		}
 		if (isxdigit(*s)) {
-			if (kstrtou8(s, 16, d))
+			if (d - dst >= dst_size || src + len - s < 2 ||
+			    hex2bin(d, s, 1))
 				return 0;
 			d++;
 			s += 2;
@@ -1423,14 +1424,18 @@ nxpwifi_cmd_sta_cfg_data(struct nxpwifi_private *priv,
 	u32 len;
 	u8 *data = (u8 *)cmd + S_DS_GEN;
 
-	if (adapter->cal_data->data && adapter->cal_data->size > 0) {
-		len = nxpwifi_parse_cal_cfg((u8 *)adapter->cal_data->data,
-					    adapter->cal_data->size, data);
-		nxpwifi_dbg(adapter, INFO,
-			    "download cfg_data from config file\n");
-	} else {
+	if (!adapter->cal_data || !adapter->cal_data->data ||
+	    !adapter->cal_data->size)
 		return -EINVAL;
-	}
+
+	len = nxpwifi_parse_cal_cfg((u8 *)adapter->cal_data->data,
+				    adapter->cal_data->size, data,
+				    NXPWIFI_SIZE_OF_CMD_BUFFER - S_DS_GEN);
+	if (!len)
+		return -EINVAL;
+
+	nxpwifi_dbg(adapter, INFO,
+		    "download cfg_data from config file\n");
 
 	cmd->command = cpu_to_le16(HOST_CMD_CFG_DATA);
 	cmd->size = cpu_to_le16(S_DS_GEN + len);
-- 
2.53.0

