Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 069D1C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 05:45:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BBD121527
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 05:45:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="FTQlrWRv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9BBD121527
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731323AbeKLPhM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 10:37:12 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:32674 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728269AbeKLPhM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 10:37:12 -0500
X-IronPort-AV: E=Sophos;i="5.54,494,1534834800"; 
   d="scan'208";a="23150823"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 11 Nov 2018 22:45:32 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.105) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 11 Nov 2018 22:45:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dQZKC8ZUyL/vDc/ay/TL8yJrY7ne1t3X9adhdGGFjbo=;
 b=FTQlrWRvU/Mi17w10wlu+ICXssK+5gpMflnxkYDxCHfZJUhlSbDle1Tz4fu1y2URaZl2aBJz85r9Q1sXgVhOmWgbTBWn9pFOC5xwxdjBI3Ij85hhUqfn0UHR9a74/bTBm4PyXqLvEd+TZT5hCHZUECXGD2+qAa2hn4/fhF4cpXA=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2599.namprd11.prod.outlook.com (52.135.227.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.21; Mon, 12 Nov 2018 05:45:29 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7%6]) with mapi id 15.20.1294.044; Mon, 12 Nov 2018
 05:45:29 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 10/12] staging: wilc1000: added 'WILC_' prefix for constants
 to have clear namespace
Thread-Topic: [PATCH 10/12] staging: wilc1000: added 'WILC_' prefix for
 constants to have clear namespace
Thread-Index: AQHUekrrgYivYpl2AEePhC1CU9LWRw==
Date:   Mon, 12 Nov 2018 05:45:29 +0000
Message-ID: <1542001458-20217-11-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2599;6:r9vEywJ9b/HIFgaUxI/QzuCK2B35RTJEEy4t5GaLD0K4y4+3a/soXU5hNkZGWaHuQMHS9ZDFecFRlxpQmx1tSptvxelj5M0wMeXs/43coAH5zoYpreiLl56Pm4oO2hJP6NbKuaWk5V+Jso50RZSaMy7YVHeTmaZN8CBj4/yO2sI5CWBNErpr3k/8XvLAcXmr37Ere4TpHMi3DG2SbjOslpF7qqLuTBL2hhVNkP9WuweZgCKJ42zkndBEOF0d3aUb0Has/iLDVTAkJhd4cqW5tdbyZL+Nb/194fN+5y3Cj8RwTMYqVeJufr8fnGaQCFuWBxcNqiz3N72U9Wbox0q6QCixHnna+jf/1Vu2GWZxBPe4/aUDTQeACfxWW2vuFf+7xVrY0LUKn5rTK22zn1uT+NvNxea63YYIL/SmoIRRSJDO5FHjxfW+Po/wo36bB/0wvKVEJhWLiHuuQ+U9QIajAg==;5:PQ9kjo64EI6Uu26kwQzzmO5dNm+Rwc3r2fCjC+AUIVQMuO6xFw8xZgtRlIoRdIkRWP47YoTy5rQkGu1Wtc+jmLLoeaJOWfd2V0IgO8HLqIdrOpJm1Xjrx2Pft8m9nmmJzbpomqRBOox+OiNQUWFHUMDusJ7/vfXvc6a32NXE4uw=;7:qki9b6j9A2SLQXlPrgw7f0FG+uUNbtG7jVygwJFggLAYZiQN/xEv6durL7V5i4umGSmvscokZ2P/2uFTkSstbB8TtWVn7O8qkMCP7mELfvDcBHFsoXIe2PEmxe/3bP2LeZHSpqhOnSwD1khTLGH8bQ==
x-ms-office365-filtering-correlation-id: bc38a3e3-cd1a-4760-2b78-08d648620d88
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390040)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2599;
x-ms-traffictypediagnostic: BYAPR11MB2599:
x-microsoft-antispam-prvs: <BYAPR11MB25994784046F1C4B65B3A13AE3C10@BYAPR11MB2599.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(21532816269658);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3002001)(3231402)(944501410)(52105112)(10201501046)(93006095)(93001095)(148016)(149066)(150057)(6041310)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123562045)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB2599;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2599;
x-forefront-prvs: 0854128AF0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(136003)(366004)(39860400002)(189003)(199004)(4326008)(25786009)(2906002)(6116002)(3846002)(72206003)(26005)(2351001)(14454004)(86362001)(575784001)(186003)(6436002)(478600001)(6486002)(105586002)(76176011)(106356001)(2501003)(107886003)(5640700003)(54906003)(52116002)(99286004)(102836004)(53936002)(14444005)(53946003)(256004)(6506007)(386003)(316002)(36756003)(486006)(8936002)(6916009)(11346002)(7736002)(305945005)(476003)(2616005)(68736007)(8676002)(71200400001)(97736004)(5660300001)(66066001)(446003)(81156014)(81166006)(6512007)(71190400001)(2900100001)(4744004)(579004)(569006);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2599;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: q6DVVvJXWHHEToKIzrXOkgyi7HGMEjGi/6S3llg/H+wd5Q1j9eOl1465x1Gs1FAhxqdFMe69sILjshBJpqNdvje++or6TezPKWBWaECmXorU/gw2rcuB0Gbiy62j500ICYIYs3AlF4bRhkdvJJad+wXO04aeuNSV/FTat9posqcQ1HarDSEse/Mwn010tCmtncuhX/VnawCn1P5gMuK4nz9FJr9zL0rLIwitZ8nsK+MtNPfI1VuOMxdiKB2UYyDMYPO6QWcxmQJamNUIJLNIx2hX/P5Edg8sJMVM0isWwHDSjOwwjI4P2yQt7xCMdNbN+ynA7vByUJNS50nkruRwCR8cFPgsP4/fHZ+d7sr0+HI=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: bc38a3e3-cd1a-4760-2b78-08d648620d88
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2018 05:45:29.5400
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

For better namespace added 'WILC_' prefix for driver specific constants.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         | 162 +++++++++++-------=
----
 drivers/staging/wilc1000/host_interface.h         |  59 ++++----
 drivers/staging/wilc1000/linux_wlan.c             |  20 +--
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  56 ++++----
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |   8 +-
 drivers/staging/wilc1000/wilc_wlan.c              |   4 +-
 6 files changed, 159 insertions(+), 150 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index c238d39..5ab426c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -94,7 +94,7 @@ struct set_multicast {
 };
=20
 struct del_all_sta {
-	u8 del_all_sta[MAX_NUM_STA][ETH_ALEN];
+	u8 del_all_sta[WILC_MAX_NUM_STA][ETH_ALEN];
 	u8 assoc_sta;
 };
=20
@@ -242,7 +242,7 @@ static struct wilc_vif *wilc_get_vif_from_idx(struct wi=
lc *wilc, int idx)
 {
 	int index =3D idx - 1;
=20
-	if (index < 0 || index >=3D NUM_CONCURRENT_IFC)
+	if (index < 0 || index >=3D WILC_NUM_CONCURRENT_IFC)
 		return NULL;
=20
 	return wilc->vif[index];
@@ -261,7 +261,7 @@ static void handle_set_channel(struct work_struct *work=
)
 	wid.val =3D (char *)&hif_set_ch->set_ch;
 	wid.size =3D sizeof(char);
=20
-	ret =3D wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
+	ret =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
 				   wilc_get_vif_idx(vif));
=20
 	if (ret)
@@ -284,7 +284,7 @@ static void handle_set_wfi_drv_handler(struct work_stru=
ct *work)
=20
 	hif_drv	=3D vif->hif_drv;
=20
-	buffer =3D kzalloc(DRV_HANDLER_SIZE, GFP_KERNEL);
+	buffer =3D kzalloc(WILC_DRV_HANDLER_SIZE, GFP_KERNEL);
 	if (!buffer)
 		goto free_msg;
=20
@@ -302,9 +302,9 @@ static void handle_set_wfi_drv_handler(struct work_stru=
ct *work)
 	wid.id =3D WID_SET_DRV_HANDLER;
 	wid.type =3D WID_STR;
 	wid.val =3D (s8 *)buffer;
-	wid.size =3D DRV_HANDLER_SIZE;
+	wid.size =3D WILC_DRV_HANDLER_SIZE;
=20
-	ret =3D wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
+	ret =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
 				   hif_drv->driver_handler_id);
 	if (ret)
 		netdev_err(vif->ndev, "Failed to set driver handler\n");
@@ -331,7 +331,7 @@ static void handle_set_operation_mode(struct work_struc=
t *work)
 	wid.val =3D (s8 *)&hif_op_mode->mode;
 	wid.size =3D sizeof(u32);
=20
-	ret =3D wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
+	ret =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
 				   wilc_get_vif_idx(vif));
=20
 	if (ret)
@@ -353,7 +353,7 @@ static void handle_get_mac_address(struct work_struct *=
work)
 	wid.val =3D get_mac_addr->mac_addr;
 	wid.size =3D ETH_ALEN;
=20
-	ret =3D wilc_send_config_pkt(vif, GET_CFG, &wid, 1,
+	ret =3D wilc_send_config_pkt(vif, WILC_GET_CFG, &wid, 1,
 				   wilc_get_vif_idx(vif));
=20
 	if (ret)
@@ -371,28 +371,28 @@ static void handle_cfg_param(struct work_struct *work=
)
 	struct wid wid_list[32];
 	int i =3D 0;
=20
-	if (param->flag & RETRY_SHORT) {
+	if (param->flag & WILC_CFG_PARAM_RETRY_SHORT) {
 		wid_list[i].id =3D WID_SHORT_RETRY_LIMIT;
 		wid_list[i].val =3D (s8 *)&param->short_retry_limit;
 		wid_list[i].type =3D WID_SHORT;
 		wid_list[i].size =3D sizeof(u16);
 		i++;
 	}
-	if (param->flag & RETRY_LONG) {
+	if (param->flag & WILC_CFG_PARAM_RETRY_LONG) {
 		wid_list[i].id =3D WID_LONG_RETRY_LIMIT;
 		wid_list[i].val =3D (s8 *)&param->long_retry_limit;
 		wid_list[i].type =3D WID_SHORT;
 		wid_list[i].size =3D sizeof(u16);
 		i++;
 	}
-	if (param->flag & FRAG_THRESHOLD) {
+	if (param->flag & WILC_CFG_PARAM_FRAG_THRESHOLD) {
 		wid_list[i].id =3D WID_FRAG_THRESHOLD;
 		wid_list[i].val =3D (s8 *)&param->frag_threshold;
 		wid_list[i].type =3D WID_SHORT;
 		wid_list[i].size =3D sizeof(u16);
 		i++;
 	}
-	if (param->flag & RTS_THRESHOLD) {
+	if (param->flag & WILC_CFG_PARAM_RTS_THRESHOLD) {
 		wid_list[i].id =3D WID_RTS_THRESHOLD;
 		wid_list[i].val =3D (s8 *)&param->rts_threshold;
 		wid_list[i].type =3D WID_SHORT;
@@ -400,7 +400,7 @@ static void handle_cfg_param(struct work_struct *work)
 		i++;
 	}
=20
-	ret =3D wilc_send_config_pkt(vif, SET_CFG, wid_list,
+	ret =3D wilc_send_config_pkt(vif, WILC_SET_CFG, wid_list,
 				   i, wilc_get_vif_idx(vif));
=20
 	if (ret)
@@ -424,7 +424,7 @@ static int handle_scan_done(struct wilc_vif *vif, enum =
scan_event evt)
 		wid.val =3D (s8 *)&abort_running_scan;
 		wid.size =3D sizeof(char);
=20
-		result =3D wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
+		result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
 					      wilc_get_vif_idx(vif));
=20
 		if (result) {
@@ -538,7 +538,7 @@ static void handle_scan(struct work_struct *work)
 	wid_list[index].val =3D (s8 *)&scan_info->src;
 	index++;
=20
-	result =3D wilc_send_config_pkt(vif, SET_CFG, wid_list,
+	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, wid_list,
 				      index,
 				      wilc_get_vif_idx(vif));
=20
@@ -764,7 +764,7 @@ static void handle_connect(struct work_struct *work)
 	cur_byte =3D wid_list[wid_cnt].val;
 	wid_cnt++;
=20
-	result =3D wilc_send_config_pkt(vif, SET_CFG, wid_list,
+	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, wid_list,
 				      wid_cnt,
 				      wilc_get_vif_idx(vif));
 	if (result) {
@@ -873,7 +873,7 @@ static void handle_connect_timeout(struct work_struct *=
work)
 	wid.val =3D (s8 *)&dummy_reason_code;
 	wid.size =3D sizeof(char);
=20
-	result =3D wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
+	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result)
 		netdev_err(vif->ndev, "Failed to send disconnect\n");
@@ -1234,7 +1234,7 @@ static void host_int_get_assoc_res_info(struct wilc_v=
if *vif,
 	wid.val =3D assoc_resp_info;
 	wid.size =3D max_assoc_resp_info_len;
=20
-	result =3D wilc_send_config_pkt(vif, GET_CFG, &wid, 1,
+	result =3D wilc_send_config_pkt(vif, WILC_GET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result) {
 		*rcvd_assoc_resp_info_len =3D 0;
@@ -1290,10 +1290,10 @@ static inline void host_int_parse_assoc_resp_info(s=
truct wilc_vif *vif,
 	if (mac_status =3D=3D WILC_MAC_STATUS_CONNECTED) {
 		u32 assoc_resp_info_len;
=20
-		memset(hif_drv->assoc_resp, 0, MAX_ASSOC_RESP_FRAME_SIZE);
+		memset(hif_drv->assoc_resp, 0, WILC_MAX_ASSOC_RESP_FRAME_SIZE);
=20
 		host_int_get_assoc_res_info(vif, hif_drv->assoc_resp,
-					    MAX_ASSOC_RESP_FRAME_SIZE,
+					    WILC_MAX_ASSOC_RESP_FRAME_SIZE,
 					    &assoc_resp_info_len);
=20
 		if (assoc_resp_info_len !=3D 0) {
@@ -1469,7 +1469,7 @@ static int wilc_pmksa_key_copy(struct wilc_vif *vif, =
struct key_attr *hif_key)
 	wid.val =3D (s8 *)key_buf;
 	wid.size =3D (hif_key->attr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1;
=20
-	ret =3D wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
+	ret =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
 				   wilc_get_vif_idx(vif));
=20
 	kfree(key_buf);
@@ -1489,9 +1489,9 @@ static void handle_key(struct work_struct *work)
 	struct host_if_drv *hif_drv =3D vif->hif_drv;
=20
 	switch (hif_key->type) {
-	case WEP:
+	case WILC_KEY_TYPE_WEP:
=20
-		if (hif_key->action & ADDKEY_AP) {
+		if (hif_key->action & WILC_ADD_KEY_AP) {
 			wid_list[0].id =3D WID_11I_MODE;
 			wid_list[0].type =3D WID_CHAR;
 			wid_list[0].size =3D sizeof(char);
@@ -1520,11 +1520,11 @@ static void handle_key(struct work_struct *work)
 			wid_list[2].size =3D hif_key->attr.wep.key_len + 2;
 			wid_list[2].val =3D (s8 *)key_buf;
=20
-			result =3D wilc_send_config_pkt(vif, SET_CFG,
+			result =3D wilc_send_config_pkt(vif, WILC_SET_CFG,
 						      wid_list, 3,
 						      wilc_get_vif_idx(vif));
 			kfree(key_buf);
-		} else if (hif_key->action & ADDKEY) {
+		} else if (hif_key->action & WILC_ADD_KEY) {
 			key_buf =3D kmalloc(hif_key->attr.wep.key_len + 2,
 					  GFP_KERNEL);
 			if (!key_buf) {
@@ -1541,27 +1541,27 @@ static void handle_key(struct work_struct *work)
 			wid.val =3D (s8 *)key_buf;
 			wid.size =3D hif_key->attr.wep.key_len + 2;
=20
-			result =3D wilc_send_config_pkt(vif, SET_CFG,
+			result =3D wilc_send_config_pkt(vif, WILC_SET_CFG,
 						      &wid, 1,
 						      wilc_get_vif_idx(vif));
 			kfree(key_buf);
-		} else if (hif_key->action & REMOVEKEY) {
+		} else if (hif_key->action & WILC_REMOVE_KEY) {
 			wid.id =3D WID_REMOVE_WEP_KEY;
 			wid.type =3D WID_STR;
=20
 			wid.val =3D (s8 *)&hif_key->attr.wep.index;
 			wid.size =3D 1;
=20
-			result =3D wilc_send_config_pkt(vif, SET_CFG,
+			result =3D wilc_send_config_pkt(vif, WILC_SET_CFG,
 						      &wid, 1,
 						      wilc_get_vif_idx(vif));
-		} else if (hif_key->action & DEFAULTKEY) {
+		} else if (hif_key->action & WILC_DEFAULT_KEY) {
 			wid.id =3D WID_KEY_ID;
 			wid.type =3D WID_CHAR;
 			wid.val =3D (s8 *)&hif_key->attr.wep.index;
 			wid.size =3D sizeof(char);
=20
-			result =3D wilc_send_config_pkt(vif, SET_CFG,
+			result =3D wilc_send_config_pkt(vif, WILC_SET_CFG,
 						      &wid, 1,
 						      wilc_get_vif_idx(vif));
 		}
@@ -1569,8 +1569,8 @@ static void handle_key(struct work_struct *work)
 		complete(&msg->work_comp);
 		break;
=20
-	case WPA_RX_GTK:
-		if (hif_key->action & ADDKEY_AP) {
+	case WILC_KEY_TYPE_WPA_RX_GTK:
+		if (hif_key->action & WILC_ADD_KEY_AP) {
 			key_buf =3D kzalloc(RX_MIC_KEY_MSG_LEN, GFP_KERNEL);
 			if (!key_buf) {
 				result =3D -ENOMEM;
@@ -1595,12 +1595,12 @@ static void handle_key(struct work_struct *work)
 			wid_list[1].val =3D (s8 *)key_buf;
 			wid_list[1].size =3D RX_MIC_KEY_MSG_LEN;
=20
-			result =3D wilc_send_config_pkt(vif, SET_CFG,
+			result =3D wilc_send_config_pkt(vif, WILC_SET_CFG,
 						      wid_list, 2,
 						      wilc_get_vif_idx(vif));
=20
 			kfree(key_buf);
-		} else if (hif_key->action & ADDKEY) {
+		} else if (hif_key->action & WILC_ADD_KEY) {
 			key_buf =3D kzalloc(RX_MIC_KEY_MSG_LEN, GFP_KERNEL);
 			if (!key_buf) {
 				result =3D -ENOMEM;
@@ -1623,7 +1623,7 @@ static void handle_key(struct work_struct *work)
 			wid.val =3D (s8 *)key_buf;
 			wid.size =3D RX_MIC_KEY_MSG_LEN;
=20
-			result =3D wilc_send_config_pkt(vif, SET_CFG,
+			result =3D wilc_send_config_pkt(vif, WILC_SET_CFG,
 						      &wid, 1,
 						      wilc_get_vif_idx(vif));
=20
@@ -1633,8 +1633,8 @@ static void handle_key(struct work_struct *work)
 		complete(&msg->work_comp);
 		break;
=20
-	case WPA_PTK:
-		if (hif_key->action & ADDKEY_AP) {
+	case WILC_KEY_TYPE_WPA_PTK:
+		if (hif_key->action & WILC_ADD_KEY_AP) {
 			key_buf =3D kmalloc(PTK_KEY_MSG_LEN + 1, GFP_KERNEL);
 			if (!key_buf) {
 				result =3D -ENOMEM;
@@ -1657,11 +1657,11 @@ static void handle_key(struct work_struct *work)
 			wid_list[1].val =3D (s8 *)key_buf;
 			wid_list[1].size =3D PTK_KEY_MSG_LEN + 1;
=20
-			result =3D wilc_send_config_pkt(vif, SET_CFG,
+			result =3D wilc_send_config_pkt(vif, WILC_SET_CFG,
 						      wid_list, 2,
 						      wilc_get_vif_idx(vif));
 			kfree(key_buf);
-		} else if (hif_key->action & ADDKEY) {
+		} else if (hif_key->action & WILC_ADD_KEY) {
 			key_buf =3D kmalloc(PTK_KEY_MSG_LEN, GFP_KERNEL);
 			if (!key_buf) {
 				result =3D -ENOMEM;
@@ -1678,7 +1678,7 @@ static void handle_key(struct work_struct *work)
 			wid.val =3D (s8 *)key_buf;
 			wid.size =3D PTK_KEY_MSG_LEN;
=20
-			result =3D wilc_send_config_pkt(vif, SET_CFG,
+			result =3D wilc_send_config_pkt(vif, WILC_SET_CFG,
 						      &wid, 1,
 						      wilc_get_vif_idx(vif));
 			kfree(key_buf);
@@ -1688,7 +1688,7 @@ static void handle_key(struct work_struct *work)
 		complete(&msg->work_comp);
 		break;
=20
-	case PMKSA:
+	case WILC_KEY_TYPE_PMKSA:
 		result =3D wilc_pmksa_key_copy(vif, hif_key);
 		/*free 'msg', this case it not a sync call*/
 		kfree(msg);
@@ -1721,7 +1721,7 @@ static void handle_disconnect(struct work_struct *wor=
k)
 	vif->obtaining_ip =3D false;
 	wilc_set_power_mgmt(vif, 0, 0);
=20
-	result =3D wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
+	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
=20
 	if (result) {
@@ -1794,7 +1794,7 @@ static void handle_get_rssi(struct work_struct *work)
 	wid.val =3D msg->body.data;
 	wid.size =3D sizeof(char);
=20
-	result =3D wilc_send_config_pkt(vif, GET_CFG, &wid, 1,
+	result =3D wilc_send_config_pkt(vif, WILC_GET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result)
 		netdev_err(vif->ndev, "Failed to get RSSI value\n");
@@ -1841,7 +1841,7 @@ static void handle_get_statistics(struct work_struct =
*work)
 	wid_list[wid_cnt].val =3D (s8 *)&stats->tx_fail_cnt;
 	wid_cnt++;
=20
-	result =3D wilc_send_config_pkt(vif, GET_CFG, wid_list,
+	result =3D wilc_send_config_pkt(vif, WILC_GET_CFG, wid_list,
 				      wid_cnt,
 				      wilc_get_vif_idx(vif));
=20
@@ -1878,7 +1878,7 @@ static void handle_get_inactive_time(struct work_stru=
ct *work)
=20
 	ether_addr_copy(wid.val, hif_sta_inactive->mac);
=20
-	result =3D wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
+	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	kfree(wid.val);
=20
@@ -1892,7 +1892,7 @@ static void handle_get_inactive_time(struct work_stru=
ct *work)
 	wid.val =3D (s8 *)&hif_sta_inactive->inactive_time;
 	wid.size =3D sizeof(u32);
=20
-	result =3D wilc_send_config_pkt(vif, GET_CFG, &wid, 1,
+	result =3D wilc_send_config_pkt(vif, WILC_GET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
=20
 	if (result)
@@ -1947,7 +1947,7 @@ static void handle_add_beacon(struct work_struct *wor=
k)
 		memcpy(cur_byte, param->tail, param->tail_len);
 	cur_byte +=3D param->tail_len;
=20
-	result =3D wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
+	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result)
 		netdev_err(vif->ndev, "Failed to send add beacon\n");
@@ -1972,7 +1972,7 @@ static void handle_del_beacon(struct work_struct *wor=
k)
 	wid.size =3D sizeof(char);
 	wid.val =3D &del_beacon;
=20
-	result =3D wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
+	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result)
 		netdev_err(vif->ndev, "Failed to send delete beacon\n");
@@ -2029,7 +2029,7 @@ static void handle_add_station(struct work_struct *wo=
rk)
 	cur_byte =3D wid.val;
 	cur_byte +=3D wilc_hif_pack_sta_param(cur_byte, param);
=20
-	result =3D wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
+	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result !=3D 0)
 		netdev_err(vif->ndev, "Failed to send add station\n");
@@ -2063,7 +2063,7 @@ static void handle_del_all_sta(struct work_struct *wo=
rk)
=20
 	*(curr_byte++) =3D param->assoc_sta;
=20
-	for (i =3D 0; i < MAX_NUM_STA; i++) {
+	for (i =3D 0; i < WILC_MAX_NUM_STA; i++) {
 		if (memcmp(param->del_all_sta[i], zero_buff, ETH_ALEN))
 			memcpy(curr_byte, param->del_all_sta[i], ETH_ALEN);
 		else
@@ -2072,7 +2072,7 @@ static void handle_del_all_sta(struct work_struct *wo=
rk)
 		curr_byte +=3D ETH_ALEN;
 	}
=20
-	result =3D wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
+	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result)
 		netdev_err(vif->ndev, "Failed to send delete all station\n");
@@ -2102,7 +2102,7 @@ static void handle_del_station(struct work_struct *wo=
rk)
=20
 	ether_addr_copy(wid.val, param->mac_addr);
=20
-	result =3D wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
+	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result)
 		netdev_err(vif->ndev, "Failed to del station\n");
@@ -2132,7 +2132,7 @@ static void handle_edit_station(struct work_struct *w=
ork)
 	cur_byte =3D wid.val;
 	cur_byte +=3D wilc_hif_pack_sta_param(cur_byte, param);
=20
-	result =3D wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
+	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result)
 		netdev_err(vif->ndev, "Failed to send edit station\n");
@@ -2189,7 +2189,7 @@ static int handle_remain_on_chan(struct wilc_vif *vif=
,
 	wid.val[0] =3D remain_on_chan_flag;
 	wid.val[1] =3D (s8)hif_remain_ch->ch;
=20
-	result =3D wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
+	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	kfree(wid.val);
 	if (result !=3D 0)
@@ -2232,7 +2232,7 @@ static void handle_register_frame(struct work_struct =
*work)
=20
 	wid.size =3D sizeof(u16) + 2;
=20
-	result =3D wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
+	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	kfree(wid.val);
 	if (result)
@@ -2266,7 +2266,7 @@ static void handle_listen_state_expired(struct work_s=
truct *work)
 		wid.val[0] =3D remain_on_chan_flag;
 		wid.val[1] =3D FALSE_FRMWR_CHANNEL;
=20
-		result =3D wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
+		result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
 					      wilc_get_vif_idx(vif));
 		kfree(wid.val);
 		if (result !=3D 0) {
@@ -2328,7 +2328,7 @@ static void handle_power_management(struct work_struc=
t *work)
 	wid.val =3D &power_mode;
 	wid.size =3D sizeof(char);
=20
-	result =3D wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
+	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result)
 		netdev_err(vif->ndev, "Failed to send power management\n");
@@ -2366,7 +2366,7 @@ static void handle_set_mcast_filter(struct work_struc=
t *work)
 		memcpy(cur_byte, hif_set_mc->mc_list,
 		       ((hif_set_mc->cnt) * ETH_ALEN));
=20
-	result =3D wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
+	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result)
 		netdev_err(vif->ndev, "Failed to send setup multicast\n");
@@ -2390,7 +2390,7 @@ static void handle_set_tx_pwr(struct work_struct *wor=
k)
 	wid.val =3D &tx_pwr;
 	wid.size =3D sizeof(char);
=20
-	ret =3D wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
+	ret =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
 				   wilc_get_vif_idx(vif));
 	if (ret)
 		netdev_err(vif->ndev, "Failed to set TX PWR\n");
@@ -2411,7 +2411,7 @@ static void handle_get_tx_pwr(struct work_struct *wor=
k)
 	wid.val =3D (s8 *)tx_pwr;
 	wid.size =3D sizeof(char);
=20
-	ret =3D wilc_send_config_pkt(vif, GET_CFG, &wid, 1,
+	ret =3D wilc_send_config_pkt(vif, WILC_GET_CFG, &wid, 1,
 				   wilc_get_vif_idx(vif));
 	if (ret)
 		netdev_err(vif->ndev, "Failed to get TX PWR\n");
@@ -2501,8 +2501,8 @@ int wilc_remove_wep_key(struct wilc_vif *vif, u8 inde=
x)
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
=20
-	msg->body.key_info.type =3D WEP;
-	msg->body.key_info.action =3D REMOVEKEY;
+	msg->body.key_info.type =3D WILC_KEY_TYPE_WEP;
+	msg->body.key_info.action =3D WILC_REMOVE_KEY;
 	msg->body.key_info.attr.wep.index =3D index;
=20
 	result =3D wilc_enqueue_work(msg);
@@ -2531,8 +2531,8 @@ int wilc_set_wep_default_keyid(struct wilc_vif *vif, =
u8 index)
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
=20
-	msg->body.key_info.type =3D WEP;
-	msg->body.key_info.action =3D DEFAULTKEY;
+	msg->body.key_info.type =3D WILC_KEY_TYPE_WEP;
+	msg->body.key_info.action =3D WILC_DEFAULT_KEY;
 	msg->body.key_info.attr.wep.index =3D index;
=20
 	result =3D wilc_enqueue_work(msg);
@@ -2561,8 +2561,8 @@ int wilc_add_wep_key_bss_sta(struct wilc_vif *vif, co=
nst u8 *key, u8 len,
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
=20
-	msg->body.key_info.type =3D WEP;
-	msg->body.key_info.action =3D ADDKEY;
+	msg->body.key_info.type =3D WILC_KEY_TYPE_WEP;
+	msg->body.key_info.action =3D WILC_ADD_KEY;
 	msg->body.key_info.attr.wep.key =3D kmemdup(key, len, GFP_KERNEL);
 	if (!msg->body.key_info.attr.wep.key) {
 		result =3D -ENOMEM;
@@ -2602,8 +2602,8 @@ int wilc_add_wep_key_bss_ap(struct wilc_vif *vif, con=
st u8 *key, u8 len,
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
=20
-	msg->body.key_info.type =3D WEP;
-	msg->body.key_info.action =3D ADDKEY_AP;
+	msg->body.key_info.type =3D WILC_KEY_TYPE_WEP;
+	msg->body.key_info.action =3D WILC_ADD_KEY_AP;
 	msg->body.key_info.attr.wep.key =3D kmemdup(key, len, GFP_KERNEL);
 	if (!msg->body.key_info.attr.wep.key) {
 		result =3D -ENOMEM;
@@ -2653,13 +2653,13 @@ int wilc_add_ptk(struct wilc_vif *vif, const u8 *pt=
k, u8 ptk_key_len,
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
=20
-	msg->body.key_info.type =3D WPA_PTK;
-	if (mode =3D=3D AP_MODE) {
-		msg->body.key_info.action =3D ADDKEY_AP;
+	msg->body.key_info.type =3D WILC_KEY_TYPE_WPA_PTK;
+	if (mode =3D=3D WILC_AP_MODE) {
+		msg->body.key_info.action =3D WILC_ADD_KEY_AP;
 		msg->body.key_info.attr.wpa.index =3D index;
 	}
-	if (mode =3D=3D STATION_MODE)
-		msg->body.key_info.action =3D ADDKEY;
+	if (mode =3D=3D WILC_STATION_MODE)
+		msg->body.key_info.action =3D WILC_ADD_KEY;
=20
 	msg->body.key_info.attr.wpa.key =3D kmemdup(ptk, ptk_key_len, GFP_KERNEL)=
;
 	if (!msg->body.key_info.attr.wpa.key) {
@@ -2730,14 +2730,14 @@ int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 =
*rx_gtk, u8 gtk_key_len,
 		}
 	}
=20
-	msg->body.key_info.type =3D WPA_RX_GTK;
+	msg->body.key_info.type =3D WILC_KEY_TYPE_WPA_RX_GTK;
=20
-	if (mode =3D=3D AP_MODE) {
-		msg->body.key_info.action =3D ADDKEY_AP;
+	if (mode =3D=3D WILC_AP_MODE) {
+		msg->body.key_info.action =3D WILC_ADD_KEY_AP;
 		msg->body.key_info.attr.wpa.mode =3D cipher_mode;
 	}
-	if (mode =3D=3D STATION_MODE)
-		msg->body.key_info.action =3D ADDKEY;
+	if (mode =3D=3D WILC_STATION_MODE)
+		msg->body.key_info.action =3D WILC_ADD_KEY;
=20
 	msg->body.key_info.attr.wpa.key =3D kmemdup(rx_gtk, key_len, GFP_KERNEL);
 	if (!msg->body.key_info.attr.wpa.key) {
@@ -2787,8 +2787,8 @@ int wilc_set_pmkid_info(struct wilc_vif *vif,
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
=20
-	msg->body.key_info.type =3D PMKSA;
-	msg->body.key_info.action =3D ADDKEY;
+	msg->body.key_info.type =3D WILC_KEY_TYPE_PMKSA;
+	msg->body.key_info.action =3D WILC_ADD_KEY;
=20
 	for (i =3D 0; i < pmkid->numpmkid; i++) {
 		memcpy(msg->body.key_info.attr.pmkid.pmkidlist[i].bssid,
@@ -3640,7 +3640,7 @@ int wilc_del_allstation(struct wilc_vif *vif, u8 mac_=
addr[][ETH_ALEN])
=20
 	del_all_sta_info =3D &msg->body.del_all_sta_info;
=20
-	for (i =3D 0; i < MAX_NUM_STA; i++) {
+	for (i =3D 0; i < WILC_MAX_NUM_STA; i++) {
 		if (memcmp(mac_addr[i], zero_addr, ETH_ALEN)) {
 			memcpy(del_all_sta_info->del_all_sta[i], mac_addr[i],
 			       ETH_ALEN);
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index 610ca2b..606e80a 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -9,20 +9,25 @@
 #include <linux/ieee80211.h>
 #include "wilc_wlan_if.h"
=20
-#define IDLE_MODE	0x00
-#define AP_MODE		0x01
-#define STATION_MODE	0x02
-#define GO_MODE		0x03
-#define CLIENT_MODE	0x04
-
-#define MAX_NUM_STA				9
-#define ADDKEY					0x1
-#define REMOVEKEY				0x2
-#define DEFAULTKEY				0x4
-#define ADDKEY_AP				0x8
+enum {
+	WILC_IDLE_MODE =3D 0x0,
+	WILC_AP_MODE =3D 0x1,
+	WILC_STATION_MODE =3D 0x2,
+	WILC_GO_MODE =3D 0x3,
+	WILC_CLIENT_MODE =3D 0x4
+};
+
+enum {
+	WILC_ADD_KEY =3D 0x1,
+	WILC_REMOVE_KEY =3D 0x2,
+	WILC_DEFAULT_KEY =3D 0x4,
+	WILC_ADD_KEY_AP =3D 0x8
+};
+
+#define WILC_MAX_NUM_STA			9
 #define MAX_NUM_SCANNED_NETWORKS		100
 #define MAX_NUM_SCANNED_NETWORKS_SHADOW		130
-#define MAX_NUM_PROBED_SSID			10
+#define WILC_MAX_NUM_PROBED_SSID		10
=20
 #define TX_MIC_KEY_LEN				8
 #define RX_MIC_KEY_LEN				8
@@ -34,16 +39,18 @@
 #define PMKSA_KEY_LEN				22
 #define WILC_MAX_NUM_PMKIDS			16
 #define WILC_ADD_STA_LENGTH			40
-#define NUM_CONCURRENT_IFC			2
-#define DRV_HANDLER_SIZE			5
+#define WILC_NUM_CONCURRENT_IFC			2
+#define WILC_DRV_HANDLER_SIZE			5
 #define DRV_HANDLER_MASK			0x000000FF
=20
 #define NUM_RSSI                5
=20
-#define SET_CFG              0
-#define GET_CFG              1
+enum {
+	WILC_SET_CFG =3D 0,
+	WILC_GET_CFG
+};
=20
-#define MAX_ASSOC_RESP_FRAME_SIZE   256
+#define WILC_MAX_ASSOC_RESP_FRAME_SIZE   256
=20
 struct rssi_history_buffer {
 	bool full;
@@ -130,10 +137,10 @@ struct cfg_param_attr {
 };
=20
 enum cfg_param {
-	RETRY_SHORT		=3D BIT(0),
-	RETRY_LONG		=3D BIT(1),
-	FRAG_THRESHOLD		=3D BIT(2),
-	RTS_THRESHOLD		=3D BIT(3),
+	WILC_CFG_PARAM_RETRY_SHORT =3D BIT(0),
+	WILC_CFG_PARAM_RETRY_LONG =3D BIT(1),
+	WILC_CFG_PARAM_FRAG_THRESHOLD =3D BIT(2),
+	WILC_CFG_PARAM_RTS_THRESHOLD =3D BIT(3)
 };
=20
 struct found_net_info {
@@ -155,10 +162,10 @@ enum conn_event {
 };
=20
 enum KEY_TYPE {
-	WEP,
-	WPA_RX_GTK,
-	WPA_PTK,
-	PMKSA,
+	WILC_KEY_TYPE_WEP,
+	WILC_KEY_TYPE_WPA_RX_GTK,
+	WILC_KEY_TYPE_WPA_PTK,
+	WILC_KEY_TYPE_PMKSA,
 };
=20
 typedef void (*wilc_scan_result)(enum scan_event, struct network_info *,
@@ -268,7 +275,7 @@ struct host_if_drv {
=20
 	bool ifc_up;
 	int driver_handler_id;
-	u8 assoc_resp[MAX_ASSOC_RESP_FRAME_SIZE];
+	u8 assoc_resp[WILC_MAX_ASSOC_RESP_FRAME_SIZE];
 };
=20
 struct add_sta_param {
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc10=
00/linux_wlan.c
index faf97df..96d8834 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -46,7 +46,8 @@ static int dev_state_ev_handler(struct notifier_block *th=
is,
=20
 	switch (event) {
 	case NETDEV_UP:
-		if (vif->iftype =3D=3D STATION_MODE || vif->iftype =3D=3D CLIENT_MODE) {
+		if (vif->iftype =3D=3D WILC_STATION_MODE ||
+		    vif->iftype =3D=3D WILC_CLIENT_MODE) {
 			hif_drv->ifc_up =3D 1;
 			vif->obtaining_ip =3D false;
 			del_timer(&vif->during_ip_timer);
@@ -65,7 +66,8 @@ static int dev_state_ev_handler(struct notifier_block *th=
is,
 		break;
=20
 	case NETDEV_DOWN:
-		if (vif->iftype =3D=3D STATION_MODE || vif->iftype =3D=3D CLIENT_MODE) {
+		if (vif->iftype =3D=3D WILC_STATION_MODE ||
+		    vif->iftype =3D=3D WILC_CLIENT_MODE) {
 			hif_drv->ifc_up =3D 0;
 			vif->obtaining_ip =3D false;
 		}
@@ -179,11 +181,11 @@ static struct net_device *get_if_handler(struct wilc =
*wilc, u8 *mac_header)
 	bssid1 =3D mac_header + 4;
=20
 	for (i =3D 0; i < wilc->vif_num; i++) {
-		if (wilc->vif[i]->mode =3D=3D STATION_MODE)
+		if (wilc->vif[i]->mode =3D=3D WILC_STATION_MODE)
 			if (ether_addr_equal_unaligned(bssid,
 						       wilc->vif[i]->bssid))
 				return wilc->vif[i]->ndev;
-		if (wilc->vif[i]->mode =3D=3D AP_MODE)
+		if (wilc->vif[i]->mode =3D=3D WILC_AP_MODE)
 			if (ether_addr_equal_unaligned(bssid1,
 						       wilc->vif[i]->bssid))
 				return wilc->vif[i]->ndev;
@@ -1021,12 +1023,12 @@ void wilc_netdev_cleanup(struct wilc *wilc)
 	}
=20
 	if (wilc->vif[0]->ndev || wilc->vif[1]->ndev) {
-		for (i =3D 0; i < NUM_CONCURRENT_IFC; i++)
+		for (i =3D 0; i < WILC_NUM_CONCURRENT_IFC; i++)
 			if (wilc->vif[i]->ndev)
 				if (wilc->vif[i]->mac_opened)
 					wilc_mac_close(wilc->vif[i]->ndev);
=20
-		for (i =3D 0; i < NUM_CONCURRENT_IFC; i++) {
+		for (i =3D 0; i < WILC_NUM_CONCURRENT_IFC; i++) {
 			unregister_netdev(wilc->vif[i]->ndev);
 			wilc_free_wiphy(wilc->vif[i]->ndev);
 			free_netdev(wilc->vif[i]->ndev);
@@ -1082,7 +1084,7 @@ int wilc_netdev_init(struct wilc **wilc, struct devic=
e *dev, int io_type,
=20
 	register_inetaddr_notifier(&g_dev_notifier);
=20
-	for (i =3D 0; i < NUM_CONCURRENT_IFC; i++) {
+	for (i =3D 0; i < WILC_NUM_CONCURRENT_IFC; i++) {
 		struct wireless_dev *wdev;
=20
 		ndev =3D alloc_etherdev(sizeof(struct wilc_vif));
@@ -1130,7 +1132,7 @@ int wilc_netdev_init(struct wilc **wilc, struct devic=
e *dev, int io_type,
 		if (ret)
 			goto free_ndev;
=20
-		vif->iftype =3D STATION_MODE;
+		vif->iftype =3D WILC_STATION_MODE;
 		vif->mac_opened =3D 0;
 	}
=20
@@ -1139,7 +1141,7 @@ int wilc_netdev_init(struct wilc **wilc, struct devic=
e *dev, int io_type,
 free_ndev:
 	for (; i >=3D 0; i--) {
 		if (wl->vif[i]) {
-			if (wl->vif[i]->iftype =3D=3D STATION_MODE)
+			if (wl->vif[i]->iftype =3D=3D WILC_STATION_MODE)
 				unregister_netdev(wl->vif[i]->ndev);
=20
 			if (wl->vif[i]->ndev) {
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/st=
aging/wilc1000/wilc_wfi_cfgoperations.c
index 4cfa3ff4..9906a9f7 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -465,7 +465,7 @@ static void cfg_connect_result(enum conn_event conn_dis=
conn_evt,
 		    conn_info->status =3D=3D WLAN_STATUS_SUCCESS) {
 			connect_status =3D WLAN_STATUS_UNSPECIFIED_FAILURE;
 			wilc_wlan_set_bssid(priv->dev, null_bssid,
-					    STATION_MODE);
+					    WILC_STATION_MODE);
=20
 			if (!wfi_drv->p2p_connect)
 				wlan_channel =3D INVALID_CHANNEL;
@@ -507,7 +507,7 @@ static void cfg_connect_result(enum conn_event conn_dis=
conn_evt,
 		priv->p2p.recv_random =3D 0x00;
 		priv->p2p.is_wilc_ie =3D false;
 		eth_zero_addr(priv->associated_bss);
-		wilc_wlan_set_bssid(priv->dev, null_bssid, STATION_MODE);
+		wilc_wlan_set_bssid(priv->dev, null_bssid, WILC_STATION_MODE);
=20
 		if (!wfi_drv->p2p_connect)
 			wlan_channel =3D INVALID_CHANNEL;
@@ -768,7 +768,7 @@ static int connect(struct wiphy *wiphy, struct net_devi=
ce *dev,
 	if (!wfi_drv->p2p_connect)
 		wlan_channel =3D nw_info->ch;
=20
-	wilc_wlan_set_bssid(dev, nw_info->bssid, STATION_MODE);
+	wilc_wlan_set_bssid(dev, nw_info->bssid, WILC_STATION_MODE);
=20
 	ret =3D wilc_set_join_req(vif, nw_info->bssid, sme->ssid,
 				sme->ssid_len, sme->ie, sme->ie_len,
@@ -781,7 +781,7 @@ static int connect(struct wiphy *wiphy, struct net_devi=
ce *dev,
=20
 		netdev_err(dev, "wilc_set_join_req(): Error\n");
 		ret =3D -ENOENT;
-		wilc_wlan_set_bssid(dev, null_bssid, STATION_MODE);
+		wilc_wlan_set_bssid(dev, null_bssid, WILC_STATION_MODE);
 		goto out_error;
 	}
 	return 0;
@@ -815,7 +815,7 @@ static int disconnect(struct wiphy *wiphy, struct net_d=
evice *dev,
 	wfi_drv =3D (struct host_if_drv *)priv->hif_drv;
 	if (!wfi_drv->p2p_connect)
 		wlan_channel =3D INVALID_CHANNEL;
-	wilc_wlan_set_bssid(priv->dev, null_bssid, STATION_MODE);
+	wilc_wlan_set_bssid(priv->dev, null_bssid, WILC_STATION_MODE);
=20
 	priv->p2p.local_random =3D 0x01;
 	priv->p2p.recv_random =3D 0x00;
@@ -961,7 +961,7 @@ static int add_key(struct wiphy *wiphy, struct net_devi=
ce *netdev, u8 key_index,
 			if (ret)
 				return -ENOMEM;
=20
-			op_mode =3D AP_MODE;
+			op_mode =3D WILC_AP_MODE;
 		} else {
 			if (params->key_len > 16 &&
 			    params->cipher =3D=3D WLAN_CIPHER_SUITE_TKIP) {
@@ -970,7 +970,7 @@ static int add_key(struct wiphy *wiphy, struct net_devi=
ce *netdev, u8 key_index,
 				keylen =3D params->key_len - 16;
 			}
=20
-			op_mode =3D STATION_MODE;
+			op_mode =3D WILC_STATION_MODE;
 		}
=20
 		if (!pairwise)
@@ -1079,7 +1079,7 @@ static int get_station(struct wiphy *wiphy, struct ne=
t_device *dev,
 	u32 associatedsta =3D ~0;
 	u32 inactive_time =3D 0;
=20
-	if (vif->iftype =3D=3D AP_MODE || vif->iftype =3D=3D GO_MODE) {
+	if (vif->iftype =3D=3D WILC_AP_MODE || vif->iftype =3D=3D WILC_GO_MODE) {
 		for (i =3D 0; i < NUM_STA_ASSOCIATED; i++) {
 			if (!(memcmp(mac,
 				     priv->assoc_stainfo.sta_associated_bss[i],
@@ -1098,7 +1098,7 @@ static int get_station(struct wiphy *wiphy, struct ne=
t_device *dev,
=20
 		wilc_get_inactive_time(vif, mac, &inactive_time);
 		sinfo->inactive_time =3D 1000 * inactive_time;
-	} else if (vif->iftype =3D=3D STATION_MODE) {
+	} else if (vif->iftype =3D=3D WILC_STATION_MODE) {
 		struct rf_info stats;
=20
 		wilc_get_statistics(vif, &stats, true);
@@ -1143,14 +1143,14 @@ static int set_wiphy_params(struct wiphy *wiphy, u3=
2 changed)
 		netdev_dbg(vif->ndev,
 			   "Setting WIPHY_PARAM_RETRY_SHORT %d\n",
 			   wiphy->retry_short);
-		cfg_param_val.flag  |=3D RETRY_SHORT;
+		cfg_param_val.flag  |=3D WILC_CFG_PARAM_RETRY_SHORT;
 		cfg_param_val.short_retry_limit =3D wiphy->retry_short;
 	}
 	if (changed & WIPHY_PARAM_RETRY_LONG) {
 		netdev_dbg(vif->ndev,
 			   "Setting WIPHY_PARAM_RETRY_LONG %d\n",
 			   wiphy->retry_long);
-		cfg_param_val.flag |=3D RETRY_LONG;
+		cfg_param_val.flag |=3D WILC_CFG_PARAM_RETRY_LONG;
 		cfg_param_val.long_retry_limit =3D wiphy->retry_long;
 	}
 	if (changed & WIPHY_PARAM_FRAG_THRESHOLD) {
@@ -1159,7 +1159,7 @@ static int set_wiphy_params(struct wiphy *wiphy, u32 =
changed)
 			netdev_dbg(vif->ndev,
 				   "Setting WIPHY_PARAM_FRAG_THRESHOLD %d\n",
 				   wiphy->frag_threshold);
-			cfg_param_val.flag |=3D FRAG_THRESHOLD;
+			cfg_param_val.flag |=3D WILC_CFG_PARAM_FRAG_THRESHOLD;
 			cfg_param_val.frag_threshold =3D wiphy->frag_threshold;
 		} else {
 			netdev_err(vif->ndev,
@@ -1173,7 +1173,7 @@ static int set_wiphy_params(struct wiphy *wiphy, u32 =
changed)
 			netdev_dbg(vif->ndev,
 				   "Setting WIPHY_PARAM_RTS_THRESHOLD %d\n",
 				   wiphy->rts_threshold);
-			cfg_param_val.flag |=3D RTS_THRESHOLD;
+			cfg_param_val.flag |=3D WILC_CFG_PARAM_RTS_THRESHOLD;
 			cfg_param_val.rts_threshold =3D wiphy->rts_threshold;
 		} else {
 			netdev_err(vif->ndev, "RTS threshold out of range\n");
@@ -1768,11 +1768,11 @@ static int change_virtual_intf(struct wiphy *wiphy,=
 struct net_device *dev,
 		dev->ieee80211_ptr->iftype =3D type;
 		priv->wdev->iftype =3D type;
 		vif->monitor_flag =3D 0;
-		vif->iftype =3D STATION_MODE;
-		wilc_set_operation_mode(vif, STATION_MODE);
+		vif->iftype =3D WILC_STATION_MODE;
+		wilc_set_operation_mode(vif, WILC_STATION_MODE);
=20
 		memset(priv->assoc_stainfo.sta_associated_bss, 0,
-		       MAX_NUM_STA * ETH_ALEN);
+		       WILC_MAX_NUM_STA * ETH_ALEN);
=20
 		wl->enable_ps =3D true;
 		wilc_set_power_mgmt(vif, 1, 0);
@@ -1783,8 +1783,8 @@ static int change_virtual_intf(struct wiphy *wiphy, s=
truct net_device *dev,
 		dev->ieee80211_ptr->iftype =3D type;
 		priv->wdev->iftype =3D type;
 		vif->monitor_flag =3D 0;
-		vif->iftype =3D CLIENT_MODE;
-		wilc_set_operation_mode(vif, STATION_MODE);
+		vif->iftype =3D WILC_CLIENT_MODE;
+		wilc_set_operation_mode(vif, WILC_STATION_MODE);
=20
 		wl->enable_ps =3D false;
 		wilc_set_power_mgmt(vif, 0, 0);
@@ -1794,12 +1794,12 @@ static int change_virtual_intf(struct wiphy *wiphy,=
 struct net_device *dev,
 		wl->enable_ps =3D false;
 		dev->ieee80211_ptr->iftype =3D type;
 		priv->wdev->iftype =3D type;
-		vif->iftype =3D AP_MODE;
+		vif->iftype =3D WILC_AP_MODE;
=20
 		if (wl->initialized) {
 			wilc_set_wfi_drv_handler(vif, wilc_get_vif_idx(vif),
 						 0, vif->ifc_id, false);
-			wilc_set_operation_mode(vif, AP_MODE);
+			wilc_set_operation_mode(vif, WILC_AP_MODE);
 			wilc_set_power_mgmt(vif, 0, 0);
 		}
 		break;
@@ -1808,10 +1808,10 @@ static int change_virtual_intf(struct wiphy *wiphy,=
 struct net_device *dev,
 		vif->obtaining_ip =3D true;
 		mod_timer(&vif->during_ip_timer,
 			  jiffies + msecs_to_jiffies(DURING_IP_TIME_OUT));
-		wilc_set_operation_mode(vif, AP_MODE);
+		wilc_set_operation_mode(vif, WILC_AP_MODE);
 		dev->ieee80211_ptr->iftype =3D type;
 		priv->wdev->iftype =3D type;
-		vif->iftype =3D GO_MODE;
+		vif->iftype =3D WILC_GO_MODE;
=20
 		wl->enable_ps =3D false;
 		wilc_set_power_mgmt(vif, 0, 0);
@@ -1838,7 +1838,7 @@ static int start_ap(struct wiphy *wiphy, struct net_d=
evice *dev,
 	if (ret !=3D 0)
 		netdev_err(dev, "Error in setting channel\n");
=20
-	wilc_wlan_set_bssid(dev, wl->vif[vif->idx]->src_addr, AP_MODE);
+	wilc_wlan_set_bssid(dev, wl->vif[vif->idx]->src_addr, WILC_AP_MODE);
 	wilc_set_power_mgmt(vif, 0, 0);
=20
 	return wilc_add_beacon(vif, settings->beacon_interval,
@@ -1865,7 +1865,7 @@ static int stop_ap(struct wiphy *wiphy, struct net_de=
vice *dev)
 	struct wilc_vif *vif =3D netdev_priv(priv->dev);
 	u8 null_bssid[ETH_ALEN] =3D {0};
=20
-	wilc_wlan_set_bssid(dev, null_bssid, AP_MODE);
+	wilc_wlan_set_bssid(dev, null_bssid, WILC_AP_MODE);
=20
 	ret =3D wilc_del_beacon(vif);
=20
@@ -1883,7 +1883,7 @@ static int add_station(struct wiphy *wiphy, struct ne=
t_device *dev,
 	struct add_sta_param sta_params =3D { {0} };
 	struct wilc_vif *vif =3D netdev_priv(dev);
=20
-	if (vif->iftype =3D=3D AP_MODE || vif->iftype =3D=3D GO_MODE) {
+	if (vif->iftype =3D=3D WILC_AP_MODE || vif->iftype =3D=3D WILC_GO_MODE) {
 		memcpy(sta_params.bssid, mac, ETH_ALEN);
 		memcpy(priv->assoc_stainfo.sta_associated_bss[params->aid], mac,
 		       ETH_ALEN);
@@ -1918,7 +1918,7 @@ static int del_station(struct wiphy *wiphy, struct ne=
t_device *dev,
 	struct wilc_vif *vif =3D netdev_priv(dev);
 	struct sta_info *info;
=20
-	if (!(vif->iftype =3D=3D AP_MODE || vif->iftype =3D=3D GO_MODE))
+	if (!(vif->iftype =3D=3D WILC_AP_MODE || vif->iftype =3D=3D WILC_GO_MODE)=
)
 		return ret;
=20
 	info =3D &priv->assoc_stainfo;
@@ -1939,7 +1939,7 @@ static int change_station(struct wiphy *wiphy, struct=
 net_device *dev,
 	struct add_sta_param sta_params =3D { {0} };
 	struct wilc_vif *vif =3D netdev_priv(dev);
=20
-	if (vif->iftype =3D=3D AP_MODE || vif->iftype =3D=3D GO_MODE) {
+	if (vif->iftype =3D=3D WILC_AP_MODE || vif->iftype =3D=3D WILC_GO_MODE) {
 		memcpy(sta_params.bssid, mac, ETH_ALEN);
 		sta_params.aid =3D params->aid;
 		sta_params.rates_len =3D params->supported_rates_len;
@@ -2141,7 +2141,7 @@ struct wireless_dev *wilc_create_wiphy(struct net_dev=
ice *net,
=20
 	priv =3D wdev_priv(wdev);
 	priv->wdev =3D wdev;
-	wdev->wiphy->max_scan_ssids =3D MAX_NUM_PROBED_SSID;
+	wdev->wiphy->max_scan_ssids =3D WILC_MAX_NUM_PROBED_SSID;
 #ifdef CONFIG_PM
 	wdev->wiphy->wowlan =3D &wowlan_support;
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/stagin=
g/wilc1000/wilc_wfi_netdevice.h
index 6283d9e..c6dad12 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -57,7 +57,7 @@ struct wilc_wfi_wep_key {
 };
=20
 struct sta_info {
-	u8 sta_associated_bss[MAX_NUM_STA][ETH_ALEN];
+	u8 sta_associated_bss[WILC_MAX_NUM_STA][ETH_ALEN];
 };
=20
 /*Parameters needed for host interface for  remaining on channel*/
@@ -94,8 +94,8 @@ struct wilc_priv {
 	u8 wep_key_len[4];
 	/* The real interface that the monitor is on */
 	struct net_device *real_ndev;
-	struct wilc_wfi_key *wilc_gtk[MAX_NUM_STA];
-	struct wilc_wfi_key *wilc_ptk[MAX_NUM_STA];
+	struct wilc_wfi_key *wilc_gtk[WILC_MAX_NUM_STA];
+	struct wilc_wfi_key *wilc_ptk[WILC_MAX_NUM_STA];
 	u8 wilc_groupkey;
 	/* mutexes */
 	struct mutex scan_req_lock;
@@ -168,7 +168,7 @@ struct wilc {
 	int dev_irq_num;
 	int close;
 	u8 vif_num;
-	struct wilc_vif *vif[NUM_CONCURRENT_IFC];
+	struct wilc_vif *vif[WILC_NUM_CONCURRENT_IFC];
 	u8 open_ifcs;
 	/*protect head of transmit queue*/
 	struct mutex txq_add_to_head_cs;
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc100=
0/wilc_wlan.c
index d474b87..563ce62 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1205,7 +1205,7 @@ int wilc_send_config_pkt(struct wilc_vif *vif, u8 mod=
e, struct wid *wids,
 	int i;
 	int ret =3D 0;
=20
-	if (mode =3D=3D GET_CFG) {
+	if (mode =3D=3D WILC_GET_CFG) {
 		for (i =3D 0; i < count; i++) {
 			if (!wilc_wlan_cfg_get(vif, !i,
 					       wids[i].id,
@@ -1221,7 +1221,7 @@ int wilc_send_config_pkt(struct wilc_vif *vif, u8 mod=
e, struct wid *wids,
 							     wids[i].val,
 							     wids[i].size);
 		}
-	} else if (mode =3D=3D SET_CFG) {
+	} else if (mode =3D=3D WILC_SET_CFG) {
 		for (i =3D 0; i < count; i++) {
 			if (!wilc_wlan_cfg_set(vif, !i,
 					       wids[i].id,
--=20
2.7.4

