Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69531C0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 14:30:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 236C920819
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 14:30:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="QYoJcSxJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 236C920819
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729608AbeKEXuy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 18:50:54 -0500
Received: from mail-dm3nam03on0043.outbound.protection.outlook.com ([104.47.41.43]:12752
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729165AbeKEXux (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 18:50:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=owOSYMkNBn3rEpMDzs/NaWTQX2p4FVFBQSo6DnkWWjs=;
 b=QYoJcSxJaYGdE9bRGbA7BGNlxqt/5C9Ll0YRK7JG39V9Dn2gqUazHSTTpsZ5fvJuENYREsxRd+wmK3J3B07dtKs/VY2zsWzV23+H0ozjwIj+EPfeO7ySaU66jnHN4ZswH8cDpjqfj2iKJgInyShoM3wIlEEfKG1A6Bh1O54cyds=
Received: from BL0SPR01MB0020.namprd05.prod.outlook.com (20.177.146.138) by
 BL0SPR01MB0022.namprd05.prod.outlook.com (20.177.146.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.12; Mon, 5 Nov 2018 14:30:36 +0000
Received: from BL0SPR01MB0020.namprd05.prod.outlook.com
 ([fe80::fce8:69f:f659:27d8]) by BL0SPR01MB0020.namprd05.prod.outlook.com
 ([fe80::fce8:69f:f659:27d8%3]) with mapi id 15.20.1294.028; Mon, 5 Nov 2018
 14:30:36 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
CC:     Jouni Malinen <j@w1.fi>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [RFC 0/3] cfg80211/nl80211/iw: add basic AMPDU/AMSDU controls
Thread-Topic: [RFC 0/3] cfg80211/nl80211/iw: add basic AMPDU/AMSDU controls
Thread-Index: AQHUdRQdP3Y7plTpG06kvM3cndpYMw==
Date:   Mon, 5 Nov 2018 14:30:36 +0000
Message-ID: <20181105143027.17570-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P194CA0090.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:8f::31) To BL0SPR01MB0020.namprd05.prod.outlook.com
 (2603:10b6:208:72::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0SPR01MB0022;6:c1nC1PmlSvoqQxCBggYe33IwyktL6r9qqxFfnMG43zfq7hBCkkH+5zBfWl2YCBra0O/8eF5wuRSQJt+KuYWPO6O0Rj8NJ5nmEKyfijwuEqugJp4suwjDom+nd2IUjQgNzosodCX4kXLu6zvNbAgKg9hGeIzkRDIO7Wch3JSLSW6UQRVZE3gBCzLNthhXkmyK1kRKU4CE8vOomG8VZXnB8rCLItaFT1ee0ZGHwU4pp5TN2RDZkk98tz0CzZfIXGiIVyt7H46nD/BbXgNSYtmkCO8tAlv3f4XbDwP5Yp9wI3FMC1RKebPR6WKCYAOBlRaJopHxM9bH+E1sjSvGzWa0HKGI5S6CBvmy39l187TTSJyjd+WhAJOXHUDb61BHo3RnRYuX32bJpzUS0cn5/hwWX3wmBqxiGHk7dm0z6J04ZXJtoib8FC7DCEqclesgUFh/S64hQkl0/zfCq/0JQqGJ/A==;5:P2aNWB2JyJCqwon/bn4o1OMl4PBC9u8vhESjnOXUCxqU7TNKZ28khnJG7k1lLfSD0ZuGfcMphZ4twg/XN6w0H8b/obvLk1zbxs/FLuvP+NJ11DVoDvoKqFe7nn7wRGOVIsmvkXYWs29eoJQ9yee9mDCOVbCt1+ieiavj2SHCkY4=;7:6ErE3M3Ut7/JOy2xrNPC2EzcZOfky0ADbjwG9oI98D/L+49GO+q0Lu9GU91Lntws9Fs8Lqtrvd46p5FOGilIW4DzS8LI6RDCDPJYmYtnVBfoQkVOPtKNuMvs9D9t/4jjTtjR7IwzjW4T7FikmfprCA==
x-ms-office365-filtering-correlation-id: dfdc090b-d7d7-44b2-dfc7-08d6432b3fd0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BL0SPR01MB0022;
x-ms-traffictypediagnostic: BL0SPR01MB0022:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-microsoft-antispam-prvs: <BL0SPR01MB00226A9022392956D6979599A3CA0@BL0SPR01MB0022.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(166708455590820)(21532816269658);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3231382)(944501410)(52105095)(3002001)(10201501046)(93006095)(93001095)(148016)(149066)(150057)(6041310)(20161123560045)(20161123558120)(20161123562045)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BL0SPR01MB0022;BCL:0;PCL:0;RULEID:;SRVR:BL0SPR01MB0022;
x-forefront-prvs: 08476BC6EF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(39840400004)(396003)(376002)(136003)(199004)(189003)(1076002)(99286004)(4326008)(68736007)(6116002)(3846002)(7736002)(966005)(305945005)(53936002)(256004)(6486002)(14444005)(52116002)(478600001)(25786009)(71200400001)(2900100001)(66066001)(71190400001)(107886003)(86362001)(316002)(2501003)(110136005)(103116003)(8936002)(54906003)(6506007)(386003)(5660300001)(36756003)(14454004)(186003)(102836004)(2906002)(106356001)(105586002)(97736004)(6436002)(6512007)(6306002)(26005)(81166006)(476003)(81156014)(8676002)(2616005)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0SPR01MB0022;H:BL0SPR01MB0020.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:3;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: fnGxSdk2puHg2EH/07n4MX2w92LPt3yDOvUe8S/ijnEHOjsUf7365etsYbqJpDc9LFzBFlJlNhbOCQog0MkdzRiLtv54mmQ73E9iJgVD82ke1/6JuHpo/8JRSb6SFk9w7veRHLbRkiWyx61d56CoySwsWLzpwyLMEJH6CDuBhbH4SDuQ+z9QjyNP+vBklqAyX7WhuDOAnIgg3ZB0Hi61wGRVhQMgZejI0+cFyqZOEUFecLNbfoDt3C65iUn3yYdetmyNH9irzjzecvblkCXOtbMralslkA3q/DR/9UkfHz3Iwgkfcks/6gxjE4G4aI6UNXoExJNsGvwI30ctMiRgJvjtTZlht6MLgmBRLdKhyys=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfdc090b-d7d7-44b2-dfc7-08d6432b3fd0
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2018 14:30:36.2558
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0SPR01MB0022
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello Johannes and all,=20

Here are several RFC patches providing simple high-level controls of AMSDU/=
AMPDU
aggregation. The primary purpose of this functionality is an attempt to fil=
l
missing gaps in nl80211 interface for basic WFA certification tests.

We experimented with QCA sigma-dut tool: https://github.com/qca/sigma-dut.
The purpose was to cover basic HT/VHT WFA STA tests for cfg80211 driver
controlled by wpa_supplicant  w/o adding any vendor specific commands.
Multiple WFA test parameters (e.g. STBC, NSS, SGI, LDPC) can be configured
by overriding HT/VHT capabilities in wpa_supplicant and applying them on
connect in cfg80211_connect callback. Others (e.g. RTS params) can be
configured using iw tool or NL80211_CMD_SET_WIPHY directly. These patches
implement simpe high-level switches for AMSDU/AMPDU aggregation.

It would be interesting to collect comments/concerns regarding this approac=
h.
Does it make sense to enhance nl80211 in order to cover all the missing pie=
ces
required for WFA certification tests ? Or maybe it makes sense to use
NL80211_TESTMODE subcommands for this kind of testing.


The summary of changes is as follows:
- nl80211/cfg80211: new wiphy flags and minimal set_wiphy/get_wiphy changes
- iw: new phy subcommands to enable/disable aggregation
- qtnfmac: minimal driver example - get/set aggregation

Regards,
Sergey


kernel:
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c |    2 +
 drivers/net/wireless/quantenna/qtnfmac/commands.c |   17 ++++++++++++
 drivers/net/wireless/quantenna/qtnfmac/core.h     |    2 +
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    |    7 ++++
 include/net/cfg80211.h                            |    7 ++++
 include/uapi/linux/nl80211.h                      |    6 ++++
 net/wireless/core.c                               |    3 ++
 net/wireless/nl80211.c                            |   31 +++++++++++++++++=
+++++
 9 files changed, 76 insertions(+), 1 deletion(-)

iw:
 nl80211.h |    6 ++++++
 phy.c     |   60 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
+++
 2 files changed, 66 insertions(+)
