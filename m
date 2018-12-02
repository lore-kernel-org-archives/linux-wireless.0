Return-Path: <SRS0=9n1M=OL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E04CC04EB8
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:02:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C14E82082F
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:02:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="OVLKszTf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C14E82082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725805AbeLBSCx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Dec 2018 13:02:53 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:63018 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbeLBSCx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Dec 2018 13:02:53 -0500
X-IronPort-AV: E=Sophos;i="5.56,307,1539673200"; 
   d="scan'208";a="23749573"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 02 Dec 2018 11:02:51 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 2 Dec 2018 11:02:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=imZZ5q0DJOMAOxw0UIMx2TMUafK6yx3B/pUaYTBGN6Q=;
 b=OVLKszTfjk0KHTe5vF6GUztC9bVd2SDr9lGUy7m7TnxoPi1hWuy8nho5Ptj/0o/Oqa/Jz54PkWM7mjtQW/7Yo490xVlxQD2iq4eCyfvJy8u5gJ9xMHHoTwJcroZttd9x8iXiZ5ipfMDCalZRUgx27TxLu5dow2/BFIPcdlFhfpo=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2806.namprd11.prod.outlook.com (52.135.228.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.18; Sun, 2 Dec 2018 18:02:49 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f%4]) with mapi id 15.20.1382.020; Sun, 2 Dec 2018
 18:02:49 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 12/29] staging: wilc1000: handle add beacon operation callback
 from cfg80211 context
Thread-Topic: [PATCH 12/29] staging: wilc1000: handle add beacon operation
 callback from cfg80211 context
Thread-Index: AQHUimk8SRAMUwYY10eq0u7Jv3i+hg==
Date:   Sun, 2 Dec 2018 18:02:48 +0000
Message-ID: <1543773663-20561-13-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2806;6:K7BQBKDg8iSNv8lQLyh1M9pUIzkEWKO5WT9pXR96ksswBK/sNdNmlNUMY9UVSIMHm9ZV0KQlR5/sa1JE6TJ4sMM0izYgtTqDWEQD/1A9fsVUD+TN1ok0mnObWp60F/x8A2Vppe/XVaapqQ5aYCchLW9cPcDt+UlV5unChLExmxVVhTSi0Gvi5Ez3nChu4PoEx9LgLxze2NRXpuKFbix/yxojHXy68fPG68Yv2YNs6ZLRzaFGkpodk65FSeiMMDPl7BRE90XOoWgKmrAGidA0FSvs4H4IPFTYhLPK8bZHBI/EXhFaDtc/Io15vNEu7c6Zf6ESsvcqDU76Fb7y05EZ2lIgIZWMxPkMJSGiIyxC/DdkHT7xwyqpp+LkU5ON0flBURgPjDL1byoVY2dgye1IC8twerx1Cjf8HGVMiKtplOZCnVr4i5ygyUffgfg9uCZJjIHxRr70tUGO6mtrSy1eNw==;5:TGgiWz48uRJ9lk56tCTbiLy9niKlooRuao/wjXsNZSf/DE6NlGMOpWhAhKTkV/WzHLCoJp6O23KtR4trroSoejlU6QZSYtBVXGKAx0pE/1zTKY8ggB3mGvHCFSelRIKMA2nTGdXiKgtOvYXvD3KeyNrOVdpcyAbOuyTzz47oiEA=;7:tDiUEfJoxYX4pkA4AVE40+jqrbKnWhQd6NsOG+u90rtMGe/ICC24dKeGcMGTaCZ5kIsuVLUZ5Mu43dXtwBMdfRbKrl3DlGYgfCsxVzGT/MtjJ/Ryp5JWAdmG6m7/tpwV0LpHZ2e4f+nX0iu/IgsTtQ==
x-ms-office365-filtering-correlation-id: 7fb31c5d-1e7b-437e-7b0f-08d658805e85
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2806;
x-ms-traffictypediagnostic: BYAPR11MB2806:
x-microsoft-antispam-prvs: <BYAPR11MB2806F7DECE920F30FA97D816E3AD0@BYAPR11MB2806.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3002001)(10201501046)(3231455)(999002)(944501491)(52105112)(148016)(149066)(150057)(6041310)(20161123562045)(20161123558120)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB2806;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2806;
x-forefront-prvs: 087474FBFA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(366004)(39850400004)(396003)(136003)(199004)(189003)(186003)(4326008)(7736002)(26005)(14454004)(2906002)(107886003)(305945005)(386003)(53936002)(6506007)(36756003)(76176011)(6512007)(71190400001)(52116002)(71200400001)(5640700003)(256004)(3846002)(6116002)(99286004)(5660300001)(78486014)(6486002)(446003)(11346002)(486006)(575784001)(86362001)(105586002)(8676002)(97736004)(68736007)(316002)(2616005)(6436002)(476003)(54906003)(66066001)(25786009)(102836004)(81156014)(81166006)(8936002)(72206003)(2351001)(2501003)(478600001)(6916009)(106356001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2806;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: nGlL3scGpbSk0YDWMntrDnd29Am8GMiSTgCexOw+axQbMV8JF8S+43ro7THtOinegPp7VWMeItfhAhdvZYJG4NfO7BpYbp1vsNal5BK8aoDMkr7RFYKafeMPg4ZFSTkHb2IeDXNXn/lV1DsSyojU/WITShKihEx/TMXeG6EkocUJ1X4q1JXNLFScdRAeTX6WU2ulrC9G2Wxk1d4d6mT77QjhMQiYRCsvKrE7mgXt/K+6yJNzko/AgUrAd73EyXQdbipmFiK3XnuDVJsPpsegbfDP2MgQFythbeea7WeCcRTnzsQUCftP4CE+n+CketYBH43hkTJCRWG8tfaAWbGi0EXRjHAc24nzcfxq9o8b9Pk=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fb31c5d-1e7b-437e-7b0f-08d658805e85
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2018 18:02:48.8921
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

Refactor add/change beacon cfg80211 operation callback to handle from
cfg context. Also avoided extra copy of information by packing directly
in firmware expected format.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         | 128 +++++-------------=
----
 drivers/staging/wilc1000/host_interface.h         |   2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  10 +-
 3 files changed, 32 insertions(+), 108 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 995ca65..97b84d2 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -78,15 +78,6 @@ struct channel_attr {
 	u8 set_ch;
 };
=20
-struct beacon_attr {
-	u32 interval;
-	u32 dtim_period;
-	u32 head_len;
-	u8 *head;
-	u32 tail_len;
-	u8 *tail;
-};
-
 struct set_multicast {
 	bool enabled;
 	u32 cnt;
@@ -116,7 +107,6 @@ union message_body {
 	struct key_attr key_info;
 	struct cfg_param_attr cfg_info;
 	struct channel_attr channel_info;
-	struct beacon_attr beacon_info;
 	struct sta_inactive_t mac_info;
 	struct set_ip_addr ip_info;
 	struct drv_handler drv;
@@ -1878,62 +1868,6 @@ static void handle_get_inactive_time(struct work_str=
uct *work)
 	complete(&msg->work_comp);
 }
=20
-static void handle_add_beacon(struct work_struct *work)
-{
-	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
-	struct wilc_vif *vif =3D msg->vif;
-	struct beacon_attr *param =3D &msg->body.beacon_info;
-	int result;
-	struct wid wid;
-	u8 *cur_byte;
-
-	wid.id =3D WID_ADD_BEACON;
-	wid.type =3D WID_BIN;
-	wid.size =3D param->head_len + param->tail_len + 16;
-	wid.val =3D kmalloc(wid.size, GFP_KERNEL);
-	if (!wid.val)
-		goto error;
-
-	cur_byte =3D wid.val;
-	*cur_byte++ =3D (param->interval & 0xFF);
-	*cur_byte++ =3D ((param->interval >> 8) & 0xFF);
-	*cur_byte++ =3D ((param->interval >> 16) & 0xFF);
-	*cur_byte++ =3D ((param->interval >> 24) & 0xFF);
-
-	*cur_byte++ =3D (param->dtim_period & 0xFF);
-	*cur_byte++ =3D ((param->dtim_period >> 8) & 0xFF);
-	*cur_byte++ =3D ((param->dtim_period >> 16) & 0xFF);
-	*cur_byte++ =3D ((param->dtim_period >> 24) & 0xFF);
-
-	*cur_byte++ =3D (param->head_len & 0xFF);
-	*cur_byte++ =3D ((param->head_len >> 8) & 0xFF);
-	*cur_byte++ =3D ((param->head_len >> 16) & 0xFF);
-	*cur_byte++ =3D ((param->head_len >> 24) & 0xFF);
-
-	memcpy(cur_byte, param->head, param->head_len);
-	cur_byte +=3D param->head_len;
-
-	*cur_byte++ =3D (param->tail_len & 0xFF);
-	*cur_byte++ =3D ((param->tail_len >> 8) & 0xFF);
-	*cur_byte++ =3D ((param->tail_len >> 16) & 0xFF);
-	*cur_byte++ =3D ((param->tail_len >> 24) & 0xFF);
-
-	if (param->tail)
-		memcpy(cur_byte, param->tail, param->tail_len);
-	cur_byte +=3D param->tail_len;
-
-	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
-				      wilc_get_vif_idx(vif));
-	if (result)
-		netdev_err(vif->ndev, "Failed to send add beacon\n");
-
-error:
-	kfree(wid.val);
-	kfree(param->head);
-	kfree(param->tail);
-	kfree(msg);
-}
-
 static void wilc_hif_pack_sta_param(u8 *cur_byte, const u8 *mac,
 				    struct station_parameters *params)
 {
@@ -3258,47 +3192,43 @@ void wilc_frame_register(struct wilc_vif *vif, u16 =
frame_type, bool reg)
 }
=20
 int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 dtim_period,
-		    u32 head_len, u8 *head, u32 tail_len, u8 *tail)
+		    struct cfg80211_beacon_data *params)
 {
+	struct wid wid;
 	int result;
-	struct host_if_msg *msg;
-	struct beacon_attr *beacon_info;
+	u8 *cur_byte;
=20
-	msg =3D wilc_alloc_work(vif, handle_add_beacon, false);
-	if (IS_ERR(msg))
-		return PTR_ERR(msg);
+	wid.id =3D WID_ADD_BEACON;
+	wid.type =3D WID_BIN;
+	wid.size =3D params->head_len + params->tail_len + 16;
+	wid.val =3D kzalloc(wid.size, GFP_KERNEL);
+	if (!wid.val)
+		return -ENOMEM;
=20
-	beacon_info =3D &msg->body.beacon_info;
-	beacon_info->interval =3D interval;
-	beacon_info->dtim_period =3D dtim_period;
-	beacon_info->head_len =3D head_len;
-	beacon_info->head =3D kmemdup(head, head_len, GFP_KERNEL);
-	if (!beacon_info->head) {
-		result =3D -ENOMEM;
-		goto error;
-	}
-	beacon_info->tail_len =3D tail_len;
+	cur_byte =3D wid.val;
+	put_unaligned_le32(interval, cur_byte);
+	cur_byte +=3D 4;
+	put_unaligned_le32(dtim_period, cur_byte);
+	cur_byte +=3D 4;
+	put_unaligned_le32(params->head_len, cur_byte);
+	cur_byte +=3D 4;
=20
-	if (tail_len > 0) {
-		beacon_info->tail =3D kmemdup(tail, tail_len, GFP_KERNEL);
-		if (!beacon_info->tail) {
-			result =3D -ENOMEM;
-			goto error;
-		}
-	} else {
-		beacon_info->tail =3D NULL;
-	}
+	if (params->head_len > 0)
+		memcpy(cur_byte, params->head, params->head_len);
+	cur_byte +=3D params->head_len;
=20
-	result =3D wilc_enqueue_work(msg);
+	put_unaligned_le32(params->tail_len, cur_byte);
+	cur_byte +=3D 4;
+
+	if (params->tail_len > 0)
+		memcpy(cur_byte, params->tail, params->tail_len);
+
+	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
+				      wilc_get_vif_idx(vif));
 	if (result)
-		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
+		netdev_err(vif->ndev, "Failed to send add beacon\n");
=20
-error:
-	if (result) {
-		kfree(beacon_info->head);
-		kfree(beacon_info->tail);
-		kfree(msg);
-	}
+	kfree(wid.val);
=20
 	return result;
 }
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index bebf0c6..647a1af 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -324,7 +324,7 @@ int wilc_hif_set_cfg(struct wilc_vif *vif,
 int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler=
);
 int wilc_deinit(struct wilc_vif *vif);
 int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 dtim_period,
-		    u32 head_len, u8 *head, u32 tail_len, u8 *tail);
+		    struct cfg80211_beacon_data *params);
 int wilc_del_beacon(struct wilc_vif *vif);
 int wilc_add_station(struct wilc_vif *vif, const u8 *mac,
 		     struct station_parameters *params);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/st=
aging/wilc1000/wilc_wfi_cfgoperations.c
index bbe68ba..18370ef 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1768,11 +1768,9 @@ static int start_ap(struct wiphy *wiphy, struct net_=
device *dev,
 {
 	struct wilc_vif *vif =3D netdev_priv(dev);
 	struct wilc *wl =3D vif->wilc;
-	struct cfg80211_beacon_data *beacon =3D &settings->beacon;
 	int ret;
=20
 	ret =3D set_channel(wiphy, &settings->chandef);
-
 	if (ret !=3D 0)
 		netdev_err(dev, "Error in setting channel\n");
=20
@@ -1780,9 +1778,7 @@ static int start_ap(struct wiphy *wiphy, struct net_d=
evice *dev,
 	wilc_set_power_mgmt(vif, 0, 0);
=20
 	return wilc_add_beacon(vif, settings->beacon_interval,
-				   settings->dtim_period, beacon->head_len,
-				   (u8 *)beacon->head, beacon->tail_len,
-				   (u8 *)beacon->tail);
+				   settings->dtim_period, &settings->beacon);
 }
=20
 static int change_beacon(struct wiphy *wiphy, struct net_device *dev,
@@ -1791,9 +1787,7 @@ static int change_beacon(struct wiphy *wiphy, struct =
net_device *dev,
 	struct wilc_priv *priv =3D wiphy_priv(wiphy);
 	struct wilc_vif *vif =3D netdev_priv(priv->dev);
=20
-	return wilc_add_beacon(vif, 0, 0, beacon->head_len,
-				   (u8 *)beacon->head, beacon->tail_len,
-				   (u8 *)beacon->tail);
+	return wilc_add_beacon(vif, 0, 0, beacon);
 }
=20
 static int stop_ap(struct wiphy *wiphy, struct net_device *dev)
--=20
2.7.4

