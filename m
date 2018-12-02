Return-Path: <SRS0=9n1M=OL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A18CC65BB3
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:02:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEB712082F
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:02:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="WCVieIVu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EEB712082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725790AbeLBSCl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Dec 2018 13:02:41 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:63009 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbeLBSCk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Dec 2018 13:02:40 -0500
X-IronPort-AV: E=Sophos;i="5.56,307,1539673200"; 
   d="scan'208";a="23749570"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 02 Dec 2018 11:02:39 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.49) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 2 Dec 2018 11:02:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k0oeqhaBSzkqVNphJN5Qn9zMWOaJ4Cc7V5gtvW3+i08=;
 b=WCVieIVupbxzPwOaNfl0bpjzQ9DnE/OpZdzofyzTxA8/rhdEcscciRKJzHyLwtJ7rSa/xXPdGyFjHuUCLUMSjn+B1u9LRVtVwId7HzfUAX+7FqhS3lXXr3mUYYqwHHoFPyWq/gv4AC83OXuCczVARVozITaOPg7tzsoBeDmYgg0=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3334.namprd11.prod.outlook.com (20.177.185.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.19; Sun, 2 Dec 2018 18:02:36 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f%4]) with mapi id 15.20.1382.020; Sun, 2 Dec 2018
 18:02:37 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 08/29] staging: wilc1000: use void return for
 wilc_hif_pack_sta_param()
Thread-Topic: [PATCH 08/29] staging: wilc1000: use void return for
 wilc_hif_pack_sta_param()
Thread-Index: AQHUimk1lIAgSgqWJEGtf5DSG10zHg==
Date:   Sun, 2 Dec 2018 18:02:36 +0000
Message-ID: <1543773663-20561-9-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3334;6:AkFjoIxyeFKE/8UaopYxngnoQ6weS9f0NhO2LvtXPnL2jZnmHRtTkTU0QX/UfQXYNjtcortOl2MZQRnQkZyim5T6iqG2+VgmwI9iGnfxayQ57tXGs9Zax+pGPNQ5s8cUiwP4Y8esBqjeV0nXyirs7a+8JK0qDFxgtSAV9qjV1HNskg/Mj7MmXpshJKNXdIpgqfD+Dm5ISAEih7k1rcudmmEAWHfhE2iHXWIIEwcQFVcNAfW3vc1u1LEz3WkEFK5X99svwSlBehCKGws+7x4vQ0Indcp+qcb2RPRjId3NBRXFzYD3Q7mkTClETsmRO5Isi3YlXEGhQejAmlk2MJAuKpqfJVOWie1C9bm3/EJtp09Y2A+XNk9gb217vVRMhA+fezoy3rL19bKoUO6KXZKLA6TsQyD3dhhziayq86PYr3aP06X9LDFVQgRgWogqXK8JiaexLRG8ICgCPNyWCQAVKA==;5:+hEGjCFs6F27HpJCnv3bgvxAXkGNwppGUBeQelA4jqVQg1E/gfs8EezPHpEQWWSGmbStbIWCw6scsqiyK1yvpBzIRxE/J7NDT/wS2rrOu/Uv7zYt4jkmTMV6kCxlpz+OpwzIJrt2+v+GhawdJvcVBiW3x+iUstZCjKczcRxciDI=;7:RvEkeBsgwF9qlypAsg4MlU5zCwz2udmksb2hBDKY48cKYTnl8QvPRHYpA/Kdqg5hY2OTJf0+C+yjA8AtQhkXmqipFTlAMUCeoCpBwdxfKAp0ZIOosRfLlsdHhuqwFamj0SlemBg4Xa+h/eDR8MITQQ==
x-ms-office365-filtering-correlation-id: 05ada13c-82f7-4978-70e4-08d658805778
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3334;
x-ms-traffictypediagnostic: BYAPR11MB3334:
x-microsoft-antispam-prvs: <BYAPR11MB3334BA05F0822203F2781C46E3AD0@BYAPR11MB3334.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(10201501046)(3002001)(3231455)(999002)(944501491)(52105112)(93006095)(93001095)(148016)(149066)(150057)(6041310)(20161123558120)(20161123564045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB3334;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB3334;
x-forefront-prvs: 087474FBFA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(366004)(376002)(396003)(39850400004)(199004)(189003)(107886003)(6916009)(386003)(5660300001)(5640700003)(446003)(4326008)(11346002)(6506007)(78486014)(2906002)(6512007)(53936002)(54906003)(3846002)(6116002)(2351001)(81166006)(316002)(81156014)(52116002)(8676002)(26005)(8936002)(256004)(76176011)(6436002)(97736004)(106356001)(99286004)(486006)(6486002)(68736007)(105586002)(14454004)(478600001)(2616005)(7736002)(66066001)(36756003)(305945005)(72206003)(186003)(2501003)(86362001)(102836004)(476003)(71190400001)(25786009)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3334;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: eapxa6/HpWzT0X25nHXKyTrlBTG3jzRLmn2Bqkmeo+3CqqAjQt1yULckt8Q7gwnobE4kjYZMpptria8qBlrqlij+MG8BDIR1gknjPepJuaz7ClLDeoMK9BxpIEw3Iec5MPvRBeRZ2fvuIziDif+KvsKpZokk29xwATcr1M6g1BS+dR843ndRNrOn1nySzy8ORTH3pcXZjLibRpU+GEXeD9HLAicGNHvS/3CUluJfoOilLHh/Xsr3OSCp023NqwzQ2yiNAFM8Ijw5rMawRvNF9k1VXdzeT02g0gFIV+p4uz1zzGqgVulFr3wurkBY7/fFcuCqb7XIrxbyxdAvbY0QFMK9gdN1E2kIsoALIHLELCI=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 05ada13c-82f7-4978-70e4-08d658805778
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2018 18:02:36.8805
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

Change the return type from u32 to void for wilc_hif_pack_sta_param() as
its value is not used. Also remove the use of extra pointer as it's not
required now.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index fedcff8..40477ca 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1960,12 +1960,9 @@ static void handle_del_beacon(struct work_struct *wo=
rk)
 	kfree(msg);
 }
=20
-static u32 wilc_hif_pack_sta_param(u8 *buff, const u8 *mac,
-				   struct station_parameters *params)
+static void wilc_hif_pack_sta_param(u8 *cur_byte, const u8 *mac,
+				    struct station_parameters *params)
 {
-	u8 *cur_byte;
-
-	cur_byte =3D buff;
 	ether_addr_copy(cur_byte, mac);
 	cur_byte +=3D ETH_ALEN;
=20
@@ -1990,9 +1987,6 @@ static u32 wilc_hif_pack_sta_param(u8 *buff, const u8=
 *mac,
 	put_unaligned_le16(params->sta_flags_mask, cur_byte);
 	cur_byte +=3D 2;
 	put_unaligned_le16(params->sta_flags_set, cur_byte);
-	cur_byte +=3D 2;
-
-	return cur_byte - buff;
 }
=20
 static void handle_del_all_sta(struct work_struct *work)
@@ -3440,7 +3434,7 @@ int wilc_add_station(struct wilc_vif *vif, const u8 *=
mac,
 		return -ENOMEM;
=20
 	cur_byte =3D wid.val;
-	cur_byte +=3D wilc_hif_pack_sta_param(cur_byte, mac, params);
+	wilc_hif_pack_sta_param(cur_byte, mac, params);
=20
 	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
@@ -3532,7 +3526,7 @@ int wilc_edit_station(struct wilc_vif *vif, const u8 =
*mac,
 		return -ENOMEM;
=20
 	cur_byte =3D wid.val;
-	cur_byte +=3D wilc_hif_pack_sta_param(cur_byte, mac, params);
+	wilc_hif_pack_sta_param(cur_byte, mac, params);
=20
 	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
--=20
2.7.4

