Return-Path: <SRS0=9BuQ=PR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED3EEC43387
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 14:46:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3B50206BA
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 14:46:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="m8NpFcGH";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="iIRgA5Ok"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731903AbfAIOqV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Jan 2019 09:46:21 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:33766 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731901AbfAIOqU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Jan 2019 09:46:20 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x09EeAbk020902
        for <linux-wireless@vger.kernel.org>; Wed, 9 Jan 2019 06:46:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0818; bh=aF/Q/b9hwdcYzjU9PbnEYOo5k8D03pa90k5nmbQJhVM=;
 b=m8NpFcGH2yiOJ2DF0HK7aIJOyvxl/GeIlcqOWWazkImzZusHKVl7rIdrjmI2g98wrQdC
 wagrnGkNyj2xW45nwGS9PC+JoRLeekYT1iBtdJbaBBkJgL/HOFF6CMYNBhtfXPWQhkXu
 h8TGq4zsB4pFHlX6MIzkckSerKlVWpHo4GWB5KXsW4PEbLBrF+RrmdwxtEsSJuj5p4Cl
 2bYZFKEU0feBjTPG+GzKtiMl/54o990C083EP5x2zimPkwjq8stS9nmTJvWY2QfjXtyQ
 Tms9+PtqyN0tMWaDxR65+leQNhbTUszaLq4hqKnWC/q3n+zqc2fbHQnLeH4yCrwRBi1U wQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2pw18fc531-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jan 2019 06:46:18 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 9 Jan
 2019 06:46:16 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.59) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 9 Jan 2019 06:46:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aF/Q/b9hwdcYzjU9PbnEYOo5k8D03pa90k5nmbQJhVM=;
 b=iIRgA5OkeAupYOjxaKnJ4CCeSBuuzWRgVqy5WtFCegATVygnfmwudSzV1DBCF3wFUfSny+r4+Qtncr12Gi6AUltHUiD3Vc3GhcWbH8Z8/YhhrvmwRvm0EtXCReA7FtAMz+uqV8MhxtMzpaJTXBVIB0T7MDEzlPJ0LxY1E9dGKwU=
Received: from CY4PR18MB1237.namprd18.prod.outlook.com (10.172.176.7) by
 CY4PR18MB0918.namprd18.prod.outlook.com (10.173.182.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1516.14; Wed, 9 Jan 2019 14:46:11 +0000
Received: from CY4PR18MB1237.namprd18.prod.outlook.com
 ([fe80::95d4:8a68:81d7:87c5]) by CY4PR18MB1237.namprd18.prod.outlook.com
 ([fe80::95d4:8a68:81d7:87c5%8]) with mapi id 15.20.1495.011; Wed, 9 Jan 2019
 14:46:09 +0000
From:   Ganapathi Bhat <gbhat@marvell.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Cathy Luo <cluo@marvell.com>, Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Rakesh Parmar <rakeshp@marvell.com>,
        Hemantkumar Suthar <shemant@marvell.com>
Subject: [PATCH v2] mwifiex: add support for sd8977 chipset
Thread-Topic: [PATCH v2] mwifiex: add support for sd8977 chipset
Thread-Index: AdSoKeBMXl0ndSmBTC+txF8evGoR5g==
Date:   Wed, 9 Jan 2019 14:46:09 +0000
Message-ID: <CY4PR18MB1237AEF3375B348254E0298FA08B0@CY4PR18MB1237.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [182.72.17.59]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;CY4PR18MB0918;20:VZ058fjaJEuQuJThKYTComNryRtrbYF7bJsLSDHh78UfpOdrNopmVLaq+FSlBo9zDZ5b5hijZMIf8HTXPjr1RiOgIGxwl2lj3AYrw+2vHogj6d8ECmgrACZsLrSbt2PPUAhM94oexn8L7rzwF5N1XouadGXp9RypZ45cwGtWfrQ=
x-ms-exchange-antispam-srfa-diagnostics: SOS;SOR;
x-forefront-antispam-report: SFV:SKI;SCL:-1;SFV:NSPM;SFS:(10009020)(366004)(396003)(136003)(346002)(376002)(39860400002)(199004)(189003)(2906002)(68736007)(74316002)(7696005)(6436002)(575784001)(86362001)(5640700003)(5660300001)(102836004)(4326008)(99286004)(106356001)(105586002)(78486014)(26005)(33656002)(6506007)(486006)(55236004)(256004)(107886003)(53936002)(14444005)(55016002)(66066001)(476003)(25786009)(2501003)(186003)(9686003)(97736004)(54906003)(316002)(81156014)(81166006)(305945005)(478600001)(6116002)(8676002)(71190400001)(7736002)(2351001)(71200400001)(6916009)(8936002)(3846002)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR18MB0918;H:CY4PR18MB1237.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-office365-filtering-correlation-id: 2046a264-af86-4d39-9da5-08d6764131a4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:CY4PR18MB0918;
x-ms-traffictypediagnostic: CY4PR18MB0918:
x-microsoft-antispam-prvs: <CY4PR18MB091871A1744C7704EF3A1C97A08B0@CY4PR18MB0918.namprd18.prod.outlook.com>
x-forefront-prvs: 0912297777
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +wUTH/VV7uE/0VGZY/qVCP9+C87kGS8bEMNQFJYz1kuzJMr0HQtRPr39ycmGbR4Zl5idlFL7/HwLtqg3STtgU0NiksCGfXzyJtQbnMHw6TlzjmSrQUUdseB7eN5yCSsHaNrXvS3y9yWIDBohno2BOZH/jhS1gDHBcFWvxobB/PWToti/PtXKR6FwES3p4Szw4LhuLvlxUsEpsCaGNWTsV7FeK9Gr7TvdC5qwBUr/WQRxejYeih2Ga1gQKbLwbomw/2aR5M3/6rakVyGTH6p1yKR9lC6Y87qW0FDwFFGKmyPj2q/pq35G6MZE8VxjAKT9
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2046a264-af86-4d39-9da5-08d6764131a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2019 14:46:09.6233
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR18MB0918
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-01-09_07:,,
 signatures=0
X-Proofpoint-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=868 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1901090124
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From a0f96e630eb5b74b047149e23c161a9f06fb2cc5 Mon Sep 17 00:00:00 2001
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
