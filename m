Return-Path: <SRS0=9n1M=OL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5615CC65BB8
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:02:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 204FD2082F
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:02:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="J5Z57fcl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 204FD2082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725786AbeLBSCi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Dec 2018 13:02:38 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:40359 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbeLBSCi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Dec 2018 13:02:38 -0500
X-IronPort-AV: E=Sophos;i="5.56,307,1539673200"; 
   d="scan'208";a="21024640"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 02 Dec 2018 11:02:36 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.105) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 2 Dec 2018 11:02:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M8l4vAqaN2FEqbpiSoCp7luS1KfwwXHrzDqQ1XwkkA4=;
 b=J5Z57fcleLg8qKzNNm+QXZQmVWwClC/KyEZi9KgeYDFcK5Ku5HfP2vyXKde0H6zWjQYhEGXkhJ6xo2TfVJZtlrHw1G1to28TipYJ1FveCZ4E4kIEPMMnAVyNh18uTIK82yFbdd0IPQjvr0Ake5xnnE+I2ul6mzRB1YVvstmwzeM=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3334.namprd11.prod.outlook.com (20.177.185.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.19; Sun, 2 Dec 2018 18:02:34 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f%4]) with mapi id 15.20.1382.020; Sun, 2 Dec 2018
 18:02:34 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 07/29] staging: wilc1000: handle add and edit station from the
 cfg80211 context
Thread-Topic: [PATCH 07/29] staging: wilc1000: handle add and edit station
 from the cfg80211 context
Thread-Index: AQHUimkzVHMl0DbA5UeoDAetEx6vUw==
Date:   Sun, 2 Dec 2018 18:02:34 +0000
Message-ID: <1543773663-20561-8-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3334;6:cscKibvFQO6pjE4ZNDQYbQzJ3U5BiHegrmuXDquLKJM8Y4s5eytK/boNLQk/26Fqo491y4v43dUFgWDfne4F5nCMBpS6iseKN30CKqzssfyk4KLaf2/ogLuE6FWl6DKjRVeu4Uq9mezhZoiHJRg0/aY8u45Yz0QyvxCIZ9A/rsVb3XKC+8Ldya7eKxfuliC5AfZXl8FHRf3ZpTnk94mUY3Y1KT2HVpCSEQzFlJA4cMH2kBlifqZwFhNv2VM0v3R3fsz8eUM81VsjDsbLx0EsHU4yCNJoatDqt+8uC6VR0P3cLcRGAKbWMy2gxjw/2xcgiCrXDrcM811kco8EMqMWiZtCIka656xeY3zxMCA8gf1k+Rd+Usxy6BtNe0/9QyhluvARmr+2tlDsZxDj6o3M3kPT45pY36zJilUwVEjbTdy1mojM61POAWwI2zRqXH7zmU9EaWEfA8ar7w/K9GChAg==;5:MDRFViXEYbLkvyKLVj+sVvyZn1Jkw8EbNnNEuz5xeiiZBJtUjkwCYeJ/HuRtUsCDLxSXbFuxPCicwA57yZhZ2x82uo77W7ylXW2PSy+SZCAqTH2DYHt5AIarblwu6Veop1z1zX+D70JQtwvlSTdV0dJQ/N8MQoGKwyrdOTx3iUo=;7:X41jmoo8NBdnDuUdEFHffsBXJprvo/WCX9Lao0FJnEFopKsEZIBqy3DBPpjEHxHi0GPfvVJHdrQoyqzm/sXJ59UbWJ28qFc4kpMWd79UgEKI1hZLKO+I0vYD9gj1Yli+ts/dM0Ok1QtbiMUKYqbUnQ==
x-ms-office365-filtering-correlation-id: 44bfae3f-3da7-48c8-3ad3-08d6588055d2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3334;
x-ms-traffictypediagnostic: BYAPR11MB3334:
x-microsoft-antispam-prvs: <BYAPR11MB3334D6F73A6B250AE21F3AB7E3AD0@BYAPR11MB3334.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(10201501046)(3002001)(3231455)(999002)(944501491)(52105112)(93006095)(93001095)(148016)(149066)(150057)(6041310)(20161123558120)(20161123564045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB3334;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB3334;
x-forefront-prvs: 087474FBFA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(366004)(376002)(396003)(39850400004)(199004)(189003)(107886003)(6916009)(386003)(5660300001)(5640700003)(446003)(4326008)(11346002)(6506007)(78486014)(2906002)(6512007)(53936002)(54906003)(3846002)(6116002)(2351001)(81166006)(316002)(81156014)(52116002)(8676002)(26005)(8936002)(256004)(76176011)(6436002)(97736004)(106356001)(99286004)(486006)(6486002)(68736007)(105586002)(14454004)(478600001)(2616005)(7736002)(66066001)(36756003)(305945005)(72206003)(186003)(2501003)(86362001)(575784001)(102836004)(476003)(71190400001)(25786009)(4744004)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3334;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 3ShvbZqBwKT6MbXfKVZAWhvLSOtIao5wvAHhBfUflTUjPfn+E19Y/o5RhP+3MuBXwKLeffYFGCH7Ayrd8/bQLnijqGCgVtRHz+dnsgzPCzrnZF01V+Msf0rUmHYdu955P9N14TZpWdDVQN3W5mnOZoCKBPQmjpBrMZhEFWYbA/c+Hv+N4BJ2UnVLhzrngh/2aq0kOExO4BTVAoIGe9667rzPVzMHWvo5N2rh+nLP1Pg+CeeB2Mt9UNAXLYcb9a9hoXy9V+eeRRCiSe9a9aUoy0RWGgZOExG6yuWcLw58tyJz9Y5a8XdF8+nS41mU/UPvCQjeRAmAFYyVamp14H1i81WzK1ME4EWXD4cvsL9WFNs=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 44bfae3f-3da7-48c8-3ad3-08d6588055d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2018 18:02:34.1675
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

Refactor the code to avoid handling of add/edit stations using work
queue and now set the wid value from caller context.
Avoid making an extra copy of buffer and directly copy the data in
firmware expected format.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         | 192 +++++++-----------=
----
 drivers/staging/wilc1000/host_interface.h         |   7 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  35 +---
 3 files changed, 67 insertions(+), 167 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 4074a37..fedcff8 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -121,9 +121,7 @@ union message_body {
 	struct cfg_param_attr cfg_info;
 	struct channel_attr channel_info;
 	struct beacon_attr beacon_info;
-	struct add_sta_param add_sta_info;
 	struct del_sta del_sta_info;
-	struct add_sta_param edit_sta_info;
 	struct sta_inactive_t mac_info;
 	struct set_ip_addr ip_info;
 	struct drv_handler drv;
@@ -1962,67 +1960,41 @@ static void handle_del_beacon(struct work_struct *w=
ork)
 	kfree(msg);
 }
=20
-static u32 wilc_hif_pack_sta_param(u8 *buff, struct add_sta_param *param)
+static u32 wilc_hif_pack_sta_param(u8 *buff, const u8 *mac,
+				   struct station_parameters *params)
 {
 	u8 *cur_byte;
=20
 	cur_byte =3D buff;
-
-	memcpy(cur_byte, param->bssid, ETH_ALEN);
-	cur_byte +=3D  ETH_ALEN;
-
-	*cur_byte++ =3D param->aid & 0xFF;
-	*cur_byte++ =3D (param->aid >> 8) & 0xFF;
-
-	*cur_byte++ =3D param->rates_len;
-	if (param->rates_len > 0)
-		memcpy(cur_byte, param->rates, param->rates_len);
-	cur_byte +=3D param->rates_len;
-
-	*cur_byte++ =3D param->ht_supported;
-	memcpy(cur_byte, &param->ht_capa, sizeof(struct ieee80211_ht_cap));
+	ether_addr_copy(cur_byte, mac);
+	cur_byte +=3D ETH_ALEN;
+
+	put_unaligned_le16(params->aid, cur_byte);
+	cur_byte +=3D 2;
+
+	*cur_byte++ =3D params->supported_rates_len;
+	if (params->supported_rates_len > 0)
+		memcpy(cur_byte, params->supported_rates,
+		       params->supported_rates_len);
+	cur_byte +=3D params->supported_rates_len;
+
+	if (params->ht_capa) {
+		*cur_byte++ =3D true;
+		memcpy(cur_byte, &params->ht_capa,
+		       sizeof(struct ieee80211_ht_cap));
+	} else {
+		*cur_byte++ =3D false;
+	}
 	cur_byte +=3D sizeof(struct ieee80211_ht_cap);
=20
-	*cur_byte++ =3D param->flags_mask & 0xFF;
-	*cur_byte++ =3D (param->flags_mask >> 8) & 0xFF;
-
-	*cur_byte++ =3D param->flags_set & 0xFF;
-	*cur_byte++ =3D (param->flags_set >> 8) & 0xFF;
+	put_unaligned_le16(params->sta_flags_mask, cur_byte);
+	cur_byte +=3D 2;
+	put_unaligned_le16(params->sta_flags_set, cur_byte);
+	cur_byte +=3D 2;
=20
 	return cur_byte - buff;
 }
=20
-static void handle_add_station(struct work_struct *work)
-{
-	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
-	struct wilc_vif *vif =3D msg->vif;
-	struct add_sta_param *param =3D &msg->body.add_sta_info;
-	int result;
-	struct wid wid;
-	u8 *cur_byte;
-
-	wid.id =3D WID_ADD_STA;
-	wid.type =3D WID_BIN;
-	wid.size =3D WILC_ADD_STA_LENGTH + param->rates_len;
-
-	wid.val =3D kmalloc(wid.size, GFP_KERNEL);
-	if (!wid.val)
-		goto error;
-
-	cur_byte =3D wid.val;
-	cur_byte +=3D wilc_hif_pack_sta_param(cur_byte, param);
-
-	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
-				      wilc_get_vif_idx(vif));
-	if (result !=3D 0)
-		netdev_err(vif->ndev, "Failed to send add station\n");
-
-error:
-	kfree(param->rates);
-	kfree(wid.val);
-	kfree(msg);
-}
-
 static void handle_del_all_sta(struct work_struct *work)
 {
 	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
@@ -2095,37 +2067,6 @@ static void handle_del_station(struct work_struct *w=
ork)
 	kfree(msg);
 }
=20
-static void handle_edit_station(struct work_struct *work)
-{
-	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
-	struct wilc_vif *vif =3D msg->vif;
-	struct add_sta_param *param =3D &msg->body.edit_sta_info;
-	int result;
-	struct wid wid;
-	u8 *cur_byte;
-
-	wid.id =3D WID_EDIT_STA;
-	wid.type =3D WID_BIN;
-	wid.size =3D WILC_ADD_STA_LENGTH + param->rates_len;
-
-	wid.val =3D kmalloc(wid.size, GFP_KERNEL);
-	if (!wid.val)
-		goto error;
-
-	cur_byte =3D wid.val;
-	cur_byte +=3D wilc_hif_pack_sta_param(cur_byte, param);
-
-	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
-				      wilc_get_vif_idx(vif));
-	if (result)
-		netdev_err(vif->ndev, "Failed to send edit station\n");
-
-error:
-	kfree(param->rates);
-	kfree(wid.val);
-	kfree(msg);
-}
-
 static int handle_remain_on_chan(struct wilc_vif *vif,
 				 struct remain_ch *hif_remain_ch)
 {
@@ -3484,34 +3425,30 @@ int wilc_del_beacon(struct wilc_vif *vif)
 	return result;
 }
=20
-int wilc_add_station(struct wilc_vif *vif, struct add_sta_param *sta_param=
)
+int wilc_add_station(struct wilc_vif *vif, const u8 *mac,
+		     struct station_parameters *params)
 {
+	struct wid wid;
 	int result;
-	struct host_if_msg *msg;
-	struct add_sta_param *add_sta_info;
+	u8 *cur_byte;
=20
-	msg =3D wilc_alloc_work(vif, handle_add_station, false);
-	if (IS_ERR(msg))
-		return PTR_ERR(msg);
+	wid.id =3D WID_ADD_STA;
+	wid.type =3D WID_BIN;
+	wid.size =3D WILC_ADD_STA_LENGTH + params->supported_rates_len;
+	wid.val =3D kmalloc(wid.size, GFP_KERNEL);
+	if (!wid.val)
+		return -ENOMEM;
=20
-	add_sta_info =3D &msg->body.add_sta_info;
-	memcpy(add_sta_info, sta_param, sizeof(struct add_sta_param));
-	if (add_sta_info->rates_len > 0) {
-		add_sta_info->rates =3D kmemdup(sta_param->rates,
-					      add_sta_info->rates_len,
-					      GFP_KERNEL);
-		if (!add_sta_info->rates) {
-			kfree(msg);
-			return -ENOMEM;
-		}
-	}
+	cur_byte =3D wid.val;
+	cur_byte +=3D wilc_hif_pack_sta_param(cur_byte, mac, params);
+
+	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
+				      wilc_get_vif_idx(vif));
+	if (result !=3D 0)
+		netdev_err(vif->ndev, "Failed to send add station\n");
+
+	kfree(wid.val);
=20
-	result =3D wilc_enqueue_work(msg);
-	if (result) {
-		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
-		kfree(add_sta_info->rates);
-		kfree(msg);
-	}
 	return result;
 }
=20
@@ -3580,36 +3517,29 @@ int wilc_del_allstation(struct wilc_vif *vif, u8 ma=
c_addr[][ETH_ALEN])
 	return result;
 }
=20
-int wilc_edit_station(struct wilc_vif *vif,
-		      struct add_sta_param *sta_param)
+int wilc_edit_station(struct wilc_vif *vif, const u8 *mac,
+		      struct station_parameters *params)
 {
+	struct wid wid;
 	int result;
-	struct host_if_msg *msg;
-	struct add_sta_param *add_sta_info;
+	u8 *cur_byte;
=20
-	msg =3D wilc_alloc_work(vif, handle_edit_station, false);
-	if (IS_ERR(msg))
-		return PTR_ERR(msg);
+	wid.id =3D WID_EDIT_STA;
+	wid.type =3D WID_BIN;
+	wid.size =3D WILC_ADD_STA_LENGTH + params->supported_rates_len;
+	wid.val =3D kmalloc(wid.size, GFP_KERNEL);
+	if (!wid.val)
+		return -ENOMEM;
=20
-	add_sta_info =3D &msg->body.add_sta_info;
-	memcpy(add_sta_info, sta_param, sizeof(*add_sta_info));
-	if (add_sta_info->rates_len > 0) {
-		add_sta_info->rates =3D kmemdup(sta_param->rates,
-					      add_sta_info->rates_len,
-					      GFP_KERNEL);
-		if (!add_sta_info->rates) {
-			kfree(msg);
-			return -ENOMEM;
-		}
-	}
+	cur_byte =3D wid.val;
+	cur_byte +=3D wilc_hif_pack_sta_param(cur_byte, mac, params);
=20
-	result =3D wilc_enqueue_work(msg);
-	if (result) {
-		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
-		kfree(add_sta_info->rates);
-		kfree(msg);
-	}
+	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
+				      wilc_get_vif_idx(vif));
+	if (result)
+		netdev_err(vif->ndev, "Failed to send edit station\n");
=20
+	kfree(wid.val);
 	return result;
 }
=20
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index 7a71cb6..bebf0c6 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -326,11 +326,12 @@ int wilc_deinit(struct wilc_vif *vif);
 int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 dtim_period,
 		    u32 head_len, u8 *head, u32 tail_len, u8 *tail);
 int wilc_del_beacon(struct wilc_vif *vif);
-int wilc_add_station(struct wilc_vif *vif, struct add_sta_param *sta_param=
);
+int wilc_add_station(struct wilc_vif *vif, const u8 *mac,
+		     struct station_parameters *params);
 int wilc_del_allstation(struct wilc_vif *vif, u8 mac_addr[][ETH_ALEN]);
 int wilc_del_station(struct wilc_vif *vif, const u8 *mac_addr);
-int wilc_edit_station(struct wilc_vif *vif,
-		      struct add_sta_param *sta_param);
+int wilc_edit_station(struct wilc_vif *vif, const u8 *mac,
+		      struct station_parameters *params);
 int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 timeout);
 int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled, u32 co=
unt,
 				u8 *mc_list);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/st=
aging/wilc1000/wilc_wfi_cfgoperations.c
index 69b181f..bbe68ba 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1818,28 +1818,13 @@ static int add_station(struct wiphy *wiphy, struct =
net_device *dev,
 {
 	int ret =3D 0;
 	struct wilc_priv *priv =3D wiphy_priv(wiphy);
-	struct add_sta_param sta_params =3D { {0} };
 	struct wilc_vif *vif =3D netdev_priv(dev);
=20
 	if (vif->iftype =3D=3D WILC_AP_MODE || vif->iftype =3D=3D WILC_GO_MODE) {
-		memcpy(sta_params.bssid, mac, ETH_ALEN);
 		memcpy(priv->assoc_stainfo.sta_associated_bss[params->aid], mac,
 		       ETH_ALEN);
-		sta_params.aid =3D params->aid;
-		sta_params.rates_len =3D params->supported_rates_len;
-		sta_params.rates =3D params->supported_rates;
=20
-		if (!params->ht_capa) {
-			sta_params.ht_supported =3D false;
-		} else {
-			sta_params.ht_supported =3D true;
-			sta_params.ht_capa =3D *params->ht_capa;
-		}
-
-		sta_params.flags_mask =3D params->sta_flags_mask;
-		sta_params.flags_set =3D params->sta_flags_set;
-
-		ret =3D wilc_add_station(vif, &sta_params);
+		ret =3D wilc_add_station(vif, mac, params);
 		if (ret)
 			netdev_err(dev, "Host add station fail\n");
 	}
@@ -1874,26 +1859,10 @@ static int change_station(struct wiphy *wiphy, stru=
ct net_device *dev,
 			  const u8 *mac, struct station_parameters *params)
 {
 	int ret =3D 0;
-	struct add_sta_param sta_params =3D { {0} };
 	struct wilc_vif *vif =3D netdev_priv(dev);
=20
 	if (vif->iftype =3D=3D WILC_AP_MODE || vif->iftype =3D=3D WILC_GO_MODE) {
-		memcpy(sta_params.bssid, mac, ETH_ALEN);
-		sta_params.aid =3D params->aid;
-		sta_params.rates_len =3D params->supported_rates_len;
-		sta_params.rates =3D params->supported_rates;
-
-		if (!params->ht_capa) {
-			sta_params.ht_supported =3D false;
-		} else {
-			sta_params.ht_supported =3D true;
-			sta_params.ht_capa =3D *params->ht_capa;
-		}
-
-		sta_params.flags_mask =3D params->sta_flags_mask;
-		sta_params.flags_set =3D params->sta_flags_set;
-
-		ret =3D wilc_edit_station(vif, &sta_params);
+		ret =3D wilc_edit_station(vif, mac, params);
 		if (ret)
 			netdev_err(dev, "Host edit station fail\n");
 	}
--=20
2.7.4

