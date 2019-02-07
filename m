Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD5D5C282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 11:29:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78DB621872
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 11:29:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="l0j2lrR7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbfBGL3Q (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 06:29:16 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:42850 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726579AbfBGL3Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 06:29:16 -0500
X-IronPort-AV: E=Sophos;i="5.56,564,1539673200"; 
   d="scan'208";a="24333100"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 07 Feb 2019 04:29:15 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.38) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 7 Feb 2019 04:29:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=98kKb+2IOwm90KtFhwshOoR1ugCm5DzbEeOOCSGawd8=;
 b=l0j2lrR7KgCy7wX6kBFrLAxdR8b8KC0ueyUxGuUMa0mpO318msKKLl3Zne7CnIlnpxU15uacAVwklGBHehVNFeJ7tJYqc7fG24NThK09VSkbU8sFPcUaXOaFHDymWh/qSHzADduNOEeifNprYKM6MTgAq0HF1MUOG/y1OTbn/ZE=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2792.namprd11.prod.outlook.com (52.135.228.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.21; Thu, 7 Feb 2019 11:29:14 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1601.016; Thu, 7 Feb 2019
 11:29:14 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH v2 6/8] staging: wilc1000: rename wilc_frmw_to_linux()
Thread-Topic: [PATCH v2 6/8] staging: wilc1000: rename wilc_frmw_to_linux()
Thread-Index: AQHUvtha4pLUB6XpJ06E/z7QA1/Eeg==
Date:   Thu, 7 Feb 2019 11:29:13 +0000
Message-ID: <1549538913-17463-7-git-send-email-ajay.kathat@microchip.com>
References: <1549538913-17463-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1549538913-17463-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR0101CA0060.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::22) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [27.59.126.210]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2792;6:Lb3a/Tb9zIyfR7eb+FzqguJyoPpfRZs+mrZEbSuxBR+LpAWRC8QGcFPyxxF8YpeEXpP/PVS1fMAq5MHpGy784cnChhFEpt0NEapsCDuWFnVqySTGk6USZzEJsaMuuNZ7WWWR0T2QKEN+y579TWD7gAcMmdRMCpEHOPt5cMbbt+Eg+2qyLzGXZIw7w7CQZwHyWfG2oPxLghevfwscb/M8vBaPF95ymWolMqjLmSDdivnDj9OKTjUEe6+97Ge6M9CSDrgXDeFp/aFpVdi2oEiqMX1XiseOciWyegnuI/93/LKMK+9PueSN09oXGoHoRsguEnywhCbJ0xoCjFmMqiPbLkrIRWChcoGVCQREP6hoHx2yU3lRGRHLv4czJahR0aPI9Y35O7StSkyGweeT9pDseyxaLRM9IcVcIsFphKbiB1DYwS9MNeaiJIJFUHCSLZQseB1mmlJjpjwxuIdQfiluNA==;5:Xh/pO9fXV7JTiOMvbfJqns7oyia7YoWzfwYtCfIYHGII7bnDwDFW+s3lurwsA1rPiLmAmO4mjs8KpLeaJFFuRdO1ddpnHxKzwfCwynJKtxC39K0TUSArsHweP9AnNsB+csK/42JJX2kAzgPT1egk2MuoekViP91kEGAW0xLPsGYpuRw0BKlYxFbW4xmt/8ihI/dCWYZRtVUoLJ34jjjGXA==;7:+UAd8Vz9QYqK5+0y6EeK65ACYTb7/FWPfp2OJN4+IIJOvpl6nmyqCZCW6sGXDYsPyJp6GyQ/JkRPC3lcGhw5a2YgjOYYFXKZtfgCApdcW9LYQCUpgjEvCLQiXxSnmYJieP6V8Nn/3h5pUCpU0yODcw==
x-ms-office365-filtering-correlation-id: 3f6efb14-4709-4bf2-759d-08d68cef7cb6
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2792;
x-ms-traffictypediagnostic: BYAPR11MB2792:
x-microsoft-antispam-prvs: <BYAPR11MB2792019FA79F913F38485966E3680@BYAPR11MB2792.namprd11.prod.outlook.com>
x-forefront-prvs: 0941B96580
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(346002)(366004)(376002)(39860400002)(189003)(199004)(2501003)(256004)(14444005)(7736002)(68736007)(107886003)(81166006)(81156014)(305945005)(186003)(8676002)(8936002)(66066001)(50226002)(97736004)(52116002)(4326008)(11346002)(86362001)(316002)(25786009)(476003)(2616005)(54906003)(478600001)(6486002)(105586002)(486006)(6916009)(106356001)(6436002)(14454004)(6512007)(53936002)(2906002)(2351001)(71200400001)(71190400001)(6116002)(3846002)(386003)(6506007)(446003)(76176011)(36756003)(26005)(5640700003)(102836004)(99286004)(72206003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2792;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NnRIa4u2wKk8kSrtlEXxwNOQSO8GWBRp6jpujP1GZyAzKiFNxnkhPfT4NDsrUYVlL2YyHgVo7jpx4TKBgULbyBazxjD7Mc8qP50BwOa3PQuWia72ChMKZAu0d5QzzgVxiN1ECvWjTqFgJ6LONGz+cngnJPEo+YvPY3/XEC7DjQxTyDE3LFMILR0Yl6eczaGVURKYQ72PoYZTsLsvAmY4pxwmhRK68WF41JzPH0kM120SFI43SVNrJDqdT3c1BciTKc8Iusl4ZDtHuN8GYE0/kxtowV8ORDmyAiFZ4U2TM6dJs2W5ST2+XG0rsKf+aS30p78yAtZMiSLX8YPl1dzre/99axfLcHXUwpME7CoUJZZn2XfiuH676kZFixm6H8QhWRKrJqOriy5znw2OTKA3eE125HcT2ItfOADpCnL1Wnw=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f6efb14-4709-4bf2-759d-08d68cef7cb6
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2019 11:29:11.1280
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2792
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Rename wilc_frmw_to_linux() to wilc_frmw_to_host() to be remove the _linux
suffix.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c         | 3 ++-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 2 +-
 drivers/staging/wilc1000/wilc_wlan.c          | 5 ++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc10=
00/linux_wlan.c
index 1ebf2b8..1e2f6f4 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -803,7 +803,8 @@ static int wilc_mac_close(struct net_device *ndev)
 	return 0;
 }
=20
-void wilc_frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_off=
set)
+void wilc_frmw_to_host(struct wilc *wilc, u8 *buff, u32 size,
+		       u32 pkt_offset)
 {
 	unsigned int frame_len =3D 0;
 	int stats;
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/stagin=
g/wilc1000/wilc_wfi_netdevice.h
index 2b9b8b5..df00762 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -281,7 +281,7 @@ struct wilc_wfi_mon_priv {
 	struct net_device *real_ndev;
 };
=20
-void wilc_frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_off=
set);
+void wilc_frmw_to_host(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offs=
et);
 void wilc_mac_indicate(struct wilc *wilc);
 void wilc_netdev_cleanup(struct wilc *wilc);
 int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc100=
0/wilc_wlan.c
index af1c4d8..c238969 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -717,9 +717,8 @@ static void wilc_wlan_handle_rx_buff(struct wilc *wilc,=
 u8 *buffer, int size)
 		} else {
 			if (!is_cfg_packet) {
 				if (pkt_len > 0) {
-					wilc_frmw_to_linux(wilc, buff_ptr,
-							   pkt_len,
-							   pkt_offset);
+					wilc_frmw_to_host(wilc, buff_ptr,
+							  pkt_len, pkt_offset);
 				}
 			} else {
 				struct wilc_cfg_rsp rsp;
--=20
2.7.4

