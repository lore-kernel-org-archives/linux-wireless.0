Return-Path: <SRS0=z7UY=PZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 207CCC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:21:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D627D20652
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:21:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="i7wb9rBU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbfAQNVT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jan 2019 08:21:19 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:44173 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfAQNVS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jan 2019 08:21:18 -0500
X-IronPort-AV: E=Sophos;i="5.56,489,1539673200"; 
   d="scan'208";a="22718457"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 17 Jan 2019 06:21:17 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 17 Jan 2019 06:21:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J+ZyxChJIBQgdz7KlnWReR+NaeayWBV/PjuWDSjIsO0=;
 b=i7wb9rBU4p+nPeezzeXrpI88jH4VjmNqpRpa8KqETB3cMALA3K/kMfaMZYGEUandrdPA3TR3n01MGOZy9wPgi+lRDQE/dbZQT/Vh7ZgmUBSLOg/BttjlH9Vcmx7VoPAt+xHK9XQuZ9eV0vwE2RlvdLxxyh8m0dLv6ZjkJzbBg2U=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3464.namprd11.prod.outlook.com (20.177.187.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.26; Thu, 17 Jan 2019 13:21:15 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::c110:8559:a438:491d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::c110:8559:a438:491d%3]) with mapi id 15.20.1516.019; Thu, 17 Jan 2019
 13:21:15 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 03/13] staging: wilc1000: use 'struct' to pack cfg header
 frame in wilc_wlan_cfg_commit()
Thread-Topic: [PATCH 03/13] staging: wilc1000: use 'struct' to pack cfg header
 frame in wilc_wlan_cfg_commit()
Thread-Index: AQHUrmeGk6+Z8N1rQEeQAG2KjGv25A==
Date:   Thu, 17 Jan 2019 13:21:15 +0000
Message-ID: <1547731250-18518-4-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3464;6:LVBPTsBy8gN4z404FcI98vP4bUxiM2MHA2slheF3cZiqJGMWVkIHqqgg/T5eIprKdqwFCly9XO6k4nKAbYNO51Jcd6ojkzJ1q97/EAFfzbpARQLfhdbuomHQj/NJ9+6qO0JtFQybsbFShRLxj/gI447kntNQOkSJE0ny3kafTRlTb1TCbIfdvQlwVdJeK2ZYs0Ap+ddpR+qcD8MAn5mm8mizMnQNu+tfPwgW1L4JpQFRgvEBQq8Z67RAFOgoaQXAu0kIoTWYFymg5sKkYcadayR2aVn0x4GcXssww1VISLePLzoclwJn9n/r1SPedxYRUVK8nTVHFNx5ym14XDBC0vk5ROLcuuS6iomvP8fMAkxE7Isxi4kbyzUPR3au0Qp119Q3wqNjlaMrSOWCenbRWgpkBeyoztx2bDJXWlQJPsBPZDEd3pOnhE//0UmKzROPNEQbP9R+2RVnv7PzcrH/bg==;5:Abhpi/Q/7crQiVw62GZ21lSEX5+o1DIvqnvw12pg7lkPKUvcwq2jJv30A7EtYFvD1+jtJPArFPA7IzrYwV410AUkiq0UGT6J459KaQwewl28ewFGgRRhjJv7OiCFYARH8KquDgJrTPwieLLHoAaDMYC1CInJDgkiiTtOJtYofYhc+FDWDvj0+u3qlNctgyOB1phrql/rh551LVRx8TF0rA==;7:+Xpzqny17M/1XzkDxNbt1S3GyWH6Dj3yEM6MewLStqtTD9TZZwGO+21scv2zmRIiRXmGKp/Tkp5BMXilqX/xbj0ItlmVp4xz3vQBFNnU6FjXTTGlqcYHRqEfO6+DWDmdWgTYqqBFS+IhpIi3JTjtgg==
x-ms-office365-filtering-correlation-id: 1bd48ba5-09fb-4bb5-0c74-08d67c7ea883
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3464;
x-ms-traffictypediagnostic: BYAPR11MB3464:
x-microsoft-antispam-prvs: <BYAPR11MB3464D1C0532E6EB2716E05F0E3830@BYAPR11MB3464.namprd11.prod.outlook.com>
x-forefront-prvs: 0920602B08
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(136003)(39860400002)(376002)(396003)(199004)(189003)(14454004)(68736007)(81166006)(81156014)(5660300001)(8936002)(2906002)(106356001)(8676002)(26005)(305945005)(7736002)(6486002)(6436002)(5640700003)(36756003)(86362001)(99286004)(478600001)(6916009)(50226002)(72206003)(78486014)(76176011)(2501003)(66066001)(4326008)(97736004)(486006)(25786009)(6506007)(476003)(102836004)(14444005)(256004)(386003)(53936002)(2616005)(54906003)(6512007)(71190400001)(71200400001)(105586002)(107886003)(3846002)(52116002)(186003)(2351001)(6116002)(316002)(11346002)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3464;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Guw/ql0gDWGtKxYZg/hFnOBt5jHyDtcrkrsCOHpcjKT5vVxvBzEjBwlLNp/okbDV8VipTr3y65wbRV6W1z5kRJNHLXBLcrXy+MyvKnxthYE8yw6I6F9q72MRm3PRatRo6AixbZ26gMOwwuhBh+Ib1UdzI7jEuAvQ4yRV03NhybFTcBdNWbFFzSFJchsAu+97RHwdPUlCSgVcekTfQZSGRSL4E8w4bg0L1Zr80yHmP+853snh4dRpAvqKNpkIgoxB5S8U+mbwFTKyiGSzXRN3GuloG/oDcKcwOqLfS+LjTEmAf1i1NIyZ7fyAHaipcPGD2UuQfn37/SNo35IWlht9B0U05p92BxqcOtOkFU07Xh5uz6iTgTMEWOmYY/kkAWtRhM7dkR2P8SU3pLUVvyuQarJCivK0E+jCUZxnEpT7IB0=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bd48ba5-09fb-4bb5-0c74-08d67c7ea883
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2019 13:21:13.5054
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

Make use of 'struct' to pack cfg header in wilc_wlan_cfg_commit()
instead of byte by byte filling.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  2 +-
 drivers/staging/wilc1000/wilc_wlan.c          | 25 ++++++++++-------------=
--
 drivers/staging/wilc1000/wilc_wlan.h          | 14 ++++++++++----
 3 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/stagin=
g/wilc1000/wilc_wfi_netdevice.h
index c6685c0..a3400c1 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -251,7 +251,7 @@ struct wilc {
 	struct mutex cfg_cmd_lock;
 	struct wilc_cfg_frame cfg_frame;
 	u32 cfg_frame_offset;
-	int cfg_seq_no;
+	u8 cfg_seq_no;
=20
 	u8 *rx_buffer;
 	u32 rx_buffer_offset;
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc100=
0/wilc_wlan.c
index 3c5e9e0..16b6c55 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1092,24 +1092,19 @@ static int wilc_wlan_cfg_commit(struct wilc_vif *vi=
f, int type,
 {
 	struct wilc *wilc =3D vif->wilc;
 	struct wilc_cfg_frame *cfg =3D &wilc->cfg_frame;
-	int total_len =3D wilc->cfg_frame_offset + 4 + DRIVER_HANDLER_SIZE;
-	int seq_no =3D wilc->cfg_seq_no % 256;
-	int driver_handler =3D (u32)drv_handler;
+	int t_len =3D wilc->cfg_frame_offset + sizeof(struct wilc_cfg_cmd_hdr);
=20
 	if (type =3D=3D WILC_CFG_SET)
-		cfg->wid_header[0] =3D 'W';
+		cfg->hdr.cmd_type =3D 'W';
 	else
-		cfg->wid_header[0] =3D 'Q';
-	cfg->wid_header[1] =3D seq_no;
-	cfg->wid_header[2] =3D (u8)total_len;
-	cfg->wid_header[3] =3D (u8)(total_len >> 8);
-	cfg->wid_header[4] =3D (u8)driver_handler;
-	cfg->wid_header[5] =3D (u8)(driver_handler >> 8);
-	cfg->wid_header[6] =3D (u8)(driver_handler >> 16);
-	cfg->wid_header[7] =3D (u8)(driver_handler >> 24);
-	wilc->cfg_seq_no =3D seq_no;
-
-	if (!wilc_wlan_txq_add_cfg_pkt(vif, &cfg->wid_header[0], total_len))
+		cfg->hdr.cmd_type =3D 'Q';
+
+	cfg->hdr.seq_no =3D wilc->cfg_seq_no % 256;
+	cfg->hdr.total_len =3D cpu_to_le16(t_len);
+	cfg->hdr.driver_handler =3D cpu_to_le32(drv_handler);
+	wilc->cfg_seq_no =3D cfg->hdr.seq_no;
+
+	if (!wilc_wlan_txq_add_cfg_pkt(vif, (u8 *)&cfg->hdr, t_len))
 		return -1;
=20
 	return 0;
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc100=
0/wilc_wlan.h
index 2766713..c8ca13b 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -14,7 +14,6 @@
  *      Mac eth header length
  *
  ********************************************/
-#define DRIVER_HANDLER_SIZE		4
 #define MAX_MAC_HDR_LEN			26 /* QOS_MAC_HDR_LEN */
 #define SUB_MSDU_HEADER_LENGTH		14
 #define SNAP_HDR_LEN			8
@@ -251,14 +250,21 @@ struct wilc_hif_func {
=20
 #define MAX_CFG_FRAME_SIZE	1468
=20
+struct wilc_cfg_cmd_hdr {
+	u8 cmd_type;
+	u8 seq_no;
+	__le16 total_len;
+	__le32 driver_handler;
+};
+
 struct wilc_cfg_frame {
-	u8 wid_header[8];
+	struct wilc_cfg_cmd_hdr hdr;
 	u8 frame[MAX_CFG_FRAME_SIZE];
 };
=20
 struct wilc_cfg_rsp {
-	int type;
-	u32 seq_no;
+	u8 type;
+	u8 seq_no;
 };
=20
 struct wilc;
--=20
2.7.4

