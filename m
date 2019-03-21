Return-Path: <SRS0=G8on=RY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23444C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 08:26:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD069218A2
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 08:26:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="lxSJq3TW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbfCUI0h (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Mar 2019 04:26:37 -0400
Received: from mail-eopbgr700088.outbound.protection.outlook.com ([40.107.70.88]:7328
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725985AbfCUI0h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Mar 2019 04:26:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q3878b0H0SjdDrfwxmqTcCU0rjsCMKZICsOKsywgLso=;
 b=lxSJq3TWG/iNSlATekDkmZb2x4PAlk99KublhaJHkg+Kz1AMvWmkMzwxh2qSv/XosBOjD2X85egwrgYOYFhBt/AnaJh9ciSzmXhkZ56rfjm3l8wYbRvIxw2PCvwKLgYE/nCQ8mDNDXiMdXZPn5SQzq+B/VQXiTU6E8eDloIEJFs=
Received: from CY4PR05MB2933.namprd05.prod.outlook.com (10.169.184.145) by
 CY4PR05MB3143.namprd05.prod.outlook.com (10.172.155.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.13; Thu, 21 Mar 2019 08:26:34 +0000
Received: from CY4PR05MB2933.namprd05.prod.outlook.com
 ([fe80::d8c2:65f2:8dc8:b231]) by CY4PR05MB2933.namprd05.prod.outlook.com
 ([fe80::d8c2:65f2:8dc8:b231%8]) with mapi id 15.20.1709.015; Thu, 21 Mar 2019
 08:26:34 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB4287.namprd05.prod.outlook.com (52.135.73.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.15; Thu, 21 Mar 2019 08:26:06 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e%4]) with mapi id 15.20.1709.015; Thu, 21 Mar 2019
 08:26:06 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: Re: [PATCH 12/14] qtnfmac: fix debugfs entries for multiple cards on
 the same host
Thread-Topic: [PATCH 12/14] qtnfmac: fix debugfs entries for multiple cards on
 the same host
Thread-Index: AQHU3wRBThr6jAugZ0GKclwbi1SOe6YUjg/QgABGCoCAAN8a2YAADjOA
Date:   Thu, 21 Mar 2019 08:26:06 +0000
Message-ID: <20190321082600.smb64hxdn2lpiqd5@bars>
References: <20190320100340.14168-1-sergey.matyukevich.os@quantenna.com>
 <20190320100340.14168-13-sergey.matyukevich.os@quantenna.com>
 <874l7xzlmo.fsf@purkki.adurom.net> <20190320151641.3477cx3kuc3ipqam@bars>
 <8736ngsms9.fsf@codeaurora.org>
In-Reply-To: <8736ngsms9.fsf@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0009.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::22) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 91b4f601-3c7f-4e5c-055d-08d6add6dceb
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB4287;
x-ms-traffictypediagnostic: SN6PR05MB4287:|CY4PR05MB3143:
x-moderation-data: 3/21/2019 8:26:31 AM
x-microsoft-antispam-prvs: <CY4PR05MB3143EB2F48E59017F3697ABAA3420@CY4PR05MB3143.namprd05.prod.outlook.com>
x-forefront-prvs: 0983EAD6B2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(136003)(396003)(366004)(346002)(376002)(39840400004)(189003)(199004)(476003)(436003)(6916009)(446003)(11346002)(97736004)(478600001)(99286004)(93886005)(54906003)(316002)(26005)(102836004)(386003)(186003)(52116002)(25786009)(1076003)(6506007)(76176011)(66066001)(8676002)(486006)(8936002)(106356001)(81156014)(81166006)(305945005)(105586002)(71190400001)(71200400001)(14454004)(53936002)(6116002)(7736002)(3846002)(6246003)(6486002)(107886003)(68736007)(33716001)(5660300002)(2906002)(229853002)(86362001)(6512007)(9686003)(4326008)(5024004)(256004)(14444005)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR05MB3143;H:CY4PR05MB2933.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: N4UmG/ux6Zgvbg9qUPhb7VejWLE3IqPkYUovG34hH46mz/5fjG1m4wiO9t+31Nwmxexs55cqFC3kYe2URB0CDoFh42z/PsgQoQHoYq6ATrCA0ulPXN2N8wyT5Tb14LRioAfKZgIlpDYHOu8sWIVpjCqHOvrILpb/861LNDyOhHc0/XgdnQYplgd+XZuSt69InSErWoPXT4WUWL7Dr3/cccuqb3avjAmpW03qXPvR/j76INn0J5IbuuIEB9rrnNrzGS/oPbnr3jG76CXE+OQ6q6DoG8dxSCHosTDzWN2IaKDVQcQdagVmGvhWlVUmRhNU6hh/OLrpU0A/asMdNa9RDiiEDlKBmLvpQkgONc+b2lh1JxU9zFiu0m08pue6CL0lSTzRUbY9jWaZmaFu7wdi/Hry4R95GTsBl86o8E+BnGE=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7084DC9130719740B2B4E4D3046B6552@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91b4f601-3c7f-4e5c-055d-08d6add6dceb
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2019 08:26:34.0721
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR05MB3143
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello Kalle,

> >> > Fix creation of debugfs entries for qtnfmac wireless card: use separ=
ate
> >> > directories for different wireless cards. This commit enables suppor=
t
> >> > for multiple qtnfmac wireless cards on the same PCIe host.
> >> >
> >> > Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.c=
om>
> >> > ---
> >> >  drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c | 6 +++++-
> >> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >> >
> >> > diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c b/dr=
ivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
> >> > index b561b75e4433..56fc6d49c121 100644
> >> > --- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
> >> > +++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
> >> > @@ -130,6 +130,8 @@ static int qtnf_dbg_shm_stats(struct seq_file *s=
, void *data)
> >> >
> >> >  int qtnf_pcie_fw_boot_done(struct qtnf_bus *bus)
> >> >  {
> >> > +     struct qtnf_pcie_bus_priv *priv =3D get_bus_priv(bus);
> >> > +     char card_id[64];
> >> >       int ret;
> >> >
> >> >       bus->fw_state =3D QTNF_FW_STATE_BOOT_DONE;
> >> > @@ -137,7 +139,9 @@ int qtnf_pcie_fw_boot_done(struct qtnf_bus *bus)
> >> >       if (ret) {
> >> >               pr_err("failed to attach core\n");
> >> >       } else {
> >> > -             qtnf_debugfs_init(bus, DRV_NAME);
> >> > +             snprintf(card_id, sizeof(card_id), "%s:%s",
> >> > +                      DRV_NAME, pci_name(priv->pdev));
> >>
> >> Can you give an example for the path?
> >>
> >
> > For instance:  /sys/kernel/debug/qtnfmac_pcie:0000:01:00.0
>=20
> TBH not really fond of that. What about
> "/sys/kernel/debug/qtnfmac/pcie:0000:01:00.0"? IIRC iwlwifi used
> something like that.
>=20
> And please add an example path to the commit log.

Ok, will be fixed and resubmitted in v2.

Or, alternatively, if the other patches are ok for you,
feel free to drop the questionable ones and apply all
the others. I will rework the rejected pieces and
resubmit them, adding more pending fixes.

Regards,
Sergey
