Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEFE1C64EB8
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 09:56:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 745352086D
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 09:56:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="KgnUa5HB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 745352086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbeJHRG5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 13:06:57 -0400
Received: from mail-sn1nam02on0089.outbound.protection.outlook.com ([104.47.36.89]:36736
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726354AbeJHRG4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 13:06:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JUj2P1ewoAHfnsEar0QH3/5CRoQfd/y/tqhgUS1Comc=;
 b=KgnUa5HBr/NSAWRlehs8ITdUdc2fH9kjCKnD0iKKrceWp0EHXRnLFeOuhj781cyqs/2+8x/QZVapNYlH026RHjDM4S83IqeyelIss+AhDgC+yG9CRYUviPwbVK9bQ7UUwx4+/U7u9mMkJirYyrON76kSNTZKKZL4ygt3OXacwzY=
Received: from BL0PR05MB4595.namprd05.prod.outlook.com (20.177.144.212) by
 BL0PR05MB4642.namprd05.prod.outlook.com (20.177.144.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.16; Mon, 8 Oct 2018 09:56:00 +0000
Received: from BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::e4b8:995b:1c73:657a]) by BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::e4b8:995b:1c73:657a%3]) with mapi id 15.20.1228.020; Mon, 8 Oct 2018
 09:56:00 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 1/5] qtnfmac: use 'help' in Kconfig
Thread-Topic: [PATCH 1/5] qtnfmac: use 'help' in Kconfig
Thread-Index: AQHUXu0eKaIiFUM0KkmSF+vQQjmAXw==
Date:   Mon, 8 Oct 2018 09:56:00 +0000
Message-ID: <20181008095551.18651-2-sergey.matyukevich.os@quantenna.com>
References: <20181008095551.18651-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20181008095551.18651-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR02CA0023.eurprd02.prod.outlook.com
 (2603:10a6:20b:6e::36) To BL0PR05MB4595.namprd05.prod.outlook.com
 (2603:10b6:208:5f::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB4642;6:MxN2BNo5Gj9rvkYYPfyUJa8GDmJTYZnlEIRXOaC3P1RpUXdbJ125KDMpcxyUwrDjK38GFMfrVfvGdolYeL9F06ATmZF3rFVxt0uYnY/ctmsAs8wgoVBKrjQIPOSEy0Hb38RYOtHW1zojRNFTY20OJ6Ri5/mIHGuuS+YzGJCCUKDzWF+M0TE93LihMMevOCUz0V9QLLnnasXYWHavc9KVD0THOGeRsix55iWxC2qHRLPs3q/k2LkZeMXutRFZJyfgLzxUzjyWr/hKaRa5MTJWclH3vB1bjqFLtWIisqO7dH0g8imngEqtcahrhB+AGEJVAdbqYwrZnfw0g3/N1J4OPnK6XCTabjl9OEDLMo0pcf0BwPZgZ4eP4MvBRzQvR8wpoPT+uJL+DCH0F/UnblbYzduHC68CcMdrU0Oa8W5K321exLx1IK3bVkrsL/NY6nJNo/AZSeP7FFPQbBQCTbkjew==;5:/O8qAb8onbh9gORH7XDjF5Zh2TRsNEzE/giIS/Rt61qeoZQkbblRtHw8FEjJ8RXAEhYkOEh9bOLT2Z1G9V7lJED0a/UETdCyaExqFsH0FGCJgELz/5YIOyf/u3TY8ZYPEaNcZzEVrgmRtTp5ohcovxhw7JH+sVFdvAlsVORRzV0=;7:SQQ94A155lXrtklRvfp5GfWt4phqmNZ9rEZnB/vV79gSQUcZeWmPay9m6dWgRr8LTfLlAyXPr+5JtZV2Hx6wJLD+JHpPqJWEuNoGHrdSRC5WhV/M+XNejPpyvxVtAkWymk55V5T6nWIdX/M36eJ44LnGvPAkhSIgoul71FVh/1AJgX6W0bGzOCt1GC+DJ2FjpqyE217DWtiwe0BYFfJUfL1VduMjhFoSGY551WKNEmGyKkhAcilOEj+l5cZtONkW
x-ms-office365-filtering-correlation-id: ff608974-b241-4318-f728-08d62d044061
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB4642;
x-ms-traffictypediagnostic: BL0PR05MB4642:
x-microsoft-antispam-prvs: <BL0PR05MB4642D8FF8F7692A52A88DF95A3E60@BL0PR05MB4642.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231355)(944501410)(52105095)(10201501046)(3002001)(93006095)(93001095)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123558120)(20161123564045)(20161123560045)(201708071742011)(7699051);SRVR:BL0PR05MB4642;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB4642;
x-forefront-prvs: 081904387B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39840400004)(396003)(346002)(366004)(376002)(189003)(199004)(105586002)(486006)(68736007)(2351001)(5250100002)(386003)(316002)(2501003)(446003)(2616005)(5660300001)(6916009)(103116003)(186003)(14454004)(14444005)(53936002)(102836004)(11346002)(3846002)(256004)(305945005)(7736002)(2900100001)(8936002)(106356001)(107886003)(26005)(1076002)(6436002)(54906003)(76176011)(478600001)(6116002)(6486002)(81156014)(25786009)(99286004)(8676002)(81166006)(476003)(52116002)(5640700003)(6506007)(71200400001)(6512007)(71190400001)(2906002)(66066001)(4326008)(86362001)(36756003)(97736004);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB4642;H:BL0PR05MB4595.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: ibmjERMrFQtRQZEBcmiFvTlpSIvuGFodRqjyUjZHuw4N3/Y8vqR5Pb13FFFfLIep8/eOtlZj4BS5z2oXEZzmVkF62li97DwHd8ov12yTmORfPY/5+0SXf22xPekK0XIqXfvkwmADDXr9K8d5LNABvlPlXjgCmrdDc4LoSz8iivtMSmxBbMiGmJS770CsPLt57f+DXpu9ij8ev0Cw38upyUrbPMj/ha/P3GfuiQduQffrDP2reFpzA0q1P+E9ir9FZCbQSLNqQ9cy3pEF9RVSRJFIe9eFx1injD/9VMsyZpx2kX5GTKSW7TucPFALTYkJ26QaZvNpZqB+fefi0JrOKnzFj79CURkTtbenRZklskk=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff608974-b241-4318-f728-08d62d044061
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2018 09:56:00.8722
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB4642
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix checkpatch warning: use preferred 'help' option in Kconfig.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/Kconfig         | 2 +-
 drivers/net/wireless/quantenna/qtnfmac/Kconfig | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/quantenna/Kconfig b/drivers/net/wireless/=
quantenna/Kconfig
index de84ce125c26..7628d9c1ea6a 100644
--- a/drivers/net/wireless/quantenna/Kconfig
+++ b/drivers/net/wireless/quantenna/Kconfig
@@ -1,7 +1,7 @@
 config WLAN_VENDOR_QUANTENNA
 	bool "Quantenna wireless cards support"
 	default y
-	---help---
+	help
 	  If you have a wireless card belonging to this class, say Y.
=20
 	  Note that the answer to this question doesn't directly affect the
diff --git a/drivers/net/wireless/quantenna/qtnfmac/Kconfig b/drivers/net/w=
ireless/quantenna/qtnfmac/Kconfig
index 8d1492a90bd1..b8c12a5f16b4 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/Kconfig
+++ b/drivers/net/wireless/quantenna/qtnfmac/Kconfig
@@ -11,7 +11,7 @@ config QTNFMAC_PEARL_PCIE
 	select QTNFMAC
 	select FW_LOADER
 	select CRC32
-	---help---
+	help
 	  This option adds support for wireless adapters based on Quantenna
 	  802.11ac QSR10g (aka Pearl) FullMAC chipset running over PCIe.
=20
--=20
2.11.0

