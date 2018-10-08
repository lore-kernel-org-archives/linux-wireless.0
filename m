Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F17FBC64EB8
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 09:56:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A13652086D
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 09:56:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="HdJSqriq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A13652086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbeJHRG7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 13:06:59 -0400
Received: from mail-sn1nam02on0089.outbound.protection.outlook.com ([104.47.36.89]:36736
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726354AbeJHRG6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 13:06:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jfLwliZJEh0tWF1aqPvO+XTpRnd9wZctwYZ2BHwJlrY=;
 b=HdJSqriqKyrXeyP8+OwtcdcqEXM2xZlh7UFIyFwCWQke6RoGvrfW1xAU+KKIV4FrqlZVRHIq1PHFmkg3k4f/XLmgVsim1laz3bhTHQYnIxgDtGMzTmqUSFezKoL/NRkbkiBPGKO0aLCOjgbfO7AghRof1djx9q+6SMt95AqAtb4=
Received: from BL0PR05MB4595.namprd05.prod.outlook.com (20.177.144.212) by
 BL0PR05MB4642.namprd05.prod.outlook.com (20.177.144.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.16; Mon, 8 Oct 2018 09:56:03 +0000
Received: from BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::e4b8:995b:1c73:657a]) by BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::e4b8:995b:1c73:657a%3]) with mapi id 15.20.1228.020; Mon, 8 Oct 2018
 09:56:03 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 3/5] qtnfmac_pcie: cleanup Pearl platform headers
Thread-Topic: [PATCH 3/5] qtnfmac_pcie: cleanup Pearl platform headers
Thread-Index: AQHUXu0fr57VSPaQ7EajRj2I+n3yuw==
Date:   Mon, 8 Oct 2018 09:56:03 +0000
Message-ID: <20181008095551.18651-4-sergey.matyukevich.os@quantenna.com>
References: <20181008095551.18651-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20181008095551.18651-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR02CA0023.eurprd02.prod.outlook.com
 (2603:10a6:20b:6e::36) To BL0PR05MB4595.namprd05.prod.outlook.com
 (2603:10b6:208:5f::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB4642;6:kdaIn5+tMY+UWl7RbUKj8DLeT4gAvgvqD6SDbPpaKTWScOASNBzehUAc9114u10kT30itr79dx2WEekEiP+V1133TqE3yBKGeK2iO7y653oJKjT2/2XhtFRT8gyoBKvzGYClF6zNQod8lm4aq2a0Yyx1DxoVnLEkgey+6WzjX4olDxhuusrgWzWVfXS5etgYXGRHvvRA2cFGdHrRtmb7wO3QhGF8lY9Nqa1fSz1I2qBmWA20kbSDHkoO0d54Ry4uj/+R9pij2qkBlbtbG1CHRvaTaWnudeKigiaKQS/if9CjZcyougjpf/HxNx+vA6y0BINtNHIr0wWBqxde0EdreWSP9eaKtx7ubziqdSURbbqHL9EwkB5lHs0twV4I+UjAwsW27NOiBhQGtpnFhC4fQOK7QGSfqHRdU6+MZsSlCUvZxXL1CUIOYHC31hr1VAeSTMXjDc696i0twsuYHoo5nA==;5:czVCyrxIUjmghfZasPNlEmjRX+EkP629dkXWunmlaUkpsT9RzM1xhT1GrmvBZefHGdr6kHmyil2fyAYFGSoz7UO4KlhSMcWNP0rU1QtbwcPo+loU2u212bz2TLbjg9lHEPlQEGt+1P91xrAa/alPCT8Ch7zK0MozMZByNUBkB6I=;7:qmue9uqzYrwsVJmnm8Lr8Y52Yz92fzxjl3ItaJ/ZNfNlWyBTiBrQhzTxKfHQJmpKFLiFutjgOOZbPRNmkuHM+pl6HVY4IgM5UCrnoctk9gCessa94FcERaSIGwotDBWWdTc2EMLUth6LTI415ug2xWa/pl8qQVRlJEl6BS27qiioE+gnOIQBGjQZxDHwIK2pFxVnJHzWNhfY+1MlLITsuL/L1yJP0W3yV7i+nevsV5ylIyT6/qmjlWHreIEB/48g
x-ms-office365-filtering-correlation-id: cceb2ed3-135a-48fb-5bd8-08d62d04420a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB4642;
x-ms-traffictypediagnostic: BL0PR05MB4642:
x-microsoft-antispam-prvs: <BL0PR05MB4642EB29494A2B2F0E0B8394A3E60@BL0PR05MB4642.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231355)(944501410)(52105095)(10201501046)(3002001)(93006095)(93001095)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123558120)(20161123564045)(20161123560045)(201708071742011)(7699051);SRVR:BL0PR05MB4642;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB4642;
x-forefront-prvs: 081904387B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39840400004)(396003)(346002)(366004)(376002)(189003)(199004)(105586002)(486006)(68736007)(2351001)(5250100002)(386003)(316002)(2501003)(446003)(2616005)(5660300001)(6916009)(103116003)(186003)(14454004)(14444005)(53936002)(575784001)(102836004)(11346002)(3846002)(256004)(305945005)(7736002)(2900100001)(8936002)(106356001)(107886003)(26005)(1076002)(6436002)(54906003)(76176011)(478600001)(6116002)(6486002)(81156014)(25786009)(99286004)(8676002)(81166006)(476003)(52116002)(5640700003)(6506007)(71200400001)(6512007)(71190400001)(2906002)(4744004)(66066001)(4326008)(86362001)(36756003)(97736004);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB4642;H:BL0PR05MB4595.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 3Gaf9ee6Iud1WD+fGJX+hzxlSw07BmWC//8pGdYEWTl+EIhzDRU1TDlf9kcPgnapt/dGmQ3msEWJfPdYan9izhRl3L9bfMdS8pHVbHOOqrGRvyprci62Y/LTiI60yibbmmfPIxrUD3z5BV9OndnLQQjTJloyxWs0NSvzcTyjL2AYWlVeZOJwsMzKNLQK83MqdSWaY3qlqSggSQ1sThBbZNLm11fPpTyMT3xGcsBjJCGu3TB6lL29KG4wE4njf5Me/rIoHsOqQVDBfx8c3n5SWBa4Hwj62Cf7dMVnx21tRBNbA5OjsGuGSLy8NSSKA6TmMizZUdPaj80mg40HdyT5kJKfJudtUYZK+FNUK+Uec+U=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cceb2ed3-135a-48fb-5bd8-08d62d04420a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2018 09:56:03.3879
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB4642
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove redundant information from Pearl platform headers.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 .../quantenna/qtnfmac/pcie/pearl_pcie_ipc.h        |   5 -
 .../quantenna/qtnfmac/pcie/pearl_pcie_regs.h       | 228 +----------------=
----
 2 files changed, 3 insertions(+), 230 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h b=
/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h
index 7ecaa69fe018..634480fe6a64 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h
@@ -72,11 +72,6 @@
=20
 #define QTN_EP_LHOST_TQE_PORT	4
=20
-enum qtnf_pcie_bda_ipc_flags {
-	QTN_PCIE_IPC_FLAG_HBM_MAGIC	=3D BIT(0),
-	QTN_PCIE_IPC_FLAG_SHM_PIO	=3D BIT(1),
-};
-
 enum qtnf_fw_loadtype {
 	QTN_FW_DBEGIN,
 	QTN_FW_DSUB,
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_regs.h =
b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_regs.h
index 1e6693c17006..6e9a5c61d46f 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_regs.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_regs.h
@@ -4,12 +4,7 @@
 #ifndef __PEARL_PCIE_H
 #define __PEARL_PCIE_H
=20
-#define	PCIE_GEN2_BASE				(0xe9000000)
-#define	PCIE_GEN3_BASE				(0xe7000000)
-
-#define PEARL_CUR_PCIE_BASE			(PCIE_GEN2_BASE)
-#define PCIE_HDP_OFFSET				(0x2000)
-
+/* Pearl PCIe HDP registers */
 #define PCIE_HDP_CTRL(base)			((base) + 0x2c00)
 #define PCIE_HDP_AXI_CTRL(base)			((base) + 0x2c04)
 #define PCIE_HDP_HOST_WR_DESC0(base)		((base) + 0x2c10)
@@ -73,7 +68,7 @@
 #define PCIE_HDP_TX_HOST_Q_RD_PTR(base)		((base) + 0x2d3c)
 #define PCIE_HDP_TX_HOST_Q_STS(base)		((base) + 0x2d40)
=20
-/* Host HBM pool registers */
+/* Pearl PCIe HBM pool registers */
 #define PCIE_HHBM_CSR_REG(base)			((base) + 0x2e00)
 #define PCIE_HHBM_Q_BASE_REG(base)		((base) + 0x2e04)
 #define PCIE_HHBM_Q_LIMIT_REG(base)		((base) + 0x2e08)
@@ -91,230 +86,13 @@
 #define HBM_INT_STATUS(base)			((base) + 0x2f9c)
 #define PCIE_HHBM_POOL_CNFIG(base)		((base) + 0x2f9c)
=20
-/* host HBM bit field definition */
+/* Pearl PCIe HBM bit field definitions */
 #define HHBM_CONFIG_SOFT_RESET			(BIT(8))
 #define HHBM_WR_REQ				(BIT(0))
 #define HHBM_RD_REQ				(BIT(1))
 #define HHBM_DONE				(BIT(31))
 #define HHBM_64BIT				(BIT(10))
=20
-/* offsets for dual PCIE */
-#define PCIE_PORT_LINK_CTL(base)		((base) + 0x0710)
-#define PCIE_GEN2_CTL(base)			((base) + 0x080C)
-#define PCIE_GEN3_OFF(base)			((base) + 0x0890)
-#define PCIE_ATU_CTRL1(base)			((base) + 0x0904)
-#define PCIE_ATU_CTRL2(base)			((base) + 0x0908)
-#define PCIE_ATU_BASE_LOW(base)			((base) + 0x090C)
-#define PCIE_ATU_BASE_HIGH(base)		((base) + 0x0910)
-#define PCIE_ATU_BASE_LIMIT(base)		((base) + 0x0914)
-#define PCIE_ATU_TGT_LOW(base)			((base) + 0x0918)
-#define PCIE_ATU_TGT_HIGH(base)			((base) + 0x091C)
-#define PCIE_DMA_WR_ENABLE(base)		((base) + 0x097C)
-#define PCIE_DMA_WR_CHWTLOW(base)		((base) + 0x0988)
-#define PCIE_DMA_WR_CHWTHIG(base)		((base) + 0x098C)
-#define PCIE_DMA_WR_INTSTS(base)		((base) + 0x09BC)
-#define PCIE_DMA_WR_INTMASK(base)		((base) + 0x09C4)
-#define PCIE_DMA_WR_INTCLER(base)		((base) + 0x09C8)
-#define PCIE_DMA_WR_DONE_IMWR_ADDR_L(base)	((base) + 0x09D0)
-#define PCIE_DMA_WR_DONE_IMWR_ADDR_H(base)	((base) + 0x09D4)
-#define PCIE_DMA_WR_ABORT_IMWR_ADDR_L(base)	((base) + 0x09D8)
-#define PCIE_DMA_WR_ABORT_IMWR_ADDR_H(base)	((base) + 0x09DC)
-#define PCIE_DMA_WR_IMWR_DATA(base)		((base) + 0x09E0)
-#define PCIE_DMA_WR_LL_ERR_EN(base)		((base) + 0x0A00)
-#define PCIE_DMA_WR_DOORBELL(base)		((base) + 0x0980)
-#define PCIE_DMA_RD_ENABLE(base)		((base) + 0x099C)
-#define PCIE_DMA_RD_DOORBELL(base)		((base) + 0x09A0)
-#define PCIE_DMA_RD_CHWTLOW(base)		((base) + 0x09A8)
-#define PCIE_DMA_RD_CHWTHIG(base)		((base) + 0x09AC)
-#define PCIE_DMA_RD_INTSTS(base)		((base) + 0x0A10)
-#define PCIE_DMA_RD_INTMASK(base)		((base) + 0x0A18)
-#define PCIE_DMA_RD_INTCLER(base)		((base) + 0x0A1C)
-#define PCIE_DMA_RD_ERR_STS_L(base)		((base) + 0x0A24)
-#define PCIE_DMA_RD_ERR_STS_H(base)		((base) + 0x0A28)
-#define PCIE_DMA_RD_LL_ERR_EN(base)		((base) + 0x0A34)
-#define PCIE_DMA_RD_DONE_IMWR_ADDR_L(base)	((base) + 0x0A3C)
-#define PCIE_DMA_RD_DONE_IMWR_ADDR_H(base)	((base) + 0x0A40)
-#define PCIE_DMA_RD_ABORT_IMWR_ADDR_L(base)	((base) + 0x0A44)
-#define PCIE_DMA_RD_ABORT_IMWR_ADDR_H(base)	((base) + 0x0A48)
-#define PCIE_DMA_RD_IMWR_DATA(base)		((base) + 0x0A4C)
-#define PCIE_DMA_CHNL_CONTEXT(base)		((base) + 0x0A6C)
-#define PCIE_DMA_CHNL_CNTRL(base)		((base) + 0x0A70)
-#define PCIE_DMA_XFR_SIZE(base)			((base) + 0x0A78)
-#define PCIE_DMA_SAR_LOW(base)			((base) + 0x0A7C)
-#define PCIE_DMA_SAR_HIGH(base)			((base) + 0x0A80)
-#define PCIE_DMA_DAR_LOW(base)			((base) + 0x0A84)
-#define PCIE_DMA_DAR_HIGH(base)			((base) + 0x0A88)
-#define PCIE_DMA_LLPTR_LOW(base)		((base) + 0x0A8C)
-#define PCIE_DMA_LLPTR_HIGH(base)		((base) + 0x0A90)
-#define PCIE_DMA_WRLL_ERR_ENB(base)		((base) + 0x0A00)
-#define PCIE_DMA_RDLL_ERR_ENB(base)		((base) + 0x0A34)
-#define PCIE_DMABD_CHNL_CNTRL(base)		((base) + 0x8000)
-#define PCIE_DMABD_XFR_SIZE(base)		((base) + 0x8004)
-#define PCIE_DMABD_SAR_LOW(base)		((base) + 0x8008)
-#define PCIE_DMABD_SAR_HIGH(base)		((base) + 0x800c)
-#define PCIE_DMABD_DAR_LOW(base)		((base) + 0x8010)
-#define PCIE_DMABD_DAR_HIGH(base)		((base) + 0x8014)
-#define PCIE_DMABD_LLPTR_LOW(base)		((base) + 0x8018)
-#define PCIE_DMABD_LLPTR_HIGH(base)		((base) + 0x801c)
-#define PCIE_WRDMA0_CHNL_CNTRL(base)		((base) + 0x8000)
-#define PCIE_WRDMA0_XFR_SIZE(base)		((base) + 0x8004)
-#define PCIE_WRDMA0_SAR_LOW(base)		((base) + 0x8008)
-#define PCIE_WRDMA0_SAR_HIGH(base)		((base) + 0x800c)
-#define PCIE_WRDMA0_DAR_LOW(base)		((base) + 0x8010)
-#define PCIE_WRDMA0_DAR_HIGH(base)		((base) + 0x8014)
-#define PCIE_WRDMA0_LLPTR_LOW(base)		((base) + 0x8018)
-#define PCIE_WRDMA0_LLPTR_HIGH(base)		((base) + 0x801c)
-#define PCIE_WRDMA1_CHNL_CNTRL(base)		((base) + 0x8020)
-#define PCIE_WRDMA1_XFR_SIZE(base)		((base) + 0x8024)
-#define PCIE_WRDMA1_SAR_LOW(base)		((base) + 0x8028)
-#define PCIE_WRDMA1_SAR_HIGH(base)		((base) + 0x802c)
-#define PCIE_WRDMA1_DAR_LOW(base)		((base) + 0x8030)
-#define PCIE_WRDMA1_DAR_HIGH(base)		((base) + 0x8034)
-#define PCIE_WRDMA1_LLPTR_LOW(base)		((base) + 0x8038)
-#define PCIE_WRDMA1_LLPTR_HIGH(base)		((base) + 0x803c)
-#define PCIE_RDDMA0_CHNL_CNTRL(base)		((base) + 0x8040)
-#define PCIE_RDDMA0_XFR_SIZE(base)		((base) + 0x8044)
-#define PCIE_RDDMA0_SAR_LOW(base)		((base) + 0x8048)
-#define PCIE_RDDMA0_SAR_HIGH(base)		((base) + 0x804c)
-#define PCIE_RDDMA0_DAR_LOW(base)		((base) + 0x8050)
-#define PCIE_RDDMA0_DAR_HIGH(base)		((base) + 0x8054)
-#define PCIE_RDDMA0_LLPTR_LOW(base)		((base) + 0x8058)
-#define PCIE_RDDMA0_LLPTR_HIGH(base)		((base) + 0x805c)
-#define PCIE_RDDMA1_CHNL_CNTRL(base)		((base) + 0x8060)
-#define PCIE_RDDMA1_XFR_SIZE(base)		((base) + 0x8064)
-#define PCIE_RDDMA1_SAR_LOW(base)		((base) + 0x8068)
-#define PCIE_RDDMA1_SAR_HIGH(base)		((base) + 0x806c)
-#define PCIE_RDDMA1_DAR_LOW(base)		((base) + 0x8070)
-#define PCIE_RDDMA1_DAR_HIGH(base)		((base) + 0x8074)
-#define PCIE_RDDMA1_LLPTR_LOW(base)		((base) + 0x8078)
-#define PCIE_RDDMA1_LLPTR_HIGH(base)		((base) + 0x807c)
-
-#define PCIE_ID(base)				((base) + 0x0000)
-#define PCIE_CMD(base)				((base) + 0x0004)
-#define PCIE_BAR(base, n)			((base) + 0x0010 + ((n) << 2))
-#define PCIE_CAP_PTR(base)			((base) + 0x0034)
-#define PCIE_MSI_LBAR(base)			((base) + 0x0054)
-#define PCIE_MSI_CTRL(base)			((base) + 0x0050)
-#define PCIE_MSI_ADDR_L(base)			((base) + 0x0054)
-#define PCIE_MSI_ADDR_H(base)			((base) + 0x0058)
-#define PCIE_MSI_DATA(base)			((base) + 0x005C)
-#define PCIE_MSI_MASK_BIT(base)			((base) + 0x0060)
-#define PCIE_MSI_PEND_BIT(base)			((base) + 0x0064)
-#define PCIE_DEVCAP(base)			((base) + 0x0074)
-#define PCIE_DEVCTLSTS(base)			((base) + 0x0078)
-
-#define PCIE_CMDSTS(base)			((base) + 0x0004)
-#define PCIE_LINK_STAT(base)			((base) + 0x80)
-#define PCIE_LINK_CTL2(base)			((base) + 0xa0)
-#define PCIE_ASPM_L1_CTRL(base)			((base) + 0x70c)
-#define PCIE_ASPM_LINK_CTRL(base)		(PCIE_LINK_STAT)
-#define PCIE_ASPM_L1_SUBSTATE_TIMING(base)	((base) + 0xB44)
-#define PCIE_L1SUB_CTRL1(base)			((base) + 0x150)
-#define PCIE_PMCSR(base)			((base) + 0x44)
-#define PCIE_CFG_SPACE_LIMIT(base)		((base) + 0x100)
-
-/* PCIe link defines */
-#define PEARL_PCIE_LINKUP			(0x7)
-#define PEARL_PCIE_DATA_LINK			(BIT(0))
-#define PEARL_PCIE_PHY_LINK			(BIT(1))
-#define PEARL_PCIE_LINK_RST			(BIT(3))
-#define PEARL_PCIE_FATAL_ERR			(BIT(5))
-#define PEARL_PCIE_NONFATAL_ERR			(BIT(6))
-
-/* PCIe Lane defines */
-#define PCIE_G2_LANE_X1				((BIT(0)) << 16)
-#define PCIE_G2_LANE_X2				((BIT(0) | BIT(1)) << 16)
-
-/* PCIe DLL link enable */
-#define PCIE_DLL_LINK_EN			((BIT(0)) << 5)
-
-#define PCIE_LINK_GEN1				(BIT(0))
-#define PCIE_LINK_GEN2				(BIT(1))
-#define PCIE_LINK_GEN3				(BIT(2))
-#define PCIE_LINK_MODE(x)			(((x) >> 16) & 0x7)
-
-#define MSI_EN					(BIT(0))
-#define MSI_64_EN				(BIT(7))
-#define PCIE_MSI_ADDR_OFFSET(a)			((a) & 0xFFFF)
-#define PCIE_MSI_ADDR_ALIGN(a)			((a) & (~0xFFFF))
-
-#define PCIE_BAR_MASK(base, n)			((base) + 0x1010 + ((n) << 2))
-#define PCIE_MAX_BAR				(6)
-
-#define PCIE_ATU_VIEW(base)			((base) + 0x0900)
-#define PCIE_ATU_CTL1(base)			((base) + 0x0904)
-#define PCIE_ATU_CTL2(base)			((base) + 0x0908)
-#define PCIE_ATU_LBAR(base)			((base) + 0x090c)
-#define PCIE_ATU_UBAR(base)			((base) + 0x0910)
-#define PCIE_ATU_LAR(base)			((base) + 0x0914)
-#define PCIE_ATU_LTAR(base)			((base) + 0x0918)
-#define PCIE_ATU_UTAR(base)			((base) + 0x091c)
-
-#define PCIE_MSI_ADDR_LOWER(base)		((base) + 0x0820)
-#define PCIE_MSI_ADDR_UPPER(base)		((base) + 0x0824)
-#define PCIE_MSI_ENABLE(base)			((base) + 0x0828)
-#define PCIE_MSI_MASK_RC(base)			((base) + 0x082c)
-#define PCIE_MSI_STATUS(base)			((base) + 0x0830)
-#define PEARL_PCIE_MSI_REGION			(0xce000000)
-#define PEARL_PCIE_MSI_DATA			(0)
-#define PCIE_MSI_GPIO(base)			((base) + 0x0888)
-
-#define PCIE_HDP_HOST_QUEUE_FULL	(BIT(17))
-#define USE_BAR_MATCH_MODE
-#define PCIE_ATU_OB_REGION		(BIT(0))
-#define PCIE_ATU_EN_REGION		(BIT(31))
-#define PCIE_ATU_EN_MATCH		(BIT(30))
-#define PCIE_BASE_REGION		(0xb0000000)
-#define PCIE_MEM_MAP_SIZE		(512 * 1024)
-
-#define PCIE_OB_REG_REGION		(0xcf000000)
-#define PCIE_CONFIG_REGION		(0xcf000000)
-#define PCIE_CONFIG_SIZE		(4096)
-#define PCIE_CONFIG_CH			(1)
-
-/* inbound mapping */
-#define PCIE_IB_BAR0			(0x00000000)	/* ddr */
-#define PCIE_IB_BAR0_CH			(0)
-#define PCIE_IB_BAR3			(0xe0000000)	/* sys_reg */
-#define PCIE_IB_BAR3_CH			(1)
-
-/* outbound mapping */
-#define PCIE_MEM_CH			(0)
-#define PCIE_REG_CH			(1)
-#define PCIE_MEM_REGION			(0xc0000000)
-#define	PCIE_MEM_SIZE			(0x000fffff)
-#define PCIE_MEM_TAR			(0x80000000)
-
-#define PCIE_MSI_REGION			(0xce000000)
-#define PCIE_MSI_SIZE			(KBYTE(4) - 1)
-#define PCIE_MSI_CH			(1)
-
-/* size of config region */
-#define PCIE_CFG_SIZE			(0x0000ffff)
-
-#define PCIE_ATU_DIR_IB			(BIT(31))
-#define PCIE_ATU_DIR_OB			(0)
-#define PCIE_ATU_DIR_CFG		(2)
-#define PCIE_ATU_DIR_MATCH_IB		(BIT(31) | BIT(30))
-
-#define PCIE_DMA_WR_0			(0)
-#define PCIE_DMA_WR_1			(1)
-#define PCIE_DMA_RD_0			(2)
-#define PCIE_DMA_RD_1			(3)
-
-#define PCIE_DMA_CHNL_CNTRL_CB		(BIT(0))
-#define PCIE_DMA_CHNL_CNTRL_TCB		(BIT(1))
-#define PCIE_DMA_CHNL_CNTRL_LLP		(BIT(2))
-#define PCIE_DMA_CHNL_CNTRL_LIE		(BIT(3))
-#define PCIE_DMA_CHNL_CNTRL_RIE		(BIT(4))
-#define PCIE_DMA_CHNL_CNTRL_CSS		(BIT(8))
-#define PCIE_DMA_CHNL_CNTRL_LLE		(BIT(9))
-#define PCIE_DMA_CHNL_CNTRL_TLP		(BIT(26))
-
-#define PCIE_DMA_CHNL_CONTEXT_RD	(BIT(31))
-#define PCIE_DMA_CHNL_CONTEXT_WR	(0)
-#define PCIE_MAX_BAR			(6)
-
 /* PCIe HDP interrupt status definition */
 #define PCIE_HDP_INT_EP_RXDMA		(BIT(0))
 #define PCIE_HDP_INT_HBM_UF		(BIT(1))
--=20
2.11.0

