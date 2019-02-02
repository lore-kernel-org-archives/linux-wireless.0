Return-Path: <SRS0=M3au=QJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0620AC282DA
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Feb 2019 19:17:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCFA32082C
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Feb 2019 19:17:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="DJttGnmu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbfBBTRd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 2 Feb 2019 14:17:33 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:12688 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbfBBTRc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Feb 2019 14:17:32 -0500
X-IronPort-AV: E=Sophos;i="5.56,553,1539673200"; 
   d="scan'208";a="26232224"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 02 Feb 2019 12:17:32 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sat, 2 Feb 2019 12:17:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0rD8q1TvEEJzeu3bKWT4Ee8PA2kJlveTAu2c5KRG+1U=;
 b=DJttGnmuyQD92+kuFiyB22unH1z7alUvGfG7wmy65R1UwqxqZRgzrDSWDFXGLu9IbrX2hXbUswEmoj88JsyCMgESuU0l/zLHUsw+HgOV93tbSAIwt1Cr9ijQ4s8cu5my0rMU92RnHV+5hwNzs2wQuZGeq2pPzNlyvopJ4ZvD4+4=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3638.namprd11.prod.outlook.com (20.178.237.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.16; Sat, 2 Feb 2019 19:17:30 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1580.019; Sat, 2 Feb 2019
 19:17:30 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 14/15] staging: wilc1000: add check before performing
 operation on net_device
Thread-Topic: [PATCH 14/15] staging: wilc1000: add check before performing
 operation on net_device
Thread-Index: AQHUuyvxuHI7bB4sBkqwbIAVUUsm1w==
Date:   Sat, 2 Feb 2019 19:17:30 +0000
Message-ID: <1549134974-5545-15-git-send-email-ajay.kathat@microchip.com>
References: <1549134974-5545-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1549134974-5545-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR0101CA0011.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::21) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [49.205.218.11]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3638;6:8nGV0KRSdHeu6RJ0DXE9GARoh79TvoWWhD000QaRU3dG+KaMpd0fQQnpW67RQs0OtEFpPVoe83Z0QriSTiLWl9NLJbG7FIt812K2LWhrNAP+OS2DbA2ijdzdjn38cfuB58PvokXCdm6PTMgGmEDdhrcLi/3wFKhzq/c1xOtv2dCuxH6UhrqVb5aHYqsCevMt5+/TkdusZlKHCLZO0iOxSfRLQHT7RlircxTIXS4/jepN/2+wTQ5yXYbfarcQPF8C63Cq82u4Y14umjLaFwxZBpgQ+8UKM7DY8dE2BBr9hsO8qnGijvv1QZCHOn4g6L4flXzhKf7Bk3o0SOb+0Qo+fbWo0gyXHVhYs7lCgEm58TZ3rh0ukPrQbGIpLGCNqAo2yNFq8i3nh9yukCdpqQ0U2nMgt21wXhvcRp6l1b4shukHpAsewf8expksApTu4oGfl+1XBH5h2ylXLMk7AYcHiw==;5:wAgSLcw5xnKJUvIM5tEtqtL8Es+p0bY0NFr3tkrhDbaLWgpXJfxmsXM6EtVTMKfo30BemNhJiD8kotsGdhpZKcpTXDWqbTBp+y7DVvr/2J+saXA5M23FWgYJstaEVrxtnZVeQ+xF6Qvw+t4NNtDwi8ahFDlrcCFds+e5U86oWX2pYlQZoFEvt8BI+ToPG8zolTmy1pX+vZfNfGneExrGpw==;7:yFC4CwBQDzeRZw8l57CPV8SpYEpI00AkIcjXugAde23J5CIhkeiTNUBm+tCPtDDj6znE0rayaL4L3y1+OR+VokmWy3DQ1EyELoIqFWP+raGPNRhQ6YXKToaEjMv8+LGRvRiC9e3eZcck95YK+ndNfQ==
x-ms-office365-filtering-correlation-id: 33f7d85c-39c5-4ac5-f43d-08d68943138f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3638;
x-ms-traffictypediagnostic: BYAPR11MB3638:
x-microsoft-antispam-prvs: <BYAPR11MB36384490A2410C3F1F722F92E3930@BYAPR11MB3638.namprd11.prod.outlook.com>
x-forefront-prvs: 09368DB063
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(376002)(136003)(346002)(366004)(189003)(199004)(26005)(478600001)(7736002)(186003)(105586002)(106356001)(2351001)(476003)(6486002)(446003)(2616005)(486006)(6512007)(66066001)(11346002)(2906002)(14454004)(6436002)(72206003)(71200400001)(71190400001)(386003)(6506007)(5640700003)(2501003)(68736007)(3846002)(97736004)(102836004)(6916009)(36756003)(76176011)(78486014)(25786009)(107886003)(81156014)(81166006)(4326008)(86362001)(52116002)(53936002)(316002)(305945005)(14444005)(99286004)(256004)(8676002)(6116002)(8936002)(50226002)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3638;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: myrY/s/pi6CNe5xEGd8FWF3q79adT/yJ9rE7Sy5VR9498QuQ9un4dYkzVHcbk49gu+CDQ8J4sELsH2ETL8BOaHUkIFL853fdcbTT5j5FEDfY2gK6RIop1jvbNYnaUFaMBnzv5IdHS/HNGw7UQgzqCFnw2JVLQf3j5MKTpHDuA6jPh0q4tRi2HkKQikYHhKljUmV4dVoFMUCPmy8/9gINW4wFUPOpW0lwFw5evJc2sNBUvKQXZb5tkhVwvt/mDHfovbNWd3jb3owu+Cw/M/Pp3LO+FAwh3X4RVFP7IkJTKhmujxGQ/fsm+w5GCBXBYIV4UqnRyhWwNCPTnJycqXFYwXPILxDwB7aBX9Ey/dEchvbsFhpJjkXEOfprWRICe5uTN4OWDzUkb8vi/sESD+zZ9CjkTx/6M1aDDo1SqMX9bks=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 33f7d85c-39c5-4ac5-f43d-08d68943138f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2019 19:17:28.2774
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3638
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
index dcd5861..bafb454 100644
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

