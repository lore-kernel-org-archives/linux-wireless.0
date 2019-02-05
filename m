Return-Path: <SRS0=RZRw=QM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0768DC282CB
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 07:15:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B51122081B
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 07:15:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="nS+nv38S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfBEHPd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Feb 2019 02:15:33 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:9668 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbfBEHPd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Feb 2019 02:15:33 -0500
X-IronPort-AV: E=Sophos;i="5.56,562,1539673200"; 
   d="scan'208";a="26155318"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 05 Feb 2019 00:15:32 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.105) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Tue, 5 Feb 2019 00:15:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hQc98idW1A/TfN1nSVkPYPaw6O2OhEJOSNUJuqhUYMs=;
 b=nS+nv38Sy0XKCvl191qWKSaJIX/xe1X1Z2w8wuv+eOFaa9pLHxutktGb/r7VhLKwe9WEYWj/HkS0l2NHfLCgU7CslIFzp1S4TfJoL7/jKaAbBAHrCtlWaSn6v0ZJ9ysyA/pR1U8FE7NE6YB3BIfo6kTmQsiSjbjc3ktRSCk3Oks=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2982.namprd11.prod.outlook.com (20.177.224.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.20; Tue, 5 Feb 2019 07:15:29 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1580.019; Tue, 5 Feb 2019
 07:15:29 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 00/12] staging: wilc1000: changes to address mainline review
 comments
Thread-Topic: [PATCH 00/12] staging: wilc1000: changes to address mainline
 review comments
Thread-Index: AQHUvSKSg3xKO8ghmkS+V5h+vGJW0g==
Date:   Tue, 5 Feb 2019 07:15:29 +0000
Message-ID: <1549350913-645-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR0101CA0066.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::28) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [183.82.17.42]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2982;6:EENPmI20Ivst51C9+TfKLw12zV5zNRp/y0nhhmDC1+i3pxuLEczbG7TdqDJYN2vakuOg1rkX1OijSFo9vQLYcMuGUStL/LAHe4uhEZfO2i291gERPFtac43VvxawrT3ryHtfLEN7Lv+ri1DBG+EpCgxSk/PJ8jdqgxO3G7TkjlT3ue72uazT46QSYc6xg/qDBuVcsAWvl/DXwtOo/K2AxKCZx7k4fdAEBDqyiEoWSDZ/x+sBBJnmwjLFQV8Ero4VF/bQzO1/Et6CLKZr80scBDFUTbM2rIScGsMJgjaANYq1TRYzBaZbAk1k+c84hNnb6khHmsTs2K2tjhUw8fY5SBowa1psckca598MPIqnbleUbt70vDLahZtoC7NfqSo0e8tCbZUEyqMfcpMnBV/d4agMePIlBLBU82XVHhYGwD0GMDS85zX0hthvCs3P8Xh4ZrqBKRiOkNAlTo7LHL4PiQ==;5:es30bMB6U+iQhnQNT8cLUXe6s8Yl55VPfIWrSmXd2816mPbYodbJ2bKShyR2bHRAIccqOANMqfp9uiy4lCzEu08z5OrQC+rp6xCpHHZLXIWokD+8EEAKwqaBnlEiwhjMzEzkUkOCNBT8lVfbLmtStDnFMKrRr7eg7SvtDHj1KPJRZvGHTBr3+2LPgYttuHdA2zglwq76VAeM5EL6JcGUEQ==;7:+U1lLX/WtMZ8mouwQRCPVqMndF1BCrtQog4s+msuE9OdXFrkUPmamtX3kqXXkZPydhpkAVeTEYjdIX0TMmdw+KpOPRhI2ZTUQZdKGkFYWWqQOVqywptv5s2PklEobgnh0rAZlbCkS0gK/Iij/wCPuw==
x-ms-office365-filtering-correlation-id: d895b6ca-e8db-41db-d7a7-08d68b39b528
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2982;
x-ms-traffictypediagnostic: BYAPR11MB2982:
x-microsoft-antispam-prvs: <BYAPR11MB2982E68D13BD974EDA271938E36E0@BYAPR11MB2982.namprd11.prod.outlook.com>
x-forefront-prvs: 0939529DE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(346002)(376002)(366004)(396003)(189003)(199004)(478600001)(36756003)(305945005)(102836004)(6486002)(81156014)(81166006)(71190400001)(5640700003)(6436002)(186003)(14454004)(99286004)(6306002)(52116002)(386003)(26005)(2616005)(476003)(256004)(8676002)(6512007)(14444005)(316002)(6506007)(2906002)(53936002)(54906003)(3846002)(4326008)(25786009)(2351001)(106356001)(6116002)(7736002)(486006)(86362001)(2501003)(68736007)(50226002)(66066001)(97736004)(966005)(107886003)(105586002)(72206003)(78486014)(71200400001)(8936002)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2982;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: be/056IIvvoC01FYEuRFqgiZgFXjufkA8/2GgU/eaOaCzNZ36wLIkd+4U7a+RafAmUznap9bV03Gu9sTukGkzEcwwGCnPnlVlJZnz5b3egcV9gG3iTU+iNqGeELcNEibA+JUyPtkBYdLWmU/KllhVEZInH55xgpqo7inKVXRNCIbD0mUNh8TANI7taU/6AdyiuH4Em3mlNCGp5aWfYxKuOqPMcqSPYz3soOkpY0yd/ZnE64q1vbBGp1YD/rxDbSjqEimZHvsIt3ecFf3LpyKUK6o5Nd+cVC/QgSKnWQaPJ+8GiLaYiPGNb1PqbQWpcSs8ThvpF4atOIyggrrY9r9nGiHrrbgTNaupGEDJD3oXOBKN507H1Q4RUgkZ86AYYRW7MzaEqcqS/GCOaACU52sM7N1yY0awl+LHFiNrkpKKRw=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d895b6ca-e8db-41db-d7a7-08d68b39b528
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2019 07:15:26.7759
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2982
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

This series contains pending patches from #9 till #15 from previous
series[1].
Also added 5 new patches to avoid the use of unnecessary static
variables for few leftovers.

[1]. https://patchwork.kernel.org/cover/10794463/
     https://patchwork.kernel.org/patch/10794479/

Ajay Singh (12):
  staging: wilc1000: remove use of 'terminated_handle' static variable
  staging: wilc1000: refactor linux_wlan_init_test_config()
  staging: wilc1000: refactor code to use cookie information
  staging: wilc1000: use random number for cookie instead of pointer
  staging: wilc1000: avoid use of interface names for validation
  staging: wilc1000: add check before performing operation on net_device
  staging: wilc1000: remove unused struct 'add_sta_param'
  staging: wilc1000: avoid use of 'hif_deinit_lock' static variable
  staging: wilc1000: avoid use of static variable in linux_mon.c
  staging: wilc1000: move static variable 'wlan_channel' to 'wilc'
    struct
  staging: wilc1000: move 'curr_channel' static variable in 'wilc'
    struct
  staging: wilc1000: define p2p related static variable as constants

 drivers/staging/wilc1000/host_interface.c         | 107 +++----
 drivers/staging/wilc1000/host_interface.h         |  24 +-
 drivers/staging/wilc1000/linux_mon.c              |   9 +-
 drivers/staging/wilc1000/linux_wlan.c             | 356 ++++++++++--------=
----
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 113 +++----
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |   6 +-
 drivers/staging/wilc1000/wilc_wlan_if.h           |   1 -
 7 files changed, 271 insertions(+), 345 deletions(-)

--=20
2.7.4

