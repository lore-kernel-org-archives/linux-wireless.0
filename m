Return-Path: <SRS0=xBvi=PW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDF62C43387
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 09:40:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A8F020659
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 09:40:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="bWkGpjHU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfANJkX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 14 Jan 2019 04:40:23 -0500
Received: from mail-eopbgr690068.outbound.protection.outlook.com ([40.107.69.68]:13440
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726064AbfANJkX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Jan 2019 04:40:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xX1xJi3qmdxUua26eRaZPD5cwKS4xVy8dCVrfiH9J4k=;
 b=bWkGpjHUa2efb7X+Pw+3L2A0Q++VuiPT+pznrAg1hIxLQpAwjmD0JjgXl1JwuKeGCby6EkHwwRrt8e36mkvvDC0Qj93MC1nMIcVDEK/HhcOJS1Y/DUUn6frncxReHiyZMNBNAQJ2hZon/oycdARb6jNgfc5WYdO7gblXASBFqi8=
Received: from BN6PR05MB3316.namprd05.prod.outlook.com (10.174.95.138) by
 BN6PR05MB3604.namprd05.prod.outlook.com (10.174.235.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.10; Mon, 14 Jan 2019 09:40:13 +0000
Received: from BN6PR05MB3316.namprd05.prod.outlook.com
 ([fe80::209d:29a3:d7d:71bb]) by BN6PR05MB3316.namprd05.prod.outlook.com
 ([fe80::209d:29a3:d7d:71bb%3]) with mapi id 15.20.1537.018; Mon, 14 Jan 2019
 09:40:13 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB5838.namprd05.prod.outlook.com (20.177.255.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.17; Mon, 14 Jan 2019 09:39:33 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5%6]) with mapi id 15.20.1537.018; Mon, 14 Jan 2019
 09:39:33 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH v2 0/7] qtnfmac: fixes and minor enhancements
Thread-Topic: [PATCH v2 0/7] qtnfmac: fixes and minor enhancements
Thread-Index: AQHUq+0OCsXkApKeRUGf6CO5zHNAIQ==
Date:   Mon, 14 Jan 2019 09:39:33 +0000
Message-ID: <20190114093925.9061-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0070.namprd05.prod.outlook.com
 (2603:10b6:a03:74::47) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BN6PR05MB3604;6:xeNdrGiB5dPUWONWd0xLoOm4lgUAFpluKOBO6bd2P3VymqdLO6azwzhCaIymLMr//p/ypM1aOtnTA6AScITNSTThg1VY3bsDhZ23X2EyvhZwhuuuo3WiZgaRARoN/8ADLkyn6AjFzZbytQP9+2n0Fqw2+7MSL6k3tQKGvMNmj2y5PL585e7Q0W4kWxprcmj+87A0+Oi9FIxfm6ij3lNQvtgASKQlKYmH40TNEWJTaC/FPlVPL7orNX6K/wPmPMEfCysWo8OE8CHAHn7pPvCXEpVky5sUROQ6cphRRVG+QhtIsOVqIkSWoqQLnnLFaZS/aGUr+aA7ng1b9+xzq23DgfaSSkeArIt5ShVvdmDaWffWOvYSThz+rUWhzjq9EES0UOLBYPSFoifnjfB19IdYoHZR/S4nHUvK8I9sdSo4XZxG+t58mBX3AudgTTofi6BbsSjSBcvNVjq7+ykw0lBOyQ==;5:D7ajyF61ZVYUBtQa4sELZSujxsytSmgsIRtpBmD3ph/E+Ry8APqjEajX8wP0ahodL+DoYQZ1EiZA7Q6C3kYU6AsBwB07blNTQZBuKJb5RsX59TwwWsUoPmlbGNDfXgtA5seO3onA2OxRUqnqYhcnD7+nnc47teD7UUar2Nbdw7p1v7MBN7hbsL4tMmElFCxt/rZ0z5YLPc0uYEtmDOrpuw==;7:PboVVMnNIyMGTJamzl6kpCqcsMWfDDSRX+VMGMNAXH5Di6SIIz7BVNBx+vSV2Pa1WwzZaS4DjK8JvcuWyDqFwDk8f/+CuHCqLNCTqXRD2MNDu2VRrrO7XLSSe9TGd8NcCetd8a1WNQQeyeA4M3ChFA==
x-ms-office365-filtering-correlation-id: 5f6aff35-d1e2-46db-3ace-08d67a04301b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB5838;
x-ms-traffictypediagnostic: SN6PR05MB5838:|BN6PR05MB3604:
x-moderation-data: 1/14/2019 9:40:11 AM
x-microsoft-antispam-prvs: <BN6PR05MB3604141A4C2E3361744EF52EA3800@BN6PR05MB3604.namprd05.prod.outlook.com>
x-forefront-prvs: 0917DFAC67
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39840400004)(396003)(346002)(136003)(376002)(366004)(189003)(199004)(256004)(14444005)(2501003)(1076003)(3846002)(6512007)(81156014)(6486002)(81166006)(5640700003)(106356001)(2351001)(6116002)(26005)(107886003)(316002)(53936002)(97736004)(8936002)(2906002)(8676002)(6436002)(71200400001)(103116003)(2616005)(386003)(7736002)(71190400001)(52116002)(68736007)(25786009)(4326008)(305945005)(6506007)(99286004)(486006)(54906003)(476003)(186003)(478600001)(6916009)(436003)(105586002)(5660300001)(66066001)(102836004)(14454004)(36756003)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR05MB3604;H:BN6PR05MB3316.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Cv59Jw7cHLc+cf7HbdHwuzIsztv8bDhkzRyIxHJ1YUr7YqVC8vH6vqtYmIMtU0FlkU40NlWXtk8E19yAs5HsaUlRVMrGqF0oLNCL6fb53wVB61WnZJZvSZ88zzMf35YOFeD/8rEOvx4/WPyQCAop66LfnRWqVB+3P24uoZC7xVHBwrRbGAH02MIiza4vzsCF2+jmNMfqOoT5Xp8d8HJZxAqNCWT+vs8F4/5jtJJ0EXyvVbr+wrClL//f4+HB1R5ncPPpk4zyVJVA9+bGlLhmpfOZk+8z6W9cFqOTKShoRDSy/mLYWii5xw+xmqOmmFI5v7u0znj9KgAnbqCjgD/E2IQpQ/XQGNsiLzG8txfmOr6am68izchELLoWI4aosbilEJfiWdxzCwC7RV8xbrfhmW/4dcTrTe0EWTxE9kyZ1Rg=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f6aff35-d1e2-46db-3ace-08d67a04301b
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2019 09:40:13.1701
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR05MB3604
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello Kalle and all,

Here is the patch set with fixes and enhancements for qtnfmac driver.
The major changes include the following items:
- final conversion to SPDX license format
- 4addr mode support
- PCIe INTx fix

Regards,
Sergey

v1 -> v2:
- remove remaining textual license from cfg80211.h header
- fix smatch warning for 4addr mode patch
- queue two more trivial cleanup patches to the series


Andrey Shevchenko (1):
  qtnfmac: support EBUSY errcode for QLINK protocol

Sergey Matyukevich (8):
  qtnfmac: fix legacy PCIe interrupt handling
  qtnfmac: add support for 4addr mode
  qtnfmac: switch to 32bit values for RTS/FRAG thresholds
  qtnfmac: do not reject retry changes in driver
  qtnfmac: convert to SPDX license identifiers
  qtnfmac: add missing bss record to host scan cache
  qtnfmac: remove unused declarations
  qtnfmac: minor cleanup in qtnf_cmd_send_with_reply

 drivers/net/wireless/quantenna/Makefile            |  1 +
 drivers/net/wireless/quantenna/qtnfmac/bus.h       | 19 +----
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  | 43 ++++------
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.h  | 17 +---
 drivers/net/wireless/quantenna/qtnfmac/commands.c  | 58 ++++++-------
 drivers/net/wireless/quantenna/qtnfmac/commands.h  | 22 ++---
 drivers/net/wireless/quantenna/qtnfmac/core.c      | 21 ++---
 drivers/net/wireless/quantenna/qtnfmac/core.h      | 17 +---
 drivers/net/wireless/quantenna/qtnfmac/debug.c     | 17 +---
 drivers/net/wireless/quantenna/qtnfmac/debug.h     | 17 +---
 drivers/net/wireless/quantenna/qtnfmac/event.c     | 96 +++++++++++++++++-=
----
 drivers/net/wireless/quantenna/qtnfmac/event.h     | 17 +---
 .../wireless/quantenna/qtnfmac/pcie/topaz_pcie.c   |  6 +-
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     | 27 ++----
 .../net/wireless/quantenna/qtnfmac/qlink_util.c    | 16 +---
 .../net/wireless/quantenna/qtnfmac/qlink_util.h    | 28 +++----
 .../net/wireless/quantenna/qtnfmac/qtn_hw_ids.h    | 17 +---
 drivers/net/wireless/quantenna/qtnfmac/shm_ipc.c   | 17 +---
 drivers/net/wireless/quantenna/qtnfmac/shm_ipc.h   | 17 +---
 .../net/wireless/quantenna/qtnfmac/shm_ipc_defs.h  | 17 +---
 drivers/net/wireless/quantenna/qtnfmac/trans.c     | 17 +---
 drivers/net/wireless/quantenna/qtnfmac/trans.h     | 17 +---
 drivers/net/wireless/quantenna/qtnfmac/util.c      | 17 +---
 drivers/net/wireless/quantenna/qtnfmac/util.h      | 17 +---
 24 files changed, 188 insertions(+), 370 deletions(-)

--=20
2.11.0

