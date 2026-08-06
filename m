Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F70B47F2C2
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 14:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786027147; cv=none; b=HrTtPt7duWTCI1+kMwABhTp4z57xZsQ59N8gperhuAS6aaz2hAfgoGp4bJsKldcpTwgOJ4QDdPnBWmiY/v9qlk7Jss/Era6fRJ7lEZkchOJ7ZNzuVEovJAFA+pAdSp9Iq2iOmsL+CWpqkErOL2E6UuZJL+gIVF/gfdhAibX26tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786027147; c=relaxed/simple;
	bh=8zb72y+uRtZA5JG7Jpy7Gdf5cpo//eqQjoZwFUzntms=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZIXto0pL/YvalsnTFT6SxcrWK7f577EhfCNh0zkdFarmUdzf0UVpeK8FkjBrN3TQO0LyPHkQw2CF2KkwFYqWy62Nhu2RgFfIhNvKxozWg/u9Ntgt3BjVHpAsKQQFGJuumQIudhWyLIH0ZNVwDr1k9XecnbafkAylHxVvWIANaY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Umdw0+wX; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=BtdvXBWA; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Umdw0+wX";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="BtdvXBWA"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6769o5dq1627565
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2026 14:39:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	tLAbMrw6kMVW1KpbCEzwXaQHTu3vG+Xv+taIs0sFboE=; b=Umdw0+wXDi/tThuW
	hp38e8A8JadQ4rM/lXI8TBE5H9Qz1QR7UzvGGkZCqBQ2zUgqhfnWUVDD5WAJsKKE
	R/XhAYL5WSB885KUs+UeTFEyHlF+I0cmfY/23fWoiY+AbGo4WWBmgwtNaO/BYwW5
	a3F8EvBz7P7xQxTRM1EAE3o7LjkPUKuhpYSaGchOp6PMCVLHFVKgXhS0s3v7zDjA
	yopcd/y7sL8nzPj59wEbTvp1mutd7Itp1xIUbYkc6GB2C2WUcpuw4DiCXYitgQYB
	ujuHuSYvPIfStAEqtz/aumqKyP4AufbKbWc+TSJuL+WMOQfG1UCVbCAkT4I4JIw2
	551lBg==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvntnhxqx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 14:39:04 +0000 (GMT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-8efe7db1c42so24640176d6.3
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 07:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786027143; x=1786631943; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tLAbMrw6kMVW1KpbCEzwXaQHTu3vG+Xv+taIs0sFboE=;
        b=BtdvXBWAfvyBuvA9XF0E2UtTHOCU1HsIoEzPDNBKBHI7qxCpFLybv/uABO7Y686XUu
         uJhT5J1QLKKkv+3PT7O5PBfP9Ult4j2oodtHcopUE6nWII6sDupRCqgOPRXj/MhszqXV
         Lg46IKEjhJxHM84DPqT/5jwJ9Xa8D7ZQ7SkEJkRG1RYy2Isilj1zwFTQ2pmKSu3Q2hVm
         yMDXyxKiyj1yl90I/m0ZNVbK1kjYm9KZLlzHH2icjNp94pC1pI+IclXxtf/9L1WGkglg
         VZTGLomR6H3PYpNGsWRwGYLDmgcwi9MbTOTqXRmp7SrJL1Z6UTsX2f6Ux9S+ow0lKlNP
         Q8UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786027143; x=1786631943;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tLAbMrw6kMVW1KpbCEzwXaQHTu3vG+Xv+taIs0sFboE=;
        b=ruULwoLy1uapuAk8HZaM7Whe0UgpbGVXFLOWlaGp/YgnFIhpukYShh1PO4CN8MSu2Q
         Pdm2GBZ2h9mNcrIPShuWraOXBWDT5lEihdEVAb7f6u5Dvv2jsS42iqHF8H3KeMUZ79eV
         6FGTNXgfdoXIPUaWUS4C1u41aW3QDUEtBK/AcHm0MZf2QcIE4LeDub6wW2v8GAiagykN
         t5VlhQsTkR1HDNujMJ8cNyXg1ZenH3+ncZannbfw8B0R2U2A70V3D9Qyp/czblhUkXGb
         IYWq5khiwoZ62x78OavLAuXTVF1nl/j+3g/PHRR3rXJYum/6A2z8UQQ16ASLPaWG38YL
         Kmew==
X-Forwarded-Encrypted: i=1; AHgh+RpieAz8d5sjWe00II6c9dnOMHPXLlyOBLGf57cLtjODqzcV3Z1bcvgRzfYhUKZJBgsckB7GS4NcT1Fl366Hyw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwuK00VOMQnl8ZPcxUYi+YunGFtlUnoF2HSy8ANIZ+ePHKY14AV
	oXofcPEMysMFd6BaZQGUUF/N9/1KHrO27iHT1d4KQjmSP4HzoaLW6d9zYIdPdmAOh1tSfbu1ZJ2
	CW+ggdvlA/f77p3od26Ds22jbYkmrLEqeYYyst7ojf/21/B9pMicVmZQRxNOkLuhEQTOSZg==
X-Gm-Gg: AR+sD10fUJl7GxWubqWoKyyWlQs3aeO/3X7cdxH6Hl/8xRXWEherSkW46w7bcFZQqR6
	IHlEv5r/AiArk3vKNctlCP9e0GiFxcTupgk/7WdelJFpQNadlZDM3Knce9Z4yHZBbypMQZwjhg1
	eOV7lob0JM+oTejeRXwUukug7KEbUFLanAvCPvOwH7hjsH/9G1UTDKSlmVOcgvnpsZkoY4eW5yv
	wf9OQ3LxSXKt1wBiiEwhdqri1HDSMU6Pd/i01ypt0l0hLHIIjglYokxyYnrxweWMnVwKFuJ+kbd
	7rQEJUPDKV/LFbtWb5p6HGpVVrOXvAYGf8EOswyOFhbVkp+Q3barC56wqDWCbTwXkSGvOfq6Cvy
	3lA5ZWUEheYp2DthMGYLpyHPBaMjK0U3x5EaI5KRXdhNrR0FCqQE1llrsqAPF3/yEhp82ujJyRE
	mC+4EiIl1ftpgr+hd+I4kCyKyZ9M5tTDVOa6qrI00UOyT++Y4nQQ==
X-Received: by 2002:a05:622a:4c14:b0:51c:2633:9ddd with SMTP id d75a77b69052e-52ce61eabd5mr171870471cf.41.1786027142887;
        Thu, 06 Aug 2026 07:39:02 -0700 (PDT)
X-Received: by 2002:a05:622a:4c14:b0:51c:2633:9ddd with SMTP id d75a77b69052e-52ce61eabd5mr171869411cf.41.1786027142285;
        Thu, 06 Aug 2026 07:39:02 -0700 (PDT)
Received: from QCOM-eG0v1AUPpu.na.qualcomm.com ([90.85.108.51])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2036276e58sm270552166b.28.2026.08.06.07.38.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 07:39:01 -0700 (PDT)
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Date: Thu, 06 Aug 2026 16:38:39 +0200
Subject: [PATCH v10 06/10] block: implement NVMEM provider
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260806-block-as-nvmem-v10-6-be598b2a5606@oss.qualcomm.com>
References: <20260806-block-as-nvmem-v10-0-be598b2a5606@oss.qualcomm.com>
In-Reply-To: <20260806-block-as-nvmem-v10-0-be598b2a5606@oss.qualcomm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDExNCBTYWx0ZWRfXwelfbi7m8Zg5
 fRbiMGDuS8Gvs9Hg/j0Dsg5QvAd6mAhoXSKW8b5t8gKOAFHD6SO2iaGYNcuDre65ByE58uZm66r
 YeMq7pv2NxnLLbkbzie5k3z3Gd9w64JCk4Mi2dsRsI8Y4+W6ySm/tdVFImfGhCqq7b4o/7ChEds
 +/17umvjQX7BDQ1KjtiMl15AoDikfeHAdVA8rU4s9whxW+Cm6sEWGSIIQXClmR1ONRLLNHgRxY+
 17i9byJX70qYyGlHl79uVrpyMgAH7MVTbeOc973IqVbCuLcGaw7q6ZYN6m59jgxYwQ9/e6Ki9l9
 L4iuB7ut65s4C2QclZXPv+HRtwciMk3pF8jYPRui4dszjqtzQ/HpX3iAqL4FMCLQDykEMsn+GSu
 2kTYqpzmOy5Oxs+hT5RXUrKUaRISz/uzBUcdQZuTIyaxAh+A+h56f2E28JuI0bm9M274pPWXWsQ
 eZGPOGbOhs49pH1I35w==
X-Proofpoint-ORIG-GUID: _Afec-6AwhsdgEQKGmQz5nOnrt4vwXLU
X-Proofpoint-GUID: _Afec-6AwhsdgEQKGmQz5nOnrt4vwXLU
X-Authority-Analysis: v=2.4 cv=LpKiDHdc c=1 sm=1 tr=0 ts=6a749c88 cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=JDRa4Jy4r6/BpSpxP2cCow==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=VT4XjZGOAAAA:8 a=71DuYGxFrHUPmPLwgxgA:9 a=QEXdDO2ut3YA:10
 a=1HOtulTD9v-eNWfpl4qZ:22 a=6CpsfURP9XNmmWg3j1mJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDExNCBTYWx0ZWRfXzxQ4FOTJqlsm
 w8dRpsaq4TgX9UBgxCRnUwTDZFrVaHDYLnEdI2BsG3f4Bl1/5ZkmNpzMm+38rJUh0rMH2yjs9FH
 17vUxh3ay8DkUntgOpZbHNqPGKTg2r0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 priorityscore=1501 malwarescore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060114

On embedded devices using an eMMC it is common that one or more partitions
on the eMMC are used to store MAC addresses and Wi-Fi calibration EEPROM
data. Allow referencing the partition in device tree for the kernel and
Wi-Fi drivers accessing it via the NVMEM layer.

NVMEM is registered for a block device whose OF node describes an NVMEM
layout, either via an "nvmem-layout" child or by being a "fixed-layout"
node itself (e.g. an eMMC boot partition associated through its mmc-card
node).

The NVMEM device is a read-only side channel onto a block device.
Each read opens the block device with BLK_OPEN_EXCL to keep other
exclusive openers away for the duration of the access.

Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 block/Kconfig             |  11 +++++
 block/Makefile            |   1 +
 block/blk-nvmem.c         | 112 ++++++++++++++++++++++++++++++++++++++++++++++
 block/blk.h               |   8 ++++
 block/genhd.c             |   4 ++
 block/partitions/core.c   |   5 +++
 include/linux/blk_types.h |   4 ++
 7 files changed, 145 insertions(+)

diff --git a/block/Kconfig b/block/Kconfig
index 70e4a66d941ff66ecb0ec34f4f7eff7fd1e4be40..4899ad572c71ffdbb62460d57623216254893ddc 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -209,6 +209,17 @@ config BLK_INLINE_ENCRYPTION_FALLBACK
 	  by falling back to the kernel crypto API when inline
 	  encryption hardware is not present.
 
+config BLK_NVMEM
+	bool "Block device NVMEM provider"
+	depends on OF
+	depends on NVMEM
+	help
+	  Allow block devices (or partitions) to act as NVMEM providers,
+	  exposing factory-provisioned data such as MAC addresses or Wi-Fi
+	  calibration blobs to the drivers that consume them. This is
+	  typically used on embedded devices where such data is stored in a
+	  dedicated area of an eMMC, instead of a separate EEPROM or OTP.
+
 source "block/partitions/Kconfig"
 
 config BLK_PM
diff --git a/block/Makefile b/block/Makefile
index e7bd320e3d6971a8abf584f5de42776bb54e8216..8200297fbcbab304beb4239d0c33da07011c3ed9 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -39,3 +39,4 @@ obj-$(CONFIG_BLK_INLINE_ENCRYPTION)	+= blk-crypto.o blk-crypto-profile.o \
 					   blk-crypto-sysfs.o
 obj-$(CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK)	+= blk-crypto-fallback.o
 obj-$(CONFIG_BLOCK_HOLDER_DEPRECATED)	+= holder.o
+obj-$(CONFIG_BLK_NVMEM)                += blk-nvmem.o
diff --git a/block/blk-nvmem.c b/block/blk-nvmem.c
new file mode 100644
index 0000000000000000000000000000000000000000..69b69184e16303444c9cb2dc816d5679daeb13c4
--- /dev/null
+++ b/block/blk-nvmem.c
@@ -0,0 +1,112 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * block device NVMEM provider
+ *
+ * Copyright (c) 2024 Daniel Golle <daniel@makrotopia.org>
+ * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
+ *
+ * Useful on devices using a whole disk or a partition (e.g. an eMMC boot
+ * partition) to store MAC addresses, Bluetooth addresses or Wi-Fi
+ * calibration EEPROM data.
+ *
+ * The NVMEM device is a side channel onto a block device that stays fully
+ * usable. This is somewhat mitigated by opening the device exclusively.
+ */
+
+#include <linux/device.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/nvmem-provider.h>
+#include <linux/nvmem-consumer.h>
+#include <linux/of.h>
+#include <linux/property.h>
+
+#include "blk.h"
+
+static int blk_nvmem_reg_read(void *priv, unsigned int from,
+			      void *val, size_t bytes)
+{
+	struct block_device *bdev = priv;
+	struct file *bdev_file;
+	loff_t pos = from;
+	ssize_t ret;
+
+	/* open and prevent other exclusive openers */
+	bdev_file = bdev_file_open_by_dev(bdev->bd_dev,
+					  BLK_OPEN_READ | BLK_OPEN_EXCL,
+					  blk_nvmem_reg_read, NULL);
+	if (IS_ERR(bdev_file))
+		return PTR_ERR(bdev_file);
+
+	if (file_bdev(bdev_file) != bdev) {
+		fput(bdev_file);
+		return -ENODEV;
+	}
+
+	ret = kernel_read(bdev_file, val, bytes, &pos);
+	fput(bdev_file);
+
+	if (ret < 0)
+		return ret;
+	if (ret != bytes)
+		return -EIO;
+	return 0;
+}
+
+int blk_nvmem_add(struct block_device *bdev)
+{
+	struct device *dev = &bdev->bd_device;
+	struct device_node *np = dev_of_node(dev);
+	struct nvmem_config config = {
+		.id		= NVMEM_DEVID_NONE,
+		.owner		= THIS_MODULE,
+		.word_size	= 1,
+		.stride		= 1,
+		.read_only	= true,
+		.root_only	= true,
+		.ignore_wp	= true,
+	};
+	struct nvmem_device *nvmem;
+	struct device_node *child;
+
+	/* skip devices which do not have a device tree node */
+	if (!np)
+		return 0;
+
+	/*
+	 * The layout is described either by an "nvmem-layout" child node or
+	 * by the device node itself being a "fixed-layout" container.
+	 */
+	child = of_get_child_by_name(np, "nvmem-layout");
+	if (child)
+		of_node_put(child);
+	else if (!of_device_is_compatible(np, "fixed-layout"))
+		return 0;
+
+	if (bdev_nr_bytes(bdev) > INT_MAX) {
+		dev_warn(dev, "block device too large to be an NVMEM\n");
+		return 0;
+	}
+
+	config.dev = dev;
+	config.name = dev_name(dev);
+	config.priv = bdev;
+	config.reg_read = blk_nvmem_reg_read;
+	config.size = bdev_nr_bytes(bdev);
+	config.of_node = np;
+
+	nvmem = nvmem_register(&config);
+	if (IS_ERR(nvmem))
+		return dev_err_probe(dev, PTR_ERR(nvmem),
+				     "Failed to register NVMEM device\n");
+
+	bdev->bd_nvmem = nvmem;
+
+	return 0;
+}
+
+void blk_nvmem_del(struct block_device *bdev)
+{
+	nvmem_unregister(bdev->bd_nvmem);
+	bdev->bd_nvmem = NULL;
+}
diff --git a/block/blk.h b/block/blk.h
index 25af8ac5ef0f77c09b4d747827b275c32e9f2972..dad8f0d7a218edbafa9b6a03aed673657f3e8cbb 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -810,4 +810,12 @@ static inline void blk_debugfs_unlock(struct request_queue *q,
 	memalloc_noio_restore(memflags);
 }
 
+#ifdef CONFIG_BLK_NVMEM
+int blk_nvmem_add(struct block_device *bdev);
+void blk_nvmem_del(struct block_device *bdev);
+#else
+static inline int blk_nvmem_add(struct block_device *bdev) { return 0; }
+static inline void blk_nvmem_del(struct block_device *bdev) {}
+#endif
+
 #endif /* BLK_INTERNAL_H */
diff --git a/block/genhd.c b/block/genhd.c
index f84b6a355b574af88c870938a8c69aeb9f8f44ad..0c9c5e5ea7baffa326a2d45b075688cf3a0edf5a 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -421,6 +421,8 @@ static void add_disk_final(struct gendisk *disk)
 		 */
 		dev_set_uevent_suppress(ddev, 0);
 		disk_uevent(disk, KOBJ_ADD);
+
+		blk_nvmem_add(disk->part0);
 	}
 
 	blk_apply_bdi_limits(disk->bdi, &disk->queue->limits);
@@ -704,6 +706,8 @@ static void __del_gendisk(struct gendisk *disk)
 
 	disk_del_events(disk);
 
+	blk_nvmem_del(disk->part0);
+
 	/*
 	 * Prevent new openers by unlinked the bdev inode.
 	 */
diff --git a/block/partitions/core.c b/block/partitions/core.c
index eee954df1ac6ef7dd4f02ad5c9d49aed778bf015..c83227710584a6feb25c8abae3b319cfae9cce5b 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -289,6 +289,8 @@ void drop_partition(struct block_device *part)
 	xa_erase(&part->bd_disk->part_tbl, bdev_partno(part));
 	kobject_put(part->bd_holder_dir);
 
+	blk_nvmem_del(part);
+
 	device_del(&part->bd_device);
 	put_device(&part->bd_device);
 }
@@ -406,6 +408,9 @@ static struct block_device *add_partition(struct gendisk *disk, int partno,
 	/* suppress uevent if the disk suppresses it */
 	if (!dev_get_uevent_suppress(ddev))
 		kobject_uevent(&pdev->kobj, KOBJ_ADD);
+
+	blk_nvmem_add(bdev);
+
 	return bdev;
 
 out_del:
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 8808ee76e73c09e0ceaac41ba59e86fb0c4efc64..6ed173c649025b95cce9253b27f68f2c7dbab8eb 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -15,6 +15,7 @@
 struct bio_set;
 struct bio;
 struct bio_integrity_payload;
+struct nvmem_device;
 struct page;
 struct io_context;
 struct cgroup_subsys_state;
@@ -73,6 +74,9 @@ struct block_device {
 	int			bd_writers;
 #ifdef CONFIG_SECURITY
 	void			*bd_security;
+#endif
+#ifdef CONFIG_BLK_NVMEM
+	struct nvmem_device	*bd_nvmem;
 #endif
 	/*
 	 * keep this out-of-line as it's both big and not needed in the fast

-- 
2.34.1

