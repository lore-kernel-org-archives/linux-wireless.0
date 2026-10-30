Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793398120;
	b=DW37R9ByR7ZB9LtLCbyey+5NpzblYGiwCAS8WCSbNPn8BD3VDCy0OE4xntKf7zVG3BBT
	 vf8lOck8u3LY/kd3GX77zCNRdZ3EpWPSE2OZxU79zpn2sg0ib5K4O6cLlyfzWT5S6Ib3a
	 /vYS2IHkAeOJaF7kJbeFn6X38bRUpq9jWqqC9A997b0f8zniRw/1Dg+7a1upw9uvx0/DC
	 oWIi9OQC+9U5CGC0TZpxU9SB0O3aTHkO4ijTKtpKAGzzgafimFs5VeiadwALBnWE2vOdO
	 pKSQqXKwj2dG+xFl3inQr9y91f3mrGVVSWvSVVF6fJ613fNS3DKBMPGHvY4zlWSwXyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793398120;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=6MP1tF8YbJWsKrQojtXpYNGggZHhGf8qvXrZ+jDl4EY=;
	b=mhqpwyWHGGli1v5cAPs6GvdVltfJ6eehd5RyObeJeI24+p9YcKVMKWOn0DpJJfZE78sl
	 a4QKTOdSsmFfs04J9SBDhU/lByUnrgOCnFb6jpuPcBXQeX18hMvUw3U4HhWynrfDqgJvY
	 sNL8j9lHR/5qKz5AIlKmf5coJArre3W064lmApvGBDsr4NIGoi3QRs/2ZUlN69WlskGpe
	 ghrNXVM8Fu1rM67N47k4tTJ4gbTZHM201htOYrDYWT8bVI3+BDvNW0oJ7lSBSGY09yKo5
	 ZVnsd3GbVN3iVdqcBq68fUbMxInIWz6xbn9FCOMwaeF/bOP5g8rSmToLsUe/4Qo1HLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="ZYNamf/V";
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DA5606A31D
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 22:08:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C5DA5606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZYNamf/V
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a59100fa83so11035585e9.0
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 15:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793398118; x=1794002918; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6MP1tF8YbJWsKrQojtXpYNGggZHhGf8qvXrZ+jDl4EY=;
        b=ZYNamf/VYWCnTct7RBEnVi+JFPz+0o+TohO4Y+EUJEs8LgdF/ztEk+zOKpZrEDf91H
         YpHEBexnSPhRokuh1sCBval92RStxkjgxXE/0VZpe2zfQC8gcNQLdRSDCMJ+YgLD4iMg
         PdaoVTevSLhEWz6JmE9DoyiY6fZFroK5VE/IolCfxwOCAt5ECOe3AOZNg0fB8bvOzOKa
         aHfIGABusUgtjWCqymOu0ZuR8vD4LdCh1fpLZ5ZUzrF7AaF1MJ1+5gdAXdaqIRCEGWYV
         Uj9CEbNSBxZrb/dCVZpRw8fEGmNHSSUxVz56B0UzQJVbH7ho66lUcrmgd/ELB8i/jrjQ
         vnWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793398118; x=1794002918;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6MP1tF8YbJWsKrQojtXpYNGggZHhGf8qvXrZ+jDl4EY=;
        b=ahSu4D93jxJjiXDq7lzS+NcPTbeinJkZJ1nbpeKVdz0RM9SfW12tnXP/dnywfQUree
         D1HSujh9cuMEtz2Jixy8uX5gl9JajvpSUM6skhL1tvjftQ9dOs94TMGOkSR7mPQRsEGX
         CWg7qPUspqJCihKskntWBN4WFcqisA8pnQcjlpuYtKcERJHak/kSZIvL0v4dn79/3Q4e
         nfpnzqim7jT3j3ywtxmtHzzbs7gdf4nLwjeZk+0T7b2RDE8MIu4Wi9/7h9kO5uOgkLjb
         jjnTsHaQrLepyAlCpTElNcLrpjCkCbIyQCefydkWJu38ZLqEthrXZRJpejjy+MLVHp+2
         pswQ==
X-Gm-Message-State: AFq9FYJDvTD/SIC+XW8wRZR7+RoBL+MYgC45fRD74o5KkKebdeiLruGV
	r78X0OpbAyGzLWYrWa9lzKJ/TxNnFYT5+SFPEehWNsWd+ptTR+vP0lW6
X-Gm-Gg: AYBFou2YqFslwwTqoKQK5IVuTb28n1IW4MNc9jw69YBCw10IAAWPGhYBgUqPReZJvj/
	X21AlYuUeDNP9br2tvBTL6qzrnpo6A0zhXUO0vVrrGZZIfl+JCFMvr5Y/BYGBXPPNnnxD6XOQqO
	9+/DxI/hFanL2zp/1oaojJlqpKyg8A4o6pikFe7KcJdmnK80l6P6zqcjYQVEpT/IovM5BXqPM7+
	d2pehgZ3KxPBECf6W//tAyUHGlnnNcBTnMbZPqP/MrBp/43ardLDaoVhXjf5qHd77ymoHaVShX9
	S0m4RJCrtWW0aJQRjZj3Zb9NnJe7pb9hzKcA5h7+S0r/5aYyrYB2Pb8JpjElcR+xbBDyrFcfY6Y
	fqevu8N0RT2NX/3uEDhwJH5wKcYw6OzV5thbOFl2/fsvAGrCkKKz1Si76r+yfCntoC8SbIYWC8F
	QvMynQy0luY+u0Zz6KK0/egfLLkk7qC6ute+OF++wwSM42NsGGOPyLr4QsbMGBg2DV7NzQXundj
	+6eoXnmvmrQkVNNQM98Z/WkeqPg1VeDo0c4X/BtekJSy3QT/0ZOFeyGtJsOAExxfZx/GDUjXHu8
	d4II+O+Q2c/IIsSKmFoWVrhSyBD6pygAFCq+IBg9Q6C4gdh+4INzuimiDHBIZXlVlcduEleLbmL
	8DkHxTN3+BH29RGf/umB0XIfsyoyU6yTwfFQ3O5qbDuWshsi3FLrssLfs2g==
X-Received: by 2002:a05:600c:630d:b0:4a1:fae2:a8ab with SMTP id 5b1f17b1804b1-4ac150b38abmr79417375e9.3.1793398118067;
        Fri, 30 Oct 2026 15:08:38 -0700 (PDT)
Received: from u1804.home.lan (152-43.dsl.iskon.hr. [89.164.152.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abe7706516sm56230305e9.0.2026.10.30.15.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 15:08:37 -0700 (PDT)
From: Goran Sustek <gsustek@gmail.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH ath-next 1/3] wifi: ath12k: allocate the AFC memory region requested by firmware
Date: Fri, 30 Oct 2026 23:08:22 +0100
Message-ID: <20261030220824.915760-2-gsustek@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261030220824.915760-1-gsustek@gmail.com>
References: <20261030220824.915760-1-gsustek@gmail.com>
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

QCN9274 firmware WLAN.WBE.1.6-01243 requests a target memory segment of
type 0xa at every boot. The driver does not know this type, so it logs

  ath12k_wifi7_pci 0000:06:00.0: memory type 10 not supported

and answers the request with a NULL address but the requested size.

Type 0xa is the AFC region: QMI_WLFW_AFC_MEM_V01 = 10 in Qualcomm's
wlan_firmware_service_v01.h. The firmware asks for 8 KiB, one 4 KiB
slot per radio, where the host places the answer of an Automated
Frequency Coordination server for 6 GHz Standard Power operation.

The firmware's handler of the memory response records the reported
address and marks the region as provided whenever the size is
non-zero; it does not check for a zero address. With the current
NULL answer the firmware therefore holds a region at bus address 0.
This driver never enables AFC and no misbehaviour has been observed,
but the firmware state is wrong.

Name the type and allocate it like the other host regions, bounded to
two 4 KiB slots. This removes the warning and gives the firmware a
valid region. An oversized request keeps today's behaviour with a
warning.

Tested as part of the series.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
Signed-off-by: Goran Sustek <gsustek@gmail.com>
---
 drivers/net/wireless/ath/ath12k/qmi.c |   17 +++++++++++++++++
 drivers/net/wireless/ath/ath12k/qmi.h |    3 +++
 2 files changed, 20 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/qmi.c b/drivers/net/wireless/ath/ath12k/qmi.c
index 280e50a1f31d..0679e5d2d4fc 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.c
+++ b/drivers/net/wireless/ath/ath12k/qmi.c
@@ -2707,6 +2707,23 @@ static int ath12k_qmi_alloc_target_mem_chunk(struct ath12k_base *ab)
 			if (ret)
 				goto err;
 			break;
+		case AFC_REGION_TYPE:
+			/* Firmware requests the AFC region at every boot, even
+			 * when the 6 GHz radio does not use Standard Power. It
+			 * treats a non-zero size as a provided region, so hand
+			 * it real memory instead of a NULL address.
+			 */
+			if (chunk->size > ATH12K_QMI_AFC_MEM_SIZE) {
+				ath12k_warn(ab, "AFC memory request of %u B exceeds %u B, not allocated\n",
+					    chunk->size, ATH12K_QMI_AFC_MEM_SIZE);
+				chunk->paddr = 0;
+				chunk->v.addr = NULL;
+				break;
+			}
+			ret = ath12k_qmi_alloc_chunk(ab, chunk);
+			if (ret)
+				goto err;
+			break;
 		case MLO_GLOBAL_MEM_REGION_TYPE:
 			mlo_size += chunk->size;
 			if (ag->mlo_mem.mlo_mem_size &&
diff --git a/drivers/net/wireless/ath/ath12k/qmi.h b/drivers/net/wireless/ath/ath12k/qmi.h
index 6da10f3cb597..c438ef6c7680 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.h
+++ b/drivers/net/wireless/ath/ath12k/qmi.h
@@ -26,6 +26,8 @@
 #define ATH12K_QMI_BDF_EXT_STR_LENGTH		0x20
 #define ATH12K_QMI_WLFW_MAX_DEV_MEM_NUM_V01 4
 #define ATH12K_QMI_DEVMEM_CMEM_INDEX	0
+/* AFC region: one 4 KiB slot per radio, at most two radios */
+#define ATH12K_QMI_AFC_MEM_SIZE		(2 * 0x1000)
 
 #define QMI_WLFW_REQUEST_MEM_IND_V01		0x0035
 #define QMI_WLFW_FW_MEM_READY_IND_V01		0x0037
@@ -173,6 +175,7 @@ enum ath12k_qmi_target_mem {
 	CALDB_MEM_REGION_TYPE = 0x4,
 	MLO_GLOBAL_MEM_REGION_TYPE = 0x8,
 	PAGEABLE_MEM_REGION_TYPE = 0x9,
+	AFC_REGION_TYPE = 0xa,
 	LPASS_SHARED_V01_REGION_TYPE = 0xb,
 };
 
--
2.47.0
