Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEA2DC43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 05:45:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F45721527
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 05:45:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="GLqnvNu7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6F45721527
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731138AbeKLPgr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 10:36:47 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:41844 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728269AbeKLPgq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 10:36:46 -0500
X-IronPort-AV: E=Sophos;i="5.54,494,1534834800"; 
   d="scan'208";a="20255100"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 11 Nov 2018 22:45:07 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 11 Nov 2018 22:45:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0l1Rt1VSn9zYgn0u1YkKA9tJmKtjDBL6WvQVlK9jt6U=;
 b=GLqnvNu7XgcKZD0OzZ5nwKXOb2OQdS+DcI3KrIJ5yul5rtzSSgnpUY/orxJTMfciPA31WT5CTl9/3gf+A7OhUotGxXRJ4mlESsuhWOKEQHEclAl1WOCrkBncYM8b45iAlY+JdMa8NyXeEAQCg1WCd8y4t9w/yPY1qNJfIF0C/6k=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2599.namprd11.prod.outlook.com (52.135.227.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.21; Mon, 12 Nov 2018 05:45:06 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7%6]) with mapi id 15.20.1294.044; Mon, 12 Nov 2018
 05:45:06 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 02/12] staging: wilc1000: use WLAN_PMKID_LEN macro from
 ieee80211.h header
Thread-Topic: [PATCH 02/12] staging: wilc1000: use WLAN_PMKID_LEN macro from
 ieee80211.h header
Thread-Index: AQHUekrdhaIVWOO/IUy8mzrRzrCr+g==
Date:   Mon, 12 Nov 2018 05:45:06 +0000
Message-ID: <1542001458-20217-3-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2599;6:S95zeBCHZ6cQf/cZW+XAwdUqtI7ihvigg4jxhjXsfr1okxoca4vpYgJiarY0J0+ItqP1DdOsNv5cue17IAPE5gydhXJJHZv4g092KEY2vWeNXuz462DKMDpt3VVWDE+i31t7XGqexWQjdpt32Yqx6nCY/5SUgW2la+7EUAlL/mmLnLjVNn9tyUp+ghNM6IbhOrEU4si6di+cQoIzJo2Sp1LhQBFlOj82mEMVJrPevhkzH4iK5B4he0WN0RblKjL5lX4wHWpXxfA73X0MMA/NjMMK7pRmEnLYApYZ0FBHFmpmMGV3SLEyaWmSgQWaxYfIWf5iaV+LfUawoR1kV96jGYvxHLAVrYMJMq4b1mAFVUo9ZFuFhysxCVm5s0ILIq9GXMbY5Og/zGjALGj8gd2sXYJzPy0u31wdM0R4xLwY1NrZOITvwWIho1ymGq58s9y3ABN5DV0Q0nuPhdHtyKfqvg==;5:q8+NgudlV+ol8mLgxLCJTW0iDjEp3Ghkx+Df9e+rHeH9X8HMJK6jwQxZSadHJwl4kPnH9WnaNJ1Q4t1Rt3XXmnYxAOY8YMjYFZqwvmDhhe/jd+ib6BvstWxRLBnkcvp/lRxoWaNWh/YpGflfKdnMaty5rtTljceXKK7kShYSfYI=;7:6u0o4p+MpC9J1Avl2VUfx+XZBM3zh3OO37nqwHpzmgQGDUiRHk/rsJ4QSgX1RHPawgb1uTwUun9gIwvjiawgB66feDDJLti7D3pnQgTm7ppkYCfiqOPnENphx8/v6enAUJRdwZNh2IWUKFurfNDylQ==
x-ms-office365-filtering-correlation-id: 26ef5b76-bfdd-403e-ed6d-08d64861ffa3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390040)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2599;
x-ms-traffictypediagnostic: BYAPR11MB2599:
x-microsoft-antispam-prvs: <BYAPR11MB259904D43290374BDA2059F4E3C10@BYAPR11MB2599.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3002001)(3231402)(944501410)(52105112)(10201501046)(93006095)(93001095)(148016)(149066)(150057)(6041310)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123562045)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB2599;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2599;
x-forefront-prvs: 0854128AF0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(136003)(366004)(39860400002)(189003)(199004)(4326008)(25786009)(2906002)(6116002)(3846002)(72206003)(26005)(2351001)(14454004)(86362001)(186003)(6436002)(478600001)(6486002)(105586002)(76176011)(106356001)(2501003)(107886003)(5640700003)(54906003)(52116002)(99286004)(102836004)(53936002)(256004)(6506007)(386003)(316002)(36756003)(486006)(8936002)(6916009)(11346002)(7736002)(305945005)(476003)(2616005)(68736007)(8676002)(71200400001)(97736004)(5660300001)(66066001)(446003)(81156014)(81166006)(6512007)(71190400001)(2900100001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2599;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 38XBtiO99e6jD6yTgI2z4kE7v847RFlDVgWqgMaYH/lRAsCyhREGuEEXDqdH9DHRFMjYsiRINVCqNeJEWmm1pXIPR76pqxLb3MzuDT/heMX0PFM+2iypv3vL+l8G+c27ZdbIvN518sdL4utwSm/Wh6CJzhf12OpE6FIysaApnD3D/J4ZaXYlIoRtPzAhWNKnMuQMHDi9NjanWdBQ5IPOhpX+EDVerPQSqfZ4EejMrf81RsdtKXrJYbbLbixLP7WM54ERxbDAGr6ipGHMnER+gqwyW9KUkw9BPPVcLKwl3Lx6bE9thFleMmbnZT4fP3gHBUm7C7XWdkk54M3l291XoPeIU+DRujfWZxzeJMxuYbY=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 26ef5b76-bfdd-403e-ed6d-08d64861ffa3
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2018 05:45:06.0106
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

Make use of WLAN_PMKID_LEN macro provided by ieee80211.h header instead
of PMKID_LEN.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         | 4 ++--
 drivers/staging/wilc1000/host_interface.h         | 3 +--
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 ++--
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     | 1 -
 4 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index eb13b41..c200d90 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1460,7 +1460,7 @@ static int wilc_pmksa_key_copy(struct wilc_vif *vif, =
struct key_attr *hif_key)
 		memcpy(key_buf + ((PMKSA_KEY_LEN * i) + 1),
 		       hif_key->attr.pmkid.pmkidlist[i].bssid, ETH_ALEN);
 		memcpy(key_buf + ((PMKSA_KEY_LEN * i) + ETH_ALEN + 1),
-		       hif_key->attr.pmkid.pmkidlist[i].pmkid, PMKID_LEN);
+		       hif_key->attr.pmkid.pmkidlist[i].pmkid, WLAN_PMKID_LEN);
 	}
=20
 	wid.id =3D WID_PMKID_INFO;
@@ -2793,7 +2793,7 @@ int wilc_set_pmkid_info(struct wilc_vif *vif,
 		memcpy(msg->body.key_info.attr.pmkid.pmkidlist[i].bssid,
 		       &pmkid->pmkidlist[i].bssid, ETH_ALEN);
 		memcpy(msg->body.key_info.attr.pmkid.pmkidlist[i].pmkid,
-		       &pmkid->pmkidlist[i].pmkid, PMKID_LEN);
+		       &pmkid->pmkidlist[i].pmkid, WLAN_PMKID_LEN);
 	}
=20
 	result =3D wilc_enqueue_work(msg);
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index 0185fc6..3d31153 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -46,7 +46,6 @@
=20
 #define PMKSA_KEY_LEN				22
 #define ETH_ALEN				6
-#define PMKID_LEN				16
 #define WILC_MAX_NUM_PMKIDS			16
 #define WILC_ADD_STA_LENGTH			40
 #define NUM_CONCURRENT_IFC			2
@@ -128,7 +127,7 @@ enum host_if_state {
=20
 struct host_if_pmkid {
 	u8 bssid[ETH_ALEN];
-	u8 pmkid[PMKID_LEN];
+	u8 pmkid[WLAN_PMKID_LEN];
 };
=20
 struct host_if_pmkid_attr {
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/st=
aging/wilc1000/wilc_wfi_cfgoperations.c
index f92ecf6c..7b753c1 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1217,7 +1217,7 @@ static int set_pmksa(struct wiphy *wiphy, struct net_=
device *netdev,
 		memcpy(priv->pmkid_list.pmkidlist[i].bssid, pmksa->bssid,
 		       ETH_ALEN);
 		memcpy(priv->pmkid_list.pmkidlist[i].pmkid, pmksa->pmkid,
-		       PMKID_LEN);
+		       WLAN_PMKID_LEN);
 		if (!(flag =3D=3D PMKID_FOUND))
 			priv->pmkid_list.numpmkid++;
 	} else {
@@ -1254,7 +1254,7 @@ static int del_pmksa(struct wiphy *wiphy, struct net_=
device *netdev,
 			       ETH_ALEN);
 			memcpy(priv->pmkid_list.pmkidlist[i].pmkid,
 			       priv->pmkid_list.pmkidlist[i + 1].pmkid,
-			       PMKID_LEN);
+			       WLAN_PMKID_LEN);
 		}
 		priv->pmkid_list.numpmkid--;
 	} else {
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/stagin=
g/wilc1000/wilc_wfi_netdevice.h
index 4f05a16..6283d9e 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -22,7 +22,6 @@
 #define FLOW_CONTROL_UPPER_THRESHOLD		256
=20
 #define WILC_MAX_NUM_PMKIDS			16
-#define PMKID_LEN				16
 #define PMKID_FOUND				1
 #define NUM_STA_ASSOCIATED			8
=20
--=20
2.7.4

