Return-Path: <SRS0=k7+a=M4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D496FC04EBD
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 11:49:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C2622098A
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 11:49:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="oQ8MCBRe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C2622098A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbeJPTjj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Oct 2018 15:39:39 -0400
Received: from mail-dm3nam03on0043.outbound.protection.outlook.com ([104.47.41.43]:38231
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726760AbeJPTjj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Oct 2018 15:39:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nwVj8JH1Cn7SY8PTVBFnMYeDOR9rqOISVmiPc6tfI/Y=;
 b=oQ8MCBReH7ujO0fLERAxGBxH7kaLRkDXCPkN0FBSV8eOeAPOGWEAWA1lDvQ85ey/Pk+mQBGD1AhBf1RiOzZZURNNpcPrNwhh+g0wjx9mUxHxDTfilKvzLKG2oOUzhT9CWcotR5+YzlCODFAwTxm4YhB/ozn6KDswcDbVE3d8jpQ=
Received: from BL0PR05MB4595.namprd05.prod.outlook.com (20.177.144.212) by
 BL0PR05MB5347.namprd05.prod.outlook.com (10.167.233.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1250.15; Tue, 16 Oct 2018 11:49:30 +0000
Received: from BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::d16b:3a5b:aa09:b156]) by BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::d16b:3a5b:aa09:b156%2]) with mapi id 15.20.1250.020; Tue, 16 Oct 2018
 11:49:30 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Tamizh chelvam <tamizhr@codeaurora.org>
CC:     "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/3] mac80211: Implement functionality to monitor
 station's signal stregnth
Thread-Topic: [PATCH 3/3] mac80211: Implement functionality to monitor
 station's signal stregnth
Thread-Index: AQHUZLDHbUwyLnDOoU+jm+Kn6bthk6UhwzCA
Date:   Tue, 16 Oct 2018 11:49:30 +0000
Message-ID: <20181016114923.wtmuhfhjzrbqn4so@bars>
References: <1539626250-769-1-git-send-email-tamizhr@codeaurora.org>
 <1539626250-769-4-git-send-email-tamizhr@codeaurora.org>
In-Reply-To: <1539626250-769-4-git-send-email-tamizhr@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P194CA0059.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:84::36) To BL0PR05MB4595.namprd05.prod.outlook.com
 (2603:10b6:208:5f::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB5347;6:weorXg3YheA/v3ESCOe/9kCZQ5yAerYGnVYTlvZhmLYMmoaiaJZaZ3j7plSgZII7ILwpQkcUqQWqtLhpSFGuKPNjvLb0trSiCbjeCzP9TRYFviRq2hQTSijBh8e7cnMjkuA0hPk6y5Ve9hFmyiKRil3DOGj0j4aKDBincazwdxeQRha/yurl/00FizUhgYEK28ZiD1Sft8jhSH8oVikO/qaL1IjDfocGQhwanrPxoChL88zioranSpQvr6gxB75bsQ4vpdEIm8iZjR+QZOdlY9nnjrCXErlnmjZRrtbSbq8HWSTvzuk1Lq20ehdB9jE08+jwN3OBkmBY+KFlN/DVEsMO1PR1imzCl6474VRbxWF4xH3pQog5shDNUlvjXly6UkfbNupF+LPxqPd9tKAe+/Ic12rGOPLrGXuYy0DwWc8GUNodn65WZrhnn6iVqLnTlOP7VEAKCa/s51m4E4/+NA==;5:6Zu+/oM4GVk/AqQnLRaimEl9O5kzlBbHn255yeF8d3wKjLfBCtQQAzQwy9DN/SyNzowus3aiTFY5+CxLKBbfj6MYWgUuxZw9tY916iJjQPoGugKnDHZcvTovNeT3yMkNGnklwknExWc13eFKgbtA8XDQRG+DgPH6na4ACA6Krlw=;7:q6dkCe0Zb4pvMyq5/U3knSRRFI2aOLEwWDlT0RwQsRra2OdjSu/0kHoB6CME16iiDSfTV6gX2IZqvUJcyYyj2zdy09k34SNpuhlRRDHfNT1WjfQ4JeP3JkVqP2Fe4CLSH+NVAvNJ7P232JAI1ZAKFjujzZOMkg6Px00P9/gDcZVVTS1cYM+cPd/lFOVFqYC8nTlE4BTfLru7M2sYLtmpGgNgt9juDfF6aVgrOMWpkRhNEcEaSB+/d31X48y7p9Xr
x-ms-office365-filtering-correlation-id: 49dd5391-d737-471a-4917-08d6335d6ea7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB5347;
x-ms-traffictypediagnostic: BL0PR05MB5347:
x-microsoft-antispam-prvs: <BL0PR05MB5347931B21C90D51604B4DB9A3FE0@BL0PR05MB5347.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3002001)(3231355)(944501410)(52105095)(10201501046)(93006095)(93001095)(149066)(150057)(6041310)(20161123560045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123562045)(201708071742011)(7699051);SRVR:BL0PR05MB5347;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB5347;
x-forefront-prvs: 0827D7ACB9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(346002)(396003)(39850400004)(376002)(366004)(136003)(189003)(199004)(8936002)(2900100001)(8676002)(97736004)(33716001)(2906002)(5660300001)(99286004)(54906003)(81156014)(105586002)(71190400001)(71200400001)(52116002)(81166006)(1076002)(53936002)(76176011)(86362001)(33896004)(3846002)(256004)(68736007)(106356001)(4326008)(229853002)(6506007)(6512007)(9686003)(386003)(11346002)(446003)(14454004)(6486002)(6916009)(486006)(102836004)(305945005)(6116002)(66066001)(25786009)(316002)(6246003)(6436002)(186003)(478600001)(7736002)(5250100002)(476003)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB5347;H:BL0PR05MB4595.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 1cIMdjIp3hNKwKkdsRYiEB68VqL4l9bLeOIt3xSNyFlOzxlIGzEEhsUQEI4w7Yg2mcIabttNKaYyMovojdwoHr+k8J2ZceWvVCOLwUgeZPnF4Fez5ssOyAPxZhSkIxxKxtO6Q2oF30zxtRuR0CXuGbuOjTXnz4lTlgCzL1xJQn3/fJq8wuMbqNC+w9dSs/DmQCiTFHyh4J5djxaJkIb9kGrbLvrLLSc/jSpjZcDpaMedg4D2u7NYMl+p8GnJABuPwKv0Aa/iVGWLratQ/4ce1ORcJ2pE4fspcLCsct4NjdL2/0fzaZg6MS7m3HfDsd8RVXA/mlaSQct0eeEyjDcCipTUtIUl2a6x7EAMLhwWWZ0=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0762354DBD9BFB4D94815FCE5524F6A8@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49dd5391-d737-471a-4917-08d6335d6ea7
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2018 11:49:30.4217
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB5347
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> +/*
> + * How many frames need to have been used in average station's
> + * signal strength before checking against the threshold
> + */
> +#define IEEE80211_STA_SIGNAL_AVE_MIN_COUNT     4
> +
> +
>  /* there are 40 bytes if you don't need the rateset to be kept */
>  #define IEEE80211_TX_INFO_DRIVER_DATA_SIZE 40

...

> +static void ieee80211_sta_rx_signal_thold_check(struct ieee80211_rx_data=
 *rx)
> +{
> +       struct sta_info *sta =3D rx->sta;
> +       struct ieee80211_bss_conf *bss_conf =3D &rx->sdata->vif.bss_conf;
> +       bool rssi_cross =3D  false;
> +
> +       if (!wiphy_ext_feature_isset(rx->local->hw.wiphy,
> +                               NL80211_EXT_FEATURE_STA_MON_RSSI_CONFIG))
> +               return;
> +
> +       sta->count_rx_signal++;
> +       if (sta->count_rx_signal < IEEE80211_STA_SIGNAL_AVE_MIN_COUNT)
> +               return;

Could you please clarify count_rx_signal processing and averaging
approach ? I couldn't find where this counter is reset or
modified in any other way.

Regards,
Sergey
