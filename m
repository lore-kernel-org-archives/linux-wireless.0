Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF2B5326BA
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 14:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792074383; cv=none; b=kZtMYfc4vYK2ftProB9plmYfoM4DsI44mSP+IswRkz4AYdMtgQEAlkkQ5mwZSAv8WfxOax42eTE5+mx0jGd10jFp9hdHfTNWpXuKTAx7vkQl8aOasZTuMECXjOKHZw5iOTCCE1KEBLjFvP4zBK5ADsFOsrVqWxfkYzR3QmtFbJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792074383; c=relaxed/simple;
	bh=v6B4pGlB15qzDa60OAR4xYAziYlSgj48SYzsH2z92fA=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=KL04ZcGYI5hGXsB26z74yDceMRyV/9jf6Fcr/DK+QBnUIhznfbGb8+OoqP5AHEvgJU/sQuGLsv2E7zowYP/LA8tSpA2UInU7zo9ofIT/KVzs0iWRG+7ZO/pLAapR+jL3+gN/rUf8vlOco1+Cwmd4h5yIQLVc4XKSbcv5h98IGPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FWIGrUZU; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JcHtsMZ2; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FWIGrUZU";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JcHtsMZ2"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69F9jeOF1955612
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 14:26:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=xhiR0eGHIMEJDeGPWUuO5n
	vAYyIG1mI9G6WhoIq53T8=; b=FWIGrUZUdNKKjjZWBp3l4RMNHqJJ2aKexIy6pw
	DvKcaX/iVimpXKY6jRZU/xxYklHlux3kpHXn/+CTB05Cbky8BlSB3hwx9VDjimqI
	039OUEuH001yGize62ZWlMrDXM2PG9iBn1Ge0eEvO/lq+QGNegaXKMVl6JvtW068
	CTxevQdD3Y6paxiPfLio11L3IstrXpWynDxHsoAXZj+zKJIUodoPsDGOaNJ6H97b
	BqfhDep3hX6eS+jlB4LtAH2W6DhkFLci2TERTR5/CSwovZm9vcoohyokVpqgjZlx
	UpHX6jVXsFtlqKLPTmfAvNj3ThrplCfii7WANYajF6ZT4TOQ==
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com [209.85.221.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hakdeubgh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 14:26:14 +0000 (GMT)
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-5e975625f00so1208908e0c.0
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 07:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792074373; x=1792679173; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=xhiR0eGHIMEJDeGPWUuO5nvAYyIG1mI9G6WhoIq53T8=;
        b=JcHtsMZ26pbvfDHLywXbimBwwxVk2WL/1FXoZO671931STG+B8vCEyO4wDP/aoYKBn
         4D7tGAPGmm+y4Jx97X+wVir3p6frvlj9vaV002PmHPphb3RzZjPjQ2r+Br2udfADKlVn
         +UjpsBE1bkw2VxLPl2GqtSJAfHB+7CHJnvGwfiGwJj1Hh7Zi5i+Q0Q6axJPvFpzDZQnX
         0ye85pz3uX8laxdKJgcBLFHGVOi/FM4DB8Xqj6pvgJdlH9A0BlEVBKLs//I7l/wAnyuV
         HSsEcGFo5WpSAKSrH+dMSQiREVENPOkGgWK5WzPaznh59usLehFP0saaMIquN40YGsEA
         lIZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792074373; x=1792679173;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=xhiR0eGHIMEJDeGPWUuO5nvAYyIG1mI9G6WhoIq53T8=;
        b=AprZx8zhvoGIsJCRCstw+4ZR6xwy5u+jK6+svZEBxWRGfLtCy5o/v5KPriowxNj4nN
         M8tw+WJW7FSIaoXgS2p8D/IybnVjrjhVw29JRInbrld8pwpCqBApst/XRUu7IlKXEuuR
         J86n7gnXwJqlX0ptTXG9NAI6+OMrFxTRGEUzYl2d6unt6G7Mc6tsZuY33TRCqGjXuGXZ
         TWq6ifgNbVyP/Y/lRCNu5ZMRV1kyNrLDqrbb6XjGxTB04agLaAOPNuctTFPfNDSJCE4d
         IVj4ge4byogZiD7j8oRoVPb5MI+QbDdjploP0pFb397mtcNsK25gWdXqk77EW5cunAYn
         vnMQ==
X-Forwarded-Encrypted: i=1; AKwUvBzKfIHFGQxbSMTTECyHOQgF6PI4YiMQKtW60QpzRZf1hkXuzzokRew0pSZF/OeWr0YAf0Vq79zL2SYYZKF5kQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYJvG8ZHP8BGrcdlqxGzTmYwVaij01jynhzoXTpqRLAxRz7bD+0c
	mAAQkYsEGWi8O4RbsXBgfkCyZQ0OX+6GogK4L5bZM5VVwFf+Qx1tCG1zE9go7+S/SLEm9j0LCNd
	z8selS5x3n2hP0x2DONYnQ0wtqOs1qN1E2CYbWfs5PHZoDvYu5dNARl02U8dM2Z6zXl5OOA==
X-Gm-Gg: AYBFou18/bYNCdfb3U5M3p+2p57ZrN/yRjZmHuICP9OwHKzhxHG7K8EOOtwqDmvtDJ0
	ZD2b+pW1G6+ayd7xh8iHnpCr+bPGhNZOftJ1bKsLa7MEuWyeYRKy360+TO8mdlzBNwIuN7Wf38D
	llRzaKBwQEWBJdy7TphwwFSX2moZC1HbgEx1guAbo0ZDlOVwXVO+UKQPfPLnG7q0UNr3e5fvWg1
	MqSw/rXoGjJCacHlwoN3+hPjJzNgTpB/Ul8ljpA3ZMaz6/jG6PiBF1aiS8C/nTc9wVfZ4YjNzM6
	I3zD5PknBZsvdI04KmxauPvey41iukRpqEfIlouf/DBSazWqAHKvEUwCsh2AsGFVm1YAaNJzude
	xSJpFMTzQQUY+XKNDLhPdJ+oF5fJgmWSkSfqKPPSabk6EEPctKsb5s9NTIKTx4vTvfqZkakcfIK
	kVuBJfCZRQHHTIuw0tt/SLhC3FjW1BQjYZPXGFEqGrTlNqlacBzvA=
X-Received: by 2002:a05:6122:8b1c:b0:5e9:176f:a548 with SMTP id 71dfb90a1353d-5e91efb1041mr6704139e0c.0.1792074373159;
        Thu, 15 Oct 2026 07:26:13 -0700 (PDT)
X-Received: by 2002:a05:6122:8b1c:b0:5e9:176f:a548 with SMTP id 71dfb90a1353d-5e91efb1041mr6704076e0c.0.1792074372429;
        Thu, 15 Oct 2026 07:26:12 -0700 (PDT)
Received: from QCOM-eG0v1AUPpu.na.qualcomm.com ([2a01:e0a:830:450:5402:5e0b:9ef0:9b5b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1bd6428b3sm69083145e9.1.2026.10.15.07.26.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 07:26:11 -0700 (PDT)
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Subject: [PATCH v11 0/7] Support for block device NVMEM providers
Date: Thu, 15 Oct 2026 16:25:59 +0200
Message-Id: <20261015-block-as-nvmem-v11-0-f890ac74f87d@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAHfi0GoC/3XSzW7DIAwA4Fepch6VMf897T2mHSCYNVrTbGGLN
 lV995FeEolxQbIlPmzjW5dpHih3p8Otm2kZ8jBdS8D506Hrz/76RmyIJdEhoAaJloXL1L8zn9l
 1GWlkMgiwZEP0znfl0sdMafh5iC+vJT4P+Wuafx8PLHzNNqmFM2DaRxRkFHfgn6ecj5/f/tJP4
 3gsR7eKC26KAlMpWJSQuKEYFReSGorYFA11LaIoFrXlSYH3QjUUuVdcpciiSGU4kg6IvW4oaqd
 wrBRVFKcIyqhTSg4ait4pWNeii5IAy0xiH6WODcVsigFeKaYoIpFFUJTA24Zi94qoFLt2ZD0JD
 KmXrvXTbqcIqBS3dmTQCWW5iSE1FA4bY0HXawfrxpByNqBXZXj/OPf7/Q+q0+5bLAMAAA==
X-Change-ID: 20260428-block-as-nvmem-4b308e8bda9a
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
        Christoph Hellwig <hch@lst.de>,
        Piotr Kwapulinski <piotr.kwapulinski@intel.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Authority-Analysis: v=2.4 cv=OdENnRTY c=1 sm=1 tr=0 ts=6ad0e286 cx=c_pps
 a=+D9SDfe9YZWTjADjLiQY5g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=VwQbUJbxAAAA:8
 a=VT4XjZGOAAAA:8 a=EUspDBNiAAAA:8 a=zFza9r7X0cgvMxzYsRQA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=vmgOmaN-Xu0dpDh8OwbV:22 a=6CpsfURP9XNmmWg3j1mJ:22
X-Proofpoint-ORIG-GUID: ZRyoxym7N6Kz664HMfnuPvLvtbASlqO0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDA1NyBTYWx0ZWRfX0ds7cQRKIKLl
 jFmo9Joytr5aj5sdCgPswqIeYlKqMAQj3ik/N2wtMOpsfToP6XQMB/RCIlFBivhFUtmJtAfe51U
 lR79zY9tHDg8MSKkqr7BMe53b2yjFLIYq2aJquWtXFj+WMNyjZ3k8nc4pui3AUxnGovj0Zof2VR
 zPuvK84zyAUbTNs6FIzwzG3WZ1hEJe+Rb+uZnQGU6pJaklWkzJg4fSHJvhziJtasKjP6OzWTyUY
 UZc5JCtA/ltlwgS5nez63XCD2jCbXFQ4XdzC0AsraA7rI5UTUFumiVM8LbRLN9NxPaXTVNUW6iI
 r1cmEzRJIhX7NmLviBB4KxM2L34koaAVwLZNwIOaI2pBQzTVh4pHfhQgDf90/mK68VsFfulW45y
 AHFVkX+78g/dMpUrWYyYCjreMVN7mv8545v41hMCCVv0mnncnYshtuB+BUc7inuwG7IaJW3w5C6
 YIObjUFeDhQS8f9A+6A==
X-Proofpoint-GUID: ZRyoxym7N6Kz664HMfnuPvLvtbASlqO0
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDA1NyBTYWx0ZWRfX6JANYY/flmQe
 AQxikikNxJuWIwADcCcjPvf9OctvDH6YlJVYtCJQkf4/xEDhVuOhaSZfjhg8rELaUOZSy5zIgs1
 +NKmNRzXGI9QeTDXfmwJddYttDCeynQ=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 impostorscore=0 phishscore=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 adultscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610150057

On embedded devices, it is common for factory provisioning to store
device-specific information, such as Ethernet or WiFi MAC addresses,
in a dedicated area of an eMMC partition. This avoids the need for
and additional EEPROM/OTP and leverages the persistence of eMMC.

One example is the Arduino UNO-Q, where the WiFi MAC address and the
Bluetooth Device address are stored in the eMMC Boot1 partition.

Until now, accessing this information required a custom bootloader
to read the data and inject it into the Device Tree before handing
control over to the kernel. This approach is fragile and leads to
device-specific workarounds.

Rather than adding a new NVMEM provider specifically to the eMMC
subsystem, the new support operates at the block layer, allowing any
block device to behave like other non-volatile memories such as EEPROM
or OTP.

This series builds on earlier work by Daniel Golle that enables block
devices to act as NVMEM providers:
https://lore.kernel.org/all/6061aa4201030b9bb2f8d03ef32a564fdb786ed1.1709667858.git.daniel@makrotopia.org/

It also introduces an NVMEM layout description for the Arduino UNO-Q,
allowing device-specific data stored in the eMMC Boot1 partition to
be accessed in a standard way.

WiFi and Ethernet already support retrieving MAC addresses from NVMEM.
Bluetooth requires similar support, which is also addressed.

Note that this is currently limited to MMC-backed block devices, as
only the MMC core associates a firmware node with the block device
(add_disk_fwnode). This can be easily extended in the future to
support additional block drivers.

Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
---
Changes in v11:
- Rebase on linux-next + resend
- Link to v10: https://lore.kernel.org/r/20260806-block-as-nvmem-v10-0-be598b2a5606@oss.qualcomm.com

Changes in v10:
- block/blk-nvmem: simplify read error handling (Christoph)
- block/blk-nvmem: verify dev_t wasn't reassigned before reading (sashiko)
- block/blk-nvmem: drop __free() cleanup for explicit of_node_put() (Christoph)
- block/blk-nvmem: init static nvmem_config fields at declaration (Christoph)
- block/partitions/of: fix fwnode ref leak on skip/abort/error paths (sashiko)
- Link to v9: https://lore.kernel.org/r/20260730-block-as-nvmem-v9-0-f72935817dbf@oss.qualcomm.com

Changes in v9:
- Add nvmem support for partition blocks, not only disk (Christoph)
- Prevent concurrent exclusive access to the block device on read (Christoph)
- Add comment about nvmem being a side channel for block device access (Christoph)
- Link to v8: https://lore.kernel.org/r/20260703-block-as-nvmem-v8-0-98ae32bfc49a@oss.qualcomm.com

Changes in v8:
- block: Fix bdev->bd_nvmem on registering failure (sashiko)
- net: of_net: of_get_nvmem_eui48() now also rejects all-ones cells (sashiko)
- Bluetooth: mgmt: account for HCI_QUIRK_USE_BDADDR_NVMEM in
  is_configured() and get_missing_options() (sashiko)
- Reword blk-nvmem KCONFIG help text to satisfy checkpatch
- Link to v7: https://lore.kernel.org/r/20260701-block-as-nvmem-v7-0-3fe8205ef0a8@oss.qualcomm.com

Changes in v7:
- Rework bindings/dts so that the eMMC boot partition can be a nvmem fixed-layout
  and not a child of fixed-partition. (Rob)
- Add Support for fixed-layout as the nvmem device node itself
- Remove "block: partitions: of: Skip child nodes without reg property"
  This is no more required in this series and will be submitted separately (Rob)
- Add missing linux/cleanup.h and linux/device.h includes (Bartosz)
- simplify nvmem_register() error path using dev_err_probe() (Bartosz)
- nvmem_device forward declaration to blk_types.h (Bartosz)
- Add hci_dev_get_bd_addr_from_nvmem() kernel-doc for return value (Piotr)
- Link to v6: https://lore.kernel.org/r/20260629-block-as-nvmem-v6-0-f02513dcd46d@oss.qualcomm.com

Changes in v6:
- blk_nvmem_add() returns int, error properly propagated (Bartosz)
- Redundant if (bdev->bd_nvmem) guard removed in blk_nvmem_del() (Bartosz)
- Size guard changed from UINT_MAX → INT_MAX to avoid signed overflow in config.size (sashiko)
- BLK_OPEN_RESTRICT_WRITES removed from blk_nvmem_reg_read() (sashiko)
- Link to v5: https://lore.kernel.org/r/20260612-block-as-nvmem-v5-0-95e0b30fff90@oss.qualcomm.com

Changes in v5:
- Fixed ath10k binding issue + extended commit message (Krzysztof)
- Moved blk-nvmem handling to block core instead of a class_interface
  This allows correct/robust integration with block device life cycle (Bartosz).
- block: partitions: of: Skip child nodes without reg property (sashiko)
- Link to v4: https://lore.kernel.org/r/20260609-block-as-nvmem-v4-0-45712e6b22c6@oss.qualcomm.com

Changes in v4:
- Fix squash issue (dts commit incorrectly squashed) (Konrad)
- Use devres for nvmem resources (Bartosz)
- use __free() destructor helper when possible (Bartosz)
- Fix value return checking for bdev_file_open_by_dev
- Link to v3: https://lore.kernel.org/r/20260608-block-as-nvmem-v3-0-82681f50aa35@oss.qualcomm.com

Changes in v3:
- Fixed missing 'fixed-partitions' compatible in partition (Rob)
- Fixed clashing nvmem cells, document calibration along mac (Sashiko)
- Remove workaround to handle dangling nvmem references after
  unregistering, this is a generic nvmem framework issue handled
  in Bartosz's series:
   https://lore.kernel.org/all/20260429-nvmem-unbind-v3-0-2a694f95395b@oss.qualcomm.com/
- Validate mac (is_valid_ether_addr) before copying to output buffer
- Link to v2: https://lore.kernel.org/r/20260507-block-as-nvmem-v2-0-bf17edd5134e@oss.qualcomm.com

Changes in v2:
- Fix example nvmem-layout cells to use compatible = "mac-base"
- Squash WiFi MAC and Bluetooth BD address consumer patches into the nvmem layout patch
- Fix possible use-after-free in blk-nvmem: bnv (nvmem priv) linked to nvmem lifetime
- Simplify nvmem-cell-names from items: - const: to plain const:
- Factor out common NVMEM EUI-48 retrieval logic
- Reorder changes
- Link to v1: https://lore.kernel.org/r/20260428-block-as-nvmem-v1-0-6ad23e75190a@oss.qualcomm.com

---
Loic Poulain (7):
      dt-bindings: bluetooth: qcom: Add NVMEM BD address cell
      block: partitions: of: Attach partition fwnode to the block device
      block: implement NVMEM provider
      net: of_net: Add of_get_nvmem_eui48() helper for EUI-48 lookup
      Bluetooth: hci_sync: Add NVMEM-backed BD address retrieval
      Bluetooth: qca: Set NVMEM BD address quirks when address is invalid
      arm64: dts: qcom: arduino-imola: Add NVMEM layout for WiFi/BT

 .../net/bluetooth/qcom,bluetooth-common.yaml       |   9 ++
 arch/arm64/boot/dts/qcom/qrb2210-arduino-imola.dts |  32 ++++++
 block/Kconfig                                      |  11 ++
 block/Makefile                                     |   1 +
 block/blk-nvmem.c                                  | 112 +++++++++++++++++++++
 block/blk.h                                        |   8 ++
 block/genhd.c                                      |   4 +
 block/partitions/check.h                           |   1 +
 block/partitions/core.c                            |  25 ++++-
 block/partitions/of.c                              |   3 +
 drivers/bluetooth/btqca.c                          |   5 +-
 include/linux/blk_types.h                          |   4 +
 include/linux/of_net.h                             |   7 ++
 include/net/bluetooth/hci.h                        |  18 ++++
 net/bluetooth/hci_sync.c                           |  41 +++++++-
 net/bluetooth/mgmt.c                               |   6 +-
 net/core/of_net.c                                  |  52 +++++++---
 17 files changed, 320 insertions(+), 19 deletions(-)
---
base-commit: d419d682257d813f6cb7a28e42b35d0edf4ad038
change-id: 20260428-block-as-nvmem-4b308e8bda9a

Best regards,
-- 
Loic Poulain <loic.poulain@oss.qualcomm.com>

