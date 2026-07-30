Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE5E39060A
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 16:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427270; cv=none; b=ItKPZywo9eJ2IzcupgYMEFhMgbNGS+s57XBabqpefk55IfvkfkjAFiR8M3xtcFRo2E7GZAsyU9u/q3ENXZZ4pJA/tt+aRwxcD78CqO6gvyfax5LBfN8JN5PVJ1UWSQ/w3eDUOkNAav2HZVF7RSq3O5fXHmxY/65VR0XCa2Mguvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427270; c=relaxed/simple;
	bh=L92wgefYXvtbzOMdFEhUTkLwtCR1yYb0ZcvRRGDMuNM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=EcRVQ4Gg080/cDgg+xvp2XXHBfGfY44X+XRDExv4obWps768XYmDRv98DhGieaVF9jgwWWYfa6QmecJrcGJSKZoEHG8mUro4U6D6kgJxRUdd5AbyfDAHefIlR0hCQ9j2hNjs9ybYdGlk0fJQoR/xbkp404GSbG5Eb4IY781TsbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YT7WVXhE; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=c7eBGp/v; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YT7WVXhE";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="c7eBGp/v"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UFQp3k1144998
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 16:01:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	cPeNqGPMRBWAfsA5CvuzYdqPrDk9qOkztMDjoEMaK1o=; b=YT7WVXhEsZRuo4tj
	rRS18ZkhpL5M/kLvIYGgnkfXMVwlcTPPbuqRyMuROdWq9ab8QuFzzS63kAEy5Bi7
	Bvul0ORPu/UUS9bzL1gT27Zxr+5i5GR57qvYOl+bme9l1fq5wRTG5PZrnEw1l1eW
	1/rR4Hr3YnpsT2IOumRcSXZ6WlkW2Cw7icpC/OTfAsoMgmmy8/lGe11+NAlgfwKh
	4I7NSS5Jjo8umJcK+JZEfDhGuzM2LaU8JxjSapPBb1pC1al/8a794ME7mQaDak3J
	BmjU11jGwrDQ8FhK1xknkfHycAOXCqqXpbGdQGFoXBO6yOHNx/aJtQe9jm32PfGv
	wl8fGQ==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fr8k60f67-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 16:01:03 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-52827090cc5so11971541cf.0
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 09:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785427262; x=1786032062; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cPeNqGPMRBWAfsA5CvuzYdqPrDk9qOkztMDjoEMaK1o=;
        b=c7eBGp/vY0cHLNRlKO5upfkX4e4aWZIV/B8yN383nMapLLHloSJzLqto2X4chQfPqY
         pmHS803tEb6Swjqg2nPbdPRDHlOcG5isZMrvnbM2QchGeHrOHYUgxXrx3OEuDD1pTJB2
         d/quBbt8NNAuix77mkfw7WsD29FCUcbQxop+Nwv/K3ze1BS4vGd7i2AdRGROf+qHYvFY
         O0ktu0UpFhNLK2ROgkxeoBHg+y9u3ZJuay7e9UA0HAscu6FAW0tkbCDVpA/d7l2Lk8F3
         OOQlDZcAl7cFVP7o5X/VNIwxePjZCodVymLMrmL8eYYBy2damXfeZkmPnFpMvjlp0yAj
         /FPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785427262; x=1786032062;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cPeNqGPMRBWAfsA5CvuzYdqPrDk9qOkztMDjoEMaK1o=;
        b=lX+ay1RwccnlhaFn3KPlfkJ2n4jyvjMGyUmJZrsYdckCNGUqCVStjl53gTAezpkICA
         BjM0s0G5pf7nTSIXbroWeb+gp9bIRo/VWTGTp+oeslWJg0eLFAch1/MTcvigayCx9U6H
         ukpwZQtY6Jhys/zT5ugEmhcbRYF/CZ3Ilcre1jMCOhPEKq9ZRVF0XpZThv1i3dxaaEZ5
         zNGoSmHK2LUX5g1IyaEH5lOHbvDPjRDq1BeDqQyY3Kgfxz0PRQHXF1XyiIDMfqmGK82b
         tTfoSr8XjOviZJMobQhNWD97QIwK+SglXF4YWJhT1SKRG0zPvVwjfwuUdS5ZpMjJiK+s
         anPg==
X-Forwarded-Encrypted: i=1; AHgh+RqpKBw2zH8+5YHue+HWKw30IzDp9FSmpYBmtbFe86aJWOsMd2R0fxgU5llcBnWo97rAi9bfh9WzuSqIVccmWQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzuZikRNgGweAzgQy8b1/0uLLe9U/AO8YErZXPtSv26y6jGDjWP
	6fEENnsejsunLsoOtBYpSI85L8+L7W1PI1cdpGHlzy5MG2zTsgR+PsAeimqFUo4q6YEmAUdzVH2
	2MeesId/+tk+bf7UOTszixWiRQxCCFlyI/2XqHiy+tz+2DtQtz5tVFT+6fI19vgB4iSVeOA==
X-Gm-Gg: AR+sD11u9NZGgr0xyknGh1iAt2N2MU59LteUJJoNngETTO6ZDG/RXVWIq5pFcd5dUKO
	qm49S2yDKpMte1QuDsd4nvyZ7Rz4Jbdu5F4zAGkcCkSJxZoGk+H56ArxA/A3jJq3VD75s+hYi/w
	GoLKEYGp1mMKyzlKT2QO9FcytinGT9RoIGu/u3Z0EP53VBC2lN8pRmnj75EDvlGGwDeQsOXN8tE
	yp3HbF6WUC693iu3Ij7CzKeWSG0+Ss8CzMUNkFGPZW9m7jPlHFZbNbjVM94g3p/RQHXmKYaa0iq
	iF7PM6TUy6YVBqiFHlWmyT0GJ89SOal7JNPREHTKXpJ+8PUaKW/3Gr1lESSL+gh9sjTyL/7YUaX
	avpvTzA7NUjjWT+SqXEog0FuO8WeNzH8ILKI7Z9375Np85Gd/04P3RzZHCK6Ub4OW3hkr70TB7R
	kRv/BKOclmZ6+cOqf4EtBivkt8rtAO68NM89wpsDGe5EL/WG0F8EZO
X-Received: by 2002:a05:622a:488d:b0:528:1bad:a2a4 with SMTP id d75a77b69052e-52b424e2ebfmr11075331cf.15.1785427261798;
        Thu, 30 Jul 2026 09:01:01 -0700 (PDT)
X-Received: by 2002:a05:622a:488d:b0:528:1bad:a2a4 with SMTP id d75a77b69052e-52b424e2ebfmr11072291cf.15.1785427258968;
        Thu, 30 Jul 2026 09:00:58 -0700 (PDT)
Received: from QCOM-eG0v1AUPpu.na.qualcomm.com ([2a01:e0a:830:450:61cd:dcd3:c61a:ac3c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1fa8bb6deesm85168066b.53.2026.07.30.09.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 09:00:58 -0700 (PDT)
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Date: Thu, 30 Jul 2026 18:00:37 +0200
Subject: [PATCH v9 07/10] net: of_net: Add of_get_nvmem_eui48() helper for
 EUI-48 lookup
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-block-as-nvmem-v9-7-f72935817dbf@oss.qualcomm.com>
References: <20260730-block-as-nvmem-v9-0-f72935817dbf@oss.qualcomm.com>
In-Reply-To: <20260730-block-as-nvmem-v9-0-f72935817dbf@oss.qualcomm.com>
To: Ulf Hansson <ulfh@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jeff Johnson <jjohnson@kernel.org>,
        Bartosz Golaszewski <brgl@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Balakrishna Godavarthi <quic_bgodavar@quicinc.com>,
        Rocky Liao <quic_rjliao@quicinc.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Srinivas Kandagatla <srini@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Saravana Kannan <saravanak@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>
Cc: linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-block@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, daniel@makrotopia.org,
        Loic Poulain <loic.poulain@oss.qualcomm.com>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEyMCBTYWx0ZWRfX0XxtoZknJTqB
 VxQxtJlPn96j6eUGldmjj9yrQPnMR2IZmh4BX2WS6tTiCMge1C6BIsdDLEq/7bVJo9qwbH/c8ny
 KPpAdBmnPN5aprA4oJqZkr3ZUjWgGwMOXT9QY5uwvUwCOtvwH2t1v/S+AOZXUGPxXanWSlEzBwq
 +ONS2Fg+SqVtnEqAOv9iQsUCT3/ROS+w0VfwLB4MI63pkkjrHP2GLIB4oSnqt61LgJpsXszUEjH
 lSldeJoWXBQH89bVstbQgvWE/iuJBp+BWAQ8vuRKkCg+hdTppkOSxumR362znmA+uaFw0c1iPWp
 +Tovt8SLlg8aV7LcvA13GKDvSgJm8AL2K4WeFnN/23i+yGx15dk/3fB6Np065druXWlgLoIygxL
 dSAkDrSom+fJ2PAHa/cSfrAONhIBpA==
X-Proofpoint-GUID: 1-Ffa_kNbSYN4iFtijCQPUU5ppVYfnlH
X-Proofpoint-ORIG-GUID: 1-Ffa_kNbSYN4iFtijCQPUU5ppVYfnlH
X-Authority-Analysis: v=2.4 cv=Wqgb99fv c=1 sm=1 tr=0 ts=6a6b753f cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=EUspDBNiAAAA:8
 a=bEbww9rD5qa0LKludeoA:9 a=QEXdDO2ut3YA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEyMCBTYWx0ZWRfX7IN0VUp2O0b8
 EqRPKP7LfQcP1O6cEapp/+1XGFhh3BXoJlAuEKga+uWtceZrQwdo2BvpzYMof792xPeT8dC34XM
 2mpFQJCdCeb6FaCwvpXfwiE88RK31to=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 phishscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 classifier=typeunknown authscore=0 authtc=
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.22.0-2606150000 definitions=main-2607300120

Factor out the common NVMEM EUI-48 retrieval logic from
of_get_mac_address_nvmem() into a new of_get_nvmem_eui48() helper that
accepts the NVMEM cell name as a parameter. This allows other subsystems
(e.g. Bluetooth) to reuse the same lookup-validate-copy pattern with a
different cell name, without duplicating code.

of_get_mac_address_nvmem() is updated to call of_get_nvmem_eui48() with
"mac-address", preserving its existing behavior.

Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
---
 include/linux/of_net.h |  7 +++++++
 net/core/of_net.c      | 52 ++++++++++++++++++++++++++++++++++++++------------
 2 files changed, 47 insertions(+), 12 deletions(-)

diff --git a/include/linux/of_net.h b/include/linux/of_net.h
index d88715a0b3a52f87af23d47791bea3baf5be5200..7854ba555d9a55f3d020a37fe00a27ae52e0e5dc 100644
--- a/include/linux/of_net.h
+++ b/include/linux/of_net.h
@@ -15,6 +15,7 @@ struct net_device;
 extern int of_get_phy_mode(struct device_node *np, phy_interface_t *interface);
 extern int of_get_mac_address(struct device_node *np, u8 *mac);
 extern int of_get_mac_address_nvmem(struct device_node *np, u8 *mac);
+int of_get_nvmem_eui48(struct device_node *np, const char *cell_name, u8 *addr);
 int of_get_ethdev_address(struct device_node *np, struct net_device *dev);
 extern struct net_device *of_find_net_device_by_node(struct device_node *np);
 #else
@@ -34,6 +35,12 @@ static inline int of_get_mac_address_nvmem(struct device_node *np, u8 *mac)
 	return -ENODEV;
 }
 
+static inline int of_get_nvmem_eui48(struct device_node *np,
+				      const char *cell_name, u8 *addr)
+{
+	return -ENODEV;
+}
+
 static inline int of_get_ethdev_address(struct device_node *np, struct net_device *dev)
 {
 	return -ENODEV;
diff --git a/net/core/of_net.c b/net/core/of_net.c
index 93ea425b9248a23f4f95a336e9cdbf0053248e32..999ca0e9258c41580823b80e0ef6db26617bc968 100644
--- a/net/core/of_net.c
+++ b/net/core/of_net.c
@@ -61,9 +61,7 @@ static int of_get_mac_addr(struct device_node *np, const char *name, u8 *addr)
 int of_get_mac_address_nvmem(struct device_node *np, u8 *addr)
 {
 	struct platform_device *pdev = of_find_device_by_node(np);
-	struct nvmem_cell *cell;
-	const void *mac;
-	size_t len;
+	u8 mac[ETH_ALEN] __aligned(sizeof(u16));
 	int ret;
 
 	/* Try lookup by device first, there might be a nvmem_cell_lookup
@@ -75,27 +73,57 @@ int of_get_mac_address_nvmem(struct device_node *np, u8 *addr)
 		return ret;
 	}
 
-	cell = of_nvmem_cell_get(np, "mac-address");
+	ret = of_get_nvmem_eui48(np, "mac-address", mac);
+	if (ret)
+		return ret;
+
+	if (!is_valid_ether_addr(mac))
+		return -EINVAL;
+
+	memcpy(addr, mac, ETH_ALEN);
+	return 0;
+}
+EXPORT_SYMBOL(of_get_mac_address_nvmem);
+
+/**
+ * of_get_nvmem_eui48 - Read a 6-byte EUI-48 address from a named NVMEM cell.
+ * @np:		Device node to look up the NVMEM cell from.
+ * @cell_name:	Name of the NVMEM cell (e.g. "mac-address", "local-bd-address").
+ * @addr:	Output buffer for the 6-byte address.
+ *
+ * Reads the named NVMEM cell and validates that it contains a non-zero 6-byte
+ * address. Returns 0 on success, negative errno on failure.
+ */
+int of_get_nvmem_eui48(struct device_node *np, const char *cell_name, u8 *addr)
+{
+	struct nvmem_cell *cell;
+	const void *eui48;
+	size_t len;
+
+	cell = of_nvmem_cell_get(np, cell_name);
 	if (IS_ERR(cell))
 		return PTR_ERR(cell);
 
-	mac = nvmem_cell_read(cell, &len);
+	eui48 = nvmem_cell_read(cell, &len);
 	nvmem_cell_put(cell);
 
-	if (IS_ERR(mac))
-		return PTR_ERR(mac);
+	if (IS_ERR(eui48))
+		return PTR_ERR(eui48);
 
-	if (len != ETH_ALEN || !is_valid_ether_addr(mac)) {
-		kfree(mac);
+	/* Reject unprogrammed cells that read as all-zeroes or all-ones */
+	if (len != ETH_ALEN ||
+	    !memchr_inv(eui48, 0x00, ETH_ALEN) ||
+	    !memchr_inv(eui48, 0xff, ETH_ALEN)) {
+		kfree(eui48);
 		return -EINVAL;
 	}
 
-	memcpy(addr, mac, ETH_ALEN);
-	kfree(mac);
+	memcpy(addr, eui48, ETH_ALEN);
+	kfree(eui48);
 
 	return 0;
 }
-EXPORT_SYMBOL(of_get_mac_address_nvmem);
+EXPORT_SYMBOL_GPL(of_get_nvmem_eui48);
 
 /**
  * of_get_mac_address()

-- 
2.34.1

