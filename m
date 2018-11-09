Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BA65C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 09:40:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5775620827
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 09:40:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="0xsdkCiQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5775620827
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727598AbeKITUZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 14:20:25 -0500
Received: from mail-by2nam03on0080.outbound.protection.outlook.com ([104.47.42.80]:11697
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727561AbeKITUY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 14:20:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vrwxrky4Emf+2qiZwCQpLbVe053uUUdlYs+fhh2i3lQ=;
 b=0xsdkCiQ29EhlS/tPZYGs6bra0L4wdQze62cs0bBTvIQ91sNlYSl4bW1Ro2R7W5AmbWlz2a2tuADhhK58gDmk9x/QFhsNaayx+rBNwZDay1TmqIncYDLIq0gHls34Mv+rgmVC8PxahGzIWqKb0XVbDUMuSnMS+yQPpAJQFvlA1M=
Received: from BL0PR05MB4595.namprd05.prod.outlook.com (20.177.144.212) by
 BL0PR05MB4836.namprd05.prod.outlook.com (52.132.15.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.14; Fri, 9 Nov 2018 09:40:24 +0000
Received: from BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::d16b:3a5b:aa09:b156]) by BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::d16b:3a5b:aa09:b156%3]) with mapi id 15.20.1339.013; Fri, 9 Nov 2018
 09:40:24 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Tamizh chelvam <tamizhr@codeaurora.org>
CC:     "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
Subject: Re: [PATCH 1/4] New netlink command for TID specific configuration
Thread-Topic: [PATCH 1/4] New netlink command for TID specific configuration
Thread-Index: AQHUajCNBN9RHbfm70WKuA3PqJ0Zo6VEo+UAgAGd7QCAAQo/AA==
Date:   Fri, 9 Nov 2018 09:40:24 +0000
Message-ID: <20181109094017.j4vkhaprz4zmszch@bars>
References: <1540230918-27712-1-git-send-email-tamizhr@codeaurora.org>
 <1540230918-27712-2-git-send-email-tamizhr@codeaurora.org>
 <20181107140552.zfuusbapgqjumoln@bars>
 <0b75171a7777bd25e203240a3a119cb5@codeaurora.org>
In-Reply-To: <0b75171a7777bd25e203240a3a119cb5@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR0701CA0052.eurprd07.prod.outlook.com
 (2603:10a6:203:2::14) To BL0PR05MB4595.namprd05.prod.outlook.com
 (2603:10b6:208:5f::20)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB4836;6:ET/f7ngASYr9Bn/yW565H8u9Ui0xtnF3ZXzIqJUzBnu5157PQLvNtfJDMY5bXk9Je4K2ScCLwnv+W0F//bgm5170jkBtcGPoFUwzf/LIMEFsq5GVEM8EznOOskSfYQSj+n49hYWesyZRYXN6dJM/x9Zra6JReMDq3GOgowNEp2TOYkVzN9Nmj1/GnK0gUioOK7wbq4f0K3usdK73aeHkYGszonaNYHjnVNoxYOq60gI2rXzVOorIg1g2VyQiAgUfdLTf/QREFZVAPPVe2ZYGYPj8g9ZgQo0j8N3pCCMVAgHfkhR9VIGfoGW8U8img8qbSlZgMozuy0qTvxzAWTFsTaVytRMBZUNb4PTJsQ1zqJ8GzxHQiibiG6wb3mzbK69xr21y5d+nKewSO2ozUxULLB21bapHz6i4r39VJi+NVG1EGXkia7C5TrRJCme4FCh/5qFiFhwijGr5UImeasn/0Q==;5:c2b+/kSSoL/KOtMEvpWIPxueBomzpj9ZSg/1pF5Z90SGeW4Nj1T60Yjf+GYX9s+CEpC3vT8GyjnH39Ll9gRdW0fB28GY90EgZkH6VJe36DPCe+t7GTZkqyYPay3cCyQMFWsXeEzcmIcMxEmvqDm1gF8Np+FX/AqT0I/7tU8qZCA=;7:cLUexfVpwR9VMn6W0UpCICkzvTh5spOKwtidwk+Ki79X2PSlrAzdhYd754zpPQsXuEg2akbNd1VRvBmfl136gHj14YlWx79gibwm4Y3wgecD4cShX+73p75TJVCXad/WYFEb/B0lL4DV8ChB9bwcUA==
x-ms-office365-filtering-correlation-id: c1c31c16-a875-4122-3c8d-08d646275f36
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB4836;
x-ms-traffictypediagnostic: BL0PR05MB4836:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-microsoft-antispam-prvs: <BL0PR05MB4836177CC0E62769738DDF75A3C60@BL0PR05MB4836.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3002001)(10201501046)(93006095)(93001095)(3231382)(944501410)(52105095)(148016)(149066)(150057)(6041310)(20161123560045)(20161123564045)(20161123558120)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BL0PR05MB4836;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB4836;
x-forefront-prvs: 08512C5403
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(366004)(346002)(136003)(396003)(376002)(39850400004)(199004)(189003)(486006)(256004)(106356001)(105586002)(476003)(186003)(11346002)(54906003)(26005)(66066001)(102836004)(446003)(5660300001)(6916009)(86362001)(4326008)(25786009)(76176011)(33716001)(8936002)(6246003)(93886005)(71190400001)(71200400001)(6486002)(68736007)(478600001)(2906002)(6436002)(97736004)(14454004)(1076002)(6116002)(3846002)(229853002)(33896004)(316002)(99286004)(52116002)(2900100001)(6506007)(386003)(6512007)(9686003)(305945005)(7736002)(81156014)(53936002)(8676002)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB4836;H:BL0PR05MB4595.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: aclSXf4J8sdYVoQAR/m///2KG4EJXbOzy7KaQP/HxKe6x8vKJQJFl8bxuZ8WPTe9NInK9Tezx+aJ7nE1lvqppEoqxC+eaG1y2r/Ep+VWxy6of8A1GcEU4hqMlDy1PlTW2fz9VlyVfhbNtj4mjplTi6kbh+TdxFrXFCzlwNSPuBIBWAgqiX8TnpE+W/O8YK9DigxZnXAjjDEFq34Kz+aJekwY1oltmKzMVfrFJ4a2elPzMwluXHg2DjRvhaeH7DrSG5BhBR9va13X5Pi6sRIFiQklCF43ljVPFdG/QY6264g1DoDuQfVf3G65+eCJmOJgG9HpxqCAaYy/eJCekzpcAOlSHFP+rUlVG4yxY0CzwRM=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D9016FE9226B684F93C920BFB685E5FD@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1c31c16-a875-4122-3c8d-08d646275f36
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2018 09:40:24.0536
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB4836
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello Tamizh,

...

> > > +static int nl80211_set_tid_config(struct sk_buff *skb,
> > > +                                 struct genl_info *info)
> > > +{
> > > +       struct cfg80211_registered_device *rdev =3D info->user_ptr[0]=
;
> > > +       struct nlattr *attrs[NL80211_ATTR_TID_MAX + 1];
> > > +       struct nlattr *tid;
> > > +       struct net_device *dev =3D info->user_ptr[1];
> > > +       const char *peer =3D NULL;
> > > +       u8 tid_no;
> > > +       int ret =3D -EINVAL, retry_short =3D -1, retry_long =3D -1;
> > > +
> > > +       tid =3D info->attrs[NL80211_ATTR_TID_CONFIG];
> > > +       if (!tid)
> > > +               return -EINVAL;
> > > +
> > > +       ret =3D nla_parse_nested(attrs, NL80211_ATTR_TID_MAX, tid,
> > > +                              nl80211_attr_tid_policy, info->extack)=
;
> > > +       if (ret)
> > > +               return ret;
> > > +
> > > +       if (!attrs[NL80211_ATTR_TID])
> > > +               return -EINVAL;
> > > +
> > > +       if (attrs[NL80211_ATTR_TID_RETRY_SHORT]) {
> > > +               retry_short =3D
> > > nla_get_u8(attrs[NL80211_ATTR_TID_RETRY_SHORT]);
> > > +               if (!retry_short ||
> > > +                   retry_short > rdev->wiphy.max_data_retry_count)
> > > +                       return -EINVAL;
> > > +       }
> > > +
> > > +       if (attrs[NL80211_ATTR_TID_RETRY_LONG]) {
> > > +               retry_long =3D
> > > nla_get_u8(attrs[NL80211_ATTR_TID_RETRY_LONG]);
> > > +               if (!retry_long ||
> > > +                   retry_long > rdev->wiphy.max_data_retry_count)
> > > +                       return -EINVAL;
> > > +       }
> > > +
> > > +       tid_no =3D nla_get_u8(attrs[NL80211_ATTR_TID]);
> > > +       if (tid_no >=3D IEEE80211_FIRST_TSPEC_TSID)
> > > +               return -EINVAL;
> > > +
> > > +       if (info->attrs[NL80211_ATTR_MAC])
> > > +               peer =3D nla_data(info->attrs[NL80211_ATTR_MAC]);
> > > +
> > > +       if (nla_get_flag(attrs[NL80211_ATTR_TID_RETRY_CONFIG])) {
> >=20
> > Do we really need this additional flag to indicate retry data ?
> > Maybe we can simply check retry attrs or even retry data, e.g.:
>=20
> Yes, because this implementation gives provision to set default retry
> count for TID traffic type for a station.
> Since we use single NL command for all TID configurations, this flag
> will be useful to notify the driver about
> retry TID configuration change.

Ok. So if driver receives retry value (-1), it should reset to some
default value known to driver or firmware. IMHO it worth making it
more explicit: in its current form this convention will not be obvious
for driver authors. Though I don't have a good idea how to do it.
Maybe merge both aggregation and retry cfg80211 callbacks into one
and use structure for params and bitmask for operations...

> >=20
> > if (attrs[NL80211_ATTR_TID_RETRY_LONG] ||
> >     attrs[NL80211_ATTR_TID_RETRY_SHORT]) {
> >     ...
> >=20
> > if ((retry_short > 0) || (retry_long > 0)) {
> >     ...

Regards,
Sergey
