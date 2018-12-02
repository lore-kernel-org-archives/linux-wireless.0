Return-Path: <SRS0=9n1M=OL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7837C04EB8
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:02:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94DE92082F
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:02:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="jmMMKl9K"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 94DE92082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725764AbeLBSCY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Dec 2018 13:02:24 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:23423 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbeLBSCY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Dec 2018 13:02:24 -0500
X-IronPort-AV: E=Sophos;i="5.56,307,1539673200"; 
   d="scan'208";a="23899229"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 02 Dec 2018 11:02:22 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.105) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 2 Dec 2018 11:02:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q0rEnOY9DtwesnLPxPu6UXJAeyXrjgv96d80W7VTvcg=;
 b=jmMMKl9Kf3AePWNtnAPa6jQgZg8QqD4UT1noaqqIfj0eG9Aq2sIVIamnEea3YO7/Me9c0GxvygFfTMj/vphC7a8+KMZkFesUYMjEx/+MwQl685ZEAjKrd9XTlvyvXgo4+jJursj/ieJ8YcjhHNnJLWBIPsITLyMw5XfA/vA4TTg=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3334.namprd11.prod.outlook.com (20.177.185.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.19; Sun, 2 Dec 2018 18:02:17 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f%4]) with mapi id 15.20.1382.020; Sun, 2 Dec 2018
 18:02:17 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 01/29] staging: wilc1000: remove unnecessary checks in
 wilc_mac_close()
Thread-Topic: [PATCH 01/29] staging: wilc1000: remove unnecessary checks in
 wilc_mac_close()
Thread-Index: AQHUimkppEx8r1aIkE21uh5bSl2U1w==
Date:   Sun, 2 Dec 2018 18:02:16 +0000
Message-ID: <1543773663-20561-2-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3334;6:BpCFShD/ICRrBN7tog/vtp3hex4GKlOYNE7OlUZq7oX+/Ik9kValYJEnLckibDIKsgNvZZbiMXa3EbLPUdav9T5Akj5Mo/WyWNQWR8KcQh0jmNEx/UO0N8fKsP3f6r3+KPw3iKYhCs5nFqMjp6EHf/ZoBBJziWd9l2dvcPyHWK+B0QGoAvgFIONdmTVtO0TwKrajg0ScMp0crAAjSGd85ceMUNrtBgiMZrDy0URveE1flhS6Pe10HtmdP9SR0jsJYH/+2qWC+jGy7WCugMaDwLtxCb537qvabRLYPkF2voGJmtFVn7zcpxwT7s5JCutTtlPlUqLP+ApFu7oXkBwswmhHOl/pl94nfMpO8ZWdvjv1LFOk2SDWAyeC3M0U/KwZAbrbMr4dtRScqrdGYpHhtfvYp2R0oEopzu50wy0ppFAmRhbxetqzfxUhQCWrR8oTzyhCwDcI/s8DwOJUCthOoQ==;5:F29ozlHPovagFNBNM4aK5RVYxr81WHWmPAh1T/Fmtw0sMKOssKOhSJbLIM+6shJY46MQFxXYesF5ffihtEi0cwgzEHEnlQB7CVahlY2hggUpzRYUipdJKCVsqRCxILj/M/uPwj1nXRTc/Yx6TfnFD6usvqSrb+qFtLy/Pg1E2qY=;7:g6kF+SX28xeMSRfL44Igbo13+Rt4ZtWcig22Krd54vqMMu4ONIdWis1LWviwO29dLyUGHjLbwzGXY13uEiflfNCAUtsbqFz2wM6ypBMJMoPIahj313tmlAEUEjno3qplII07q1zqzRh2XoaOf9/Iaw==
x-ms-office365-filtering-correlation-id: 54598fcb-3b02-4be9-261b-08d658804b78
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3334;
x-ms-traffictypediagnostic: BYAPR11MB3334:
x-microsoft-antispam-prvs: <BYAPR11MB3334A62F5739B549FA64C152E3AD0@BYAPR11MB3334.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(10201501046)(3002001)(3231455)(999002)(944501491)(52105112)(93006095)(93001095)(148016)(149066)(150057)(6041310)(20161123558120)(20161123564045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB3334;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB3334;
x-forefront-prvs: 087474FBFA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(366004)(376002)(396003)(39850400004)(199004)(189003)(107886003)(6916009)(386003)(5660300001)(5640700003)(446003)(4326008)(11346002)(6506007)(78486014)(2906002)(6512007)(53936002)(54906003)(3846002)(6116002)(2351001)(81166006)(316002)(81156014)(52116002)(8676002)(26005)(8936002)(256004)(14444005)(76176011)(6436002)(97736004)(106356001)(99286004)(486006)(6486002)(68736007)(105586002)(14454004)(478600001)(2616005)(7736002)(66066001)(36756003)(305945005)(72206003)(186003)(2501003)(86362001)(102836004)(476003)(71190400001)(25786009)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3334;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: w96kFHp0JBzrnVj/ELOK4CLKDUK9ns5cfJEupm9P/+4vEo5OPAsC/E7PTF4UmA2QUeBROOj+WkpwRhjawbK1W5L/W0C00gyZY27HIbghpBRnm7tM8KvRdOhNUmN4B3VwHfmYFBklUR3lT3X2bHyGlHco0afbfbUU5LYtgRXT0SzgQWZzXtNprXOdpaVyUrVtJuz4mZIPPchigjHCMm43yotJdv6OfSws8mAvd7WA+KIJBj9ag4m/XNgCnuJFNrl/wsYxdaQRjBVis/7/ze6pSAOVoBBs482eD1v+bTEbxDIl8dY73SJ9LOUbJ7/P2QwK7VhaOmAq/2VASF78+waYOlCGHrLTqYG5/jskLLH8ny0=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 54598fcb-3b02-4be9-261b-08d658804b78
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2018 18:02:16.9190
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

Remove unnecessary 'if' check in wilc_mac_close() as those conditions
will not happen.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc10=
00/linux_wlan.c
index 66fb988..c92ee79 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -896,31 +896,11 @@ netdev_tx_t wilc_mac_xmit(struct sk_buff *skb, struct=
 net_device *ndev)
=20
 static int wilc_mac_close(struct net_device *ndev)
 {
-	struct wilc_priv *priv;
 	struct wilc_vif *vif =3D netdev_priv(ndev);
-	struct host_if_drv *hif_drv;
-	struct wilc *wl;
-
-	if (!vif || !vif->ndev || !vif->ndev->ieee80211_ptr ||
-	    !vif->ndev->ieee80211_ptr->wiphy)
-		return 0;
-
-	priv =3D wiphy_priv(vif->ndev->ieee80211_ptr->wiphy);
-	wl =3D vif->wilc;
-
-	if (!priv)
-		return 0;
-
-	hif_drv =3D (struct host_if_drv *)priv->hif_drv;
+	struct wilc *wl =3D vif->wilc;
=20
 	netdev_dbg(ndev, "Mac close\n");
=20
-	if (!wl)
-		return 0;
-
-	if (!hif_drv)
-		return 0;
-
 	if (wl->open_ifcs > 0)
 		wl->open_ifcs--;
 	else
--=20
2.7.4

