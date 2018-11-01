Return-Path: <SRS0=HAyh=NM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0B58C6786F
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Nov 2018 16:45:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8615620820
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Nov 2018 16:45:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="vEbOvElL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8615620820
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbeKBBtG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 1 Nov 2018 21:49:06 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:22178 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbeKBBtG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Nov 2018 21:49:06 -0400
X-IronPort-AV: E=Sophos;i="5.54,452,1534834800"; 
   d="scan'208";a="19785005"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 01 Nov 2018 09:45:22 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.107) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 1 Nov 2018 09:45:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tvwY2TF2xBuIx/3ncGO5v2vJYnDp27xwIM1PwFfXb0M=;
 b=vEbOvElL19Qb9xqL/K40Y2cYJO6UiDnH5a/Xf/4BI6vHRzk1cEQFkW4N/GDmCfE1xeiwMY2iTMNfxmlkUzohYoTzJet60vbUAk5aqyqOCOePTb0OGszmFtym9aw9AeZOp2usCDt71I1yMwdErG4Z+pnSQJPH7KOcOEiF9N+zqKU=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2582.namprd11.prod.outlook.com (52.135.227.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.24; Thu, 1 Nov 2018 16:45:20 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7%6]) with mapi id 15.20.1273.027; Thu, 1 Nov 2018
 16:45:20 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 6/8] staging: wilc1000: remove unnecessary MAX_STRING_LEN
 macro
Thread-Topic: [PATCH 6/8] staging: wilc1000: remove unnecessary MAX_STRING_LEN
 macro
Thread-Index: AQHUcgJGupyF8amde0qk/GtebEujZQ==
Date:   Thu, 1 Nov 2018 16:45:20 +0000
Message-ID: <1541090691-31928-7-git-send-email-ajay.kathat@microchip.com>
References: <1541090691-31928-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1541090691-31928-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SG2PR06CA0138.apcprd06.prod.outlook.com
 (2603:1096:1:1f::16) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [49.205.219.12]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2582;6:2SXgEVLx9XmfgfLHcHh7GJtrHQE7S3GeaBDqi/jjqyLqXeidjwrKBrAyKZvsu6YQgJ5lEf/eCZt0k7rpiZHfzP47Q7UNl+U4hbSAI/RaHSW8vG+NIV8xsGHCjSbcGfCdUo+cqCHH+TuNz56GRpl0QEy28YvNL0U4RCeMDUwI6M65ZYhUetYGIs9O67E3PlUsqbgdkoBtMmzH/7DGXlzPnnj6+qGelL/eef2r+YgqpOo7cghW2PYiq4v5eI0Bh1biSSvx1LmrwguUGrO3OfowpXWO6jWPffZ/n6FDePvEwsD8zZ0fiqaY50wgsfV4LE8VgMJwkqu7F5Y09ZuzzJYgPGkXOMfOppaH4vcK/wYXACVDB9dKO1tAOZ3wVO1KZlXitU+nfDLzp48wg0mpNKS/r8ip2Q1N3XaU3VbxnlMM0d6zVZiyE/NPQr1uv7Fsw1GO5F3rzAVLY3kwrMOeGeMcpw==;5:AhREf/e/WEKU1js93Q2gfsdzpYWzpqz8iqzLT2+LtUJ9st/k/TbfblImZEKrxDZBqK8zfGxhnBMYbRCaBJU9Gd/Cq3R12r+M2VoxEbGR6WcQVD7Cmwfr7TqA9SHrpJf54UXHDwO9pWXVdu6Aih8n0Vsa/O8R7XFGXIlCAO11roA=;7:806BLfudMS9mq8ug1fGgBbe2Iq5Kor6fIMwglXXymlI+z3FVdX93m6egOvb8F6FWxFTthEApMxo7ayNlQMMDi5MM/tX0/yRYcc1KhkRnWY7I4Kj8BYU/EKuYpDjVt4eFxLVg4jjiW0m7huydsU3Kuw==
x-ms-office365-filtering-correlation-id: 36d198d1-27ca-4140-c411-08d6401968d0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2582;
x-ms-traffictypediagnostic: BYAPR11MB2582:
x-microsoft-antispam-prvs: <BYAPR11MB2582041C4B2AEC2D354B30F1E3CE0@BYAPR11MB2582.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(10201501046)(3002001)(3231382)(944501410)(52105095)(148016)(149066)(150057)(6041310)(20161123558120)(20161123564045)(20161123560045)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB2582;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2582;
x-forefront-prvs: 0843C17679
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(376002)(346002)(366004)(39860400002)(199004)(189003)(68736007)(6916009)(8936002)(7736002)(2906002)(81166006)(81156014)(186003)(3846002)(6116002)(4326008)(5660300001)(54906003)(26005)(316002)(86362001)(2900100001)(476003)(36756003)(107886003)(25786009)(446003)(11346002)(66066001)(486006)(8676002)(305945005)(78486014)(5250100002)(2616005)(386003)(6506007)(102836004)(2351001)(53936002)(97736004)(72206003)(14454004)(478600001)(6486002)(71200400001)(71190400001)(6436002)(52116002)(106356001)(105586002)(5640700003)(256004)(76176011)(6512007)(99286004)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2582;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: MmWO72h3xJrOHmYFUVfJGmBAMlr1zTfQVY1Tnphq3VmwnXLojc0+UodOtyR9bpovMn04gSAjQW6K2VD6dRMWkZh5VI5035OunS3/jeHKbZ2qOgSOhQvIzrq/g/E94xmhmWTAma726+UkSDXrNpZNgYz4Kn1oGFPsg4r+MJ5lF/M371/2qKAyIWRSQbeLsshGooMbMHg6T336pZs1rd07U4eAqFRhiK3feDQA9eT2l2lCgaCjofZjKqMQNfWTTwFcduPybYb4OAgnY7pBoqs10DEWooNNh6AbdwDchvEMsGebwKU2G1AfpkJagfKqZXGNdEulsO/IA/skZAqP0DefZgEW8OLJtSKdEFwORw+8s8w=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 36d198d1-27ca-4140-c411-08d6401968d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2018 16:45:20.1739
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2582
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Cleanup patch to remove the use of unnecessary 'MAX_STRING_LEN' macro.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/coreconfigurator.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/=
wilc1000/coreconfigurator.h
index 71a9f27..a1347f7 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -14,8 +14,7 @@
 #define SET_CFG              0
 #define GET_CFG              1
=20
-#define MAX_STRING_LEN               256
-#define MAX_ASSOC_RESP_FRAME_SIZE    MAX_STRING_LEN
+#define MAX_ASSOC_RESP_FRAME_SIZE   256
=20
 struct rssi_history_buffer {
 	bool full;
--=20
2.7.4

