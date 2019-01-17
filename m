Return-Path: <SRS0=z7UY=PZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7225C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:21:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9152A20652
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:21:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="vUnE3idw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbfAQNVL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jan 2019 08:21:11 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:40711 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727131AbfAQNVL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jan 2019 08:21:11 -0500
X-IronPort-AV: E=Sophos;i="5.56,489,1539673200"; 
   d="scan'208";a="23513309"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 17 Jan 2019 06:21:11 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.38) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 17 Jan 2019 06:21:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3q7wh8GCDFj2LhiBAPehzjHmyad4akmF9qbDD32EJoY=;
 b=vUnE3idw/URCzSsH4ulxlf+rgmbUQsjdnWBh1bbVUQA4BtZ2jtNtqj8nZVQsvzdjjGdfjSiqS5gLDPk2LEVLIjSXky7PUWSzZK1lVxa6l6xGhm9pUrk6PFfqK6YnU/9mH+t+HemBW02qi4dg0DN8m0cyfQTEXKqIMmErmVe6Vu0=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3464.namprd11.prod.outlook.com (20.177.187.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.26; Thu, 17 Jan 2019 13:21:06 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::c110:8559:a438:491d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::c110:8559:a438:491d%3]) with mapi id 15.20.1516.019; Thu, 17 Jan 2019
 13:21:06 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 00/13] staging: wilc1000: address few mainline review
Thread-Topic: [PATCH 00/13] staging: wilc1000: address few mainline review
Thread-Index: AQHUrmeAwjrrFTYIG0Knnqi3W6iolA==
Date:   Thu, 17 Jan 2019 13:21:06 +0000
Message-ID: <1547731250-18518-1-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3464;6:As7xj0SR/G5Ba2MTPhh2JkBvIYh+EuXSgj4za0oUT1vNqRmXi5MfsWSOU/8+YVLnw+RV7RUnBnVYH4vVeLls0Gm5wE7EKTt7fSnpinbT/Q4sNpXk2R7Hl/g3j4K3/TjM5UF6XWLNrGySCpo13ZGdrlFq89RElSBcYn5qxEIzUi581ZpOQGWBtSmk/Xx9K4jBy9oxMlcdxoB0hRKyN3Hc07AXckq1EGgK4ISb65otkeFYLf8j4ncegAKiayjPaFqLROi65EvgYBEjTAIULIPEPSnLxBlfFzuLP8bA0g+jq2QVgURws0OKDiw885K95VKzgvVjxqIp3LFnFLq2NKN04iWcDB1+p0B1ZAsMG1f2xRd/taJQ7ZlOhz6tCnsKnIqNjDM9+wgeRH+nx63LofaUQ1MxffwzhXsCkkYers6jcQOFEIhMRlN18LWTxAfihYLANRTNl9hHm79pXS2EKU2dYg==;5:lVtfwjn1+D73GbsIUHr0lxAfabkOBV9xY0sUzmCTkOKjxgUDkpZEtiw7jkVtU/HxuOH5ORti9UKhO7SC/SlEVV3ZhYgEuK747A42G9y0LtFH/0zHHVzNCsjLCveLZC1RnwjA404NSbolE7XNC5X0ynLDaIkNtRw/GDAgTP+Ut34swkJRSI6vT0ousy0NZwHJqH8EvS8Eal2lBN6EJa1eKg==;7:L5fB2r3/oV8ULWY4YYAZ5xx6MojtdflOfE8WwboPNDS/jcsKRXqA6e9abyT/671YkG+ptjTNEUlg0HrC37XaCw6fFPGukBMQ28bARGiJID0op8iEbai7Zv7bx18mPm/OXdxd2dDe50wfk1F2/LSzsA==
x-ms-office365-filtering-correlation-id: 8293e5c8-b83a-4b53-3d6a-08d67c7ea330
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3464;
x-ms-traffictypediagnostic: BYAPR11MB3464:
x-microsoft-antispam-prvs: <BYAPR11MB34646367A4D1AA1F75D7A54CE3830@BYAPR11MB3464.namprd11.prod.outlook.com>
x-forefront-prvs: 0920602B08
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(136003)(39860400002)(376002)(396003)(199004)(189003)(14454004)(68736007)(966005)(81166006)(81156014)(5660300001)(8936002)(2906002)(106356001)(8676002)(26005)(305945005)(7736002)(6486002)(6436002)(5640700003)(36756003)(86362001)(99286004)(478600001)(6916009)(50226002)(72206003)(78486014)(2501003)(66066001)(4326008)(97736004)(486006)(25786009)(6506007)(476003)(102836004)(14444005)(256004)(386003)(53936002)(2616005)(54906003)(6512007)(71190400001)(71200400001)(105586002)(107886003)(3846002)(52116002)(186003)(2351001)(6116002)(316002)(6306002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3464;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: OpjSnTJADTYorZHWu0rajHMWWjWJPqXk77Br91ABCaMZSQCygG7UO5h9F9VL3z1dVrzt8qS9cDSnLMKouyOUgKc73Qsm/AjK/u999vsLW9CYJwoTLkI4Z+Cu2lDLFspMrUdNZjyz+YpukjFhSi8RdXFb/6SKU2zwbjxOZpogNBgHqyytVPvjDR26OiI2EuoI9KdHnx2zCk6qqIa4HihwUf/7OgIOW9sogcbL2ep1bufHeUy+586eq4RWwctLkv69GKNK9lYFrw7/4y1hJ+U69G6DuB/4W4nXYSsg3fRx51ByeLJrqrSoO4Vbjfnx6JfgpHAA0oBclSXamki1brxdl137szyLXVeuIMPTxrN9IbD4HWf9ejGpYEiSLUPWEHyQ0o6GWV0y05G7vQu4YFRsOgYlchAkZIuAfXpuzi+bdeQ=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8293e5c8-b83a-4b53-3d6a-08d67c7ea330
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2019 13:21:04.2569
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

This series contains changes to address few of the review comments[1].
It mainly has the modification to remove the use of scan shadow
buffer, make use of kernel provided API, avoid typedef's and few
changes to simplify the logic.

[1]. https://www.spinics.net/lists/linux-wireless/msg178735.html
     https://www.spinics.net/lists/linux-wireless/msg179533.html
     https://www.spinics.net/lists/linux-wireless/msg178760.html

Ajay Singh (13):
  staging: wilc1000: make use of get_unaligned_le16/le32 to pack data
  staging: wilc1000: refactor wilc_wlan_set_bssid()
  staging: wilc1000: use 'struct' to pack cfg header frame in
    wilc_wlan_cfg_commit()
  staging: wilc1000: remove the use of scan shadow buffer
  staging: wilc1000: make use of cfg80211_inform_bss_frame()
  staging: wilc1000: corrected order to pack join param buffer
  staging: wilc1000: use struct to pack join parameters for FW
  staging: wilc1000: rename hidden_network related data structure
  staging: wilc1000: use single struct for 'connect' related parameters
  staging: wilc1000: refactor information message parsing logic
  staging: wilc1000: remove 'disconnect_info' structure
  staging: wilc1000: refactor handle_set_mcast_filter()
  staging: wilc1000: avoid the use of typedef for function pointers

 drivers/staging/wilc1000/host_interface.c         | 979 +++++++-----------=
----
 drivers/staging/wilc1000/host_interface.h         | 127 +--
 drivers/staging/wilc1000/linux_wlan.c             |  12 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 450 ++--------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |   5 +-
 drivers/staging/wilc1000/wilc_wlan.c              |  35 +-
 drivers/staging/wilc1000/wilc_wlan.h              |  19 +-
 drivers/staging/wilc1000/wilc_wlan_cfg.c          |  27 +-
 drivers/staging/wilc1000/wilc_wlan_if.h           |   3 -
 9 files changed, 456 insertions(+), 1201 deletions(-)

--=20
2.7.4

