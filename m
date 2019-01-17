Return-Path: <SRS0=z7UY=PZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 305B3C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:21:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E76DE20652
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:21:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="OTsMOnkP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727726AbfAQNVp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jan 2019 08:21:45 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:40740 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727686AbfAQNVo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jan 2019 08:21:44 -0500
X-IronPort-AV: E=Sophos;i="5.56,489,1539673200"; 
   d="scan'208";a="23513331"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 17 Jan 2019 06:21:45 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.38) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 17 Jan 2019 06:21:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CNtd1YBAUwPlQsTxNwXh1xsUE3H3t1741m0H0g0KzQA=;
 b=OTsMOnkPD+71MTqW9QIKuvFlscBJmpdXJeK0xuhyky9HRa3uRhyWPJz8vduf+xQldyyWs1x2aYPvut/1WMYE0s4esRzzZER3C0oSCmYzv0uEtGTvXoL6hSDL2p8hqDD2zkSrNFZ39mggDGDq+6k0FFPWx8C75cdviSp3vivgBf8=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2534.namprd11.prod.outlook.com (52.135.226.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.25; Thu, 17 Jan 2019 13:21:41 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::c110:8559:a438:491d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::c110:8559:a438:491d%3]) with mapi id 15.20.1516.019; Thu, 17 Jan 2019
 13:21:41 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 12/13] staging: wilc1000: refactor handle_set_mcast_filter()
Thread-Topic: [PATCH 12/13] staging: wilc1000: refactor
 handle_set_mcast_filter()
Thread-Index: AQHUrmeVLax1Z3/Z3k2WlRysVqb39w==
Date:   Thu, 17 Jan 2019 13:21:41 +0000
Message-ID: <1547731250-18518-13-git-send-email-ajay.kathat@microchip.com>
References: <1547731250-18518-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1547731250-18518-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR01CA0138.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:35::32) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [49.205.218.18]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2534;6:1gGWNRzFxcZpLEFtKrezuNFzZXZf8pNOjScHZOj2+TMAozJ03eJZ/apQNKfFoFMeM6OaeQv2oQ7+IpjILN5LVaAMRH3iqmpPJGdCVTcQDDpZ2VIsVjIKYnULNIZTtn4XtkHQF8URE3uMF5P/V+0qOGRYBJKHTyF//MT5Wb6REZy7qyJT7Kg9fT8gkiMV23RpRxm/Zc0Vcho3ZBqELeBhjoc1k6evPJXqTK/bdeaSW8WiD5U41275EJwcGlIuEppGzwX8dPgqhH7y+jS89MP3m+W/j2eH+gkMQelv6pEpgQF4plt/XFSee69DAhqfGVGesq/LTdvqZ13esaCFw6TOru+IzYyP233ebOYI9eTw0MjFoYghes4BKZLVhm9HBdlKSWgGBBgEVQqeDNZKmvP7Yw8rEhKq9gsBpLpu93GZuJiuI8PSLXWm18cttTrFJ+NjYozGL+t7RsuZDKkp54GMyQ==;5:xVMHBKnfmovGqf1Gb/uPYPDgHhqVidOq5TlsERAAcQoF8pOo+6Us83w5WspXQoQJpgpG32f6COtQ16DkvuHasGT5bpL+QzLPyRPxcNkSPD5xyRm3yu/WXULHtwGZ7qYvSnBpp4WO0tJQzp7JZzdTOvo+lNckkG3COTVFvLKjJal5aWBr1OlB/m0+dacJFp5JsJSHQnroHE21PMtwwmqZXA==;7:AUCfEXsIj6HhV7WdldOUSzpP/TyGNkEITr5cRaBsPNALs7Pxls+9eUf7gXzGSiQMn4ZR7nw2u02VyGtocfLFgXsfv5o2jRq6C4HGZDaRfWCCZjZ6RRykDrlcorFFIJXdI9L7XIgoMkdig/qxZX95qQ==
x-ms-office365-filtering-correlation-id: 78e47827-15e9-4730-d34d-08d67c7eb7f0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2534;
x-ms-traffictypediagnostic: BYAPR11MB2534:
x-microsoft-antispam-prvs: <BYAPR11MB25348E1520A9C6C20D242806E3830@BYAPR11MB2534.namprd11.prod.outlook.com>
x-forefront-prvs: 0920602B08
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(136003)(346002)(39860400002)(376002)(199004)(189003)(6916009)(6116002)(3846002)(386003)(6506007)(14454004)(2616005)(66066001)(7736002)(78486014)(71190400001)(71200400001)(5660300001)(102836004)(476003)(305945005)(52116002)(76176011)(446003)(106356001)(81166006)(81156014)(486006)(11346002)(316002)(8936002)(54906003)(8676002)(99286004)(50226002)(2351001)(72206003)(478600001)(68736007)(25786009)(186003)(5640700003)(2906002)(26005)(105586002)(53936002)(6512007)(36756003)(6436002)(6486002)(256004)(4326008)(107886003)(2501003)(86362001)(97736004);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2534;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ANoyQEn1SNnvVyoHgG6Pxd3SreNjBtrenv8M93M4XhMIsgsGtlBqWqDgYKeTGt9ikI4F9UBBF69VKvCag0sOW/5tFCLBL87Lj96ElbTtsHLYNRKI9nV4jFiGtioGDSSiepvdQUN8cyT55Qt3T88aPkeLklX6lp3xxcTuiRcsips2vEzaOqDfU2WaM9YxWBEJ4Kpn54bFbBQvNON5G7AQe/F/SHjuCW2X7LaMvlGkbcxQN29D1SfQ776gODzH+PQYoxggwRgBSeSYKw9cNto6WwEKpxkTH9yZytWEaKPMp2ihbb4ZAIFHAxzRzmHTCDAMo52mo/RLqRz3tUG1sufsC6eZ/COSsTJNt9DCkSFUsdRgOSItPyd23+aEnn+ZJlVkKG0UWxtTcUxa/+4jscLGfw32Po1d1oLux5ZOlVT9U10=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 78e47827-15e9-4730-d34d-08d67c7eb7f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2019 13:21:39.1245
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2534
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Refactor handle_set_mcast_filter() by making use of put_unaligned32() to
pack the data instead of byte operation.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 37 +++++++++++++--------------=
----
 drivers/staging/wilc1000/host_interface.h |  2 +-
 drivers/staging/wilc1000/linux_wlan.c     |  6 ++---
 3 files changed, 20 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index fa3af2c..f463865 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -15,8 +15,8 @@ struct wilc_rcvd_mac_info {
 	u8 status;
 };
=20
-struct set_multicast {
-	bool enabled;
+struct wilc_set_multicast {
+	u32 enabled;
 	u32 cnt;
 	u8 *mc_list;
 };
@@ -71,7 +71,7 @@ struct wilc_gtk_key {
 union message_body {
 	struct wilc_rcvd_net_info net_info;
 	struct wilc_rcvd_mac_info mac_info;
-	struct set_multicast multicast_info;
+	struct wilc_set_multicast mc_info;
 	struct remain_ch remain_on_ch;
 	char *data;
 };
@@ -1067,32 +1067,27 @@ static void handle_set_mcast_filter(struct work_str=
uct *work)
 {
 	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif =3D msg->vif;
-	struct set_multicast *hif_set_mc =3D &msg->body.multicast_info;
+	struct wilc_set_multicast *set_mc =3D &msg->body.mc_info;
 	int result;
 	struct wid wid;
 	u8 *cur_byte;
=20
 	wid.id =3D WID_SETUP_MULTICAST_FILTER;
 	wid.type =3D WID_BIN;
-	wid.size =3D sizeof(struct set_multicast) + (hif_set_mc->cnt * ETH_ALEN);
+	wid.size =3D sizeof(struct wilc_set_multicast) + (set_mc->cnt * ETH_ALEN)=
;
 	wid.val =3D kmalloc(wid.size, GFP_KERNEL);
 	if (!wid.val)
 		goto error;
=20
 	cur_byte =3D wid.val;
-	*cur_byte++ =3D (hif_set_mc->enabled & 0xFF);
-	*cur_byte++ =3D 0;
-	*cur_byte++ =3D 0;
-	*cur_byte++ =3D 0;
+	put_unaligned_le32(set_mc->enabled, cur_byte);
+	cur_byte +=3D 4;
=20
-	*cur_byte++ =3D (hif_set_mc->cnt & 0xFF);
-	*cur_byte++ =3D ((hif_set_mc->cnt >> 8) & 0xFF);
-	*cur_byte++ =3D ((hif_set_mc->cnt >> 16) & 0xFF);
-	*cur_byte++ =3D ((hif_set_mc->cnt >> 24) & 0xFF);
+	put_unaligned_le32(set_mc->cnt, cur_byte);
+	cur_byte +=3D 4;
=20
-	if (hif_set_mc->cnt > 0 && hif_set_mc->mc_list)
-		memcpy(cur_byte, hif_set_mc->mc_list,
-		       ((hif_set_mc->cnt) * ETH_ALEN));
+	if (set_mc->cnt > 0 && set_mc->mc_list)
+		memcpy(cur_byte, set_mc->mc_list, set_mc->cnt * ETH_ALEN);
=20
 	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
@@ -1100,7 +1095,7 @@ static void handle_set_mcast_filter(struct work_struc=
t *work)
 		netdev_err(vif->ndev, "Failed to send setup multicast\n");
=20
 error:
-	kfree(hif_set_mc->mc_list);
+	kfree(set_mc->mc_list);
 	kfree(wid.val);
 	kfree(msg);
 }
@@ -2150,7 +2145,7 @@ int wilc_set_power_mgmt(struct wilc_vif *vif, bool en=
abled, u32 timeout)
 	return result;
 }
=20
-int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled, u32 co=
unt,
+int wilc_setup_multicast_filter(struct wilc_vif *vif, u32 enabled, u32 cou=
nt,
 				u8 *mc_list)
 {
 	int result;
@@ -2160,9 +2155,9 @@ int wilc_setup_multicast_filter(struct wilc_vif *vif,=
 bool enabled, u32 count,
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
=20
-	msg->body.multicast_info.enabled =3D enabled;
-	msg->body.multicast_info.cnt =3D count;
-	msg->body.multicast_info.mc_list =3D mc_list;
+	msg->body.mc_info.enabled =3D enabled;
+	msg->body.mc_info.cnt =3D count;
+	msg->body.mc_info.mc_list =3D mc_list;
=20
 	result =3D wilc_enqueue_work(msg);
 	if (result) {
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index 363db0b..527ae05 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -230,7 +230,7 @@ int wilc_del_station(struct wilc_vif *vif, const u8 *ma=
c_addr);
 int wilc_edit_station(struct wilc_vif *vif, const u8 *mac,
 		      struct station_parameters *params);
 int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 timeout);
-int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled, u32 co=
unt,
+int wilc_setup_multicast_filter(struct wilc_vif *vif, u32 enabled, u32 cou=
nt,
 				u8 *mc_list);
 int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
 			   u32 duration, u16 chan,
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc10=
00/linux_wlan.c
index 5b554c6..87ec048 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -811,12 +811,12 @@ static void wilc_set_multicast_list(struct net_device=
 *dev)
=20
 	if (dev->flags & IFF_ALLMULTI ||
 	    dev->mc.count > WILC_MULTICAST_TABLE_SIZE) {
-		wilc_setup_multicast_filter(vif, false, 0, NULL);
+		wilc_setup_multicast_filter(vif, 0, 0, NULL);
 		return;
 	}
=20
 	if (dev->mc.count =3D=3D 0) {
-		wilc_setup_multicast_filter(vif, true, 0, NULL);
+		wilc_setup_multicast_filter(vif, 1, 0, NULL);
 		return;
 	}
=20
@@ -833,7 +833,7 @@ static void wilc_set_multicast_list(struct net_device *=
dev)
 		cur_mc +=3D ETH_ALEN;
 	}
=20
-	if (wilc_setup_multicast_filter(vif, true, dev->mc.count, mc_list))
+	if (wilc_setup_multicast_filter(vif, 1, dev->mc.count, mc_list))
 		kfree(mc_list);
 }
=20
--=20
2.7.4

