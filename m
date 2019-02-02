Return-Path: <SRS0=M3au=QJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 051E8C282DA
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Feb 2019 19:17:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3FF82082C
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Feb 2019 19:17:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="rJ9Ifz+M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfBBTRD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 2 Feb 2019 14:17:03 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:36455 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbfBBTRD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Feb 2019 14:17:03 -0500
X-IronPort-AV: E=Sophos;i="5.56,553,1539673200"; 
   d="scan'208";a="25789173"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 02 Feb 2019 12:17:02 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.108) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sat, 2 Feb 2019 12:17:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SdrUwiVqV+p/0H+c6fPVfe46ka2sTfXzYSPleSF5BO0=;
 b=rJ9Ifz+MRdDNoR+cVhKcxMmw0yMkA/XRLzgg68d47zkQY+FUy6FMjNQavEGhDDhHYxJA4k9EhjXLvsQeKT/G23NAW5RUzfjygVVTwLzIQMAbuBlL7VHGZJTQ+vEg22HCVvMKb7n8Nv2iwqLmSXmvJQJ+mGFZI3oKxJEOE9Scmyo=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2998.namprd11.prod.outlook.com (20.177.224.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.21; Sat, 2 Feb 2019 19:16:59 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1580.019; Sat, 2 Feb 2019
 19:16:59 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 03/15] staging: wilc1000: remove redundant macros for radiotap
Thread-Topic: [PATCH 03/15] staging: wilc1000: remove redundant macros for
 radiotap
Thread-Index: AQHUuyvee8IyQa2e20K4gx2Ludvwqw==
Date:   Sat, 2 Feb 2019 19:16:59 +0000
Message-ID: <1549134974-5545-4-git-send-email-ajay.kathat@microchip.com>
References: <1549134974-5545-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1549134974-5545-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR0101CA0011.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::21) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [49.205.218.11]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2998;6:yV6boP0iwM3yNdxyfdIXmKCIXI9bWOfXU94+hdaXmpykYdhLlc7Ao/Y49nAoy+agczeV6lD9PCGHs1kmf56AT/eY+zPsTxCf7dWp6s8/CG58zXN/rnWmn7jaqDe70/rJ/BLqDl5ZA/YMnPbXTv1r1wf+dAfujYWB7I3lOQn235vxEoUNkAJv1y5s8emiVPO7trbH7ygECWeQkn+zBVGXqXvPeYO0fj3C6F3Qxddh1C822SKL6/YwlsEA6oVMduF/rU58dv2gS9PChEEbjASQkbynaa1qHtBmWj068r1Q3RxjA7qPx1GTUIugCZZBx1kceCdd1nUbEKq/zJy/n02LytszfSY7WgQXXQdQpHxhwYCefz6rRY8e1Xv5ksNSOtoGxcUHD17j1ceHk6AXYpxY7cVeujPah/PzgRwxuhNzLkUHY3EEiJufOQ6nKvXGvfP8kHDfU4x18WWZQBURKmdKiQ==;5:eFyde3Eh58mszJPZOeZOmNwSlmSKba4wG6X3EXUNqsPbF7bhSFjr0oX5t+A0PVMy9FoFpeyjeoCq3uoXE56LZTAJSW2h4o6oIY+DTKwL7Eh6Z7aE4maDj3M9s+eQIJKrdfqr+JY1Pvb9BEpYdOS7o9mBiKhwXbEIttRK7s1UKJsuMtajSkfUeoAwGVfX5ZcT0BWt/6POwg5m86O2G7EYZg==;7:cMYYps/GXKgqt27te0uhzg4e8n70FM26OzLTsdpwjWn/nb0eAdZm/BsUilH8QMKluUF+iR2LdrB/GaItXm5CTlUVZ5D3kA5odWb4XXL8ryW+iqYwJ2DSIxeT01ic/BcTjcqw/uiujD2JeMNN8kfIEw==
x-ms-office365-filtering-correlation-id: b9a1edd6-e81b-441e-6b32-08d6894300c7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2998;
x-ms-traffictypediagnostic: BYAPR11MB2998:
x-microsoft-antispam-prvs: <BYAPR11MB2998C8DA876AA4EE645EF82FE3930@BYAPR11MB2998.namprd11.prod.outlook.com>
x-forefront-prvs: 09368DB063
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(376002)(366004)(346002)(39850400004)(189003)(199004)(25786009)(107886003)(105586002)(78486014)(36756003)(50226002)(2501003)(6916009)(66066001)(8936002)(3846002)(4326008)(305945005)(7736002)(71200400001)(71190400001)(8676002)(6116002)(54906003)(81166006)(316002)(446003)(81156014)(6436002)(6486002)(2906002)(2616005)(486006)(476003)(76176011)(256004)(99286004)(11346002)(52116002)(53936002)(72206003)(478600001)(186003)(386003)(4744005)(26005)(14454004)(106356001)(86362001)(5640700003)(97736004)(2351001)(68736007)(6506007)(102836004)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2998;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ShCEwvXlaVKMfYHhTDux1YpByFGvUWV70b5KrAmwjBYpLJC/db7ydNk628CgIsfPiMczATntqse8P/GWIsGIw+2SLZMR4mlVKTjAYaEar66CB09y82rRqSRMZkzHjNKWW5vscXP9D3wdEeKF9sqFWYtQmKZvL93gVMgc+9g6sWbbWUWDbI/a+mMJ6ZMDX5B3C2iVu1nfatIi3OEpFc6ZHRfhyX2rlcfaKXEYNTV2mYUi/G+PyLf2VzodJS0r/uzgvQ2VU8CnTdwMe8e005e9qhoU+e1hltMfwfos4/COYArp6N2g34aXrAKLjh11ncGKD5+7lUabadFSUYhwVeLM2Qluncp78SGjWwaDSdSuy1GXykfnQi5zCLHsLCxmv929Hxxi3OMaUEyKASv8BNSHZ2ziFvusWfmynOudeE3xLFE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b9a1edd6-e81b-441e-6b32-08d6894300c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2019 19:16:56.9453
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2998
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Remove macro define which are already present in the included header.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_mon.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc100=
0/linux_mon.c
index 32d0c81..ce37b6f 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -21,9 +21,6 @@ struct wilc_wfi_radiotap_cb_hdr {
 static u8 srcadd[6];
 static u8 bssid[6];
=20
-#define IEEE80211_RADIOTAP_F_TX_RTS	0x0004  /* used rts/cts handshake */
-#define IEEE80211_RADIOTAP_F_TX_FAIL	0x0001  /* failed due to excessive*/
-
 #define TX_RADIOTAP_PRESENT ((1 << IEEE80211_RADIOTAP_RATE) |	\
 			     (1 << IEEE80211_RADIOTAP_TX_FLAGS))
=20
--=20
2.7.4

