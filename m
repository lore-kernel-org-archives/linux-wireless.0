Return-Path: <SRS0=9n1M=OL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 199CCC64EB4
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:02:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE0C52082F
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:02:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="LhLUn8Ae"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CE0C52082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725797AbeLBSCs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Dec 2018 13:02:48 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:39776 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbeLBSCs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Dec 2018 13:02:48 -0500
X-IronPort-AV: E=Sophos;i="5.56,307,1539673200"; 
   d="scan'208";a="24754994"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 02 Dec 2018 11:02:46 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.38) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 2 Dec 2018 11:02:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R9rHb59dJtr/P0RfJgIMZwvlKGzLHv4UT8RYez7xY2Q=;
 b=LhLUn8AerrJdcf1YMkwDF+Hoi2kJFChTIxtYnO3cHoyYSjbuiN3YvOwstjMVz0W8nkyHEd8B13OjjATC5bQqnnzcQMeajwngEqwpcvlTs+Vfo6gs3MiSbj7xHpQG2FAzoav8JSA+33hQ2g8op7YOTTbZ4zHL4WpWdDahg00fhT4=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2806.namprd11.prod.outlook.com (52.135.228.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.18; Sun, 2 Dec 2018 18:02:43 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f%4]) with mapi id 15.20.1382.020; Sun, 2 Dec 2018
 18:02:43 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 10/29] staging: wilc1000: use is_zero_ether_addr() API to
 check mac address
Thread-Topic: [PATCH 10/29] staging: wilc1000: use is_zero_ether_addr() API to
 check mac address
Thread-Index: AQHUimk4LUt8ViMG5UOMBa6G8mkvlg==
Date:   Sun, 2 Dec 2018 18:02:43 +0000
Message-ID: <1543773663-20561-11-git-send-email-ajay.kathat@microchip.com>
References: <1543773663-20561-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1543773663-20561-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR0101CA0063.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::25) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [183.82.18.98]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2806;6:6sUCNkL7494GJa6Ip7G0E+z3G/B+lVRIN8RCvgZHafzohkeaEFeap+ItBUrZCm7fZYeDBbI8gNjsfdPTrfSfbBAgI4yn5NgmIjR1pw9GCz11mDtiqosTewpjQKAkT+sEy3KwXtyIw7qOeJSvXayRwGk0vGBwo3+rjsd/tXHrBZSUL7aGdxGDZlQmMj+PqhTBzpiee1zkE5Rdvr5Jt1ork/+OBV9rx3rdi5uavgzP0NLENty2tq7YIos78W0a9iuzpZZVN/ggxGZIyfMzvkvmOAWpbMk07+Yhwb9UTyqCP4jNT39IfhgbNQKKpXFE4E0AotEUfldrbcVVPFzbAye4CveXyqeY/jrwNbRjv1xmWIJeJCiIw/MDpCrp6P+tot+WoHoJWkXWeudyRemPabLARB3JpJifDLErWz9TXZBpt3GTgFBBk5ThYtb2mE4tvTs9E6HtzFH7rc12YG73fskZIg==;5:jUsz4X7y3A9eUzkHh4yyp0+RDWGjm0l4o+CoLDs0W/fi1xds8AVyQzc4toG5kjtKMJTXtI0wC1pTO60ApGlktzowtFI4PTmVpnyz8+BTBJ1S5wbUSSb3FLacFESalQvjH7pDBbNYc+VXFOz3eWBVrY7b/uS9NTvFUvkxH71ZVaM=;7:gl/MO6oXvE665sw5Hrs6j4f10p0yQEZcwOm6nSfjvJqXqKf2zSuTCMtHAdNQr5H3/E5clyfXnMF/JKzQ9fQFjDY4PQsWifPqsygfIsH0SsL9l9qdkrz63L9Upw52RjfdQdYL3NO+M3Abo5ymIOdB+A==
x-ms-office365-filtering-correlation-id: 5c271f37-ad39-49cd-d2ec-08d658805b25
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2806;
x-ms-traffictypediagnostic: BYAPR11MB2806:
x-microsoft-antispam-prvs: <BYAPR11MB28066E78D8EB054781DAD53DE3AD0@BYAPR11MB2806.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3002001)(10201501046)(3231455)(999002)(944501491)(52105112)(148016)(149066)(150057)(6041310)(20161123562045)(20161123558120)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB2806;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2806;
x-forefront-prvs: 087474FBFA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(366004)(39850400004)(396003)(136003)(199004)(189003)(186003)(4326008)(7736002)(26005)(14454004)(2906002)(107886003)(305945005)(386003)(53936002)(6506007)(36756003)(76176011)(6512007)(71190400001)(52116002)(71200400001)(5640700003)(256004)(3846002)(6116002)(99286004)(5660300001)(78486014)(6486002)(446003)(11346002)(486006)(86362001)(105586002)(8676002)(97736004)(68736007)(316002)(2616005)(6436002)(476003)(54906003)(66066001)(25786009)(102836004)(81156014)(81166006)(8936002)(72206003)(2351001)(2501003)(478600001)(6916009)(106356001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2806;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 1FQZbn53v0rqY/OMn3pK4P034og5T9smmnOK1I4BzQxNOEZsqf9toGCvYXuanHSdYTLhOZxHObOH6IPsZD4hhjSBaza9K4wHaoe14q7e+XjJLdvwY/yc6yXnLgzxDVRUFknNRZH507HFtxn4kKHJnys/+1kvBSZHjMqnXIk7j9l6NDQI/K/tvbvuGPWNoQgAHAoIEAESzgA2XP8P3Gx2GSBG5/S5HoI4mSKI9/wwEuxIlvpVn4+6zogXK8cQahHxWK5rXmM01yeOAiEnIBH2lr0IuwfyP3777uWoIEaPmlKBSlAyuoeKgwwJuol1f+slYjZHgzvw1tYvKrCTDwe70i+OTU0jv3rps8JdyExaqZ0=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c271f37-ad39-49cd-d2ec-08d658805b25
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2018 18:02:43.0429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2806
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Use is_zero_ether_addr() API to check if mac address value is zero.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 3 +--
 drivers/staging/wilc1000/linux_wlan.c     | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 8ce56a3..310138d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3400,13 +3400,12 @@ int wilc_del_allstation(struct wilc_vif *vif, u8 ma=
c_addr[][ETH_ALEN])
 	struct wid wid;
 	int result;
 	int i;
-	u8 zero_addr[ETH_ALEN] =3D {0};
 	u8 assoc_sta =3D 0;
 	struct del_all_sta del_sta;
=20
 	memset(&del_sta, 0x0, sizeof(del_sta));
 	for (i =3D 0; i < WILC_MAX_NUM_STA; i++) {
-		if (memcmp(mac_addr[i], zero_addr, ETH_ALEN)) {
+		if (!is_zero_ether_addr(mac_addr[i])) {
 			assoc_sta++;
 			ether_addr_copy(del_sta.mac[i], mac_addr[i]);
 		}
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc10=
00/linux_wlan.c
index e246d18..142816a 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -205,11 +205,10 @@ void wilc_wlan_set_bssid(struct net_device *wilc_netd=
ev, u8 *bssid, u8 mode)
 int wilc_wlan_get_num_conn_ifcs(struct wilc *wilc)
 {
 	u8 i =3D 0;
-	u8 null_bssid[6] =3D {0};
 	u8 ret_val =3D 0;
=20
 	for (i =3D 0; i < wilc->vif_num; i++)
-		if (memcmp(wilc->vif[i]->bssid, null_bssid, 6))
+		if (!is_zero_ether_addr(wilc->vif[i]->bssid))
 			ret_val++;
=20
 	return ret_val;
--=20
2.7.4

