Return-Path: <SRS0=RZRw=QM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80D65C282CB
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 07:16:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50F552081B
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 07:16:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="jO9xAyPo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727572AbfBEHQI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Feb 2019 02:16:08 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:26935 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfBEHQI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Feb 2019 02:16:08 -0500
X-IronPort-AV: E=Sophos;i="5.56,562,1539673200"; 
   d="scan'208";a="26323443"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 05 Feb 2019 00:16:07 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.106) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Tue, 5 Feb 2019 00:16:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1BTP8tXWIxOrqmI4HruCkIGA5KpEVacVUbjcJpqs8W4=;
 b=jO9xAyPoV/eUF5y+4UhoMoElhxnWbGWiZ34h0bIb4kZMEXApZ7yg0v7+i5VmuN0oQm4/szlu8/Y08DOLMvjSMrMJw3x1qjyC4DnqM2PsgTgJz/FaNPnDhG97kraR6pDMhmNY0ca/QsC1V+yOT1yRWu+uzsSN0KncefRWkuSGZgQ=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2984.namprd11.prod.outlook.com (20.177.224.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.20; Tue, 5 Feb 2019 07:16:05 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1580.019; Tue, 5 Feb 2019
 07:16:05 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 12/12] staging: wilc1000: define p2p related static variable
 as constants
Thread-Topic: [PATCH 12/12] staging: wilc1000: define p2p related static
 variable as constants
Thread-Index: AQHUvSKobv2cAy9GF026f9awEGfvLA==
Date:   Tue, 5 Feb 2019 07:16:05 +0000
Message-ID: <1549350913-645-13-git-send-email-ajay.kathat@microchip.com>
References: <1549350913-645-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1549350913-645-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR0101CA0066.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::28) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [183.82.17.42]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2984;6:vRUpNt2VaujOhB25zYON3KGLS0zAy+Co4ZIZwI9b2f0tTH/S1HlJpIwDl4qFnJSIkRypFtl37o6r2+WpsX+/ZhvQS+Yd/sHsmI7r0TEjR7TbIPUMfVzV2XLw2MoU8AnffB50LaXCnGHR4WvsXWwe5Qm1TDMdz9p8e39wsDZ4+PHIEHNVmlV0DqUCSm1TZrB79XdnwgCeo6G9427hRx2ITrIG99UMeQn8PxMvVW9hhzeKOxf9IwF+j16DzskCdWJh2qY45nbrSWinjpF4YoZfl/9bveTPRWO3xN2uSW2Db9fRo5vnKPZCczynwNpQb3f0WMgclHn/x9YRLDlu+94lo92eKasooXinvRF5GhkSLIkfdPIgSn/kV9RQ4T1+8L5ZWd6cigSAE8L/ZNMfay7V9JmscYkYH+3FxKsFy9yfIeen0rI8KAo5hAw7pFITkvOTJSKa/8o9B7bGgCJfV3shdg==;5:Q4ccKuiQUvcIRpHXSo23W8cxlDRI5i0ouWudKBY0PP1X3QUjY4vLO0pUMiB1CpNAdmV/Ja9imEzxaLzuKfoEcJtqnrJVNNaUZLCDfJmrfK5nxi1r7i7wzTHxZMrlMsHyaEhWAkyckxPz2aTXQUKddf8AvlrJTPkmpsOhlv/ussy2b/1+OXlUAZFyECBR4dhJrq7CoL0BAkgC9QJk0O0ghA==;7:INGQOhMRfwOiMgtygSIi0sdEZr4TDWBJQksxjIDY1YnpRiJh40BSBygiyYFtK/XZ2uPzHgEOlS52B3z/gLI1X6jzSoVp8tnZi4HP7+BoTuZRUn4646rWtm5kHqXTdvRXNbGuz0Gb3AQuCFldauIXKw==
x-ms-office365-filtering-correlation-id: 1325cea4-1672-48ae-6b82-08d68b39cab2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2984;
x-ms-traffictypediagnostic: BYAPR11MB2984:
x-microsoft-antispam-prvs: <BYAPR11MB298496502D183F43834A6A7AE36E0@BYAPR11MB2984.namprd11.prod.outlook.com>
x-forefront-prvs: 0939529DE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39860400002)(376002)(396003)(346002)(136003)(199004)(189003)(4326008)(36756003)(386003)(6116002)(3846002)(102836004)(14454004)(68736007)(97736004)(11346002)(78486014)(316002)(2351001)(5640700003)(478600001)(25786009)(6436002)(4744005)(53936002)(71190400001)(26005)(71200400001)(6486002)(106356001)(72206003)(6916009)(446003)(8676002)(105586002)(305945005)(6512007)(186003)(6506007)(7736002)(486006)(476003)(66066001)(2616005)(8936002)(107886003)(52116002)(81166006)(81156014)(76176011)(2501003)(50226002)(256004)(99286004)(54906003)(2906002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2984;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NBDFq97VYafOeDZWarkgwUWvD0WttqHysleNpxjP3WA6BMSeUIgfRZFJTedq0oo63yUwSkJwtB+FlxiF8fYu8dd5ng8CDrHdH1YauPGL91JHA/ahm3aFFkc5kzWorqkm56MevpDsvHxDRdwhpUQvH+nCkhvcgOHf+dHBXLXbMDsx/tmoyIr2RfMq/Zz9rwFy/b99DW0U3672MQzdfErXoUdVy1jqPdbB82CbH9hx8JcGb+1ffAG+pkSbcq3YbSIwD4Bh01hIgALtMyDWGvBYfcoaM31n7G1yCPAOzXsW1bP9XLBsUCR1kEOoyH9lyGH+kca2mWa+lyHT2OF+J9PQULjNKG5rD5JIxc8xOHFZ67n3gGb8/oq5V8WZNrqJc8SoRevr5AsgChtFyWMu1AZpiW7htthQPUrsG1YM1BgW85g=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1325cea4-1672-48ae-6b82-08d68b39cab2
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2019 07:16:02.7165
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2984
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Add constant qualifer for 'p2p_vendor_spec' & 'p2p_oui' static
variable because they are treated like constant values.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/st=
aging/wilc1000/wilc_wfi_cfgoperations.c
index dd1fe3f..8fb4bd4 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -67,8 +67,8 @@ struct p2p_mgmt_data {
 	u8 *buff;
 };
=20
-static u8 p2p_oui[] =3D {0x50, 0x6f, 0x9A, 0x09};
-static u8 p2p_vendor_spec[] =3D {0xdd, 0x05, 0x00, 0x08, 0x40, 0x03};
+static const u8 p2p_oui[] =3D {0x50, 0x6f, 0x9A, 0x09};
+static const u8 p2p_vendor_spec[] =3D {0xdd, 0x05, 0x00, 0x08, 0x40, 0x03}=
;
=20
 #define WILC_IP_TIMEOUT_MS		15000
=20
--=20
2.7.4

