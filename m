Return-Path: <SRS0=z7UY=PZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10214C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:21:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D165E20652
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:21:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="kq1zksP+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbfAQNVi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jan 2019 08:21:38 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:61724 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727515AbfAQNVe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jan 2019 08:21:34 -0500
X-IronPort-AV: E=Sophos;i="5.56,489,1539673200"; 
   d="scan'208";a="25443312"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 17 Jan 2019 06:21:26 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.49) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 17 Jan 2019 06:21:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d8Xy7nIgE2WZ486RD+S2CNwDQBbNHlCwO5d/KB/FFu8=;
 b=kq1zksP+QJIxRrkDSqYCv0KjrQmle/Wlj/j9Ru9xTGRZ0qWMBDBZg4N02RobtSyIZ/JAbo1muGXYs6VhJcE1sBvOERY9WzSLOflHbNGOO78+yhEbZPsPfzqzZX4OmJ7awcks3q1aPhdPA/ODxk+RnKfl1KJXMInqB3Z8HjoidL8=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3464.namprd11.prod.outlook.com (20.177.187.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.26; Thu, 17 Jan 2019 13:21:24 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::c110:8559:a438:491d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::c110:8559:a438:491d%3]) with mapi id 15.20.1516.019; Thu, 17 Jan 2019
 13:21:24 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 06/13] staging: wilc1000: corrected order to pack join param
 buffer
Thread-Topic: [PATCH 06/13] staging: wilc1000: corrected order to pack join
 param buffer
Thread-Index: AQHUrmeLEtTrOFhOkkOfLx/rsq4Z4A==
Date:   Thu, 17 Jan 2019 13:21:24 +0000
Message-ID: <1547731250-18518-7-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3464;6:eYVBpUA5Iv0bQleXRk+EJMWkFhUlahbbhDl8wVnWeLlo9cyr+eizY8FqdCgza2pB4Pcl3DX4jRadJ6c9fs3nmHK8m1xij/FVk7PlGkz+pf7WRxNXBb43nIX27FU2voD/+vyoeueuxqUhlrhIGtKHWy9xzr+SBchZUM7ePb0AzNHwWohxpLKCZccXH64wcy6Ss2zBNchgGXAvtNxteSjmHWq9OkWoCWNJURBda46wfX9zaCSJ2vnxPzKprV7VvRkouXAPV4ZdDd2NuCGVNMjokjKJo8iuYtXjQRsP6wYe3NKBBc6sPmAnJN3nMjCOJ1a1OIR5xL4bbjEEdMKbIWj7QVdf+CpjPV1niGjqYSR7tqNpWnuWh3mkx6tgpK8DjNVQfUVMrpoZX+Ms5C8aECWluHNWZkQ66qiQT08L5CvWOEM+4tswEasMT9Gv3RDJfofU3VxxYSikrCfkXmNCbuPkFQ==;5:25i3CY4ZjiWlIBj/f4UE/FGbd7kOvRjUp6E0mfD0u6pHktnkNEo4AteLR3msZPBcF39zQpT+RNmfuANalfft128GkUrPIU8pnjdrKHQ/qVjq2Pq8DcN1ftZzFetqGhsU7LJgzHCNSvojbriFMCoYiHeZiqp2Bv9GHRlNqedDaYZKl47nrw0cSiKljop2Fqi7G94VInqpgU+YbLjh9c6CaQ==;7:six9B73L8PM+nB7WXGKXbCL9wkty0ED1hUEDFUcm3IlrcuQAqnewIwJh2GCfcRnZmBP6RelzxBCSazGM0BArLKIPRVkbzlSyfwfJs09WeyOIlDQiR4y+RI0TA9dpHy2Gc7i0jGQbWLA2QQI7ZEfwOQ==
x-ms-office365-filtering-correlation-id: d6b21e66-6afb-4966-f544-08d67c7ead80
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3464;
x-ms-traffictypediagnostic: BYAPR11MB3464:
x-microsoft-antispam-prvs: <BYAPR11MB34646BD3173B0705C44B2907E3830@BYAPR11MB3464.namprd11.prod.outlook.com>
x-forefront-prvs: 0920602B08
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(136003)(39860400002)(376002)(396003)(199004)(189003)(14454004)(68736007)(81166006)(81156014)(5660300001)(8936002)(2906002)(106356001)(8676002)(26005)(305945005)(7736002)(6486002)(6436002)(5640700003)(36756003)(86362001)(99286004)(478600001)(6916009)(50226002)(72206003)(78486014)(76176011)(2501003)(66066001)(4326008)(97736004)(486006)(25786009)(6506007)(476003)(102836004)(14444005)(256004)(386003)(53936002)(2616005)(54906003)(6512007)(71190400001)(71200400001)(105586002)(107886003)(3846002)(52116002)(186003)(2351001)(6116002)(316002)(11346002)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3464;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 53+dgJM5QWHRgw9em1tcFItXH9e9Fo6bi9iDoxt5cp4y0pdO7zc56jtoPgHWz1tamIeAV/7pRcnAUhBCLFibZJQ4POA9QNRyKdlX70GSvp/o4m0jT1F+JeZ6lji/l+PYXfGFzW+onRMjmKdmqHwV2HXH/ojwLb82yfItWI/CCoxxmehRfYJ4XuHRE+GTc4WgQIDYZWWaIdfGm6p7lW8FgS3LRwhBGjAGKMs7EjtB9MwseWs82FSvSOLR71dKbe+hK4B7S4ZywH73M97L1LsG2pSsyCwsHUT8/mrMkU/tE4Swvo1DVfrPewjrd+Do969Js7ASf/UeKy0aPFEC5a4I66KD4kzdb/bh7CIKwi1SAy+e51mtowINnAAtu6lqUEeEzBd4ItaUZnjR3gu8P7L0SREj7LjhdXBfd4/9x29JuMI=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d6b21e66-6afb-4966-f544-08d67c7ead80
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2019 13:21:21.7872
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

Modified packing order for join param as expected by firmware.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 68f58d1..2fb5697 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -11,8 +11,6 @@
=20
 #define FALSE_FRMWR_CHANNEL			100
=20
-#define REAL_JOIN_REQ				0
-
 struct rcvd_async_info {
 	u8 *buffer;
 	u32 len;
@@ -436,15 +434,14 @@ static int wilc_send_connect_wid(struct wilc_vif *vif=
)
 	memcpy(cur_byte, bss_param->rsn_cap, sizeof(bss_param->rsn_cap));
 	cur_byte +=3D sizeof(bss_param->rsn_cap);
=20
-	*(cur_byte++) =3D REAL_JOIN_REQ;
 	*(cur_byte++) =3D bss_param->noa_enabled;
=20
 	if (bss_param->noa_enabled) {
 		put_unaligned_le32(bss_param->tsf, cur_byte);
 		cur_byte +=3D 4;
=20
-		*(cur_byte++) =3D bss_param->opp_enabled;
 		*(cur_byte++) =3D bss_param->idx;
+		*(cur_byte++) =3D bss_param->opp_enabled;
=20
 		if (bss_param->opp_enabled)
 			*(cur_byte++) =3D bss_param->ct_window;
--=20
2.7.4

