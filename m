Return-Path: <SRS0=RZRw=QM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDA6DC282CB
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 07:15:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A32312081B
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 07:15:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="bxXqHD//"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbfBEHPv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Feb 2019 02:15:51 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:40026 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfBEHPv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Feb 2019 02:15:51 -0500
X-IronPort-AV: E=Sophos;i="5.56,562,1539673200"; 
   d="scan'208";a="25864249"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 05 Feb 2019 00:15:50 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.105) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Tue, 5 Feb 2019 00:15:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k074ym7KmObrCIsuMvbBa3oFwhGPtudy9pakRN5sfpw=;
 b=bxXqHD//MvwLreLh1zUUyQEYDBSTTytT9Qg4AIqJF1nh1q3Eo7PShC6DYKOUIJTu2crnJk96xqyld0WSKdyNnVikQ8/Q07xjCd57WuWNqqUUJiybJme5Nu+sQatmDZKQIBdhE1CXLCbwy82cS6HCyiBI8KQWBGBNaTGY+ABrXLQ=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2984.namprd11.prod.outlook.com (20.177.224.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.20; Tue, 5 Feb 2019 07:15:48 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1580.019; Tue, 5 Feb 2019
 07:15:48 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 06/12] staging: wilc1000: add check before performing
 operation on net_device
Thread-Topic: [PATCH 06/12] staging: wilc1000: add check before performing
 operation on net_device
Thread-Index: AQHUvSKexLDCLg1O/kCWQYxf7/PrOQ==
Date:   Tue, 5 Feb 2019 07:15:48 +0000
Message-ID: <1549350913-645-7-git-send-email-ajay.kathat@microchip.com>
References: <1549350913-645-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1549350913-645-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR0101CA0066.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::28) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [183.82.17.42]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2984;6:3CZCu1eBgYksDPjIMrK23CYszQPS7LCKUcyGRhvSAMdq6Eqkj/UmcHLAz41LyqVWrYTvIHlqkYcpQduihNQMz4PMBAtQICEn/ytRdnaUeqa2B5Opj5mNZEhwBh2UTxZ8eD4S0zAA5X5JCLTN0lMNNCDQFaphMOaOrrkMc/uwScWLCawQZeWeFHeXCyPYaFG6/RWX1lPAFropa71pL7S+CYAdieJRHfLLe98XxcAGtTvhWxfBObH/wd51Qk8y6Gdfdg1UvR2MexVbvFo3iU/BHBTUbt9zG/CeW+xmAR2Fe5SPH0/L4IJLcdcH75otQZb2vFzPv0EIAVwxOXiY2SU+f8vJeCJ34oqFj3tYVmCHZc1OHuQCBYiVtnp7lD2DrHYPGQ/sLp+dfSCTIxeM+FtfhKCGLta1NnkMlnU69P0ix1EEHglLSaxIOr4IE4J8A1cMl1nW33RSak/qCUMc3LoffQ==;5:v/x/RBlRfp3aMIt+OdVDUYl1jH9kR6qJSPiUcbqoDhSY6OnfjQqEPlcWtYs73QMP0JBbeRE9HVuYYe5RRqcmEdS+ZlpTVOnQYTw1/s4I2fNA/CGUGuemamdFsXGD6ptW8tH5brCPxMhimzMwj+p1zfeG59Pwas7xVfwzhpXI28wIJqXokRZk9FX7toxbM4on8o02bTXLi+zzKy42uojyfw==;7:8awTMcb6Vrma/xrdTn0iiHO4rylZvJpNdDXhkpBiw8fsk4YWcaz02D61nsZ2LO+5BU4YS8JJn6AmbcmS4MhkNT66nYl6yzStpJgoAY22fGrYL07Y6sDxVwAPmZW9dajZvjyOGzHpUnLJ0dYyk8c49w==
x-ms-office365-filtering-correlation-id: 6edd0b62-f940-427c-cf1d-08d68b39c0de
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2984;
x-ms-traffictypediagnostic: BYAPR11MB2984:
x-microsoft-antispam-prvs: <BYAPR11MB298425B47D892257458B4784E36E0@BYAPR11MB2984.namprd11.prod.outlook.com>
x-forefront-prvs: 0939529DE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39860400002)(376002)(396003)(346002)(136003)(199004)(189003)(4326008)(36756003)(386003)(6116002)(3846002)(102836004)(14454004)(68736007)(97736004)(11346002)(78486014)(316002)(2351001)(5640700003)(478600001)(25786009)(6436002)(53936002)(71190400001)(26005)(71200400001)(6486002)(106356001)(72206003)(6916009)(446003)(8676002)(105586002)(305945005)(6512007)(186003)(6506007)(7736002)(486006)(476003)(66066001)(2616005)(8936002)(107886003)(52116002)(81166006)(81156014)(76176011)(2501003)(50226002)(256004)(14444005)(99286004)(54906003)(2906002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2984;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6AyXDrvr2yj9tADXZz7jjZ5a1NnGiHxdS1gpzPmXptB3DOHK3wHKDWcEloWwbpfPx/M7iXMStvpQM5sJ/5GWjl7k6sGqczH41N4zwLf0MHpnKjAA13DKNML0qNbfUElkLAb4NOv0vVQgX7PJy3FGZ46EAL0ySaoA+VohMQGrK8Mg04SEGTRkYXWXxnbRSLxi3aV+GUjN8Mmt5ELkrau9OEVB+fZt1IjK6IZqU1JksLoiJKEi6orJT1dOUX/U6rUs/snyy3oSea2fo+eH9pu8Sat6UAvNIGF/CD82s2Oid0PrPMIRICGfNpvqQP7FXXNHX4sMmC3CUBZHiZjol8m7Nq+ciGbekAcnZjafuX3B/uIpu59usoBQy+m3juoYpGSI7YJxmGX+3ZiIUEuBG05SeCC2g0aC9l30brA0zFEQGvo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6edd0b62-f940-427c-cf1d-08d68b39c0de
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2019 07:15:46.5164
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2984
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Before calling an operation on net_device check if that interface is
available.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc10=
00/linux_wlan.c
index 56272b3..f096f9e 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -159,9 +159,11 @@ static int linux_wlan_txq_task(void *vp)
 		do {
 			ret =3D wilc_wlan_handle_txq(dev, &txq_count);
 			if (txq_count < FLOW_CONTROL_LOWER_THRESHOLD) {
-				if (netif_queue_stopped(wl->vif[0]->ndev))
+				if (wl->vif[0]->mac_opened &&
+				    netif_queue_stopped(wl->vif[0]->ndev))
 					netif_wake_queue(wl->vif[0]->ndev);
-				if (netif_queue_stopped(wl->vif[1]->ndev))
+				if (wl->vif[1]->mac_opened &&
+				    netif_queue_stopped(wl->vif[1]->ndev))
 					netif_wake_queue(wl->vif[1]->ndev);
 			}
 		} while (ret =3D=3D -ENOBUFS && !wl->close);
@@ -761,8 +763,10 @@ netdev_tx_t wilc_mac_xmit(struct sk_buff *skb, struct =
net_device *ndev)
 						linux_wlan_tx_complete);
=20
 	if (queue_count > FLOW_CONTROL_UPPER_THRESHOLD) {
-		netif_stop_queue(wilc->vif[0]->ndev);
-		netif_stop_queue(wilc->vif[1]->ndev);
+		if (wilc->vif[0]->mac_opened)
+			netif_stop_queue(wilc->vif[0]->ndev);
+		if (wilc->vif[1]->mac_opened)
+			netif_stop_queue(wilc->vif[1]->ndev);
 	}
=20
 	return 0;
--=20
2.7.4

