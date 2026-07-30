Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8B544AB81
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 16:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427260; cv=none; b=VX3kDHW9h64LV3bSpG4zWKr5FqwTINfi9a3fg8bTkMvOYJPGPF5j1EJ9QlSjXkpbUSwm6DfFiq0jm0NJACA+HZLm1njhQwHs1ROdcAARoINnfN6cqVWQa71h6pbM84W8iBlru7IJkzFdFnksDrIpoBeKYDXPh2IbvHd13Ku3EsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427260; c=relaxed/simple;
	bh=OvCoQyRpL0+LUj08qznL6Vpg7APY+bJUr7eTwyvn2XQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DWQKlzpUSEEx4/7jm9Jgf+hNTwAF7uwM2+647pHq6YETG60/92coVvFhWb8oCVqwI3vRpV+ZrtnSynkPIup8UER7apVL5ANREik5BqzQ4gZRTP7h2748fKYx+qO0mEjYKvfkPhvFLq9AObdxaFj5uXjNRNUI1m8Qj1u1+HKRDiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=dxeULNSL; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=b2eeMAOL; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="dxeULNSL";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="b2eeMAOL"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UFQtUN1087809
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 16:00:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	v9PMz+dnble1GdL5feeV7xmOmc+UN0QuRZbXG4cK1sc=; b=dxeULNSLUcRNcK9i
	MlZ9849Moe7IBN/zZB4WyHHUajMW4KVHBCd4FW3YxgDE0NsmY9kJUlZEtPVQUcZB
	j68kbNcmPEQ1eCvdAki3GxBSRLBXWp4v2hg48LRqTrK2RR2BizZ34wuhaa9xwFJX
	toQfxEaCnq69SBpIujR9AmX1qhiahCDP//gLTMQIgScSoszdg+zsf1xr5iyyUkKd
	EE2VC1HNWGg4tuHr1FPQ5x0E8IA/zG3DONT10tKWWFKBpcOv4iT/C+V3vsC3c6nS
	UKdMhdwayjtfgMkIUqnERhu4Urj+QmpJP73YI1o8rqST8EOnkE1EuA+cuqQ4ub4V
	FhlQtA==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fr8n38cvw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 16:00:57 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-92e66f9e2baso1659785a.0
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 09:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785427257; x=1786032057; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v9PMz+dnble1GdL5feeV7xmOmc+UN0QuRZbXG4cK1sc=;
        b=b2eeMAOLMWzyuv8v85r+c+eaHZ9aUU7XWZV2w6UgKG4ATS8BNeVWbxGzv3k+gLOfl9
         xicvOGSmhZnjt5VhnkTOLvGCJxqc9s9CM5RKEX0tL6j3LknsqBQA1bIPA1AOsus9qDH2
         xzshwrzyQTp+/TmQnT4I/Vas9UtGwBPcPMiEZanWCCxLQEH9iA5tgfHI+I2ITszzOzN7
         U9IBTC/oBITQpMMEx6P9G7+y7XjPgUTCMv3TBb6t/tNazvlGGFdfhJogdLTihnj0uLQF
         xie1f4c62jME+CwfxjPhGXU/sUNCcusm7fYeklTf8Gv8zQ4AlMOFDM/7tRedpJdTRnAt
         nT7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785427257; x=1786032057;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v9PMz+dnble1GdL5feeV7xmOmc+UN0QuRZbXG4cK1sc=;
        b=lDdXBmKjXIWsT6rCWTqTesM6ajIAs7fDaz9ugHsomrBiav1l+Fc664a53LQXfXnw/h
         iWwzr/kPwaCEcleVGzLAUn12BpPjxsjJjl9ideetZeswUtW4gowl6grAqOwlTwYOhKkk
         S/Tp2G3veN2lRGYyDJs4sMPFPZKoqWjS3SUTF1TwQSUlUIb7k8339NY+6HfuxmFb0poz
         Ahwdymj0SwrmfYhVVo+/EfNnCItRR2/yRE/9U3JScJJzp5PrMRB3NGq9+YleZpvXsFqb
         M3deSYwrvtHG2Q1qfMHWepuRqO0YUkurzTkgggAW4jGaIWo9d6Mc5xdmFmUbb9W6KWHZ
         f+xg==
X-Forwarded-Encrypted: i=1; AHgh+RouyxinzlNOm6T73kvQwOnIRCDwAGwyIhGv8xLmWVHY0zwm5vNII9I/RxADGzijKa5ZWer9cKqnpZLYDSBiMA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyx2mOX/9LY6TvTCOGE+SgkjS0h5Z2reZeej/xQ/i9tsgMLHaeU
	143/2idKTI4oJcrAFnVm7dGKOLSyOfcrfhE/GDWOhoBbUgO/w41t0wcFFtDEShEs5GHwKnHkNIZ
	748Ok6DM2VOCaDb3wh3B1h4fng3/zBg4KoEV0FFBzQZFtgVDAJBPGas6uhKFVx9C1qT5itg==
X-Gm-Gg: AR+sD13pIGl/CwWiOsvOw4M8UV1XtBXRZkTuUf9AQZTgGNOnXExvyTk7nmJhnnd4LZn
	Uiy698AK+fbPSHc5pT5trdkjCtrLMAvXHcBsthdddvNBQsA6gWG15KrWeSAe8BnGJJQyPal1ORk
	o97fFwxubpZkzzaN09HGlAJCo6niGe0E3o9neOa0L7hpXmpgdX5FrFOMMDoyV/nYTqKi5YEilr9
	Tm1VPCK4k2WNm7inQXcEefa890ljBD1a9mc3s6kCGykI2VsOcWALxiNPYZF0+Qst04YbBU8B6aW
	zEO9Y4jWhKM4w4lUdU0hjlaX/eK3C9wnXjf+cDP0xehzjb7hWBaQHKNyvaHKOk51B4PAS4bPOJ1
	FPJc8QmUmRafaYuG1gM4bcfwOZKOlsJRhkysaO2TxT0ryRzWDUcOJU0F+w0blQSZajAN2saTvtc
	/nJX/9/bW8oFx2yFVbRChh+nxaQcRE0JPyMLTT9x/3QlxZMjeQ4J5M
X-Received: by 2002:a05:622a:591a:b0:527:7d0f:863b with SMTP id d75a77b69052e-52b385fee43mr34234271cf.12.1785427255320;
        Thu, 30 Jul 2026 09:00:55 -0700 (PDT)
X-Received: by 2002:a05:622a:591a:b0:527:7d0f:863b with SMTP id d75a77b69052e-52b385fee43mr34232291cf.12.1785427254055;
        Thu, 30 Jul 2026 09:00:54 -0700 (PDT)
Received: from QCOM-eG0v1AUPpu.na.qualcomm.com ([2a01:e0a:830:450:61cd:dcd3:c61a:ac3c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1fa8bb6deesm85168066b.53.2026.07.30.09.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 09:00:53 -0700 (PDT)
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Date: Thu, 30 Jul 2026 18:00:35 +0200
Subject: [PATCH v9 05/10] block: partitions: of: Attach partition fwnode to
 the block device
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-block-as-nvmem-v9-5-f72935817dbf@oss.qualcomm.com>
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
        Loic Poulain <loic.poulain@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Authority-Analysis: v=2.4 cv=Ar/eGu9P c=1 sm=1 tr=0 ts=6a6b7539 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8
 a=2ffTNAQyBkxXHBiWhEgA:9 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-GUID: ANXGUDcaeZ9fKGoPmyjkt0MbNoHo_JCr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEyMCBTYWx0ZWRfX23egMzpv6ylq
 CV2YGa/PVsz+B0Uxs/XI9PsaQKhKbdeU9cNPA3KB+/VQM8nZxV+Gm/HBXqry/9TTFOUMUtuhFE1
 ylc47vzRb/BV/NVd+rOCr9ve7m14Sj28O6cMGsTsXrLNXKahB3SID6laCvWztAiT1XbMrjX0kP7
 X3yone3dLkqpRfH36VQYYktgacfNDQvdm32Xe3ttnLz7JpFxwmTn2cPqbrGnYUdGXrjWxTmxQ+K
 EC4Ie0rTIuupng4Ieakdpks9QmUCH5wAkRA4TZnVXtziJ1Why2/vdLbBFryfleLB0+CjiYFu0/R
 QPJosbL3+z70WQDKwcxVPTb+sgfwswF6kNyLPwmKnrKqCv0JUVfwV1Rop17tRDtkNCP0HQ0gaGy
 eXC2AgV+1sCVzmKSdgKsCS1/RqoyB2ZXhyyFDeg/M/ldkc+T7uDbRFW0kJudIofWlpOkBaLvUZY
 zGSNSiBydN+ta95Or1w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEyMCBTYWx0ZWRfX9BS7srr5ck7R
 kQQVkb5+fnzx6ugIMsNTLDqDHS4bzAiFP59wIUcFyZcEHvP7ZGP00HhDeJNiDI86dWhfdkEwjxM
 q5WC4Ye0yDsZPW16NlvDh6zdmTCi4kQ=
X-Proofpoint-ORIG-GUID: ANXGUDcaeZ9fKGoPmyjkt0MbNoHo_JCr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 priorityscore=1501 malwarescore=0 impostorscore=0
 bulkscore=0 adultscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300120

The OF partition parser reads offset, size and label from each
"fixed-partitions" child node but does not associate that node with the
resulting partition block device. As a result a partition has no
of_node, unlike the whole-disk device which gets its firmware node via
add_disk_fwnode().

Carry the partition's device tree node through the parser and attach it
to the partition's block device with device_set_node(), mirroring the
whole-disk case. This lets consumers describe per-partition properties
in the device tree (for example an NVMEM layout on a partition node) and
look them up through the partition device.

No functional change for existing users, partitions without a matching
device tree node simply get a NULL fwnode.

Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
---
 block/partitions/check.h |  1 +
 block/partitions/core.c  | 10 +++++++---
 block/partitions/of.c    |  3 +++
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/block/partitions/check.h b/block/partitions/check.h
index b0997467b61a54a8a621b9c155c8329289649460..326081499d9a6be730dbd659c110449cfa06921f 100644
--- a/block/partitions/check.h
+++ b/block/partitions/check.h
@@ -17,6 +17,7 @@ struct parsed_partitions {
 		int flags;
 		bool has_info;
 		struct partition_meta_info info;
+		struct fwnode_handle *fwnode;
 	} *parts;
 	int next;
 	int limit;
diff --git a/block/partitions/core.c b/block/partitions/core.c
index b5c59b79ca7cbb28d4d93478ee1c80908f76ee9f..72f435dfeffc63e897913571f319e5edd8e7ba88 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -11,6 +11,7 @@
 #include <linux/sysfs.h>
 #include <linux/ctype.h>
 #include <linux/vmalloc.h>
+#include <linux/property.h>
 #include <linux/raid/detect.h>
 #include "check.h"
 
@@ -247,6 +248,7 @@ static const struct attribute_group *part_attr_groups[] = {
 
 static void part_release(struct device *dev)
 {
+	fwnode_handle_put(dev_fwnode(dev));
 	put_disk(dev_to_bdev(dev)->bd_disk);
 	bdev_drop(dev_to_bdev(dev));
 }
@@ -294,7 +296,8 @@ static const DEVICE_ATTR(whole_disk, 0444, whole_disk_show, NULL);
  */
 static struct block_device *add_partition(struct gendisk *disk, int partno,
 				sector_t start, sector_t len, int flags,
-				struct partition_meta_info *info)
+				struct partition_meta_info *info,
+				struct fwnode_handle *fwnode)
 {
 	dev_t devt = MKDEV(0, 0);
 	struct device *ddev = disk_to_dev(disk);
@@ -343,6 +346,7 @@ static struct block_device *add_partition(struct gendisk *disk, int partno,
 	pdev->class = &block_class;
 	pdev->type = &part_type;
 	pdev->parent = ddev;
+	device_set_node(pdev, fwnode);
 
 	/* in consecutive minor range? */
 	if (bdev_partno(bdev) < disk->minors) {
@@ -449,7 +453,7 @@ int bdev_add_partition(struct gendisk *disk, int partno, sector_t start,
 	}
 
 	part = add_partition(disk, partno, start, length,
-			ADDPART_FLAG_NONE, NULL);
+			ADDPART_FLAG_NONE, NULL, NULL);
 	ret = PTR_ERR_OR_ZERO(part);
 out:
 	mutex_unlock(&disk->open_mutex);
@@ -564,7 +568,7 @@ static bool blk_add_partition(struct gendisk *disk,
 	}
 
 	part = add_partition(disk, p, from, size, state->parts[p].flags,
-			     &state->parts[p].info);
+			     &state->parts[p].info, state->parts[p].fwnode);
 	if (IS_ERR(part)) {
 		if (PTR_ERR(part) != -ENXIO) {
 			printk(KERN_ERR " %s: p%d could not be added: %pe\n",
diff --git a/block/partitions/of.c b/block/partitions/of.c
index dab36513eba336344c9558d486a8915624b0fca8..d4016f9b77ec078eb1adb32923107c012ca4a751 100644
--- a/block/partitions/of.c
+++ b/block/partitions/of.c
@@ -3,6 +3,7 @@
 #include <linux/blkdev.h>
 #include <linux/major.h>
 #include <linux/of.h>
+#include <linux/property.h>
 #include <linux/string.h>
 #include "check.h"
 
@@ -65,6 +66,8 @@ static void add_of_partition(struct parsed_partitions *state, int slot,
 		partname = of_get_property(np, "name", &len);
 	strscpy(info->volname, partname, sizeof(info->volname));
 
+	state->parts[slot].fwnode = fwnode_handle_get(of_fwnode_handle(np));
+
 	seq_buf_printf(&state->pp_buf, "(%s)", info->volname);
 }
 

-- 
2.34.1

