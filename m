Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53D87C282C4
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 07:13:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 021AA20863
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 07:13:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="gUimyFau"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbfBIHNC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Feb 2019 02:13:02 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:61023 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbfBIHNB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Feb 2019 02:13:01 -0500
X-IronPort-AV: E=Sophos;i="5.56,564,1539673200"; 
   d="scan'208";a="24409318"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 09 Feb 2019 00:13:01 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.38) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sat, 9 Feb 2019 00:13:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+1xf3exnYIrDv5zCB32lihVXvWrQOzAVAhYt+H4Vz3k=;
 b=gUimyFau8RMvwD5mDhIU/N5QIeFYD8cqaGTgQl9Z1JSVOT7tx2s6BwukTx7G6PfRtr+M1VYLM9Ip1RU5CCIHgdrqPJPvsxLcCmd0AAhxrCaDLL9erK1SlzuNRFin8GDGhnXfKEXnYV4dY3GAVLLFbMBsQc8jSkO+y25tmP6hUwY=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3077.namprd11.prod.outlook.com (20.177.226.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.22; Sat, 9 Feb 2019 07:12:58 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1601.016; Sat, 9 Feb 2019
 07:12:58 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <kvalo@codeaurora.org>,
        <johannes@sipsolutions.net>, <Adham.Abozaeid@microchip.com>,
        <Venkateswara.Kaja@microchip.com>, <Nicolas.Ferre@microchip.com>,
        <Claudiu.Beznea@microchip.com>, <Ajay.Kathat@microchip.com>
Subject: [PATCH 14/16] wilc1000: add wilc_sdio.c
Thread-Topic: [PATCH 14/16] wilc1000: add wilc_sdio.c
Thread-Index: AQHUwEbi8pOJDaLJlEmp7NSXvY5GPQ==
Date:   Sat, 9 Feb 2019 07:12:57 +0000
Message-ID: <1549696298-9795-15-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3077;6:r7N+SP5PrWFqddMLmCPkZDFKAg2I/TIeawcydbYHJM6E1+5b3moffuSpDTDnTjN8DS+VGlxbSy3aFMnTw+r25SkXiH1ip2LWFkT1NKq7mjFPS6MDVy1SDvRTlB90v4/M+KLdk6y+9I6MyjDZyiPs4tGjfEwoE6q21zjzMP7iR3Yz+cKYMTMwaTNtGwhEBTAGOXu4P6W8Uy1+prFIG2p3nZrtOT+M4xJLQd0NPoc245+A8KA5h5h6yBf4jfKu0ucDpYl7vzREV7K2b5JKc9EVKIPCsJY6z3F2LOH26sq7yKFjwNA17qImaqrGB6aA2dtuy/nKcqbqhzmqZTlnKQbOZGkdl8ECX6mFJV3fSfKF6n/j2tLVoWIh46Drxf6B88QIl5gdxZbkl0WFqgNonaf42BvjwIo1RHethfZDKob2ywkCOYVTe44GZ5IteXzxp0MIpdQL/mBGdxBNwskw5acgCA==;5:zioCWuYIDrqmdcnrbJSthDG2H6s8GKSArpq6gCKWfJyv/J4H3Uceh+wP9WC/PB6PWrNkMPFVxsP+GNxSLXKpHBl3OjO0/dIs7dSnHqlfi9b2YQAwYCUfXzi4tpGw9ltXxrEMWhM7ftfsEmcHsS0+FfSarmURs2kdtI5IC5ackDMjM66Xiqk+s0nx40qVcd2EsE44dckg0sTmPbADD11vyg==;7:PJ3JChY6Em7hUU1szUyei3/3Cs8My7TQ374ogIHvoh/NLxnpvuDAWbdEw9pCoPZR/ZfWj59UQwvnUZmXWVbjvW3gp4hOO0vpE0+gn2rEPcMs0IQQgnQehpBFkcnw9B1JKEMxeCCQs0wNJWteLK0E0Q==
x-ms-office365-filtering-correlation-id: 968f3ee8-47e4-4043-c034-08d68e5e0490
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3077;
x-ms-traffictypediagnostic: BYAPR11MB3077:
x-microsoft-antispam-prvs: <BYAPR11MB3077A73D830FE1E8EA720DB7E36A0@BYAPR11MB3077.namprd11.prod.outlook.com>
x-forefront-prvs: 09435FCA72
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(396003)(39860400002)(136003)(366004)(199004)(189003)(81166006)(8676002)(81156014)(97736004)(386003)(6506007)(14454004)(99286004)(305945005)(486006)(72206003)(6916009)(53936002)(102836004)(478600001)(7736002)(8936002)(26005)(186003)(36756003)(50226002)(54906003)(256004)(2616005)(476003)(11346002)(446003)(14444005)(68736007)(105586002)(106356001)(5640700003)(2351001)(6116002)(3846002)(52116002)(316002)(6436002)(66066001)(30864003)(107886003)(25786009)(4326008)(2501003)(2906002)(76176011)(78486014)(53946003)(6486002)(86362001)(71200400001)(71190400001)(6512007)(579004);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3077;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: y9CUXAxx1IicCYxkd7a6nzxJlS8/dMgDtX8CKOZ+/SoqAGJ6eH4iSqOBD08H3NB6z59059BINnHCViUObxBTJyeH4YDVXQuU8zz0XEWuldqQlSbe4/ASKrcEPAu6Gh6wjQZcdw6a0zFmNItHeZAVVjIs/RtuU+KxlceF6vRfwhl08guWwQnOANlPFi9snIHxnqKmdTnUGo3ZPCspl3e4P0/fPoTO1kKllERbq7v9O17p9cihIvXjaI5gMSSYAGJn6VUmSwLWhLS0q+UkNe14/zv2PAn7Ixe/iw5lsNGHpzAttQSjDFSSjI7ZaxnxUlrY6L5IuHUUQ6O6UWWmyG8831ZDNZHAdhxKJ0HCCMfD8bVYTLLCK9EFH1rD6sSHVPz7oItxWUUTGph9VkNn44NbvaUO0Z7LfIyzBDxmbiU14X8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 968f3ee8-47e4-4043-c034-08d68e5e0490
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2019 07:12:54.8541
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

Moved '/driver/staging/wilc1000/wilc_sdio.c' to
'drivers/net/wireless/microchip/wilc1000/'.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 .../net/wireless/microchip/wilc1000/wilc_sdio.c    | 1140 ++++++++++++++++=
++++
 1 file changed, 1140 insertions(+)
 create mode 100644 drivers/net/wireless/microchip/wilc1000/wilc_sdio.c

diff --git a/drivers/net/wireless/microchip/wilc1000/wilc_sdio.c b/drivers/=
net/wireless/microchip/wilc1000/wilc_sdio.c
new file mode 100644
index 0000000..b789c57
--- /dev/null
+++ b/drivers/net/wireless/microchip/wilc1000/wilc_sdio.c
@@ -0,0 +1,1140 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiari=
es.
+ * All rights reserved.
+ */
+
+#include <linux/mmc/sdio_func.h>
+#include <linux/mmc/host.h>
+
+#include "wilc_wfi_netdevice.h"
+
+#define SDIO_MODALIAS "wilc1000_sdio"
+
+#define SDIO_VENDOR_ID_WILC 0x0296
+#define SDIO_DEVICE_ID_WILC 0x5347
+
+static const struct sdio_device_id wilc_sdio_ids[] =3D {
+	{ SDIO_DEVICE(SDIO_VENDOR_ID_WILC, SDIO_DEVICE_ID_WILC) },
+	{ },
+};
+
+#define WILC_SDIO_BLOCK_SIZE 512
+
+struct wilc_sdio {
+	bool irq_gpio;
+	u32 block_size;
+	int nint;
+/* Max num interrupts allowed in registers 0xf7, 0xf8 */
+#define MAX_NUN_INT_THRPT_ENH2 (5)
+	int has_thrpt_enh3;
+};
+
+struct sdio_cmd52 {
+	u32 read_write:		1;
+	u32 function:		3;
+	u32 raw:		1;
+	u32 address:		17;
+	u32 data:		8;
+};
+
+struct sdio_cmd53 {
+	u32 read_write:		1;
+	u32 function:		3;
+	u32 block_mode:		1;
+	u32 increment:		1;
+	u32 address:		17;
+	u32 count:		9;
+	u8 *buffer;
+	u32 block_size;
+};
+
+static const struct wilc_hif_func wilc_hif_sdio;
+
+static void wilc_sdio_interrupt(struct sdio_func *func)
+{
+	sdio_release_host(func);
+	wilc_handle_isr(sdio_get_drvdata(func));
+	sdio_claim_host(func);
+}
+
+static int wilc_sdio_cmd52(struct wilc *wilc, struct sdio_cmd52 *cmd)
+{
+	struct sdio_func *func =3D container_of(wilc->dev, struct sdio_func, dev)=
;
+	int ret;
+	u8 data;
+
+	sdio_claim_host(func);
+
+	func->num =3D cmd->function;
+	if (cmd->read_write) {  /* write */
+		if (cmd->raw) {
+			sdio_writeb(func, cmd->data, cmd->address, &ret);
+			data =3D sdio_readb(func, cmd->address, &ret);
+			cmd->data =3D data;
+		} else {
+			sdio_writeb(func, cmd->data, cmd->address, &ret);
+		}
+	} else {        /* read */
+		data =3D sdio_readb(func, cmd->address, &ret);
+		cmd->data =3D data;
+	}
+
+	sdio_release_host(func);
+
+	if (ret)
+		dev_err(&func->dev, "%s..failed, err(%d)\n", __func__, ret);
+	return ret;
+}
+
+static int wilc_sdio_cmd53(struct wilc *wilc, struct sdio_cmd53 *cmd)
+{
+	struct sdio_func *func =3D container_of(wilc->dev, struct sdio_func, dev)=
;
+	int size, ret;
+
+	sdio_claim_host(func);
+
+	func->num =3D cmd->function;
+	func->cur_blksize =3D cmd->block_size;
+	if (cmd->block_mode)
+		size =3D cmd->count * cmd->block_size;
+	else
+		size =3D cmd->count;
+
+	if (cmd->read_write) {  /* write */
+		ret =3D sdio_memcpy_toio(func, cmd->address,
+				       (void *)cmd->buffer, size);
+	} else {        /* read */
+		ret =3D sdio_memcpy_fromio(func, (void *)cmd->buffer,
+					 cmd->address,  size);
+	}
+
+	sdio_release_host(func);
+
+	if (ret)
+		dev_err(&func->dev, "%s..failed, err(%d)\n", __func__,  ret);
+
+	return ret;
+}
+
+static int wilc_sdio_probe(struct sdio_func *func,
+			   const struct sdio_device_id *id)
+{
+	struct wilc *wilc;
+	int ret;
+	struct gpio_desc *gpio =3D NULL;
+	struct wilc_sdio *sdio_priv;
+
+	sdio_priv =3D kzalloc(sizeof(*sdio_priv), GFP_KERNEL);
+	if (!sdio_priv)
+		return -ENOMEM;
+
+	if (IS_ENABLED(CONFIG_WILC1000_HW_OOB_INTR)) {
+		gpio =3D gpiod_get(&func->dev, "irq", GPIOD_IN);
+		if (IS_ERR(gpio)) {
+			/* get the GPIO descriptor from hardcode GPIO number */
+			gpio =3D gpio_to_desc(GPIO_NUM);
+			if (!gpio)
+				dev_err(&func->dev, "failed to get irq gpio\n");
+		}
+	}
+
+	dev_dbg(&func->dev, "Initializing netdev\n");
+	ret =3D wilc_netdev_init(&wilc, &func->dev, WILC_HIF_SDIO,
+			       &wilc_hif_sdio);
+	if (ret) {
+		dev_err(&func->dev, "Couldn't initialize netdev\n");
+		kfree(sdio_priv);
+		return ret;
+	}
+	sdio_set_drvdata(func, wilc);
+	wilc->bus_data =3D sdio_priv;
+	wilc->dev =3D &func->dev;
+	wilc->gpio_irq =3D gpio;
+
+	dev_info(&func->dev, "Driver Initializing success\n");
+	return 0;
+}
+
+static void wilc_sdio_remove(struct sdio_func *func)
+{
+	struct wilc *wilc =3D sdio_get_drvdata(func);
+
+	/* free the GPIO in module remove */
+	if (wilc->gpio_irq)
+		gpiod_put(wilc->gpio_irq);
+	wilc_netdev_cleanup(wilc);
+}
+
+static int wilc_sdio_reset(struct wilc *wilc)
+{
+	struct sdio_cmd52 cmd;
+	int ret;
+	struct sdio_func *func =3D dev_to_sdio_func(wilc->dev);
+
+	cmd.read_write =3D 1;
+	cmd.function =3D 0;
+	cmd.raw =3D 0;
+	cmd.address =3D 0x6;
+	cmd.data =3D 0x8;
+	ret =3D wilc_sdio_cmd52(wilc, &cmd);
+	if (ret) {
+		dev_err(&func->dev, "Fail cmd 52, reset cmd ...\n");
+		return ret;
+	}
+	return 0;
+}
+
+static int wilc_sdio_suspend(struct device *dev)
+{
+	struct sdio_func *func =3D dev_to_sdio_func(dev);
+	struct wilc *wilc =3D sdio_get_drvdata(func);
+	int ret;
+
+	dev_info(dev, "sdio suspend\n");
+	chip_wakeup(wilc);
+
+	if (!wilc->suspend_event) {
+		wilc_chip_sleep_manually(wilc);
+	} else {
+		host_sleep_notify(wilc);
+		chip_allow_sleep(wilc);
+	}
+
+	ret =3D wilc_sdio_reset(wilc);
+	if (ret) {
+		dev_err(&func->dev, "Fail reset sdio\n");
+		return ret;
+	}
+	sdio_claim_host(func);
+
+	return 0;
+}
+
+static int wilc_sdio_enable_interrupt(struct wilc *dev)
+{
+	struct sdio_func *func =3D container_of(dev->dev, struct sdio_func, dev);
+	int ret =3D 0;
+
+	sdio_claim_host(func);
+	ret =3D sdio_claim_irq(func, wilc_sdio_interrupt);
+	sdio_release_host(func);
+
+	if (ret < 0) {
+		dev_err(&func->dev, "can't claim sdio_irq, err(%d)\n", ret);
+		ret =3D -EIO;
+	}
+	return ret;
+}
+
+static void wilc_sdio_disable_interrupt(struct wilc *dev)
+{
+	struct sdio_func *func =3D container_of(dev->dev, struct sdio_func, dev);
+	int ret;
+
+	sdio_claim_host(func);
+	ret =3D sdio_release_irq(func);
+	if (ret < 0)
+		dev_err(&func->dev, "can't release sdio_irq, err(%d)\n", ret);
+	sdio_release_host(func);
+}
+
+/********************************************
+ *
+ *      Function 0
+ *
+ ********************************************/
+
+static int wilc_sdio_set_func0_csa_address(struct wilc *wilc, u32 adr)
+{
+	struct sdio_func *func =3D dev_to_sdio_func(wilc->dev);
+	struct sdio_cmd52 cmd;
+	int ret;
+
+	/**
+	 *      Review: BIG ENDIAN
+	 **/
+	cmd.read_write =3D 1;
+	cmd.function =3D 0;
+	cmd.raw =3D 0;
+	cmd.address =3D 0x10c;
+	cmd.data =3D (u8)adr;
+	ret =3D wilc_sdio_cmd52(wilc, &cmd);
+	if (ret) {
+		dev_err(&func->dev, "Failed cmd52, set 0x10c data...\n");
+		goto fail;
+	}
+
+	cmd.address =3D 0x10d;
+	cmd.data =3D (u8)(adr >> 8);
+	ret =3D wilc_sdio_cmd52(wilc, &cmd);
+	if (ret) {
+		dev_err(&func->dev, "Failed cmd52, set 0x10d data...\n");
+		goto fail;
+	}
+
+	cmd.address =3D 0x10e;
+	cmd.data =3D (u8)(adr >> 16);
+	ret =3D wilc_sdio_cmd52(wilc, &cmd);
+	if (ret) {
+		dev_err(&func->dev, "Failed cmd52, set 0x10e data...\n");
+		goto fail;
+	}
+
+	return 1;
+fail:
+	return 0;
+}
+
+static int wilc_sdio_set_func0_block_size(struct wilc *wilc, u32 block_siz=
e)
+{
+	struct sdio_func *func =3D dev_to_sdio_func(wilc->dev);
+	struct sdio_cmd52 cmd;
+	int ret;
+
+	cmd.read_write =3D 1;
+	cmd.function =3D 0;
+	cmd.raw =3D 0;
+	cmd.address =3D 0x10;
+	cmd.data =3D (u8)block_size;
+	ret =3D wilc_sdio_cmd52(wilc, &cmd);
+	if (ret) {
+		dev_err(&func->dev, "Failed cmd52, set 0x10 data...\n");
+		goto fail;
+	}
+
+	cmd.address =3D 0x11;
+	cmd.data =3D (u8)(block_size >> 8);
+	ret =3D wilc_sdio_cmd52(wilc, &cmd);
+	if (ret) {
+		dev_err(&func->dev, "Failed cmd52, set 0x11 data...\n");
+		goto fail;
+	}
+
+	return 1;
+fail:
+	return 0;
+}
+
+/********************************************
+ *
+ *      Function 1
+ *
+ ********************************************/
+
+static int wilc_sdio_set_func1_block_size(struct wilc *wilc, u32 block_siz=
e)
+{
+	struct sdio_func *func =3D dev_to_sdio_func(wilc->dev);
+	struct sdio_cmd52 cmd;
+	int ret;
+
+	cmd.read_write =3D 1;
+	cmd.function =3D 0;
+	cmd.raw =3D 0;
+	cmd.address =3D 0x110;
+	cmd.data =3D (u8)block_size;
+	ret =3D wilc_sdio_cmd52(wilc, &cmd);
+	if (ret) {
+		dev_err(&func->dev, "Failed cmd52, set 0x110 data...\n");
+		goto fail;
+	}
+	cmd.address =3D 0x111;
+	cmd.data =3D (u8)(block_size >> 8);
+	ret =3D wilc_sdio_cmd52(wilc, &cmd);
+	if (ret) {
+		dev_err(&func->dev, "Failed cmd52, set 0x111 data...\n");
+		goto fail;
+	}
+
+	return 1;
+fail:
+	return 0;
+}
+
+/********************************************
+ *
+ *      Sdio interfaces
+ *
+ ********************************************/
+static int wilc_sdio_write_reg(struct wilc *wilc, u32 addr, u32 data)
+{
+	struct sdio_func *func =3D dev_to_sdio_func(wilc->dev);
+	struct wilc_sdio *sdio_priv =3D wilc->bus_data;
+	int ret;
+
+	cpu_to_le32s(&data);
+
+	if (addr >=3D 0xf0 && addr <=3D 0xff) {
+		struct sdio_cmd52 cmd;
+
+		cmd.read_write =3D 1;
+		cmd.function =3D 0;
+		cmd.raw =3D 0;
+		cmd.address =3D addr;
+		cmd.data =3D data;
+		ret =3D wilc_sdio_cmd52(wilc, &cmd);
+		if (ret) {
+			dev_err(&func->dev,
+				"Failed cmd 52, read reg (%08x) ...\n", addr);
+			goto fail;
+		}
+	} else {
+		struct sdio_cmd53 cmd;
+
+		/**
+		 *      set the AHB address
+		 **/
+		if (!wilc_sdio_set_func0_csa_address(wilc, addr))
+			goto fail;
+
+		cmd.read_write =3D 1;
+		cmd.function =3D 0;
+		cmd.address =3D 0x10f;
+		cmd.block_mode =3D 0;
+		cmd.increment =3D 1;
+		cmd.count =3D 4;
+		cmd.buffer =3D (u8 *)&data;
+		cmd.block_size =3D sdio_priv->block_size;
+		ret =3D wilc_sdio_cmd53(wilc, &cmd);
+		if (ret) {
+			dev_err(&func->dev,
+				"Failed cmd53, write reg (%08x)...\n", addr);
+			goto fail;
+		}
+	}
+
+	return 1;
+
+fail:
+
+	return 0;
+}
+
+static int wilc_sdio_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
+{
+	struct sdio_func *func =3D dev_to_sdio_func(wilc->dev);
+	struct wilc_sdio *sdio_priv =3D wilc->bus_data;
+	u32 block_size =3D sdio_priv->block_size;
+	struct sdio_cmd53 cmd;
+	int nblk, nleft, ret;
+
+	cmd.read_write =3D 1;
+	if (addr > 0) {
+		/**
+		 *      has to be word aligned...
+		 **/
+		if (size & 0x3) {
+			size +=3D 4;
+			size &=3D ~0x3;
+		}
+
+		/**
+		 *      func 0 access
+		 **/
+		cmd.function =3D 0;
+		cmd.address =3D 0x10f;
+	} else {
+		/**
+		 *      has to be word aligned...
+		 **/
+		if (size & 0x3) {
+			size +=3D 4;
+			size &=3D ~0x3;
+		}
+
+		/**
+		 *      func 1 access
+		 **/
+		cmd.function =3D 1;
+		cmd.address =3D 0;
+	}
+
+	nblk =3D size / block_size;
+	nleft =3D size % block_size;
+
+	if (nblk > 0) {
+		cmd.block_mode =3D 1;
+		cmd.increment =3D 1;
+		cmd.count =3D nblk;
+		cmd.buffer =3D buf;
+		cmd.block_size =3D block_size;
+		if (addr > 0) {
+			if (!wilc_sdio_set_func0_csa_address(wilc, addr))
+				goto fail;
+		}
+		ret =3D wilc_sdio_cmd53(wilc, &cmd);
+		if (ret) {
+			dev_err(&func->dev,
+				"Failed cmd53 [%x], block send...\n", addr);
+			goto fail;
+		}
+		if (addr > 0)
+			addr +=3D nblk * block_size;
+		buf +=3D nblk * block_size;
+	}
+
+	if (nleft > 0) {
+		cmd.block_mode =3D 0;
+		cmd.increment =3D 1;
+		cmd.count =3D nleft;
+		cmd.buffer =3D buf;
+
+		cmd.block_size =3D block_size;
+
+		if (addr > 0) {
+			if (!wilc_sdio_set_func0_csa_address(wilc, addr))
+				goto fail;
+		}
+		ret =3D wilc_sdio_cmd53(wilc, &cmd);
+		if (ret) {
+			dev_err(&func->dev,
+				"Failed cmd53 [%x], bytes send...\n", addr);
+			goto fail;
+		}
+	}
+
+	return 1;
+
+fail:
+
+	return 0;
+}
+
+static int wilc_sdio_read_reg(struct wilc *wilc, u32 addr, u32 *data)
+{
+	struct sdio_func *func =3D dev_to_sdio_func(wilc->dev);
+	struct wilc_sdio *sdio_priv =3D wilc->bus_data;
+	int ret;
+
+	if (addr >=3D 0xf0 && addr <=3D 0xff) {
+		struct sdio_cmd52 cmd;
+
+		cmd.read_write =3D 0;
+		cmd.function =3D 0;
+		cmd.raw =3D 0;
+		cmd.address =3D addr;
+		ret =3D wilc_sdio_cmd52(wilc, &cmd);
+		if (ret) {
+			dev_err(&func->dev,
+				"Failed cmd 52, read reg (%08x) ...\n", addr);
+			goto fail;
+		}
+		*data =3D cmd.data;
+	} else {
+		struct sdio_cmd53 cmd;
+
+		if (!wilc_sdio_set_func0_csa_address(wilc, addr))
+			goto fail;
+
+		cmd.read_write =3D 0;
+		cmd.function =3D 0;
+		cmd.address =3D 0x10f;
+		cmd.block_mode =3D 0;
+		cmd.increment =3D 1;
+		cmd.count =3D 4;
+		cmd.buffer =3D (u8 *)data;
+
+		cmd.block_size =3D sdio_priv->block_size;
+		ret =3D wilc_sdio_cmd53(wilc, &cmd);
+		if (ret) {
+			dev_err(&func->dev,
+				"Failed cmd53, read reg (%08x)...\n", addr);
+			goto fail;
+		}
+	}
+
+	le32_to_cpus(data);
+
+	return 1;
+
+fail:
+
+	return 0;
+}
+
+static int wilc_sdio_read(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
+{
+	struct sdio_func *func =3D dev_to_sdio_func(wilc->dev);
+	struct wilc_sdio *sdio_priv =3D wilc->bus_data;
+	u32 block_size =3D sdio_priv->block_size;
+	struct sdio_cmd53 cmd;
+	int nblk, nleft, ret;
+
+	cmd.read_write =3D 0;
+	if (addr > 0) {
+		/**
+		 *      has to be word aligned...
+		 **/
+		if (size & 0x3) {
+			size +=3D 4;
+			size &=3D ~0x3;
+		}
+
+		/**
+		 *      func 0 access
+		 **/
+		cmd.function =3D 0;
+		cmd.address =3D 0x10f;
+	} else {
+		/**
+		 *      has to be word aligned...
+		 **/
+		if (size & 0x3) {
+			size +=3D 4;
+			size &=3D ~0x3;
+		}
+
+		/**
+		 *      func 1 access
+		 **/
+		cmd.function =3D 1;
+		cmd.address =3D 0;
+	}
+
+	nblk =3D size / block_size;
+	nleft =3D size % block_size;
+
+	if (nblk > 0) {
+		cmd.block_mode =3D 1;
+		cmd.increment =3D 1;
+		cmd.count =3D nblk;
+		cmd.buffer =3D buf;
+		cmd.block_size =3D block_size;
+		if (addr > 0) {
+			if (!wilc_sdio_set_func0_csa_address(wilc, addr))
+				goto fail;
+		}
+		ret =3D wilc_sdio_cmd53(wilc, &cmd);
+		if (ret) {
+			dev_err(&func->dev,
+				"Failed cmd53 [%x], block read...\n", addr);
+			goto fail;
+		}
+		if (addr > 0)
+			addr +=3D nblk * block_size;
+		buf +=3D nblk * block_size;
+	}       /* if (nblk > 0) */
+
+	if (nleft > 0) {
+		cmd.block_mode =3D 0;
+		cmd.increment =3D 1;
+		cmd.count =3D nleft;
+		cmd.buffer =3D buf;
+
+		cmd.block_size =3D block_size;
+
+		if (addr > 0) {
+			if (!wilc_sdio_set_func0_csa_address(wilc, addr))
+				goto fail;
+		}
+		ret =3D wilc_sdio_cmd53(wilc, &cmd);
+		if (ret) {
+			dev_err(&func->dev,
+				"Failed cmd53 [%x], bytes read...\n", addr);
+			goto fail;
+		}
+	}
+
+	return 1;
+
+fail:
+
+	return 0;
+}
+
+/********************************************
+ *
+ *      Bus interfaces
+ *
+ ********************************************/
+
+static int wilc_sdio_deinit(struct wilc *wilc)
+{
+	return 1;
+}
+
+static int wilc_sdio_init(struct wilc *wilc, bool resume)
+{
+	struct sdio_func *func =3D dev_to_sdio_func(wilc->dev);
+	struct wilc_sdio *sdio_priv =3D wilc->bus_data;
+	struct sdio_cmd52 cmd;
+	int loop, ret;
+	u32 chipid;
+
+	if (!resume)
+		sdio_priv->irq_gpio =3D wilc->dev_irq_num;
+
+	/**
+	 *      function 0 csa enable
+	 **/
+	cmd.read_write =3D 1;
+	cmd.function =3D 0;
+	cmd.raw =3D 1;
+	cmd.address =3D 0x100;
+	cmd.data =3D 0x80;
+	ret =3D wilc_sdio_cmd52(wilc, &cmd);
+	if (ret) {
+		dev_err(&func->dev, "Fail cmd 52, enable csa...\n");
+		goto fail;
+	}
+
+	/**
+	 *      function 0 block size
+	 **/
+	if (!wilc_sdio_set_func0_block_size(wilc, WILC_SDIO_BLOCK_SIZE)) {
+		dev_err(&func->dev, "Fail cmd 52, set func 0 block size...\n");
+		goto fail;
+	}
+	sdio_priv->block_size =3D WILC_SDIO_BLOCK_SIZE;
+
+	/**
+	 *      enable func1 IO
+	 **/
+	cmd.read_write =3D 1;
+	cmd.function =3D 0;
+	cmd.raw =3D 1;
+	cmd.address =3D 0x2;
+	cmd.data =3D 0x2;
+	ret =3D wilc_sdio_cmd52(wilc, &cmd);
+	if (ret) {
+		dev_err(&func->dev,
+			"Fail cmd 52, set IOE register...\n");
+		goto fail;
+	}
+
+	/**
+	 *      make sure func 1 is up
+	 **/
+	cmd.read_write =3D 0;
+	cmd.function =3D 0;
+	cmd.raw =3D 0;
+	cmd.address =3D 0x3;
+	loop =3D 3;
+	do {
+		cmd.data =3D 0;
+		ret =3D wilc_sdio_cmd52(wilc, &cmd);
+		if (ret) {
+			dev_err(&func->dev,
+				"Fail cmd 52, get IOR register...\n");
+			goto fail;
+		}
+		if (cmd.data =3D=3D 0x2)
+			break;
+	} while (loop--);
+
+	if (loop <=3D 0) {
+		dev_err(&func->dev, "Fail func 1 is not ready...\n");
+		goto fail;
+	}
+
+	/**
+	 *      func 1 is ready, set func 1 block size
+	 **/
+	if (!wilc_sdio_set_func1_block_size(wilc, WILC_SDIO_BLOCK_SIZE)) {
+		dev_err(&func->dev, "Fail set func 1 block size...\n");
+		goto fail;
+	}
+
+	/**
+	 *      func 1 interrupt enable
+	 **/
+	cmd.read_write =3D 1;
+	cmd.function =3D 0;
+	cmd.raw =3D 1;
+	cmd.address =3D 0x4;
+	cmd.data =3D 0x3;
+	ret =3D wilc_sdio_cmd52(wilc, &cmd);
+	if (ret) {
+		dev_err(&func->dev, "Fail cmd 52, set IEN register...\n");
+		goto fail;
+	}
+
+	/**
+	 *      make sure can read back chip id correctly
+	 **/
+	if (!resume) {
+		if (!wilc_sdio_read_reg(wilc, 0x1000, &chipid)) {
+			dev_err(&func->dev, "Fail cmd read chip id...\n");
+			goto fail;
+		}
+		dev_err(&func->dev, "chipid (%08x)\n", chipid);
+		if ((chipid & 0xfff) > 0x2a0)
+			sdio_priv->has_thrpt_enh3 =3D 1;
+		else
+			sdio_priv->has_thrpt_enh3 =3D 0;
+		dev_info(&func->dev, "has_thrpt_enh3 =3D %d...\n",
+			 sdio_priv->has_thrpt_enh3);
+	}
+
+	return 1;
+
+fail:
+
+	return 0;
+}
+
+static int wilc_sdio_read_size(struct wilc *wilc, u32 *size)
+{
+	u32 tmp;
+	struct sdio_cmd52 cmd;
+
+	/**
+	 *      Read DMA count in words
+	 **/
+	cmd.read_write =3D 0;
+	cmd.function =3D 0;
+	cmd.raw =3D 0;
+	cmd.address =3D 0xf2;
+	cmd.data =3D 0;
+	wilc_sdio_cmd52(wilc, &cmd);
+	tmp =3D cmd.data;
+
+	cmd.address =3D 0xf3;
+	cmd.data =3D 0;
+	wilc_sdio_cmd52(wilc, &cmd);
+	tmp |=3D (cmd.data << 8);
+
+	*size =3D tmp;
+	return 1;
+}
+
+static int wilc_sdio_read_int(struct wilc *wilc, u32 *int_status)
+{
+	struct sdio_func *func =3D dev_to_sdio_func(wilc->dev);
+	struct wilc_sdio *sdio_priv =3D wilc->bus_data;
+	u32 tmp;
+	struct sdio_cmd52 cmd;
+
+	wilc_sdio_read_size(wilc, &tmp);
+
+	/**
+	 *      Read IRQ flags
+	 **/
+	if (!sdio_priv->irq_gpio) {
+		int i;
+
+		cmd.read_write =3D 0;
+		cmd.function =3D 1;
+		cmd.address =3D 0x04;
+		cmd.data =3D 0;
+		wilc_sdio_cmd52(wilc, &cmd);
+
+		if (cmd.data & BIT(0))
+			tmp |=3D INT_0;
+		if (cmd.data & BIT(2))
+			tmp |=3D INT_1;
+		if (cmd.data & BIT(3))
+			tmp |=3D INT_2;
+		if (cmd.data & BIT(4))
+			tmp |=3D INT_3;
+		if (cmd.data & BIT(5))
+			tmp |=3D INT_4;
+		if (cmd.data & BIT(6))
+			tmp |=3D INT_5;
+		for (i =3D sdio_priv->nint; i < MAX_NUM_INT; i++) {
+			if ((tmp >> (IRG_FLAGS_OFFSET + i)) & 0x1) {
+				dev_err(&func->dev,
+					"Unexpected interrupt (1) : tmp=3D%x, data=3D%x\n",
+					tmp, cmd.data);
+				break;
+			}
+		}
+	} else {
+		u32 irq_flags;
+
+		cmd.read_write =3D 0;
+		cmd.function =3D 0;
+		cmd.raw =3D 0;
+		cmd.address =3D 0xf7;
+		cmd.data =3D 0;
+		wilc_sdio_cmd52(wilc, &cmd);
+		irq_flags =3D cmd.data & 0x1f;
+		tmp |=3D ((irq_flags >> 0) << IRG_FLAGS_OFFSET);
+	}
+
+	*int_status =3D tmp;
+
+	return 1;
+}
+
+static int wilc_sdio_clear_int_ext(struct wilc *wilc, u32 val)
+{
+	struct sdio_func *func =3D dev_to_sdio_func(wilc->dev);
+	struct wilc_sdio *sdio_priv =3D wilc->bus_data;
+	int ret;
+	int vmm_ctl;
+
+	if (sdio_priv->has_thrpt_enh3) {
+		u32 reg;
+
+		if (sdio_priv->irq_gpio) {
+			u32 flags;
+
+			flags =3D val & (BIT(MAX_NUN_INT_THRPT_ENH2) - 1);
+			reg =3D flags;
+		} else {
+			reg =3D 0;
+		}
+		/* select VMM table 0 */
+		if (val & SEL_VMM_TBL0)
+			reg |=3D BIT(5);
+		/* select VMM table 1 */
+		if (val & SEL_VMM_TBL1)
+			reg |=3D BIT(6);
+		/* enable VMM */
+		if (val & EN_VMM)
+			reg |=3D BIT(7);
+		if (reg) {
+			struct sdio_cmd52 cmd;
+
+			cmd.read_write =3D 1;
+			cmd.function =3D 0;
+			cmd.raw =3D 0;
+			cmd.address =3D 0xf8;
+			cmd.data =3D reg;
+
+			ret =3D wilc_sdio_cmd52(wilc, &cmd);
+			if (ret) {
+				dev_err(&func->dev,
+					"Failed cmd52, set 0xf8 data (%d) ...\n",
+					__LINE__);
+				goto fail;
+			}
+		}
+		return 1;
+	}
+	if (sdio_priv->irq_gpio) {
+		/* has_thrpt_enh2 uses register 0xf8 to clear interrupts. */
+		/*
+		 * Cannot clear multiple interrupts.
+		 * Must clear each interrupt individually.
+		 */
+		u32 flags;
+
+		flags =3D val & (BIT(MAX_NUM_INT) - 1);
+		if (flags) {
+			int i;
+
+			ret =3D 1;
+			for (i =3D 0; i < sdio_priv->nint; i++) {
+				if (flags & 1) {
+					struct sdio_cmd52 cmd;
+
+					cmd.read_write =3D 1;
+					cmd.function =3D 0;
+					cmd.raw =3D 0;
+					cmd.address =3D 0xf8;
+					cmd.data =3D BIT(i);
+
+					ret =3D wilc_sdio_cmd52(wilc, &cmd);
+					if (ret) {
+						dev_err(&func->dev,
+							"Failed cmd52, set 0xf8 data (%d) ...\n",
+							__LINE__);
+						goto fail;
+					}
+				}
+				if (!ret)
+					break;
+				flags >>=3D 1;
+			}
+			if (!ret)
+				goto fail;
+			for (i =3D sdio_priv->nint; i < MAX_NUM_INT; i++) {
+				if (flags & 1)
+					dev_err(&func->dev,
+						"Unexpected interrupt cleared %d...\n",
+						i);
+				flags >>=3D 1;
+			}
+		}
+	}
+
+	vmm_ctl =3D 0;
+	/* select VMM table 0 */
+	if (val & SEL_VMM_TBL0)
+		vmm_ctl |=3D BIT(0);
+	/* select VMM table 1 */
+	if (val & SEL_VMM_TBL1)
+		vmm_ctl |=3D BIT(1);
+	/* enable VMM */
+	if (val & EN_VMM)
+		vmm_ctl |=3D BIT(2);
+
+	if (vmm_ctl) {
+		struct sdio_cmd52 cmd;
+
+		cmd.read_write =3D 1;
+		cmd.function =3D 0;
+		cmd.raw =3D 0;
+		cmd.address =3D 0xf6;
+		cmd.data =3D vmm_ctl;
+		ret =3D wilc_sdio_cmd52(wilc, &cmd);
+		if (ret) {
+			dev_err(&func->dev,
+				"Failed cmd52, set 0xf6 data (%d) ...\n",
+				__LINE__);
+			goto fail;
+		}
+	}
+	return 1;
+fail:
+	return 0;
+}
+
+static int wilc_sdio_sync_ext(struct wilc *wilc, int nint)
+{
+	struct sdio_func *func =3D dev_to_sdio_func(wilc->dev);
+	struct wilc_sdio *sdio_priv =3D wilc->bus_data;
+	u32 reg;
+
+	if (nint > MAX_NUM_INT) {
+		dev_err(&func->dev, "Too many interrupts (%d)...\n", nint);
+		return 0;
+	}
+	if (nint > MAX_NUN_INT_THRPT_ENH2) {
+		dev_err(&func->dev,
+			"Cannot support more than 5 interrupts when has_thrpt_enh2=3D1.\n");
+		return 0;
+	}
+
+	sdio_priv->nint =3D nint;
+
+	/**
+	 *      Disable power sequencer
+	 **/
+	if (!wilc_sdio_read_reg(wilc, WILC_MISC, &reg)) {
+		dev_err(&func->dev, "Failed read misc reg...\n");
+		return 0;
+	}
+
+	reg &=3D ~BIT(8);
+	if (!wilc_sdio_write_reg(wilc, WILC_MISC, reg)) {
+		dev_err(&func->dev, "Failed write misc reg...\n");
+		return 0;
+	}
+
+	if (sdio_priv->irq_gpio) {
+		u32 reg;
+		int ret, i;
+
+		/**
+		 *      interrupt pin mux select
+		 **/
+		ret =3D wilc_sdio_read_reg(wilc, WILC_PIN_MUX_0, &reg);
+		if (!ret) {
+			dev_err(&func->dev, "Failed read reg (%08x)...\n",
+				WILC_PIN_MUX_0);
+			return 0;
+		}
+		reg |=3D BIT(8);
+		ret =3D wilc_sdio_write_reg(wilc, WILC_PIN_MUX_0, reg);
+		if (!ret) {
+			dev_err(&func->dev, "Failed write reg (%08x)...\n",
+				WILC_PIN_MUX_0);
+			return 0;
+		}
+
+		/**
+		 *      interrupt enable
+		 **/
+		ret =3D wilc_sdio_read_reg(wilc, WILC_INTR_ENABLE, &reg);
+		if (!ret) {
+			dev_err(&func->dev, "Failed read reg (%08x)...\n",
+				WILC_INTR_ENABLE);
+			return 0;
+		}
+
+		for (i =3D 0; (i < 5) && (nint > 0); i++, nint--)
+			reg |=3D BIT((27 + i));
+		ret =3D wilc_sdio_write_reg(wilc, WILC_INTR_ENABLE, reg);
+		if (!ret) {
+			dev_err(&func->dev, "Failed write reg (%08x)...\n",
+				WILC_INTR_ENABLE);
+			return 0;
+		}
+		if (nint) {
+			ret =3D wilc_sdio_read_reg(wilc, WILC_INTR2_ENABLE, &reg);
+			if (!ret) {
+				dev_err(&func->dev,
+					"Failed read reg (%08x)...\n",
+					WILC_INTR2_ENABLE);
+				return 0;
+			}
+
+			for (i =3D 0; (i < 3) && (nint > 0); i++, nint--)
+				reg |=3D BIT(i);
+
+			ret =3D wilc_sdio_read_reg(wilc, WILC_INTR2_ENABLE, &reg);
+			if (!ret) {
+				dev_err(&func->dev,
+					"Failed write reg (%08x)...\n",
+					WILC_INTR2_ENABLE);
+				return 0;
+			}
+		}
+	}
+	return 1;
+}
+
+/* Global sdio HIF function table */
+static const struct wilc_hif_func wilc_hif_sdio =3D {
+	.hif_init =3D wilc_sdio_init,
+	.hif_deinit =3D wilc_sdio_deinit,
+	.hif_read_reg =3D wilc_sdio_read_reg,
+	.hif_write_reg =3D wilc_sdio_write_reg,
+	.hif_block_rx =3D wilc_sdio_read,
+	.hif_block_tx =3D wilc_sdio_write,
+	.hif_read_int =3D wilc_sdio_read_int,
+	.hif_clear_int_ext =3D wilc_sdio_clear_int_ext,
+	.hif_read_size =3D wilc_sdio_read_size,
+	.hif_block_tx_ext =3D wilc_sdio_write,
+	.hif_block_rx_ext =3D wilc_sdio_read,
+	.hif_sync_ext =3D wilc_sdio_sync_ext,
+	.enable_interrupt =3D wilc_sdio_enable_interrupt,
+	.disable_interrupt =3D wilc_sdio_disable_interrupt,
+};
+
+static int wilc_sdio_resume(struct device *dev)
+{
+	struct sdio_func *func =3D dev_to_sdio_func(dev);
+	struct wilc *wilc =3D sdio_get_drvdata(func);
+
+	dev_info(dev, "sdio resume\n");
+	sdio_release_host(func);
+	chip_wakeup(wilc);
+	wilc_sdio_init(wilc, true);
+
+	if (wilc->suspend_event)
+		host_wakeup_notify(wilc);
+
+	chip_allow_sleep(wilc);
+
+	return 0;
+}
+
+static const struct of_device_id wilc_of_match[] =3D {
+	{ .compatible =3D "microchip,wilc1000-sdio", },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, wilc_of_match);
+
+static const struct dev_pm_ops wilc_sdio_pm_ops =3D {
+	.suspend =3D wilc_sdio_suspend,
+	.resume =3D wilc_sdio_resume,
+};
+
+static struct sdio_driver wilc_sdio_driver =3D {
+	.name		=3D SDIO_MODALIAS,
+	.id_table	=3D wilc_sdio_ids,
+	.probe		=3D wilc_sdio_probe,
+	.remove		=3D wilc_sdio_remove,
+	.drv =3D {
+		.pm =3D &wilc_sdio_pm_ops,
+		.of_match_table =3D wilc_of_match,
+	}
+};
+module_driver(wilc_sdio_driver,
+	      sdio_register_driver,
+	      sdio_unregister_driver);
+MODULE_LICENSE("GPL");
--=20
2.7.4

