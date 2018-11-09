Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00045C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 09:47:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF17F20855
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 09:47:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="uE9pGRCr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF17F20855
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbeKIT0v (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 14:26:51 -0500
Received: from mail-cys01nam02on0061.outbound.protection.outlook.com ([104.47.37.61]:20352
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727552AbeKIT0u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 14:26:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bzAykPzHE6XPPVttnOHHV4flcoF8XuNeJ26QPfLgJNM=;
 b=uE9pGRCrrFISSdWbS40xRlXHCP6SyAcEl62RvcAomPboWp65goX9segI3DWHt9C3e6WIncjqnNBnLAIjAAR49JC6buZB79g42eR037kNv1vg+SepitZl2LtZRQcSeELAu7LWHe9Onne+u9eO+Ol+cpwfmlphrSyy9nsLhL4HBps=
Received: from BL0PR05MB4595.namprd05.prod.outlook.com (20.177.144.212) by
 BL0PR05MB5507.namprd05.prod.outlook.com (10.167.235.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1339.10; Fri, 9 Nov 2018 09:47:02 +0000
Received: from BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::d16b:3a5b:aa09:b156]) by BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::d16b:3a5b:aa09:b156%3]) with mapi id 15.20.1339.013; Fri, 9 Nov 2018
 09:47:02 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Tamizh chelvam <tamizhr@codeaurora.org>
CC:     "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: Re: [PATCH 1/4] New netlink command for TID specific configuration
Thread-Topic: [PATCH 1/4] New netlink command for TID specific configuration
Thread-Index: AQHUajCNBN9RHbfm70WKuA3PqJ0Zo6VC0ViAgANrkgCAAREBgA==
Date:   Fri, 9 Nov 2018 09:47:01 +0000
Message-ID: <20181109094654.7w2etehlz55lv662@bars>
References: <1540230918-27712-1-git-send-email-tamizhr@codeaurora.org>
 <1540230918-27712-2-git-send-email-tamizhr@codeaurora.org>
 <20181106101601.526ovvmabfqrr7sl@bars>
 <7a8662ce7744bee6d9e695c67d7e9643@codeaurora.org>
In-Reply-To: <7a8662ce7744bee6d9e695c67d7e9643@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P192CA0018.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:83::31) To BL0PR05MB4595.namprd05.prod.outlook.com
 (2603:10b6:208:5f::20)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB5507;6:+f68hfVJGq0J/nFaNdxtzpKZNDwGh2ccNy6MPgSnGIw5S9knISLuy5hiL5Iz3wpIs5B+pptp6h26xTqCYvFv8RZurk1JrE2B8qDJyaR15IAOb9rECUqgDAsiz0+OIHK915venKLyfbJoNAUVuodJoxxFqo0OjMvlYXKyJdBc7QnIBIfrqGMtgTlaPqyPE4BDd01WDLhdupAViAJd/yaTBiBGa+eRQhRkd9KBDInkbp5pZpCU8SnfQBGC6sy3EruqiSOK4qK3yxPu/YkXEYRmz5xo06odH+fGuBbO0+Gv+ysm/ZvicavuARCALUF2tThk2T845tBGxf/8z+VTMxGPIrEaNrZt3ICRI+jH1TAuBgszmTIpYKYNhE+Vzd+quL3ZrG0Js0Wq85NZ3cjF2wZpnpI7D/ki/uquT21t3tpRrOzVrrKupq8j2ReH8EpFQMOm2Stbzx5QbI0LzBYgMDVTpw==;5:nxwwPz9TCwW7vCqFze2cWbDMWcNmfNj7WFhO25x48j4LERQaiBzyXpEOePbrI3ZODP/5PN0pwvAOSbJPERuhwWlIZdqn7GZ4tC5eqyE1gnKWKEq6GiVqms6zQ1eS3nftvwOajHjlLeqqpGOFMT2V0+FMsIM5+VLVIdQlda6+u9c=;7:sssf6944S75lPAfdYEE8yKm0urZUTYsTox5Hv2U6q6157r+Hd2LL5I9/UZx83HKSQnDWY5F1/ra/uFSZWlClIXlG45RCUg/1bLzzinjaPppmIwvom6+LqBMpxZEYuBRnGdC+7UrJ9u1FJY7x+g33dA==
x-ms-office365-filtering-correlation-id: aa441696-2f01-4e8d-95a1-08d646284c8e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB5507;
x-ms-traffictypediagnostic: BL0PR05MB5507:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-microsoft-antispam-prvs: <BL0PR05MB55071539963653EAF919C074A3C60@BL0PR05MB5507.namprd05.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3002001)(10201501046)(3231382)(944501410)(52105095)(93006095)(93001095)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123558120)(20161123564045)(20161123560045)(201708071742011)(7699051)(76991095);SRVR:BL0PR05MB5507;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB5507;
x-forefront-prvs: 08512C5403
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(7916004)(366004)(376002)(346002)(136003)(39850400004)(396003)(189003)(199004)(81166006)(81156014)(33896004)(2900100001)(5660300001)(52116002)(6486002)(66066001)(99286004)(68736007)(33716001)(6506007)(229853002)(2906002)(6116002)(54906003)(93886005)(316002)(8936002)(6916009)(14454004)(478600001)(107886003)(71190400001)(1076002)(386003)(3846002)(71200400001)(97736004)(6246003)(25786009)(4326008)(53936002)(106356001)(476003)(8676002)(102836004)(105586002)(6436002)(7736002)(446003)(256004)(76176011)(186003)(486006)(11346002)(14444005)(6512007)(86362001)(26005)(305945005)(9686003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB5507;H:BL0PR05MB4595.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: +fNIMcGsUZWkI2vYpReXxMcg0EWMs5BcBEAbXayf7HDV8sL0HtVfUyYtW37YWV1YoNe4Dq+DqvwKP86+zYK/+rCCaoY7Z8v1ieWhKW/e0rRznTIlO0egfL4tqvucBn+13Y0eV6TkxJ+sjo9LEPlUq96HFchGXCRUU1AyGEX18zn5n/gDvjmKIAg0HfRmSW9sIm6kHr1nDjBDvrCl4uubT56E3nMfOpQVWElE45iliRN9sgN8vV5feDsKg3dYbeKcKCcIBSqs6pTyh7uPBbmHswSnJl/cmLRyDKmHV12UaZMo+oXebv52toKVyYztuo1NtqJ2dZRRJYZO84ogQb89p0QOPR3MH2bQctboOCpKgVY=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <15BA425A48C91040BC7FBC226DFC7A0A@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa441696-2f01-4e8d-95a1-08d646284c8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2018 09:47:01.9324
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB5507
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello Tamizh,

> > > Co-Developed-by: Tamizh Chelvam <tamizhr@codeaurora.org>
> > > Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
> > > Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
> > > ---
> > >  include/net/cfg80211.h       |   14 +++++++
> > >  include/uapi/linux/nl80211.h |   69 ++++++++++++++++++++++++++++++++=
+
> > >  net/wireless/nl80211.c       |   86
> > > ++++++++++++++++++++++++++++++++++++++++++
> > >  net/wireless/rdev-ops.h      |   15 ++++++++
> > >  net/wireless/trace.h         |   27 +++++++++++++
> > >  5 files changed, 211 insertions(+)

...

> > >  /**
> > > @@ -4035,6 +4044,9 @@ struct wiphy_iftype_ext_capab {
> > >   * @txq_limit: configuration of internal TX queue frame limit
> > >   * @txq_memory_limit: configuration internal TX queue memory limit
> > >   * @txq_quantum: configuration of internal TX queue scheduler quantu=
m
> > > + *
> > > + * @max_data_retry_count: Maximum limit can be configured as retry
> > > count
> > > + *     for a TID.
> > >   */
> > >  struct wiphy {
> > >         /* assign these fields before you register the wiphy */
> > > @@ -4171,6 +4183,8 @@ struct wiphy {
> > >         u32 txq_memory_limit;
> > >         u32 txq_quantum;
> > >=20
> > > +       u8 max_data_retry_count;
> > > +
> > >         char priv[0] __aligned(NETDEV_ALIGN);
> > >  };
> >=20
> > Could you please clarify why do you define max_data_retry_count instead
> > of
> > making use of existing wiphy params: retry_short (dot11ShortRetryLimit)
> > and retry_long (dot11LongRetryLimit) ?
>=20
> max_data_retry_count added to validate the max limit for the retry count
> supported by the driver.
> existing wiphy parames: retry_short and retry_long can be modified
> through user command.
> So, I've added this param for validation purpose. Correct me If I'm
> wrong.

Well, but then it probably makes sense to use max_data_retry_count value
to validate retry_short and retry_long values in nl80211_set_wiphy.

Regards,
Sergey
