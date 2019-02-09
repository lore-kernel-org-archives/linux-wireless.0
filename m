Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83F27C282C4
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 07:12:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3760920863
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 07:12:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="oBhdnxAC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbfBIHMK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Feb 2019 02:12:10 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:5689 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfBIHMK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Feb 2019 02:12:10 -0500
X-IronPort-AV: E=Sophos;i="5.56,564,1539673200"; 
   d="scan'208";a="24409313"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 09 Feb 2019 00:12:09 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.38) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sat, 9 Feb 2019 00:12:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=daU5h4aAF/pNzOG7AbzDsbQ/K4ucE9XZx75k7nVXXds=;
 b=oBhdnxACiSEApFAH62BknF1I4J8PSV980nuADIGyoBczZhUuaPpaiw7ILnN9MZWkdyEiS8JBHMwCQFWDqbMpybYv7vboOI/ljWc7qb5rvU/brSvXS84O782X61b+Dgp2Qit4DrclwqqC34EHMBBbatsFz5lI5GOUESrd+wJTyzo=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3128.namprd11.prod.outlook.com (20.177.227.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.21; Sat, 9 Feb 2019 07:12:05 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1601.016; Sat, 9 Feb 2019
 07:12:05 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <kvalo@codeaurora.org>,
        <johannes@sipsolutions.net>, <Adham.Abozaeid@microchip.com>,
        <Venkateswara.Kaja@microchip.com>, <Nicolas.Ferre@microchip.com>,
        <Claudiu.Beznea@microchip.com>, <Ajay.Kathat@microchip.com>
Subject: [PATCH 00/16] wilc1000: move out of staging
Thread-Topic: [PATCH 00/16] wilc1000: move out of staging
Thread-Index: AQHUwEbCCX3IcHjEkkah7YSVPvJ9TA==
Date:   Sat, 9 Feb 2019 07:12:04 +0000
Message-ID: <1549696298-9795-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR0101CA0021.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::31) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [183.82.17.42]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3128;6:/FzCp1kknUWFEW6gMPBfNuasa/3l09OW27y38iK/sC+5k4G9Wi40bqJQa1XTvj24obM3UF00juxR9cScveBArsTNGMC8A1kfGrXWhoXQepP2JQdHooJliZuNOXOoaTKZHZ+7LXkJKzo0PMKfDikVcyN59cpCfaiIig3uVCbJiV8DVoiltQZSwL/gfn3LRRUSlasAPcDgvVw7RJS28aHxv4WxB73MTNpgNSE5k8i3i8evhSabOOh7SYjmgrn/mfpw1eEWwnSIS0FFmymstZnWTpQgcob9pmzJgycRrM9uxlgETUSMOr8VMBHCvtO2gnqpco6UgC5FllZIGnv8P/+8ZSB45pME4pd6Wovg4hCxf2cBXB/TUCqj394QTemA+DSNHsNIcIRcSSnwXtJG3mcIrHKNteNqO9YzbBKAQeyeE6o5vRbn10+smjidLMEgeKoHSZa8WfBf6n3D/P0eLr/vpA==;5:f2qc1b0yHcpC7DG+/xeQWBi3BVjSE6U0P/0LNbuiNFWCdlGs0c6qGN+02QRsEusiKvMxPMmKOfCIRaF08lpkCsKeFw3TyxATIsdAhebTajDI1guDDIQUuetabs+HDaInfX3ksSjXElYZtWt3giHC4RxbxF0izTO3CGygE+q15wWy6gJR3o2sKjomKS/bAa2WOq5y8ugN21pa48NKcWI1iw==;7:3aOLpDv0qLtptGCScREnmoFhZU29gg/sbEq9HDuNoq95w3oCcx++2fcZhXa1Dx7nuJKZSB92H9hkxTNzBrN0pSFjjoegU2u7yDs6LpnZCUFlJqtaGY6YuwSE2Kn2PbkTIw7q/J1WqqzwKiz4dY3qIw==
x-ms-office365-filtering-correlation-id: 61bc0670-e0ae-4b28-de4f-08d68e5de502
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3128;
x-ms-traffictypediagnostic: BYAPR11MB3128:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <BYAPR11MB312866D64ABEF9B23FF688F5E36A0@BYAPR11MB3128.namprd11.prod.outlook.com>
x-forefront-prvs: 09435FCA72
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(376002)(39860400002)(366004)(346002)(189003)(199004)(78486014)(71200400001)(966005)(25786009)(14444005)(256004)(2906002)(14454004)(3846002)(71190400001)(86362001)(6116002)(316002)(486006)(72206003)(54906003)(53936002)(52116002)(305945005)(2501003)(2616005)(26005)(68736007)(6486002)(7736002)(66066001)(2351001)(4326008)(8936002)(6306002)(476003)(50226002)(81156014)(8676002)(81166006)(6512007)(97736004)(107886003)(478600001)(186003)(106356001)(6916009)(105586002)(6436002)(5640700003)(102836004)(36756003)(99286004)(386003)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3128;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: hPq1VoUKxm2S7lTiBp4yDwo/Xs6I8+efepLS0zGqrq8voWMA3TJJuH3i6TW1/FGc/bJcXgL9t7yvwJIfiq1LFZE+CqxjZhtdOJqQ35qfjxKQ2AXeEYBo/56+gjgG5G95gKTPfw5fiOyLNEec9M/wHuFwSJvILbdQ/EamXEMGDz389+WF4jubwY8SXiVevEq+KzOc+78yexG5fycJPcHBr1wJF8fgsDRQaE+zpll2KxWTvcHKnojlBs7Z8dhCTvZImBPXTQeA5fXLOxaUBiMMENKAnrOa79tzjFT2snkiidS7ltTJGw9SL1OtDGvsi9R5uL0/nO3H4rVBfKSMMTrLqXYjyziz6DW4KUG1XOyf9tUPnVG+WVGCkpgyNwKctk2r+s1yJ46CGP0zQEEBuXHm1W+6Eu63RXawG1h69erbOiI=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 61bc0670-e0ae-4b28-de4f-08d68e5de502
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2019 07:12:01.4986
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3128
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

This patch series is to review and move wilc1000 driver out of staging.
Implemented the initial received review comments[1] and submitting the
driver again. During this cleanup deleted around 3.3k lines of code.

Below are the major items fixed in recent cleanup:
 - remove use of shadow buffer to keep scan result.
 - remove internal messaging flow to handle cfg80211_ops.
 - make use of cfg80211 provided API.
 - use structure for packing firmware commands.
 - make use of kernel provided API and macros.
 - remove unnecessary logs messages.

Pending action item:
 - dynamically add/remove p2p interface.

 This item will take some time, we are planning to take it up after
 mainline.

 We hope it can be move out staging in v5.1.
 Please review and confirm if it is good to move out.

[1]. https://www.spinics.net/lists/linux-wireless/msg177877.html

Ajay Singh (16):
  wilc1000: add host_interface.h
  wilc1000: add host_interface.c
  wilc1000: add wilc_wlan_if.h
  wilc1000: add wilc_wlan_cfg.h
  wilc1000: add wilc_wlan_cfg.c
  wilc1000: add wilc_wfi_netdevice.h
  wilc1000: add wilc_wfi_cfgoperations.h
  wilc1000: add wilc_wfi_cfgoperations.c
  wilc1000: add wilc_netdev.c
  wilc1000: add wilc_mon.c
  wilc1000: add wilc_spi.c
  wilc1000: add wilc_wlan.c
  wilc1000: add wilc_wlan.h
  wilc1000: add wilc_sdio.c
  wilc1000: updated DT device binding for wilc1000 device
  wilc1000: add Makefile and Kconfig files for wilc1000 compilation

 .../net/wireless}/microchip,wilc1000,sdio.txt      |    0
 .../net/wireless}/microchip,wilc1000,spi.txt       |    0
 drivers/net/wireless/Kconfig                       |    1 +
 drivers/net/wireless/Makefile                      |    1 +
 drivers/net/wireless/microchip/Kconfig             |   14 +
 drivers/net/wireless/microchip/Makefile            |    2 +
 drivers/net/wireless/microchip/wilc1000/Kconfig    |   42 +
 drivers/net/wireless/microchip/wilc1000/Makefile   |   14 +
 .../wireless/microchip/wilc1000/host_interface.c   | 2152 ++++++++++++++++=
++++
 .../wireless/microchip/wilc1000/host_interface.h   |  247 +++
 drivers/net/wireless/microchip/wilc1000/wilc_mon.c |  258 +++
 .../net/wireless/microchip/wilc1000/wilc_netdev.c  | 1079 ++++++++++
 .../net/wireless/microchip/wilc1000/wilc_sdio.c    | 1140 +++++++++++
 drivers/net/wireless/microchip/wilc1000/wilc_spi.c | 1136 +++++++++++
 .../microchip/wilc1000/wilc_wfi_cfgoperations.c    | 1878 ++++++++++++++++=
+
 .../microchip/wilc1000/wilc_wfi_cfgoperations.h    |   24 +
 .../microchip/wilc1000/wilc_wfi_netdevice.h        |  292 +++
 .../net/wireless/microchip/wilc1000/wilc_wlan.c    | 1346 ++++++++++++
 .../net/wireless/microchip/wilc1000/wilc_wlan.h    |  313 +++
 .../wireless/microchip/wilc1000/wilc_wlan_cfg.c    |  495 +++++
 .../wireless/microchip/wilc1000/wilc_wlan_cfg.h    |   54 +
 .../net/wireless/microchip/wilc1000/wilc_wlan_if.h |  803 ++++++++
 drivers/staging/Kconfig                            |    2 -
 drivers/staging/Makefile                           |    1 -
 24 files changed, 11291 insertions(+), 3 deletions(-)
 rename {drivers/staging/wilc1000 =3D> Documentation/devicetree/bindings/ne=
t/wireless}/microchip,wilc1000,sdio.txt (100%)
 rename {drivers/staging/wilc1000 =3D> Documentation/devicetree/bindings/ne=
t/wireless}/microchip,wilc1000,spi.txt (100%)
 create mode 100644 drivers/net/wireless/microchip/Kconfig
 create mode 100644 drivers/net/wireless/microchip/Makefile
 create mode 100644 drivers/net/wireless/microchip/wilc1000/Kconfig
 create mode 100644 drivers/net/wireless/microchip/wilc1000/Makefile
 create mode 100644 drivers/net/wireless/microchip/wilc1000/host_interface.=
c
 create mode 100644 drivers/net/wireless/microchip/wilc1000/host_interface.=
h
 create mode 100644 drivers/net/wireless/microchip/wilc1000/wilc_mon.c
 create mode 100644 drivers/net/wireless/microchip/wilc1000/wilc_netdev.c
 create mode 100644 drivers/net/wireless/microchip/wilc1000/wilc_sdio.c
 create mode 100644 drivers/net/wireless/microchip/wilc1000/wilc_spi.c
 create mode 100644 drivers/net/wireless/microchip/wilc1000/wilc_wfi_cfgope=
rations.c
 create mode 100644 drivers/net/wireless/microchip/wilc1000/wilc_wfi_cfgope=
rations.h
 create mode 100644 drivers/net/wireless/microchip/wilc1000/wilc_wfi_netdev=
ice.h
 create mode 100644 drivers/net/wireless/microchip/wilc1000/wilc_wlan.c
 create mode 100644 drivers/net/wireless/microchip/wilc1000/wilc_wlan.h
 create mode 100644 drivers/net/wireless/microchip/wilc1000/wilc_wlan_cfg.c
 create mode 100644 drivers/net/wireless/microchip/wilc1000/wilc_wlan_cfg.h
 create mode 100644 drivers/net/wireless/microchip/wilc1000/wilc_wlan_if.h

--=20
2.7.4

