Return-Path: <SRS0=s1k3=OY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94795C43387
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 02:32:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8422D206C0
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 02:32:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="FvwPK9Ds"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbeLOCce (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Dec 2018 21:32:34 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:27902 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbeLOCcd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Dec 2018 21:32:33 -0500
X-IronPort-AV: E=Sophos;i="5.56,355,1539673200"; 
   d="scan'208";a="23954410"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 14 Dec 2018 19:32:33 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Fri, 14 Dec 2018 19:32:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SOASolXGKVowa1R2NqGKwG3/eao6ZovmfpIKE5EVn80=;
 b=FvwPK9Dsm3iAv4IQEwKFFDOougCYwxDRoY6adDhAkKSUjGJEW0O+X3j3EZEkr1QCzEoda+yhwL6yOdQ1J7m6NSAPzYt6T+1OrK/oAxhGLH9Ux9v+F3sEewMq52mu/KdXyP91IZ+rM2C6kdRzl8svCIFOR5SEUZojyY1CSRFq/Cg=
Received: from BN7PR11MB2562.namprd11.prod.outlook.com (52.135.244.32) by
 BN7PR11MB2851.namprd11.prod.outlook.com (52.135.246.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1425.19; Sat, 15 Dec 2018 02:32:29 +0000
Received: from BN7PR11MB2562.namprd11.prod.outlook.com
 ([fe80::c410:c1c4:ad61:381]) by BN7PR11MB2562.namprd11.prod.outlook.com
 ([fe80::c410:c1c4:ad61:381%4]) with mapi id 15.20.1425.021; Sat, 15 Dec 2018
 02:32:29 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <Ajay.Kathat@microchip.com>
Subject: [PATCH] staging: wilc1000: fix NULL dereference inside wilc_scan()
Thread-Topic: [PATCH] staging: wilc1000: fix NULL dereference inside
 wilc_scan()
Thread-Index: AQHUlB5sTXCQlMXBeESV7dD3h0T68w==
Date:   Sat, 15 Dec 2018 02:32:29 +0000
Message-ID: <1544841131-9804-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR01CA0089.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:49::31) To BN7PR11MB2562.namprd11.prod.outlook.com
 (2603:10b6:406:b0::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [183.82.18.41]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BN7PR11MB2851;6:E4RW1cO55q6VKiFEKrztz/fDfs9eErtLeDFRNTMxMTtvzUpmYZdJtmkyta+iFgJ5cNYkar1b25eO3gkwCaeVeQD1EQ9yWrLNnePvDVeAcin7egQBSvL4j/zzAdGHpZfKlgtTmv2dgwaWvuqoOYUPnyxjLQSOOj59G6mIAiJkXyFQgzAngDq6JgXMv7NxIBVuahg4OoD/k3ceNmnNQ26OdPAUNTsH26BqCZ15NJR7DkhdRrL8zbLTbsV1KypRj8fth2tZjDp60thCfVcXvekW8cSKv42/XMN5KUc+LsbLh8f7PdP/0v+4W0/dsyasxKhsDtMNzMBApQhUeBfm9rYiR+AbeKbANwR6vzo0WrR9jvnhUO8I2NQT3f4+Fja9Hft4cbnwiE2IHn5cnFF/UbDaQvROxaEeq/a15iodPcDwF2xaRx11iwRIxTTxZCamOqfUZIqpBqGynSRfOxsiNeWR8w==;5:UDMKahIeEmWURcd6crdsiK2jmWShOEwqTiYwUxTscIHTMmQdkbzT8B3VhHjoSmucqwW8l5cTjexIcIc7ztx1esbRuyqV2qPbUll4qodqJP6RCeKnlXP9OxQ1SQ/MA9V6ll8J34fOtivPuF19mxOClkLvBm+t7U/mVeB90hp22xw=;7:QK+C+n7ltleoasZZcB7Fx/vFHhtQ4qV5+kXcRgmUZZ+DyYb9ZrT5Wex4C0q78/VL2Bb3hYsKqPJDCEuFSCt7KLkibLMc+5tqwxJEkjIsmuoiW/AiBEoFWqmARxB6dA/bE5gmcgclQYD+Ia0a5NmhgQ==
x-ms-office365-filtering-correlation-id: c05aca5d-8232-4e2f-9eb1-08d662358ef9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BN7PR11MB2851;
x-ms-traffictypediagnostic: BN7PR11MB2851:
x-microsoft-antispam-prvs: <BN7PR11MB2851FAD086CAA88D3551054FE3A20@BN7PR11MB2851.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(3230021)(999002)(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3231475)(944501520)(52105112)(10201501046)(3002001)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123558120)(20161123562045)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BN7PR11MB2851;BCL:0;PCL:0;RULEID:;SRVR:BN7PR11MB2851;
x-forefront-prvs: 088751B4D4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(346002)(376002)(39860400002)(136003)(396003)(199004)(189003)(4326008)(5660300001)(99286004)(5640700003)(66066001)(2501003)(6916009)(2616005)(476003)(6436002)(2906002)(486006)(107886003)(256004)(105586002)(53936002)(81166006)(8936002)(8676002)(6506007)(2351001)(106356001)(81156014)(386003)(68736007)(6486002)(102836004)(6512007)(71190400001)(186003)(86362001)(575784001)(72206003)(54906003)(478600001)(78486014)(316002)(26005)(97736004)(14454004)(6116002)(52116002)(25786009)(71200400001)(3846002)(7736002)(36756003)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR11MB2851;H:BN7PR11MB2562.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: aOIp4/q93cGZhsn0ARguts+WEgaG0+XucJRy+nciimGPhPwQfVjbpk99ACFkbk7zgLxOsL+fBi7VAREqTa5nRu3S1tqVTupjCjSqT66T5dFvXTYeYv8N/ZRGetGl9lS+kSnQtt+aRCmanXvgLWH6AQHrjzp49+lNkT8oitVy2TJx5IFV9HdLfplnuiEhZNxua+D1XFxUFuHeETWWs3wJ3Bjs3/PnZmDiJ3FtpCm/KiTgZhJNiJgHcGFfl1ZF0WmCcsZPjW3q3dbKAqnY9yySa43xO0vea8TbROlDmhj6+63ZbpTF57pd+3k1fssST8qn
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c05aca5d-8232-4e2f-9eb1-08d662358ef9
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2018 02:32:29.5235
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2851
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Added NULL check before accessing 'hidden_net' pointer inside
wilc_scan() to fix the issue found by static code checker.

Fixes: 8f1a0ac1eba7 ("staging: wilc1000: handle scan operation callback fro=
m cfg80211 context")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 48 +++++++++++++++++----------=
----
 1 file changed, 26 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index b8603f2..70c854d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -246,27 +246,29 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u=
8 scan_type,
=20
 	hif_drv->usr_scan_req.ch_cnt =3D 0;
=20
-	wid_list[index].id =3D WID_SSID_PROBE_REQ;
-	wid_list[index].type =3D WID_STR;
-
-	for (i =3D 0; i < hidden_net->n_ssids; i++)
-		valuesize +=3D ((hidden_net->net_info[i].ssid_len) + 1);
-	hdn_ntwk_wid_val =3D kmalloc(valuesize + 1, GFP_KERNEL);
-	wid_list[index].val =3D hdn_ntwk_wid_val;
-	if (wid_list[index].val) {
-		buffer =3D wid_list[index].val;
-
-		*buffer++ =3D hidden_net->n_ssids;
-
-		for (i =3D 0; i < hidden_net->n_ssids; i++) {
-			*buffer++ =3D hidden_net->net_info[i].ssid_len;
-			memcpy(buffer, hidden_net->net_info[i].ssid,
-			       hidden_net->net_info[i].ssid_len);
-			buffer +=3D hidden_net->net_info[i].ssid_len;
-		}
+	if (hidden_net) {
+		wid_list[index].id =3D WID_SSID_PROBE_REQ;
+		wid_list[index].type =3D WID_STR;
+
+		for (i =3D 0; i < hidden_net->n_ssids; i++)
+			valuesize +=3D ((hidden_net->net_info[i].ssid_len) + 1);
+		hdn_ntwk_wid_val =3D kmalloc(valuesize + 1, GFP_KERNEL);
+		wid_list[index].val =3D hdn_ntwk_wid_val;
+		if (wid_list[index].val) {
+			buffer =3D wid_list[index].val;
+
+			*buffer++ =3D hidden_net->n_ssids;
+
+			for (i =3D 0; i < hidden_net->n_ssids; i++) {
+				*buffer++ =3D hidden_net->net_info[i].ssid_len;
+				memcpy(buffer, hidden_net->net_info[i].ssid,
+				       hidden_net->net_info[i].ssid_len);
+				buffer +=3D hidden_net->net_info[i].ssid_len;
+			}
=20
-		wid_list[index].size =3D (s32)(valuesize + 1);
-		index++;
+			wid_list[index].size =3D (s32)(valuesize + 1);
+			index++;
+		}
 	}
=20
 	wid_list[index].id =3D WID_INFO_ELEMENT_PROBE;
@@ -316,8 +318,10 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8=
 scan_type,
 		  jiffies + msecs_to_jiffies(HOST_IF_SCAN_TIMEOUT));
=20
 error:
-	kfree(hidden_net->net_info);
-	kfree(hdn_ntwk_wid_val);
+	if (hidden_net) {
+		kfree(hidden_net->net_info);
+		kfree(hdn_ntwk_wid_val);
+	}
=20
 	return result;
 }
--=20
2.7.4

