Return-Path: <SRS0=+bZT=NF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81D32ECDE46
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 21:11:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C2CC2054F
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 21:11:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="hZ1X4dbe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3C2CC2054F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbeJZFpY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Oct 2018 01:45:24 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:15306 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbeJZFpX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Oct 2018 01:45:23 -0400
X-IronPort-AV: E=Sophos;i="5.54,425,1534834800"; 
   d="scan'208";a="22303986"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 25 Oct 2018 14:11:05 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.49) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 25 Oct 2018 14:11:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p0JEdAz52YYOeXvQWutAxrQu00I2PPlt7EuR3+ozjz0=;
 b=hZ1X4dbeiPagPWPkmVU88CNKZCWB+7ThUCPEWfaj0UhbyLT4azrG5T5gCv90G+HNVgQUgVH0pzdwqWQ6sX+f6x8swPEruj8+71TVzpfJdM2lL76JMFoxnq1CsxuvEOp3kJf9LSzzsv8UaiWT1lBcSJKb9EriPj+aTMViVu9NB4k=
Received: from DM2PR11MB0255.namprd11.prod.outlook.com (10.160.135.27) by
 DM2PR11MB0350.namprd11.prod.outlook.com (10.160.136.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.18; Thu, 25 Oct 2018 21:11:02 +0000
Received: from DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::5cab:d918:f310:6f0e]) by DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::5cab:d918:f310:6f0e%10]) with mapi id 15.20.1250.028; Thu, 25 Oct
 2018 21:11:02 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Venkateswara.Kaja@microchip.com>,
        <Aditya.Shankar@microchip.com>, <Sripad.Balwadgi@microchip.com>,
        <Mrutyunjaya.Satapathy@microchip.com>, <johannes@sipsolutions.net>,
        <Adham.Abozaeid@microchip.com>
Subject: [PATCH 3/4] staging: wilc1000: Don't keep a copy of wiphy parameters
 in the driver
Thread-Topic: [PATCH 3/4] staging: wilc1000: Don't keep a copy of wiphy
 parameters in the driver
Thread-Index: AQHUbKc75vmGJiw8BUq9mnQpKtSO7A==
Date:   Thu, 25 Oct 2018 21:11:02 +0000
Message-ID: <20181025210849.20006-4-adham.abozaeid@microchip.com>
References: <20181025210849.20006-1-adham.abozaeid@microchip.com>
In-Reply-To: <20181025210849.20006-1-adham.abozaeid@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
x-clientproxiedby: BYAPR02CA0030.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::43) To DM2PR11MB0255.namprd11.prod.outlook.com
 (2a01:111:e400:3c24::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM2PR11MB0350;6:Vs0uqNQnB+pf08DO9CK2GjaE+EXn8WTX2fm7yQ1oTs9theBUJ7N6WcAF7jDZKJ8fBgevuoFeIfL/Dchm0+YTsQMllXVB5ppfaGaOfgFroczNOBI7MdRWOd5toHxV5wBXFoR6oSXC/jtS6PH+FpS89SS4GOONTQrFQnxAy4D6cHuVxycor757In1+cKxQlkHPAbkXdZww+Xwu/W90LERTF5hQmH3/bisw9VYeIKYrqqztnOEBKfBCdfcuT/nNdj8hy10LaqtBEkof3LWBt0gUv8lcK47/Xy+68hvEK5mymhdBM9NVTPxfbjOE8twrZq4sbg4S/dD7lTsIf3Pzqi1qih4+3uD1uvB2kwa8HnAD6VpUVUk9Q7//JzD7/7NfTMVS+PFHgbvgkC3K8aT/RJQIJ4WiWp2N8ui4ouq9oReBlmdarEcLy/0a51/sG99ySAPLBqDhlXn50qigL31GwKhT7w==;5:DW+o5qrhXUGZ1Z/T7tfMA6aGfJxHX5rmzYljvbSo7LMknk8+DNnrMEbgeysfS3BNknr31+XK7lNrCTajiLxEqPcg7qjZVLJ1BcgW6ofTkcHJrsUMst4NrVy+xuk6oR87U40x2XOHNC9X4K+cJI8d+BlzUL7NCAGslZc31FQrCXg=;7:3WrtlaT1tdCahXirZkFM9Nn9Bzo8esJvhJfiWLQrCV79gmabtRjzBt1oT0JSA6M/qx0dDlgF1P2v2uMxxbJ8KkdwfZF8dfD2q9K15SVPQ+5/t14s7nelOMUgokk+aSXhyll00JiZqe6PXDztZMXjng==
x-ms-office365-filtering-correlation-id: e92d3d66-b506-45a7-c313-08d63abe5e4a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DM2PR11MB0350;
x-ms-traffictypediagnostic: DM2PR11MB0350:
x-ld-processed: 3f4057f3-b418-4d4e-ba84-d55b4e897d88,ExtAddr
x-microsoft-antispam-prvs: <DM2PR11MB03500B6CABAD0A449BB03B918DF70@DM2PR11MB0350.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3231355)(944501410)(52105095)(3002001)(93006095)(93001095)(10201501046)(148016)(149066)(150057)(6041310)(20161123560045)(20161123564045)(20161123562045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:DM2PR11MB0350;BCL:0;PCL:0;RULEID:;SRVR:DM2PR11MB0350;
x-forefront-prvs: 083691450C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(136003)(346002)(39860400002)(376002)(199004)(189003)(386003)(11346002)(6506007)(2900100001)(14444005)(3846002)(6116002)(71200400001)(446003)(68736007)(36756003)(81166006)(5250100002)(81156014)(2906002)(2616005)(476003)(4326008)(71190400001)(1076002)(5660300001)(52116002)(105586002)(86362001)(8676002)(256004)(478600001)(76176011)(66066001)(99286004)(26005)(53936002)(102836004)(6512007)(54906003)(2351001)(2501003)(316002)(25786009)(97736004)(106356001)(72206003)(6436002)(5640700003)(6916009)(14454004)(305945005)(186003)(107886003)(8936002)(6486002)(7736002)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR11MB0350;H:DM2PR11MB0255.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: jNcwXaTwOdna2ZErHOF9wmawPIWkFqKFvmA36d6FuhLlfnVIo6STGqhwyR4CqNAjAMdq9XyaEnggClq+EbQK05AdrTXusYZO4v0UQ6/fTzw+iZkpGC0elLRgHM+2B2wVqqH3DmizPem3WXVdG8JksNJK2npgwfaYj4tbuMPhxb2nBpH343VvNEApXzXv5iyYRTpukCSYvBugU1AsAk6bhVinVE9l371t8ske8S5cigjF4pRWLzDM6khHDi9HjoiGyZ+QBs+UlYr3EtkbewrIo3V/lXm+zIGpIIpILvTTWN1hknNmMytn+TzEhk73PgFNRfZZ+IGyap37HOtoFAN5UvCs6qp00CwOAtikpQi4u48=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e92d3d66-b506-45a7-c313-08d63abe5e4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2018 21:11:02.4412
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR11MB0350
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

host_if_drv.cfg_values is a write only member, and can be removed

Signed-off-by: Adham Abozaeid <adham.abozaeid@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 13 -------------
 drivers/staging/wilc1000/host_interface.h |  1 -
 2 files changed, 14 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 0bb3b4f6d04e..cdc495287949 100755
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -375,43 +375,31 @@ static void handle_cfg_param(struct work_struct *work=
)
 	mutex_lock(&hif_drv->cfg_values_lock);
=20
 	if (param->flag & RETRY_SHORT) {
-		u16 retry_limit =3D param->short_retry_limit;
-
 		wid_list[i].id =3D WID_SHORT_RETRY_LIMIT;
 		wid_list[i].val =3D (s8 *)&param->short_retry_limit;
 		wid_list[i].type =3D WID_SHORT;
 		wid_list[i].size =3D sizeof(u16);
-		hif_drv->cfg_values.short_retry_limit =3D retry_limit;
 		i++;
 	}
 	if (param->flag & RETRY_LONG) {
-		u16 limit =3D param->long_retry_limit;
-
 		wid_list[i].id =3D WID_LONG_RETRY_LIMIT;
 		wid_list[i].val =3D (s8 *)&param->long_retry_limit;
 		wid_list[i].type =3D WID_SHORT;
 		wid_list[i].size =3D sizeof(u16);
-		hif_drv->cfg_values.long_retry_limit =3D limit;
 		i++;
 	}
 	if (param->flag & FRAG_THRESHOLD) {
-		u16 frag_th =3D param->frag_threshold;
-
 		wid_list[i].id =3D WID_FRAG_THRESHOLD;
 		wid_list[i].val =3D (s8 *)&param->frag_threshold;
 		wid_list[i].type =3D WID_SHORT;
 		wid_list[i].size =3D sizeof(u16);
-		hif_drv->cfg_values.frag_threshold =3D frag_th;
 		i++;
 	}
 	if (param->flag & RTS_THRESHOLD) {
-		u16 rts_th =3D param->rts_threshold;
-
 		wid_list[i].id =3D WID_RTS_THRESHOLD;
 		wid_list[i].val =3D (s8 *)&param->rts_threshold;
 		wid_list[i].type =3D WID_SHORT;
 		wid_list[i].size =3D sizeof(u16);
-		hif_drv->cfg_values.rts_threshold =3D rts_th;
 		i++;
 	}
=20
@@ -3139,7 +3127,6 @@ int wilc_init(struct net_device *dev, struct host_if_=
drv **hif_drv_handler)
 	mutex_lock(&hif_drv->cfg_values_lock);
=20
 	hif_drv->hif_state =3D HOST_IF_IDLE;
-	hif_drv->cfg_values.scan_source =3D DEFAULT_SCAN;
=20
 	hif_drv->p2p_timeout =3D 0;
=20
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index 5f894fe7c896..60cb1a1fee1a 100755
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -238,7 +238,6 @@ struct host_if_drv {
 	enum host_if_state hif_state;
=20
 	u8 assoc_bssid[ETH_ALEN];
-	struct cfg_param_attr cfg_values;
 	/*lock to protect concurrent setting of cfg params*/
 	struct mutex cfg_values_lock;
=20
--=20
2.17.1

