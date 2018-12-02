Return-Path: <SRS0=9n1M=OL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 191F4C64EB4
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:02:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D715F20881
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:02:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="OgNsLHcy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D715F20881
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbeLBSCY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Dec 2018 13:02:24 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:40345 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbeLBSCY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Dec 2018 13:02:24 -0500
X-IronPort-AV: E=Sophos;i="5.56,307,1539673200"; 
   d="scan'208";a="21024629"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 02 Dec 2018 11:02:22 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.105) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 2 Dec 2018 11:02:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BP1ExmvOVf/VzoNTJkAQ4s68x8jk9BGtTAZ4wLcS2FA=;
 b=OgNsLHcyIy1Yc52bJfalZNDrU7FJ2xrbJYKKFOxdmsVDwiaCkpK+GoXVnlXvMlkHpwEML1kqneXlDue0g9zdyhc1SqAsKudXC+igEDK89vLXpm48drT2eryhu3GQXexkBl7x8YwT8T3F3MBui9Nag7Xse6AMzuaJy5+a3huwrv4=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3334.namprd11.prod.outlook.com (20.177.185.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.19; Sun, 2 Dec 2018 18:02:19 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f%4]) with mapi id 15.20.1382.020; Sun, 2 Dec 2018
 18:02:20 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 02/29] staging: wilc1000: make use of put_unaligned_le32 in
 handle_set_wfi_drv_handler()
Thread-Topic: [PATCH 02/29] staging: wilc1000: make use of put_unaligned_le32
 in handle_set_wfi_drv_handler()
Thread-Index: AQHUimkqWYkIBXXfrEiEHzq4sDr6vg==
Date:   Sun, 2 Dec 2018 18:02:19 +0000
Message-ID: <1543773663-20561-3-git-send-email-ajay.kathat@microchip.com>
References: <1543773663-20561-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1543773663-20561-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR0101CA0063.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::25) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [183.82.18.98]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3334;6:BhlZV9oWmlacVq4SxbB4MUJwwDr0RSF8KJKfN1weN2D2IYByaaSTMVGZ/0eeuR3tVJLfpaB5c+G11wv9U4Edtlx3i8Fsud0/73B3Krb0d0g/QPgoAA6T0TxsenNxN8vGzDj6LyxBhhmuJT5hc82ZVap8N7wK8eDWwK/xefjbH940nFeOOHri89M1LjKtqVcr/8x3hVpP6jPobrh+ZXJOakSHpZ4soDkBCc8X4XVnrFPmbj/u715JkMBtTGMfuecB82GBVZv14EdxvYxDllHok+6WuuUYY1UgcDgtEqFphCOuY5YnOjuuQJVdmBy0/Psh7eW673AAwQapbqH5iPAt45e4rCA7KvXQmONYemQh3vZVTKNtZjqKWF95vTWYqqzanZSFuQ9NgpgLbXiD+Dx+7PoXl2XiqsKoh1FcUYIKby94/jDGc019ay46GONTmNXiE8KW8wJpQi85C9KHa6AEyA==;5:iBzOYDThdgwTO2R3+4VdSYMLH/0fP7MUQsLoQYJai38ZURJjZK3OLsVTRCmP0TENBcl79yH+L0B/QD+XpRMAz2yO2Cdk5L8S95x3WRMFgViZ4A3OTiYfjVgjfSjk68Wn1YA75Tmaxehc0FZT7/BVUMo4XSCpgMjy8bQsA1CtKXM=;7:b/5BZYbjTNfZRMsbpnfO2GD8eIfMoHn4gsFP23ZdTFWj9eo91GFoDGEBK4Nmx0t4xmoBibLhZLBEcg+dwAXEuyQ9HL0oCPGPfiXDnpeAu7sxIEgGhQ4rHP8+S20m83Qly8Rvbr00+YlR6Q5L/NXi2A==
x-ms-office365-filtering-correlation-id: 1c983767-5c26-4426-c7c6-08d658804d4c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3334;
x-ms-traffictypediagnostic: BYAPR11MB3334:
x-microsoft-antispam-prvs: <BYAPR11MB33348083DBC4071C8AB5C2F0E3AD0@BYAPR11MB3334.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(10201501046)(3002001)(3231455)(999002)(944501491)(52105112)(93006095)(93001095)(148016)(149066)(150057)(6041310)(20161123558120)(20161123564045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB3334;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB3334;
x-forefront-prvs: 087474FBFA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(366004)(376002)(396003)(39850400004)(199004)(189003)(107886003)(6916009)(386003)(5660300001)(5640700003)(446003)(4326008)(11346002)(6506007)(78486014)(2906002)(6512007)(53936002)(54906003)(3846002)(6116002)(2351001)(81166006)(316002)(81156014)(52116002)(8676002)(26005)(8936002)(256004)(76176011)(6436002)(97736004)(106356001)(99286004)(486006)(6486002)(68736007)(105586002)(14454004)(478600001)(2616005)(7736002)(66066001)(36756003)(305945005)(72206003)(186003)(2501003)(86362001)(575784001)(102836004)(476003)(71190400001)(25786009)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3334;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: +OfLM0RST4+G3d1dXnTPrAuFznSVvhqJ0ls4XUpOb1DlgVan1k122XPUNReGTzNbkiZeb0q4pzPRBwKdIZW2c+sxfksvZBlU8kzoVqIKgpD6j+DjOJbL7J3VbdmOowPl1XNJBegLVuMxJAUub+w+ZgxnwYLUWMYo37PhISF1KEeai7RyKtN0y5t04geqG97gulqwUod7O9yAxI9a6LD0oXWq0bg/OcrPjl+21/uS4Td5TDJvgd3nll+pCB6bZJZqBikGVh3Ek2iD+ax1gfNaNpKRv14mxNJIO6TppnPr3nmYXtKbt4Mb7zJSQWTYU2kXJ+MxiDSIcoZ7tRPxyh0XND6/3bHfYZTMqquVFSztkew=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c983767-5c26-4426-c7c6-08d658804d4c
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2018 18:02:19.8101
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3334
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Make use of put_unaligned_le32() function to pack the wid command buffer
for firmware.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 10 ++--------
 drivers/staging/wilc1000/host_interface.h |  1 -
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 3f3b013..e179a8e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -289,14 +289,8 @@ static void handle_set_wfi_drv_handler(struct work_str=
uct *work)
 		goto free_msg;
=20
 	currbyte =3D buffer;
-	*currbyte =3D hif_drv->driver_handler_id & DRV_HANDLER_MASK;
-	currbyte++;
-	*currbyte =3D (u32)0 & DRV_HANDLER_MASK;
-	currbyte++;
-	*currbyte =3D (u32)0 & DRV_HANDLER_MASK;
-	currbyte++;
-	*currbyte =3D (u32)0 & DRV_HANDLER_MASK;
-	currbyte++;
+	put_unaligned_le32(hif_drv->driver_handler_id, currbyte);
+	currbyte +=3D 4;
 	*currbyte =3D (hif_drv_handler->name | (hif_drv_handler->mode << 1));
=20
 	wid.id =3D WID_SET_DRV_HANDLER;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index 8279345..7a71cb6 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -41,7 +41,6 @@ enum {
 #define WILC_ADD_STA_LENGTH			40
 #define WILC_NUM_CONCURRENT_IFC			2
 #define WILC_DRV_HANDLER_SIZE			5
-#define DRV_HANDLER_MASK			0x000000FF
=20
 #define NUM_RSSI                5
=20
--=20
2.7.4

