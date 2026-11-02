Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793636850;
	b=EEPQqyyYsMTXW8+ewmUPheE5kDEKnWi4vXMub7MX6SsoVV0STG++VLmacegSTfEqT9gl
	 xP/FTjqBDWorIbypjICYTyNhZlFpUZRgc/Aab45eKZc4qezYBoswSuU9NDWlCsN97xAwx
	 u3py09xMvh6vsnKVcu0AOG0Ws2ncKfX8D5Z3uXFw0T+lul+W/91aPSOhwqYEiIzcaHOWV
	 2a8bUIrSoSVG+1RW7UANNwYjtnNcXrQf63x5GXNOkNZx0NaRUGNmnh2xMZVLWOxWvRmFT
	 LtDBOd8po2VrhQhgfPwDnOmZLFl8shpq4IVh1IKANlnxyiqNwV5z3l+zJ3H3y3ngHfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793636850;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=IE79JMn0wPrEDgdovegTuQ5M+CHvyEMAVwZJre8pogM=;
	b=bXo7rJAukATkV3jgB5RB+SihWlnOd90V6GR119FijUlWia6GbgGYWG/K0DvJUTSbL33C
	 1HvKN7WeRZCWJVWFT723f5eb7gMjdIiEMgTHvH0xHWVw3krXXVfFfbXadkg9VdYGeB3qN
	 5iLrA/gwfzgz0LSCKfSGW8xZdRT0sXYgeFCmnaCU410V4KdHhkXfw6wOhIK+DTVu5Seev
	 OjQqDNvCqVpv4BgQhtTLSooBW4y2yvYGnEAJfQ3uf5K6dqcN3B1uhToiZr1M6u5PueEfG
	 mHBS4kaN2HjWD+NBLxCrKP8xqSes2IfClZGZiCQatnmQKk0KmLBNhYF2dmiuIYuEYNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=cmS7v6PW;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=J8YCTeBw;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6ED6072230
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 16:27:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC6ED6072230
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=cmS7v6PW;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=J8YCTeBw
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A2DpMd0452545
	for <linux-wireless@vger.kernel.org>; Mon, 2 Nov 2026 16:27:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	IE79JMn0wPrEDgdovegTuQ5M+CHvyEMAVwZJre8pogM=; b=cmS7v6PWAAEcGhV2
	yVNk1/HoeP+HdcxRfgPcIqWH08IduF66sTf/rpn4Jtf77R3s9nR2WYT0I7J9pG25
	eC+wGpvzw+sCuUDQeJDiygd+V1PzNw1NmtNr4jPMb3E0oS0pESzxmB7H8cgBWpGy
	23fXshUi4C8NzebFlLl8LFtmnV4p0Q+QOMdfU36p3r0mZXBdb7zWPbQDSK2Abro9
	kTfjU5VHMuU9IH/JWX52vBGKIWJlyyeFdLgFY/Gh5vym2e51Isx6ZDqoWLudVan/
	w+/iSlGbo2tQSestH68O9MT4Ltn2hQtWY4eyqxLiNqrpz3nai7/A3QzAKj7Xv2GA
	pN7VTQ==
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com [209.85.222.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hpsa6sb4e-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 16:27:28 +0000 (GMT)
Received: by mail-ua1-f71.google.com with SMTP id a1e0cc1a2514c-98bcae867a1so498318241.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 08:27:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793636848; x=1794241648; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IE79JMn0wPrEDgdovegTuQ5M+CHvyEMAVwZJre8pogM=;
        b=J8YCTeBwllzueA5d6If9AO86uK8/9VHs8qZkIkd666+IhLFyml5l9azLr4m/tdk9WR
         dJldbowLh8XMN1SnGjKmC6JWKzq5qvHAbJCJJ3hsAr6AfTvvTrj2PxBMgo7NFkVs0Zu4
         YzTDv/ktwTNAJuhMkdthGK/3RuReoS/JiQXQ09lJzqgLD80epthFjWw+CkkRVP+6KfLe
         TX/YkvPaUsK5nbaGdC1vgEG/2KeBU7/wpc/27JZlU5uMHUnrefZRRrlDDKcniyly+5K0
         gj2C2fLUDt4CubWfcqOdXTJ7NtqAomVVFNTK7CAFRqSgBWalmLtHP0wNR8YtQjOFQ7DV
         Y3ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793636848; x=1794241648;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IE79JMn0wPrEDgdovegTuQ5M+CHvyEMAVwZJre8pogM=;
        b=ik7xpLAuhji06NDRkUKXoF7spELm76LnbofY9NXA8Zxk6niMO0NCrIX7cSCCKYYzUf
         4DRZ931bGcH5xUfFbmCda3lJQ9pvmaXbfY+4fJRFxrTuywxQztrgfi9SB7Elj0xAsHtU
         D311cZwPfFEgUdLzSwftfV4f9AFogtyzunkDKaAZLTXd5B3FUFDZWhE0RPL5M9fS6K6z
         lkU1Zo4HZuKJl5KnOP3QM0FQfIu2kdhb4JKMAVVq2HnAdZM9GdrU/nMTHvZi89lrD4VR
         +TmOB+7CEf5KzA7J/64sbOJBoE0yyDETcIw7/Izfs4E1T3YjvkuqizYz+Pgs5dcc8Fne
         /Efw==
X-Forwarded-Encrypted: i=1; AKwUvBwy9cxRN0KyeXqX31lkeTgkp+PnhcbvuVAyILs4HVglwSdAVR0UeDkHQmhd5L8MMO6NEuQ8KoPIPL86aYJHsA==@vger.kernel.org
X-Gm-Message-State: APuU4Z/znL5rd6PN25XaE/NaNDrMAPRPw5f4dWMaDLmH4bNzBG8e9TS4
	9+zBv8UQ7/+GIWQjlPYqZP512kvbor8H6zkD/1SYijLJ2JBYDjT//mX0lLT0MO+Y2m9WJwmSM6v
	O0SBEcaSCJvOz/Ya48laZVoJ/zYt0dfVkchDcDPDhOuT1PK147anJscq4oP0NXiv+MrgMlg==
X-Gm-Gg: AYBFou2rJmnYyvR3YUqQqVpMgTAYltnKpuzJVNbs+7yp5jM0Zv41MwvLzeLd/odNuX3
	aHyBQGMZdGUftJf4zjNUA1cJh56Q2q3iH5vHDQ1Le74Nw5IReVt/lbEUHE2HFg8l/C25PR34R6L
	NiM12E/FxcJ+0AMYut2OPue7G7ugAwwEMyg93i9BtdMRgNm8hiHVQPgjPALTkDKszXboWwQjnci
	P585dKL+E9k/lFRGX4nH4+usLJMNB2aTRMq3OApzJKNgoFC6hFpkdd+E4aQfs/a04ZhMp8gA2j1
	/ZZ8qfoeUIM7vGHwko+5x2MdbmKaSad1k4of9ZnVuFHhZlVnhH660E9wEGTy4fiJIfMz3YtZWlS
	YBLEOJMPfkMuu1pinObyzJQjmjDbnXz9srmEbpEDaRzWWNaROv0b5NBbwtONefV2v6CvcUh1xTP
	yR8FcSAHa6wLwvPRcPIFDPhNx5fHbg+aRVyyOosfUj0zySwZYtSEnxmJu73x0zPr+05z5TcYNWl
	lVWYtp8dhBr9iGpBVkmJDFVrn6c
X-Received: by 2002:a05:6102:8097:b0:7c3:3890:6076 with SMTP id ada2fe7eead31-7d0725cfd65mr3871178137.6.1793636848071;
        Mon, 02 Nov 2026 08:27:28 -0800 (PST)
X-Received: by 2002:a05:6102:8097:b0:7c3:3890:6076 with SMTP id ada2fe7eead31-7d0725cfd65mr3871137137.6.1793636847453;
        Mon, 02 Nov 2026 08:27:27 -0800 (PST)
Received: from QCOM-eG0v1AUPpu.na.qualcomm.com ([2a01:e0a:830:450:f048:3e89:c517:10cd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b959c1sm20490695f8f.45.2026.11.02.08.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 08:27:26 -0800 (PST)
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Date: Mon, 02 Nov 2026 17:27:20 +0100
Subject: [PATCH v12 1/2] block: partitions: of: Attach partition fwnode to
 the block device
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
Message-Id: <20261102-block-as-nvmem-v12-1-f4a2a681087d@oss.qualcomm.com>
References: <20261102-block-as-nvmem-v12-0-f4a2a681087d@oss.qualcomm.com>
In-Reply-To: <20261102-block-as-nvmem-v12-0-f4a2a681087d@oss.qualcomm.com>
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
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Christoph Hellwig <hch@lst.de>
X-Mailer: b4 0.14.2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDA2NSBTYWx0ZWRfX3VXwWnsa2Snh
 tzlrNiK5895svl+QYyCCy6X2trYup415rrsFSF1p5UneigEoT5FOTWcaAy8DB41wC45kekS5Gfc
 2rjhI0c2FveJ0RR1DNcUq0HIbtRstJWA/dv3/tB+/875jUBL1Qf0Nk7Gm6iNK2KyWmSPF76evXB
 wL9GO9cVst5Xix7Z48UR8THyAv1EcdHp7fuUU3ReX5XLvApx8loJM1iocrZ2RUliocGXlj17Lvk
 j87XY2pXhCCcA0dyOeRDE+6+eZVbFmTxF5+EleDoZwAIsPAz184YnoqSh/U91oT9ertWDUHrWCR
 22EYv8w5otooBCO/nhan0McujTyAroZ0npJuNFTWwOc0D99qo5IMTAcH6DdJQADm5rEcKOz8fiq
 culmtJR4E7rM6PkAwPMr27kv06GA18xVQ9NKTo6Pl/0eB642rEHC2gN8qWBL42sIUbKcG1hLKhF
 jGXZXrlY0hws9+GxF5w==
X-Proofpoint-GUID: bNBmrMMXSdkhZYojbT5XhGyp1oLnwWGQ
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDA2NSBTYWx0ZWRfXzvZiWZD2RSU5
 XsGgIudok0HWPYtRCUSbGtp072ld17icvHZsQ5AWPxl6Ob3PNvkAF3aRuzW65KFSslUNt4vwdVv
 GKixQo2dWqVk5BsGpk0jSw8OtQt0foQ=
X-Proofpoint-ORIG-GUID: bNBmrMMXSdkhZYojbT5XhGyp1oLnwWGQ
X-Authority-Analysis: v=2.4 cv=I9fw19gg c=1 sm=1 tr=0 ts=6ae8b9f0 cx=c_pps
 a=KB4UBwrhAZV1kjiGHFQexw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=EUspDBNiAAAA:8
 a=2ffTNAQyBkxXHBiWhEgA:9 a=QEXdDO2ut3YA:10 a=o1xkdb1NAhiiM49bd1HK:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-02_04,2026-11-02_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 clxscore=1015 phishscore=0 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611020065

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

Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
---
 block/partitions/check.h |  1 +
 block/partitions/core.c  | 20 +++++++++++++++++---
 block/partitions/of.c    |  3 +++
 3 files changed, 21 insertions(+), 3 deletions(-)

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
index b5c59b79ca7cbb28d4d93478ee1c80908f76ee9f..eee954df1ac6ef7dd4f02ad5c9d49aed778bf015 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -11,6 +11,7 @@
 #include <linux/sysfs.h>
 #include <linux/ctype.h>
 #include <linux/vmalloc.h>
+#include <linux/property.h>
 #include <linux/raid/detect.h>
 #include "check.h"
 
@@ -110,8 +111,17 @@ static struct parsed_partitions *allocate_partitions(struct gendisk *hd)
 	return state;
 }
 
+static void drop_partitions_fwnodes(struct parsed_partitions *state)
+{
+	for (int i = 0; i < state->limit; i++) {
+		fwnode_handle_put(state->parts[i].fwnode);
+		state->parts[i].fwnode = NULL;
+	}
+}
+
 static void free_partitions(struct parsed_partitions *state)
 {
+	drop_partitions_fwnodes(state);
 	vfree(state->parts);
 	kfree(state);
 }
@@ -139,6 +149,7 @@ static struct parsed_partitions *check_partition(struct gendisk *hd)
 
 	i = res = err = 0;
 	while (!res && check_part[i]) {
+		drop_partitions_fwnodes(state);
 		memset(state->parts, 0, state->limit * sizeof(state->parts[0]));
 		res = check_part[i++](state);
 		if (res < 0) {
@@ -247,6 +258,7 @@ static const struct attribute_group *part_attr_groups[] = {
 
 static void part_release(struct device *dev)
 {
+	fwnode_handle_put(dev_fwnode(dev));
 	put_disk(dev_to_bdev(dev)->bd_disk);
 	bdev_drop(dev_to_bdev(dev));
 }
@@ -294,7 +306,8 @@ static const DEVICE_ATTR(whole_disk, 0444, whole_disk_show, NULL);
  */
 static struct block_device *add_partition(struct gendisk *disk, int partno,
 				sector_t start, sector_t len, int flags,
-				struct partition_meta_info *info)
+				struct partition_meta_info *info,
+				struct fwnode_handle *fwnode)
 {
 	dev_t devt = MKDEV(0, 0);
 	struct device *ddev = disk_to_dev(disk);
@@ -343,6 +356,7 @@ static struct block_device *add_partition(struct gendisk *disk, int partno,
 	pdev->class = &block_class;
 	pdev->type = &part_type;
 	pdev->parent = ddev;
+	device_set_node(pdev, fwnode_handle_get(fwnode));
 
 	/* in consecutive minor range? */
 	if (bdev_partno(bdev) < disk->minors) {
@@ -449,7 +463,7 @@ int bdev_add_partition(struct gendisk *disk, int partno, sector_t start,
 	}
 
 	part = add_partition(disk, partno, start, length,
-			ADDPART_FLAG_NONE, NULL);
+			ADDPART_FLAG_NONE, NULL, NULL);
 	ret = PTR_ERR_OR_ZERO(part);
 out:
 	mutex_unlock(&disk->open_mutex);
@@ -564,7 +578,7 @@ static bool blk_add_partition(struct gendisk *disk,
 	}
 
 	part = add_partition(disk, p, from, size, state->parts[p].flags,
-			     &state->parts[p].info);
+			     &state->parts[p].info, state->parts[p].fwnode);
 	if (IS_ERR(part)) {
 		if (PTR_ERR(part) != -ENXIO) {
 			printk(KERN_ERR " %s: p%d could not be added: %pe\n",
diff --git a/block/partitions/of.c b/block/partitions/of.c
index 53664ea06b6540e3d1155141adaafac7286f2d21..4fc7c80c407de42b2b31be2c82e0e6bc2a30c9e3 100644
--- a/block/partitions/of.c
+++ b/block/partitions/of.c
@@ -3,6 +3,7 @@
 #include <linux/blkdev.h>
 #include <linux/major.h>
 #include <linux/of.h>
+#include <linux/property.h>
 #include <linux/string.h>
 #include "check.h"
 
@@ -62,6 +63,8 @@ static void add_of_partition(struct parsed_partitions *state, int slot,
 		partname = of_get_property(np, "name", &len);
 	strscpy(info->volname, partname, sizeof(info->volname));
 
+	state->parts[slot].fwnode = fwnode_handle_get(of_fwnode_handle(np));
+
 	seq_buf_printf(&state->pp_buf, "(%s)", info->volname);
 }
 

-- 
2.34.1

