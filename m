Return-Path: <SRS0=z7UY=PZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE0EDC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:21:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DFD220652
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:21:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="1NZ5scPY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727648AbfAQNVi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jan 2019 08:21:38 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:61724 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726954AbfAQNVi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jan 2019 08:21:38 -0500
X-IronPort-AV: E=Sophos;i="5.56,489,1539673200"; 
   d="scan'208";a="25443330"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 17 Jan 2019 06:21:35 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.49) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 17 Jan 2019 06:21:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RPuZHMFFcmj51pgrbPSJW+HQnGFHbu1ekT475MAUSYs=;
 b=1NZ5scPYfgnBmygbmUVd1BdfB6JD6HvLNzhYM/PkV3ok55wwhJA0rcqBsSYQMDUrvT39sFEyckCpeTCLpnVjRrokO6w99vk9No71I8vh/VmtzmvOOMzjcxBzNiCvS2XhQVqohih7nT4ga8jfayDK8+t2Cjv8w90e3/ao23wtu7Q=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3464.namprd11.prod.outlook.com (20.177.187.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.26; Thu, 17 Jan 2019 13:21:33 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::c110:8559:a438:491d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::c110:8559:a438:491d%3]) with mapi id 15.20.1516.019; Thu, 17 Jan 2019
 13:21:33 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 09/13] staging: wilc1000: use single struct for 'connect'
 related parameters
Thread-Topic: [PATCH 09/13] staging: wilc1000: use single struct for 'connect'
 related parameters
Thread-Index: AQHUrmeQQzSFTsK6x0qFpTvC9lDO6w==
Date:   Thu, 17 Jan 2019 13:21:32 +0000
Message-ID: <1547731250-18518-10-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3464;6:wbTPiLKVhzgvCOg8MLxqy5gwNmMnXEieK20WdPfSx9Z7oUaWshFczG63lElsYKvX78A/TEYAGEPH73zBpUOMyK+YMW4xZ/OhjIo8zvXL67x+l9SNmTzkw7v8K4jEuUcPUDme+SOiwZwESiBFV27SnK4dx8xHYgTSRgRYBtXYV458umijZpt72SPFyEKDm+FuulWK+fVylrOgqrYwfQ4ehJ4Wx29M+qIrjHQZnxgr1aPKeowdYk0A+WneUOsBkKgj4sdoQOq0cwE6KHc+D/Ng6Jqb7FJflRfzm2MmZzvx4gtzQDrYqg5ZNduNGqJkUw2AS6U2yEYfH1vKulZDkqU/zQKtS2CtOkyr92xwLOvkvE4DtLvrpU4hbD2ZgZM5EuOnBNicr7f+pSvK18Pc8O8ZNgzb5eHNmjK8zJFNVSMK9M+WmuS87NWODCkQMMxTTYghZYkBK1SGdIHaPyZ4Pr7U7Q==;5:hSTJ4b1vHSu2I03YeXZOlzp8Z+MY26Panv3zNOjGRvDI6ttt5q14QLhHqtMW+av6UNWjyOyOqD1GnRt8ZWV3zEpF+41HmmBEQvRpe6mFaG6ozNJQCm6cMyYe2ZvS99wsOAnP1LiS5oIhYTAVq2iYF6VWHJuEM7ZogJmDPn14CalOH0Sq3MGXE4ysLgzNBiZpczCcmqpdrXpZUWakp11e0Q==;7:+s5j16GrZDNI1r5WxZkiPYv4+xd6ceB0IyuZ5cd5C3Nh9eqGAigabMHmbfPecfiTggP0Ea2zpridpxx0nSCU1qCbn0VbdNberURK2NHmCPJVuHrSEcgzVKiNiTWoDD7tamVuUMS8iH708NyG4kVhBw==
x-ms-office365-filtering-correlation-id: 4209f1ed-1828-4344-8da6-08d67c7eb2a8
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3464;
x-ms-traffictypediagnostic: BYAPR11MB3464:
x-microsoft-antispam-prvs: <BYAPR11MB3464C0E50EFEB35D82159852E3830@BYAPR11MB3464.namprd11.prod.outlook.com>
x-forefront-prvs: 0920602B08
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(136003)(39860400002)(376002)(396003)(199004)(189003)(14454004)(68736007)(81166006)(81156014)(5660300001)(8936002)(2906002)(53946003)(106356001)(8676002)(26005)(305945005)(7736002)(6486002)(6436002)(5640700003)(36756003)(86362001)(99286004)(478600001)(6916009)(30864003)(50226002)(72206003)(78486014)(76176011)(2501003)(66066001)(4326008)(97736004)(486006)(25786009)(6506007)(476003)(102836004)(14444005)(256004)(386003)(53936002)(2616005)(54906003)(6512007)(71190400001)(71200400001)(105586002)(107886003)(3846002)(52116002)(186003)(2351001)(6116002)(316002)(11346002)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3464;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NmbXepw4ClIGJnHWFhxJidTbDN6xtMl/5+v9WZIOFXs89erXfnlLTCbKBC/XNiOt/FNQ99UGdCaJ4EKbW1RtR39jmiBWlRjYglWyO9sgMHj0umoSTAxj0FgAyYErYK2VCQLVVmGtRxxFn2mFUlFZB/o3pcLxrkakox2IiajKuzs6t2OBPska0Y6dETSFmOmun72Wqp3JKRAJqQDoglkrAa79jHkUPNQTXmWxvOUd95elxbt0IZOYis1YT9jB6cEpT2dQfvmygn5ScWd/7RaZqnY5h6xiOHDwcL5G4ZkKHbFQl+FpzBMuh0LU6StBVpSgulyphuktJTbqNPormzH0kZpf8YIyEvGHrepcw45G7ZDqZYPYIanGbfsRxsHR1lpIH++Q+QWficmTWBW75yC9Ip2O+2Ny7Mg+Y+DTQpywHnY=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4209f1ed-1828-4344-8da6-08d67c7eb2a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2019 13:21:30.5834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3464
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Use single structure to store the connect request and response
information. It helped in avoiding unnecessary buffer allocation to
handle request and response flow.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         | 217 ++++++------------=
----
 drivers/staging/wilc1000/host_interface.h         |  41 ++--
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  30 +--
 3 files changed, 84 insertions(+), 204 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 6c2be43..e37d8ab 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -344,8 +344,8 @@ static int wilc_send_connect_wid(struct wilc_vif *vif)
 	struct wid wid_list[8];
 	u32 wid_cnt =3D 0, dummyval =3D 0;
 	struct host_if_drv *hif_drv =3D vif->hif_drv;
-	struct user_conn_req *conn_attr =3D &hif_drv->usr_conn_req;
-	struct wilc_join_bss_param *bss_param =3D hif_drv->usr_conn_req.param;
+	struct wilc_conn_info *conn_attr =3D &hif_drv->conn_info;
+	struct wilc_join_bss_param *bss_param =3D conn_attr->param;
=20
 	wid_list[wid_cnt].id =3D WID_SUCCESS_FRAME_COUNT;
 	wid_list[wid_cnt].type =3D WID_INT;
@@ -367,8 +367,8 @@ static int wilc_send_connect_wid(struct wilc_vif *vif)
=20
 	wid_list[wid_cnt].id =3D WID_INFO_ELEMENT_ASSOCIATE;
 	wid_list[wid_cnt].type =3D WID_BIN_DATA;
-	wid_list[wid_cnt].val =3D conn_attr->ies;
-	wid_list[wid_cnt].size =3D conn_attr->ies_len;
+	wid_list[wid_cnt].val =3D conn_attr->req_ies;
+	wid_list[wid_cnt].size =3D conn_attr->req_ies_len;
 	wid_cnt++;
=20
 	wid_list[wid_cnt].id =3D WID_11I_MODE;
@@ -403,14 +403,8 @@ static int wilc_send_connect_wid(struct wilc_vif *vif)
=20
 error:
=20
-	kfree(conn_attr->bssid);
-	conn_attr->bssid =3D NULL;
-
-	kfree(conn_attr->ssid);
-	conn_attr->ssid =3D NULL;
-
-	kfree(conn_attr->ies);
-	conn_attr->ies =3D NULL;
+	kfree(conn_attr->req_ies);
+	conn_attr->req_ies =3D NULL;
=20
 	return result;
 }
@@ -420,7 +414,6 @@ static void handle_connect_timeout(struct work_struct *=
work)
 	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif =3D msg->vif;
 	int result;
-	struct connect_info info;
 	struct wid wid;
 	u16 dummy_reason_code =3D 0;
 	struct host_if_drv *hif_drv =3D vif->hif_drv;
@@ -432,31 +425,11 @@ static void handle_connect_timeout(struct work_struct=
 *work)
=20
 	hif_drv->hif_state =3D HOST_IF_IDLE;
=20
-	memset(&info, 0, sizeof(struct connect_info));
-
-	if (hif_drv->usr_conn_req.conn_result) {
-		if (hif_drv->usr_conn_req.bssid) {
-			memcpy(info.bssid,
-			       hif_drv->usr_conn_req.bssid, 6);
-		}
-
-		if (hif_drv->usr_conn_req.ies) {
-			info.req_ies_len =3D hif_drv->usr_conn_req.ies_len;
-			info.req_ies =3D kmemdup(hif_drv->usr_conn_req.ies,
-					       hif_drv->usr_conn_req.ies_len,
-					       GFP_KERNEL);
-			if (!info.req_ies)
-				goto out;
-		}
-
-		hif_drv->usr_conn_req.conn_result(CONN_DISCONN_EVENT_CONN_RESP,
-						  &info,
-						  WILC_MAC_STATUS_DISCONNECTED,
-						  NULL,
-						  hif_drv->usr_conn_req.arg);
+	if (hif_drv->conn_info.conn_result) {
+		hif_drv->conn_info.conn_result(CONN_DISCONN_EVENT_CONN_RESP,
+					       WILC_MAC_STATUS_DISCONNECTED,
+					       NULL, hif_drv->conn_info.arg);
=20
-		kfree(info.req_ies);
-		info.req_ies =3D NULL;
 	} else {
 		netdev_err(vif->ndev, "%s: conn_result is NULL\n", __func__);
 	}
@@ -471,14 +444,9 @@ static void handle_connect_timeout(struct work_struct =
*work)
 	if (result)
 		netdev_err(vif->ndev, "Failed to send disconnect\n");
=20
-	hif_drv->usr_conn_req.ssid_len =3D 0;
-	kfree(hif_drv->usr_conn_req.ssid);
-	hif_drv->usr_conn_req.ssid =3D NULL;
-	kfree(hif_drv->usr_conn_req.bssid);
-	hif_drv->usr_conn_req.bssid =3D NULL;
-	hif_drv->usr_conn_req.ies_len =3D 0;
-	kfree(hif_drv->usr_conn_req.ies);
-	hif_drv->usr_conn_req.ies =3D NULL;
+	hif_drv->conn_info.req_ies_len =3D 0;
+	kfree(hif_drv->conn_info.req_ies);
+	hif_drv->conn_info.req_ies =3D NULL;
=20
 out:
 	kfree(msg);
@@ -671,20 +639,8 @@ static void host_int_get_assoc_res_info(struct wilc_vi=
f *vif,
 	*rcvd_assoc_resp_info_len =3D wid.size;
 }
=20
-static inline void host_int_free_user_conn_req(struct host_if_drv *hif_drv=
)
-{
-	hif_drv->usr_conn_req.ssid_len =3D 0;
-	kfree(hif_drv->usr_conn_req.ssid);
-	hif_drv->usr_conn_req.ssid =3D NULL;
-	kfree(hif_drv->usr_conn_req.bssid);
-	hif_drv->usr_conn_req.bssid =3D NULL;
-	hif_drv->usr_conn_req.ies_len =3D 0;
-	kfree(hif_drv->usr_conn_req.ies);
-	hif_drv->usr_conn_req.ies =3D NULL;
-}
-
 static s32 wilc_parse_assoc_resp_info(u8 *buffer, u32 buffer_len,
-				      struct connect_info *ret_conn_info)
+				      struct wilc_conn_info *ret_conn_info)
 {
 	u8 *ies;
 	u16 ies_len;
@@ -708,10 +664,8 @@ static s32 wilc_parse_assoc_resp_info(u8 *buffer, u32 =
buffer_len,
 static inline void host_int_parse_assoc_resp_info(struct wilc_vif *vif,
 						  u8 mac_status)
 {
-	struct connect_info conn_info;
 	struct host_if_drv *hif_drv =3D vif->hif_drv;
-
-	memset(&conn_info, 0, sizeof(struct connect_info));
+	struct wilc_conn_info *conn_info =3D &hif_drv->conn_info;
=20
 	if (mac_status =3D=3D WILC_MAC_STATUS_CONNECTED) {
 		u32 assoc_resp_info_len;
@@ -727,7 +681,7 @@ static inline void host_int_parse_assoc_resp_info(struc=
t wilc_vif *vif,
=20
 			err =3D wilc_parse_assoc_resp_info(hif_drv->assoc_resp,
 							 assoc_resp_info_len,
-							 &conn_info);
+							 conn_info);
 			if (err)
 				netdev_err(vif->ndev,
 					   "wilc_parse_assoc_resp_info() returned error %d\n",
@@ -735,31 +689,13 @@ static inline void host_int_parse_assoc_resp_info(str=
uct wilc_vif *vif,
 		}
 	}
=20
-	if (hif_drv->usr_conn_req.bssid) {
-		memcpy(conn_info.bssid, hif_drv->usr_conn_req.bssid, 6);
-
-		if (mac_status =3D=3D WILC_MAC_STATUS_CONNECTED &&
-		    conn_info.status =3D=3D WLAN_STATUS_SUCCESS) {
-			memcpy(hif_drv->assoc_bssid,
-			       hif_drv->usr_conn_req.bssid, ETH_ALEN);
-		}
-	}
-
-	if (hif_drv->usr_conn_req.ies) {
-		conn_info.req_ies =3D kmemdup(hif_drv->usr_conn_req.ies,
-					    hif_drv->usr_conn_req.ies_len,
-					    GFP_KERNEL);
-		if (conn_info.req_ies)
-			conn_info.req_ies_len =3D hif_drv->usr_conn_req.ies_len;
-	}
-
 	del_timer(&hif_drv->connect_timer);
-	hif_drv->usr_conn_req.conn_result(CONN_DISCONN_EVENT_CONN_RESP,
-					  &conn_info, mac_status, NULL,
-					  hif_drv->usr_conn_req.arg);
+	conn_info->conn_result(CONN_DISCONN_EVENT_CONN_RESP, mac_status, NULL,
+			       hif_drv->conn_info.arg);
=20
 	if (mac_status =3D=3D WILC_MAC_STATUS_CONNECTED &&
-	    conn_info.status =3D=3D WLAN_STATUS_SUCCESS) {
+	    conn_info->status =3D=3D WLAN_STATUS_SUCCESS) {
+		ether_addr_copy(hif_drv->assoc_bssid, conn_info->bssid);
 		wilc_set_power_mgmt(vif, 0, 0);
=20
 		hif_drv->hif_state =3D HOST_IF_CONNECTED;
@@ -771,19 +707,19 @@ static inline void host_int_parse_assoc_resp_info(str=
uct wilc_vif *vif,
 		hif_drv->hif_state =3D HOST_IF_IDLE;
 	}
=20
-	kfree(conn_info.resp_ies);
-	conn_info.resp_ies =3D NULL;
+	kfree(conn_info->resp_ies);
+	conn_info->resp_ies =3D NULL;
+	conn_info->resp_ies_len =3D 0;
=20
-	kfree(conn_info.req_ies);
-	conn_info.req_ies =3D NULL;
-	host_int_free_user_conn_req(hif_drv);
+	kfree(conn_info->req_ies);
+	conn_info->req_ies =3D NULL;
+	conn_info->req_ies_len =3D 0;
 }
=20
 static inline void host_int_handle_disconnect(struct wilc_vif *vif)
 {
 	struct disconnect_info disconn_info;
 	struct host_if_drv *hif_drv =3D vif->hif_drv;
-	wilc_connect_result conn_result =3D hif_drv->usr_conn_req.conn_result;
=20
 	memset(&disconn_info, 0, sizeof(struct disconnect_info));
=20
@@ -796,19 +732,22 @@ static inline void host_int_handle_disconnect(struct =
wilc_vif *vif)
 	disconn_info.ie =3D NULL;
 	disconn_info.ie_len =3D 0;
=20
-	if (conn_result) {
+	if (hif_drv->conn_info.conn_result) {
 		vif->obtaining_ip =3D false;
 		wilc_set_power_mgmt(vif, 0, 0);
=20
-		conn_result(CONN_DISCONN_EVENT_DISCONN_NOTIF, NULL, 0,
-			    &disconn_info, hif_drv->usr_conn_req.arg);
+		hif_drv->conn_info.conn_result(CONN_DISCONN_EVENT_DISCONN_NOTIF,
+					       0, &disconn_info,
+					       hif_drv->conn_info.arg);
 	} else {
 		netdev_err(vif->ndev, "%s: conn_result is NULL\n", __func__);
 	}
=20
 	eth_zero_addr(hif_drv->assoc_bssid);
=20
-	host_int_free_user_conn_req(hif_drv);
+	hif_drv->conn_info.req_ies_len =3D 0;
+	kfree(hif_drv->conn_info.req_ies);
+	hif_drv->conn_info.req_ies =3D NULL;
 	hif_drv->hif_state =3D HOST_IF_IDLE;
 }
=20
@@ -834,7 +773,7 @@ static void handle_rcvd_gnrl_async_info(struct work_str=
uct *work)
 	if (hif_drv->hif_state =3D=3D HOST_IF_WAITING_CONN_RESP ||
 	    hif_drv->hif_state =3D=3D HOST_IF_CONNECTED ||
 	    hif_drv->usr_scan_req.scan_result) {
-		if (!hif_drv->usr_conn_req.conn_result) {
+		if (!hif_drv->conn_info.conn_result) {
 			netdev_err(vif->ndev, "%s: conn_result is NULL\n",
 				   __func__);
 			goto free_rcvd_info;
@@ -875,7 +814,7 @@ int wilc_disconnect(struct wilc_vif *vif)
 	struct host_if_drv *hif_drv =3D vif->hif_drv;
 	struct disconnect_info disconn_info;
 	struct user_scan_req *scan_req;
-	struct user_conn_req *conn_req;
+	struct wilc_conn_info *conn_info;
 	int result;
 	u16 dummy_reason_code =3D 0;
=20
@@ -900,7 +839,7 @@ int wilc_disconnect(struct wilc_vif *vif)
 	disconn_info.ie =3D NULL;
 	disconn_info.ie_len =3D 0;
 	scan_req =3D &hif_drv->usr_scan_req;
-	conn_req =3D &hif_drv->usr_conn_req;
+	conn_info =3D &hif_drv->conn_info;
=20
 	if (scan_req->scan_result) {
 		del_timer(&hif_drv->scan_timer);
@@ -908,12 +847,12 @@ int wilc_disconnect(struct wilc_vif *vif)
 		scan_req->scan_result =3D NULL;
 	}
=20
-	if (conn_req->conn_result) {
+	if (conn_info->conn_result) {
 		if (hif_drv->hif_state =3D=3D HOST_IF_WAITING_CONN_RESP)
 			del_timer(&hif_drv->connect_timer);
=20
-		conn_req->conn_result(CONN_DISCONN_EVENT_DISCONN_NOTIF, NULL,
-				      0, &disconn_info, conn_req->arg);
+		conn_info->conn_result(CONN_DISCONN_EVENT_DISCONN_NOTIF,
+				       0, &disconn_info, conn_info->arg);
 	} else {
 		netdev_err(vif->ndev, "%s: conn_result is NULL\n", __func__);
 	}
@@ -922,14 +861,9 @@ int wilc_disconnect(struct wilc_vif *vif)
=20
 	eth_zero_addr(hif_drv->assoc_bssid);
=20
-	conn_req->ssid_len =3D 0;
-	kfree(conn_req->ssid);
-	conn_req->ssid =3D NULL;
-	kfree(conn_req->bssid);
-	conn_req->bssid =3D NULL;
-	conn_req->ies_len =3D 0;
-	kfree(conn_req->ies);
-	conn_req->ies =3D NULL;
+	conn_info->req_ies_len =3D 0;
+	kfree(conn_info->req_ies);
+	conn_info->req_ies =3D NULL;
=20
 	return 0;
 }
@@ -1546,61 +1480,22 @@ int wilc_get_mac_address(struct wilc_vif *vif, u8 *=
mac_addr)
 	return result;
 }
=20
-int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
-		      size_t ssid_len, const u8 *ies, size_t ies_len,
-		      wilc_connect_result connect_result, void *user_arg,
-		      u8 security, enum authtype auth_type,
-		      u8 channel, void *join_params)
+int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ies,
+		      size_t ies_len)
 {
 	int result;
 	struct host_if_drv *hif_drv =3D vif->hif_drv;
-	struct user_conn_req *con_info =3D &hif_drv->usr_conn_req;
+	struct wilc_conn_info *conn_info =3D &hif_drv->conn_info;
=20
-	if (!hif_drv || !connect_result) {
-		netdev_err(vif->ndev,
-			   "%s: hif driver or connect result is NULL",
-			   __func__);
-		return -EFAULT;
-	}
-
-	if (!join_params) {
-		netdev_err(vif->ndev, "%s: joinparams is NULL\n", __func__);
-		return -EFAULT;
-	}
-
-	if (hif_drv->usr_scan_req.scan_result) {
-		netdev_err(vif->ndev, "%s: Scan in progress\n", __func__);
-		return -EBUSY;
-	}
-
-	con_info->security =3D security;
-	con_info->auth_type =3D auth_type;
-	con_info->ch =3D channel;
-	con_info->conn_result =3D connect_result;
-	con_info->arg =3D user_arg;
-	con_info->param =3D join_params;
-
-	if (bssid) {
-		con_info->bssid =3D kmemdup(bssid, 6, GFP_KERNEL);
-		if (!con_info->bssid)
-			return -ENOMEM;
-	}
-
-	if (ssid) {
-		con_info->ssid_len =3D ssid_len;
-		con_info->ssid =3D kmemdup(ssid, ssid_len, GFP_KERNEL);
-		if (!con_info->ssid) {
-			result =3D -ENOMEM;
-			goto free_bssid;
-		}
-	}
+	if (bssid)
+		ether_addr_copy(conn_info->bssid, bssid);
=20
 	if (ies) {
-		con_info->ies_len =3D ies_len;
-		con_info->ies =3D kmemdup(ies, ies_len, GFP_KERNEL);
-		if (!con_info->ies) {
+		conn_info->req_ies_len =3D ies_len;
+		conn_info->req_ies =3D kmemdup(ies, ies_len, GFP_KERNEL);
+		if (!conn_info->req_ies) {
 			result =3D -ENOMEM;
-			goto free_ssid;
+			return result;
 		}
 	}
=20
@@ -1615,13 +1510,7 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssi=
d, const u8 *ssid,
 	return 0;
=20
 free_ies:
-	kfree(con_info->ies);
-
-free_ssid:
-	kfree(con_info->ssid);
-
-free_bssid:
-	kfree(con_info->bssid);
+	kfree(conn_info->req_ies);
=20
 	return result;
 }
@@ -1963,7 +1852,7 @@ void wilc_gnrl_async_info_received(struct wilc *wilc,=
 u8 *buffer, u32 length)
 		return;
 	}
=20
-	if (!hif_drv->usr_conn_req.conn_result) {
+	if (!hif_drv->conn_info.conn_result) {
 		netdev_err(vif->ndev, "%s: conn_result is NULL\n", __func__);
 		mutex_unlock(&hif_deinit_lock);
 		return;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index e702404..459a084 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -35,15 +35,6 @@ enum {
=20
 #define WILC_MAX_ASSOC_RESP_FRAME_SIZE   256
=20
-struct connect_info {
-	u8 bssid[6];
-	u8 *req_ies;
-	size_t req_ies_len;
-	u8 *resp_ies;
-	u16 resp_ies_len;
-	u16 status;
-};
-
 struct disconnect_info {
 	u16 reason;
 	u8 *ie;
@@ -122,12 +113,6 @@ struct wilc_rcvd_net_info {
 typedef void (*wilc_scan_result)(enum scan_event, struct wilc_rcvd_net_inf=
o *,
 				 void *);
=20
-typedef void (*wilc_connect_result)(enum conn_event,
-				     struct connect_info *,
-				     u8,
-				     struct disconnect_info *,
-				     void *);
-
 typedef void (*wilc_remain_on_chan_expired)(void *, u32);
 typedef void (*wilc_remain_on_chan_ready)(void *);
=20
@@ -148,17 +133,18 @@ struct user_scan_req {
 	u32 ch_cnt;
 };
=20
-struct user_conn_req {
-	u8 *bssid;
-	u8 *ssid;
+struct wilc_conn_info {
+	u8 bssid[ETH_ALEN];
 	u8 security;
 	enum authtype auth_type;
-	size_t ssid_len;
-	u8 *ies;
-	size_t ies_len;
-	wilc_connect_result conn_result;
-	bool ht_capable;
 	u8 ch;
+	u8 *req_ies;
+	size_t req_ies_len;
+	u8 *resp_ies;
+	u16 resp_ies_len;
+	u16 status;
+	void (*conn_result)(enum conn_event evt, u8 status,
+			    struct disconnect_info *info, void *priv_data);
 	void *arg;
 	void *param;
 };
@@ -175,7 +161,7 @@ struct remain_ch {
 struct wilc;
 struct host_if_drv {
 	struct user_scan_req usr_scan_req;
-	struct user_conn_req usr_conn_req;
+	struct wilc_conn_info conn_info;
 	struct remain_ch remain_on_ch;
 	u8 remain_on_ch_pending;
 	u64 p2p_timeout;
@@ -228,11 +214,8 @@ int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *rx=
_gtk, u8 gtk_key_len,
 		    u8 cipher_mode);
 int wilc_set_pmkid_info(struct wilc_vif *vif, struct wilc_pmkid_attr *pmki=
d);
 int wilc_get_mac_address(struct wilc_vif *vif, u8 *mac_addr);
-int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
-		      size_t ssid_len, const u8 *ies, size_t ies_len,
-		      wilc_connect_result connect_result, void *user_arg,
-		      u8 security, enum authtype auth_type,
-		      u8 channel, void *join_params);
+int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ies,
+		      size_t ies_len);
 int wilc_disconnect(struct wilc_vif *vif);
 int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel);
 int wilc_get_rssi(struct wilc_vif *vif, s8 *rssi_level);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/st=
aging/wilc1000/wilc_wfi_cfgoperations.c
index 1762c60..bc1d7a7 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -139,9 +139,7 @@ static void cfg_scan_result(enum scan_event scan_event,
 	}
 }
=20
-static void cfg_connect_result(enum conn_event conn_disconn_evt,
-			       struct connect_info *conn_info,
-			       u8 mac_status,
+static void cfg_connect_result(enum conn_event conn_disconn_evt, u8 mac_st=
atus,
 			       struct disconnect_info *disconn_info,
 			       void *priv_data)
 {
@@ -150,16 +148,15 @@ static void cfg_connect_result(enum conn_event conn_d=
isconn_evt,
 	struct wilc_vif *vif =3D netdev_priv(dev);
 	struct wilc *wl =3D vif->wilc;
 	struct host_if_drv *wfi_drv =3D priv->hif_drv;
+	struct wilc_conn_info *conn_info =3D &wfi_drv->conn_info;
=20
 	vif->connecting =3D false;
=20
 	if (conn_disconn_evt =3D=3D CONN_DISCONN_EVENT_CONN_RESP) {
-		u16 connect_status;
-
-		connect_status =3D conn_info->status;
+		u16 connect_status =3D conn_info->status;
=20
 		if (mac_status =3D=3D WILC_MAC_STATUS_DISCONNECTED &&
-		    conn_info->status =3D=3D WLAN_STATUS_SUCCESS) {
+		    connect_status =3D=3D WLAN_STATUS_SUCCESS) {
 			connect_status =3D WLAN_STATUS_UNSPECIFIED_FAILURE;
 			wilc_wlan_set_bssid(priv->dev, NULL, WILC_STATION_MODE);
=20
@@ -410,6 +407,12 @@ static int connect(struct wiphy *wiphy, struct net_dev=
ice *dev,
 			auth_type =3D WILC_FW_AUTH_IEEE8021;
 	}
=20
+	if (wfi_drv->usr_scan_req.scan_result) {
+		netdev_err(vif->ndev, "%s: Scan in progress\n", __func__);
+		ret =3D -EBUSY;
+		goto out_error;
+	}
+
 	bss =3D cfg80211_get_bss(wiphy, sme->channel, sme->bssid, sme->ssid,
 			       sme->ssid_len, IEEE80211_BSS_TYPE_ANY,
 			       IEEE80211_PRIVACY(sme->privacy));
@@ -438,16 +441,21 @@ static int connect(struct wiphy *wiphy, struct net_de=
vice *dev,
=20
 	wilc_wlan_set_bssid(dev, bss->bssid, WILC_STATION_MODE);
=20
-	ret =3D wilc_set_join_req(vif, bss->bssid, sme->ssid,
-				sme->ssid_len, sme->ie, sme->ie_len,
-				cfg_connect_result, (void *)priv,
-				security, auth_type, curr_channel, join_params);
+	wfi_drv->conn_info.security =3D security;
+	wfi_drv->conn_info.auth_type =3D auth_type;
+	wfi_drv->conn_info.ch =3D curr_channel;
+	wfi_drv->conn_info.conn_result =3D cfg_connect_result;
+	wfi_drv->conn_info.arg =3D priv;
+	wfi_drv->conn_info.param =3D join_params;
+
+	ret =3D wilc_set_join_req(vif, bss->bssid, sme->ie, sme->ie_len);
 	if (ret) {
 		netdev_err(dev, "wilc_set_join_req(): Error\n");
 		ret =3D -ENOENT;
 		if (!wfi_drv->p2p_connect)
 			wlan_channel =3D INVALID_CHANNEL;
 		wilc_wlan_set_bssid(dev, NULL, WILC_STATION_MODE);
+		wfi_drv->conn_info.conn_result =3D NULL;
 		kfree(join_params);
 		goto out_put_bss;
 	}
--=20
2.7.4

