Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1A6CC282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 07:22:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 874A82075C
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 07:22:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="nz5zLhdm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbfBGHW1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 02:22:27 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:47400 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbfBGHW1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 02:22:27 -0500
X-IronPort-AV: E=Sophos;i="5.56,564,1539673200"; 
   d="scan'208";a="27377114"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 07 Feb 2019 00:22:26 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.107) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 7 Feb 2019 00:22:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cQ7hHlIMiXZKvfYwtgQXyp6HEeP+3c7pXr3k29PwePE=;
 b=nz5zLhdm99vV55ACDzS36/jPhc6rPyvM1U2WLxgBo1rweb0t1IfFzy+aPjscG6hP6qsGqg9jLR0lvGwPZ51WyJ/uSt7xe/duiZCn83UNVDzBlKDKUrUZT3d5cdyF1VJbBGWO/7dcn22LD+Zrv/bkLsGYkmoqsLmEppjYBEvAFSM=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3415.namprd11.prod.outlook.com (20.177.224.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.22; Thu, 7 Feb 2019 07:22:25 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1601.016; Thu, 7 Feb 2019
 07:22:25 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>, <stable@vger.kernel.org>
Subject: [PATCH 2/9] staging: wilc1000: fix to set the correct value for
 'vif_num'
Thread-Topic: [PATCH 2/9] staging: wilc1000: fix to set the correct value for
 'vif_num'
Thread-Index: AQHUvrXfydZqDAWgJk6jufREFkE89g==
Date:   Thu, 7 Feb 2019 07:22:25 +0000
Message-ID: <1549519927-2651-3-git-send-email-ajay.kathat@microchip.com>
References: <1549519927-2651-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1549519927-2651-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR0101CA0020.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:c::30) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [223.237.230.157]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3415;6:oNEjNroldMXPzhZDRwZb0IRA7J/1pKnpn0+zXxAoaXHuJBsySBq9I0s93psw05fccYYo6MgNCXZxNHE8hQmJ/DoD6NTpUNl4XxllOCJ2J0OijUoh+qgpd6llha4F+cvRUhcqHC/7TUcza1opC/CxtdfKhCWg6I2S32JjqoOgnduheGWRORDbMit1kynZUU0X8uVuUOOJLIpIk3nrXYTuMX5wqeI2VGNEluuRI0XUOEoX3CZwaXN1Ax8w9jxng62pSqFxnJYzRI0aCEZuLOalC98ckEaWU0SciLEjopANuy4ze/D8d3LZwoa4rL+7TdcArHoFsTkfVMQRtYznM4jazz1VTik5Y4syq2R2RCTMTl8aChdHZX5LLzZ6j9s8KYVkmNbN1SLgNK7Y4bH0IsI5X1AOBgft2qJkIRK60/lTpwsp76CQoNdgx0cAhUbklNbZhFZS5vLt+amZotB2MGPsVg==;5:Ql5lCmsHN8Aozj0n4sLzRe+s5+cbuq3ES0eMmQifwLfgqwzZuwMDDNeDhuPqCJBD3ydyKJTqqDuozu6cHoKBhLDtPF1cC37i/iIaR6kH5/FxxqF7VROMw2SayUY7pSgTcc17SuJp1uDeR2jCVbymD/9d5xzuS4441MO7/83R1Fv8E7i8VfmKPhWJBWJZJeETQuJwLfqhA3R2Mb4hfIgXCA==;7:TnBJ4vmmOtT5BJ3rw0ynYmGDp7pxBWyMU7burIRzovEJMa1HpQY0oIX0nzKdp+OMSuzlrYBCWkiqCjFiCPjXWI2+NNE9Co59Gg7PNPUMzOfS4b92SJ5HfhOqgnnXMkIhueSaoVdX2k/f5UfWS6Qekw==
x-ms-office365-filtering-correlation-id: 0bce5d14-e90d-4008-e88e-08d68ccd01ab
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3415;
x-ms-traffictypediagnostic: BYAPR11MB3415:
x-microsoft-antispam-prvs: <BYAPR11MB341591635A86C4C43B90CF96E3680@BYAPR11MB3415.namprd11.prod.outlook.com>
x-forefront-prvs: 0941B96580
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(136003)(366004)(396003)(376002)(189003)(199004)(86362001)(5640700003)(478600001)(6116002)(446003)(3846002)(72206003)(6486002)(11346002)(6436002)(25786009)(2351001)(2616005)(476003)(6512007)(105586002)(106356001)(486006)(26005)(6506007)(102836004)(386003)(36756003)(71190400001)(2501003)(97736004)(71200400001)(81156014)(305945005)(66066001)(54906003)(4744005)(4326008)(186003)(68736007)(8936002)(81166006)(52116002)(50226002)(53936002)(256004)(6916009)(14444005)(316002)(99286004)(14454004)(2906002)(76176011)(7736002)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3415;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0ObNm7FVXMY/iMErMCO8gz3r0zr7wQ2txFRfyabKeGvXsAfitXCYKKuG0MwgGSq+r1rjVix8GGhgWrPVy83Uq76u536HP54XwgMsUJ0pdXj4Iac/XNk5X2s4srf594oanCqEwT49+I8Q47nk33bjr+c/+SI5NxJifujb4u+T+lIRImBpwLtRB3govk1ZKZ7OKpPHWSZ1RGS4Q43q9YQ0DSTaWJopjkhCy9yMQgZozrTKv3zkpR1EkspJoOBVn6QQ+ctTBJw0IUQG6GrTMXgj+oS78W2/jFwlBTL0kPsDZSHEExM/mvWQ8Rziu4BFjN7ojGueP7H9j+JV4egm6Eb09H//04/UadhnaNQ9rWoxf4ttRv/vnP/7XhC2fmOSH3cbtAcwhvXMcA6mBXKspVAv5PKmqzoAlC4gb0XZIsz9l/A=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bce5d14-e90d-4008-e88e-08d68ccd01ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2019 07:22:21.7262
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3415
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Set correct interface count value in '->vif_num'.
'vif_num' was incorrectly set one less than total number of interfaces
because 'i' is used to set its value, which starts from 0.

Fixes: 735bb39ca3be ("staging: wilc1000: simplify vif[i]->ndev accesses")
Cc: <stable@vger.kernel.org> # v4.10
Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc10=
00/linux_wlan.c
index 648b658..8fa5f90 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1021,7 +1021,7 @@ int wilc_netdev_init(struct wilc **wilc, struct devic=
e *dev, int io_type,
 		vif->wilc =3D *wilc;
 		vif->ndev =3D ndev;
 		wl->vif[i] =3D vif;
-		wl->vif_num =3D i;
+		wl->vif_num =3D i + 1;
 		ndev->netdev_ops =3D &wilc_netdev_ops;
=20
 		wdev =3D wilc_create_wiphy(ndev, dev);
--=20
2.7.4

