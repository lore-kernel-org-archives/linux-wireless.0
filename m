Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CED3DB64B
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 08:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787645605; cv=none; b=jpLodlp9TrtN4+2o7rn3YSC3jb0V3NGOW4tx6uFVHzOBThBLWk9SgHGIiJu9wSNMxExtenBAeOA5O4lwI2iFkokz24UAfpEIqsTDnOumpGLG1rwfEz/9Q4LOvWfrtD6m/xrlFVCay9mVMLF5Vi+oTpRc2MWasXYxHDspG3OmtHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787645605; c=relaxed/simple;
	bh=QQ4Mp+MQrZ0abZOXlL4Gh1EJOdpfUwc8kPhdt3VDwl0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FXfTX6fC6wmqD0PNfjB2uVFmD/TgaiJNHqKkLXyqghWWMyfeB8RDXDAah43+pfnq8MFNKHAYMYfVIkVyPQDZdi1W/0fXuhigEK5Kb9CfEY4C3Cbw0Ua9Hg7d7Grr8NgZRr+nnoueGdHmaP8JxNPzHWQC4v3XVDrtBITX+yDgP+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mPyjSrU7; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RUevpzYh; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mPyjSrU7";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RUevpzYh"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67P88MGR2387935
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 08:13:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=hv9r+64K3KZer1HaUJU7uPLWJOybOoMeHi6
	liK+PZew=; b=mPyjSrU7iaatxis04yo5xMJkEkXPAJr+nnE5OHTt8BYiDLc1cZR
	EOSgU/rOYvIeKSZRChpG/pvhq12tZ91VmeTqt/MxIm/blYeAIXBeb+AxL+P48sFH
	aoUwKwMWNLh4N2e/L74VXobdgEFb0B5PSsjoAOZnLMLptIjYRXAZipbgtvarTkKc
	uk5WxTYMAq0YSkcp1JUXnUCdWfav1XC6jfIw09eIaeVQ683rfKAQ7b3E9D+ZADF4
	uG/XAPwegx3i+MMndXMa7XyTvRTxsbyTmS5nBDGoxPMqkIi8aZFclObGkckmpJvn
	gXuFucvE7yM4ersiW17v/NaenmPNdSpJXqQ==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g8swraxsv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 08:13:23 +0000 (GMT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-90410c668adso40144536d6.1
        for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 01:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787645602; x=1788250402; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hv9r+64K3KZer1HaUJU7uPLWJOybOoMeHi6liK+PZew=;
        b=RUevpzYhOcfCWE5kPDOzQCjlELq5P70931+QgTBOHaFGMkLHQhJARlYtYdPkrgdtaX
         RJoVxx8ceW0OnT6nQSQmJFtzpc29EfJyJouvU3SPrhpWBfKtbmwaCj6MD1g79MNlqZ76
         gSEFah+spLGQISOmv445JhINnUy4Gl7OAYn6VDbi9TiKqxmwsu/3MFM7xqX2Zo/0DhvZ
         /XDWZILZaCKl2hm01Vs7h+BJyTUlJsSBETJkdj6ZP7AFommkoUvNCY83CzO4ZIB931mr
         cWl65tfT/E2fiEwUiB/xFbYHcj1uQ8YfjudUG4c+FlMlNpBHhdi3WxumEeaY7NtaivQu
         mslQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787645602; x=1788250402;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hv9r+64K3KZer1HaUJU7uPLWJOybOoMeHi6liK+PZew=;
        b=rXvugU/tTiZeBPwcmMwBuKYOUOLE89eZoHef1zoshuE+wAqrvqj0OvSi98N5mUZkvf
         iAI7h2kLKMNfac+ENeQiHNxkYJlweZV/9qTd3fF3fOkbNqMeqqvqv86xKHJtV0341IuD
         CkczsgapQFv1pauor0mNMcKSnrg2CEZp96GhB2z4lLx9jvzskXwBV89iTQbm5dBOpJ+K
         EYDEMBrec1nPNvzsXNz6Xq9qUVDciLfBx4TSZ81tKAWYVke4PhoAKGOVxbHJtVmplchz
         6Dz3aRiEqqy9eqWuY8wXo+/xWhTcdP7HqiV2HjmsxRWC445Glo6rm14zu3fN7t3tbKSL
         6hCg==
X-Forwarded-Encrypted: i=1; AHgh+Rob64C+jRaFoZkw72L38fKLm5NxVm+y+7iMAsI3O8kCjWjNwSgj3jl1jaQGbBI3lB0uZDtA3vPTsXzTe3dqoA==@vger.kernel.org
X-Gm-Message-State: AFuF++nbOAFH6z8cCludJdq1sgxqRb8BQhWc/05vkHhF/KKE2CZNINd4
	VPqsGsmxOmKKTQzXgf3XJWFVv+gDLwflUr3D1U57XGzV4RahX5/JhJRPjwT3+Wg/TNFyFCLdHBq
	qY67FJeN2AsbdsVpKsVzJqRnXP8QlJBOliKyE0Ww5LcNIF6tzJEF6A247T9qLMpTCdidIYw==
X-Gm-Gg: AR+sD12EhXt/GrWwFMYrqoSePKH5QQ3JYnlQpgLGhLhNBCKvB26lz5A+oEcFzz9U/Qy
	P1k5B1V4UtZS05VJXC/lN0O/ku1ltMSmNFVzucUQJLSMNAkaWJYxjLhx0qUd13zcC3+fZSku5a/
	43jz/c/2gi24NktP+jhQi2jfAhSpa7M4R+ZGdfpuhVDP3fdDqzmwgKwoOdv/ZBontgc2iK1iTiO
	2Oqq31AjKlqK3CJt1bK77PM0kIqx6YVhS3jw2vmWv5iD59ykRXghUugDJHsZvnPMN+oddtTHnm6
	s+Bplx4cIh4niRRfYDDdi4WMQEwgseU43iFMAVnZpBQ7HL5LncgOMWsbQ0ZY1P/fqKoV8vsPCCh
	KLoeS1uxIWgAV53Y=
X-Received: by 2002:ac8:5f53:0:b0:52d:6afd:7db5 with SMTP id d75a77b69052e-52df59ec0d3mr344910591cf.25.1787645601990;
        Tue, 25 Aug 2026 01:13:21 -0700 (PDT)
X-Received: by 2002:ac8:5f53:0:b0:52d:6afd:7db5 with SMTP id d75a77b69052e-52df59ec0d3mr344910221cf.25.1787645601382;
        Tue, 25 Aug 2026 01:13:21 -0700 (PDT)
Received: from quoll ([178.197.219.214])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249672becesm1687582866b.42.2026.08.25.01.13.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 01:13:20 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>, linux-wireless@vger.kernel.org,
        ath12k@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH] wifi: ath12k: ahb: Revert undocumented ABI and dead code
Date: Tue, 25 Aug 2026 10:13:14 +0200
Message-ID: <20260825081313.71351-2-krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3254; i=krzysztof.kozlowski@oss.qualcomm.com;
 h=from:subject; bh=QQ4Mp+MQrZ0abZOXlL4Gh1EJOdpfUwc8kPhdt3VDwl0=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBqjU6ZmH29I4c1VwrnjgwykypA4ZmZkqL3qWwfl
 reZhLKS73GJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCao1OmQAKCRDBN2bmhouD
 1ziiD/45tKK4t4NoPjGQYgAtqj4adc82l82kkAMngH2NL7E/kDcnYCxrDWaafpAzJTp02bwCsWA
 7u9eaizT6xEKeG+y9bDo3lr/YvEaVSJ7bDH1Qzx8aaMWPl8GNM6xb4NqpPrca3L5fUHawOVjtCt
 Iy0wMTsx0NfUeCWmLOyRooSf+zTlFAFlFl6IvApkQeOwrFohCdGKaZ+cV9VPSL5Gu9LOZLqZi0H
 4U8L44j68gY6jyybO+RXaSLTy4qg1nBrFCs1AAl1/1CASnZZ2rIIkt7rNz1NxYaXnGC14SvcbHU
 zAsvVkDCDN00KuZNVc1Yaq1qs23PHelxcOm9/XakIklZMtkMM7y+9gty9GXXChBAwtWrul56jQR
 Nskx1sxSFoMPAn8fk0t1yle1h7751f5nKKIzmb28nsF7W3yumsOfGwHyoZwSYVT0H8x79lKj+yb
 wEKm8XhbjWjyEWazPIgTZuseVmVwrFiJRAuIvAhMDTM92ggo+8JV9OLBp3WGHqCpLcCqKBuZJVb
 K0Dw/xkYdlX0ruTO/DIGLslbmUju5FnOvtXSmNPaP+SvNM3WtE6TlGRl4buc+Ff0w+UYw0++3R7
 s+3W9CYaGpzlBvYDQwm7inXm15q49zNKvxrkxsOxKIIKdwHHEIEmIe2pUoe8AG5PdM0xAFRzQmW KQlKrpcbHCxZrug==
X-Developer-Key: i=krzysztof.kozlowski@oss.qualcomm.com; a=openpgp; fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: FxTv2WhNFVRQW2U6hU01u67TQ-MezOWS
X-Proofpoint-GUID: FxTv2WhNFVRQW2U6hU01u67TQ-MezOWS
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI1MDA2OCBTYWx0ZWRfX38u2vJ05WKU7
 LjWJz46MU8hKX9Z6f+E7cDUqRqjiD1FzxIvNELsyiw0M4uW4u3Im6/RBjisV4GBn9yTYoGcjSmA
 DHAs9Rxvpxvvu/T03TivGgEYA4C0pM4=
X-Authority-Analysis: v=2.4 cv=TqPWQjXh c=1 sm=1 tr=0 ts=6a8d4ea3 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=+bKQE0WJfmhK2875HamI0Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=EUspDBNiAAAA:8
 a=Rjp3qrauO7Pr9jUhhQUA:9 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI1MDA2OCBTYWx0ZWRfXyW0JFGgA5dpc
 RcFxuAtBfT76XbxIKmnD0hmmUpCpUrmY0K7RmR/haFXAlzc5/MmOzTx3jn7xqcpVoZUUMMkEaiC
 vGUkhpnthxlz2Ev3ZF+7xF6V4nbyDsL+bebNil87BG/1SN4XBSReqV00MyuC6kn/eJSIJYK4P24
 duYRJGg0wwbLHx2bLIrLnxGjIrqXjzNSPrFIQ/BjHthpnDdW5DadoG/07dASJFY7EVOyWWTTmAY
 XzB9xD9zruFH1Lz6JLtcSg0DAfaUitnM2PiqXN/nzxPaZYIUDLZ6TuUvpPh10pb1HA2VCdF1tpc
 svcqv/7N+WFR3yk7JZUFRch+jkQZyvuRpdC2TvIN0HDutNn7jFlZV3RfoDvV3hu9oAl3EG5H2kh
 3rQeQ4aFJyChba3qUUxjuFsO4M5vWjGTFLDP1a8ocwNalEPj38oLKYZhH6k/XgWlKv2wh2iAMWz
 TT6fK4CUq5fYUuQ5f7w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-25_02,2026-08-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 malwarescore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 suspectscore=0 priorityscore=1501
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608250068

Commit 96f46607bbce ("wifi: ath12k: add AHB platform descriptor
support") added undocumented OF ABI, by relying on a very specific node
name.  This is not allowed and was never acked by Devicetree
maintainers.

Additionally that part of code is not even used, because all devices
have exactly the same user pd, so this was added "for future".  Adding
dead code just "for future" is heavily discouareged in kernel coding.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wifi7/ahb.c | 51 +--------------------
 1 file changed, 1 insertion(+), 50 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/ahb.c b/drivers/net/wireless/ath/ath12k/wifi7/ahb.c
index 98a6606ffd76..6e9e9034cba1 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/ahb.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/ahb.c
@@ -15,21 +15,6 @@
 #include "dp.h"
 #include "core.h"
 
-/*
- * Node name to UserPD ID mapping
- *
- * The io_start field is used for additional validation when the reg
- * property is present in the device tree. If io_start is 0, only
- * node_name matching is performed.
- *
- * For platforms where not all WiFi nodes have a 'reg' property, set
- * io_start to 0 for those entries. The driver will match purely by
- * node name in such cases.
- */
-static const struct ath12k_ahb_userpd_map ath12k_wifi7_ahb_userpd_map[] = {
-	{ .io_start = 0x0c000000, .node_name = "wifi", .upd_id = ATH12K_AHB_USERPD_ID_0 },
-};
-
 static const struct ath12k_ahb_desc ath12k_wifi7_ahb_desc[] = {
 	[ATH12K_HW_IPQ5332_HW10] = {
 		.hw_rev = ATH12K_HW_IPQ5332_HW10,
@@ -55,40 +40,6 @@ static const struct of_device_id ath12k_wifi7_ahb_of_match[] = {
 
 MODULE_DEVICE_TABLE(of, ath12k_wifi7_ahb_of_match);
 
-/*
- * ath12k_wifi7_ahb_get_userpd_id - Resolve UserPD ID from DT properties
- * @ab: ath12k base structure
- *
- * Returns: UserPD ID (1-based) on success, 0 on failure
- *
- * Resolution logic:
- * 1. If reg property exist in DT, get userpd_id from io_start
- * 2. If reg property is absent, get userpd_id from DT node name
- * 3. Return 0 if no match found (probe will fail)
- */
-static u32 ath12k_wifi7_ahb_get_userpd_id(struct ath12k_base *ab)
-{
-	const struct ath12k_ahb_userpd_map *map;
-	struct resource *res;
-	size_t i;
-
-	res = platform_get_resource(ab->pdev, IORESOURCE_MEM, 0);
-
-	for (i = 0; i < ARRAY_SIZE(ath12k_wifi7_ahb_userpd_map); i++) {
-		map = &ath12k_wifi7_ahb_userpd_map[i];
-
-		if (res) {
-			if (map->io_start && map->io_start == res->start)
-				return map->upd_id;
-		} else if (map->node_name &&
-			   of_node_name_eq(ab->dev->of_node, map->node_name)) {
-			return map->upd_id;
-		}
-	}
-
-	return 0;
-}
-
 static int ath12k_wifi7_ahb_probe(struct platform_device *pdev)
 {
 	const struct ath12k_ahb_desc *desc;
@@ -106,7 +57,7 @@ static int ath12k_wifi7_ahb_probe(struct platform_device *pdev)
 	ab->hw_rev = desc->hw_rev;
 	ab->hif.ops = desc->ops;
 	ab_ahb->scm_auth_enabled = desc->auth_enabled;
-	ab_ahb->userpd_id = ath12k_wifi7_ahb_get_userpd_id(ab);
+	ab_ahb->userpd_id = ATH12K_AHB_USERPD_ID_0;
 	if (!ab_ahb->userpd_id)
 		return -EOPNOTSUPP;
 
-- 
2.53.0

