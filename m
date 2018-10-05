Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E44DBC00449
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 10:11:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CD6820875
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 10:11:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="KlW4Hf+j"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8CD6820875
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbeJERJe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 13:09:34 -0400
Received: from mail-bl2nam02on0042.outbound.protection.outlook.com ([104.47.38.42]:30496
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727535AbeJERJe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 13:09:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Wdxeco0Bn/WveoW4hYkjERfF8ncmXD0wGRD/s1XTsU=;
 b=KlW4Hf+jJHPg/7n8Pc6U809mc/2xDwDuk0Zpm9fJ+V8KsTxO82YisM0z5lYBKDq8woWK5e6ZXBZ+M8QMRzG3jr0G1l+01Dr5n938Ja9XdfPy3bOHQxxmhd39ZJVTyl9AviUTVL1It/I7AFf0xzsni8NA94yhIoWPEcgs+ar4UZ4=
Received: from BYAPR05MB4597.namprd05.prod.outlook.com (52.135.233.18) by
 BYAPR05MB4375.namprd05.prod.outlook.com (52.135.202.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.13; Fri, 5 Oct 2018 10:11:25 +0000
Received: from BYAPR05MB4597.namprd05.prod.outlook.com
 ([fe80::fc58:438:5b30:9373]) by BYAPR05MB4597.namprd05.prod.outlook.com
 ([fe80::fc58:438:5b30:9373%4]) with mapi id 15.20.1207.021; Fri, 5 Oct 2018
 10:11:25 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH v2 00/13] qtnfmac: fixes and cleanups for STA mode
Thread-Topic: [PATCH v2 00/13] qtnfmac: fixes and cleanups for STA mode
Thread-Index: AQHUXJPGvIXyEY5e4UquCQ03lGuy3A==
Date:   Fri, 5 Oct 2018 10:11:25 +0000
Message-ID: <20181005101114.3013-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5P194CA0013.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:203:8f::23) To BYAPR05MB4597.namprd05.prod.outlook.com
 (2603:10b6:a03:4c::18)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR05MB4375;6:ljNJZr00vq98m4rjIFb9nRVrWY7DongkZOQ4e9NTJ75i0HjyNvoERMwk+FQ35Tf/1u7UGtUnOCHlmA+03/QhcikaPC+M3fSXvVFDqiAHZqbaZUyfsEXCCepwBUoTUjpisSu2IS3VjYZMwe0dI6Ihmq9Pd3CGUh4HbwTt89yJe61xbu0jWsYhL9x3gnKPMKlvYNX5w5NdOIgl7OU84thXnNHKUlizFqCt3BP3pX4AmLt85T9EWBcKugHnDtLfYOLUdfoAzF/gfQr0ZiYJ07Mc4r3vHw/AdpiJKRp1b9m8osSCdhEk5Dlebz1MuoBneBcDKV/WpmfarfmgtsmJmRowfycuRpPvYE2Xd64jJjcZ4rx7ObFJaiN4CmoxVXKo3XF/DihL4cm42iXKtoIo4+lV/bfmGCzFCOKkHqy7qvRNAAwYF82Ahgb8cNvB9tfpYq3PC8REOBTV/uI/1WS4gTQAkA==;5:9U7vB0SsHrGltdLyabIN0hgJz33FXvGxy1oNTxlSFBBAc+fggpAk/Jln/7Ltbj7cNdREPOpgQsmXgoDkb0ZnCsKvf4vC+TelRs+00DaC9lhBl3hrfOUC4kvF0q3lsm1J+dNJ3TKPo4uM4NATQrlMMdUZFkwwVexhD/6rTPH6SCE=;7:cKeLA4iUz5mYbi8zH11gfn12yEeBVfzNAIPKtxxYAfrI5cO6XtRf7j0/Mzmfc6+oGwlkbqXWEagZyhymMETBShsonoqntXqqvuW8XfxY6COd5aKL80GyuMrZhBBVkm5vu2Zd7AWWRCwrUIKEDorFiwYrI1i1HMBbexXstGPo2TZuw+K+nlNFbZszDn0bxln3/e3nwZDQpcIxq6QQV49txk/ZMLooJojRYBbhUx706j4vzjPEu8/d1xO782MprXVy
x-ms-office365-filtering-correlation-id: 48e0ce6c-79fd-4206-ab37-08d62aaae88c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR05MB4375;
x-ms-traffictypediagnostic: BYAPR05MB4375:
x-microsoft-antispam-prvs: <BYAPR05MB4375A41668FBADC7F622F54DA3EB0@BYAPR05MB4375.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(20558992708506);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3231355)(944501410)(52105095)(93006095)(93001095)(3002001)(10201501046)(149066)(150057)(6041310)(20161123564045)(20161123562045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(201708071742011)(7699051);SRVR:BYAPR05MB4375;BCL:0;PCL:0;RULEID:;SRVR:BYAPR05MB4375;
x-forefront-prvs: 0816F1D86E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(39850400004)(366004)(376002)(346002)(189003)(199004)(6916009)(478600001)(6506007)(386003)(106356001)(105586002)(99286004)(6512007)(2900100001)(97736004)(2351001)(4326008)(25786009)(36756003)(53936002)(2906002)(103116003)(107886003)(2501003)(52116002)(486006)(5660300001)(5250100002)(2616005)(476003)(305945005)(8676002)(8936002)(102836004)(14444005)(26005)(3846002)(71190400001)(71200400001)(1076002)(6116002)(14454004)(68736007)(6436002)(6486002)(5640700003)(7736002)(186003)(86362001)(316002)(256004)(66066001)(81156014)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB4375;H:BYAPR05MB4597.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: Ypipq2ckyupyL4N/wS2VrdVkMfVzKnPF7N6oeb7NIv0XTmURsGS4MW1CD8NhctkjT1JRBj0ztqeFAsWU9QUm+FJd2UKsT6vitTFgojYPDYYy6tuhnz5LuYT+W6SIK/u8YeHxtdkA8PkGK7TMopuAGtW9hevDAvOD3Gr0JryIm2MU9wfgG+eSpP+pYYFS87gBS2FIyc0Puvu0Fd7F7bRcGINM3+qEuk+e5zqkRJp//hNOe0/+VvUOlFOPo43QgQ6ItMqkhSmIPM5BpERVpuHJfpZ8ggfceGlW5lE2g7ZD74csRTFzYpYgxhPdwb+ZsrmhzezgNYDoLzULPit3CuVB7yluea6YcmtgfIoa15+VG3o=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48e0ce6c-79fd-4206-ab37-08d62aaae88c
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2018 10:11:25.7156
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4375
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello Kalle and all,=20

Here is the next  patch set with fixes and cleanups for qtnfmac driver.
This set mostly consists of multiple fixes and improvements for STA
mode. The major changes include the following items:
- fixes for 'iw' output: rates for enabled SGI, 'dump station'
- expose more scan features to host: scan flush and dwell time
- inform host wireless core when OBSS is not supported by firmware
- command processing cleanup: unify and get rid of 'unlikely' macros

Regards,
Sergey

Changes v1->v2:
- fix email addresses: drop "OS" string

Igor Mitsyanko (4)
  qtnfmac: do not cancel scan in disconnect callback
  qtnfmac: do not initialize per-MAC data multiple times
  qtnfmac: request userspace to do OBSS scanning if FW can not
  qtnfmac: generate local disconnect event in disconnect callback

Sergey Matyukevich (9)
  qtnfmac: implement dump_station support for STA mode
  qtnfmac: drop redundant data copy in control path
  qtnfmac: add support for scan dwell time configuration
  qtnfmac: add support for scan flush
  qtnfmac: drop error reports for out-of-bounds key indexes
  qtnfmac: inform wireless core about supported extended capabilities
  qtnfmac: pass sgi rate info flag to wireless core
  qtnfmac: cleanup and unify command error handling
  qtnfmac: do not track STA states in driver


 cfg80211.c   |  193 ++++++++++-----------
 commands.c   |  535 +++++++++++++-----------------------------------------=
-----
 core.c       |   39 ++--
 core.h       |    8=20
 event.c      |   18 -
 pcie/pcie.c  |    5=20
 qlink.h      |    5=20
 qlink_util.h |    8=20
 shm_ipc.c    |   13 -
 shm_ipc.h    |    4=20
 10 files changed, 277 insertions(+), 551 deletions(-)
