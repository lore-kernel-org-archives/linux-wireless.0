Return-Path: <SRS0=9n1M=OL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A082C04EB8
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:03:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 463442080A
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:03:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="aAOCRDfZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 463442080A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbeLBSDh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Dec 2018 13:03:37 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:63046 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbeLBSDh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Dec 2018 13:03:37 -0500
X-IronPort-AV: E=Sophos;i="5.56,307,1539673200"; 
   d="scan'208";a="23749613"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 02 Dec 2018 11:03:34 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 2 Dec 2018 11:03:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zh+EixQnBfoG+mV8ELJKLmIQsVm3Aizvm1gQJ/G4r6U=;
 b=aAOCRDfZ5KyEWWkIYbZKk5eRWUFsIb66l3gcdRga4VRh7pK8EGWCVUhPzgftzxl/TKuXIx73YNJq8+GpmGbRIW1+txFcbpNQZV12FugLF4DtJF9nhP3f/aX1F5SGuyDiT6v+4s97H6J8z1q1+5DQzG4TRpG7xyuRVYcp+JkfHXQ=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2806.namprd11.prod.outlook.com (52.135.228.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.18; Sun, 2 Dec 2018 18:03:17 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f%4]) with mapi id 15.20.1382.020; Sun, 2 Dec 2018
 18:03:17 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 22/29] staging: wilc1000: refactor wilc_get_mac_address() to
 avoid deferred handling
Thread-Topic: [PATCH 22/29] staging: wilc1000: refactor wilc_get_mac_address()
 to avoid deferred handling
Thread-Index: AQHUimlN3PAIBqPX1k+g1GKrN0kWeQ==
Date:   Sun, 2 Dec 2018 18:03:17 +0000
Message-ID: <1543773663-20561-23-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2806;6:8KgbROTeJCRvNROJOkEKQk3wZX45CPAB/Oi0Doa6UqkCJ4sweFNxDgrhZRQTtom8VJKXkBETDHzT/aBbD6BffdSQWFeti/KWabW/p4cwG+rBvBIdwIbbS7hwUZOeITY0vZZmuYkhSVznfd/aD8mVRxVePGnf6KibITwVkjouN6GNAs+tfrggEYthDcSbF0QDQUWvb/mh6GDM0ZvbtIf7EwXUAcbXrkvMrXWZLhwopCzL44hDTUuFs/wCvKrZ/fXN21obj36hS3Fc7/K5UJiVsQZtzzcx/EZKOL1edj6BNwL+6dojnFqPWRhVpTWr8VH75diMuJc9voq3Zm3/+CqxhV9yVKDWWRUKiA3qAsgPxZQtAMAtbJb/rLIrjPmLaZeXSOxsgOhEbwr0TG5QbsUf80neSek81BsWm9STIJykrp/1rrwTNYG+I3gCtK4fLd4yr6u5bqH9mI2NaoeZzVxz7w==;5:08zTxs/Cjs3MEUPYfPVmnvDhY8JEgDIfs5q/5SHW2uDa5JLBjZE3QCC3E+PgGfq7MhwMFbJRDPZ3BepeR1T57PXLToUt9aOKIkt4yBuWCvvagsbdzJS66kCP3MslZZwx9dFmQaxDsnbkL4iKAQY6D6tkhD8jsboVBiXsGnEQovU=;7:iRFyXNwU84qCoCnd6HMRSTWqSnhATZx6j6X6aIf0/Ey3npEegCzsCB91VU0xPsGavuX+lbEHFfkWfPqOIUF8AMrXW+pOI6QDUcTLnuO7gbOV42twxnmbgZwF2yIAtBkz0LNVcGzqrd0EsFZu6Hwngg==
x-ms-office365-filtering-correlation-id: 2fc7e6cf-3421-41da-be73-08d658806f70
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2806;
x-ms-traffictypediagnostic: BYAPR11MB2806:
x-microsoft-antispam-prvs: <BYAPR11MB280664C92AE47D17D54A3915E3AD0@BYAPR11MB2806.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3002001)(10201501046)(3231455)(999002)(944501491)(52105112)(148016)(149066)(150057)(6041310)(20161123562045)(20161123558120)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB2806;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2806;
x-forefront-prvs: 087474FBFA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(366004)(39850400004)(396003)(136003)(199004)(189003)(186003)(4326008)(7736002)(26005)(14454004)(2906002)(107886003)(305945005)(386003)(53936002)(6506007)(36756003)(76176011)(6512007)(71190400001)(52116002)(71200400001)(5640700003)(14444005)(256004)(3846002)(6116002)(99286004)(5660300001)(78486014)(6486002)(446003)(11346002)(486006)(575784001)(86362001)(105586002)(8676002)(97736004)(68736007)(316002)(2616005)(6436002)(476003)(54906003)(66066001)(25786009)(102836004)(81156014)(81166006)(8936002)(72206003)(2351001)(2501003)(478600001)(6916009)(106356001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2806;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 5mLRyPUaunoK0XTFHBOR8B2jX37gGQEQQkdjZDR5IUnqaDjyMBfS2j7r7kfXCYv46kChlDHUAM+6qND2oklLdr02e1Krs9hyjraGSvlnATTXRYP2qJnaUTD691Rcs0aUXyYsKXUHPTkK3siX6rtfWD+3AXQ7j4a4m+nA7Jfvf9+bjIVhMxNZnkbuyBry0YMhQsi9yrc+tzR/KtJeWr+r0k5pSPZonZ/2BqF+GAxBaAHMRaBasJDXQSX1VZcREzGOxYeQe/Te9ayL4fh33KTyMWbaJ3LeOC0VS7BY6naWUOONVlh/l313WRVvElmPTOkmPnlA69XYZl6c6kZzDUg5x45695KrlpW8W37mnknj0DU=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fc7e6cf-3421-41da-be73-08d658806f70
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2018 18:03:17.2885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2806
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Avoid handling of WID_MAC_ADDR wid command in deferred approach. Instead
of posting the wid to workqueue now handle directly from the caller
context.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 43 ++++++---------------------=
----
 drivers/staging/wilc1000/host_interface.h |  4 ---
 2 files changed, 8 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 71395d8..dc02561 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -103,7 +103,6 @@ union message_body {
 	struct rcvd_net_info net_info;
 	struct rcvd_async_info async_info;
 	struct set_multicast multicast_info;
-	struct get_mac_addr get_mac_info;
 	struct remain_ch remain_on_ch;
 	char *data;
 };
@@ -208,28 +207,6 @@ static struct wilc_vif *wilc_get_vif_from_idx(struct w=
ilc *wilc, int idx)
 	return wilc->vif[index];
 }
=20
-static void handle_get_mac_address(struct work_struct *work)
-{
-	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
-	struct wilc_vif *vif =3D msg->vif;
-	struct get_mac_addr *get_mac_addr =3D &msg->body.get_mac_info;
-	int ret;
-	struct wid wid;
-
-	wid.id =3D WID_MAC_ADDR;
-	wid.type =3D WID_STR;
-	wid.val =3D get_mac_addr->mac_addr;
-	wid.size =3D ETH_ALEN;
-
-	ret =3D wilc_send_config_pkt(vif, WILC_GET_CFG, &wid, 1,
-				   wilc_get_vif_idx(vif));
-
-	if (ret)
-		netdev_err(vif->ndev, "Failed to get mac address\n");
-	complete(&msg->work_comp);
-	/* free 'msg' data later, in caller */
-}
-
 static int handle_scan_done(struct wilc_vif *vif, enum scan_event evt)
 {
 	int result =3D 0;
@@ -1934,21 +1911,17 @@ int wilc_set_pmkid_info(struct wilc_vif *vif, struc=
t wilc_pmkid_attr *pmkid)
 int wilc_get_mac_address(struct wilc_vif *vif, u8 *mac_addr)
 {
 	int result;
-	struct host_if_msg *msg;
-
-	msg =3D wilc_alloc_work(vif, handle_get_mac_address, true);
-	if (IS_ERR(msg))
-		return PTR_ERR(msg);
+	struct wid wid;
=20
-	msg->body.get_mac_info.mac_addr =3D mac_addr;
+	wid.id =3D WID_MAC_ADDR;
+	wid.type =3D WID_STR;
+	wid.size =3D ETH_ALEN;
+	wid.val =3D mac_addr;
=20
-	result =3D wilc_enqueue_work(msg);
+	result =3D wilc_send_config_pkt(vif, WILC_GET_CFG, &wid, 1,
+				      wilc_get_vif_idx(vif));
 	if (result)
-		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
-	else
-		wait_for_completion(&msg->work_comp);
-
-	kfree(msg);
+		netdev_err(vif->ndev, "Failed to get mac address\n");
=20
 	return result;
 }
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index d2f29ea..953f0ea 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -194,10 +194,6 @@ struct user_conn_req {
 	void *arg;
 };
=20
-struct get_mac_addr {
-	u8 *mac_addr;
-};
-
 struct remain_ch {
 	u16 ch;
 	u32 duration;
--=20
2.7.4

