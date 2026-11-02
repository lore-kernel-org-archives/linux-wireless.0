Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793621980;
	b=XE1SEnl9dKJ4RqIkxrLUk/0sFcyKF852MQydEMxO7/sh0KxB3YQj+/LGx73RzBNZPU46
	 AefChWt4NEgLa7x94MvIvR0lvFyJg+9my/y2t+eEoTrSyU8hSgfG0JBMlddnEneFcQptJ
	 3cycSaeeUzli/EB37hjzAnCiDy3DwHa3yy3Ggb6UdJyQPywPO5gFxdnDxLEWFPAvpNJgV
	 596lldyooM8YbfVGEkgrNwDdZ00fNvfjW7QKkwJxxmavD4wvt/3nngXBY7lWiQqO4Qi7N
	 +aI06ulQznosDrZ59qbt199wzFzxpVrS8+HYrSakNBV3AtoVT9+dPO3vtsKZkVKQkSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793621980;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TsQ7SUUVHUQq2PWgfT1D050Y58fUNisV6VpQiBCfSZE=;
	b=HfLqHH2LqMd6OBas0mBZtVIQ51R2ifOrOu/qaSUoGFKhnWEnoojVoWzCma9QzHy9S2yQ
	 hsupWKpg3iAktlqctCALv3yxFqVE3Si5R14Lvnhum9asd3fKk4eQQqDrrS+Rg21saD3Ux
	 Bb/oqZcZMIm0F1fU8Zfdzkg0Zk9J0dxoa7hckcsTH4oSzMKTNEGQGYzKbXLk+27D9fbsO
	 dttQcY3cY132Wl3bxosJhlYX87t/4dMgu1A5e/JBb/wb3Ut+ZfE8L8iNuTtj/DABBmyWk
	 +BjwKhIrYT0aBX2bWn+C6jF/fOdCZwkZXsoAu8leX4ldLhdrkgoxt07zb4XKprNoVKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=remarkable.no;
	spf=pass smtp.mailfrom=remarkable.no;
	dkim=pass header.d=remarkable.no header.i=@remarkable.no header.a=rsa-sha256 header.s=google header.b=T+nUEvAH;
	arc=none smtp.remote-ip=209.85.218.43
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA4E606A324
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 12:19:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5AA4E606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=remarkable.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=remarkable.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=remarkable.no header.i=@remarkable.no header.a=rsa-sha256 header.s=google header.b=T+nUEvAH
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c4682977f9aso352466666b.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 04:19:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=remarkable.no; s=google; t=1793621979; x=1794226779; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TsQ7SUUVHUQq2PWgfT1D050Y58fUNisV6VpQiBCfSZE=;
        b=T+nUEvAHPgsmmnOiDE/slWiMw7Q736AfYFblYaMMERMPiAVPBXi3j8Vde+z/lQat9d
         vQtWYeEzVjWhdoMqOVG5aUt+HoaAUyxiAZRjSoUgcmn2tvOTTmGmdVPrhlzFgpR8wHX9
         4sF2ItwkKBC/wn+2mjfokBS2ByAJcsgy45LVDP+LvG+93jSb4dF8qF/O6GuPWryadNgN
         zg0xzzgikzCJgDPbZ4kybdiQIyGz7Gnf8i4UJGYjMm001oOhvLdynUlCc2zVcnqgc2y0
         9Gmvv3/qsZoj+UbKoIh4UHjeqnJagny6e3O+90nUb7Nf/PKZYzPG6c/hdlCiSiTPGpoX
         OBKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793621979; x=1794226779;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TsQ7SUUVHUQq2PWgfT1D050Y58fUNisV6VpQiBCfSZE=;
        b=axvfdoWdGsoBiHwQo/SmtHPid71WXBoaG1HeNy3MwoQ+UOrC7Lgx/spgPvyormWCFQ
         +b8riGa2vspFHZkwfthoecfXdyrBSxAtcLbLIrejl3nQnpq/bJf6unSCJnCBBrD8JP+i
         CcgX7Ru3Pk8aivJeY6TrClZ280wzDuU/HJf0zNHfbvuLUfoHdJlLkDPW31+cfbkR2yLY
         vOXcgn/AwhrWQAEnmQj1Fk7qxqKeomVGyFJ9rXIh+jJG9Dfo5rcggVkMAH+HL1cF8OeW
         l8TRZLhJeOCsh3P9KTxLiS8ffEiEsRNuDuZ+er+Kyj4z5XxDCvimKflkQSgm1ZH6sqct
         Qhvg==
X-Forwarded-Encrypted: i=1; AKwUvBzzQhe+UUVLXJbqZ+tMMh9PahQdCUzCpW1aA3to37VYRm86WczEJP9Hd/ISfaYh3IfVBns0s0yyxhK69BE7Sg==@vger.kernel.org
X-Gm-Message-State: APuU4Z+ajCCONrRPjKFwjrK2HZIxdqDkgp4VYZRIHidCV5eTPse8igFb
	gX6ujydXZOPx3OMYGPqE0nfUpByrli7yAWBUVA1FFZ7y/tQ+ob0oPTvSNzrXWSTGr9U=
X-Gm-Gg: AYBFou1m7YD31sEV4iiTdAhf5KI4HXG6Kimh1IQRPnxq3GBp+jTSssxG5j9Idk3CawW
	O4rpMMDAPg0Lj4gaUClzx3aENiXclsuq/ZZpOIgRVCEw4JzoXafyU8aVitOxVpbHlZzLRSgIE8D
	910DUO0RW+JmlHaZZ+KsHits8kfVy700kzqdxcWo6dOycEvArx2ZfhBiL5TO7NXyqTkKP3djwi5
	GzAccmirIH6m3WSXNYuofiHOl/CmyRmOvQPFdYOHdxwVPEapv89xTbRA500cKpQLSS0BUJxSlGz
	vxbDvA4pbLXUfv+G7oYOw97kzwLhrGF+k5PIJDoIhGY0747p+VHgdlKO0f4C7W+7XwgQVIANHSX
	tWh8h/wRkAAGA3jDMBoL9RJqnW7gsbsjZIF2iR6aRONYVgrJLQU6Ak9G4hPw/tGcl6qvkkxGF6S
	UmJvf2kLRAnoYYStXJ6EwFjbQP0PAd1vvq1ZQJ1bOJparezXdKQLvjlB0N+eXJDhuzvikw5TET4
	e3DVqbKQ0AZ49W4VAtA5DjhpIm8QlFt/2AmPTtTjfZvURPGUAx99GnB4ca42tvn+wXAas5L2eCJ
	FCzMik+Dvyo6h9p7wXZsHdO8f52fZYPM+41WwgMEk6fW
X-Received: by 2002:a17:907:961a:b0:c31:91f9:60b7 with SMTP id a640c23a62f3a-c4ca7a69731mr830226366b.34.1793621978663;
        Mon, 02 Nov 2026 04:19:38 -0800 (PST)
Received: from vkn-desktop.lan ([213.52.63.204])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4cabcfd22bsm378293666b.28.2026.11.02.04.19.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 04:19:38 -0800 (PST)
From: Viktor Korsnes <viktor.korsnes@remarkable.no>
To: Jeff Chen <jeff.chen_1@nxp.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Viktor Korsnes <viktor.korsnes@remarkable.no>,
	Francesco Dolcini <francesco@dolcini.it>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless 2/2] wifi: nxpwifi: add missing header to HOST_CMD_CFG_DATA
Date: Mon,  2 Nov 2026 13:18:00 +0100
Message-ID: <20261102121856.1011263-2-viktor.korsnes@remarkable.no>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261102121856.1011263-1-viktor.korsnes@remarkable.no>
References: <20261102121856.1011263-1-viktor.korsnes@remarkable.no>
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
index f3cd5a51c438..a62ea7b9dc07 100644
--- a/drivers/net/wireless/nxp/nxpwifi/sta_cmd.c
+++ b/drivers/net/wireless/nxp/nxpwifi/sta_cmd.c
@@ -1421,24 +1421,28 @@ nxpwifi_cmd_sta_cfg_data(struct nxpwifi_private *priv,
 			 u16 cmd_action, u32 cmd_type)
 {
 	struct nxpwifi_adapter *adapter = priv->adapter;
+	struct host_cmd_ds_802_11_cfg_data *pcfg_data = &cmd->params.cfg_data;
 	u32 len;
-	u8 *data = (u8 *)cmd + S_DS_GEN;
 
 	if (!adapter->cal_data || !adapter->cal_data->data ||
 	    !adapter->cal_data->size)
 		return -EINVAL;
 
 	len = nxpwifi_parse_cal_cfg((u8 *)adapter->cal_data->data,
-				    adapter->cal_data->size, data,
-				    NXPWIFI_SIZE_OF_CMD_BUFFER - S_DS_GEN);
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

