Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7C3DC0044B
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 05:45:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E27E21527
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 05:45:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="Mg19aqTO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E27E21527
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731338AbeKLPhO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 10:37:14 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:20249 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728269AbeKLPhO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 10:37:14 -0500
X-IronPort-AV: E=Sophos;i="5.54,494,1534834800"; 
   d="scan'208";a="20255123"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 11 Nov 2018 22:45:34 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.108) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 11 Nov 2018 22:45:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7wzuC8+kEr4xYfvgZkUZGsqSxnyi5pGfwXBSOE8Dnj8=;
 b=Mg19aqTOlGQbUcZ3uUQdHiTJ+EZVbyObPzCotapXQnfZgPJq4AG/2Zn2/ZcaQmQAQj9KPe12KP67lN5M3pmpB5C2Kbyz9SsV83+wl38PZHNtX/VhOXQD5e2WYeUe1VUHWfUqkEBgPJfJGC+d4fHIypmmbSUNEcCNr//TXv2ErTY=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2599.namprd11.prod.outlook.com (52.135.227.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.21; Mon, 12 Nov 2018 05:45:32 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7%6]) with mapi id 15.20.1294.044; Mon, 12 Nov 2018
 05:45:32 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 11/12] staging: wilc1000: use ENOBUFS error code instead of
 WILC_TX_ERR_NO_BUF macro
Thread-Topic: [PATCH 11/12] staging: wilc1000: use ENOBUFS error code instead
 of WILC_TX_ERR_NO_BUF macro
Thread-Index: AQHUekrtislktLPEfUqSa2LzX+QlZw==
Date:   Mon, 12 Nov 2018 05:45:32 +0000
Message-ID: <1542001458-20217-12-git-send-email-ajay.kathat@microchip.com>
References: <1542001458-20217-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1542001458-20217-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR01CA0135.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:35::29) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [27.59.94.109]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2599;6:BtKOIJXiEUgcsMbh6QpFyk+8yW2ESX5F2EeZeo7S8iNAbbYEs9BuFwvDpZGYGPeVlsCbrhjyyfceDswVIpcmYbaPMO3Hmax/LW4M7bBr1C1SC/WZ0TUPfEHTRJ3RefSdgt+uJgi9o80tcVUMGTqneVvQz5t12l5OfNuwLpFa4zEZIYf80XFn9K/qO60QrbiG4ge1g59mk5izxNUjHQ5BhySMuuZ8FNxliS9Qt4Q4fQXDxU1HBf52rxgnkNBiBS77kgpnLlVl60ygk3qgOdc5gFg5AMWAyKaP1E0BH0ZTZ4eS8PBUUA55R9UGWgXmhMo0Wc/9hOMo9bzLR7pYMW7Cr34O8yegrIVrgZ1+QnLlujB+FFJgLiB4wGuZdv0ToWFpaKxwiQ4Q1vqZMtD2Jl91zNWpxhYV0IxXX+a/rUThGcNaz5H0nd+V7sxckly4WQu2n/I2d2SH6N4VwcbAc+E2+g==;5:J1jKZdK2/R5hd+YlehEN6lzRsUNbe/t0Xed7/W80ws9ubOc2/g5qiZ5UUqZNQQ1woulflnHbGLtNOC6g2SDJJEBdD6IJP31LOCnS4dV8gX33hUQ9N0ovDzdLGweCwDdK6UEXbw+Vr9iRnaHb2l2FFy6kbOx8OKqUUuqaHU4czrk=;7:sNFWozdXXvOh61QJ4SQb8Kae2V7p6xi2F8c28CpUSLH2LRP72ZTombBdlGffUMjURcr3V/9snaQG40rFgMkWbHV3m41UsfCAnVLfQ6860RUO7LKAKt5XCx8xxgV7Q4AwwK6n+zc9qWKVFXjAeWy6WA==
x-ms-office365-filtering-correlation-id: 0aff0706-7b53-4fc5-1cf2-08d648620f5b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390040)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2599;
x-ms-traffictypediagnostic: BYAPR11MB2599:
x-microsoft-antispam-prvs: <BYAPR11MB2599933FA293A9D3E47E1D53E3C10@BYAPR11MB2599.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3002001)(3231402)(944501410)(52105112)(10201501046)(93006095)(93001095)(148016)(149066)(150057)(6041310)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123562045)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB2599;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2599;
x-forefront-prvs: 0854128AF0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(136003)(366004)(39860400002)(189003)(199004)(4326008)(25786009)(2906002)(6116002)(3846002)(72206003)(26005)(2351001)(14454004)(86362001)(575784001)(186003)(6436002)(478600001)(6486002)(105586002)(76176011)(106356001)(2501003)(107886003)(5640700003)(54906003)(52116002)(99286004)(102836004)(53936002)(14444005)(256004)(6506007)(386003)(316002)(36756003)(486006)(8936002)(6916009)(11346002)(7736002)(305945005)(476003)(2616005)(68736007)(8676002)(71200400001)(97736004)(5660300001)(66066001)(446003)(81156014)(81166006)(6512007)(71190400001)(2900100001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2599;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: eKpgD0Gb3gBm6Cbf8gw5IqpoewV9KqEIRywhykFzjxXQ9hfY+lgvcUrr7vFHQB+UXXvTW4/Sb4HvWadHqKdV1TfTmcWbUZQHwlkTM/FmUtW9hRXUknWATPUD+Y+7F5lXkQC5ioHEM/ILPgxWe0E7cCleeXvdCwoqwYTk+2HTnQGDYC/I318fwKxxfcMUrANmHA75HeqKJtWV1QOze6UmS42dT2iZTEQg1gTCaybh/twYG1LmVMkfwbACERJx2mSu+fV47+lKpTM28/lRJKLBEXOaLOfDgBUyyPO8g/w5p5c/+mKoRaXDZkLzHuV/QTKEkmBoi7cxc2dDJcYqLSqosID61tBmat0LWPBN4T56SDo=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0aff0706-7b53-4fc5-1cf2-08d648620f5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2018 05:45:32.3740
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2599
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Make use of 'ENOBUFS' instead of WILC_TX_ERR_NO_BUF macro. The value of
WILC_TX_ERR_NO_BUF is -2, which is confusing with ENOENT error code.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c   | 2 +-
 drivers/staging/wilc1000/wilc_wlan.c    | 2 +-
 drivers/staging/wilc1000/wilc_wlan_if.h | 2 --
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc10=
00/linux_wlan.c
index 96d8834..66fb988 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -242,7 +242,7 @@ static int linux_wlan_txq_task(void *vp)
 				if (netif_queue_stopped(wl->vif[1]->ndev))
 					netif_wake_queue(wl->vif[1]->ndev);
 			}
-		} while (ret =3D=3D WILC_TX_ERR_NO_BUF && !wl->close);
+		} while (ret =3D=3D -ENOBUFS && !wl->close);
 	}
 	return 0;
 }
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc100=
0/wilc_wlan.c
index 563ce62..f0b10e2 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -611,7 +611,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *t=
xq_count)
 		goto out_release_bus;
=20
 	if (entries =3D=3D 0) {
-		ret =3D WILC_TX_ERR_NO_BUF;
+		ret =3D -ENOBUFS;
 		goto out_release_bus;
 	}
=20
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc=
1000/wilc_wlan_if.h
index f4f6ac6..e2310d8 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -41,8 +41,6 @@ struct tx_complete_data {
=20
 typedef void (*wilc_tx_complete_func_t)(void *, int);
=20
-#define WILC_TX_ERR_NO_BUF	(-2)
-
 /********************************************
  *
  *      Wlan Configuration ID
--=20
2.7.4

