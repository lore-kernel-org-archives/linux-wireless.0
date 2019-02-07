Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 494EEC282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 11:28:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0453021872
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 11:28:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="J9YMfX6H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbfBGL24 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 06:28:56 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:51220 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726579AbfBGL2z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 06:28:55 -0500
X-IronPort-AV: E=Sophos;i="5.56,564,1539673200"; 
   d="scan'208";a="26413599"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 07 Feb 2019 04:28:54 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 7 Feb 2019 04:28:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ikCh5iyheAcpPNbiF3wlTPvZ60+r9OKUwJDFbHl4IEc=;
 b=J9YMfX6HBMn3bvYFgbSqWIgWGEm3tXVdbZcOVzpxBeEFvdNPUbXUqIAq/NW8AbBmbA+L5iu24Dwfvld3lTyQqyIEE8V7XPwDdD1L1MsI8CcqGP4yS0/Ac7gBULxGcvyvgKEG0oMMYBq9arq/XaW7MyYTdcdCYvXzvkBskc1226g=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2792.namprd11.prod.outlook.com (52.135.228.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.21; Thu, 7 Feb 2019 11:28:52 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1601.016; Thu, 7 Feb 2019
 11:28:52 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH v2 0/8] staging: wilc1000: fixes & changes for mainline review
 comments
Thread-Topic: [PATCH v2 0/8] staging: wilc1000: fixes & changes for mainline
 review comments
Thread-Index: AQHUvthNLKBuTBpAP0GjDq0IvM7EXw==
Date:   Thu, 7 Feb 2019 11:28:52 +0000
Message-ID: <1549538913-17463-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR0101CA0060.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::22) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [27.59.126.210]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2792;6:cUZtB6B7APFRRFIfz7hkWjRDPRQMOoiildVAOdhXy521HRySMBw6dictRhC3V4fsf/g21uRm46Vri3mx0sETUo0fwpt7+zZ6dwqfjP7CGLpI8gB8y02wHYRHqbm4gt5P4ucm2cXH2YuDZhGcGSnSaFV4C1I+z4Cn3Y+GsE7Obp0+PEFLHv6bBm7ETsrI7KYTk9+myJ1OrxVWfgA2W3HK1r1uCbBU7qjwL4+wicAUqYWMjNaS8oY5h8EBPHx1tgASYu6nXgYj2/H+8gLpamtmIRnJzVTGhsxYy9UdkDkOQqCC0UIAgtpMOpgf+A5pu6eVJ4qI4+900ooz28lOpqUuf+qAtHFoxl5zPMoiZTfcZ6cT/HRlcJIUiIg0Q/ZoYC8Vy53PFjj5azYRCcoRLeiKCD0dLCAdhuLo/tN6zi656vzYTj5i5zrHUfdux6HJQop2AFsbHwjkXWZOYXxvVqnSsA==;5:au8zIcSqHcHUMfY1BIeZFFDxdoDXHNb1EKB6mBRaQUVOQVYTRzNfXTEqe65PZXg3OEKYIhr7LW8kJZwEXxk1qRJRNwkkDZHkMXQxBcEYtqY7sF/LMJP+kVrYt0FRmDjWyhhTfTZBpgFbucipE3QO55qpkQbkq13tkBvBIW2SJxlxCOvB+INXjHlRgdG9Z3f/GBpIf+m5KXF9gJJ/t12DUQ==;7:hN5Olxr1GFZCpDi6GMgnxybNFmzZrXHI9z2bJRy3xhCn2EWxpAPzkhcbqvHCweuNS03zwyIyV9RVRlwNvqzNREjOCUieDJmf4oiQ+PkjD2iGZEGC2hRHr+n8T+ic9tU4Gxa1MoVzDRBtPkuMLGd5Dw==
x-ms-office365-filtering-correlation-id: 2b1546c7-fc6b-4896-e2dc-08d68cef6fa4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2792;
x-ms-traffictypediagnostic: BYAPR11MB2792:
x-microsoft-antispam-prvs: <BYAPR11MB2792ADC6E1A6BAF9674875B2E3680@BYAPR11MB2792.namprd11.prod.outlook.com>
x-forefront-prvs: 0941B96580
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(346002)(366004)(376002)(39860400002)(189003)(199004)(2501003)(256004)(7736002)(68736007)(107886003)(81166006)(81156014)(305945005)(186003)(8676002)(8936002)(66066001)(50226002)(97736004)(52116002)(4326008)(86362001)(316002)(25786009)(476003)(2616005)(54906003)(478600001)(6486002)(105586002)(486006)(6916009)(106356001)(6436002)(14454004)(6512007)(53936002)(2906002)(2351001)(71200400001)(71190400001)(6116002)(3846002)(386003)(6506007)(36756003)(26005)(5640700003)(102836004)(99286004)(72206003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2792;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8Wx8+I3z0BBXgIoomapAhE5w6azjqXISDbTP4GAvE1Y8be3nkyimv8sADptXXdQXpnXDDTUkFK7hVyx9iDwmGgDaqVh+ljqS4wotcfNiWPTchK69vC0+unt7QA/PolgOzLR1ToncR3fIl1fCNANdqHUKv3/vQ/L3PazYburYQSNKJgZHrQAfJmfSJDZRYGwGPo2EdgA54i4OYHkXk+ac9r4xrYRgGO6cbdiTXW4R8F0rtf8ZNY0AMftrvTDRMZ/42QfSJiFn2lxtX5siLFedQsHgiTL24UdnIGQOZSlNbKjKAYUGo07NwKazJ82Wr8IDFTVkQFLVxr2vMpLp3J5lavK/TInv4NLMkn6OSWPKas5H4wRucXjs9NNWRo4mYNTRKTlcZGJKhyvoEwAk1MYvikC76VlsVTNSSsj5IWfe5F0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b1546c7-fc6b-4896-e2dc-08d68cef6fa4
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2019 11:28:49.4156
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2792
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

This series contains the following changes:
 - fix to set 'vif_num' value correctly.
 - use 'wilc_' prefix for variables and function names.
 - avoid use of unnecessary 'linux_' prefix from file names.

Changes since v1:
    - merged patch 1 & 2 and added modification as suggested by Dan.

Ajay Singh (8):
  staging: wilc1000: fix to set correct value for 'vif_num'
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
 .../wilc1000/{linux_wlan.c =3D> wilc_netdev.c}       |  26 +--
 drivers/staging/wilc1000/wilc_sdio.c               | 187 ++++++++++-------=
----
 drivers/staging/wilc1000/wilc_spi.c                |   4 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c  |  22 +--
 drivers/staging/wilc1000/wilc_wfi_netdevice.h      |   2 +-
 drivers/staging/wilc1000/wilc_wlan.c               |  13 +-
 drivers/staging/wilc1000/wilc_wlan.h               |  17 +-
 drivers/staging/wilc1000/wilc_wlan_cfg.c           |  12 +-
 drivers/staging/wilc1000/wilc_wlan_if.h            |  36 ----
 13 files changed, 190 insertions(+), 209 deletions(-)
 rename drivers/staging/wilc1000/{linux_mon.c =3D> wilc_mon.c} (100%)
 rename drivers/staging/wilc1000/{linux_wlan.c =3D> wilc_netdev.c} (97%)

--=20
2.7.4

