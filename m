Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09887C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 05:45:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F45C2175B
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 05:45:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="VoEOwjtQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F45C2175B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731043AbeKLPgm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 10:36:42 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:41844 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728269AbeKLPgl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 10:36:41 -0500
X-IronPort-AV: E=Sophos;i="5.54,494,1534834800"; 
   d="scan'208";a="20255098"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 11 Nov 2018 22:45:02 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.105) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 11 Nov 2018 22:45:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ka514A9z5Io9ERYWU5x8w6OUOfWBrwLFuk6v6zMl2Lg=;
 b=VoEOwjtQbWKQuBBNui0LmpBw5DBNkuzCUVve7eZiAeOH2v6L5UJ7gc9UQfd9K4TaHqtGjpcaGQ5IL6QVbywtlS8asHTvA808EJaAC+j4UHXukm7HOm6b/mJsIj0pOKrcVnEKPsiQRWuuRSqGJJqWYADL2ypt6WVptuB2pd6TjFo=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2599.namprd11.prod.outlook.com (52.135.227.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.21; Mon, 12 Nov 2018 05:45:00 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7%6]) with mapi id 15.20.1294.044; Mon, 12 Nov 2018
 05:45:00 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 00/12] staging: wilc1000: better namespace for constants and
 cleanup
Thread-Topic: [PATCH 00/12] staging: wilc1000: better namespace for constants
 and cleanup
Thread-Index: AQHUekrZWxUe6TewnEursZcLiYfAhg==
Date:   Mon, 12 Nov 2018 05:45:00 +0000
Message-ID: <1542001458-20217-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR01CA0135.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:35::29) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [27.59.94.109]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2599;6:6J8lxlaaViRUDO9VnepbKdW/AbFug2y0OMJgNPQFEO8lepaWIddJgNJ1GYh+OAML7QOtix7K3IGaQPEkIjDBv+w5lx/g1cUBXQUiwS1mx8IxqYXSsEtDEL7Omi9U64QWV0aL25p7X7WPi3hl8UD1PO+hvmH/BMrzfwWeHA+wpWWwRbxDkpxCN7Lo6axKGHLwJZi+Dt32hhtfKFk8zp6r8YzWckgosOpm69QVsc4lRnY7RkYMEIPEkfrCve+fgiFmOtwskqWI8yhAh7kBgO9E3O+ATUr4ivlUm9JVXIdqHG7NkghTG+TiHj2k/SoXo03Wfc+jPfdaw56pYWDNZ5Z5N288Wij14gDmOaczbFrBbsUeEhMHGIf4UFsl22ExvuGXU6nFZqzGWjbu1kcEgLyoZgB9vjnYhLNZuPw+ZX38on2AFADBD+xvRfromTlrBJ6TTs7xpVmgeZMMjpnYC5CluA==;5:LT811b2PjHFH/hClh+hZHGrTsZRbZ2RTvP5mH4g3UPp5MTvemlNBC7j2f3GIFO4cTUCin8aeoG7L+/s0a97Nxj9i6MiVhqWpESwbHzwOGWeK5e3/z+j6T/bsJjXSH38OU6fvrdq/kF27fvb9XgydbEF2AmospHeeSblVKdXtw+g=;7:m2OuaF4PofLuAVG20HzSKWSv9Cr9W7jUloIwvVprCrdBUww/gQTn9sQqRD/u/9b/cgcpi6pYBDaIRU+ysZrO/0h35JhhH8BLpOKQGg00d0ZQvzjZtHrGJVOo8c2tANeyUqRz/HDZiYgo7q6QwdeW3A==
x-ms-office365-filtering-correlation-id: 0afddfc7-5b8c-433a-ff4e-08d64861fc2b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390040)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2599;
x-ms-traffictypediagnostic: BYAPR11MB2599:
x-microsoft-antispam-prvs: <BYAPR11MB25993DC1D792A10E8E0D5882E3C10@BYAPR11MB2599.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(192374486261705);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3002001)(3231402)(944501410)(52105112)(10201501046)(93006095)(93001095)(148016)(149066)(150057)(6041310)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123562045)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB2599;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2599;
x-forefront-prvs: 0854128AF0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(136003)(366004)(39860400002)(189003)(199004)(4326008)(25786009)(2906002)(6116002)(3846002)(72206003)(26005)(2351001)(14454004)(86362001)(186003)(6436002)(478600001)(966005)(6486002)(105586002)(106356001)(2501003)(107886003)(5640700003)(6306002)(54906003)(52116002)(99286004)(102836004)(53936002)(14444005)(256004)(6506007)(386003)(316002)(36756003)(486006)(8936002)(6916009)(7736002)(305945005)(476003)(2616005)(68736007)(8676002)(71200400001)(97736004)(5660300001)(66066001)(81156014)(81166006)(6512007)(71190400001)(2900100001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2599;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: nNEMHLix5DS2R5RoFVyk7U5TPmDMYcd+ApZOM3DI3YoCbNMSenMN7sb6FTF4Y/vLOwID2+EWAJOyBe6NWLkc894izFb0h5M70TCIV/IifSYKMZ5UX4O81WzQYfgUCMnyldt1G0HvnzQLMi4ujThQh8jDJQOaaaxQzlRL3IQakyrKnr9Jk1URUnJzCLpe123jeo9q2dAuxA4vnhZ6IvV69/ZTiTqonEXC1XiYihPKlCT+lKp20wI56NNWVj9XG0mu8HqzLNI2TZCayfR4pF4WGADNeNl6RuOm+k1ZcNJ/UKWNa1t6Uo9cOloC3bj2K9yWM6wzjYlUfZ8fmpBuTCcG9lRa1ZSorJUvMcbWhpfXPKM=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0afddfc7-5b8c-433a-ff4e-08d64861fc2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2018 05:45:00.2855
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2599
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

This patch series contains changes to address the review feedback
comments [1]. It mainly contains the changes to have clear names for
the constants. Most of the constants names are taken care, few are left
unchanged in hope with another cleanup those macros might be deleted. After
further cleanup will revisit if anything else is required to address this.

[1]. - https://www.spinics.net/lists/linux-wireless/msg178706.html
     - https://www.spinics.net/lists/linux-wireless/msg178704.html

Ajay Singh (12):
  staging: wilc1000: use macro from ieee80211.h in register frame api's
  staging: wilc1000: use WLAN_PMKID_LEN macro from ieee80211.h header
  staging: wilc1000: remove unused macros and struct members in
    host_interface.h
  staging: wilc1000: move sdio_cmd52 & sdio_cmd53 struct to source file
  staging: wilc1000: use enum contants for mac status & added 'WILC_'
    prefix
  staging: wilc1000: restructure macros used to handle security type
  staging: wilc1000: use proper namespace for macros in wilc_wlan_if.h
    header
  staging: wilc1000: move current_tx_rate enum to wilc_wlan_if.h file
  staging: wilc1000: rename firmware related constants to follow better
    namespace
  staging: wilc1000: added 'WILC_' prefix for constants to have clear
    namespace
  staging: wilc1000: use ENOBUFS error code instead of
    WILC_TX_ERR_NO_BUF macro
  staging: wilc1000: rename tsf_hi element of network_info struct

 drivers/staging/wilc1000/host_interface.c         | 203 ++++++++++--------=
---
 drivers/staging/wilc1000/host_interface.h         | 100 ++++------
 drivers/staging/wilc1000/linux_wlan.c             |  62 ++++---
 drivers/staging/wilc1000/wilc_sdio.c              |  22 ++-
 drivers/staging/wilc1000/wilc_spi.c               |   2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 133 +++++++-------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |   9 +-
 drivers/staging/wilc1000/wilc_wlan.c              |  94 +++++-----
 drivers/staging/wilc1000/wilc_wlan_if.h           | 212 ++++++++++++------=
----
 9 files changed, 421 insertions(+), 416 deletions(-)

--=20
2.7.4

