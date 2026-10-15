Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59287535FC4
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 14:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792074394; cv=none; b=rhynlYw4jX4me4s46yuVEN3qost3/H2PiSsveV34y7o5ywnoLhJWSV/YMjo6UKVJT0+ICcjHMB/Yc6jPuKFSahsvWClhrMZBuO12mB14wuU37Yqjr+v4Wwlbdxk05B74XMWGnZDMc7MCRrHWXi3OqTZHSIwVsW0idIKFbac3exM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792074394; c=relaxed/simple;
	bh=QGnBRrtVZ3FFfHcMd7JXeA3J2ysoWmJkVEJ8fD9hdOg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Y+2scYSlnwaEXE8simKUamW5Syj2/0NAJEvajgcjKIn+L0tsVuLN08VrNEiBqbCQXyjtI0rjtRhkqBnWyCWOZJnIuWrtGThdktdlOqdFBEPdC3mW1SFOvyCMxAsFCsnZt+o2aJeBtq/fZ2KT2j0LMLXDiUkywhkbBmwo7E7mtI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=XZsjJyP8; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=dA4L7YLU; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="XZsjJyP8";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="dA4L7YLU"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69F9jggR1955846
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 14:26:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Rre9nYhysjyh/PSjFpSqFeP/GcQd3x85phPUQeiwexs=; b=XZsjJyP86E4GTGB6
	a4bPbCinpsmnCbaCdpI1h2R8SU6W/Sfbvu7l54rl4LfpvRY/w+wfr6tub8JoMKYM
	595hOFcRN0jFMk+GMScBT3neLO/EIxCKsyYVKPZCG+UjDwmQblRhBHquHl97Ha4h
	qRkmZZM95FIKDgXzLK5RLeOaIgw23GYO4em7HhOhkBb1fA0ZcFQROn8mnYvB6M7C
	DDWpbguBpGHbH9svCtj/wchrcRjviOPlWf7MfiCX28BrCY5ctz96qd0JElzNiN93
	yIEwyrdQsGNCwMrQwAeTPD45Ytl0ekMmqwUeA4e3fn9vfpwWqvsUZYWMFGLzz+zC
	Rq2gFg==
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com [209.85.222.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hakdeubhd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 14:26:23 +0000 (GMT)
Received: by mail-ua1-f71.google.com with SMTP id a1e0cc1a2514c-988be118d98so214620241.0
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 07:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792074383; x=1792679183; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Rre9nYhysjyh/PSjFpSqFeP/GcQd3x85phPUQeiwexs=;
        b=dA4L7YLUn3UyCLA476TKYiQy2N9u67VeU/AYPNVceg9P6lp3700U7USeqbUGQ50RCs
         PPB4jYt/n3HDVTj6b276Vyn03OCOvhIh/hWZsiidsqwd4NLxOzdQYId0LUhBtME6zuZS
         Bf5rTc/kGyGnoTqOUQtMdkIOQS/KS97yLerySvXm3wMpWDSHnL4O7Xsj7yGcq/7Gip7d
         bSTRw48yRsU19rXoMiHke4vORXRsuTJ87PPXg/08251t2nh+AsxrKfB06fQvQuil75Hq
         DviDEkCqHxn5cGPfNC1vysum322CHTxMpXLYAuC4SNicVQ6jHon/nKF6Wq3vxRpWP4Pr
         s0wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792074383; x=1792679183;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Rre9nYhysjyh/PSjFpSqFeP/GcQd3x85phPUQeiwexs=;
        b=2OXcSXE5nfbzao5N8scpcEqZP+zTeEmwt8f9b1A+ozoYt5YMXFpSRPHJhcbHUEx12A
         H2re2LgPbT1+ZpgK6MbiEOQoCCmN1VeI940/O34ggfDJIfG7Hs4ANbBPY16/y2l7Cdpj
         UlUV65hzQMtcyjacVXRe9ta1RtiRhze3bhdF4SmrdC2yEziuq9DBvrfeVDvvIOyzvQSw
         gsVWlIoGlW9x+SLArLe0KSGJNw7jkWmAO0N7QbyFIxa9ZTgILb6HlE2F0XGiqbGhPovv
         GCZv6uJqsYPljjT+iRGKqvIRrNOobrrHDik/kNjJcCAUmuyJySe8g1VDkraNocZMW0LQ
         EbxA==
X-Forwarded-Encrypted: i=1; AKwUvBybdtzuqyg4ITq5N6EM8CeWZGQ7c62vrgBADIpPl54n8AWv3c0yjLS12H8/zBjhbyMtKgCsdIlu0LQCHL+Csg==@vger.kernel.org
X-Gm-Message-State: AFq9FYLJcXSQrTdL3cFndmnymRSsrVPKoZz6Ajlwl04NzphaVVogah+k
	PaVBNmVD/VfRuXEsaDvU4I9Km7FM8qfIyb1qinS4kzInY6CSaotcKa2P+Cu9PlseylmJgor4bOV
	NLyAkXekB02LJ21HeDBiog6FsCpR1zT5qDZmumiiX0WL56NcQOAT4tdMw/FfsnHw+PkoHW4h6sn
	OfddeI
X-Gm-Gg: AYBFou0HSeipfLVo99NarDVN14usn9/LL5lY7/ImqaaBUTGVe8x4bwBqZh1t+6KkzDD
	mToIAE43Yts5GLLVnQBz9DcKpax/2/q5AsnZaIZN07pD9REiGgc4YBcOs8jFR8RANrVLNg3uAoy
	K4EGBgF4uA1BnHYQLQB3Z/EBYypLkQxTrlpPefvr95PIqsA09ZXV8CAX8vekd520XNcY2eV5EKr
	mHRneCnzq893qNGlm8ywFWg00d8u1XH5zzmb3n9pAbgLat+W0jhFF0KM/r050I9ErEBVHYe3u4h
	tbYrcFxbfBM8PAKv5LgIV0gFmHMPsQ3WPRMQkXL7DwcEWXwfkPKpblftPW+wDYZ+EYTvYtt6cms
	a4loHTKWbQQxRwu/v6gVO7lePLWLeWe4f3CvE2gZoM/eYCb5uaSkw9lO7Eo800N2sG+AqR5NnDq
	0D/msjloJTOX4oTU1Alhc3X1NBKucSOKxHISPAfnYbTD4LAHQ13Xs=
X-Received: by 2002:a05:6102:149d:b0:7c3:8ae6:d7ae with SMTP id ada2fe7eead31-7cb3678b940mr4845576137.1.1792074382850;
        Thu, 15 Oct 2026 07:26:22 -0700 (PDT)
X-Received: by 2002:a05:6102:149d:b0:7c3:8ae6:d7ae with SMTP id ada2fe7eead31-7cb3678b940mr4845555137.1.1792074382082;
        Thu, 15 Oct 2026 07:26:22 -0700 (PDT)
Received: from QCOM-eG0v1AUPpu.na.qualcomm.com ([2a01:e0a:830:450:5402:5e0b:9ef0:9b5b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1bd6428b3sm69083145e9.1.2026.10.15.07.26.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 07:26:21 -0700 (PDT)
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Date: Thu, 15 Oct 2026 16:26:02 +0200
Subject: [PATCH v11 3/7] block: implement NVMEM provider
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-block-as-nvmem-v11-3-f890ac74f87d@oss.qualcomm.com>
References: <20261015-block-as-nvmem-v11-0-f890ac74f87d@oss.qualcomm.com>
In-Reply-To: <20261015-block-as-nvmem-v11-0-f890ac74f87d@oss.qualcomm.com>
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
        Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <horms@kernel.org>,
        Srinivas Kandagatla <srini@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Saravana Kannan <saravanak@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Eric Dumazet <edumazet@kernel.org>, Abel Vesa <abelvesa@kernel.org>,
        Eric Dumazet <edumazet@kernel.org>
Cc: linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-block@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, daniel@makrotopia.org,
        Loic Poulain <loic.poulain@oss.qualcomm.com>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Authority-Analysis: v=2.4 cv=OdENnRTY c=1 sm=1 tr=0 ts=6ad0e28f cx=c_pps
 a=KB4UBwrhAZV1kjiGHFQexw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8
 a=VT4XjZGOAAAA:8 a=71DuYGxFrHUPmPLwgxgA:9 a=QEXdDO2ut3YA:10
 a=o1xkdb1NAhiiM49bd1HK:22 a=6CpsfURP9XNmmWg3j1mJ:22
X-Proofpoint-ORIG-GUID: wvQeaOaGTJfhUM-IL1DMa15Yu4ZwC6Bl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDA1NyBTYWx0ZWRfX51pEX7Srad/y
 NpyrPqcuk/3i8EZ/oKZyCAGPn2DPvNTgOftdYYbVLY41b84vDpUZh4Cal2dSrsL59oWbAAwfc7C
 0JmckmK6kYZkFNC7JpcspCxMnjCnaJU2skAX3arNK1MgDjGp7x2mi+rn3VMLh1JrdPfCpuBY+oZ
 o3igyc+GzMwYAbzfduwKDTIUA9UrAcPhWB0T7w+eRs1PTQXIRIGudshVFVfKonjIC6raRnr5Nvv
 wtiqJa3a3ni0LfuOVFpVuol2xhHEVnBo/6uuXCLLHAZu3tL1zLLUnSE77be+Sh94v290hETG1LH
 JEuAyPvQSHGhEhzWOJ1QcRCqaKwiLwUMZ7Q3rTjC70QLj8RQLp72pXgTaWdY/X6CQcVXkEoG/q1
 HAoUK+vPCtJrUs0p5NAh6kBCaFGzC4s/qfLVOGDCV3U1nNMVvUcw7SCW0eUmdiuT6C/rBaNOaGg
 9x7nclCS5XNwSrhRpgw==
X-Proofpoint-GUID: wvQeaOaGTJfhUM-IL1DMa15Yu4ZwC6Bl
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDA1NyBTYWx0ZWRfXzP8QCceoZNnU
 AqrEuR0wFbrLLfgyAc+s62EhjYxU5tk2Uy2XoH5EzvoAH1/lmZz84yITTkFkrjLEq1E1kMCglyH
 iku23B3cVJcc09ZUhJpSzacFdQRo2Mc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 impostorscore=0 phishscore=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 adultscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610150057

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
index 2cc03aa54c5327d0c596d67f5846740850550260..c5eed8f2777bea92281f5fef5287cb15b33e5dbe 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -823,4 +823,12 @@ static inline void blk_debugfs_unlock(struct request_queue *q,
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
index 10ca8b4d6eea7ed3910271ca3af74479e2081d6d..6c45b8eb8dfad14fa2fbfa98177154f24af49a07 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -417,6 +417,8 @@ static void add_disk_final(struct gendisk *disk)
 		 */
 		dev_set_uevent_suppress(ddev, 0);
 		disk_uevent(disk, KOBJ_ADD);
+
+		blk_nvmem_add(disk->part0);
 	}
 
 	blk_apply_bdi_limits(disk->bdi, &disk->queue->limits);
@@ -708,6 +710,8 @@ static void __del_gendisk(struct gendisk *disk)
 
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
index 0cc09b975d8ffbd45ca3dc47533a71f8e8164de6..8026bd763a0710b60b9553a49783efbaf81aeb9f 100644
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

