Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793549184;
	b=Vkp/bxfyj1x54Y2Hgkz2teCUf08z9XO6uwv7/11MTBBT3YluB5dUg31WWhSpxVlxH2EY
	 iKLDhWj5qk0in6C5KxxowH/A6shlTKMbK3iOZzgY141OdHoOz8JEPydfCLdobvlhO9KBj
	 vChwT4x2lUU5kVD5eXq3Mrk82Q6ajlMA/VqMNnL+A7hZ7dEdG4YrB4qreFTMqTEGs9dLO
	 Vob3p8NIfVFFwFxVERrlUTPHVLOPkzwQoOSVqpUDMaYVgtugdFyTXWHuM/3VLZEmGm2/W
	 pYq+28AAwMz8xWvKQlBTcO964nxppMbkGAQXkYVrPho42f+ADByWbNJ+sSvRdvweRuQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793549184;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=eRGWWGhx4P2qAtaaAXKvk7Nog5Hz8VCi7ow8vJBFAQE=;
	b=r7hk7J492ZFGvZs4roKnab8dSchoHO6fQEb87hmua3oA/0jY8/mBN/12SXOXCbF6TQSd
	 mnD367O8b3BF86j5LZy0K2p3oyni1nEL6QSp4gCU9b3vh6U2Zbva5cxxIjaL449/tpwjA
	 cLLnFI3xLkwdRlNcibw94J/Fert2maIrmz6E5UIzb8rokRuFJMmZXpKsDw4HadO9rJnHa
	 2d+zDeaCVyd+m2qSrHWt0ZPld1qZovzAzewXp0LoqtKSMJ2ABZB54T4xgCTzBBRwZGQrY
	 LoVgBdMVR20d+j4noJbiCRoEp0MQxtYG3KycF9Yftfyv+EZCnINHOJQ38GZFi4GHZcQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ph+E5Rpv;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C56606A324;
	Sun,  1 Nov 2026 16:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ph+E5Rpv
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793549183;
	b=XhgKXj9cJ0ZJUMDgtmZjqXZR6st6mP4cs7+kK8tKEwZmQz/gJXJF/1mPxHZsoHLhfHpD
	 thMHW4U9u/SijcF31JL3uc8UBoDvtkG/sMAJAUnfibsU0BmxKZPKqPUHlJkF7L4Zr6aaz
	 0GAlkOs5XD7BgNJw6X/EVAi57v76KSMwuPqthqe4blK5Wh+2Ax4arjWcI0gvDeQmEZ1cf
	 X3pJA+ZvRaedOJlp19y8DgX59uyJd2OclLu2KV0GFffMhVNhIsrqgtnQvXnS4jpgeoIUv
	 nf1aEc4ubcdj4XzjdBh31SFP4CuyMj1xZPMBl7TJwFulJSQ9hV/1nsRW7TCCNjt//eA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793549183;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=eRGWWGhx4P2qAtaaAXKvk7Nog5Hz8VCi7ow8vJBFAQE=;
	b=g/ZQmaFOfZYFvzWpqS9JMAy2u4LoW4ZgblmiJf4jVODTHSEZobb0TFrVebWWxPMkId+T
	 72Euar3KrHE7NNbpiKpmCMk4I2L0Qsg0vxNmFeGNjQNA+fmx9Bx2bI8x3Ko1TztU28nFe
	 98sjumZVT6lupGo6tupRBb+GADGc9/z6+gy9ZJi2+z9ImVlQYW7j5j0/UB3ORddt0C4wn
	 6q3DDdtz96Myz1w847uhh7D44qsyts/tPL4xsJlAJRRd6qmOs7B0Twx2npDgz38aytcB5
	 YTFZD5+gOsHnAyiYJIE007kD+cJTGNXaFIq0EsKdpK6DbkTudTBreXjfjetGdTnLmjg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 26BB51F000C1;
	Sun,  1 Nov 2026 16:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793549183;
	bh=eRGWWGhx4P2qAtaaAXKvk7Nog5Hz8VCi7ow8vJBFAQE=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=Ph+E5RpvrZl8qamsd+ujCZ+QpTReY6f+BIhFiG85T5/qTB5MTb8elCFG28KAWqAh2
	 vjcCTIk1mFJkQUwvEB+zvk3z6nQo+wGojfEVWD7ch1+7gLLsqhOXQlxsg5K5aZ4LUp
	 R4yCHfZYQHMW9UwpVqjLUtKyEH3dCv36I+GTGbVLSz8ltsl38UuhLkpsES/Y6LaBLu
	 K+Xx8Ff05MkBbeNvsYS/MJRSVGBDeP3aEUXJGjWuE2Y+hYQeplDXPKzyvsPJYV+hCe
	 RPtyYdBaJg9yvG7jKEi8EIx4rfCj7Z4mg6/zJtqvOLhabirymDDW9a86P258B+p/E3
	 HZl9ZcQQQnONg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 7F8D9461DD;
	Sun,  1 Nov 2026 16:06:22 +0000 (UTC)
From: Christopher Griffin via B4 Relay <devnull+christophergriffin05.gmail.com@kernel.org>
Date: Sun, 01 Nov 2026 10:06:23 -0600
Subject: [PATCH ath-next] wifi: ath11k: look for firmware-N.bin without the
 user-space fallback
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261101-b123-fw-api-n-direct-v1-1-a9b734520abc@gmail.com>
X-B4-Tracking: v=1; b=H4sIAH5j52oC/yWMwQrCMBAFf6W8swvZBBX9FfGQpBu7HmJJohZK/
 92ox2GYWVGlqFSchxVFXlr1kTvwbkCcfL4J6dgZ1tgDs2EKbB2lN/lZKdOoRWKjozuZkPZJYnD
 o6Vwk6fLbXuDbRFmWhuvf1Ge49+h7xbZ9APsX/sCCAAAA
X-Change-ID: 20261101-b123-fw-api-n-direct-7390bf5fecb3
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, 
 linux-kernel@vger.kernel.org, 
 Christopher Griffin <christophergriffin05@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793549182; l=2493;
 i=christophergriffin05@gmail.com; s=20261024; h=from:subject:message-id;
 bh=7FihErGI/rxuO2qBCwtRnH7nsLSwQjP+NG+2mzhjaCw=;
 b=h5I/GzmP40OJbuvR6vdmnMCQvlkWlbMBtyvvZuVKywePUAm6injCk7McFvQia3eyFTa035Mz2
 +DeBUl+boJqDIyAJvZC0EQ9KE88czoNVyp3pgM0+Oi68FG+UZlGNV89
X-Developer-Key: i=christophergriffin05@gmail.com; a=ed25519;
 pk=oa9tkTNpiGoFWdGvpDHXLSobApmsh9BfrJRJrRJAvWA=
X-Endpoint-Received: by B4 Relay for
 christophergriffin05@gmail.com/20261024 with auth_id=1309
X-Original-From: Christopher Griffin <christophergriffin05@gmail.com>
Reply-To: christophergriffin05@gmail.com
Content-Transfer-Encoding: 7bit

From: Christopher Griffin <christophergriffin05@gmail.com>

ath11k_fw_pre_init() asks for firmware-2.bin through
ath11k_core_firmware_request(), that is firmware_request_nowarn(), and
falls back to API 1 when the file is not there. The file is optional,
and many installations have none: on an Arista C-360 the QCN9074 runs
from amss.bin alone. With CONFIG_FW_LOADER_USER_HELPER_FALLBACK, which
OpenWrt sets, firmware_request_nowarn() still hands a missing file to
the user-space loader, so every probe of such a device waits on a
uevent and its answer, and the loader logs the miss; when the device
goes away before the answer, as when it is unbound right after probing,
the loader then fails to write its answer:

  procd: Failed to write to .../firmware/ath11k!QCN9074!hw1.0!firmware-2.bin/loading: Bad file descriptor

Request it with request_firmware_direct() instead, which looks on the
filesystem only, as ath11k already does for the optional calibration
file in ath11k_qmi_load_bdf_qmi().

Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.5.r4-00683-QCAHKSWPL_SILICONZ-1

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Christopher Griffin <christophergriffin05@gmail.com>
---
Seen on an Arista C-360 with OpenWrt: its QCN9074 has no firmware-2.bin,
and its scan radio is unbound right after probing.
---
 drivers/net/wireless/ath/ath11k/fw.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/fw.c b/drivers/net/wireless/ath/ath11k/fw.c
index ef1b4c81843a3..3628e33e57f6e 100644
--- a/drivers/net/wireless/ath/ath11k/fw.c
+++ b/drivers/net/wireless/ath/ath11k/fw.c
@@ -16,10 +16,14 @@ static int ath11k_fw_request_firmware_api_n(struct ath11k_base *ab,
 	struct ath11k_fw_ie *hdr;
 	const u8 *data;
 	__le32 *timestamp;
-
-	ab->fw.fw = ath11k_core_firmware_request(ab, name);
-	if (IS_ERR(ab->fw.fw)) {
-		ret = PTR_ERR(ab->fw.fw);
+	char path[100];
+
+	/* The file is optional: look for it on the filesystem only, so a
+	 * missing one does not go through the user-space fallback loader.
+	 */
+	ath11k_core_create_firmware_path(ab, name, path, sizeof(path));
+	ret = request_firmware_direct(&ab->fw.fw, path, ab->dev);
+	if (ret) {
 		ath11k_dbg(ab, ATH11K_DBG_BOOT, "failed to load %s: %d\n", name, ret);
 		ab->fw.fw = NULL;
 		return ret;

---
base-commit: a3ddbb45768717b5c9f923489387cf55c838d1ad
change-id: 20261101-b123-fw-api-n-direct-7390bf5fecb3

Best regards,
--  
Christopher Griffin <christophergriffin05@gmail.com>


