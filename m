Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538A33CF678
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 14:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786027129; cv=none; b=GiRV3h2OA0IQGVnvYXe3c/rOqHPGBA1yBGjCyIce6nd5rlGHvOLUHv2V/AOAXw890sNKZfr1H+g7ep8zgfmuAKnnXAL+2NEKr74PuNrFtfBl9qIs+zMJcOj3WYvfNwIABsr5UF1P0mtysrChKd9C187gF7DboknNXY0OQkah4q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786027129; c=relaxed/simple;
	bh=Dbcp21AtdduzCnfwtnGpBRqMSrLBUlOfVvNlXE8wpqI=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=ZzNQZydLOAjOrav+p1IvgyKb0VsUeGKrvydsybsR4WTAkJlW0WNAEyBwD6jlQ6fKV84TlakNPp8qjEkz8dFoKJfpszPER82WBGu7sWba+tFJznDh7do1Q0Debt5KzBquWDnQNZ2n8uZuQaCedhqGGsBd0VDVGP/gX6FVSpbONj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=RjcgnDjD; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IMOzRCVq; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="RjcgnDjD";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IMOzRCVq"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6769ntRG1626143
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2026 14:38:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=KOatdI4aMcMRWWupN6j4vS
	QEII+iBiMgRDvmtcwV5UU=; b=RjcgnDjD7rXq621tdLNp0nqLSaOMdz6o3MPcdI
	Iuf3My0+UGmRS0A4DFicF4P4snOzYSW0fBws4JUV2NJth8tRFHcIxyWSaeydEykc
	Wz/cur26D/Ti8Aa3LQfw6c/W9zoNs8QAFIo+8Us5gXXlnK02aH+yLhr+XsjjuxDC
	oqLtmB11Y+SW3b2MndVmlYfAT8IfSsclYbF0qnth7S8rJhu47aM6975plUxNqXhP
	DpxZz+/Bfz1zLXjHWcvQmNWnklmOyh/MTR4+UzaSoeELtG04uqDbfjmFE8wJy8BP
	FLAP+/gwUz9Aomz4qxaTptDyyVgv+pYEWEN5IEY0mVhr9Hmg==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvntnhxna-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 14:38:47 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-5283df62d68so25617631cf.0
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 07:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786027126; x=1786631926; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=KOatdI4aMcMRWWupN6j4vSQEII+iBiMgRDvmtcwV5UU=;
        b=IMOzRCVq1LP4VcTPNMVciWAMB9NvHcg5NOaZsTUNmp/3hNz0AYw5bs6zGZIEBR/Qfd
         TVTkvat/WjK4c9a2+B6vtjBYvNpZnbFfOfMieyM+qXdju7r214Ru6c/fGW3kI/GSal1v
         T7nIs3fhc4iEqf+iTBiHpXEz8Thz9lU65p7hJtikH3mrc6fW+Q89YKtBV7RJi98vGmqa
         a6h2T/aZ8gWU10lcoEM+ZdlMV1oiuWrayNwtj2sjAsS8wpUXW5oWduffbwhJulah2EUE
         14TPwQQcQ7zcF0y2VtxYNzKY5kh3JkUjKL/SahZaBdcDpThNSXmSmL3+ILMybDHpkmME
         ADtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786027126; x=1786631926;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=KOatdI4aMcMRWWupN6j4vSQEII+iBiMgRDvmtcwV5UU=;
        b=f4gJneypr+V8Bvvzv5smd2bhRJQCbJeaeR32m5t59V6ZSL2vwm95X938ycLNfNWtCx
         2tFBLc9g2eeko8X3PpKZmWUQL+VNf+c58MwKTY+CMbpqSEM7gqS+mur7hT+GhI+g5a9r
         hzJGXi9UE/XAXKbqOn+Ld464TZhUM22DmKxl4UzTzTlKfftJ6jZ4eQtRRflCQxZLz9zG
         nowH4WbnA/Hgszc7J0pNy+4GPUFeSJ27AXbyPIaftjys3qxk4seYVu5tx5oUirrMtmWC
         wTL0R5hw90J9haMaSLA21hNynb5IBfjYKu0NJSFQcutGgCQpex75DgNoWBKuQoIaeRDG
         92Xw==
X-Forwarded-Encrypted: i=1; AHgh+RqXzOJEMzh6Ws7tv8rxqy7TSLxiR47FZqfqazyJMYylLRgPoj32/3fBIvOmTkRwEv819o1UkGlSNYkghwipiw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxrlaPlHxd3P9830dOPaTXqCEqWidqTg4+qY9EdA9sDKwEd1/G8
	06o0MAiMlBTDbGDosnQpktaezuEVx2kQd3PJCxSX+lv6Abn+FzfV4iyVQvKQWQWYXvm4LYJ1tS1
	hESsC4UIx1hCCN1Pp11Q090XKzKjYKcf6ueP6iZyMlhPx7R6JFe1CoGpunWHX4ejYKtG4Tg==
X-Gm-Gg: AR+sD138UskR1hTVp+LRowzU6qydi7mWQ5s7MG/KEIot+jDirx0wM6b1m065tGchoeh
	LMJXwNUbnMMDRytYASnbPvYPIf4nJUjqpHMpQPJ4PvEcQIQ8/V7zpiXWxzTg/Bfb8K9vhhXV2hL
	SkfxvdHRiFvdzOZD4R2lcwqTRNNY86wqrQUpjPXyuq5uVGRsQzJp4jKES8Ikra7irtqosuvgX4O
	7HlsUZY5VTTzYlCVWuBzYihH+uExNVOe0dlQYJ73/GwocU5yGds+LcyRJtsAouEOcKUlb9+lLKe
	7V1ns1k/lwgdxSNnqGMbbnlVSEgoAImuFGYNXbKhtx/oZ5aOdnZxx+9vL/ONXfi+OoUesZ2wR0e
	gltrnAEY3IBsCuNBgfLalHoptz7pxs6/T9yYqvXKh5DZkIjhvqo8uw2GTCQc0ZE76rWEOcByZDW
	5p5eUGfhHIckJql+t9CkcF9HkKHn/3kVcC68ObL89OZqsKz05lsg==
X-Received: by 2002:a05:622a:13c9:b0:51b:ecca:f2e0 with SMTP id d75a77b69052e-52ce5f44c7dmr149088691cf.5.1786027125903;
        Thu, 06 Aug 2026 07:38:45 -0700 (PDT)
X-Received: by 2002:a05:622a:13c9:b0:51b:ecca:f2e0 with SMTP id d75a77b69052e-52ce5f44c7dmr149087731cf.5.1786027125394;
        Thu, 06 Aug 2026 07:38:45 -0700 (PDT)
Received: from QCOM-eG0v1AUPpu.na.qualcomm.com ([90.85.108.51])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2036276e58sm270552166b.28.2026.08.06.07.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 07:38:44 -0700 (PDT)
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Subject: [PATCH v10 00/10] Support for block device NVMEM providers
Date: Thu, 06 Aug 2026 16:38:33 +0200
Message-Id: <20260806-block-as-nvmem-v10-0-be598b2a5606@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAGmcdGoC/3XRzU7DMAwA4FdBOZPJcf458R6IQ9I4rGJdoYEKN
 O3dSXdZpZCLJVvK559cWKFlpMKeHi5soXUs43yuiYDHBzYcw/mN+JhqgSGgAYWOx9M8vPNQ+Hm
 daOIqSnDkYgo+sProY6E8/tzEl9eaH8fyNS+/twar2KpdahUcuAkJJVktPITnuZTD53c4DfM0H
 Wpgm7jiXdFgGwWrErOwlJIWUlFHkXfFQDuLrIpD40TWEILUHUXtFd8oqipKW4FkIuJgOoreKQI
 bRVfFa4J66pyzh45idgq2s5iqZMB6kzQkZVJHsXfFgmgUWxWZySFoyhBcR3F7RTaK2zZygSTGP
 Cjf+2m/UyQ0it82suildsKmmP9RrtfrH1naay/kAgAA
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
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        Christoph Hellwig <hch@lst.de>,
        Piotr Kwapulinski <piotr.kwapulinski@intel.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDExNCBTYWx0ZWRfX+AkXO7PS6Qmh
 QdeA4cUhX5DiScT+EaLOWcuwk6Kx6JmNdkdANpYKIamdJDnDiqh9ME1SRjT8opYzn4MxkgjjAUh
 BRu0sSyIalnfnku8brmf+B5NTqV8+6N5mBlkG8cV7lkR+MBT+TBuULskrWTb13Az0cu+cH4o5VM
 vDDFvYRACmXlKfKyzZcrLJcKGcM/K2Ds/ArV/gmpEepG+6n72+zJ0OUVlTBFUNsZZB2PVZdbzOy
 N2t592K6U6gepUxU+5jS9KkMfOAB5O0KHPLtAw88hpPFHqrD1HYRqFHrD0r09K98mpYQV3rOe4j
 8TQUIJI1I2/GR7oCBmD6vSZtYv90vhW3sSwr8SJFXPNoJjdq62DK7e7l01NQeTPP4HNG2U+NTIk
 mHQ1KYQIGBVHVlU3hNukU5Q23cFTIOcSuIzyWM9REU4AzfOBi6UpjUTdFg76wb9U9/D7T0M37XU
 7Y8di5+t3rsTPTS08pA==
X-Proofpoint-ORIG-GUID: IZ5kyIu8hA6I5-zLPqusN33BHxDMh11f
X-Proofpoint-GUID: IZ5kyIu8hA6I5-zLPqusN33BHxDMh11f
X-Authority-Analysis: v=2.4 cv=LpKiDHdc c=1 sm=1 tr=0 ts=6a749c77 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=JDRa4Jy4r6/BpSpxP2cCow==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=VwQbUJbxAAAA:8 a=VT4XjZGOAAAA:8 a=EUspDBNiAAAA:8 a=tqjjm0btxrnhZIKebqcA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
 a=6CpsfURP9XNmmWg3j1mJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDExNCBTYWx0ZWRfX6VjGCCd2ei9E
 jhqMpjdI7mEuSRaDn9oKXioLCffmgmyq5Aqsu1x0crxz2QwVmlT8UnipKNMrIJDRV3icmvjCUB8
 i3+G3eD0rvQj0sPs5Tpt0XGE8Ksy/f0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 priorityscore=1501 malwarescore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060114

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
Loic Poulain (10):
      dt-bindings: mmc: Document fixed-layout NVMEM provider support
      dt-bindings: net: wireless: qcom,ath10k: Document NVMEM cells
      dt-bindings: bluetooth: qcom: Add NVMEM BD address cell
      nvmem: layouts: Support fixed-layout as the nvmem device node itself
      block: partitions: of: Attach partition fwnode to the block device
      block: implement NVMEM provider
      net: of_net: Add of_get_nvmem_eui48() helper for EUI-48 lookup
      Bluetooth: hci_sync: Add NVMEM-backed BD address retrieval
      Bluetooth: qca: Set NVMEM BD address quirks when address is invalid
      arm64: dts: qcom: arduino-imola: Add NVMEM layout for WiFi/BT

 .../devicetree/bindings/mmc/mmc-card.yaml          |  23 ++++-
 .../net/bluetooth/qcom,bluetooth-common.yaml       |   9 ++
 .../bindings/net/wireless/qcom,ath10k.yaml         |  16 +++
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
 drivers/nvmem/layouts.c                            |  13 ++-
 include/linux/blk_types.h                          |   4 +
 include/linux/of_net.h                             |   7 ++
 include/net/bluetooth/hci.h                        |  18 ++++
 net/bluetooth/hci_sync.c                           |  41 +++++++-
 net/bluetooth/mgmt.c                               |   6 +-
 net/core/of_net.c                                  |  52 +++++++---
 20 files changed, 370 insertions(+), 21 deletions(-)
---
base-commit: 5174c725cd98c717af2a4fabb7615a11b3ab4b9f
change-id: 20260428-block-as-nvmem-4b308e8bda9a

Best regards,
-- 
Loic Poulain <loic.poulain@oss.qualcomm.com>

