Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF1C7ECDE47
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 21:50:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 747A32081C
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 21:50:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="N0rLpImo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 747A32081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbeKIH1y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 02:27:54 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:26825 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbeKIH1y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 02:27:54 -0500
X-IronPort-AV: E=Sophos;i="5.54,480,1534834800"; 
   d="scan'208";a="20876584"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 08 Nov 2018 14:50:29 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.49) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 8 Nov 2018 14:50:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T3KObEkbPz4jccTL7w80AmdFDKQ9xwpHj6KxIZY+mWU=;
 b=N0rLpImo5te73geRz23VcowLAzYOcDZ682G6qNI48oLmGNMkGJR8Nk5Amvw9lptaYY16FS6HAwEkF9GkGnmryZHS6bGaLbFhiNFNQ9ofnbFbyYy8U/mR0IIj+0mukl6lX2bmftZFpfIl0NeZfXxiVOhR3Pt6PwdPlffO8ydEWkE=
Received: from SN6PR11MB3407.namprd11.prod.outlook.com (52.135.111.96) by
 SN6PR11MB3488.namprd11.prod.outlook.com (52.135.112.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.30; Thu, 8 Nov 2018 21:50:27 +0000
Received: from SN6PR11MB3407.namprd11.prod.outlook.com
 ([fe80::7d22:c5b8:9e2e:2281]) by SN6PR11MB3407.namprd11.prod.outlook.com
 ([fe80::7d22:c5b8:9e2e:2281%2]) with mapi id 15.20.1294.034; Thu, 8 Nov 2018
 21:50:27 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <johannes@sipsolutions.net>, <adham.abozaeid@micochip.com>
Subject: [PATCH v4 3/3] staging: wilc1000: Remove unused mutex cfg_values_lock
Thread-Topic: [PATCH v4 3/3] staging: wilc1000: Remove unused mutex
 cfg_values_lock
Thread-Index: AQHUd60PoDvgX4MtM0y06vbKZOtDFA==
Date:   Thu, 8 Nov 2018 21:50:26 +0000
Message-ID: <20181108214915.3733-4-adham.abozaeid@microchip.com>
References: <20181108214915.3733-1-adham.abozaeid@microchip.com>
In-Reply-To: <20181108214915.3733-1-adham.abozaeid@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
x-clientproxiedby: BYAPR07CA0013.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::26) To SN6PR11MB3407.namprd11.prod.outlook.com
 (2603:10b6:805:bd::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;SN6PR11MB3488;6:VbLndyoShiBNWoYUnBmHhjSOlQQ2LmOZVIP0rMP4lc3TGSQRJiIF96w8iMM6+fErgvxpBkFC/iVS9IEygW7AxHoO+1QfNrb+ZPbEK3hVXc2y37kwM5c5Ofb3KZpF89sztvNYfgxJBYc+iiIwUvIGrZU/kQimqqY5H1iAycxtd/9RWzTiZ8Bd75mh9QvIr28YTljKgu9UQSN8w9AMRCQCnL5K7Gzxvjb6o4+rLXgx/Y+ebMQmAADyCU00da1MusunTxfzovxsWMbrSGeMb8bhRNXhmZZwyW7tqjJpue+x2X9va8SU8HL8dlVy7QVvEfu3QBuaMCfbI7QvPl9qtAzRmWRnCwpREbupeHtgAieCbUj9F1clKXGBi6Zr4Z/t77vhIGEPGLiS1W0PDsrIMkSdubUpu+yPZV4Sr0l1216uX574nldTaLiRVwPqQWpG3/FyA0tq3LZJ7iVJM5Gw7pVuzw==;5:hI94xUrByOj+02JXK4vHJTAPx4XxugrqbuJNsMAezmRcocHnUV8TDxpZOb1zOZVH3WNewAz13A2RNpiX2fHWkK4U4o/MuGfkXnS/ii1Cx3fuE2/fjFom8sTawnmfcrWMpbefOKP3IR3/8fjZPGNcv1yb7vpFLpe/T6mZSLSEYDo=;7:QknZDx1iFDBdNSLkYA6Xtk88aPMI4yBO3TTesZ8AcRo+DeSTr1iPz1joiWt8WWTQzhfJG4pqRMCMl9gEDNUk3s2wIhze6jZ5I/CUed7ArQXP7HhcNZsNkskUmv5pznBu6sE5bxXA357HxvHvQZPpIw==
x-ms-office365-filtering-correlation-id: cf3bd9cc-2b9f-45f5-6429-08d645c43196
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:SN6PR11MB3488;
x-ms-traffictypediagnostic: SN6PR11MB3488:
x-microsoft-antispam-prvs: <SN6PR11MB34882F85C9E1870E2D5893588DC50@SN6PR11MB3488.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(21532816269658);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(10201501046)(3002001)(3231382)(944501410)(52105095)(148016)(149066)(150057)(6041310)(20161123558120)(20161123564045)(20161123562045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:SN6PR11MB3488;BCL:0;PCL:0;RULEID:;SRVR:SN6PR11MB3488;
x-forefront-prvs: 0850800A29
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(396003)(39860400002)(136003)(376002)(199004)(189003)(5640700003)(52116002)(76176011)(386003)(6506007)(1076002)(6436002)(14454004)(6486002)(25786009)(7736002)(6916009)(99286004)(305945005)(6512007)(81156014)(81166006)(66066001)(8676002)(186003)(8936002)(478600001)(68736007)(97736004)(26005)(2501003)(5660300001)(53936002)(3846002)(6116002)(102836004)(4326008)(106356001)(71200400001)(71190400001)(476003)(105586002)(2351001)(2616005)(54906003)(316002)(14444005)(486006)(86362001)(256004)(446003)(2906002)(36756003)(72206003)(2900100001)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR11MB3488;H:SN6PR11MB3407.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: tnPlV/c7zsRFYwSCyciz0FH1Vm/t95fLv8uKvtAgIWVq9smzOfSW2vUFo9tYjrxJmbmXCSx2mNg2oJfgPCguQvLNxcbN53ctvSZGhY/j1llVb5oMnQpUksqu6WR0sKaWd/jFxPHZrmKvZyx9GSlOspNuOGGu7B+GzID98IRW9pgeA/bFIE/EoQogw4X8Hnvf4jdOsakrbM+DA7dGZ9BjiAGdulnm0vGN/lNtq2L3VbrwmtxCwr5NLDBbE2VeyV56hDgE68s++Wb08qE6bE0nfQwBojUGOy7ov7KTIjZ9GNUTGM1gDhhxtRsCmUVznfuJuV2+agU3voOY5vBZvKrr+eIBsAARcXmf2H4adViw7n4=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: cf3bd9cc-2b9f-45f5-6429-08d645c43196
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2018 21:50:26.9537
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3488
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Adham Abozaeid <adham.abozaeid@micochip.com>

From: Adham Abozaeid <adham.abozaeid@microchip.com>

After removing cfg_values member, cfg_values_lock that was used to protect
it can also be removed.

Signed-off-by: Adham Abozaeid <adham.abozaeid@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 9 ---------
 drivers/staging/wilc1000/host_interface.h | 2 --
 2 files changed, 11 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 8d1142776310..2bf91df1ded1 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -369,11 +369,8 @@ static void handle_cfg_param(struct work_struct *work)
 	struct cfg_param_attr *param =3D &msg->body.cfg_info;
 	int ret;
 	struct wid wid_list[32];
-	struct host_if_drv *hif_drv =3D vif->hif_drv;
 	int i =3D 0;
=20
-	mutex_lock(&hif_drv->cfg_values_lock);
-
 	if (param->flag & RETRY_SHORT) {
 		wid_list[i].id =3D WID_SHORT_RETRY_LIMIT;
 		wid_list[i].val =3D (s8 *)&param->short_retry_limit;
@@ -409,7 +406,6 @@ static void handle_cfg_param(struct work_struct *work)
 	if (ret)
 		netdev_err(vif->ndev, "Error in setting CFG params\n");
=20
-	mutex_unlock(&hif_drv->cfg_values_lock);
 	kfree(msg);
 }
=20
@@ -3240,15 +3236,10 @@ int wilc_init(struct net_device *dev, struct host_i=
f_drv **hif_drv_handler)
 	timer_setup(&hif_drv->connect_timer, timer_connect_cb, 0);
 	timer_setup(&hif_drv->remain_on_ch_timer, listen_timer_cb, 0);
=20
-	mutex_init(&hif_drv->cfg_values_lock);
-	mutex_lock(&hif_drv->cfg_values_lock);
-
 	hif_drv->hif_state =3D HOST_IF_IDLE;
=20
 	hif_drv->p2p_timeout =3D 0;
=20
-	mutex_unlock(&hif_drv->cfg_values_lock);
-
 	wilc->clients_count++;
=20
 	return 0;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index 1e2e50e91f76..523b46bfb488 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -293,8 +293,6 @@ struct host_if_drv {
 	enum host_if_state hif_state;
=20
 	u8 assoc_bssid[ETH_ALEN];
-	/*lock to protect concurrent setting of cfg params*/
-	struct mutex cfg_values_lock;
=20
 	struct timer_list scan_timer;
 	struct wilc_vif *scan_timer_vif;
--=20
2.17.1

