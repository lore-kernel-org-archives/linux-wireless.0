Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793773831;
	b=YGQM3Ouy9GjbQqJio7gGrtSAhcwzIOHJIrt0foexPtytj+aJyTgFph8kr0XAXVagtU/1
	 MsuRbCs4SVB6sX1mfbtb+1k+L78djiwRRc4woI61AwhM8LMsZ8nJrcPNQ+ZNoB6JqV0dp
	 DRASBSAvF/b9XkwbG8uZjImfuaSfYCYZrKfswrjpDdXDyRUPJITamr1+xOXtvNiJmTu52
	 WqMUE0ZxsgdBAKzDUf+/NfC8kBQUi/VFbg4k/T60YwXsCVvLKHc4SO0w23Lq7pdk7Ruoo
	 CInweE0dKbuu6womHetj8WBoctaxN8flmTyHpD60xWx3+GU9xkIWFvVym62dA/yapvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793773831;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=D1JMuHDuJB7WM40OF4LWjX7Ih9UPYlKv1FoFNhq4gJw=;
	b=eUam6bHRfiHT2pLO9ybsfkFSTtM8n3fGepYRvhvB0TnXmaUVQ0aAKXPFWNbkRdds3dDE
	 PWXutuazS/mOcHSGkVaA7XHkjN9fFFrC4c4T0B7vM8Pus/C3/rhiXrfUej42PWz2NiwAt
	 3dFdj6INsdixBscTxr7Ar9VuOxvOGkhyIA6IYs19LQa0QGJnRgOuwKZcTxnzfCa7hN76a
	 Zx6nAHtwHrTphyboWxQs/BqjuuRvJRNvO68INfJeT9wNR5e4HCihmes0XBojoR01sVWEd
	 zue4xQn5aRbuqP4ObRZ/GlE4cXFNExce9gu0oZIw1d8x/wmTa/LiOCgY5N6FGFs61gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="RgT/i3c3";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="U/+uaFEn";
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C1D606A326
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 06:30:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55C1D606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=RgT/i3c3;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=U/+uaFEn
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A40R1Er3458472
	for <linux-wireless@vger.kernel.org>; Wed, 4 Nov 2026 06:30:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	D1JMuHDuJB7WM40OF4LWjX7Ih9UPYlKv1FoFNhq4gJw=; b=RgT/i3c3iJUiddzO
	GmGwVFZt2/pEq+5N4cNtAXo9ee/0wzg8lk9o5/Ux8o1QkmdPH188pU5NnFweZSQw
	QWbFS5NSfgriTc8PhROOJtbXr5/AlpUjV1c8vHw0J7+BfTw53prf5sPQymy/bc0n
	WfFwsuj8/ZWx31xraIH6klgxc3wJuepw0B2hleBpqwHLldRLsSyDFVODgn54yzho
	ytdQNlQ8FtikCZRpnzwsG6trvpjIgwOjfAE6QjmJ7HKiXxBfHcSzSA7xU4PMq9W9
	CeoQmW7CA+fa/vt8aaYFOWh6CrJezXx1dIQtmvxCeq7um3WjSSvwx5hrf85+O6v9
	izD0ng==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hqh2bunhs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 06:30:30 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3b08aee6b3eso475694a91.3
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 22:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793773830; x=1794378630; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D1JMuHDuJB7WM40OF4LWjX7Ih9UPYlKv1FoFNhq4gJw=;
        b=U/+uaFEnQNhKjeoHH4A6kF10g0X9vo1FDwuWghdfRcWz8YVuOqiVqaFezuk1usK1Cy
         HvWkAXpxqnL32CStM63V7AQNPspmI+19lYMGeJhddC993fwBfE2E9S8ATiPx1f+4E6bo
         AO6PQ4CI02Q15jIJmfRubTh7eAR9CYhSjewqFlRHRzzwYLLM/N+B8L3D63NEwgXsLdM1
         QngpTiXX6CijsTqLotdlepgx/vlqWkhRIvYeFLOSz800hI7YjLVcLCC9pt0vx9dPvV+K
         ENAmtzS5Y4T/IurPTF7iAwow8BzliGJY7NuxEfh46LfjgiFAmMwmv827P3VFLzc5R7qo
         M5Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793773830; x=1794378630;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=D1JMuHDuJB7WM40OF4LWjX7Ih9UPYlKv1FoFNhq4gJw=;
        b=rU8LLvksIoQiIZR1yzQpCegLbbwGPqsul2oyursRRWlQPcHA2pDp36CA+VGaVfpIop
         KpJZTo45RdMYeSW1cw0LDu8GuBZiROt/cP0h53s9jktlvb/3ayCgOeIw5bsyazG/b2q1
         X0pxOioLH0uID9aA3eCv4KvWFKHOq1YCqcwlYjBt0Si718eoRzOe47djPpvTFQOpQCaE
         VCEXryAGiGTlPCVfkIyC1sXamp7N9oT4yTLdUAmNKLEcW6gQe3Y3M31tPMTOqB5ErWLP
         Telxp6M9WmLHJ10ofOnMtD/Ti0bOyaWN+1uO2pRPLet/cqlh/JvUrJtCIBUT7dLiX2dN
         85iQ==
X-Gm-Message-State: APuU4Z+8CLlMQkKqxwPNTrp9HEI+iN3XRBJ71oWBP/T9DaJb1xcmLeuk
	6VVkxTs0TTVE+VMIvAyBWjDmC/yeq+qZVelRsmc4PMngTcwPSpFExS9v5rjTuc7zCrxmuDv1DTo
	5JZYidPQvB5h6LqxZtsEsAq10gUmXB1SaqXjVPzE1SoP6lI/DElNrJlqerdZOZfBVUkibPV5jNH
	Q4UA==
X-Gm-Gg: AYBFou1ZJGQlCWypabmNDHBwlG9P2ba2md47OgdHtw2bRkO/ELQ1b0yYcaDwR0Zvjmq
	NN7WQZtqSeRdp9UjXMnTTfRRMO5G/cWkZAkohK9Gn8npAuqRQmNwwZ2iyxiZ/w3amCzZQCBv8Ay
	Ruxe2aQpGBB2HqBrlLQ1PKYtqpofDEMlZgX+uO7pnOyvnWUIFc7J2PoN2I4Phm8Z0OpMp6Ye0Qy
	t39AeuDbxCthxfAtH09Yc1x5LPVqFltufZKg0pO3rLpE/L16iEmx2t/IQvv4CBQCLpWg9rJ0bAV
	3dm2gyta8x7UxPY8kbSxohsxKiquCe81ExldZ0l7r0mNP86TLkh1Iw3DJBpa5re4kQX+vXfoJ14
	NTJpomxJRmGd9Lv0a0WSfXA25nUo4NjmeqcKVXA7XvKPVttAjhag1hdjdYGU0AJj0WBF/BhVnWa
	US7hbqwsLyyiNpyP6v3LFo/ocPP58gv1pIIIBb8Ik30WX6nIgJ71+3YKqSduB/JLuI3+vD7Zux5
	g==
X-Received: by 2002:a17:90b:134c:b0:3ab:9c73:12f with SMTP id 98e67ed59e1d1-3ae897ee533mr13031693a91.24.1793773829581;
        Tue, 03 Nov 2026 22:30:29 -0800 (PST)
X-Received: by 2002:a17:90b:134c:b0:3ab:9c73:12f with SMTP id 98e67ed59e1d1-3ae897ee533mr13031671a91.24.1793773829039;
        Tue, 03 Nov 2026 22:30:29 -0800 (PST)
Received: from hu-madhgane-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b09445f7b3sm2420646a91.5.2026.11.03.22.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 22:30:28 -0800 (PST)
From: Madhavan Ganesan <madhavan.ganesan@oss.qualcomm.com>
Date: Wed, 04 Nov 2026 12:00:08 +0530
Subject: [PATCH ath-next v2 2/2] wifi: ath12k: refactor m3 and aux_uc
 firmware memory handling
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
Content-Transfer-Encoding: 7bit
Message-Id: <20261104-m3_and_aux_ucode-v2-2-b6c335c14dfe@oss.qualcomm.com>
References: <20261104-m3_and_aux_ucode-v2-0-b6c335c14dfe@oss.qualcomm.com>
In-Reply-To: <20261104-m3_and_aux_ucode-v2-0-b6c335c14dfe@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Madhavan Ganesan <madhavan.ganesan@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyNSBTYWx0ZWRfX6o9JS2eyp8wI
 stgLMQklIQ+gil4eIdD6+FY7H5TUFzjhQ6+rh/vNmOjnNtJBWwst/zVo/NBQTEq+wT0Hi3NsCV2
 Hgr2icwGElyzws9/IE9i9WUmB9VVqSo=
X-Authority-Analysis: v=2.4 cv=AKV9GsJK c=1 sm=1 tr=0 ts=6aead106 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=7UcVal2zOK_enNmMlbUA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-ORIG-GUID: 2Il4vnJAtpiPOrM0Cl50dlp_1nyypZan
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyNSBTYWx0ZWRfXwYBJAodd9VeL
 ez4S42kVmtlrdJhN2JJv7bbgqRGHQPx7dNK3ylKTuEeoAdmnCHqx4qvwFzh9Pzp8ELTG6dwa+Do
 AFF3G/dt232BSawKm7OZxvUDufIf+neD5UjoCM3hefuc/m65/7stq2HRPi2/b1KnECLAz+Z4Eg8
 FQDTRI4YPBK7T0/xfkBar/YQZfug6uhQgtRhXP+SDCg3/ZuBt2NYwBjAFbYNlMDrJnQ/1fa734x
 MXy/84vGQ6iK/PXM+lhTmhjkxKdcwYE8jaNvKYOcatv71f8klsN5ApQgo+nqvowKjWdmZQ31suF
 1Atnj4Xhny7dZX9vqHRMlTUgSvFsVcdI7d4DLecjaAlW2BPAwx3KA9xfJgqdipC618mi0tJkf0b
 mKXgNLmrdW0A+GxuNk8glOh0STrGstdIBlYzqJdnj9yw+675WRu4CP262OJMjzxGwIQJ61RS7eg
 /+8PAzuYWhRBB94rriA==
X-Proofpoint-GUID: 2Il4vnJAtpiPOrM0Cl50dlp_1nyypZan
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 bulkscore=0 suspectscore=0 impostorscore=0
 phishscore=0 spamscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040025

ath12k_qmi_m3_free()/ath12k_qmi_m3_load() and
ath12k_qmi_aux_uc_free()/ath12k_qmi_aux_uc_load() implement identical
logic for freeing a DMA-coherent firmware memory region and for
loading firmware into it (reuse existing buffer if large enough,
otherwise free and reallocate, falling back to a standalone firmware
file when no embedded data is present).

Factor the common logic into ath12k_qmi_free_mem_region() and
ath12k_qmi_fw_mem_load(), and have the m3 and aux_uc wrappers call
into them with the appropriate struct ath12k_fw_mem_region and
firmware file name. The shared free helper also clears paddr, which
the previous per-region implementations missed.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Signed-off-by: Madhavan Ganesan <madhavan.ganesan@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/qmi.c | 164 ++++++++++++----------------------
 1 file changed, 55 insertions(+), 109 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/qmi.c b/drivers/net/wireless/ath/ath12k/qmi.c
index b1efed1702cb..237df9198e76 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.c
+++ b/drivers/net/wireless/ath/ath12k/qmi.c
@@ -3225,77 +3225,71 @@ int ath12k_qmi_load_bdf_qmi(struct ath12k_base *ab,
 	return ret;
 }
 
-static void ath12k_qmi_m3_free(struct ath12k_base *ab)
+static void ath12k_qmi_free_mem_region(struct ath12k_base *ab,
+				       struct ath12k_fw_mem_region *mem_region)
 {
-	struct ath12k_fw_mem_region *m3_mem = &ab->qmi.m3_mem;
-
-	if (ab->hw_params->fw.m3_loader == ath12k_m3_fw_loader_remoteproc)
+	if (!mem_region->vaddr)
 		return;
 
-	if (!m3_mem->vaddr)
-		return;
-
-	dma_free_coherent(ab->dev, m3_mem->total_size,
-			  m3_mem->vaddr, m3_mem->paddr);
-	m3_mem->vaddr = NULL;
-	m3_mem->total_size = 0;
-	m3_mem->size = 0;
+	dma_free_coherent(ab->dev, mem_region->total_size,
+			  mem_region->vaddr, mem_region->paddr);
+	mem_region->paddr = 0;
+	mem_region->vaddr = NULL;
+	mem_region->total_size = 0;
+	mem_region->size = 0;
 }
 
-static int ath12k_qmi_m3_load(struct ath12k_base *ab)
+static int ath12k_qmi_fw_mem_load(struct ath12k_base *ab,
+				  struct ath12k_fw_mem_region *mem_region,
+				  const u8 *embedded_data, size_t embedded_len,
+				  const char *filename)
 {
-	struct ath12k_fw_mem_region *m3_mem = &ab->qmi.m3_mem;
 	const struct firmware *fw = NULL;
-	const void *m3_data;
+	const void *data;
 	char path[100];
-	size_t m3_len;
+	size_t len;
 	int ret;
 
-	if (ab->fw.m3_data && ab->fw.m3_len > 0) {
-		/* firmware-N.bin had a m3 firmware file so use that */
-		m3_data = ab->fw.m3_data;
-		m3_len = ab->fw.m3_len;
+	if (embedded_data && embedded_len > 0) {
+		data = embedded_data;
+		len = embedded_len;
 	} else {
-		/* No m3 file in firmware-N.bin so try to request old
-		 * separate m3.bin.
-		 */
-		fw = ath12k_core_firmware_request(ab, ATH12K_M3_FILE);
+		fw = ath12k_core_firmware_request(ab, filename);
 		if (IS_ERR(fw)) {
 			ret = PTR_ERR(fw);
-			ath12k_core_create_firmware_path(ab, ATH12K_M3_FILE,
+			ath12k_core_create_firmware_path(ab, filename,
 							 path, sizeof(path));
 			ath12k_err(ab, "failed to load %s: %d\n", path, ret);
 			return ret;
 		}
 
-		m3_data = fw->data;
-		m3_len = fw->size;
+		data = fw->data;
+		len = fw->size;
 	}
 
-	/* In recovery/resume cases, M3 buffer is not freed, try to reuse that */
-	if (m3_mem->vaddr) {
-		if (m3_mem->total_size >= m3_len)
-			goto skip_m3_alloc;
+	/* In recovery/resume cases, buffer is not freed, try to reuse that */
+	if (mem_region->vaddr) {
+		if (mem_region->total_size >= len)
+			goto skip_alloc;
 
 		/* Old buffer is too small, free and reallocate */
-		ath12k_qmi_m3_free(ab);
+		ath12k_qmi_free_mem_region(ab, mem_region);
 	}
 
-	m3_mem->vaddr = dma_alloc_coherent(ab->dev,
-					   m3_len, &m3_mem->paddr,
-					   GFP_KERNEL);
-	if (!m3_mem->vaddr) {
-		ath12k_err(ab, "failed to allocate memory for M3 with size %zu\n",
-			   m3_len);
+	mem_region->vaddr = dma_alloc_coherent(ab->dev, len, &mem_region->paddr,
+					       GFP_KERNEL);
+	if (!mem_region->vaddr) {
+		ath12k_err(ab, "failed to allocate memory for %s with size %zu\n",
+			   filename, len);
 		ret = -ENOMEM;
 		goto out;
 	}
 
-	m3_mem->total_size = m3_len;
+	mem_region->total_size = len;
 
-skip_m3_alloc:
-	memcpy(m3_mem->vaddr, m3_data, m3_len);
-	m3_mem->size = m3_len;
+skip_alloc:
+	memcpy(mem_region->vaddr, data, len);
+	mem_region->size = len;
 
 	ret = 0;
 
@@ -3305,6 +3299,21 @@ static int ath12k_qmi_m3_load(struct ath12k_base *ab)
 	return ret;
 }
 
+static void ath12k_qmi_m3_free(struct ath12k_base *ab)
+{
+	if (ab->hw_params->fw.m3_loader == ath12k_m3_fw_loader_remoteproc)
+		return;
+
+	ath12k_qmi_free_mem_region(ab, &ab->qmi.m3_mem);
+}
+
+static int ath12k_qmi_m3_load(struct ath12k_base *ab)
+{
+	return ath12k_qmi_fw_mem_load(ab, &ab->qmi.m3_mem,
+				      ab->fw.m3_data, ab->fw.m3_len,
+				      ATH12K_M3_FILE);
+}
+
 /* clang stack usage explodes if this is inlined */
 static noinline_for_stack
 int ath12k_qmi_wlanfw_m3_info_send(struct ath12k_base *ab)
@@ -3359,77 +3368,14 @@ int ath12k_qmi_wlanfw_m3_info_send(struct ath12k_base *ab)
 
 static void ath12k_qmi_aux_uc_free(struct ath12k_base *ab)
 {
-	struct ath12k_fw_mem_region *aux_uc_mem = &ab->qmi.aux_uc_mem;
-
-	if (!aux_uc_mem->vaddr)
-		return;
-
-	dma_free_coherent(ab->dev, aux_uc_mem->total_size,
-			  aux_uc_mem->vaddr, aux_uc_mem->paddr);
-	aux_uc_mem->vaddr = NULL;
-	aux_uc_mem->total_size = 0;
-	aux_uc_mem->size = 0;
+	ath12k_qmi_free_mem_region(ab, &ab->qmi.aux_uc_mem);
 }
 
 static int ath12k_qmi_aux_uc_load(struct ath12k_base *ab)
 {
-	struct ath12k_fw_mem_region *aux_uc_mem = &ab->qmi.aux_uc_mem;
-	const struct firmware *fw = NULL;
-	const void *aux_uc_data;
-	char path[100];
-	size_t aux_uc_len;
-	int ret;
-
-	if (ab->fw.aux_uc_data && ab->fw.aux_uc_len > 0) {
-		/* firmware-N.bin had a aux_uc firmware file so use that */
-		aux_uc_data = ab->fw.aux_uc_data;
-		aux_uc_len = ab->fw.aux_uc_len;
-	} else {
-		/*
-		 * No aux_uc file in firmware-N.bin so try to request old
-		 * separate aux_ucode.bin.
-		 */
-		fw = ath12k_core_firmware_request(ab, ATH12K_AUX_UC_FILE);
-		if (IS_ERR(fw)) {
-			ret = PTR_ERR(fw);
-			ath12k_core_create_firmware_path(ab, ATH12K_AUX_UC_FILE,
-							 path, sizeof(path));
-			ath12k_err(ab, "failed to load %s: %d\n", path, ret);
-			return ret;
-		}
-
-		aux_uc_data = fw->data;
-		aux_uc_len = fw->size;
-	}
-
-	/* In recovery/resume cases, AUX_UC buffer is not freed, try to reuse that */
-	if (aux_uc_mem->vaddr) {
-		if (aux_uc_mem->total_size >= aux_uc_len)
-			goto copy;
-
-		/* Old buffer is too small, free and reallocate */
-		ath12k_qmi_aux_uc_free(ab);
-	}
-
-	aux_uc_mem->vaddr = dma_alloc_coherent(ab->dev, aux_uc_len,
-					       &aux_uc_mem->paddr, GFP_KERNEL);
-	if (!aux_uc_mem->vaddr) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	aux_uc_mem->total_size = aux_uc_len;
-
-copy:
-	memcpy(aux_uc_mem->vaddr, aux_uc_data, aux_uc_len);
-	aux_uc_mem->size = aux_uc_len;
-
-	ret = 0;
-
-out:
-	release_firmware(fw);
-
-	return ret;
+	return ath12k_qmi_fw_mem_load(ab, &ab->qmi.aux_uc_mem,
+				      ab->fw.aux_uc_data, ab->fw.aux_uc_len,
+				      ATH12K_AUX_UC_FILE);
 }
 
 static noinline_for_stack

-- 
2.34.1

