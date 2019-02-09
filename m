Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A426C282CB
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 07:12:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1292B20863
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 07:12:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="Yy4sjNJd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbfBIHM6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Feb 2019 02:12:58 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:26563 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbfBIHM5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Feb 2019 02:12:57 -0500
X-IronPort-AV: E=Sophos;i="5.56,564,1539673200"; 
   d="scan'208";a="27458354"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 09 Feb 2019 00:12:56 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.106) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sat, 9 Feb 2019 00:12:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z8MhQPc8vm0g4CPANdWIMHWrXZXEHa7pMooINnaLDTc=;
 b=Yy4sjNJdxbI5Z4IsW40u1RL5Wh/bUzyzPsWlyWgZbnxI1SiLH0ER9Cd37dTHykgkSNRIJGukNPMlucna6ODVxw+UTC3YnkdrTmYKQ15wfKGqql8A1itPDXDIOVsbC9vA1Xpwa4FtwIIwluck8wIUQYU69SzDjidEVyXNv0xSblo=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3077.namprd11.prod.outlook.com (20.177.226.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.22; Sat, 9 Feb 2019 07:12:54 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1601.016; Sat, 9 Feb 2019
 07:12:54 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <kvalo@codeaurora.org>,
        <johannes@sipsolutions.net>, <Adham.Abozaeid@microchip.com>,
        <Venkateswara.Kaja@microchip.com>, <Nicolas.Ferre@microchip.com>,
        <Claudiu.Beznea@microchip.com>, <Ajay.Kathat@microchip.com>
Subject: [PATCH 13/16] wilc1000: add wilc_wlan.h
Thread-Topic: [PATCH 13/16] wilc1000: add wilc_wlan.h
Thread-Index: AQHUwEbglBpA57CssE6I4jSFC+Ie2g==
Date:   Sat, 9 Feb 2019 07:12:54 +0000
Message-ID: <1549696298-9795-14-git-send-email-ajay.kathat@microchip.com>
References: <1549696298-9795-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1549696298-9795-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR0101CA0021.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::31) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [183.82.17.42]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3077;6:GBfS+sC4oDvJ41kuG3h0rLH0J/E1oD3JlJS3MomkAk0mxJkOev5xoj5yohJk/zJq25N+MoDot6aKTlDy1MBzWZHGyGnDY9eYbVEx3dlPOSmmeJsfldlLYMJH97JlNM08CAvNaOvZJ+qsRbgRVNSJrXQ6my7JnEksvy/UBMIonXWVrXvkRxqiD61mpzxEU7aOqRLiA1vUYYHbGdwFTdKDDN9S0l3vklmdJqd0p4L3UjgEwxhU2JLVbabO5gL+1hrgaGIZgKSl58iAm+jTvciZblmWr3QbSzf01YR4K76FoF9+s1BaaV4fglMxdZ5Vol37dz4OL4jUT4Sn1taNoLQ+qmB+T/zNhv4i22IbLxxWAxXdTkKQghouNQDtJ9aev1pf1UzhG8+UkiacalN9dW1RKpdznfvUR6lDaOxBw+dbjyFfTGGRa8N0V7X7UTFqup64/NjlKGtOZL+liB57CEeI0g==;5:NXeYKSONkar4ArbYkLnyFdoofzu8DzHLVwjNnDM3OCDk78wg57xaFUSLGFDadc50FHwvpRbSBhqNrWnsYhGSysvVw7YTcC3LLDOoubiyxKjTJQ1ruCPuCavAVP0lu84Mz6R9zl3R6EjzVPN88RAt+vUyrlgcesLP9OdvrVSvRr+qkH/LMVbB883XeWnlXYbqqIwgmpr1Pz17Je4Ux8ziXQ==;7:KuhM6BsTDsgodkwRieKyrWI7mL5RjtVtR+slcYC2+Q/hbMfACi7nAsvNImUEJK8K+7OTf6zCVNVQ/sziyzlq6imxIRoaQFcD3LYE6mIRrwnWzFx8cYlvVza7yNcxOZIRfjERc9UR/x//iu6kIoZeTw==
x-ms-office365-filtering-correlation-id: dc974d39-44e1-45db-42a3-08d68e5e028d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3077;
x-ms-traffictypediagnostic: BYAPR11MB3077:
x-microsoft-antispam-prvs: <BYAPR11MB3077D6E053F6A9DC211FAB68E36A0@BYAPR11MB3077.namprd11.prod.outlook.com>
x-forefront-prvs: 09435FCA72
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(396003)(39860400002)(136003)(366004)(199004)(189003)(81166006)(8676002)(81156014)(97736004)(386003)(6506007)(14454004)(99286004)(305945005)(486006)(72206003)(6916009)(53936002)(102836004)(478600001)(7736002)(8936002)(26005)(186003)(36756003)(50226002)(54906003)(256004)(2616005)(476003)(11346002)(446003)(14444005)(68736007)(105586002)(106356001)(5640700003)(2351001)(6116002)(3846002)(52116002)(316002)(6436002)(66066001)(30864003)(107886003)(25786009)(4326008)(2501003)(2906002)(76176011)(78486014)(6486002)(86362001)(71200400001)(71190400001)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3077;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ljgVJ79aT9FqLZ/iJuvCm1PatkS5BwYmMWcmFarhOTcVS0xV/wOhBOSdnfk5JxhjhbcMeTAFXHvLukYLmmNRDmzCj3pHFdXGxURpdNF0xnK9FmY5WaBV9jGYH/5rGz2IlFw+qszIo6fCcShsNsSK/7af04LGlvfAEQaNmPA/BjmLmJLlSVIGSGXWjEUIECjBXmZASsK+q4MmbNPY59YwZR4DWycj7ML9baC/SKharQ2gHLK3oHFj5VVG5rj+BjjTZhCSyR7P0PQII2XC/1UBsWtaYTKzB7M2HGpDgCalWT1THBpXQrvHqSGuf/ngbKIpwbflcBRjnLKdl6IARAQ5qtwHDnUOpdTSlNB0Txw+Ia9tW8ulTitSrBGR7RMSmVjESE8zBQ/FI4vN2R4rgY8TyEvO3aAQWgV9uhBNiFroJXk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: dc974d39-44e1-45db-42a3-08d68e5e028d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2019 07:12:50.7813
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3077
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Moved '/driver/staging/wilc1000/wilc_wlan.h' to
'drivers/net/wireless/microchip/wilc1000/'.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 .../net/wireless/microchip/wilc1000/wilc_wlan.h    | 313 +++++++++++++++++=
++++
 1 file changed, 313 insertions(+)
 create mode 100644 drivers/net/wireless/microchip/wilc1000/wilc_wlan.h

diff --git a/drivers/net/wireless/microchip/wilc1000/wilc_wlan.h b/drivers/=
net/wireless/microchip/wilc1000/wilc_wlan.h
new file mode 100644
index 0000000..1a27f62
--- /dev/null
+++ b/drivers/net/wireless/microchip/wilc1000/wilc_wlan.h
@@ -0,0 +1,313 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiari=
es.
+ * All rights reserved.
+ */
+
+#ifndef WILC_WLAN_H
+#define WILC_WLAN_H
+
+#include <linux/types.h>
+
+/********************************************
+ *
+ *      Mac eth header length
+ *
+ ********************************************/
+#define MAX_MAC_HDR_LEN			26 /* QOS_MAC_HDR_LEN */
+#define SUB_MSDU_HEADER_LENGTH		14
+#define SNAP_HDR_LEN			8
+#define ETHERNET_HDR_LEN		14
+#define WORD_ALIGNMENT_PAD		0
+
+#define ETH_ETHERNET_HDR_OFFSET		(MAX_MAC_HDR_LEN + \
+					 SUB_MSDU_HEADER_LENGTH + \
+					 SNAP_HDR_LEN - \
+					 ETHERNET_HDR_LEN + \
+					 WORD_ALIGNMENT_PAD)
+
+#define HOST_HDR_OFFSET			4
+#define ETHERNET_HDR_LEN		14
+#define IP_HDR_LEN			20
+#define IP_HDR_OFFSET			ETHERNET_HDR_LEN
+#define UDP_HDR_OFFSET			(IP_HDR_LEN + IP_HDR_OFFSET)
+#define UDP_HDR_LEN			8
+#define UDP_DATA_OFFSET			(UDP_HDR_OFFSET + UDP_HDR_LEN)
+#define ETH_CONFIG_PKT_HDR_LEN		UDP_DATA_OFFSET
+
+#define ETH_CONFIG_PKT_HDR_OFFSET	(ETH_ETHERNET_HDR_OFFSET + \
+					 ETH_CONFIG_PKT_HDR_LEN)
+
+/********************************************
+ *
+ *      Register Defines
+ *
+ ********************************************/
+#define WILC_PERIPH_REG_BASE		0x1000
+#define WILC_CHANGING_VIR_IF		0x108c
+#define WILC_CHIPID			WILC_PERIPH_REG_BASE
+#define WILC_GLB_RESET_0		(WILC_PERIPH_REG_BASE + 0x400)
+#define WILC_PIN_MUX_0			(WILC_PERIPH_REG_BASE + 0x408)
+#define WILC_HOST_TX_CTRL		(WILC_PERIPH_REG_BASE + 0x6c)
+#define WILC_HOST_RX_CTRL_0		(WILC_PERIPH_REG_BASE + 0x70)
+#define WILC_HOST_RX_CTRL_1		(WILC_PERIPH_REG_BASE + 0x74)
+#define WILC_HOST_VMM_CTL		(WILC_PERIPH_REG_BASE + 0x78)
+#define WILC_HOST_RX_CTRL		(WILC_PERIPH_REG_BASE + 0x80)
+#define WILC_HOST_RX_EXTRA_SIZE		(WILC_PERIPH_REG_BASE + 0x84)
+#define WILC_HOST_TX_CTRL_1		(WILC_PERIPH_REG_BASE + 0x88)
+#define WILC_MISC			(WILC_PERIPH_REG_BASE + 0x428)
+#define WILC_INTR_REG_BASE		(WILC_PERIPH_REG_BASE + 0xa00)
+#define WILC_INTR_ENABLE		WILC_INTR_REG_BASE
+#define WILC_INTR2_ENABLE		(WILC_INTR_REG_BASE + 4)
+
+#define WILC_INTR_POLARITY		(WILC_INTR_REG_BASE + 0x10)
+#define WILC_INTR_TYPE			(WILC_INTR_REG_BASE + 0x20)
+#define WILC_INTR_CLEAR			(WILC_INTR_REG_BASE + 0x30)
+#define WILC_INTR_STATUS		(WILC_INTR_REG_BASE + 0x40)
+
+#define WILC_VMM_TBL_SIZE		64
+#define WILC_VMM_TX_TBL_BASE		0x150400
+#define WILC_VMM_RX_TBL_BASE		0x150500
+
+#define WILC_VMM_BASE			0x150000
+#define WILC_VMM_CORE_CTL		WILC_VMM_BASE
+#define WILC_VMM_TBL_CTL		(WILC_VMM_BASE + 0x4)
+#define WILC_VMM_TBL_ENTRY		(WILC_VMM_BASE + 0x8)
+#define WILC_VMM_TBL0_SIZE		(WILC_VMM_BASE + 0xc)
+#define WILC_VMM_TO_HOST_SIZE		(WILC_VMM_BASE + 0x10)
+#define WILC_VMM_CORE_CFG		(WILC_VMM_BASE + 0x14)
+#define WILC_VMM_TBL_ACTIVE		(WILC_VMM_BASE + 040)
+#define WILC_VMM_TBL_STATUS		(WILC_VMM_BASE + 0x44)
+
+#define WILC_SPI_REG_BASE		0xe800
+#define WILC_SPI_CTL			WILC_SPI_REG_BASE
+#define WILC_SPI_MASTER_DMA_ADDR	(WILC_SPI_REG_BASE + 0x4)
+#define WILC_SPI_MASTER_DMA_COUNT	(WILC_SPI_REG_BASE + 0x8)
+#define WILC_SPI_SLAVE_DMA_ADDR		(WILC_SPI_REG_BASE + 0xc)
+#define WILC_SPI_SLAVE_DMA_COUNT	(WILC_SPI_REG_BASE + 0x10)
+#define WILC_SPI_TX_MODE		(WILC_SPI_REG_BASE + 0x20)
+#define WILC_SPI_PROTOCOL_CONFIG	(WILC_SPI_REG_BASE + 0x24)
+#define WILC_SPI_INTR_CTL		(WILC_SPI_REG_BASE + 0x2c)
+
+#define WILC_SPI_PROTOCOL_OFFSET	(WILC_SPI_PROTOCOL_CONFIG - \
+					 WILC_SPI_REG_BASE)
+
+#define WILC_AHB_DATA_MEM_BASE		0x30000
+#define WILC_AHB_SHARE_MEM_BASE		0xd0000
+
+#define WILC_VMM_TBL_RX_SHADOW_BASE	WILC_AHB_SHARE_MEM_BASE
+#define WILC_VMM_TBL_RX_SHADOW_SIZE	256
+
+#define WILC_GP_REG_0			0x149c
+#define WILC_GP_REG_1			0x14a0
+
+#define WILC_HAVE_SDIO_IRQ_GPIO		BIT(0)
+#define WILC_HAVE_USE_PMU		BIT(1)
+#define WILC_HAVE_SLEEP_CLK_SRC_RTC	BIT(2)
+#define WILC_HAVE_SLEEP_CLK_SRC_XO	BIT(3)
+#define WILC_HAVE_EXT_PA_INV_TX_RX	BIT(4)
+#define WILC_HAVE_LEGACY_RF_SETTINGS	BIT(5)
+#define WILC_HAVE_XTAL_24		BIT(6)
+#define WILC_HAVE_DISABLE_WILC_UART	BIT(7)
+#define WILC_HAVE_USE_IRQ_AS_HOST_WAKE	BIT(8)
+
+/********************************************
+ *
+ *      Wlan Defines
+ *
+ ********************************************/
+#define WILC_CFG_PKT		1
+#define WILC_NET_PKT		0
+#define WILC_MGMT_PKT		2
+
+#define WILC_CFG_SET		1
+#define WILC_CFG_QUERY		0
+
+#define WILC_CFG_RSP		1
+#define WILC_CFG_RSP_STATUS	2
+#define WILC_CFG_RSP_SCAN	3
+
+#define WILC_PLL_TO_SDIO	4
+#define WILC_PLL_TO_SPI		2
+#define ABORT_INT		BIT(31)
+
+#define WILC_RX_BUFF_SIZE	(96 * 1024)
+#define WILC_TX_BUFF_SIZE	(64 * 1024)
+
+#define MODALIAS		"WILC_SPI"
+#define GPIO_NUM		0x44
+/*******************************************/
+/*        E0 and later Interrupt flags.    */
+/*******************************************/
+/*******************************************/
+/*        E0 and later Interrupt flags.    */
+/*           IRQ Status word               */
+/* 15:0 =3D DMA count in words.              */
+/* 16: INT0 flag                           */
+/* 17: INT1 flag                           */
+/* 18: INT2 flag                           */
+/* 19: INT3 flag                           */
+/* 20: INT4 flag                           */
+/* 21: INT5 flag                           */
+/*******************************************/
+#define IRG_FLAGS_OFFSET	16
+#define IRQ_DMA_WD_CNT_MASK	((1ul << IRG_FLAGS_OFFSET) - 1)
+#define INT_0			BIT(IRG_FLAGS_OFFSET)
+#define INT_1			BIT(IRG_FLAGS_OFFSET + 1)
+#define INT_2			BIT(IRG_FLAGS_OFFSET + 2)
+#define INT_3			BIT(IRG_FLAGS_OFFSET + 3)
+#define INT_4			BIT(IRG_FLAGS_OFFSET + 4)
+#define INT_5			BIT(IRG_FLAGS_OFFSET + 5)
+#define MAX_NUM_INT		6
+
+/*******************************************/
+/*        E0 and later Interrupt flags.    */
+/*           IRQ Clear word                */
+/* 0: Clear INT0                           */
+/* 1: Clear INT1                           */
+/* 2: Clear INT2                           */
+/* 3: Clear INT3                           */
+/* 4: Clear INT4                           */
+/* 5: Clear INT5                           */
+/* 6: Select VMM table 1                   */
+/* 7: Select VMM table 2                   */
+/* 8: Enable VMM                           */
+/*******************************************/
+#define CLR_INT0		BIT(0)
+#define CLR_INT1		BIT(1)
+#define CLR_INT2		BIT(2)
+#define CLR_INT3		BIT(3)
+#define CLR_INT4		BIT(4)
+#define CLR_INT5		BIT(5)
+#define SEL_VMM_TBL0		BIT(6)
+#define SEL_VMM_TBL1		BIT(7)
+#define EN_VMM			BIT(8)
+
+#define DATA_INT_EXT		INT_0
+#define PLL_INT_EXT		INT_1
+#define SLEEP_INT_EXT		INT_2
+#define ALL_INT_EXT		(DATA_INT_EXT | PLL_INT_EXT | SLEEP_INT_EXT)
+#define NUM_INT_EXT		3
+
+#define DATA_INT_CLR		CLR_INT0
+#define PLL_INT_CLR		CLR_INT1
+#define SLEEP_INT_CLR		CLR_INT2
+
+#define ENABLE_RX_VMM		(SEL_VMM_TBL1 | EN_VMM)
+#define ENABLE_TX_VMM		(SEL_VMM_TBL0 | EN_VMM)
+/*time for expiring the completion of cfg packets*/
+#define WILC_CFG_PKTS_TIMEOUT	msecs_to_jiffies(2000)
+
+#define IS_MANAGMEMENT		0x100
+#define IS_MANAGMEMENT_CALLBACK	0x080
+#define IS_MGMT_STATUS_SUCCES	0x040
+
+/********************************************
+ *
+ *      Tx/Rx Queue Structure
+ *
+ ********************************************/
+
+struct txq_entry_t {
+	struct list_head list;
+	int type;
+	int ack_idx;
+	u8 *buffer;
+	int buffer_size;
+	void *priv;
+	int status;
+	void (*tx_complete_func)(void *priv, int status);
+};
+
+struct rxq_entry_t {
+	struct list_head list;
+	u8 *buffer;
+	int buffer_size;
+};
+
+/********************************************
+ *
+ *      Host IF Structure
+ *
+ ********************************************/
+struct wilc;
+struct wilc_hif_func {
+	int (*hif_init)(struct wilc *wilc, bool resume);
+	int (*hif_deinit)(struct wilc *wilc);
+	int (*hif_read_reg)(struct wilc *wilc, u32 addr, u32 *data);
+	int (*hif_write_reg)(struct wilc *wilc, u32 addr, u32 data);
+	int (*hif_block_rx)(struct wilc *wilc, u32 addr, u8 *buf, u32 size);
+	int (*hif_block_tx)(struct wilc *wilc, u32 addr, u8 *buf, u32 size);
+	int (*hif_read_int)(struct wilc *wilc, u32 *int_status);
+	int (*hif_clear_int_ext)(struct wilc *wilc, u32 val);
+	int (*hif_read_size)(struct wilc *wilc, u32 *size);
+	int (*hif_block_tx_ext)(struct wilc *wilc, u32 addr, u8 *buf, u32 size);
+	int (*hif_block_rx_ext)(struct wilc *wilc, u32 addr, u8 *buf, u32 size);
+	int (*hif_sync_ext)(struct wilc *wilc, int nint);
+	int (*enable_interrupt)(struct wilc *nic);
+	void (*disable_interrupt)(struct wilc *nic);
+};
+
+#define WILC_MAX_CFG_FRAME_SIZE		1468
+
+struct tx_complete_data {
+	int size;
+	void *buff;
+	u8 *bssid;
+	struct sk_buff *skb;
+};
+
+struct wilc_cfg_cmd_hdr {
+	u8 cmd_type;
+	u8 seq_no;
+	__le16 total_len;
+	__le32 driver_handler;
+};
+
+struct wilc_cfg_frame {
+	struct wilc_cfg_cmd_hdr hdr;
+	u8 frame[WILC_MAX_CFG_FRAME_SIZE];
+};
+
+struct wilc_cfg_rsp {
+	u8 type;
+	u8 seq_no;
+};
+
+struct wilc;
+struct wilc_vif;
+
+int wilc_wlan_firmware_download(struct wilc *wilc, const u8 *buffer,
+				u32 buffer_size);
+int wilc_wlan_start(struct wilc *wilc);
+int wilc_wlan_stop(struct wilc *wilc);
+int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buff=
er,
+			      u32 buffer_size,
+			      void (*tx_complete_fn)(void *, int));
+int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count);
+void wilc_handle_isr(struct wilc *wilc);
+void wilc_wlan_cleanup(struct net_device *dev);
+int wilc_wlan_cfg_set(struct wilc_vif *vif, int start, u16 wid, u8 *buffer=
,
+		      u32 buffer_size, int commit, u32 drv_handler);
+int wilc_wlan_cfg_get(struct wilc_vif *vif, int start, u16 wid, int commit=
,
+		      u32 drv_handler);
+int wilc_wlan_cfg_get_val(struct wilc *wl, u16 wid, u8 *buffer,
+			  u32 buffer_size);
+int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buf=
fer,
+			       u32 buffer_size, void (*func)(void *, int));
+void wilc_chip_sleep_manually(struct wilc *wilc);
+
+void wilc_enable_tcp_ack_filter(struct wilc_vif *vif, bool value);
+int wilc_wlan_get_num_conn_ifcs(struct wilc *wilc);
+netdev_tx_t wilc_mac_xmit(struct sk_buff *skb, struct net_device *dev);
+
+void wilc_wfi_p2p_rx(struct net_device *dev, u8 *buff, u32 size);
+void host_wakeup_notify(struct wilc *wilc);
+void host_sleep_notify(struct wilc *wilc);
+void chip_allow_sleep(struct wilc *wilc);
+void chip_wakeup(struct wilc *wilc);
+int wilc_send_config_pkt(struct wilc_vif *vif, u8 mode, struct wid *wids,
+			 u32 count, u32 drv);
+int wilc_wlan_init(struct net_device *dev);
+u32 wilc_get_chipid(struct wilc *wilc, bool update);
+#endif
--=20
2.7.4

