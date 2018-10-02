Return-Path: <SRS0=TNca=MO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10A66C43143
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 09:26:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0FFB20878
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 09:26:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="1j/B5gG+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B0FFB20878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbeJBQIR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 12:08:17 -0400
Received: from mail-bn3nam01on0070.outbound.protection.outlook.com ([104.47.33.70]:28864
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726246AbeJBQIR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 12:08:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iyv4QmciS5ICep50ONvjj5ZLp0ZH5vNa8q8WH45i8Yk=;
 b=1j/B5gG+wE9h0uZiYovAqtmQJQvjRokcSzw8ZChgaiDeaCIXTa3c3C+Ay8XMf6vXocLn4zSx9Shr76bwpr4Ii0XeKJuoEwDWpWs+uq2amLciSKWMljw4CDZOdbv0IJNV618yiietIZ4y4yHIOgXBvcQzWErRxuC9mhTPzQRGEyA=
Received: from BL0PR05MB4595.namprd05.prod.outlook.com (20.177.144.212) by
 BL0PR05MB5092.namprd05.prod.outlook.com (20.177.241.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1185.18; Tue, 2 Oct 2018 09:25:54 +0000
Received: from BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::58a1:7de3:62b:f06a]) by BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::58a1:7de3:62b:f06a%3]) with mapi id 15.20.1185.024; Tue, 2 Oct 2018
 09:25:54 +0000
From:   Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko OS <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH 00/13] qtnfmac: fixes and cleanups for STA mode
Thread-Topic: [PATCH 00/13] qtnfmac: fixes and cleanups for STA mode
Thread-Index: AQHUWjHrLjx3XLjQ3kKbIfunr5n3EQ==
Date:   Tue, 2 Oct 2018 09:25:54 +0000
Message-ID: <20181002092542.18966-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR06CA0023.eurprd06.prod.outlook.com
 (2603:10a6:206:2::36) To BL0PR05MB4595.namprd05.prod.outlook.com
 (2603:10b6:208:5f::20)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB5092;6:L0IwdjKkrOxpRVJuYdnBNGRBvnE4xSzq9Qei3UnfwruQlxr/mq/NUH6pPNmJvdEZ9xPu9ilrdAGihk0O5mkixmiqYv/8We8Jm23SzvkvAEEJ9vxtyXtvtBPGJMFbY/yHTlRWdqSHCfKXbXZWrdiX9bhzbSX7mBRNAXAHrDaAQOPA0VJcT/MZ7H4NjNK3w9Dpj6Ryw4VA7ZDPNT/q/qFNgvEWJoxI2niDaN9UVshc5N4gGflN6PhFiRTDJip0yvM9rM0sJbWvf8v7Xp+rEYXoCEH7bozHbyMsZd+2ChNeh+IhN3ygTn5KR6kplcac+Bq6D/cS5shXsW9GKDNaR516uxRcF4vRfRKmgno0oCulecX5+IB4Jn0xDJ2frA11pkuDhpTbCRXyjxwlBds2N0NdZXWT19JjLdn7oQp8oU+c1H69zufN2CNqGwshmLwV5plHDeB2uHlFYRzNXS8yFpv6VA==;5:ojGuKlzzkRvJl0uaAUXRfD/q0RzXbJrWWKg2DKrw0m53KG4GUCr0Odsay/hIywHe7uvAcQq1HXaRNf6UjU+LwSYDFnAvmfpLiz5BSlZiQwifcEizONz0B6AeplzcDY6djbRVJY6SKLPnI/XHB4/yYFPh7rVstx1h5d6EOkBBQ38=;7:JKPMHQdXiuOzk9lM1FxwsAv1Oqp5+FLr7sZImUfrbtUIMicel7SunVMbZPOu1hRJClbF0rjnA4cQ7/DWavb4gb1B3dkl+Rc+uaBn3GPVW8TvDn79G63KRIVQt8ghRFnrAInd7xknDAoDVP0P29IaZoflI3Mv4uHc5y7RG5K/KNCXkQbRWJxF0DL96AIOWSox+Vx5G5famhpcwv5qfy8ey+xgvbNSUNR8ZyFFmz01Xucdw8AmWkqJbkobVFjG1qHO
x-ms-office365-filtering-correlation-id: df518b25-a522-466a-b9f4-08d628490c8d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534165)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB5092;
x-ms-traffictypediagnostic: BL0PR05MB5092:
x-microsoft-antispam-prvs: <BL0PR05MB50929D9414BCA1263654AC93A3E80@BL0PR05MB5092.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(20558992708506);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(10201501046)(3002001)(3231355)(944501410)(52105095)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123558120)(20161123564045)(20161123560045)(201708071742011)(7699051)(76991041);SRVR:BL0PR05MB5092;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB5092;
x-forefront-prvs: 0813C68E65
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39840400004)(136003)(396003)(376002)(366004)(346002)(189003)(199004)(478600001)(97736004)(256004)(386003)(6506007)(2501003)(5250100002)(305945005)(86362001)(1076002)(6512007)(316002)(52116002)(99286004)(8676002)(14444005)(6346003)(4326008)(26005)(36756003)(2616005)(6436002)(102836004)(6916009)(2906002)(105586002)(106356001)(2900100001)(14454004)(476003)(6486002)(5660300001)(103116003)(71200400001)(6116002)(7736002)(186003)(486006)(71190400001)(3846002)(81156014)(81166006)(68736007)(8936002)(2351001)(107886003)(25786009)(66066001)(5640700003)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB5092;H:BL0PR05MB4595.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-microsoft-antispam-message-info: kYWAA4g+6cYpJgp5HBPkyW5Lr1zxtSZp2BphJs71AD4WnnzK1Rz9BegEv24teNNqqcLPUISXC+me99nC9bBPX3Ds5waGA2iV06I/Bic+Ll1sZc2mfkh75zr/kXdJCyWyacY5g3VTKAHiXEz6RNfzo99bFFGDGXLdnYHQw/hXPn0AtX8EASmu0ZDAN5doasTH14x9BhzzxYKK5vk1Q2NP0iOcmN20wv5Wh7obzsu8eauStU6/whRdlPMO8hfwrT4wVusiMOD0mvbb25BrWQTJrqnwbFvej/HP041jw1Xymi+TF8eVaYI7oiGz8LgeojDzDQ1e3FP/Fy29oP6dusJ12G+O7JnUbQW9kLf5MH0CW6s=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df518b25-a522-466a-b9f4-08d628490c8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2018 09:25:54.7175
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB5092
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
