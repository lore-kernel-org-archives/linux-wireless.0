Return-Path: <SRS0=RZRw=QM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C006CC282CC
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 07:15:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EA912081B
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 07:15:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="d7kjfZpj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbfBEHPy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Feb 2019 02:15:54 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:18918 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfBEHPy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Feb 2019 02:15:54 -0500
X-IronPort-AV: E=Sophos;i="5.56,562,1539673200"; 
   d="scan'208";a="27292481"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 05 Feb 2019 00:15:53 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.49) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Tue, 5 Feb 2019 00:15:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gdvtgetk+wRTZgdewoJhpaIeSsbqUcri9L7kv32NukA=;
 b=d7kjfZpjW06lwY/56HFv91Jss13FhJPIHn07MsnyUgAloBh8J/Bfa5n9zVjGdhXIbYj24iTPgQcyOuysdWGuat+9isV8wc0M/OKNBLI+EuVB2bYx9/iy7DHwBrfeeJCfMEdzfJ3X5mn+n/cf5qOknetk/i+uAQ4tPv3KRj3QZr4=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2982.namprd11.prod.outlook.com (20.177.224.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.20; Tue, 5 Feb 2019 07:15:51 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1580.019; Tue, 5 Feb 2019
 07:15:51 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 07/12] staging: wilc1000: remove unused struct 'add_sta_param'
Thread-Topic: [PATCH 07/12] staging: wilc1000: remove unused struct
 'add_sta_param'
Thread-Index: AQHUvSKgza2kxws0nEuC2mBx7THKEg==
Date:   Tue, 5 Feb 2019 07:15:51 +0000
Message-ID: <1549350913-645-8-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2982;6:xQ3N5rPIatlD/zpDngT2xxH/1+cZsW4+zDs0sjJQBPaK3ra/QRNMWu/2107HZXDNgbUHJ3gKrbtEnjFURjnqSJX2u8OAPKxXc8bG3DJLmhBuFtY3z6sA1tc9A8g8yOYzTkfuih9dow1P1ngVt79+G3yTTdnVML2nO5+76E7j+NwOBjCVXP92zD478yPlOFA8z48cDdOEh9SmUlYttFNEm/1sZ1fj+YC1MraFIDBHeYTGhC8IxwpiC4rMmyikE+5Y1lTF/Jgv0niWnQglI0iUXy1gJ+JqYYpnrwO8ROeiW2IgDWirDuggVQSVY+jMwExCtHRkvQ1QpxcpK63qxHFZkNfVxsAhs1TmqZsj8GoFborD0mge35uc7NqTLB7ksZxgOX5l5eBBXn7EOqnqcIptkpXAwSKy1etpSu6glkQiLEDnr8wvY6/tJZZtDfFRnxE1CqTAhMmEOAD925P+LE7yVg==;5:Dg0JHLtqbYv/9a/4RgXuxcDanfPx6fYsM3upUs3rfMKfFXGP6z2RKtwhb69CY3c3KdclpuHEoO5PifS4BBSTk6c1c8czwfLpLVKSMiG7bnMTaE4BiyDb2i6b44KortNuJ2FV4q0U/ilcU56bLy8RhjzImyMcb3UdvfmrLbwveFlT6BcKUn2rwMQx0SaUD11jS2jG5Km1Trf638HhBVX0cw==;7:GroXy5iUkBNYoJCdNJaPVTILdVHZY4UnYUg4+ea5SDYji2KLCkHr4rfa/A6dHvqwE3iZ/siCF/7uIW9INaUXvaQ6E97DZBbacjQCx1KaU9ih5H+dqIj8R/LbC8H31IZ9t82Tb429XwP4UZ7Wnjj+lA==
x-ms-office365-filtering-correlation-id: 4fc0af4a-a3a9-43a9-659e-08d68b39c265
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2982;
x-ms-traffictypediagnostic: BYAPR11MB2982:
x-microsoft-antispam-prvs: <BYAPR11MB29824D2766CB59270B275024E36E0@BYAPR11MB2982.namprd11.prod.outlook.com>
x-forefront-prvs: 0939529DE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(346002)(376002)(366004)(396003)(189003)(199004)(478600001)(36756003)(305945005)(102836004)(6486002)(81156014)(76176011)(81166006)(71190400001)(5640700003)(6436002)(186003)(14454004)(99286004)(52116002)(11346002)(386003)(446003)(26005)(2616005)(476003)(256004)(8676002)(6512007)(316002)(6506007)(2906002)(53936002)(54906003)(3846002)(4326008)(25786009)(2351001)(106356001)(6116002)(7736002)(486006)(86362001)(2501003)(68736007)(50226002)(66066001)(97736004)(107886003)(105586002)(72206003)(78486014)(4744005)(71200400001)(8936002)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2982;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ypShLWwcu6+oZbteMF5Up6xD+lDpmLHw7mgs+qE0I4T4KTNVVfC0ICyUyTEWcU1Linr6E9SRdVCpnqSAuKu3s2uO0XiF8juDdiDKxsEiSwnt9326AsT6Mi2LMopp2l9R3Vfw1u8T5I9KBViCUQglAgkrYP8/sD/t1eg+Eszj8VU5WWrNLsG4YZZiVz9GxuJ5cc6iKdqLDgFU0+F2WH8S6TJzQ/0NKjRpNOzL80JThG6Wb9jin2e15S9Vl9qhCSB2GOP3WLVdEz4w2/ujL+Vvxt6fG+uLk03VR2AHQqOmgT8eC3HSoJwQMCH2iQyzf92I5tou58ElSfbjTSmdSoiYiEpsxNZAlrrFpdiaVtsUCNSqhCuCVpPYHMgxsTGpKmPjXemIqkfv/2v4VBtkX6YDVSP8rjq+dxS9IeYzzlIzp9s=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fc0af4a-a3a9-43a9-659e-08d68b39c265
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2019 07:15:49.1342
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2982
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Remove 'add_sta_param' structure as its not used now.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.h | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index 994e641..790f83e 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -170,17 +170,6 @@ struct host_if_drv {
 	u8 assoc_resp[WILC_MAX_ASSOC_RESP_FRAME_SIZE];
 };
=20
-struct add_sta_param {
-	u8 bssid[ETH_ALEN];
-	u16 aid;
-	u8 rates_len;
-	const u8 *rates;
-	bool ht_supported;
-	struct ieee80211_ht_cap ht_capa;
-	u16 flags_mask;
-	u16 flags_set;
-};
-
 struct wilc_vif;
 int wilc_remove_wep_key(struct wilc_vif *vif, u8 index);
 int wilc_set_wep_default_keyid(struct wilc_vif *vif, u8 index);
--=20
2.7.4

