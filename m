Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793726771;
	b=L2hfAOKoVqYUOtkj9hGXdOV6ELU4redRuRWQ1OhxPA+ePfm8QD2dkkNuW9K5XoOvxDRv
	 AIXOFdYlYWtL76ZwTHyL8IPsO2Png5XdJQ3shjsTuAeqScCS6Qqgt28+7XF10hzUa1mEs
	 Py6RZnO6PCQv9bEmdLaPFIPrX5eL83kbc4E+QIXe6+m3Cba5+DHBPCqNV1wQXCSzzcJBp
	 oCNGlWh/IQUZnuNqMsFhW/YOGUo/OTrwerzFn1YXYlaWuqD7I6cdBTDG6p+SRDiVuROW5
	 fKRUX3aUL5L0WOCDp9MUDSAOsh5GDNWmFY5vCGTlcloTSlXsX3JCCXrN3bK/BN4FOMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793726771;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=PYiEmA70j8TCP13NdNomODWDhfmQmohzhkIzMccZN30=;
	b=xCtelgdXvfKMX12sZ9cAoBynhAi0XY7XlFceSdYTBs2aHnQozKl/wlcyOlKLVZqkweTC
	 WgUFdc03nYkw/PpIRNFH/RgPisgXlDSBvHKDIlOu9DEHz2vkPhj2zyeJfAMpVI+odJsWQ
	 bSGXJlQCcFutk8PHOKcDI3YIxCyD0BHWNPNHfTQhWz6QsDgFLM8yYgu4mTgZaYULiGEMc
	 lX02DwGiypLPndlQm4Ht3B6jkCOETU07w88E6HxtW29fkJo5VuRCkqjiy2M1Y88IpkpZ3
	 BhvyqAFMKCVZCRGhoCbfVWj6dv7eQyiSW/ufTI7zG3KxGsdFa7XqGBcGt+Qq0U60oAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=P8n8lwKS;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=dpW1Ta3q;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E258606D81A
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 17:26:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E258606D81A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=P8n8lwKS;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=dpW1Ta3q
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A3HPgbv2961370
	for <linux-wireless@vger.kernel.org>; Tue, 3 Nov 2026 17:26:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	PYiEmA70j8TCP13NdNomODWDhfmQmohzhkIzMccZN30=; b=P8n8lwKSZVgwBbk4
	3fZ1MFdlfP7tythQCZlmkOvJlNTzxL9pfMC3OZ1Je7fR85/e6u/UPgBuhfEvBJgd
	U54prymqgJYEeN1GKlr2/DjParuN/Ur6QYo/8VcFIXmGyfO8wKGY6OL0x5+0aWTH
	aFDkQuaz788wKRmgYuYk8HJrnBOfefguPBU6UnO2XqixmbnG1FAUpOJSHVUqsfGo
	00r9Gc/kQK4fkU1BvMpRK+VcyYfrX/3NqEwBo5MJX98x3+B7gj51be3P8UNYEBdW
	eCNS8ZdwjFifofTAQlJl991whEf1qfIsk0R7+rXdLdkIbKl6ajEjLGWcDeTJLBIH
	fDEt1g==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hq7ycu8mj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 17:26:10 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-36a26fe9521so933333eec.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 09:26:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793726770; x=1794331570; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PYiEmA70j8TCP13NdNomODWDhfmQmohzhkIzMccZN30=;
        b=dpW1Ta3qaOR+/4S9/D3Lxi3DzjvYeBK/k5p98V2D9lJt8EOT/1+6dhbdZY7Xm6vnC3
         qN3uzZ3Tjhe08QK0MpjMiY96Ow6V2wjMr6+S8N5PFOVQS29uG3/u0VNKBnuPn5pnpGQC
         OiQ9jX0cDKvl7d/2GrKsZhON+vM5/0ao9510uCg0xxUHOENv0JSJXVsEdOBpLu+X+vfJ
         WlYHa40RSSFG/+FKPwAXKursnqtJadlruXyNb45b3/bhXhAqashqxrseOeVa74PRuLn4
         Tyq1DQU8AsF79MSC3LDUezvEji82lUJqrarUDCtPkFL+u8kBc8idQMSBS9WA7jJX9Dbv
         oPRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793726770; x=1794331570;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PYiEmA70j8TCP13NdNomODWDhfmQmohzhkIzMccZN30=;
        b=jb2OqKPRQgZljfu3pShwLlC8fPBqjK+lz73Yo+PIbzL7KmpH9IvoSc+NkTHvZxb7T/
         Ier5vLnVuSwwUQBlEpZOUdHjzdS95FHwHmfnVA5+Jz3HHhDYhBR/cksUuxmyjFAH5deZ
         I3IhxWnRnVwdflYFBb/20en+Z/Bdb680mji/EXgpnExuef+CPyNy6S0KavVOQujjjFBY
         2GBqnGHKHSL/LQjRATFb6BP9MOtUt4MpaQHIIFPtUZH/6rluMzxikkxj+3A4n9s7TYxl
         Ap5HkSUd78BfpDTgeTXfaSGiYBWkTFC4HTA7ov5BLlwhejHymqRHd6kSL20bpuVwnr2T
         I7UA==
X-Gm-Message-State: APuU4Z96tsY1bWntCaVaShLDT5aHZERcLBpAYQTVK2+wYqQ1b0QjECjV
	mm3jgRHo10mA/cdDiF92uzJynGIr03ygcCwao9LS9c0nxiRouCnWrJEdOPJCmlVvSy/BucjXi4/
	2NPwx94wNwPNGPI40al9WxQgG3qS1FSs7wlhbsKBxx274ws1znOEH6oZ6hCotqjW2o/RtkA==
X-Gm-Gg: AYBFou3bi7xzcBXFdHxPabyGLy2sH83ZTFWDv1s+rmZQ/bw6Hd7j82xmaO/5Djv389n
	Q5VqBl5L3YoRUws/zSyG2zNUu5AOwSUREVec4Px3vcbN4LFLo1uaTIhEDnMrGqJ2hn3Db/jiNWm
	0nZa9MZnRV1osDDwKnIu08LvfiO5xJHyxPNaxNRg3eClZzUEUNnevWjhL6fVcOKS+DYCbSoBoRK
	nuJjPPuMJE+rkjJ4DnvXD6ci27FThCHyQHE1VZSOVkaC0771Sm+ZOD1Eirj/98CpTdzfKAJHoch
	P/6n+FDsKp59fcuIlLko5wyANZndIYpQfLYHKmdBgBzmX1/vBE/0Zd6P7KSsdqBNYThoZDRc+FB
	vNnyVRiH3jzCaJQSFmJyhsDz6B/Sn6yEFowyCdDvBEzA9pdOwNMyc+SOGTZ+YN9diOjNdvHF+aK
	atqKfjqLvVKrBbdAy/DMLmwl4080W8k0mhkOqKcwTUh4UxT7LPzeCuEL/AlHzRfWOYBtvEWX1RL
	DM=
X-Received: by 2002:a05:7022:628d:b0:184:40db:6bb9 with SMTP id a92af1059eb24-1a94876dbd0mr32647737c88.8.1793726769136;
        Tue, 03 Nov 2026 09:26:09 -0800 (PST)
X-Received: by 2002:a05:7022:628d:b0:184:40db:6bb9 with SMTP id a92af1059eb24-1a94876dbd0mr32647697c88.8.1793726768447;
        Tue, 03 Nov 2026 09:26:08 -0800 (PST)
Received: from hu-madhgane-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c1c272sm357310c88.8.2026.11.03.09.26.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 09:26:08 -0800 (PST)
From: Madhavan Ganesan <madhavan.ganesan@oss.qualcomm.com>
Date: Tue, 03 Nov 2026 22:56:01 +0530
Subject: [PATCH ath-next 2/2] wifi: ath12k: refactor m3 and aux_uc firmware
 memory handling
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
Message-Id: <20261103-m3_and_aux_ucode-v1-2-e14f13fdfa41@oss.qualcomm.com>
References: <20261103-m3_and_aux_ucode-v1-0-e14f13fdfa41@oss.qualcomm.com>
In-Reply-To: <20261103-m3_and_aux_ucode-v1-0-e14f13fdfa41@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Madhavan Ganesan <madhavan.ganesan@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Authority-Analysis: v=2.4 cv=V7foQuni c=1 sm=1 tr=0 ts=6aea1932 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=7UcVal2zOK_enNmMlbUA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-ORIG-GUID: i0nc1zsBYbImg3MiMtT_y7COAh6x8-8A
X-Proofpoint-GUID: i0nc1zsBYbImg3MiMtT_y7COAh6x8-8A
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAzMDA2OSBTYWx0ZWRfX/rAdM/S0OaKk
 Xwsd3QFnO5VtZ3aeKK3slQCetrJzrt29wyt3ln/8kUptjpZ4LhkLMD/wSgJqqIPZsRwZTDR+Eu3
 9CGgyXoJPeS7OBIPEMMP+lP1my6LEPfJByFq7CpFsXNecFpyBaleEGSCcbRYeOSS3DTciQgUYGn
 ZfNicLmIcq/SeEDbC2OGRFMGi8DYrGMA9qVce3Nx2Xx5xJ/W7OT9EyzATCQfR8np8zj1xxHrp0U
 heZg4/MMg9ZPJEah/m2SBMioITuERGmVAPG43yi/2dDXTl74i+E3Ssi60ur+mDVsNQcRI42GPE4
 qi3wjutgd5BXSgj5i8KdQ26i+34gUdvhpVeDiFFULf9XgCmFSpBkol2kl9fyhiD1FYjU4L7ePlj
 qHYep3mCCDWzc04UGJzsQ9xbU4YZOvNUVOSZ1dP7oKhOfgpFVe5h1PbHikg5GrVuCB4zUxo1zHd
 +DolM+P9FANAAG1YUSA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAzMDA2OSBTYWx0ZWRfX6EwNMxqkg/pl
 wqez/FdpF9/iFO3Va2U2w4GdKJZ7Pj9nTQlA+R6PotsPdOPgD0B+eUveK4TQrib1N/BEjJ2GM9g
 TUCAy5QUJ4HGzgY230GOb6CpmT2GQyg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-03_04,2026-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 spamscore=0 clxscore=1011 bulkscore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611030069

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
 drivers/net/wireless/ath/ath12k/qmi.c | 159 +++++++++++-----------------------
 1 file changed, 52 insertions(+), 107 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/qmi.c b/drivers/net/wireless/ath/ath12k/qmi.c
index b1efed1702cb..ba9365d10180 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.c
+++ b/drivers/net/wireless/ath/ath12k/qmi.c
@@ -3225,77 +3225,78 @@ int ath12k_qmi_load_bdf_qmi(struct ath12k_base *ab,
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
+	dma_free_coherent(ab->dev, mem_region->total_size,
+			  mem_region->vaddr, mem_region->paddr);
+	mem_region->vaddr = NULL;
+	mem_region->total_size = 0;
+	mem_region->size = 0;
+}
+
+static void ath12k_qmi_m3_free(struct ath12k_base *ab)
+{
+	if (ab->hw_params->fw.m3_loader == ath12k_m3_fw_loader_remoteproc)
 		return;
 
-	dma_free_coherent(ab->dev, m3_mem->total_size,
-			  m3_mem->vaddr, m3_mem->paddr);
-	m3_mem->vaddr = NULL;
-	m3_mem->total_size = 0;
-	m3_mem->size = 0;
+	ath12k_qmi_free_mem_region(ab, &ab->qmi.m3_mem);
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
 
@@ -3305,6 +3306,13 @@ static int ath12k_qmi_m3_load(struct ath12k_base *ab)
 	return ret;
 }
 
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
@@ -3359,77 +3367,14 @@ int ath12k_qmi_wlanfw_m3_info_send(struct ath12k_base *ab)
 
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

