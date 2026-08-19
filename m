Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB253A8724
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 13:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787146002; cv=none; b=Rh3STUw/jKsV/O1vbMqylW1VPskkpmegMIela04F8NOXkcyx0aKDKyuAtHEopew1PMVWfWMU8I7HIB5uY3ecNvKe3TeWLnLCR3WVYqQAuUTsZoIOm+MBkryTJJQ0LzFMMKVYego6DmkFhMU+IIhDIpvUCuoFAjgi2wJHlm8rkYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787146002; c=relaxed/simple;
	bh=gzbJaxCxPVY8JnK4ZtjTaXSHrAoIPOQmaGGP+IIpy80=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=X15StdJnXzS+hFk4LsDg5PJQlCZfTxhA0B9QFt3FXxmCzcRgzDbfZ2psDqxW6SzBbnrEQwbqg/SVGRpaKo3OoUeRipOaR7sw56Xn8V/9wRBHvT0EAEq0LSk6nqV5QzwgRkv/fwAe4uQ6hrHMwlUe/dWcqyE1b1EeEv/XooDoJZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=e/wHwrFY; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=F2RHqk4t; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="e/wHwrFY";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="F2RHqk4t"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67JD0P52372639
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 13:26:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	7CJo47Rs0M9LCBUMPKGSlXpd8LIC7VDX3pXhIIqAfsk=; b=e/wHwrFYq42rNYiU
	I1hvIeC9ytkAoW6qxsQOgpdSbzt3axbxn9xFlUl+SLna8EukIwer79oGUe/+VIQx
	MP+zC6DOWjvWBw2UavA/HQokpKD3SF9vYuIlUjSeCm51sMW3rA2W64cam7BSWulb
	Zl7BgdaHw6OBlKUb6Ok7RzFfD93cUHxpVH0m1YU7N0BYAcmwXfbht2r0F+4SI9jI
	2/WMIqqQG6itQ+xW+47XGUJ8OquEjrw/+8EYCckbQRJWSDEiviaVOiYRv8r9+jTp
	AOFLh2COC5GxMP/L/vWytpDb9kdYFc3oRQHVPumz/u1PqKIjVvbLmzmItZXi2AcH
	1Wpsbg==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g4yfkbdun-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 13:26:36 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-388b404eaa4so1689280a91.0
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 06:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787145996; x=1787750796; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7CJo47Rs0M9LCBUMPKGSlXpd8LIC7VDX3pXhIIqAfsk=;
        b=F2RHqk4tH8hpOsiEfQuSw8FOhpfLDKYAcsjDXJYA4IE6mmSAl4bmtB+6O6QwLJWB/5
         fm8ir9O36bePI+CBp7+Lve/+HVErDnez2fXuROJkfLjDxcyUFnLfpvwRDE1FoFcqeQTY
         +NW/XUjKleSNWxrPlJFMf09mxIRQYNizUFLn3UBIXJqEOKrdl08GDMdMzjmHXcGhvhMB
         xilxs8EHL7TdXheaIqntBeQeg2e4e7FVECLTeM5hlQefgZHpHvT7Cn60OjTccMQx+Oe3
         Uvtx0W+m/zGpycmiBt69c/+hZQxaXXqKNQP/wgG9JpsjUBq3ZKKPlMoQVyCsgjhWU4II
         Tbig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787145996; x=1787750796;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7CJo47Rs0M9LCBUMPKGSlXpd8LIC7VDX3pXhIIqAfsk=;
        b=bMvWB5XYrXMsi3TIOPXZoO+wbYm/DVTCXa/FRuSWxk43H4imhnHThUn7uzBNajkEW9
         ZgDZnuygE4KptsAHTYEzX68XuaTDIQqLDpTc46ucV5QDKmRTJ8SRUcd2UycEZdZwI5um
         x+MTeM4mgiCGeLdnHwE8v/MCjoTATx+c3dob5YoVq814L2PDfg5JGS5bn8OZQNXaKoM5
         t7hOh0vV0teloOyB37PQ4hGeYJRRKD2tC1nMbFLDzuyElBJGWrCWemTChhl+JFsmOCuc
         7xoO3FZwkJFzoMY458O8sd61+kDxz+Clg/6lhM+UAvoXIXqgW+4XBGh/CKKD0LsAQVof
         cqWQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqvcds4nvMT6PtaA0ISZVrTjT1wFroRohoQ6+P1o3TB9cMoVN/HfIzE05fry9Rs9nT/Wc9XxbMCG1WrlHPuAg==@vger.kernel.org
X-Gm-Message-State: AFuF++kLz1Yf+kXVw639KHhhQKHBa5LNCq9QKpYE9E0cF1fIU5VuIoGm
	yOdN6eetgbyhU9Ty1bEbxtVM/u/GQrMeKCd/Ms9OkiJ/0esLic5R0I7mv5TbClOrA8zuTK4T0JE
	klAx/c6HKzBJI26OShIasxZooOTILTzQmUAq0kiI7fz404gWT1hcTZMbfgU+1BD7twnbfMw==
X-Gm-Gg: AR+sD13iRhO06rvES2TUCbSllmQpQ24p/SqDe49QMqkLxoMUlZ1pOAo0paQ3eRvFgtw
	9BV6JzIcGgOJWiIeWsSqWz22JaCd0grvL1ITYkYmnGME49jDKI6eJuOYRDNowAfODzYmZJlU9yO
	YXcTRPuQfj0Rch3I/JnFg6+J5X8mjg6mpxgo8ARoVBn/lW47XfnjUqOsoqgoMOP6XWBloo9a687
	SXbGHldiq7INWkg+U0hIPPx1igowwE3u6QX70NEXcULo7eLimtVfXxi4XfsWrullqx+iOQsSGz+
	hg3o2mkAweYPmoHB2ewZEAlU1ywyy9zdobaKTsCBe2eeF/jYcCLzZGNz6YzNPoAIc+i5vN5zgLi
	XcKOuJRGgm3wYVyVwQgO3qd8VvCgxBNLv96Q=
X-Received: by 2002:a17:90b:2792:b0:393:288:29e3 with SMTP id 98e67ed59e1d1-39581212156mr9783583a91.10.1787145995941;
        Wed, 19 Aug 2026 06:26:35 -0700 (PDT)
X-Received: by 2002:a17:90b:2792:b0:393:288:29e3 with SMTP id 98e67ed59e1d1-39581212156mr9783480a91.10.1787145995520;
        Wed, 19 Aug 2026 06:26:35 -0700 (PDT)
Received: from hu-krichai-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327c2a92406sm6126465eec.11.2026.08.19.06.26.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 06:26:35 -0700 (PDT)
From: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
Date: Wed, 19 Aug 2026 18:55:54 +0530
Subject: [PATCH v5 3/6] PCI: Add pci_lnkctl2_bus_speed() to convert
 lnkctl2speed to pci_bus_speed
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260819-bwscale-v5-3-6dea79786b37@oss.qualcomm.com>
References: <20260819-bwscale-v5-0-6dea79786b37@oss.qualcomm.com>
In-Reply-To: <20260819-bwscale-v5-0-6dea79786b37@oss.qualcomm.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        =?utf-8?q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Jingoo Han <jingoohan1@gmail.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Rob Herring <robh@kernel.org>, Jeff Johnson <jjohnson@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Manivannan Sadhasivam <mani@kernel.org>,
        =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, mhi@lists.linux.dev,
        linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        qiang.yu@oss.qualcomm.com,
        Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787145973; l=1763;
 i=krishna.chundru@oss.qualcomm.com; s=20230907; h=from:subject:message-id;
 bh=gzbJaxCxPVY8JnK4ZtjTaXSHrAoIPOQmaGGP+IIpy80=;
 b=loA59unnBaRnNZxvG/WUrecr0BJunX0WpPSWWcivrQvZy9B0XTfHfNyaXVEQX9wEluKQnYWPM
 L8B/TkvKplZDph1FExIucdFvjt33wTNOLQlKQDL/w7YzJYt5HKKSivy
X-Developer-Key: i=krishna.chundru@oss.qualcomm.com; a=ed25519;
 pk=10CL2pdAKFyzyOHbfSWHCD0X0my7CXxj8gJScmn1FAg=
X-Proofpoint-GUID: ID5F_Fi6LslCYD099WtY0jLzqxsx68wG
X-Proofpoint-ORIG-GUID: ID5F_Fi6LslCYD099WtY0jLzqxsx68wG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDEwNCBTYWx0ZWRfX/3IXpLsQplLD
 Uo0dP3r1xkwlxjxQisSvYI2cyKdJle6XscDd4gNVAAdg6fGze1z5L0B+DBlggvzM5dIfQY8O8YR
 AcPE1WaeM0ezQn9Nc5s9ECdnDkX5mEZ5E+bnhzvCo1N4qSFQN+3eTYDi7XpnL8+0Gxbg8bpV2OX
 LqF+wfasZApmPUv/kHWhErM6MfMQewSoP95ryg3Yk/cc/PvHeOTewtH7Bj59uomiqGCoMhvUBf4
 1qH28WiOoKEF71Dr567ZygRNwmsHHmUQyD5rASqsPxnsvG3msBP8mEY590NcpVw+6Lr5lEoUjZF
 HNK+SYmxwsLD5NXpkf6WtiCOxY1sbnbJrMSbvmLvfyPA1US1KRpYCqGFEJGXPu3/M6q7tE5fmrR
 2Lpc+U1ULxxMx8WrAfI3JJJ/OckqitfFgVVc7UzD1mtU0+B/WDO63FixoiauZhwRUdjbaZYH8AD
 xFKN4hgLWVIkt7X/vKA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE5MDEwNCBTYWx0ZWRfX05vzXFr259IV
 U6wwDdBc91K8FN2PaWFWLGd05ATk4hegvlS+Ew8V1okq4N0Z+5Ci2mmd/JNYQWgX5fzpr4/bbkz
 UAJSMyVl93moHxQHCJMoItY69w63X14=
X-Authority-Analysis: v=2.4 cv=fvfsol4f c=1 sm=1 tr=0 ts=6a85af0c cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=rcts_Xg4tTJKaDXoMsUA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_03,2026-08-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 impostorscore=0 malwarescore=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 priorityscore=1501 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608190104

Add a exported function to convert lnkctl2speed to enum pci_bus_speed,
so that other kernel drivers can use it.

Signed-off-by: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
---
 drivers/pci/pci.c   | 15 +++++++++++++++
 include/linux/pci.h |  1 +
 2 files changed, 16 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 77b17b13ee61..cda7d210ddbf 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5939,6 +5939,21 @@ int pcie_link_speed_mbps(struct pci_dev *pdev)
 }
 EXPORT_SYMBOL(pcie_link_speed_mbps);
 
+/**
+ * pci_lnkctl2_bus_speed - convert Link Control 2 Target Link Speed to pci_bus_speed
+ * @speed: Target Link Speed (TLS) value from Link Control 2 register (0-4 for Gen1-Gen5)
+ *
+ * Convert the Target Link Speed (TLS) field value from the Link Control 2 register
+ * to the corresponding enum pci_bus_speed.
+ *
+ * Return: pci_bus_speed corresponding to the TLS value
+ */
+enum pci_bus_speed pci_lnkctl2_bus_speed(u32 speed)
+{
+	return pcie_link_speed[speed];
+}
+EXPORT_SYMBOL(pci_lnkctl2_bus_speed);
+
 /**
  * pcie_bandwidth_available - determine minimum link settings of a PCIe
  *			      device and its bandwidth limitation
diff --git a/include/linux/pci.h b/include/linux/pci.h
index d1f2d382189d..244c145af04f 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1727,6 +1727,7 @@ int pci_cfg_space_size(struct pci_dev *dev);
 unsigned char pci_bus_max_busnr(struct pci_bus *bus);
 resource_size_t pcibios_window_alignment(struct pci_bus *bus,
 					 unsigned long type);
+enum pci_bus_speed pci_lnkctl2_bus_speed(u32 speed);
 
 #define PCI_VGA_STATE_CHANGE_BRIDGE (1 << 0)
 #define PCI_VGA_STATE_CHANGE_DECODES (1 << 1)

-- 
2.34.1

