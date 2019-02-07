Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05409C282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 07:22:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC39F2075C
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 07:22:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="wgu2ugim"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbfBGHWV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 02:22:21 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:26476 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbfBGHWV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 02:22:21 -0500
X-IronPort-AV: E=Sophos;i="5.58,342,1544511600"; 
   d="scan'208";a="26238595"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 07 Feb 2019 00:22:20 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 7 Feb 2019 00:22:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ux1AGHU9SoVFViqxS0jMj/XdKSXr6RUv8KEIAEbkU5s=;
 b=wgu2ugimScN3SEDJeQWIlY99EENAu+6wtm4flc4QUkP/KyAmYfPuCH0slZTeHtQKYeHZVNRwNC/1Wm7hIxs4RYytblKhO8uKhHWt7seD2cSn+gFlWaJoOcaRSypXOZK9fmjpPLU9bbfhcs4LoB+p1xg5x+4LFpjyc5rXqhzIOc0=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3415.namprd11.prod.outlook.com (20.177.224.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.22; Thu, 7 Feb 2019 07:22:17 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1601.016; Thu, 7 Feb 2019
 07:22:17 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 0/9] staging: wilc1000: fixes & changes for mainline review
 comments
Thread-Topic: [PATCH 0/9] staging: wilc1000: fixes & changes for mainline
 review comments
Thread-Index: AQHUvrXb38zG4JnDUUKnYC+u3svHJA==
Date:   Thu, 7 Feb 2019 07:22:17 +0000
Message-ID: <1549519927-2651-1-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3415;6:U1FoTeZh9Eiyr8GGBvtlp1wmwfuIQPM4wsKYBx12HXsbEL9PMONl6A+mOOmvv174p0Bo6mQCcBHUKTCcZ5L3aMRCzSJdp66P8NBt8p1w1UAPx2bKBLfRUbYmO7whDRZmwfK1wFSutNSRXVk5J5tLy4I32sWXINuvjawHDuawDBlNLag16ZDNfwxSOzrdmq8pSDJJZ4zemZ07hpymHFPbdH8jH0jRQAi2/KvG5Vp/MeMli4s7b+IqVVpdSv4HUb5viGkvP38nfWSog2wAFFQvlNKLmS3JvbXW3Ar5WwCQhtPfsicfCNfxrpzJVqnmVyEGjDYZWLSsHEO2sizdLQLlh3E75XMFFCd9Vq8e9lYe2xh9j6Cr6vLcnVYDQyEMjLWWYRPBxIVBkoeQ57jtGg5pDgdcX4c1ou2K2qE7zXX7O4czi8az5r809qq23pqNaBzA4bvdpwdhIkRqnsiChDYTfg==;5:eLnDM44qAzT+0z6Tz9ed0JcbPjrMi+9zdW3KEu7X2VvxoVwFz0tugMYzCW94rbeJ/6HIENoLa/SuX8K1bELCebtGVL+klVAX6Vh1GgYGEpfMSI+nPi7aGrM1nKRzgnfdDVfM2+V8V7SLBD58xrte93pnLouVYnrXtLGHGW4RjPGBajtTH9B6TXqAfc6gZoFn0fCZZsXPGYGgAXeQGX7yLA==;7:IZ8O35CHAXIRc06PKgK6At5cfGX71ZBJfwExo+6jok322Yigo2WaX7wOWxhlv6DIXwFgiftiDVl9Adlb8jwF/ONN/KgWPg7AOdcDtWnj+Xk+j4PmhRhBGvieJBvaLfcUyu/kKKP7L37sjd/3WFJitw==
x-ms-office365-filtering-correlation-id: 965f381f-91c4-46f8-468f-08d68cccfd7e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3415;
x-ms-traffictypediagnostic: BYAPR11MB3415:
x-microsoft-antispam-prvs: <BYAPR11MB34150D5BC5CBC92E7A96C57CE3680@BYAPR11MB3415.namprd11.prod.outlook.com>
x-forefront-prvs: 0941B96580
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(136003)(366004)(396003)(376002)(189003)(199004)(86362001)(5640700003)(478600001)(6116002)(3846002)(72206003)(6486002)(6436002)(25786009)(2351001)(2616005)(476003)(6512007)(105586002)(106356001)(486006)(26005)(6506007)(102836004)(386003)(36756003)(71190400001)(2501003)(97736004)(71200400001)(81156014)(305945005)(66066001)(54906003)(4326008)(186003)(68736007)(8936002)(81166006)(107886003)(52116002)(50226002)(53936002)(256004)(6916009)(316002)(99286004)(14454004)(2906002)(7736002)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3415;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4HSyI90/ZsYYrRa1XskQBB4ujq4znn/WY6mguYHjKjxOfaR+1L6Y3zqfKbTMyCojRmC9srS0kKm3J+BcohQ6mbasP4ttBc2lU9pW4eXe0adgkWM1Y4IofU373uQz+Zvx1ANkOirosHzTiYqdeJYVgepRWU3+xn5it/atZPxvAhPl/oIEllD03nkL/PWhXoxCNITw294xTUvZYLY+1vVS70pQMqEMyH+6THxN4L56HPX412hMniRzWLWSRS3/U8YYWWMhRROazuSHcyuT9ULLvLTY5o2P8x1pWCjZOm1cIhJv5lqsVol/CJg5Sun5u8WYtG9IPG4P8aeDMTGjVbxfggaGZNxxBrxYQYK4FMYkWKlhhi5cOv1D1VHkBiwKxYG5G1D7RrfWL8SM/ZMp0XzIljIUNXYI5MOX+wKjM1S8I2g=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 965f381f-91c4-46f8-468f-08d68cccfd7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2019 07:22:14.9605
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

This series contains the following changes:
 - fix to set 'vif_num' value correctly. The previous Fixes patch
   for vif count had not fixed the issue completely, so reverted it
   and added a new patch to fix the issue.
 - use 'wilc_' prefix for variables and function names.
 - avoid use of unnecessary 'linux_' prefix from file names.

Ajay Singh (9):
  staging: wilc1000: revert fix related to vif index
  staging: wilc1000: fix to set the correct value for 'vif_num'
  staging: wilc1000: add 'wilc_' prefix to have proper namespace
  staging: wilc1000: move macro and function prototype from
    wilc_wlan_if.h file
  staging: wilc1000: avoid function forward declaration in wilc_sdio.c
    file
  staging: wilc1000: added 'wilc_' prefix for function in wilc_sdio.c
    file
  staging: wilc1000: rename wilc_frmw_to_linux()
  staging: wilc1000: remove 'linux_' prefix in function names
  staging: wilc1000: rename linux_wlan.c and linux_mon.c

 drivers/staging/wilc1000/Makefile                  |   2 +-
 drivers/staging/wilc1000/host_interface.c          |  55 +++---
 drivers/staging/wilc1000/host_interface.h          |  23 ++-
 .../staging/wilc1000/{linux_mon.c =3D> wilc_mon.c}   |   0
 .../wilc1000/{linux_wlan.c =3D> wilc_netdev.c}       |  27 +--
 drivers/staging/wilc1000/wilc_sdio.c               | 187 ++++++++++-------=
----
 drivers/staging/wilc1000/wilc_spi.c                |   4 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c  |  22 +--
 drivers/staging/wilc1000/wilc_wfi_netdevice.h      |   2 +-
 drivers/staging/wilc1000/wilc_wlan.c               |  13 +-
 drivers/staging/wilc1000/wilc_wlan.h               |  17 +-
 drivers/staging/wilc1000/wilc_wlan_cfg.c           |  12 +-
 drivers/staging/wilc1000/wilc_wlan_if.h            |  36 ----
 13 files changed, 190 insertions(+), 210 deletions(-)
 rename drivers/staging/wilc1000/{linux_mon.c =3D> wilc_mon.c} (100%)
 rename drivers/staging/wilc1000/{linux_wlan.c =3D> wilc_netdev.c} (97%)

--=20
2.7.4

