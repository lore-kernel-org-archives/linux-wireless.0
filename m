Return-Path: <SRS0=M3au=QJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED1F1C282D7
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Feb 2019 19:16:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAA412082C
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Feb 2019 19:16:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="de8Z8zGR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbfBBTQj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 2 Feb 2019 14:16:39 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:24907 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbfBBTQj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Feb 2019 14:16:39 -0500
X-IronPort-AV: E=Sophos;i="5.56,553,1539673200"; 
   d="scan'208";a="27205805"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 02 Feb 2019 12:16:38 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.49) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sat, 2 Feb 2019 12:16:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LaYFBUHW9A0N2Y4nzLJ3Z2kVW3Z82ICfB/k1wHX8slE=;
 b=de8Z8zGR0uv3mfSnNins2utgZ4Bvqiw2eUdmqYawiPJcAHT3lYMXXVG8ZGqHlyefNTClAd1EC3aCYx6KIHIxZY6R+VZguVACjW4ooauccudnzkeURBIBS+hMN5+ERwnWGvxAycD1D5EvOds9wlGpLJlMXS9v/7sxjRfTkmW1K1w=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2998.namprd11.prod.outlook.com (20.177.224.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.21; Sat, 2 Feb 2019 19:16:37 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1580.019; Sat, 2 Feb 2019
 19:16:36 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 00/15] staging: wilc1000: cleanup patches & handle review
 comments
Thread-Topic: [PATCH 00/15] staging: wilc1000: cleanup patches & handle review
 comments
Thread-Index: AQHUuyvRrd3rIuDjoUqQJnog/jU6Fw==
Date:   Sat, 2 Feb 2019 19:16:36 +0000
Message-ID: <1549134974-5545-1-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2998;6:JBSjx57R6N3ky7P6N7Rs7FWHWcgwz0I0KhWXQ1WM0SiFxwawjKb3fJrz7sLOzpoSC3ZOOQp4o6LbsUX91Hw3FgoPPQf47lPFRG6/L9nbq0OC/KBTr0r0MLW3ffNbpZJL3U5AHCBXsvOWXzj+KjYExp9TgZ0LxHMT0gmePEHFMbjN9CPubFIpQ5QmRrvs5m4ftcxCoDXza9zbYR5Pqx6ZsW3ZEbqbLcYKffj9yRWr+aH0d5uiZZ6iFgN3jtp5Y0R+R7l6aTO5xGOD7aRBwmwEo9dfww9mSDW9B73HzunQCC0ajqXJ/ywksSXY+/I75eBMtVb2+GtVlHn5AMpq9BBbMzfsipy1ITCunSLgqRSuiAN7n5dT4WOrhlOuJBSHY9V9gHL2DQXhDwE1zZ1+1GGor6dRSGW3dlwGdGyuV4W0TXKWZDuDrL8jzP+DOx5Z/CZnwxOQpBOqgSVKis+9x3NHMw==;5:z/dsnMnurE1t0hTiwZt0ZDe9bXvvlfC7aVPpottAqs/33+oIzdYE/zw/IRuTMKbxksx9fWInqhuDFXGdr4BWWr2Fq7B4VSTK4WrVo8pXn2wwt032L0WGyK64nis5NyKLcpMJbk0AH0v+n+f5CnGcQ9kaMIPu6KYa4hwGsmAtN92aynXhJEciCZ/zzYEVnCDB+ZVmEqqXSncovlRB1AzOCQ==;7:euDg8QxeuWCv/VDfeSToU86LbEOML0qlN4HcrhhIppWHZ0u196B7w6lYN7gbU7ER+zexcN9opS/REqps1KI53U1tvnj26O1Ou8RZX2j6xzaOWB1rnR0vWsbdnSnAgwyZs2PFqLxs0kv2E8lVStMkNQ==
x-ms-office365-filtering-correlation-id: 05790acf-313f-47f8-3e0b-08d68942f38d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2998;
x-ms-traffictypediagnostic: BYAPR11MB2998:
x-microsoft-antispam-prvs: <BYAPR11MB299838CB645F21BF77918F08E3930@BYAPR11MB2998.namprd11.prod.outlook.com>
x-forefront-prvs: 09368DB063
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(376002)(366004)(346002)(39850400004)(189003)(199004)(25786009)(107886003)(105586002)(78486014)(36756003)(50226002)(2501003)(6916009)(66066001)(8936002)(3846002)(4326008)(305945005)(7736002)(71200400001)(71190400001)(8676002)(6116002)(54906003)(81166006)(316002)(81156014)(6436002)(6486002)(2906002)(2616005)(486006)(476003)(256004)(99286004)(14444005)(52116002)(53936002)(72206003)(478600001)(186003)(386003)(26005)(14454004)(106356001)(86362001)(5640700003)(97736004)(2351001)(68736007)(6506007)(102836004)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2998;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Z8hHQ3PXDmwpYhQeKw4EOJFjH+iLogp35yg8MFXOEMBcPmSNyJ2qwsld5vtnLrRR+3TTOIIQRXsnw6zkXGlYZEfdekZfkmi17ewBd7TNHUpjAI09MhMcrqK5KiepuT66ub1S5gFDgljPCanFwBfcmdw6BKM4uYqcsa5tQpuQ7ltPb19sukY/UXSd5GEEQAs7Cn0zXaPU3aGHDr5UzuYZZen+tMnuQxrI/9GJHodfceUGMj+6dG6p6Qs+zfU1bJikuZhW0p0yULKj1sClefDMO0nkrmv1+I/ob605ESe43/7/88Uc69ktCYThpt2uoQrfvB1NfL68oybS5fRI92K9BKct4G+ODVC46FXAFSiz6afVdU+QuIBWI5I1E+Oxz5fOJFzWsHKZYTtkfJXxeSBK7hIrxMliVPy3CqeRx/BChVg=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 05790acf-313f-47f8-3e0b-08d68942f38d
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2019 19:16:34.3064
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

This series contains cleanup patches and modification to handle few mainlin=
e
review comments mentioned below:
 - avoid static variable for monitor net_device.
 - remove conditional locking in wilc_wfi_deinit_mon_interface().
 - avoid use of interface name('wlan0' & 'p2p0') string for validation.
 - use cookie information in roc related callback.

Ajay Singh (15):
  staging: wilc1000: avoid the use of 'wilc_wfi_mon' static variable
  staging: wilc1000: remove conditional lock in
    wilc_wfi_deinit_mon_interface()
  staging: wilc1000: remove redundant macros for radiotap
  staging: wilc1000: remove unnecessary debug log messages
  staging: wilc1000: rename timeout related macros
  staging: wilc1000: make use of iface type to identify p2p interface
  staging: wilc1000: refactor scan() cfg80211 ops callback
  staging: wilc1000: use correct condition in loops for 'vif_num' count
  staging: wilc1000: remove use of 'terminated_handle' static variable
  staging: wilc1000: refactor linux_wlan_init_test_config()
  staging: wilc1000: refactor code to use cookie information
  staging: wilc1000: use random number for cookie instead of pointer
  staging: wilc1000: avoid use of interface names for validation
  staging: wilc1000: add check before performing operation on net_device
  staging: wilc1000: remove unused struct 'add_sta_param'

 drivers/staging/wilc1000/host_interface.c         |  97 ++---
 drivers/staging/wilc1000/host_interface.h         |  27 +-
 drivers/staging/wilc1000/linux_mon.c              |  68 ++--
 drivers/staging/wilc1000/linux_wlan.c             | 408 +++++++++---------=
----
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 134 ++++---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h |   7 +-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |   3 +-
 drivers/staging/wilc1000/wilc_wlan.c              |   4 +-
 drivers/staging/wilc1000/wilc_wlan.h              |   2 +-
 drivers/staging/wilc1000/wilc_wlan_if.h           |   1 -
 10 files changed, 308 insertions(+), 443 deletions(-)

--=20
2.7.4

