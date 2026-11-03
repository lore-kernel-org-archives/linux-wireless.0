Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793689953;
	b=4OFwy5aedgCNkxj1Ikd6ID5u5PX1mjRe92GKdVLnDUnqP+f7Lz5LZi5DkLd4R6fB6zSA
	 uJMguZ8A6kvYMKoChUXhwl3f68li8BJRXELEwJzr//3H2NtMZsqOzNAbUN7Nmf/4usK2G
	 tDD/t45gcaBbqvMiQo1ygaKhy8VEGjpAp8fNxoybDmIX77zehdngI9Q02PMbVbtp78d6X
	 t7X5y9ciOcIm6pEYBWMTVNMf7+df8J2K6gUx6Yvan0K58YW7n+RRFWoCJa1XepK6ZQOVA
	 P9CMjVSQCy7HGfnSh9Ky7p6tZkp1HvNowd5LgRS5C3+wKmkbJLsjzZKKc1c4NYOP9ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793689953;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OfIBFKcwgYoWAWNIWo9NR6YEedzia1O6UyxuCj2s0bE=;
	b=p2/O0RFy3w6T306CRsxv+n5pyxZfi/fCbSuxSriyULjMQG/uzbCfnh8vBNgz+F7jwXXG
	 6rMZ5fdrJ64ckBrZsYMQOxOZ3kqMydHHluewMq+rjC0nt9JKizusnCFH1rYxCn//rloDT
	 rSz2186dDXZRD9uwjaKPiAZRFvaQAKjzwVToWP07K4gr7smy3NyTg2xD8cwmxPe305fzH
	 3PQbgu3QOta9Zwvk3IRKahoTTFoR/XLZV2+E6zi15UApGPkLlu9sNGkzJioX7CpGyK+3C
	 DmE9+bR/mCvU7PCyti7HAWgD3N8pJS5t9cjcdL/507O7ts3ZrRrM7K2yivA2sag3mrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=remarkable.no;
	spf=pass smtp.mailfrom=remarkable.no;
	dkim=pass header.d=remarkable.no header.i=@remarkable.no header.a=rsa-sha256 header.s=google header.b=kRsKjm79;
	arc=none smtp.remote-ip=209.85.208.47
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FF1606A333
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 07:12:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 73FF1606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=remarkable.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=remarkable.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=remarkable.no header.i=@remarkable.no header.a=rsa-sha256 header.s=google header.b=kRsKjm79
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6b486e1d02eso4908930a12.2
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 23:12:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=remarkable.no; s=google; t=1793689952; x=1794294752; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OfIBFKcwgYoWAWNIWo9NR6YEedzia1O6UyxuCj2s0bE=;
        b=kRsKjm79ytPxadXo5CH3NIvr8cel/rIXkiblgrh3W/MZYOT0nOJxeRA2rBFJcfPAUB
         EwL4cCDPmYmcDbB+1hRXYIpAMrha4CjgiMcp26ysG/USdwJ4ep3BYpDaxlyIuvpudhc5
         A5upDAC6uoip5dEwx4HJiGuacaiKaHSVO/C+mxcOt+n3R7m4WsDv9p/HVu2riXl9UxKm
         Ds+N6SvIzJQr1AZxAYN7L61BaQXuA8HIcCXYnR0OArgRyUVM0LWhD3+AK6e9h4rIvHrE
         BbviA26cVfPn6Zud7ZNqTTN1+CdRv/hQi7tV3k2/Qk58shS1ieS9tiRO+Rh8nDhGEuK+
         AmnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793689952; x=1794294752;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OfIBFKcwgYoWAWNIWo9NR6YEedzia1O6UyxuCj2s0bE=;
        b=e/FNASOq0NqWD/Dpe4FflA4viXViuyIMO4vgUOeB4x10mVyntZK/G9hyj28asiooPD
         f2GxI+Owy0je2psTEslg3tGUdBESGpLql3rqDlLeVKUtJpaKhMHuCXgc4G1WosRLU5dX
         fpRZM4NQzVhuOamwoVbO53Lda59vDlRn/kbuCrkIytJFWG8aV/gQ7Cqc1l9vg2/+x6Or
         ujQQtrP+13JiCTscPWsSdfMZsSIffm7b21bUF9jaNQ6PO3gvb+R1Wk8zZ9TQHdfkzVeI
         B88KfLiHdRE9xqqVG8jig14+YjS6B3G8AIfAR9bnh2UENPwl0bFNrfDhomchczNmQGEv
         f2pQ==
X-Forwarded-Encrypted: i=1; AKwUvByGZR+W/MPiVz0I3v/jBe6qsuIL2wOEyRpoP5zINVNPvV8rmOacDbDc9AV3CStHvAf21WoA5gtNunFy82ibFQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z9Ak7WfKInzQHQ01DAqEziovx+waFxQFuXKGwQH5Z5QjwXkYLoS
	+7zgrHtMKyx0syaxhpEl2xohx4az6KcWo+ty6xVNzkVKlRj6epmax8huLCiq0Oys4YJcOdywfi4
	QdJMGWdU=
X-Gm-Gg: AYBFou2QnZFAYxGUFTorZP9pKHtoFgsCBf00d8xMo3203m3J153uesWZuZDpgLgeejY
	gbGPnubeUnhzlVwRal2r/V/uhx2UQ7a87y+HwlxpfUgprMh3Y2nwcMOKyz7GjZkSpItwe4NQlu9
	PuBqw1fS9RiCM8P/YFmMd1gxXJek5OrkgZCQB52JIMDSjHSfysog4rTRZ5wmhBUIYJ3VdMOE9qJ
	Ujag6rZ2BJR3dJRsQJTnuZki1c5k6GKNneQxtwiZTerSNP5CY1nTnEhRE9L3n0YFPdd4BXwjkHv
	j1s4F2fSyTMFMuogQ1ZsrXbyCCh+AWbpIWoma2ifabXIJLJLO7pQVDqv1cBtJ29i9PqWT4JbsV0
	JZvYMuB8HwSLMTezUzOwl/7vaFyJakYDNZfXSCNb3oM2uEvQjbEH06zVTasBoONMJgGYUSndBxP
	blicBzjLusj9lgb0SzwEn78kJZiHitVrGcC19SqBHivc3yqsFN4dnL7dp8qbWziJ4C7yAJsBA0T
	AfqOl+J+BVvcMTWg6NBlPOeDMuxGk0l2zJwfjxJspNDGJSJpt4Fdri++Wzd8ZQUx57lnDyM7fA+
	7dZKsPEXH9BULjgBe2fl0z+Du9deMmgO36bBBxwVuPG0
X-Received: by 2002:a05:6402:234c:b0:6ac:c618:8e76 with SMTP id 4fb4d7f45d1cf-6b4d4d6dc82mr8676361a12.16.1793689951912;
        Mon, 02 Nov 2026 23:12:31 -0800 (PST)
Received: from vkn-desktop.lan ([213.52.63.204])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b4ec9ee537sm3895470a12.10.2026.11.02.23.12.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 23:12:31 -0800 (PST)
From: Viktor Korsnes <viktor.korsnes@remarkable.no>
To: Jeff Chen <jeff.chen_1@nxp.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Viktor Korsnes <viktor.korsnes@remarkable.no>,
	Francesco Dolcini <francesco@dolcini.it>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless v2 2/2] wifi: nxpwifi: add missing header to HOST_CMD_CFG_DATA
Date: Tue,  3 Nov 2026 08:12:00 +0100
Message-ID: <20261103071203.1288146-2-viktor.korsnes@remarkable.no>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261103071203.1288146-1-viktor.korsnes@remarkable.no>
References: <20261103071203.1288146-1-viktor.korsnes@remarkable.no>
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

nxpwifi_cmd_sta_cfg_data() writes the parsed calibration payload
directly at S_DS_GEN without prepending the 6-byte
host_cmd_ds_802_11_cfg_data header (action, type, data_len) expected by
the firmware for HOST_CMD_CFG_DATA (0x008f), matching upstream mwifiex
commit 9868c4ce9481 ("wifi: mwifiex: Fix RF calibration data download
from file").

Add struct host_cmd_ds_802_11_cfg_data to struct host_cmd_ds_command,
populate the header before the calibration payload, and include its size
in cmd->size.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Assisted-by: GitHub-Copilot:Gemini-4-Argon
Signed-off-by: Viktor Korsnes <viktor.korsnes@remarkable.no>
---
v2:
 - No changes

Tested on i.MX8MM with IW611 (SDIO, FW 18.99.8.p136.0) using a 458-byte
calibration configuration file: verified via kprobes on
nxpwifi_ret_sta_cfg_data() that HOST_CMD_CFG_DATA (0x8f) succeeds
(result=0, action=1, type=0x2, data_len=458, size=472) and the firmware
parses and endian-converts all 113 32-bit calibration words from the file.

 drivers/net/wireless/nxp/nxpwifi/fw.h      | 10 ++++++++++
 drivers/net/wireless/nxp/nxpwifi/sta_cmd.c | 12 ++++++++----
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/fw.h b/drivers/net/wireless/nxp/nxpwifi/fw.h
index 124728a72442..d4fe29faedea 100644
--- a/drivers/net/wireless/nxp/nxpwifi/fw.h
+++ b/drivers/net/wireless/nxp/nxpwifi/fw.h
@@ -2375,6 +2375,15 @@ struct host_cmd_twt_cfg {
 	u8 val[];
 } __packed;
 
+#define NXPWIFI_CFG_TYPE_CAL	0x2
+
+struct host_cmd_ds_802_11_cfg_data {
+	__le16 action;
+	__le16 type;
+	__le16 data_len;
+	u8 data[];
+} __packed;
+
 struct host_cmd_ds_command {
 	__le16 command;
 	__le16 size;
@@ -2382,6 +2391,7 @@ struct host_cmd_ds_command {
 	__le16 result;
 	union {
 		struct host_cmd_ds_get_hw_spec hw_spec;
+		struct host_cmd_ds_802_11_cfg_data cfg_data;
 		struct host_cmd_ds_mac_control mac_ctrl;
 		struct host_cmd_ds_802_11_mac_address mac_addr;
 		struct host_cmd_ds_mac_multicast_adr mc_addr;
diff --git a/drivers/net/wireless/nxp/nxpwifi/sta_cmd.c b/drivers/net/wireless/nxp/nxpwifi/sta_cmd.c
index c2ab32fc8e12..2536bc34f0a8 100644
--- a/drivers/net/wireless/nxp/nxpwifi/sta_cmd.c
+++ b/drivers/net/wireless/nxp/nxpwifi/sta_cmd.c
@@ -1425,24 +1425,28 @@ nxpwifi_cmd_sta_cfg_data(struct nxpwifi_private *priv,
 			 u16 cmd_action, u32 cmd_type)
 {
 	struct nxpwifi_adapter *adapter = priv->adapter;
+	struct host_cmd_ds_802_11_cfg_data *pcfg_data = &cmd->params.cfg_data;
 	u32 len;
-	u8 *data = (u8 *)cmd + S_DS_GEN;
 
 	if (!adapter->cal_data || !adapter->cal_data->data ||
 	    !adapter->cal_data->size)
 		return -EINVAL;
 
-	len = nxpwifi_parse_cal_cfg((const char *)adapter->cal_data->data,
-				    adapter->cal_data->size, data,
-				    NXPWIFI_SIZE_OF_CMD_BUFFER - S_DS_GEN);
+	len = nxpwifi_parse_cal_cfg((const char *)adapter->cal_data->data,
+				    adapter->cal_data->size, pcfg_data->data,
+				    NXPWIFI_SIZE_OF_CMD_BUFFER - S_DS_GEN -
+				    sizeof(*pcfg_data));
 	if (!len)
 		return -EINVAL;
 
+	pcfg_data->action = cpu_to_le16(cmd_action);
+	pcfg_data->type = cpu_to_le16(NXPWIFI_CFG_TYPE_CAL);
+	pcfg_data->data_len = cpu_to_le16(len);
 	nxpwifi_dbg(adapter, INFO,
 		    "download cfg_data from config file\n");
 
 	cmd->command = cpu_to_le16(HOST_CMD_CFG_DATA);
-	cmd->size = cpu_to_le16(S_DS_GEN + len);
+	cmd->size = cpu_to_le16(S_DS_GEN + sizeof(*pcfg_data) + len);
 
 	return 0;
 }
-- 
2.53.0

