Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DA80C43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:44:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEEBB21546
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:44:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="Q4AEynBk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AEEBB21546
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbeI0QBx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 12:01:53 -0400
Received: from mail-by2nam03on0118.outbound.protection.outlook.com ([104.47.42.118]:49707
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727105AbeI0QBx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 12:01:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mLKR7oaPIGIiSdVcEuIQCA+kBdv9FppkCoRQ0/1GU+E=;
 b=Q4AEynBkEzNfWUAZInZSXXAsaDVnRjxN/EFYCAyIVDEdI3XMeRxHGcUiYLWFmD5MrUeVSoPNnw91TlM9dmGWDgE8l8hDybzaiiJwVjDcXaEfwHZWIIpixCzYJRl0/QNlT/K6wIuoHCSTVEB6vcsqmQjxa8Rd1aVVbVaIY8fW1Z8=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1110.namprd06.prod.outlook.com (10.160.196.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1164.20; Thu, 27 Sep 2018 09:44:23 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::ad59:f71e:ebcb:70ac]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::ad59:f71e:ebcb:70ac%5]) with mapi id 15.20.1164.024; Thu, 27 Sep 2018
 09:44:23 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     "linux-firmware@kernel.org" <linux-firmware@kernel.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Josh Boyer <jwboyer@kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Subject: [PATCH 0/2] WFA p2p certification fixes
Thread-Topic: [PATCH 0/2] WFA p2p certification fixes
Thread-Index: AQHUVkarF8wH9OrDD0Kc4dw/WW3Ddw==
Date:   Thu, 27 Sep 2018 09:44:23 +0000
Message-ID: <1538041427-115758-1-git-send-email-chi-hsien.lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [12.110.209.245]
x-clientproxiedby: BYAPR05CA0006.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::19) To BY1PR0601MB1436.namprd06.prod.outlook.com
 (2a01:111:e400:522c::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1110;6:FIYt21O9dLJJptnRuQrm6YoNkMQTJuZPM/rDX38UVMGJgfq8EXzonMHUujwG0CnXwk+zP9P0I9hBQDU6/DsMw3Gw4HHjXn4/AGFHL7MhcP8+4PbkfHYKi3rOJgYY7q13o9naa5x8Mol2PIXfOHiIYSKqH3Sy7H79i+nsfAAmkImVvjkvWTz+9jto+N3f2nrJtAL//oxD7o+zKanGLbYBnyahDeZx1lnNhThR9yPd2/KzuvoaHoeSh+eZjD0i218DZhM41ao9rr9wnkqJO4MQwjYwpUFuHnGYTjuwcVtekoA9WEseqmvywgCZNXkF/Thznm+UwiKMvvI4dA/lM1/lG2DXvbfKFSvyW+NEoHIlZT4IRc3w9VeBpfQ0w0s5bXF3fyMWJ1RzfSXeUPec0xl6NgphEpPa/UxWRJ7lMw9NJSQqU78DE+ZptPnHJO18QGgAOWO5Mit3aUVrYf8J7pNSSA==;5:jLlhZWo4MZP1xxBmeB3v7ZrGnPJ6ZYBzde+EV5vnxlv2PPIWYkRcDZ6KBtwqL06cleI+FdddNWabgdWBdRithXn82DTvVK2/Tex4lqrHC3KWTtZXsViA386dXgQmqJqYGVot01z0HilO4O2QlW5AiwKqrhrPLK71pnAb8QtaomM=;7:WGCQQIPfguTTiEHDe1clSUeVd/5I9gHQ8m5Hb7SlsyEOsSqlBB2Xm9qybG+VaVqzJFz+Hwpi8KlCSy8CbBU/p8VRk90ftKlhIA0xyM/i2kO17NfiapX6w8GI1uf9b/GkK7kZ3LYDEJ+Ps9xRzIWa79gfXMmZtv2OWWNKZlV+Mv3F836aKzAzAWfhtbrFLvLOhWimM03ryzTzvN+DSL8KIV3ommGYMNstFivz9XeDNxL6NyStwTq74cDywRHKz9I3
x-ms-office365-filtering-correlation-id: 307f1469-cb44-4ba6-1c5d-08d6245dcdb6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534165)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1110;
x-ms-traffictypediagnostic: BY1PR0601MB1110:
x-microsoft-antispam-prvs: <BY1PR0601MB11102341C06599D8D7797FA6BB140@BY1PR0601MB1110.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(10201501046)(3002001)(93006095)(93001095)(3231355)(944501410)(52105095)(6055026)(149066)(150057)(6041310)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123562045)(20161123558120)(201708071742011)(7699051);SRVR:BY1PR0601MB1110;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1110;
x-forefront-prvs: 0808323E97
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(39860400002)(376002)(396003)(366004)(199004)(189003)(8676002)(256004)(54906003)(66066001)(4326008)(6436002)(2900100001)(2906002)(53936002)(5640700003)(3846002)(71200400001)(107886003)(6506007)(52116002)(386003)(102836004)(6512007)(5250100002)(97736004)(71190400001)(68736007)(6116002)(36756003)(81156014)(99286004)(486006)(316002)(81166006)(25786009)(186003)(26005)(86362001)(6486002)(305945005)(6916009)(7736002)(478600001)(5660300001)(105586002)(2351001)(106356001)(72206003)(8936002)(2616005)(14454004)(34290500001)(2501003)(476003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1110;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: bDlBCklUBYcef2UieZapqAdREoZhJMiDUHEH7P5JQQpxMpLpr0CWi473dHVmEXTR1GNU/lWAMHcQpbELkr/FGaQygihj/231at33kaWf7FjlXaXQfjoWvx7kn5iiW9L9rZOq5Sjz15i5rPR73ojJ0UMMmUNBOLdN5xpiUJYM1iotUNFedD04/b06+CY8GPcYwhkwTIl0/iJcDYv1WuwdF+MS6I4cWXQTkOn5Yy7qoBHCTKXPbdDhfYwVseKgs6Zo2tV9FSOrKDCbMN1DOfsjOZQj3+NMSB1gpMN847Y3EKRvEVc9yCURACyfPb0NLh9kCx9Hkl0iQLvvmfoNVNHmqnxkipol0pMxXwtsQ17tD3E=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 307f1469-cb44-4ba6-1c5d-08d6245dcdb6
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2018 09:44:23.1482
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1110
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes for WFA p2p certification 5.1.19 and 5.1.20 failures.

Chung-Hsien Hsu (2):
  brcmfmac: reduce timeout for action frame scan
  brcmfmac: fix full timeout waiting for action frame on-channel tx

 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 26 ++++++++++++++++--=
----
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.h |  2 ++
 2 files changed, 21 insertions(+), 7 deletions(-)

--=20
2.1.0

