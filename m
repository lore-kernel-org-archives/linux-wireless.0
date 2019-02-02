Return-Path: <SRS0=M3au=QJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47FD3C282D7
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Feb 2019 19:17:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FA8E2082C
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Feb 2019 19:17:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="Mz0w6fSa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbfBBTRF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 2 Feb 2019 14:17:05 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:36455 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbfBBTRE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Feb 2019 14:17:04 -0500
X-IronPort-AV: E=Sophos;i="5.56,553,1539673200"; 
   d="scan'208";a="25789174"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 02 Feb 2019 12:17:03 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.108) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sat, 2 Feb 2019 12:17:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n5rUVZuh6Z2RSrsY2V7x7W2SlNuob5vuF3GFMRbQF2E=;
 b=Mz0w6fSaOaETSzFa03tKMwgjQnc1jzktteTbdTPyavlAYolunHj2UxXSf7MZ7I0zKZ1EnjY1VRDekPSJA3CKimoPQfYLuG2y64Hgat2/E3nu3bh8mXvVYCZ7bQVSMRfAEiafhs0wOqHcYD4lviPc+XDMxP4pQ/hgXGHHpxxb8+k=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2998.namprd11.prod.outlook.com (20.177.224.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.21; Sat, 2 Feb 2019 19:17:02 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1580.019; Sat, 2 Feb 2019
 19:17:02 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 04/15] staging: wilc1000: remove unnecessary debug log
 messages
Thread-Topic: [PATCH 04/15] staging: wilc1000: remove unnecessary debug log
 messages
Thread-Index: AQHUuyvgua6/kia3ykyboAjZFJF1Wg==
Date:   Sat, 2 Feb 2019 19:17:02 +0000
Message-ID: <1549134974-5545-5-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2998;6:ApDykclLIdcFU5Vk4X1SAPu+9PMkmeT+Vohiv/rP6bSZOwEynEZtUXhV0TK5SV30pE9zziu1iGtxJMRjsayL4qLActtM5URHUalJHfpypIZiGGZ4XnGCBD2eSBQTbQzmRWEPHpgoGCqM97SEuBqpd8z0cd2bq4aINoaj8vjbI2cWupyl0i/CeSU2CEvXEngtxx1YPsbDFUFz/zOb3+Yjhl/uo/9hOV2y8l1LoJGT+SQ6mtIRJYubtN3/khyTDZmX2M/5n79qQDzYI/FrCEh8DdsUR74nbyJ3NLY/XAKbmcz3X7gwtV6czTWCn88xbtL9nO1DJMQX+qlh+I72KlL0zgxrHxX3mDhLNt3jSAKjSyF/NOS10n/6JJ3iRZ4G646jPI8W3yDMZ4Bpx6XX4n7DF/jrxlLLqQMBP01pPZ5AKLLwbxQleFkp/hXiK8cdbf1vzA8Pua0q8QXjKVcRWufTkg==;5:0Kom+Gd2JRf7etsYH3gg4Qd6o84snTYqrqlUGbAl0SjtHrcJbaBPzqPhMQc0DN0KF+gqr397+ajC8/7FUpJvR8p1F+Kd9ph/BD5lpujCy6GTqDpdiofu40LEb7TRynWSMvMXLox05orqBEWxuZIKruAnj5Ril9nBJDvH9GM7fHIdbDdPPXtTp2QK3Amb7+RWjxgJXt3mgmETCuYC6VU8+A==;7:vCOOAV/lBsbHyW39ZQ3+YiDWq3td+xDQ+OPn4dQHsISkTWJuTXDohVJ18aPGO/nYqkVAxP5T1H7976cdITKeTtgyZqL+L5ENdH7cMHkQ69KDP/Y5ELAlW6A8TLNX7mQMLnnKJqlu8u3Q3w++gnw6DA==
x-ms-office365-filtering-correlation-id: 0247c6e9-a584-4d69-dc90-08d689430280
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2998;
x-ms-traffictypediagnostic: BYAPR11MB2998:
x-microsoft-antispam-prvs: <BYAPR11MB2998FBC352F41A2526634655E3930@BYAPR11MB2998.namprd11.prod.outlook.com>
x-forefront-prvs: 09368DB063
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(376002)(366004)(346002)(39850400004)(189003)(199004)(25786009)(107886003)(105586002)(78486014)(36756003)(50226002)(2501003)(6916009)(66066001)(8936002)(3846002)(4326008)(305945005)(7736002)(71200400001)(71190400001)(8676002)(6116002)(54906003)(81166006)(316002)(446003)(81156014)(6436002)(6486002)(2906002)(2616005)(486006)(476003)(76176011)(256004)(99286004)(11346002)(52116002)(53936002)(72206003)(478600001)(186003)(386003)(26005)(14454004)(106356001)(86362001)(5640700003)(97736004)(2351001)(68736007)(6506007)(15650500001)(102836004)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2998;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rS5Gzq0t1RswCW2DmoLuFyoxFdmmIbQhI9G7xqpvVdqlGYJ5Q0kz9XrHnx/adeD10FQqIvwEoI7o9LnKIkmD9mewagC9CunoIfAjz8poPZgV06YxoYvHIcaNaw3HsQ3IO9IN2XdE5tyIBAAogUbhW3IX1baDX6iHmtGuomrHxtjombtdtqsEi1uc2J5mpbr/h0Ca1dp0v5nFBf2n6QzkgZlQmC+QMrwPetfz8ClL4FD6LLiv9KJrX3HkpFZL3eM571m2gssQTjcRXQPXXngFZOW+AIoWHImGxh8DjKo0LlkATLTDSK08bOFihxaHoPhEfUhK+fIZfp1BfSAGsiZnwy5/+zmZ9xmojV52kXi84xzwSgdovN8TZq2Muw2NRX7AKVH8RjftStjNXPJb6Qm9okEal3gxcNNTPcn16TA8xw4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0247c6e9-a584-4d69-dc90-08d689430280
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2019 19:16:59.5862
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2998
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Remove unnecessary debug log messages.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 31 -------------------------------
 1 file changed, 31 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc10=
00/linux_wlan.c
index b0249d2..81472d2 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -19,9 +19,7 @@ static int dev_state_ev_handler(struct notifier_block *th=
is,
 	struct wilc_priv *priv;
 	struct host_if_drv *hif_drv;
 	struct net_device *dev;
-	u8 *ip_addr_buf;
 	struct wilc_vif *vif;
-	u8 null_ip[4] =3D {0};
 	char wlan_dev_name[5] =3D "wlan0";
=20
 	if (!dev_iface || !dev_iface->ifa_dev || !dev_iface->ifa_dev->dev)
@@ -56,13 +54,6 @@ static int dev_state_ev_handler(struct notifier_block *t=
his,
 		if (vif->wilc->enable_ps)
 			wilc_set_power_mgmt(vif, 1, 0);
=20
-		netdev_dbg(dev, "[%s] Up IP\n", dev_iface->ifa_label);
-
-		ip_addr_buf =3D (char *)&dev_iface->ifa_address;
-		netdev_dbg(dev, "IP add=3D%d:%d:%d:%d\n",
-			   ip_addr_buf[0], ip_addr_buf[1],
-			   ip_addr_buf[2], ip_addr_buf[3]);
-
 		break;
=20
 	case NETDEV_DOWN:
@@ -77,13 +68,6 @@ static int dev_state_ev_handler(struct notifier_block *t=
his,
=20
 		wilc_resolve_disconnect_aberration(vif);
=20
-		netdev_dbg(dev, "[%s] Down IP\n", dev_iface->ifa_label);
-
-		ip_addr_buf =3D null_ip;
-		netdev_dbg(dev, "IP add=3D%d:%d:%d:%d\n",
-			   ip_addr_buf[0], ip_addr_buf[1],
-			   ip_addr_buf[2], ip_addr_buf[3]);
-
 		break;
=20
 	default:
@@ -851,9 +835,6 @@ netdev_tx_t wilc_mac_xmit(struct sk_buff *skb, struct n=
et_device *ndev)
 	struct wilc *wilc =3D vif->wilc;
 	struct tx_complete_data *tx_data =3D NULL;
 	int queue_count;
-	char *udp_buf;
-	struct iphdr *ih;
-	struct ethhdr *eth_h;
=20
 	if (skb->dev !=3D ndev) {
 		netdev_err(ndev, "Packet not destined to this device\n");
@@ -871,18 +852,6 @@ netdev_tx_t wilc_mac_xmit(struct sk_buff *skb, struct =
net_device *ndev)
 	tx_data->size =3D skb->len;
 	tx_data->skb  =3D skb;
=20
-	eth_h =3D (struct ethhdr *)(skb->data);
-	if (eth_h->h_proto =3D=3D cpu_to_be16(0x8e88))
-		netdev_dbg(ndev, "EAPOL transmitted\n");
-
-	ih =3D (struct iphdr *)(skb->data + sizeof(struct ethhdr));
-
-	udp_buf =3D (char *)ih + sizeof(struct iphdr);
-	if ((udp_buf[1] =3D=3D 68 && udp_buf[3] =3D=3D 67) ||
-	    (udp_buf[1] =3D=3D 67 && udp_buf[3] =3D=3D 68))
-		netdev_dbg(ndev, "DHCP Message transmitted, type:%x %x %x\n",
-			   udp_buf[248], udp_buf[249], udp_buf[250]);
-
 	vif->netstats.tx_packets++;
 	vif->netstats.tx_bytes +=3D tx_data->size;
 	tx_data->bssid =3D wilc->vif[vif->idx]->bssid;
--=20
2.7.4

