Return-Path: <SRS0=9n1M=OL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76F38C64EB4
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:02:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F8612082F
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:02:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="VLDsjkg+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2F8612082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725808AbeLBSCz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Dec 2018 13:02:55 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:39788 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbeLBSCz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Dec 2018 13:02:55 -0500
X-IronPort-AV: E=Sophos;i="5.56,307,1539673200"; 
   d="scan'208";a="24755001"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 02 Dec 2018 11:02:53 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.38) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 2 Dec 2018 11:02:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yUZNHHBNThpghEXh1wa9+1zqv7HI5fwJxwolpTMLu64=;
 b=VLDsjkg+Nxf9DT49D+sCWgwomDwmzlu3ke9HBCVUmPR0ES2iqRDWj0Uqw968immQ4fX51SMk/l3apPhQbNp6rGhpz/PfxinQlzfeDTqzgbdCMJQqqBswsmF/wkjg1ohpAQsIGEKmVsR4MXYoKXK0uGEXHD/LRdptsgLqrNcb2UI=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2806.namprd11.prod.outlook.com (52.135.228.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.18; Sun, 2 Dec 2018 18:02:51 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f%4]) with mapi id 15.20.1382.020; Sun, 2 Dec 2018
 18:02:51 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 13/29] staging: wilc1000: handle mgmt_frame_register ops from
 cfg82011 context
Thread-Topic: [PATCH 13/29] staging: wilc1000: handle mgmt_frame_register ops
 from cfg82011 context
Thread-Index: AQHUimk95/U4dlnk60KiYT5YqPv/6w==
Date:   Sun, 2 Dec 2018 18:02:51 +0000
Message-ID: <1543773663-20561-14-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2806;6:AVIpkFRgRNXzCXsFpYJCN0ujrjBaG7sTy7bKLH230mQrVlo6NZmA40m+hXhG1gDMsxIPjXxC1UdovClUucm182yUOrxo9XmqCjEbmp1pkjoKsPLckXUxo63st+PvuQ5e34KFJcqj3sE1WkaExdeLRa8coepcI7K5WGSJuKkegZ1mYT7i1ayWbktaFPW12RA4ce3r8f33U0dMyfwxY6ArLewCCCiv2ggwl7OwohRr4wV8yofSpZy0CtQSVWUGcpCMgVRqgB3d8eQhYF8WR5w7QKnf0qdLlop6SZQwyoAuqNsD6g5KoddNfDGi2OD+wTgrSDaHaLvxvRnXGA8OR1Q1G7E+fiAY57eul1SmhQnNfbjeauicu5zp6YITr6+DgwzsF31TCs61VqnbS0EaOqMqe+xTB9Do/OD45uOm6Tx+fHr68+Y7f/7alXVmhTtVOx6nU9bfrid32BU1Ge4ZPPLJZg==;5:A4sxd0S2ljOlYTg+PV9aDaoRUhAutjCLNxh+/altiu4vTbqIGAThglLclLWOcYQcqyveBWHxGYveyR/CO2r2+DK3eLZsJHIgXOddMl/1sXWRT6TYX84imyJUj+wsx6zn1P+VH/wmGq1Fx4Nt7IeIBSi7f1rXAftJICiEtom38Qc=;7:Ppp6P5XtjJMLYfF7GLeojv5tSgRLF42DZ9L0YOa9k9rl9XzNq7p0CERVXHu5nhYU45ARE/LYJ9VTpSZhG+yK6o/vkMkdrWslUByweV8KUTni/ey7+kXWeApyCzG2vd6XGfeW7+B/huPL7DWNOyH0oA==
x-ms-office365-filtering-correlation-id: 40f99371-8ec8-462a-788f-08d65880603e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2806;
x-ms-traffictypediagnostic: BYAPR11MB2806:
x-microsoft-antispam-prvs: <BYAPR11MB28068EAF3CF03F44B31B94A2E3AD0@BYAPR11MB2806.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3002001)(10201501046)(3231455)(999002)(944501491)(52105112)(148016)(149066)(150057)(6041310)(20161123562045)(20161123558120)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB2806;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2806;
x-forefront-prvs: 087474FBFA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(366004)(39850400004)(396003)(136003)(199004)(189003)(186003)(4326008)(7736002)(26005)(14454004)(2906002)(107886003)(305945005)(386003)(53936002)(6506007)(36756003)(76176011)(6512007)(71190400001)(52116002)(71200400001)(5640700003)(14444005)(256004)(3846002)(6116002)(99286004)(5660300001)(78486014)(6486002)(446003)(11346002)(486006)(86362001)(105586002)(8676002)(97736004)(68736007)(316002)(2616005)(6436002)(476003)(54906003)(66066001)(25786009)(102836004)(81156014)(81166006)(8936002)(72206003)(2351001)(2501003)(478600001)(6916009)(106356001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2806;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: UblCPtgQ0MChwQSON3O4TKoveqnpGq4tyJiJhhW139JbWlvCpCi4YHm0BW+/4df08GXbg1BUNtzuK68n5o4FIyqWn4DlyUqk6RwS2OnuRSQp75N1+ebl+2DPVgHji07H6xG6QMDU0/F4Ghb8TcWGVY4YzrynR1K4Qc4/PLbNKIUQmcCK7LHprZ7PfZUfGWdf+XDPDme8/9apfFiOs6FSyk2WejVeZ6CodAnBM4GB02xo3P7TpowKQQPnKw5MRibYNMrxPgaMzo6kyJcIL7P1hT7kWp2Zy5eSJhZqoJVkuwpxhRYuXC8aMuqHtfQCbZza4ZAhWFUkAbv6RtVfhAt9Cc1VNuGwal/tobCQ83AZWEI=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 40f99371-8ec8-462a-788f-08d65880603e
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2018 18:02:51.5740
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

Avoid handling of mgmt_frame_register operation callback in a deferred
manner. Now set the wid command to firmware directly from caller
context.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 70 ++++++++++-----------------=
----
 drivers/staging/wilc1000/host_interface.h |  6 ---
 2 files changed, 22 insertions(+), 54 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 97b84d2..4d1fa4a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -89,6 +89,12 @@ struct del_all_sta {
 	u8 mac[WILC_MAX_NUM_STA][ETH_ALEN];
 };
=20
+struct wilc_reg_frame {
+	bool reg;
+	u8 reg_id;
+	__le32 frame_type;
+} __packed;
+
 struct set_ip_addr {
 	u8 *ip_addr;
 	u8 idx;
@@ -115,7 +121,6 @@ union message_body {
 	struct get_mac_addr get_mac_info;
 	struct ba_session_info session_info;
 	struct remain_ch remain_on_ch;
-	struct reg_frame reg_frame;
 	char *data;
 };
=20
@@ -1963,39 +1968,6 @@ static int handle_remain_on_chan(struct wilc_vif *vi=
f,
 	return result;
 }
=20
-static void handle_register_frame(struct work_struct *work)
-{
-	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
-	struct wilc_vif *vif =3D msg->vif;
-	struct reg_frame *hif_reg_frame =3D &msg->body.reg_frame;
-	int result;
-	struct wid wid;
-	u8 *cur_byte;
-
-	wid.id =3D WID_REGISTER_FRAME;
-	wid.type =3D WID_STR;
-	wid.val =3D kmalloc(sizeof(u16) + 2, GFP_KERNEL);
-	if (!wid.val)
-		goto out;
-
-	cur_byte =3D wid.val;
-
-	*cur_byte++ =3D hif_reg_frame->reg;
-	*cur_byte++ =3D hif_reg_frame->reg_id;
-	memcpy(cur_byte, &hif_reg_frame->frame_type, sizeof(u16));
-
-	wid.size =3D sizeof(u16) + 2;
-
-	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
-				      wilc_get_vif_idx(vif));
-	kfree(wid.val);
-	if (result)
-		netdev_err(vif->ndev, "Failed to frame register\n");
-
-out:
-	kfree(msg);
-}
-
 static void handle_listen_state_expired(struct work_struct *work)
 {
 	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
@@ -3162,33 +3134,35 @@ int wilc_listen_state_expired(struct wilc_vif *vif,=
 u32 session_id)
=20
 void wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg)
 {
+	struct wid wid;
 	int result;
-	struct host_if_msg *msg;
+	struct wilc_reg_frame reg_frame;
=20
-	msg =3D wilc_alloc_work(vif, handle_register_frame, false);
-	if (IS_ERR(msg))
-		return;
+	wid.id =3D WID_REGISTER_FRAME;
+	wid.type =3D WID_STR;
+	wid.size =3D sizeof(reg_frame);
+	wid.val =3D (u8 *)&reg_frame;
+
+	memset(&reg_frame, 0x0, sizeof(reg_frame));
+	reg_frame.reg =3D reg;
=20
 	switch (frame_type) {
 	case IEEE80211_STYPE_ACTION:
-		msg->body.reg_frame.reg_id =3D WILC_FW_ACTION_FRM_IDX;
+		reg_frame.reg_id =3D WILC_FW_ACTION_FRM_IDX;
 		break;
=20
 	case IEEE80211_STYPE_PROBE_REQ:
-		msg->body.reg_frame.reg_id =3D WILC_FW_PROBE_REQ_IDX;
+		reg_frame.reg_id =3D WILC_FW_PROBE_REQ_IDX;
 		break;
=20
 	default:
 		break;
 	}
-	msg->body.reg_frame.frame_type =3D frame_type;
-	msg->body.reg_frame.reg =3D reg;
-
-	result =3D wilc_enqueue_work(msg);
-	if (result) {
-		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
-		kfree(msg);
-	}
+	reg_frame.frame_type =3D cpu_to_le16(frame_type);
+	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
+				      wilc_get_vif_idx(vif));
+	if (result)
+		netdev_err(vif->ndev, "Failed to frame register\n");
 }
=20
 int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 dtim_period,
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index 647a1af..10d5627 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -244,12 +244,6 @@ struct remain_ch {
 	u32 id;
 };
=20
-struct reg_frame {
-	bool reg;
-	u16 frame_type;
-	u8 reg_id;
-};
-
 struct wilc;
 struct host_if_drv {
 	struct user_scan_req usr_scan_req;
--=20
2.7.4

