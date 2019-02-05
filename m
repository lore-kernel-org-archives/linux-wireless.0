Return-Path: <SRS0=RZRw=QM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C5B8C282CB
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 07:16:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 697402081B
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 07:16:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="GHG4SCtJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbfBEHP7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Feb 2019 02:15:59 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:39565 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfBEHP7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Feb 2019 02:15:59 -0500
X-IronPort-AV: E=Sophos;i="5.56,562,1539673200"; 
   d="scan'208";a="26155325"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 05 Feb 2019 00:15:58 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.105) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Tue, 5 Feb 2019 00:15:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EZQ2PNe3meXnWl0hNKgkqckL+NNFHJaVhcYVkmnwYeM=;
 b=GHG4SCtJnCCkELgjFDG78q39ty5p7pIuVd+mlVrm6whZL2hJ5TnXR04nZIK3iadjff85Qn2aciWpfEX5JnNIYv55Cpl/NPUhPTNgBB+wv/6FAzowHA7S08yXRX+MVH7szUlf8orJAg+IoU92ZUJ8z8d1PIV5NuFg5B0eB5dLphI=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2982.namprd11.prod.outlook.com (20.177.224.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.20; Tue, 5 Feb 2019 07:15:57 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1580.019; Tue, 5 Feb 2019
 07:15:57 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 09/12] staging: wilc1000: avoid use of static variable in
 linux_mon.c
Thread-Topic: [PATCH 09/12] staging: wilc1000: avoid use of static variable in
 linux_mon.c
Thread-Index: AQHUvSKjXIoZopQ6pUaZdt1u8kkEDQ==
Date:   Tue, 5 Feb 2019 07:15:56 +0000
Message-ID: <1549350913-645-10-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2982;6:dRGgzpkC3bp2trmutTLn8HjSxqr2CLik9BvBpzyiRR9LJvu+1w/n858TgBiiFuio4YKiV/ICDpDYxsfek7fZj1DlgKfMQkWQwhNyh2OtLyi95Dby9YE4+JkUt5oM6CQlIg+kLH4zI6jIzwJr/ftkhg5mmT6n5je8J9RyOG4kVhqGmOu9Jf30VtYa8w4C2D5Ld7VKgvhsMvm1irH6oNegS6JdF2GwZUN6fCSysVNmdCh3eos1eQtS7Y/qq6qFh1axGZ3/TboTxM295w1JjZluK3dHx9kz7ov46ZybMonlumnl/6BGMGZoD1WdLRRGrUokvrMP2LTZ2xCxwoAiikv3QnhU4TW+9KrBihqqtzRUpFY2zKEyDATUdrjkD6c1Qj5lzRaR0WSI3r1mT9HrPCHdtKJdqZqE4G/+WUZgjf1K+netyscCOBmo9jmxhkRevdb1fclaD4dSgQ4YaQpuNesJVQ==;5:p5gRHF2XfV+EEEANan0Kj9r5ALEHNkukI0Eu17z0g4cY8radNLdnIw110Dwf8zr7qII8XEHxBGMMNh0roOsh8aPF2LnCNpwKMkkArmFFk61aiv9lsuWOY84x48zYKJ7SecAX2zZRxvy3AaTTEBFDm5XRLgLZgR00GruLgcAWS2nCoj/fdAIQk6OwvtICujic5l34vG38fA6sTic7+t7L3w==;7:pd2YKca3tcixOnCoDZuXARy7CQNKwsZSlTC3At2fJTGOZfU2IjMIYkzj+27IAmv2Bpt96cSe4JZBvzGpeZu3BH2lO970tehEC2XsrLrNaNxFhbd6cFTdLtOO7fZDlzf8bK4fvx83hjKnm+J6xtuvbg==
x-ms-office365-filtering-correlation-id: 42ccfa08-7e5f-418c-bc5e-08d68b39c5c2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2982;
x-ms-traffictypediagnostic: BYAPR11MB2982:
x-microsoft-antispam-prvs: <BYAPR11MB298279DD75B5088D56B11A98E36E0@BYAPR11MB2982.namprd11.prod.outlook.com>
x-forefront-prvs: 0939529DE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(346002)(376002)(366004)(396003)(189003)(199004)(478600001)(36756003)(305945005)(102836004)(6486002)(81156014)(76176011)(81166006)(71190400001)(5640700003)(6436002)(186003)(14454004)(99286004)(52116002)(11346002)(386003)(446003)(26005)(2616005)(476003)(256004)(8676002)(6512007)(316002)(6506007)(2906002)(53936002)(54906003)(3846002)(4326008)(25786009)(2351001)(106356001)(6116002)(7736002)(486006)(86362001)(2501003)(68736007)(50226002)(66066001)(97736004)(107886003)(105586002)(72206003)(78486014)(71200400001)(8936002)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2982;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: YtO5+j88maiKkvT9qVke5QzaqJZ3Tb/VM4bu1CWbZR73Qb4XkHDjFra+OlfOzQQSdb5K97dTnq5Vi2PdxcvFOfhT8Bn7vHg9m7P/5xx7bfDfV0N99pfMESgsKU1t4amwNr9dj23WLW/vZiXL8nksNnEajeY72BmgXREzgaA6LrRlf5bRX5OkBKuggEw7rdGGEKaFrWf1JrkOZvAv3YJ0wuxBN0aqRScTtZmzvZcqOraZIXYbDQELOQhXQjkDYodeS+WgpIMzteTRXPq7hIPH9pztdKHITkl+YrzA5Tn0Ber7E1GpIDMBuk9RmJEzcCVvZEXmfQGu5s3eK4iBOvnUQFqHRW+IYB6MeX/pP/zi9rSh7wmKTVRwQa+/gWQdgxeXXqwqjW/JcL28Pvl1zw1qojSpiVnGV1O2n1d4uHhvejE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 42ccfa08-7e5f-418c-bc5e-08d68b39c5c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2019 07:15:54.7331
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

Define local variable for 'srcadd' & 'bssid' static variables and use
ether_addr_copy() to copy value into them.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_mon.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc100=
0/linux_mon.c
index ce37b6f..9fe19a3 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -18,9 +18,6 @@ struct wilc_wfi_radiotap_cb_hdr {
 	u16 tx_flags;
 } __packed;
=20
-static u8 srcadd[6];
-static u8 bssid[6];
-
 #define TX_RADIOTAP_PRESENT ((1 << IEEE80211_RADIOTAP_RATE) |	\
 			     (1 << IEEE80211_RADIOTAP_TX_FLAGS))
=20
@@ -150,6 +147,8 @@ static netdev_tx_t wilc_wfi_mon_xmit(struct sk_buff *sk=
b,
 	struct wilc_wfi_mon_priv  *mon_priv;
 	struct sk_buff *skb2;
 	struct wilc_wfi_radiotap_cb_hdr *cb_hdr;
+	u8 srcadd[ETH_ALEN];
+	u8 bssid[ETH_ALEN];
=20
 	mon_priv =3D netdev_priv(dev);
 	if (!mon_priv)
@@ -193,8 +192,8 @@ static netdev_tx_t wilc_wfi_mon_xmit(struct sk_buff *sk=
b,
 	}
 	skb->dev =3D mon_priv->real_ndev;
=20
-	memcpy(srcadd, &skb->data[10], 6);
-	memcpy(bssid, &skb->data[16], 6);
+	ether_addr_copy(srcadd, &skb->data[10]);
+	ether_addr_copy(bssid, &skb->data[16]);
 	/*
 	 * Identify if data or mgmt packet, if source address and bssid
 	 * fields are equal send it to mgmt frames handler
--=20
2.7.4

