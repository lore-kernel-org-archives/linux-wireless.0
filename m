Return-Path: <SRS0=ogP8=PS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95B52C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 08:46:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A79220879
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 08:46:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="xwDVHMz8";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="bzwe3XzH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbfAJIqC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Jan 2019 03:46:02 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:34316 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727328AbfAJIqC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Jan 2019 03:46:02 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x0A8j4Rr006811
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jan 2019 00:46:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0818; bh=cEZwGArM4igP5sBs1LUOEysqyIQLHGLn7smORiCM/Yo=;
 b=xwDVHMz81y0ekrs3lfuSeRHcXiE2GimODUh9bK9hT8HTcqC7dcIx30QlOXUpo/19gVq5
 FsA3pH4C88RxEVaMu3od6i027RWiZ/51BcDGqMf0FQa18fOWb40DLJfZF4SbamgLByHF
 Ar0WqggXfsM6RFj56FHutOwfhiTYleka/IwSijCkE7pfCVvJafEQ6c1XqcY7+JnpPHvf
 Yx51PNqSpbKLGVmqJcOuSiZiKlZvKw3LDUPb/yh3M9KmC1J7RJrOe6exViHKlmREnVaf
 VxPA27Go2oGNM9KXzOxe5v6iiGBWjCo+plpfM8BsodXPYbHsc17j67y49NFOLbCk+m8o Tg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2pwrc5ttnt-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jan 2019 00:46:00 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 10 Jan
 2019 00:46:00 -0800
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (104.47.33.50) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 10 Jan 2019 00:45:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cEZwGArM4igP5sBs1LUOEysqyIQLHGLn7smORiCM/Yo=;
 b=bzwe3XzHmk8SXkHqujrBTqP6SzaxIvEXteMoiGyxVKsPn8N+yqSNsLKwE/Lpknj5oFvB/5NcGc6fR7tfeE3RIP9IFPtmLtOVVIo0Nfy+7SkL83kdjvC/u73YeG6mnhRP7OI6BOM++kHsrK168Dtoh0z6bfbyemB90XeUdmT0bzQ=
Received: from CY4PR18MB1237.namprd18.prod.outlook.com (10.172.176.7) by
 CY4PR18MB1541.namprd18.prod.outlook.com (10.173.62.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1495.9; Thu, 10 Jan 2019 08:45:54 +0000
Received: from CY4PR18MB1237.namprd18.prod.outlook.com
 ([fe80::95d4:8a68:81d7:87c5]) by CY4PR18MB1237.namprd18.prod.outlook.com
 ([fe80::95d4:8a68:81d7:87c5%8]) with mapi id 15.20.1495.011; Thu, 10 Jan 2019
 08:45:54 +0000
From:   Ganapathi Bhat <gbhat@marvell.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Cathy Luo <cluo@marvell.com>, Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Rakesh Parmar <rakeshp@marvell.com>,
        Hemantkumar Suthar <shemant@marvell.com>
Subject: [PATCH v3] mwifiex: add support for sd8977 chipset
Thread-Topic: [PATCH v3] mwifiex: add support for sd8977 chipset
Thread-Index: AdSowMeaJvLZaZpMTJCHp8p+7nhmQw==
Date:   Thu, 10 Jan 2019 08:45:54 +0000
Message-ID: <CY4PR18MB1237E51E20E86ED04AF401D0A0840@CY4PR18MB1237.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [182.72.17.59]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;CY4PR18MB1541;20:bvdPm8e+3fF0QUwURVYTkRnxJPMDsepjy4m3wmYHxQ02Wk09BH6QJqBo0JduYubWJG2LmbT/eiBnrej7PcgufdShkG7sqk2QMQyDSojjbePW15Px/dofU5H/LG68/tmH+MzyQfiz/7YKU7cv6XjhrjW/N72NEf7a/HuKBzK5Obs=
x-ms-exchange-antispam-srfa-diagnostics: SOS;SOR;
x-forefront-antispam-report: SFV:SKI;SCL:-1;SFV:NSPM;SFS:(10009020)(366004)(346002)(136003)(39860400002)(376002)(396003)(199004)(189003)(105586002)(6436002)(66066001)(8676002)(256004)(4326008)(2501003)(99286004)(316002)(74316002)(575784001)(86362001)(486006)(55016002)(5640700003)(78486014)(14444005)(81166006)(305945005)(81156014)(7736002)(476003)(8936002)(6916009)(186003)(33656002)(71190400001)(7696005)(68736007)(478600001)(3846002)(5660300001)(9686003)(25786009)(107886003)(97736004)(6116002)(71200400001)(53936002)(54906003)(14454004)(2906002)(55236004)(6506007)(26005)(2351001)(106356001)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR18MB1541;H:CY4PR18MB1237.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-office365-filtering-correlation-id: 0a933901-87fd-4f2f-ab49-08d676d80831
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:CY4PR18MB1541;
x-ms-traffictypediagnostic: CY4PR18MB1541:
x-microsoft-antispam-prvs: <CY4PR18MB1541593E82C8E6476199D97BA0840@CY4PR18MB1541.namprd18.prod.outlook.com>
x-forefront-prvs: 0913EA1D60
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: PhDK4+6qnKwfPAU2FeckrStOnugylCxoS7pqXwO4xutIOu4EzvW7TnXQgAvZFM3yFzyUnw6aQjZeDZq8wGr/GHssqddJ79FTj6z/YAWJiVzZYgr6CzHZkD+9XIELQ362FJl5ai2nsIf5KSNWYUQFBiHGYtxxVVQrQ5rBTNpl0tHZZUKhL6hl4qWqAHN71JxLyrlRKsxI9ZlbWDf6BoNN5MiJFqjTZPzCKr0g4lGBGG/1nLAQJj/4IL6/2Wa5PmSRZeWpEneZj1K037vLyD4jBpOMoQr895GpwFE1gb/4UWCeVkCtdwCOMnliP3MGQmEN
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a933901-87fd-4f2f-ab49-08d676d80831
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2019 08:45:54.1052
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR18MB1541
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-01-10_04:,,
 signatures=0
X-Proofpoint-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=868 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1901100073
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Hemantkumar Suthar <shemant@marvell.com>

This patch adds support for 8977 chipset to mwifiex with SDIO
interface. Register offsets and supported feature flags are
updated. Firmware image used will be mrvl/sd8977_uapsta.bin.

Signed-off-by: Hemantkumar Suthar <shemant@marvell.com>
Signed-off-by: Rakesh Parmar <rakeshp@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/Kconfig |  2 +-
 drivers/net/wireless/marvell/mwifiex/sdio.c  |  5 ++
 drivers/net/wireless/marvell/mwifiex/sdio.h  | 70 ++++++++++++++++++++++++=
++++
 3 files changed, 76 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/Kconfig b/drivers/net/wir=
eless/marvell/mwifiex/Kconfig
index 279167d..524fd56 100644
--- a/drivers/net/wireless/marvell/mwifiex/Kconfig
+++ b/drivers/net/wireless/marvell/mwifiex/Kconfig
@@ -9,7 +9,7 @@ config MWIFIEX
 	  mwifiex.
=20
 config MWIFIEX_SDIO
-	tristate "Marvell WiFi-Ex Driver for SD8786/SD8787/SD8797/SD8887/SD8897/S=
D8997"
+	tristate "Marvell WiFi-Ex Driver for SD8786/SD8787/SD8797/SD8887/SD8897/S=
D8977/SD8997"
 	depends on MWIFIEX && MMC
 	select FW_LOADER
 	select WANT_DEV_COREDUMP
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wire=
less/marvell/mwifiex/sdio.c
index d49fbd5..a856483 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -489,6 +489,8 @@ static void mwifiex_sdio_coredump(struct device *dev)
 #define SDIO_DEVICE_ID_MARVELL_8887   (0x9135)
 /* Device ID for SD8801 */
 #define SDIO_DEVICE_ID_MARVELL_8801   (0x9139)
+/* Device ID for SD8977 */
+#define SDIO_DEVICE_ID_MARVELL_8977   (0x9145)
 /* Device ID for SD8997 */
 #define SDIO_DEVICE_ID_MARVELL_8997   (0x9141)
=20
@@ -507,6 +509,8 @@ static void mwifiex_sdio_coredump(struct device *dev)
 		.driver_data =3D (unsigned long)&mwifiex_sdio_sd8887},
 	{SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, SDIO_DEVICE_ID_MARVELL_8801),
 		.driver_data =3D (unsigned long)&mwifiex_sdio_sd8801},
+	{SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, SDIO_DEVICE_ID_MARVELL_8977),
+		.driver_data =3D (unsigned long)&mwifiex_sdio_sd8977},
 	{SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, SDIO_DEVICE_ID_MARVELL_8997),
 		.driver_data =3D (unsigned long)&mwifiex_sdio_sd8997},
 	{},
@@ -2726,4 +2730,5 @@ static void mwifiex_sdio_up_dev(struct mwifiex_adapte=
r *adapter)
 MODULE_FIRMWARE(SD8797_DEFAULT_FW_NAME);
 MODULE_FIRMWARE(SD8897_DEFAULT_FW_NAME);
 MODULE_FIRMWARE(SD8887_DEFAULT_FW_NAME);
+MODULE_FIRMWARE(SD8977_DEFAULT_FW_NAME);
 MODULE_FIRMWARE(SD8997_DEFAULT_FW_NAME);
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.h b/drivers/net/wire=
less/marvell/mwifiex/sdio.h
index dccf7fd..912de2c 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.h
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.h
@@ -36,6 +36,7 @@
 #define SD8897_DEFAULT_FW_NAME "mrvl/sd8897_uapsta.bin"
 #define SD8887_DEFAULT_FW_NAME "mrvl/sd8887_uapsta.bin"
 #define SD8801_DEFAULT_FW_NAME "mrvl/sd8801_uapsta.bin"
+#define SD8977_DEFAULT_FW_NAME "mrvl/sd8977_uapsta.bin"
 #define SD8997_DEFAULT_FW_NAME "mrvl/sd8997_uapsta.bin"
=20
 #define BLOCK_MODE	1
@@ -371,6 +372,59 @@ struct mwifiex_sdio_device {
 				 0x59, 0x5c, 0x5d},
 };
=20
+static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8977 =3D {
+	.start_rd_port =3D 0,
+	.start_wr_port =3D 0,
+	.base_0_reg =3D 0xF8,
+	.base_1_reg =3D 0xF9,
+	.poll_reg =3D 0x5C,
+	.host_int_enable =3D UP_LD_HOST_INT_MASK | DN_LD_HOST_INT_MASK |
+		CMD_PORT_UPLD_INT_MASK | CMD_PORT_DNLD_INT_MASK,
+	.host_int_rsr_reg =3D 0x4,
+	.host_int_status_reg =3D 0x0C,
+	.host_int_mask_reg =3D 0x08,
+	.status_reg_0 =3D 0xE8,
+	.status_reg_1 =3D 0xE9,
+	.sdio_int_mask =3D 0xff,
+	.data_port_mask =3D 0xffffffff,
+	.io_port_0_reg =3D 0xE4,
+	.io_port_1_reg =3D 0xE5,
+	.io_port_2_reg =3D 0xE6,
+	.max_mp_regs =3D 196,
+	.rd_bitmap_l =3D 0x10,
+	.rd_bitmap_u =3D 0x11,
+	.rd_bitmap_1l =3D 0x12,
+	.rd_bitmap_1u =3D 0x13,
+	.wr_bitmap_l =3D 0x14,
+	.wr_bitmap_u =3D 0x15,
+	.wr_bitmap_1l =3D 0x16,
+	.wr_bitmap_1u =3D 0x17,
+	.rd_len_p0_l =3D 0x18,
+	.rd_len_p0_u =3D 0x19,
+	.card_misc_cfg_reg =3D 0xd8,
+	.card_cfg_2_1_reg =3D 0xd9,
+	.cmd_rd_len_0 =3D 0xc0,
+	.cmd_rd_len_1 =3D 0xc1,
+	.cmd_rd_len_2 =3D 0xc2,
+	.cmd_rd_len_3 =3D 0xc3,
+	.cmd_cfg_0 =3D 0xc4,
+	.cmd_cfg_1 =3D 0xc5,
+	.cmd_cfg_2 =3D 0xc6,
+	.cmd_cfg_3 =3D 0xc7,
+	.fw_dump_host_ready =3D 0xcc,
+	.fw_dump_ctrl =3D 0xf0,
+	.fw_dump_start =3D 0xf1,
+	.fw_dump_end =3D 0xf8,
+	.func1_dump_reg_start =3D 0x10,
+	.func1_dump_reg_end =3D 0x17,
+	.func1_scratch_reg =3D 0xe8,
+	.func1_spec_reg_num =3D 13,
+	.func1_spec_reg_table =3D {0x08, 0x58, 0x5C, 0x5D,
+				 0x60, 0x61, 0x62, 0x64,
+				 0x65, 0x66, 0x68, 0x69,
+				 0x6a},
+};
+
 static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8997 =3D {
 	.start_rd_port =3D 0,
 	.start_wr_port =3D 0,
@@ -532,6 +586,22 @@ struct mwifiex_sdio_device {
 	.can_ext_scan =3D true,
 };
=20
+static const struct mwifiex_sdio_device mwifiex_sdio_sd8977 =3D {
+	.firmware =3D SD8977_DEFAULT_FW_NAME,
+	.reg =3D &mwifiex_reg_sd8977,
+	.max_ports =3D 32,
+	.mp_agg_pkt_limit =3D 16,
+	.tx_buf_size =3D MWIFIEX_TX_DATA_BUF_SIZE_4K,
+	.mp_tx_agg_buf_size =3D MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
+	.mp_rx_agg_buf_size =3D MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
+	.supports_sdio_new_mode =3D true,
+	.has_control_mask =3D false,
+	.can_dump_fw =3D true,
+	.fw_dump_enh =3D true,
+	.can_auto_tdls =3D false,
+	.can_ext_scan =3D true,
+};
+
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8997 =3D {
 	.firmware =3D SD8997_DEFAULT_FW_NAME,
 	.reg =3D &mwifiex_reg_sd8997,
--=20
1.9.1
