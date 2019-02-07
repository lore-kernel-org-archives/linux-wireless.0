Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C729CC282C4
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 07:22:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89C4F2075C
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 07:22:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="qdUXtz0D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbfBGHWx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 02:22:53 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:10641 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726716AbfBGHWw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 02:22:52 -0500
X-IronPort-AV: E=Sophos;i="5.58,342,1544511600"; 
   d="scan'208";a="23532162"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 07 Feb 2019 00:22:51 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.108) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 7 Feb 2019 00:22:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cFta4Ih6QzZtjVebbTl/H7wybiKCFV5tw/NfcoFHJKM=;
 b=qdUXtz0DDZkaCcq5ZAD0BAbpsECXlf4SqBcqGm51MBLu1DPSMGknK3+Dj8x6nvOGZKwMidziZbP++W9fUSKr48Vu8jsoe1LrJJtFzvjXidHhGgNJQwSZ4P+7aTlTAZwsjUwV2pdTmomaH6ZTKMiRC6zRedynGraecxi1fMRAhiw=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3415.namprd11.prod.outlook.com (20.177.224.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.22; Thu, 7 Feb 2019 07:22:49 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1601.016; Thu, 7 Feb 2019
 07:22:49 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 9/9] staging: wilc1000: rename linux_wlan.c and linux_mon.c
Thread-Topic: [PATCH 9/9] staging: wilc1000: rename linux_wlan.c and
 linux_mon.c
Thread-Index: AQHUvrXuAeZ2YGODBkOlyqiEnqsMMw==
Date:   Thu, 7 Feb 2019 07:22:49 +0000
Message-ID: <1549519927-2651-10-git-send-email-ajay.kathat@microchip.com>
References: <1549519927-2651-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1549519927-2651-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR0101CA0020.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:c::30) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [223.237.230.157]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3415;6:IoqeyU8hdsMcU6LbFDfzUTuIEdAIGPPvGZ8zbCMe+SrWcYbmgfdLvCgCBNVdwyOJAczHnZwBc1XW6Db82yW6tDY0EvKGiALmzlARDJJr6n5k9AecnMOjBGMJ106ZbhHCiB6p0JffOANfdVlOeoHwtZm8bbIHLrvFbBnzBHeUN5K3ChX9ZF7DH2CthYZrmDGI7gU5T5Zp9Bvdi6aF/aUOornuXoCfadK9k3es4ZobyJHCEF0/fvWywCnAh6OqDLucllIRh6jV1h76OHOX0SmZs3gKDrObDceXbZdCI7ZliERcb8N09lhi3uc5lBRPYi3XSrcFB6/xOTHd/f63pVturmHHkx+FCHB7/m7oT2ndcu4BLRv8ZU9jeE9AtPFy1oRTJR9xf9Gjn697MaQRN9kW19I5QJsJI2Vj7jI2qzkbe89UymuAPZSuREKYxFFTF+t5CU6Z7pgCZkJ8TXAxmYoz7g==;5:qFbKcYKKAyZr1Pr1Kc/YhT/QITaZleDKn4RAmbHLoJiGKzBl7/vAccfVo2gxk2Iq53QDNKrCRfHEMgj7Ohwtf1E12DXPN1J+xSTRr7XGqZf9W9G1QBcPvJaAg0YkKAgSHCtVTLe2SNKic6aU41gJFQTrbIRSxNEgXMLMbMrK5SsDukkxjBl8Xk20kRNGp4N6oApy3BsPOZ6GCAah/rDaVw==;7:TDc3KFxaaI3W9xIoQEYTXK9hMrXV01oH8H6RoFj0VdpxHF9ncYksP7khcRR16ZcTRbIOpOhL1nfFpNpsl50maZovagp0u6LzlvHig4BjofOSrU8t1oGF6Jl+vz612BJQ9YgvaWTxf034IW7bz0baWg==
x-ms-office365-filtering-correlation-id: c76e276b-bb34-4a3f-58ab-08d68ccd1070
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3415;
x-ms-traffictypediagnostic: BYAPR11MB3415:
x-microsoft-antispam-prvs: <BYAPR11MB34151DC43511B1F1EE2131D3E3680@BYAPR11MB3415.namprd11.prod.outlook.com>
x-forefront-prvs: 0941B96580
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(136003)(366004)(396003)(376002)(189003)(199004)(86362001)(5640700003)(478600001)(6116002)(446003)(3846002)(72206003)(6486002)(11346002)(6436002)(25786009)(2351001)(2616005)(476003)(6512007)(105586002)(106356001)(486006)(26005)(6506007)(102836004)(386003)(36756003)(71190400001)(2501003)(97736004)(71200400001)(81156014)(305945005)(66066001)(54906003)(4326008)(186003)(68736007)(8936002)(81166006)(107886003)(52116002)(50226002)(53936002)(256004)(6916009)(14444005)(316002)(99286004)(14454004)(2906002)(76176011)(7736002)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3415;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kmpMxtbLe7kXKMj+TtDeMsLu78450zSNIuwCAfY0AzLqh3fjwZ0NpRwTWxuV1gUbcgBvUgZ3Qjlaw3XhtECjlpmtZGrFBzfUOPlwmr0C+o4hiFe6IqD4huFwW9j5Hh8y+EUUGUCVXHeqaJLfZiKzMIkW5DVn82fC3/cfCTzmwFPNdHxlYF2wb4d65715wbIq6CGRL3QfhuNjzy8Ic4vyFSXg2iZ1Cf4YUzVHPgAOD9k2qQ2Cq6PaVhkrN1yV5aMLGmzdfBDN/kWM5inYXWZL2Z5bY7CyIIjDl3b0RQPsUQCjIyujdpDmdo+q95InjeX9Jvwfsdt8MfVWt/sZgbvtrJFOPE8NxQ7x4eKU2GYuvpK60+fmcnTNUg2v+JRK/w5R2UlNxAfbPH4m2w3RDt0KOLYNXNZfEpsh//ZAj0PPcW4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c76e276b-bb34-4a3f-58ab-08d68ccd1070
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2019 07:22:46.8820
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3415
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Rename linux_wlan.c and linux_mon.c to wilc_netdev.c and wilc_mon.c to
include 'wilc_' prefix.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/Makefile                        | 2 +-
 drivers/staging/wilc1000/{linux_mon.c =3D> wilc_mon.c}     | 0
 drivers/staging/wilc1000/{linux_wlan.c =3D> wilc_netdev.c} | 0
 3 files changed, 1 insertion(+), 1 deletion(-)
 rename drivers/staging/wilc1000/{linux_mon.c =3D> wilc_mon.c} (100%)
 rename drivers/staging/wilc1000/{linux_wlan.c =3D> wilc_netdev.c} (100%)

diff --git a/drivers/staging/wilc1000/Makefile b/drivers/staging/wilc1000/M=
akefile
index 72a4daa..2ad3fee 100644
--- a/drivers/staging/wilc1000/Makefile
+++ b/drivers/staging/wilc1000/Makefile
@@ -4,7 +4,7 @@ obj-$(CONFIG_WILC1000) +=3D wilc1000.o
 ccflags-y +=3D -DFIRMWARE_1002=3D\"atmel/wilc1002_firmware.bin\" \
 		-DFIRMWARE_1003=3D\"atmel/wilc1003_firmware.bin\"
=20
-wilc1000-objs :=3D wilc_wfi_cfgoperations.o linux_wlan.o linux_mon.o \
+wilc1000-objs :=3D wilc_wfi_cfgoperations.o wilc_netdev.o wilc_mon.o \
 			host_interface.o wilc_wlan_cfg.o wilc_wlan.o
=20
 obj-$(CONFIG_WILC1000_SDIO) +=3D wilc1000-sdio.o
diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc100=
0/wilc_mon.c
similarity index 100%
rename from drivers/staging/wilc1000/linux_mon.c
rename to drivers/staging/wilc1000/wilc_mon.c
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc10=
00/wilc_netdev.c
similarity index 100%
rename from drivers/staging/wilc1000/linux_wlan.c
rename to drivers/staging/wilc1000/wilc_netdev.c
--=20
2.7.4

