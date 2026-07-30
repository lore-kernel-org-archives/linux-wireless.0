Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EAC8449995
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 16:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427256; cv=none; b=DqSHX+Zr6PJH5hBYwyGS2Hhk0vf5SH78tLr9GZ0cBtt9u9cdcCl8+NEivw+WKxHmi+dwtIwsjzJJ76P6JlD02nawTrhz7kUpGbzRF6XoLcQLgw6ptjWYz+hSQ4kIWgGRkjd4A2xnjK1jqfMQGRIukj5hDEuC4mUEjzHD0NvQ9Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427256; c=relaxed/simple;
	bh=NYZrwdZQ8Unx+4+MfgqEtix1DA4oaM8IOP1pJXmdN5k=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Bv+YjP8mlcqO+xaEIACLmrosOc7ofy85LbxFj80bPilU5eI9Q8aM4mCfIRuQuuBF74fSAnS3ZKxKlMxt01cALEN0y7VGMjd03Z8hQHThFKeExuzm3QrwwUW2sO2Mu8nasBqSuhOv+VFCPLxKjv5r8b1A8nZt22tCOa82TsPwN78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=M/jRX1Tp; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=UGXSs/Ar; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="M/jRX1Tp";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="UGXSs/Ar"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UFQrxP1223244
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 16:00:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	oLlLllLuzegCOZuXn5+dUp09HoQyVIGVgRcx14v62PM=; b=M/jRX1TpvMeqUO/P
	PVSImvtbdOfYbcOhO0VXezo+gXswQjqaHNvsJ3Mbp0b8x8Kyeye2BSJbUG+/C4Rt
	9KdEnjt9DqMob4WOB+dpqLM+JfKHUAxy5gSjY/BtUJQncrKHUO3/rZv5R7u03tOr
	AXHcTNZy+Q2+koiThYECm5Vu07/NgdJWrdfhJ3F7qhjr9L6LeZ5c50O+NZVOiuce
	JCPyjNPfpScmNOyxtR2uei4gtyrYng/bz0zpFaKDRapZKZNBpGa0ocmPhQ/ESFPY
	ubUJ+4lOJYsrXa2QlWRB0oI7usRTN7gqiJfSihZeCr9DbkBPMJ1bF3tPXJbYuewE
	5jcxEQ==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fr8jmrek5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 16:00:53 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-51c0199faafso24483481cf.3
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 09:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785427253; x=1786032053; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oLlLllLuzegCOZuXn5+dUp09HoQyVIGVgRcx14v62PM=;
        b=UGXSs/ArpohcB2EuuFzE8rDKRfyf9HKxZ5OtuYW/qCwKZicpiUvDJBadxFWNbCgVdg
         LZXc/0aMy3kx9EPlwHWG7zOY0zbfyhhBxsjZxqzAgiSRfu7CT9pj+2+dpJNdpQahBR29
         I5UDhefViSmnjPS44U4jSOOUUyduQaPMffbqRAXvRAFZudp2sdU01e25HjG18fSKjroO
         l9fC3XjKQN42Fzy2FD6NkuqipY/kxu7I1GgPV6Ak8Fviu12dknp8bHh6D9CSKsAJH3Ic
         101JatoTRNXqRfDtYW95EFpsV3LRYWtQhZCpUg1sxFoMNMUOLBXVZjLXOCpun5AbZGiU
         GALA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785427253; x=1786032053;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oLlLllLuzegCOZuXn5+dUp09HoQyVIGVgRcx14v62PM=;
        b=BfGvC3C/mlIIerYL3v4DymjiVGj/c7HNlPcSt4GFf+/PA2i49GyxYhsulGPqvAjAOw
         N4l/F4GbmxMcXN7ibE6RnBuEsOBgy+9XQpp5QyqYBXR4F1tiR9d5rEvEEuBUPiLBCoHs
         tWTWb/hdTCpRtDA8UwfApC9n6z8C8aNtiKtRoiSEtEWQdzP3eYzBcQEnPYtynhscM6pY
         eCGOoNsg9BRmP3WgXd3UaSZhekBSN1QiD/u/cJC9HQJTF0kgQWEMywLauDQuRv61kZZW
         1EXLEe0YyYNdy7Cr0VwkG4b+45IKLASZCQPD7MSEVKhh+3v3129E1G/Xu2TPW+kqF53L
         7SJA==
X-Forwarded-Encrypted: i=1; AHgh+RoVy6oRipTowGHP3USoyQk5del3HTB9ur9KqeN46xmMbeh1igGZH9hRD7EBNvfyhpehVcVDdt6vRRcVxnPXZw==@vger.kernel.org
X-Gm-Message-State: AOJu0YznPcHrDYSO1ytNO0SM5xwbd1vRBiocJbUK7V/v34ZXIo+uWw8R
	yhAZYE3QSrYa0EZhx4l/fiFd56WQhGiJpbsbNKkxC+eq+RYnoCvLJeLca5sqQU4m22LxSTYwoUf
	x4CoFr47Vt/sPSbjIyP+7yt/n7HAYbD01p6OjBTeeSJYsJi5aj3GmE0/YqfHssoDXvrFGJw==
X-Gm-Gg: AR+sD13Zrz99uJ/zVpFhXPa+tEMnyINvhd+ZJWZBQ9jRl7GBDFh8z1I8MKeY6Gq8Q4S
	WTy80FKZOM3DJoPYLHjrI9wgM3NOuCqU9X1eJrD9FdBzFLfGlpr7hYiKRXyn6ae3KS0F7L0qz4i
	tzZNQBJU88Dp5dJvZ9wtTvaqJgWZlZkpevdY76mnrt7Kfg23O3TRatEgMJtqOXVcd0b/EGf4e9v
	bIjcYDAaF/xNVUs1Uw1i7uhRIA+EH4rSaa3+aZr4oKaKi5VCzhP0lt8hYjLWPYZD1iW7MQM6StE
	ySz8K4LOAdykhMzaI5isVVJ8D6ICibWv/Rlm5S1ogdmEPB5OtP0O2ukAXorW7vep3JMv4x2Np0w
	NOM/L93gJMWt8h4yB20/F/RFTyASqZhhxOdHqFI+n6UhTuC2YCUFGQ8xYyOdZZ+/ZT7xPJ++dbx
	8IlDDr0n/EQ14oBLOmOpXLE/aSb2PDTaLw8BIoXDX95VdLkF3QbAHw
X-Received: by 2002:a05:622a:4d8a:b0:527:73a7:ee21 with SMTP id d75a77b69052e-52b3871bcddmr35047021cf.86.1785427252163;
        Thu, 30 Jul 2026 09:00:52 -0700 (PDT)
X-Received: by 2002:a05:622a:4d8a:b0:527:73a7:ee21 with SMTP id d75a77b69052e-52b3871bcddmr35046061cf.86.1785427251550;
        Thu, 30 Jul 2026 09:00:51 -0700 (PDT)
Received: from QCOM-eG0v1AUPpu.na.qualcomm.com ([2a01:e0a:830:450:61cd:dcd3:c61a:ac3c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1fa8bb6deesm85168066b.53.2026.07.30.09.00.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 09:00:50 -0700 (PDT)
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Date: Thu, 30 Jul 2026 18:00:34 +0200
Subject: [PATCH v9 04/10] nvmem: layouts: Support fixed-layout as the nvmem
 device node itself
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-block-as-nvmem-v9-4-f72935817dbf@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=V4tNF+ni c=1 sm=1 tr=0 ts=6a6b7535 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=EUspDBNiAAAA:8
 a=4SYEPDBQci7QR0ImIkAA:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-GUID: DZUhL-xHHsUAUM99IYkkkHh4VoAtbDWY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEyMCBTYWx0ZWRfX8JjabWH2aeuA
 jlhLiflbc7JGNs2efap9/Xy8KlTIvBaxXDQygWZdagwijMgyIlbf6wQuEoKV6S6hpc7q+Zh36Nx
 Bk+ZR2NjhngqFs5YmFJFNnvuJkEKXa87qdHZCGdOX7vwojiY+Jej7sBE0s045y8PU0y0nLh6hHw
 t9JmgqGER0jtqWmN27gOMjwX4AVgg+hEC/bnL+3VH9xWedSl8DDgwKAGpseS+64x7v0IgIi5Do9
 NVght3rTHgwyiy9HEFsoIcu5GSKyc/puZpvTHCj9h/J4aM7i3g99G2cH8VzeggfgSblnPSEbbW4
 ts5t6ooxNjNrYdHVV0KCioAK5/Ezw95uyLwF1dc90xgfYniHmIkYGSUkRlXadEB2HwCw5XUoh9m
 slL/C8REwlxGKBtnvhSBgIUL6zgXWR6Qysv8ATeTQLx4B3f2OSdPwlstOA1UR5pF3Jjp81N5Z8p
 wz1BuVBB+7d1/WwY7jQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEyMCBTYWx0ZWRfX/WiBsQ7Khifw
 w/eVDXBAYhldl+go3uVf5qi5BqdIiGd5wAaBEmTEcB4kvg5ITTpG6wKGP3mgYmc64qkKkJquLyo
 shPizG9KT/s6arQ+6u3+B/XX6PPx238=
X-Proofpoint-ORIG-GUID: DZUhL-xHHsUAUM99IYkkkHh4VoAtbDWY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 impostorscore=0 suspectscore=0 phishscore=0
 adultscore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300120

of_nvmem_layout_get_container() only looks for a child node named
"nvmem-layout" to locate the cell definitions. This does not cover
providers whose device tree node is itself the fixed-layout container,
such as an eMMC boot partition block device whose fwnode points directly
at a "fixed-layout" compatible partitions node.

When no "nvmem-layout" child is present, fall back to returning the nvmem
device node itself if it is compatible with "fixed-layout", so that its
cells are parsed by nvmem_add_cells_from_fixed_layout().

Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
---
 drivers/nvmem/layouts.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/nvmem/layouts.c b/drivers/nvmem/layouts.c
index b90584e1b99eab4217cbe7ec48373e18a7caf0dc..efa631ce7283bdd6c8ecda75915911b5e3a33c99 100644
--- a/drivers/nvmem/layouts.c
+++ b/drivers/nvmem/layouts.c
@@ -167,7 +167,18 @@ static int nvmem_layout_bus_populate(struct nvmem_device *nvmem,
 
 struct device_node *of_nvmem_layout_get_container(struct nvmem_device *nvmem)
 {
-	return of_get_child_by_name(nvmem->dev.of_node, "nvmem-layout");
+	struct device_node *np;
+
+	/* Search for nvmem-layout child */
+	np = of_get_child_by_name(nvmem->dev.of_node, "nvmem-layout");
+	if (np)
+		return np;
+
+	/* The nvmem of_node is itself a fixed-layout node */
+	if (of_device_is_compatible(nvmem->dev.of_node, "fixed-layout"))
+		return of_node_get(nvmem->dev.of_node);
+
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(of_nvmem_layout_get_container);
 

-- 
2.34.1

