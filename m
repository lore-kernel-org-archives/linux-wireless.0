Return-Path: <SRS0=K+dv=RH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77D5BC43381
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 15:42:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38427206B8
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 15:42:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=camlinlimited.onmicrosoft.com header.i=@camlinlimited.onmicrosoft.com header.b="mtQmC2vU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727147AbfCDPmt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Mar 2019 10:42:49 -0500
Received: from mail-eopbgr110049.outbound.protection.outlook.com ([40.107.11.49]:32896
        "EHLO GBR01-CWL-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726649AbfCDPmt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Mar 2019 10:42:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=camlinlimited.onmicrosoft.com; s=selector1-camlintechnologies-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t06YGanGCa27kGiD965O28qP4lJJ24kou98nX/RDVZk=;
 b=mtQmC2vU/xtqUqnw9hcvjgthMjsEapDyJ1XWaNCR5obyaLs34AqhuBHL/deNpoomEpSVJ6gJjrk8ZjzsIwfobnRbWcdKPTeCVsJcLukZa6KEkhSscIs5qkpuRrFd3CZhgxThXrbTAl0vYhjSbG6qVhPT0rWoJqukX+KFrNHYaNc=
Received: from LNXP123MB2185.GBRP123.PROD.OUTLOOK.COM (20.179.129.83) by
 LNXP123MB2060.GBRP123.PROD.OUTLOOK.COM (20.179.128.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1665.18; Mon, 4 Mar 2019 15:42:44 +0000
Received: from LNXP123MB2185.GBRP123.PROD.OUTLOOK.COM
 ([fe80::396a:e27e:d5dd:6bf0]) by LNXP123MB2185.GBRP123.PROD.OUTLOOK.COM
 ([fe80::396a:e27e:d5dd:6bf0%4]) with mapi id 15.20.1665.019; Mon, 4 Mar 2019
 15:42:44 +0000
From:   Piotr Figiel <p.figiel@camlintechnologies.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>,
        "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
        "chi-hsien.lin@cypress.com" <chi-hsien.lin@cypress.com>,
        "wright.feng@cypress.com" <wright.feng@cypress.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "brcm80211-dev-list@cypress.com" <brcm80211-dev-list@cypress.com>,
        Piotr Figiel <p.figiel@camlintechnologies.com>
Subject: [PATCH 0/2] brcmfmac: fixes for errors during USB disconnect
Thread-Topic: [PATCH 0/2] brcmfmac: fixes for errors during USB disconnect
Thread-Index: AQHU0qDpEjb5Q2/02kKwExcOG90nPQ==
Date:   Mon, 4 Mar 2019 15:42:44 +0000
Message-ID: <1551714128-27412-1-git-send-email-p.figiel@camlintechnologies.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [95.143.242.242]
x-clientproxiedby: VI1PR08CA0217.eurprd08.prod.outlook.com
 (2603:10a6:802:15::26) To LNXP123MB2185.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:dc::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=p.figiel@camlintechnologies.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: deef259a-977d-40ae-2376-08d6a0b80b6f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:LNXP123MB2060;
x-ms-traffictypediagnostic: LNXP123MB2060:
x-microsoft-exchange-diagnostics: =?iso-8859-1?Q?1;LNXP123MB2060;23:Js/K/wJAYddiOqPVm4NWVam94bylRY1MhYfV+Em?=
 =?iso-8859-1?Q?flMiLr4pgQG0+ZLUMabW14fVGpclok1RonhdRi/tUD1I4I960W+MKbMdjB?=
 =?iso-8859-1?Q?ajQpXt/48N8S0jJjuPWzVRR3dTV23rFfhwISckGaf8C7JLod6DqYR6zIBC?=
 =?iso-8859-1?Q?0ZdoviD/6tsnLkkNChmQcEMrbxMsbL0OWo3EzAVg3ptNhG3r3XdiALTRvJ?=
 =?iso-8859-1?Q?9D2jdC6rKqhMD9zZkFr8c/K8LnLdhRUK+8YX2KYiIo6rhWKWkpnLP8X3rC?=
 =?iso-8859-1?Q?frXxLJzCGcx9V64WdkSuuYsCwImWFYueOAUpfIJ9yFiCZjSTAjA9P5R7Sr?=
 =?iso-8859-1?Q?+lsqSSzcgi9Yr2zH+8sR2crPdKkE7S8VvMgWQf2SFjTkfDfEX0RM3GSx9h?=
 =?iso-8859-1?Q?vdJBOl9g3IL8C1ytwSeGjIDSiHmETnOdwgUFnClXJwgBb6f8SlltzMBKM3?=
 =?iso-8859-1?Q?EH7KQ59e3u6SNiJSMN3rgE7DQJ58OffbNI8TewtZ1EhxIfQ9PGA54gdU95?=
 =?iso-8859-1?Q?Qxgbrk9miaQz7CrDST3jj3K7TVrcrh8Ql8tgfTxRNLc0BJiw6c375Bhlmm?=
 =?iso-8859-1?Q?QfTGO0A3iwp5vpPXHoMk1JZN6qqYCI5SOlgDvLZIn7IJrrpUfXyhuW1G8P?=
 =?iso-8859-1?Q?PzZDLQj3m94rN0gWDzQLIO4Je2B46/r1el7qJHN4H2lzhNvXOwPsKxIsJH?=
 =?iso-8859-1?Q?eeIheOci8vy53HDYEieVGVcNCt//MRcN2nYHplmj2O/83WEkP34/HWvpQs?=
 =?iso-8859-1?Q?TnKr01fgHGd0YT25pgAxFkVOyM+VdGve7LCTCGwB7qDiLT7nW1gQUnuHSa?=
 =?iso-8859-1?Q?nmDzFC33uG16s4RsNhP6V1RU5v+c6ivCRQmjwkw+vCh5W7NqE98QI8iOQQ?=
 =?iso-8859-1?Q?SHiLvdQmy+4ufPG11ZEFoPoH5xCQ4hr4bkH9+narlSKoiqhPI+uAHpvp3/?=
 =?iso-8859-1?Q?vQsQ8WbNYjL9JFMwTMUeE5V+sPMB+H2+kBY1Rks6Q+Qkw7cH9wqk9CD23u?=
 =?iso-8859-1?Q?yyMUHguS3C19H1aZz3ueEiGdOYe5ldDGo6w4iB80o0xK9x4I/rcifvgw1d?=
 =?iso-8859-1?Q?5ULTZq/ycz/KbbjvgR6kot2a29tokYA7Jzp6obi5NJ1H8YiaO2P1xGTyQD?=
 =?iso-8859-1?Q?641LsqK74YTuE2AhJQC9bJLcf2C1YmzWIeONrLpuEh3ksilHDRjdZL6grs?=
 =?iso-8859-1?Q?Jkw3jsYcUh4Gky8FoyUd+jI16DFl+5r2Y/YYEbBnxL6vI9CNlPv7yPuYqj?=
 =?iso-8859-1?Q?B3QMT1aB+6E1QcxBJDE9L6nbc7pqrD2Oo81PINA=3D=3D?=
x-microsoft-antispam-prvs: <LNXP123MB20605B94308A6A001A8A527AE7710@LNXP123MB2060.GBRP123.PROD.OUTLOOK.COM>
x-forefront-prvs: 09669DB681
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39850400004)(136003)(396003)(366004)(376002)(189003)(199004)(478600001)(71190400001)(71200400001)(8936002)(107886003)(50226002)(54906003)(106356001)(105586002)(86362001)(14444005)(256004)(6486002)(81166006)(81156014)(5660300002)(4326008)(6436002)(53936002)(316002)(8676002)(36756003)(6512007)(14454004)(5640700003)(66066001)(97736004)(99286004)(6916009)(3846002)(68736007)(7736002)(25786009)(102836004)(52116002)(305945005)(2616005)(386003)(6506007)(486006)(2906002)(2501003)(476003)(6116002)(26005)(2351001)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:LNXP123MB2060;H:LNXP123MB2185.GBRP123.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: camlintechnologies.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: G2zuaEq8wdBpkngo/jt15ABRfhd2r759PXU0l23ZALksm9ol4jMmd+lvKzi5smkcKMz4N+4LWrekQDjkD9fs7309So1DkGTikih9gZqW1AezaIveAgLsFcdWIqwSoJ5+TL1BSx49+tZzGGRjs/1aIycMzawWMjD66tCWKybiaS5WjdPhepOxvYH9XruyWEl9gn8iXJvhqzv2Xn7lFfJAl4HpRboFqmHkhsCtyKF5LUeZqIv57UZY2UUn91bP2YOIgK8eg9AoFzkAB52BHvV7vBNWsLb1/y3itQzPd+ZnFLN6/LDrp5asZD28zvrwLuCQ0/SggtWEeZu/s45ZbCLCY5UJ7IIbE3/v2DCXEaPGiIAdOUWob40YxadLzGaMmRna8ktkY/MUYFQpU7qkAboRU6SiSTCB6pYzx0sdWBjaAXA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: camlintechnologies.com
X-MS-Exchange-CrossTenant-Network-Message-Id: deef259a-977d-40ae-2376-08d6a0b80b6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2019 15:42:44.8685
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fd4b1729-b18d-46d2-9ba0-2717b852b252
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LNXP123MB2060
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

During tests including automated connect and disconnect of the Raspberry Pi
WiFi Dongle (USB dongle with BCM43143) a number of issues were detected,
including a WARNING and Oops with NULL pointer dereference.  With this
patchset an attempt is made to fix those two issues.

During the test the interface was configured in AP mode and the traffic was
generated with iperf3 in a way that AP was a transmitting server at the
moment of disconnect.

Note that the patch was tested only on the aforementioned dongle.

The issues were initially detected on LTS 4.19, but were reproduced on
wireless-drivers-next/master and the patches apply on that tree.

Piotr Figiel (2):
  brcmfmac: fix WARNING during USB disconnect in case of unempty psq
  brcmfmac: fix NULL pointer derefence during USB disconnect

 .../wireless/broadcom/brcm80211/brcmfmac/bcdc.c    | 11 +++-
 .../wireless/broadcom/brcm80211/brcmfmac/bcdc.h    |  6 ++-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |  4 +-
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         | 58 ++++++++++++++----=
----
 .../broadcom/brcm80211/brcmfmac/fwsignal.h         |  3 +-
 .../wireless/broadcom/brcm80211/brcmfmac/proto.c   | 10 +++-
 .../wireless/broadcom/brcm80211/brcmfmac/proto.h   |  3 +-
 7 files changed, 64 insertions(+), 31 deletions(-)

--=20
2.7.4

