Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83FE4C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 10:33:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4357A20862
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 10:33:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="eCj5+ZHp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4357A20862
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387657AbeKFT6G (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 14:58:06 -0500
Received: from mail-eopbgr720040.outbound.protection.outlook.com ([40.107.72.40]:18438
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387404AbeKFT6G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 14:58:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UPLrJsTBlLQ4y1HWohPnPBCdtf7z9nzhGAN6IHg+aqk=;
 b=eCj5+ZHpobp11AFs1VYqs/Il++b1ZaINAJy0YvcZJz8wK79bCEwpaabXxQX7snw1iQ2AhWV/sbZ3kRHTkweyoPFFCLrmfed8TDvAr+6vIgJqzRQv1IIHJaV2jn3PUz5sGY67mvts2sZjXWkAr+523WXN3jwdQ/t+7xx+5XS0E04=
Received: from BL0SPR01MB0020.namprd05.prod.outlook.com (20.177.146.138) by
 BL0PR05MB5332.namprd05.prod.outlook.com (10.167.233.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.9; Tue, 6 Nov 2018 10:33:30 +0000
Received: from BL0SPR01MB0020.namprd05.prod.outlook.com
 ([fe80::fce8:69f:f659:27d8]) by BL0SPR01MB0020.namprd05.prod.outlook.com
 ([fe80::fce8:69f:f659:27d8%3]) with mapi id 15.20.1294.034; Tue, 6 Nov 2018
 10:33:30 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Tamizh chelvam <tamizhr@codeaurora.org>
CC:     "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/4] mac80211: Add api to support configuring TID specific
 configuration
Thread-Topic: [PATCH 3/4] mac80211: Add api to support configuring TID
 specific configuration
Thread-Index: AQHUajCQhulbacRYc0SFBMlmu1EyoqVCo+qA
Date:   Tue, 6 Nov 2018 10:33:30 +0000
Message-ID: <20181106103325.5phrwo2pv2rc26pd@bars>
References: <1540230918-27712-1-git-send-email-tamizhr@codeaurora.org>
 <1540230918-27712-4-git-send-email-tamizhr@codeaurora.org>
In-Reply-To: <1540230918-27712-4-git-send-email-tamizhr@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR0402CA0029.eurprd04.prod.outlook.com
 (2603:10a6:209::42) To BL0SPR01MB0020.namprd05.prod.outlook.com
 (2603:10b6:208:72::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB5332;6:LovyucYbtIPmbKmATBqaJeNyjHH1U3/fgicuPyFRaPWsZfpHlT1nov/ywfwz8XIsbHo1hTTcq+EJgy8rCwNbILI6VxF+qCEhbVIPQvRXqHOfyVc1MR8oewAy0RxxQE0JiKQvg+/pM7iej6DYe4ECu1eGRI1Nfcg82dZAclei61XaBXs1sJahwPN3Cdyyr8b2HruzlwpcS6XFvfrPIVFglBmCGsa7r2UDLg1FTHhM/udRk9rWoW4WjEqbrDGx3V6rR+JxwqI7m/Ww2vaLGu/cuOt0tMiVDT0TaNlvWZ4FRktDMY4Bb7jXpHGCB891n6AnjslmUfZBXCns0ycMb9oqI2wcuyCQQ6CgaGZmStixGub2S/N7wH9Y8bUK24muvOScg0VtxD0d9apXkDhMMEwLVqYz2I7QO2U7UModbWmGWAdBYIXctIunOoS6DpbTk3zE2MHYWvLjb6T9GRg7ychSqw==;5:Fz1DKhG4j1wJhF1UoTNNEQcap0rQbaH742h1ZytXTacBxpmdN+yc5+nVBzTaGPJ4DcDzHGY8HOPjJyp3XFVIkjH8mpQ7AZ4VQBal78bYn8+0XlYqRkJALkDgJz+uLnrJU495DeNjZjC3GC6QvSSpTSfZMTAieLAjNr7AhY2vRcA=;7:xCONKKJj1th2L+IKdIkvNfOneqMcEgRax3ZlSUgSuB83NVfrLAMWN72apC9fps3bMJOIS9G4fWXn4hT9e6nYTjrdKa1YXfF3pLj/CdCqRA6iek54JmLaAGgKSjbKlpPRiY3suZzxQ2nIO2MUU6PXLQ==
x-ms-office365-filtering-correlation-id: 37070fe2-9e69-44de-8896-08d643d34b3a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB5332;
x-ms-traffictypediagnostic: BL0PR05MB5332:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-microsoft-antispam-prvs: <BL0PR05MB5332177C5D320DE7818D675AA3CB0@BL0PR05MB5332.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(788757137089);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3002001)(3231382)(944501410)(52105095)(10201501046)(93006095)(93001095)(148016)(149066)(150057)(6041310)(20161123558120)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BL0PR05MB5332;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB5332;
x-forefront-prvs: 0848C1A6AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(39850400004)(396003)(346002)(136003)(376002)(366004)(199004)(189003)(305945005)(7736002)(66066001)(25786009)(1076002)(2906002)(478600001)(68736007)(8936002)(8676002)(5660300001)(81166006)(4326008)(81156014)(53936002)(6246003)(106356001)(105586002)(86362001)(9686003)(6512007)(11346002)(446003)(186003)(476003)(486006)(6116002)(3846002)(229853002)(33716001)(6436002)(6486002)(54906003)(316002)(2900100001)(6916009)(52116002)(76176011)(256004)(71200400001)(71190400001)(6506007)(14444005)(102836004)(26005)(33896004)(14454004)(99286004)(97736004)(386003);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB5332;H:BL0SPR01MB0020.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: Ui7FXcv7hJyKZG10MGRx53oIRnHJundJFkWKcfifZyraxM0zkrbKHhi6SN2C7ZxKB0YEqrwEM03mclFiimmbGwmlw43Dgwjzw5bW/3nUZssuyOTUzZjC2u/Q7EHDW6Y3tT22Z2F9VuWbL36XcwPis160MuV3XtlrRDtoyCbsKq57CjfPnxiBNcSOZkIMjkeyoZtaHEaC16ZuS3JpRjVGLzOBWqs9gGu9onZMuNobcbsuTuccE9XMHEvdwfmKUVZBN6AnC+iO5sddFvCvRRBz+CvFlUCYKnRgYC1ddJek4nrlptTv/Lht5lUw+Xxf+tKymLBPqSTeKM6aE3WMVVOXMxbKWlZpH4UzYPHTOUT77BM=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C9C6E930C710314EA5978A16A368A73E@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37070fe2-9e69-44de-8896-08d643d34b3a
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2018 10:33:30.2214
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB5332
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
> ---
>  include/net/mac80211.h    |   40 +++++++++++++++++++++++++
>  net/mac80211/cfg.c        |   71 +++++++++++++++++++++++++++++++++++++++=
++++++
>  net/mac80211/driver-ops.h |   16 ++++++++++
>  net/mac80211/trace.h      |   34 ++++++++++++++++++++++
>  4 files changed, 161 insertions(+)
>=20
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index b6cc3e33..7fa7e25 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -1478,6 +1478,35 @@ struct ieee80211_channel_switch {
>         u8 count;
>  };
>=20
> +/*
> + * enum ieee80211_tid_conf_change - TID change configuration notificatio=
n flags
> + *
> + * These flags are used with the set_tid_conf() callback
> + * to indicate which TID configuration parameter changed.
> + *
> + * @TID_RETRY_CONF_CHANGED: retry configuration changed.
> + * @TID_AGGR_CONF_CHANGED: Aggregation config changed for the TID.
> + */
> +enum ieee80211_tid_conf_change {
> +       TID_RETRY_CONF_CHANGED          =3D BIT(0),
> +       TID_AGGR_CONF_CHANGED           =3D BIT(1),
> +};

Following your approach, AMSDU support can be added in addition to
AMPDU. So I would suggest to replace AGGR by AMPDU right away.

> +
> +/*
> + * struct ieee80211_tid_conf - holds the tid configiuration data
> + * The information provided in the structure is required for the driver
> + * to configure TID specific configuration.
> + * @tid: TID number
> + * @retry_short: retry count value
> + * @retry_long: retry count value
> + * @aggr: enable/disable aggregation
> + */
> +struct ieee80211_tid_conf {
> +       u8 tid;
> +       int retry_short;
> +       int retry_long;
> +       bool aggr;
> +};

ditto: aggr -> ampdu

Regards,
Sergey
