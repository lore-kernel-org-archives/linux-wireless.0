Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10FBAC282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 07:22:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C582B218FE
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 07:22:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="f3toPomu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbfBGHW6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 02:22:58 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:16865 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726716AbfBGHW5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 02:22:57 -0500
X-IronPort-AV: E=Sophos;i="5.56,564,1539673200"; 
   d="scan'208";a="24326887"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 07 Feb 2019 00:22:46 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.106) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 7 Feb 2019 00:22:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kNnwY4emWFsk6h1eKIox74sx1Q5Vgw1dkwXssaFQ5uE=;
 b=f3toPomujT7Lc4D7jmEACdZ/vjXSmC2lEHGtBR/zhcnH/qdhRzcpm55eupKF+I3rmGs5DTrNaBcU2XasR1E4Joc3m2V4KedsSaSMiSzM0Rz8P/eV162+V54VeNxMMM/rJRKMTtTctMc8HEETk6gpwLAho/TtaSUBfddphScOg1o=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3415.namprd11.prod.outlook.com (20.177.224.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.22; Thu, 7 Feb 2019 07:22:43 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1601.016; Thu, 7 Feb 2019
 07:22:43 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 7/9] staging: wilc1000: rename wilc_frmw_to_linux()
Thread-Topic: [PATCH 7/9] staging: wilc1000: rename wilc_frmw_to_linux()
Thread-Index: AQHUvrXqGKYGCUK3j0G8hXKKN7xW+w==
Date:   Thu, 7 Feb 2019 07:22:43 +0000
Message-ID: <1549519927-2651-8-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3415;6:aLAACmdCdyWcMWTJSKcNbOC9etGzDUcv1P+X0BdwfYwpAGo1Qs4WXx1AxgiRD/tsJMLhhfSsQjFPSRkcPTerynzi2olswCdYudFWrAhzkZyenAt9vrks9ZDEFpss3CsBXwVSRmASOnQ78sSbDXNwIAD7Qt/w0m/L/akkQpXPwSlKdfoQm1Y94mf9kYf5xonCLOwyhjTnJ82m3f3t5+4Z6+NydmO2487nWVvcgxiXuALBKv/AOX9ULeHUtICU1cH+chXSWG0H1b4Tll0fisGusCDeKL2cCZWdGtlo+gBrjk1UyALGcgTNPGWU6im4H9OIlk/lwDXr92pdjBjksRsMq+KzsIrfT3V1WXQm84VV6kqutxSZJ859blX3EoWtZi5I3K5ARtAnrLeqc+dEZKNfCEB0gUUCGvTfEMsS2lyhzPHBUXF6OS8RqtNVau37tyGv6hbqzvXkhG0EMSm3NhA8QA==;5:tKUVqvO1dMjGviYeY2pUzKVhrQv9xtq7Oi4yNXTbNHSnz3cNOCLsPH43F0S3qcQ4o2siv4JW46d+1vX9Ou0NXNYpOpS6itQPG7JMGAs11KUUn1QqTyVsED+IBtWr2r71WOPzv7RIOa2gF61H2SuYvGHXZE4suc6WWwl8qM9ymZuN+lkLWhvLuTBt8q+niidHIUMj06XDyjgFdpnZ3unu4Q==;7:TGzvWqMnsFbTUJWs5cQTuiaZGVGFGpEdwK+4bZL2CXx+r1uwM2YAyls7ziwNp53+cN3OafdsCaB2WAop1M0cU3ROHaLoHpxB0MWULtd5OD5t21A2oIX2uxAX44Hlu6FKF6vGDgg5hAExMTthFeV3kg==
x-ms-office365-filtering-correlation-id: 5fb8cc53-5649-481f-772c-08d68ccd0c8c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3415;
x-ms-traffictypediagnostic: BYAPR11MB3415:
x-microsoft-antispam-prvs: <BYAPR11MB34155A346449152063D983B7E3680@BYAPR11MB3415.namprd11.prod.outlook.com>
x-forefront-prvs: 0941B96580
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(136003)(366004)(396003)(376002)(189003)(199004)(86362001)(5640700003)(478600001)(6116002)(446003)(3846002)(72206003)(6486002)(11346002)(6436002)(25786009)(2351001)(2616005)(476003)(6512007)(105586002)(106356001)(486006)(26005)(6506007)(102836004)(386003)(36756003)(71190400001)(2501003)(97736004)(71200400001)(81156014)(305945005)(66066001)(54906003)(4326008)(186003)(68736007)(8936002)(81166006)(107886003)(52116002)(50226002)(53936002)(256004)(6916009)(14444005)(316002)(99286004)(14454004)(2906002)(76176011)(7736002)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3415;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ATEi1bP3xsrNMdO56LfhuhKI2Kb0mEG/GEdRzFqQBXx2PVpk+mO3tLFP3V05YGvTyxwQB5ZYJjQ8hNAtxj2czYfQ54bulEY5wg33N/kn0h/yjcJUpfDyK85Y/lva9CachY0P2/UFqWHQDL9q7vw+n1nP+T4tu9k6EIkx+nSWT8QyKlihiXNlT2rptx1tAMXx2/MpuB3lAzOTr3mjY5OkCQiGjenvGrwb5onpRJBsFtdXHnGGxC0o25oVdQgB6W+nLctV7QTnRmhsTEXNRTvjZZ4wBdoT/ohSkAj9TE5cAGLiSvw/o58T5INuajwsfr36Nn5jQAd0lI4SOMXMSxl9tW46li8+FPqJbpvDouwzc80swgyjk2HGyZwiDEofl1tC4Z5Ajdu4qApkf6Jau/huJVhWW5MQYf6qdm1wWRDLy6w=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fb8cc53-5649-481f-772c-08d68ccd0c8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2019 07:22:40.3454
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
index b279811..533e444 100644
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

