Received: from mail-pz2-f42.google.com (mail-pz2-f42.google.com [74.125.228.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D731AAE28
	for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 03:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789615456; cv=none; b=uUiW3wMHVU71k5RtN6BLip1PO9/LEw6eyHXJHL6Z8wOm/OzPRHagH5O+VPGZSpZtWlGlBFQjVSIt+BVl2N/5jTaAN/ncWRfRxe5owJ3E+r1ZqgaQjLp7aaFowobxJ2UtHhetr8eri/SD35w/RokiRNvtGBksOc1RtHsEBsE9NZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789615456; c=relaxed/simple;
	bh=GuXG2EIcjzllydOc5zvT2hZIRsG7nIywx5OIoq6KjDs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=utDSHZKJne3JZD783qvzvw6oE9d5aTyEZxu+rYO2HMa8BPkuzuH+fPTBYYpbuCcFf+UREM0zUEEebByRdfE8cmFtpAYwYQeCeg9RTIAJ1uwxrrTiNGtOOgQpEO6TZn2lxQaoIClj2CRMCEf6NANW1R/ElUKnYZye3QUc6KmvdAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZHBR5hx4; arc=none smtp.client-ip=74.125.228.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZHBR5hx4"
Received: by mail-pz2-f42.google.com with SMTP id 41be03b00d2f7-cc4cdc0d663so204561a12.3
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 20:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789615454; x=1790220254; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1NNWZlKKsVRPy9Y6wZOFaXfYNTRAOARCiCc5K15uD0g=;
        b=ZHBR5hx4NiAhI3lcTNy32qVjIpwgnUg4cX/9p1X9AvvB4EoIu7XUCJPsH05CI8rZcx
         xnnUSKBYoCn8CJj8PfqQvbi4bZZXyCFJGw5Pc8SNXrV2LIt90gAeO0m3zpQ8nLUNFJbL
         8OQpLakVHBVwgHr20KN5YtTk23vHYZ4rJBq+y4mTa95/WkUMpbtgSLtnm6qskyziUtL5
         FjnygMmtzI0irGj6VLcukyzk45xZXLwDD18Kl6s+js5cBziWZpadi7quIfNWJpdC4JrD
         Jhvelslun7sdFviRDCPEV2wn5xACIJIlY/MKd7asSY0jDfolepBTCpzG5q8C8FDfsiwi
         VdcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789615454; x=1790220254;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1NNWZlKKsVRPy9Y6wZOFaXfYNTRAOARCiCc5K15uD0g=;
        b=ieG9ij95S7jXQd4z25S1WGSXDrOegLBtW5hHTTxPTOljU/4oGbtBnPes0QFnA+2w4A
         /c8RtiXFDPbB/iBufsPMLekGNl4xz/E1TECm4B9QwdpxMSP5wBTu2wczN76lGiIu0lWN
         /C8ECyqDqilFblhgxGttpm80nnWCdDiEdi0nYdClViNLuH46a2GU5IOWDGaQHurQ9pDy
         sTpyRqeKYkJIZhb10ew1B4wmy7g8aA3GqLa1dsJMRdTg3xrE1WOZtEOhAmEq3mFd0GNb
         MX/GxWkQnAWLW43j49jgquWdCIQx88lckwz17CiNRvU0h7S9MFXL61wtxCYmP3VY0FCR
         TNow==
X-Gm-Message-State: AFuF++ndO8JlOaDb3RDRBqwdPKEhH1q44ymjxwCncWQSVFkmkjr79rk/
	thB4PVq4LunCzUKWg8SJmM34Wj+HrHRD1tgyIiBDTuBIvGBGd7SOS/OHePlCMUPj8PE=
X-Gm-Gg: AYBFou0MoToh2eKB5hPxOu1TRIb+1l3AdBUAcrB8AOrP4JznR4fS7qR/6V/jVHWaU+P
	hqIe0HUvxsSdOGOOl69/4ONqQ2RFPUmEq+rglwtD3Q9TjeqZRjr5Jp4WLNYm1cqZnQOAtP+tuHM
	IeXX5hds6xo6H9xb1PT810qDhFDB54md0lsP6RJr13GEwwOyXF60lpwERG8m+6YwulqGuF7esCh
	3ryIG+8SNfLOt/fXBVJbGKyXoUad61FuHX3SI7Fauo2Lsa3SA6LZm3cXhneZJgmM7JYTYMMfki8
	Wd6HvdJZU8/8CEq1J9VB5QLA0G41R5+d6TahSON++oVIuM7Je7MkyceOcV0Y+6K30Zp+leVlarF
	YoLBp3IFUBFgWXzXv8OHbxmYuydDTKkuuq7XEBIo8CN46P4bTuONhkuG6FDw3j2bcZuOt1ztLoF
	2emuDtITkcJPhxlWt2Y0hTqVAQn3/3iT05uvd+T0TCxY4VgNCm6Pn/b5NkSKtlKmU77vRx152n2
	CKUXA8ZyEWaMO09ggjs4Tor6hujR8r1dCkXJRVD6/QWyGNUz0sggTHt1igjj2OQV5M6MO4LlVS7
	HkAIb14ONgDI24XOFoR1Ul+L
X-Received: by 2002:a17:90b:258f:b0:39d:b1bd:b384 with SMTP id 98e67ed59e1d1-39e1e4da87emr12104404a91.17.1789615453866;
        Wed, 16 Sep 2026 20:24:13 -0700 (PDT)
Received: from nxpwireless-Inspiron-14-Plus-7440.tw-tpe02.nxp.com (61-228-239-50.dynamic-ip.hinet.net. [61.228.239.50])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e3610bb35sm2538162a91.17.2026.09.16.20.24.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 20:24:13 -0700 (PDT)
From: Jeff Chen <chunfan.chen@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lukas@wunner.de,
	briannorris@chromium.org,
	johannes@sipsolutions.net,
	francesco@dolcini.it,
	Jeff Chen <jeff.chen_1@nxp.com>
Subject: [PATCH] wifi: mwifiex: append hotfix number to firmware version string
Date: Thu, 17 Sep 2026 11:23:50 +0800
Message-Id: <20260917032350.2323119-1-chunfan.chen@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jeff Chen <jeff.chen_1@nxp.com>

mwifiex_ret_get_hw_spec() parses and logs the FW_HOTFIX_VER_ID TLV,
but the hotfix value is not stored in the adapter structure. As a
result, the hotfix number never appears in the firmware version string
returned by mwifiex_drv_get_driver_version().

Store the hotfix version from FW_HOTFIX_VER_ID and append it to the
firmware version string.

Assisted-by: LLM sparse
Fixes: 7715d79553de ("wifi: mwifiex: Support firmware hotfix version in GET_HW_SPEC responses")
Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
---
 drivers/net/wireless/marvell/mwifiex/cmdevt.c    | 10 ++++++++--
 drivers/net/wireless/marvell/mwifiex/fw.h        |  6 ++++++
 drivers/net/wireless/marvell/mwifiex/init.c      |  1 +
 drivers/net/wireless/marvell/mwifiex/main.h      |  1 +
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c |  3 ++-
 5 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index 29e0f274575e..268a795db486 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -1594,11 +1594,17 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 						    api_rev->major_ver,
 						    api_rev->minor_ver);
 					break;
-				case FW_HOTFIX_VER_ID:
+				case FW_HOTFIX_VER_ID: {
+					struct hw_spec_fw_hotfix_ver *hf;
+
+					hf = (void *)tlv;
+					adapter->fw_hotfix_ver =
+						le16_to_cpu(hf->hotfix_ver);
 					mwifiex_dbg(adapter, INFO,
 						    "Firmware hotfix version %d\n",
-						    api_rev->major_ver);
+						    adapter->fw_hotfix_ver);
 					break;
+				}
 				default:
 					mwifiex_dbg(adapter, FATAL,
 						    "Unknown api_id: %d\n",
diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index 93561116959a..f254d6d6e3eb 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -1104,6 +1104,12 @@ struct hw_spec_api_rev {
 	u8 minor_ver;
 } __packed;
 
+struct hw_spec_fw_hotfix_ver {
+	struct mwifiex_ie_types_header header;
+	__le16 api_id;
+	__le16 hotfix_ver;
+} __packed;
+
 struct host_cmd_ds_get_hw_spec {
 	__le16 hw_if_version;
 	__le16 version;
diff --git a/drivers/net/wireless/marvell/mwifiex/init.c b/drivers/net/wireless/marvell/mwifiex/init.c
index 0c8925013724..e8a5f9b758d6 100644
--- a/drivers/net/wireless/marvell/mwifiex/init.c
+++ b/drivers/net/wireless/marvell/mwifiex/init.c
@@ -296,6 +296,7 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	adapter->config_bands = 0;
 	adapter->adhoc_start_band = 0;
 	adapter->fw_release_number = 0;
+	adapter->fw_hotfix_ver = 0;
 	adapter->fw_cap_info = 0;
 	memset(&adapter->upld_buf, 0, sizeof(adapter->upld_buf));
 	adapter->event_cause = 0;
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 8e6238c01aa6..5dd01bacc7cb 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -1003,6 +1003,7 @@ struct mwifiex_adapter {
 	bool host_mlme_enabled;
 	struct ieee80211_txrx_stypes mwifiex_mgmt_stypes[NUM_NL80211_IFTYPES];
 	u8 fw_api_ver;
+	u16 fw_hotfix_ver;
 	u8 key_api_major_ver, key_api_minor_ver;
 	u8 max_p2p_conn, max_sta_conn;
 	struct memory_type_mapping *mem_type_mapping_tbl;
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
index 19196848778c..1d3874734851 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
@@ -1144,7 +1144,8 @@ mwifiex_drv_get_driver_version(struct mwifiex_adapter *adapter, char *version,
 	char fw_ver[32];
 
 	ver.l = cpu_to_le32(adapter->fw_release_number);
-	sprintf(fw_ver, "%u.%u.%u.p%u", ver.c[2], ver.c[1], ver.c[0], ver.c[3]);
+	sprintf(fw_ver, "%u.%u.%u.p%u.%u", ver.c[2], ver.c[1],
+		ver.c[0], ver.c[3], adapter->fw_hotfix_ver);
 
 	snprintf(version, max_len, driver_version, fw_ver);
 

base-commit: 3b35f726c20d138fafa154182ee926a419306269
-- 
2.34.1

