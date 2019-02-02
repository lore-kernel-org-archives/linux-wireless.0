Return-Path: <SRS0=M3au=QJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 559FCC282D7
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Feb 2019 19:17:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28FE52082C
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Feb 2019 19:17:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="yGKnicNX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbfBBTRg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 2 Feb 2019 14:17:36 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:24944 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbfBBTRg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Feb 2019 14:17:36 -0500
X-IronPort-AV: E=Sophos;i="5.56,553,1539673200"; 
   d="scan'208";a="27205824"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 02 Feb 2019 12:17:35 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.105) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sat, 2 Feb 2019 12:17:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gdvtgetk+wRTZgdewoJhpaIeSsbqUcri9L7kv32NukA=;
 b=yGKnicNXMI/+AFef0ItFug+Rl4MDyNu1jIoeSn1o5znVqtkguLyL2lkLUfgnHQDyzRVqsyQOAXbBGA95yVu0s7IzPryYCTCdB5dNNqQz9SXFeA8bIP9MITIaAODmOKBztCmuu0xl6U7wxp9fx2J6NqNlQ3j5sw+bQklxhWMBIrM=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3638.namprd11.prod.outlook.com (20.178.237.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.16; Sat, 2 Feb 2019 19:17:33 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1580.019; Sat, 2 Feb 2019
 19:17:33 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 15/15] staging: wilc1000: remove unused struct 'add_sta_param'
Thread-Topic: [PATCH 15/15] staging: wilc1000: remove unused struct
 'add_sta_param'
Thread-Index: AQHUuyvy+Uw+43cUVEqr7DQg5P0vvQ==
Date:   Sat, 2 Feb 2019 19:17:33 +0000
Message-ID: <1549134974-5545-16-git-send-email-ajay.kathat@microchip.com>
References: <1549134974-5545-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1549134974-5545-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR0101CA0011.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::21) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [49.205.218.11]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3638;6:VYYcgcVdzy55f8uwcOHElhBDOmr4etLaReC0D72NBOKyxT4g1ZHtJkQ9rNtkYuCLsaJzqKQuSaiAN2p8ETgJfgom8qDTg81e5l9KPDxH2KA2rWRNhMO7jlJBIp1kOIsZEfq9RDbtxnM6lzjsoNLh9Q9aPky0Ebhzb8ihibRU9qaJNGhhImFoTYtkk7ZBQDcZqaVJoe5Q5x95o3X2SjpOiYzXx8V6g9obnCG2bqgH5anQP2W+lZLuiK3c4/7Nm+lk04devof0s8QpqInT3g0kmKclA/NPdAyk6i1EDyGsJGA/0lk8cajoyiHAljPrUgeHYBENiF+x5boC6XxtjCD/xebN/2tF5Moebjw6pAnqojcjJLH84xVzKuqi1B+07RDmCvuPeuRVqmXFtSKIUeic5Mxu0Yjymsk8h8vO4mGU5VsLw69UtcpNsFYAstVw5I4bgMYv8n+wa3DtGj4OJ0DsTA==;5:EAmeRSFvEphaeuRLsVm7xN5oRvOKTz7maYt6lwvGwyQs5fjhzOdFiGCtjkH6Jz2zMzgNRTialZCL3etBY0F+hojC8MDDO+m6MPGhmhDm2Ycis6BZUXgAnINfq7v9XxZM4I9ONipSpNjB96TTQ9gsoTpKamhfoyi17dYyglg2yHEsfvRsZsC1hXRwT8tJo5zp5YRiqBr0ZwyHrOKesiu4Zw==;7:D2yxIxTTSuqMw3qXsjHajy/M9vsJyVeMYqg48UsiItqKg/B/nFF7wAdhfFW2OPd6cESSa5cRxbm+Sq5VtqmWQxF6j/yHyZGL3ZpCKhzFW9FYDPFgCXxjCr9+Ol0U7eRZqG+EMkxGusTuh28+et8KLg==
x-ms-office365-filtering-correlation-id: 41b73abc-cba3-4828-0a56-08d689431527
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3638;
x-ms-traffictypediagnostic: BYAPR11MB3638:
x-microsoft-antispam-prvs: <BYAPR11MB36384972C37335F73C0543A5E3930@BYAPR11MB3638.namprd11.prod.outlook.com>
x-forefront-prvs: 09368DB063
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(376002)(136003)(346002)(366004)(189003)(199004)(26005)(478600001)(7736002)(186003)(105586002)(106356001)(2351001)(476003)(6486002)(446003)(2616005)(486006)(6512007)(66066001)(11346002)(2906002)(14454004)(6436002)(72206003)(71200400001)(71190400001)(386003)(6506007)(5640700003)(2501003)(68736007)(3846002)(97736004)(102836004)(6916009)(36756003)(76176011)(78486014)(25786009)(107886003)(81156014)(81166006)(4326008)(86362001)(52116002)(53936002)(316002)(305945005)(99286004)(256004)(8676002)(6116002)(8936002)(50226002)(54906003)(4744005);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3638;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4Gv9TzVn6HK+IH+Ezv4I91PTkTJo3cBccemYUDO/MxIAc68eKFsrOSVznA0Cbj7xe8hWLieFxZ/BDWtR4OqzzP2MtYfQM/buBpg/umw06krCi2x07yC54B3VPuHAW3wOFZhC8ao17/YNKWbD1Mt5CUmn3gF7wjrEwE7FH+cNpGqhO/cQaWW7M4OXWiEs2XphiZEPcQFASsv6XIw6Ux3Hm0J9r2i+672+xSjX+5bftxBqr7vUV4N7WcGRH8XEGiIDZQFKk2iXugf+PkAZye4Kwb+P0eSoyjdM7vAT4UuJbXk/OiiGcybDFAXsWltP+k8XrHEYjBx0NlzZSUsr2QSm5Mtjmv/q7+pIvKDPYeQ9DFyDzsW0IllSxTJ0Zrc+gErBnXCDo4YVYcdmmq5lccDuaCA1lPLYf/xQRLmhRqg0zT8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 41b73abc-cba3-4828-0a56-08d689431527
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2019 19:17:30.8993
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3638
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

