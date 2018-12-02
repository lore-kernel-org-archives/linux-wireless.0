Return-Path: <SRS0=9n1M=OL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2B95C04EB8
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:02:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FB472082F
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:02:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5FB472082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725710AbeLBSCS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Dec 2018 13:02:18 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:54426 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbeLBSCS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Dec 2018 13:02:18 -0500
X-IronPort-AV: E=Sophos;i="5.56,307,1539673200"; 
   d="scan'208";a="21782535"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 02 Dec 2018 11:02:17 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.106) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 2 Dec 2018 11:02:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yxWdgnI6QUHddws8SV7tfannLfjJhuZxe/lzQ+uy3SY=;
 b=vaC7DLg8sqkzEaaSkkSGP6qdZ+/3SiSeVq0Q1R8H1s57UYnKOsPQLNtQHYfms3Y5C6A85yYFYXDaDol6s6rJXExY8o/jh67NpJuSg/hlD2bYl7Amr1EOVqBJK4bx8oZjkdbySxStY5SiECaPRqgeLzM1/GoqrcJFbX3IKRfG3Gw=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3334.namprd11.prod.outlook.com (20.177.185.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.19; Sun, 2 Dec 2018 18:02:14 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f%4]) with mapi id 15.20.1382.020; Sun, 2 Dec 2018
 18:02:14 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 00/29] staging: wilc1000: avoid deferring of cfg80211
 operation callback
Thread-Topic: [PATCH 00/29] staging: wilc1000: avoid deferring of cfg80211
 operation callback
Thread-Index: AQHUimknRvrmCW2dvUKt8aPwpsQxOg==
Date:   Sun, 2 Dec 2018 18:02:13 +0000
Message-ID: <1543773663-20561-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR0101CA0063.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::25) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [183.82.18.98]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3334;6:GYk6FOfOsokvZx8zv9fT6vzwV0mXhKzXqRwY8HzckAdvCW1BxSQIR6NncWmUk9DyJshLP1e2bGSzyjP5eIBLt4z8UbzNpF3NrkIxb6OWRCCWF8kQwPsyK+sRDHuQpa99lUl6aE7Tp6Nl2jSh7v5KLX+f47ph6b6OVx5Inexcktt9U5BZYr/z3kem5KREFpAxI2y1QEzenoZlB4Y4/8pHQvZpeo5ci4LlWxO4sZCwNV4nAEyzt3V4JpnDkQIpPfI3QSMiqA58qC+p2ESZx+MCLjal9e9Sk6kIGwjEquzzm9vPN0+4HRIZhhazQgw80m7yPEIZlS1k5NLzuM+HLEUGslDN1VbqsgYsCSVLvAQ4H3iIUePAHPVd3CkatZyhtL1NsvKF7zMIVWGJXEupo2LBsguNb3BerPRIs09wF4QxCVPlXJdcwi1JP/Qc15LroIPr/JN12FUKVTqhphXhod6P0w==;5:RP3ooN60U+HoJXojRu7Ly8hQWhA3pqB7mZrGXk1wjn8EqoWu3qtq93Y4D/uFQO4HJE+WlrYJ+goC5TtBJuI6ZY0HMIg7V/5fIu3KXuYQkM+rmoWBv15L+OFiORrMmLTXqbIvoQQ3ySaqPp3HRD3srtEEVgCC8LhPQC1W67CdtE0=;7:GMq2rCmGzjS0b5Lyd1AqEfmbEIXQspWKiPBvFo6ToxKJnRAqX7jdZB6vdmt/Y0hghG6/YXpx2M3pcqCsoysNgVrdGQ7Ws89fqE1+aWgUDb/z06mvfXXSDUBaXsVfzeDBtYWk7L5sGypd+RMmJ3b31g==
x-ms-office365-filtering-correlation-id: 89a82c0c-ec0d-41f2-49ba-08d6588049cc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3334;
x-ms-traffictypediagnostic: BYAPR11MB3334:
x-microsoft-antispam-prvs: <BYAPR11MB3334A39568C805B2D574AF31E3AD0@BYAPR11MB3334.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(10201501046)(3002001)(3231455)(999002)(944501491)(52105112)(93006095)(93001095)(148016)(149066)(150057)(6041310)(20161123558120)(20161123564045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB3334;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB3334;
x-forefront-prvs: 087474FBFA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(366004)(376002)(396003)(39850400004)(199004)(189003)(107886003)(6916009)(386003)(5660300001)(5640700003)(4326008)(6506007)(78486014)(2906002)(6306002)(6512007)(53936002)(54906003)(3846002)(6116002)(2351001)(81166006)(316002)(81156014)(52116002)(8676002)(26005)(8936002)(256004)(14444005)(6436002)(97736004)(106356001)(99286004)(486006)(6486002)(68736007)(105586002)(14454004)(478600001)(2616005)(7736002)(66066001)(36756003)(966005)(305945005)(72206003)(186003)(2501003)(86362001)(102836004)(476003)(71190400001)(25786009)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3334;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: DcKaL6YSx0vbOQCbKvFxaivx7blwErppUYxKypnoK1l69FoM+kbXymNpuKYhglc1g8HKdP+RjcWCBA8v72twDuU2pJ+FTWLcAH0u+BheVOeCgM6pWW5/tVlcWLeuTk73UcEITmMtKdeQcF47rRVLg+IuOg8tNuf/nLC3LS8ZYXWWPVgnBlr3vBZ5haTKEvE1SWW2Gyd+EkhywIkWgNwvvTpEPphujgVZDhIAF5E2GMmMd7d/nfoxZNyOZIYs7d59Pue1t2mh7M9FIvBsqty/A99Ixudrhqgi1Wf+MCW1+z85n9GEXbJ56nvMH4WLyN5SI5VHVABb/Y4KeMGQefGQOowu/rAZb6XPEb6bkNt1BGI=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 89a82c0c-ec0d-41f2-49ba-08d6588049cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2018 18:02:13.9549
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3334
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

This patch series mainly contains the change to handle the cfg80211
operation from its context. Now the WID commands are sent to firmware
directly from the caller context.
Also added few more patches to address the review comment received
earlier in series[1].

[1]. https://www.spinics.net/lists/linux-wireless/msg178705.html
     https://www.spinics.net/lists/linux-wireless/msg178707.html
     https://www.spinics.net/lists/linux-wireless/msg178709.html

Ajay Singh (29):
  staging: wilc1000: remove unnecessary checks in wilc_mac_close()
  staging: wilc1000: make use of put_unaligned_le32 in
    handle_set_wfi_drv_handler()
  staging: wilc1000: avoid the use of the static variable to configure
    wiphy struct
  staging: wilc1000: use mutex lock to synchronized sending 'wid' cmd to
    firmware
  staging: wilc1000: handle tx power related callback from cfg80211
    context
  staging: wilc1000: handle setting power management from cfg80211
    context
  staging: wilc1000: handle add and edit station from the cfg80211
    context
  staging: wilc1000: use void return for wilc_hif_pack_sta_param()
  staging: wilc1000: handle delete station related callback ops from
    cfg80211 context
  staging: wilc1000: use is_zero_ether_addr() API to check mac address
  staging: wilc1000: handle delete beacon cfg ops from cfg80211
    context()
  staging: wilc1000: handle add beacon operation callback from cfg80211
    context
  staging: wilc1000: handle mgmt_frame_register ops from cfg82011
    context
  staging: wilc1000: refactor wilc_set_mac_chnl_num() to avoid deferred
    handling
  staging: wilc1000: refactor wilc_hif_set_cfg() to avoid deferred
    handling
  staging: wilc1000: handle station dump cfg ops from cfg80211 context
  staging: wilc1000: refactor wilc_set_operation_mode() to avoid
    deferred handling
  staging: wilc1000: refactor wilc_set_wfi_drv_handler() to avoid
    deferred handling
  staging: wilc1000: refactor wilc_get_inactive_time() to avoid deferred
    handling
  staging: wilc1000: handle key related cfg operation from cfg80211
    context
  staging: wilc1000: delete the unused code after code refactor
  staging: wilc1000: refactor wilc_get_mac_address() to avoid deferred
    handling
  staging: wilc1000: use correct 'struct remain_ch' variable in scan
    complete
  staging: wilc1000: handle remain on channel cfg ops from cfg80211
    context
  staging: wilc1000: handle get_station() ops callback in cfg80211
    context
  staging: wilc1000: avoid deferred handling of cfg80211 disconnect
    callback
  staging: wilc1000: handle connect ops callback from cfg80211 context
  staging: wilc1000: avoid extra buffer copy while connect cfg ops
  staging: wilc1000: handle scan operation callback from cfg80211
    context

 drivers/staging/wilc1000/host_interface.c         | 2405 ++++++-----------=
----
 drivers/staging/wilc1000/host_interface.h         |   79 +-
 drivers/staging/wilc1000/linux_wlan.c             |   30 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  167 +-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |   65 +-
 drivers/staging/wilc1000/wilc_wlan.c              |   21 +-
 6 files changed, 755 insertions(+), 2012 deletions(-)

--=20
2.7.4

