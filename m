Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3409C282C4
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 07:13:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74A3D20863
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 07:13:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="Ybt0rgvv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726914AbfBIHNE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Feb 2019 02:13:04 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:9354 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbfBIHND (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Feb 2019 02:13:03 -0500
X-IronPort-AV: E=Sophos;i="5.56,564,1539673200"; 
   d="scan'208";a="26492097"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 09 Feb 2019 00:13:03 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.105) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sat, 9 Feb 2019 00:13:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f4ImsrsjI5q3T6kpKzgUx+dAympGzzrCuc6cpgFOuTI=;
 b=Ybt0rgvvOZsyeSvKysl1XkEa/tFr2Kl5meaKvfYin1PlZAse9PT49lYEIRlvduVv3OWerBnUBdVOHuD0Oj+KO0j/fRCuqJfpoOBSrno3TJD6YtIxlZojcePgn7WHLLKrZfD1J9rPYc+X7gc/RmY7QIILflFsIQlbC0RXW1dtVyA=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3077.namprd11.prod.outlook.com (20.177.226.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.22; Sat, 9 Feb 2019 07:13:01 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1601.016; Sat, 9 Feb 2019
 07:13:01 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <kvalo@codeaurora.org>,
        <johannes@sipsolutions.net>, <Adham.Abozaeid@microchip.com>,
        <Venkateswara.Kaja@microchip.com>, <Nicolas.Ferre@microchip.com>,
        <Claudiu.Beznea@microchip.com>, <Ajay.Kathat@microchip.com>
Subject: [PATCH 15/16] wilc1000: updated DT device binding for wilc1000 device
Thread-Topic: [PATCH 15/16] wilc1000: updated DT device binding for wilc1000
 device
Thread-Index: AQHUwEbkimKUPiXbOkGqWtzYyCKj4w==
Date:   Sat, 9 Feb 2019 07:13:01 +0000
Message-ID: <1549696298-9795-16-git-send-email-ajay.kathat@microchip.com>
References: <1549696298-9795-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1549696298-9795-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR0101CA0021.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::31) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [183.82.17.42]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3077;6:dj5W21B+dIpB8GDi/tO/0w2BkenJshdOnN8oICTtzMv455hCXusomVDPr4Ikil3qgJ4GA0Vn5kHCUCROORJusKVSIVGMRD3zVB5FFJGOJsZ8SwmV84U7RaMFhMk6vdZuRP2FnbfBduJ0ONIQ9/yvXq6a/0tLzOmdDPIbdsR4fLDPXwUL0CNApzHrzKUbe0MdMC0jLuVpUB91VPz1/C6x6+2CcIDzw6m6MTBpYhKjsyNgyzu5t7z/0VPVP6iLAiwL7bss3JroBQkoySgWbxn0JbejJMHrPT1YpcrcQ8GXwwVWm3+qURilj3FTa175J6R8gX0XImOVKxw6Q9ua9e26pxLRJ9Cmp+OrDamiorhar74At38fClpwuriTRRVYgfHqhwDWGJAG6+8Fr/OI1l10PILO5QG7oXgmIuBNpTt95FMJKegFmO9bx3AosTFtYGBXdHVJDLoHllrrGieFG9K7sA==;5:CfhdxKx9O20QytcD3c8eC56neyg/gSvyEa/pKYlfu3P/X66AkbAtCd+WJgM7pf27OrVZYc3zEqAQ2PSPfyj2HTrPexmYhcqUqvzydoJTT5280eRPIy6qg4QqHT6313ebEfE9ny7rwKEH4/htNPmTkpkxuc8Y7zDNfyXcNEZJIw/OIU4SU/YwGrmRG912LCUV+1EBeipedTnL7P0ql8gmfw==;7:1w2mt9gshsTo7Lx8+vjMZL3qnV43VSQ3b15zR1o6xd1snUuASlvfRhOPWnarfWc+NMM7J/VkgOboJrbLhc3GtAKJyLE4+r+RZQC0Qa20PpujL8Rb0pT5OGEeidt134kttYi1pYs3VdDjYGH8ENB4Jw==
x-ms-office365-filtering-correlation-id: 9f599846-2de3-4cbf-ee06-08d68e5e069e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3077;
x-ms-traffictypediagnostic: BYAPR11MB3077:
x-microsoft-antispam-prvs: <BYAPR11MB3077A809016FC0BD9FD1366FE36A0@BYAPR11MB3077.namprd11.prod.outlook.com>
x-forefront-prvs: 09435FCA72
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(346002)(376002)(396003)(39860400002)(136003)(366004)(199004)(189003)(81166006)(8676002)(81156014)(97736004)(386003)(6506007)(14454004)(99286004)(305945005)(486006)(72206003)(6916009)(53936002)(102836004)(478600001)(7736002)(8936002)(26005)(186003)(36756003)(50226002)(54906003)(256004)(2616005)(476003)(11346002)(446003)(68736007)(105586002)(106356001)(5640700003)(2351001)(6116002)(3846002)(52116002)(316002)(6436002)(66066001)(107886003)(25786009)(4326008)(2501003)(2906002)(76176011)(78486014)(6486002)(86362001)(71200400001)(71190400001)(6512007)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3077;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Ius8nW125Q06uW/CQB6/Cx0SY5Y+7TQJyRSB40IPe+jbB04L3vl4WkGWeS1myvorX5Rr0Fvr2vXeRnv9VB4IMRQaTz+HEE5+fscEWBCd4WbdWOgBlnL34GRXD9dp72wheUUt5XrMAVReSIOjhgd8gDWG65W+QC7+Ruj7GBQo4hmx+XTfJIz3cavoBGdyXNw9drU46oPc+7yfe0OGuomVUiWHpQcwpbVyqXb7PzZytSCWmAnw9iYgNy4r+k/cpbSAoZ1jTPv+PGL0goEdlsq06//O6gTY4L+DStehEgLUJ5brPiNpLGOPLwSqp6nr473F+6sXoy/jUcw+6BJHeIsYD71RT6Bvjh/cz2a9eZpuxiE/ETnhZuNko9w/nlA3jQWFBFdH0GOOTg5JigRhV4/YdKLPnltixG/5NqqfVKG/kbM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f599846-2de3-4cbf-ee06-08d68e5e069e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2019 07:12:58.3575
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3077
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Moved the device tree binding document from '/driver/staging/wilc1000/'
to '/Documentation/devicetree/bindings/net/wireless/' folder.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 .../devicetree/bindings/net/wireless}/microchip,wilc1000,sdio.txt         =
| 0
 .../devicetree/bindings/net/wireless}/microchip,wilc1000,spi.txt          =
| 0
 2 files changed, 0 insertions(+), 0 deletions(-)
 rename {drivers/staging/wilc1000 =3D> Documentation/devicetree/bindings/ne=
t/wireless}/microchip,wilc1000,sdio.txt (100%)
 rename {drivers/staging/wilc1000 =3D> Documentation/devicetree/bindings/ne=
t/wireless}/microchip,wilc1000,spi.txt (100%)

diff --git a/drivers/staging/wilc1000/microchip,wilc1000,sdio.txt b/Documen=
tation/devicetree/bindings/net/wireless/microchip,wilc1000,sdio.txt
similarity index 100%
rename from drivers/staging/wilc1000/microchip,wilc1000,sdio.txt
rename to Documentation/devicetree/bindings/net/wireless/microchip,wilc1000=
,sdio.txt
diff --git a/drivers/staging/wilc1000/microchip,wilc1000,spi.txt b/Document=
ation/devicetree/bindings/net/wireless/microchip,wilc1000,spi.txt
similarity index 100%
rename from drivers/staging/wilc1000/microchip,wilc1000,spi.txt
rename to Documentation/devicetree/bindings/net/wireless/microchip,wilc1000=
,spi.txt
--=20
2.7.4

