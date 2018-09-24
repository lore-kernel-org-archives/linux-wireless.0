Return-Path: <SRS0=DN1r=MG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 204F4C433F4
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 05:13:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E1A121480
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 05:13:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="nz/foppe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E1A121480
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbeIXLNt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 24 Sep 2018 07:13:49 -0400
Received: from mail-eopbgr700066.outbound.protection.outlook.com ([40.107.70.66]:28567
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726366AbeIXLNt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Sep 2018 07:13:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sVm1H3CmJdHU3d8rl216UDLDep1aWG5EPewFYypD3dk=;
 b=nz/foppebUhXxThXooRAwtfThqp18dnD9OnbTdp0nSCPlFOUqdo1L1JFObQ6OSt0wlIYaQaafCA2OzKyzT7FoBXSCX2GdhTX8fWphWfzD2fniyMhTcOg8Zat2ralByswtGjp8HUiEuP3JLnX6Kh/oLSJbO6xcIwr6hs1Ts7WprQ=
Received: from MWHPR05MB3326.namprd05.prod.outlook.com (10.174.174.165) by
 MWHPR05MB2975.namprd05.prod.outlook.com (10.168.246.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1143.11; Mon, 24 Sep 2018 05:13:24 +0000
Received: from MWHPR05MB3326.namprd05.prod.outlook.com
 ([fe80::6d10:24a9:2432:b2dc]) by MWHPR05MB3326.namprd05.prod.outlook.com
 ([fe80::6d10:24a9:2432:b2dc%2]) with mapi id 15.20.1164.017; Mon, 24 Sep 2018
 05:13:24 +0000
From:   Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>
Subject: [PATCH 00/11] qtnfmac_pcie: extract device-independent PCIe driver
 code
Thread-Topic: [PATCH 00/11] qtnfmac_pcie: extract device-independent PCIe
 driver code
Thread-Index: AQHUU8VR492UWB0PQU6HIWNieV+XpA==
Date:   Mon, 24 Sep 2018 05:13:24 +0000
Message-ID: <20180924051246.13371-1-igor.mitsyanko.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0002.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::15) To MWHPR05MB3326.namprd05.prod.outlook.com
 (2603:10b6:301:3d::37)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [12.131.200.68]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;MWHPR05MB2975;6:+wxnUCmXHibZsN6Rdw/lJ+UcbN60BbvYWoNvX+Oin4t9AQjhX213ZveF9QHU3z8kJciqKfKeJhkKINrH0xUPIGH6w6JdOcEOSIL8bEBrZhgJSUQxL60wmfuJkTxCsuvQBVSAvSxMxxspWBywDAMwKZJOSYf/W4EcY6KyGQNMX5Z6P0abxxt4d3kllYN04xEqSyK8aJV+powkXgJOmQSIA11FXZs0ov0RFhHBn3UDLMq0l7akYEyRUF1Q1zwteYUJC+84YFIGucbr2lZ4x27dRyGmGRgfelWjOYwZvaKYisfpEH6v31PYGAzO1SsQjDkZ3h455fX4edIB2mYW08JwObqONTIstdQN8d2qdC9RNJHWkhSR0ZPNr42segjc+0LzCZN/GO43xEE0PmXlcZUo0MqimP4o69kmwt9AOeqFLTwx3n8izUTJ7FXxnp4loA6HU+Hr7mg/VFZilBSFxPZExw==;5:w8eL/7YLy6zheYM40278mQ6P+sSh3tKvT25Y2tMOpcMdasNiVI7c4KxNIt1mP6i9e7J9x1lrWdbShQiKPdr/HWAWHz++wCF3KEVtWKt5VOEoEQRiFVAXbOP+6Ux4h1iyDgL5W+5Dls/20gWzEyWEW073ijt8CWLAcEcA1zyICa4=;7:BtrVc/RtpZpiZ3p9H3Yx7PnB1gR8cPX2LxW+Lzlpvrl5NBfGFjExvt69b6pEkw8BV5B3jVgVzaCW6TqLO5dfJpi/49jj+NG5EgkuKrDGTSxZNJgX0B/3clo2VaJKDPDvFzd6rCZxcihbEOih279Y7Ltc3G+ndLflQn+XDsBUubZN3Mrqz+fLy6SkLfbHRl4415OlDuiZ3M4CaxCqmRFBBz6om2hZEASubEVQ5rOU3Fsb6Pqa/ffiR5pnwkLqPVcP
x-ms-office365-filtering-correlation-id: 3ab91952-971a-443a-e55b-08d621dc73b5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534165)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:MWHPR05MB2975;
x-ms-traffictypediagnostic: MWHPR05MB2975:
x-microsoft-antispam-prvs: <MWHPR05MB2975D290572A50A68963E881B0170@MWHPR05MB2975.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3231355)(944501410)(52105095)(3002001)(10201501046)(149062)(150027)(6041310)(20161123560045)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123558120)(201708071742011)(7699051)(76991041);SRVR:MWHPR05MB2975;BCL:0;PCL:0;RULEID:;SRVR:MWHPR05MB2975;
x-forefront-prvs: 0805EC9467
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(136003)(366004)(396003)(39840400004)(199004)(189003)(86362001)(68736007)(81166006)(52116002)(2900100001)(6916009)(99286004)(486006)(36756003)(316002)(2616005)(305945005)(71200400001)(71190400001)(6512007)(105586002)(106356001)(7736002)(107886003)(103116003)(8936002)(14444005)(14454004)(54906003)(81156014)(5250100002)(25786009)(478600001)(6486002)(97736004)(6116002)(1076002)(2501003)(5660300001)(3846002)(256004)(66066001)(102836004)(6346003)(2906002)(5640700003)(26005)(53936002)(386003)(6506007)(6436002)(476003)(4326008)(186003)(8676002)(2351001);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB2975;H:MWHPR05MB3326.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=igor.mitsyanko.os@quantenna.com; 
x-microsoft-antispam-message-info: 06qjix7+CRwRDOlrLzpviZGZzURBDwjC0J0KYEdOguprApgOz6MWKgSUfNHnuPXWPHYaF4B/scfSS7/egrIZacqPShBMGNkoZvNvaAWU/MldAjy+pBWgNfhGJQeb9kVXGip+9G5N+qNIaAqK/DEB1FZ8W1xdWQ+Yr3FbAOhYEHXheQhiiwJJGMh9bfAHsfPAgUFnOW+s6LZ9zo3y0YryOgz4ZEZ37xp0buNn4rrzQErh+xdM4QP5Z/1MDcpTgO/TuibR815ab91pT9ZbO3dSCbOfNxkELsbD4EMl9avJs3q/W25QEl8WxSpwvJqW5SHmHN87AqlAncuULMV1qSECoX7wnkKV42eX6OJyQO5ImVQ=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ab91952-971a-443a-e55b-08d621dc73b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2018 05:13:24.0508
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB2975
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org
Message-ID: <20180924051324.7qABsEadByU7sl6-XZLvdXkz0HmxECsi3vcCsQnVWUo@z>

Purpose of the patch series is to extract a portion of PCIe driver sources
that is common among Quantenna wifi devices. It will later be used to add
support for additional wifi card.

As a result, majority of changes here are moving code blocks around and
renaming without functional changes + several minor improvements.

Igor Mitsyanko (11):
  qtnfmac_pcie: do not store FW name in driver state structure
  qtnfmac_pcie: move Pearl pcie sources to pcie-specific directory
  qtnfmac_pcie: rename private Pearl PCIe state structure
  qtnfmac_pcie: indicate pearl-specific structures by their names
  qtnfmac_pcie: pearl: rename spinlock tx0_lock to tx_lock
  qtnfmac_pcie: separate platform-independent PCIe structure
  qtnfmac_pcie: rename platform-specific functions
  qtnfmac: add missing header includes to bus.h
  qtnfmac_pcie: extract platform-independent PCIe code
  qtnfmac: wait for FW load work to finish at PCIe remove
  qtnfmac_pcie: check for correct CHIP ID at pcie probe

 drivers/net/wireless/quantenna/qtnfmac/Makefile    |    3 +-
 drivers/net/wireless/quantenna/qtnfmac/bus.h       |    5 +-
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c |  404 ++++++
 .../{pearl/pcie_bus_priv.h =3D> pcie/pcie_priv.h}    |   71 +-
 .../wireless/quantenna/qtnfmac/pcie/pearl_pcie.c   | 1261 ++++++++++++++++=
+
 .../{pearl/pcie_ipc.h =3D> pcie/pearl_pcie_ipc.h}    |   58 -
 .../pcie_regs_pearl.h =3D> pcie/pearl_pcie_regs.h}   |    0
 .../net/wireless/quantenna/qtnfmac/pearl/pcie.c    | 1494 ----------------=
----
 .../net/wireless/quantenna/qtnfmac/qtn_hw_ids.h    |   14 +
 9 files changed, 1723 insertions(+), 1587 deletions(-)
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
 rename drivers/net/wireless/quantenna/qtnfmac/{pearl/pcie_bus_priv.h =3D> =
pcie/pcie_priv.h} (51%)
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.=
c
 rename drivers/net/wireless/quantenna/qtnfmac/{pearl/pcie_ipc.h =3D> pcie/=
pearl_pcie_ipc.h} (68%)
 rename drivers/net/wireless/quantenna/qtnfmac/{pearl/pcie_regs_pearl.h =3D=
> pcie/pearl_pcie_regs.h} (100%)
 delete mode 100644 drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c

--=20
2.9.5

