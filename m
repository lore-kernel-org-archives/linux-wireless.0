Return-Path: <SRS0=2I9a=RX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B933AC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 15:17:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81C1B2184D
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 15:17:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="OrPKrGXP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727419AbfCTPRb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Mar 2019 11:17:31 -0400
Received: from mail-eopbgr790088.outbound.protection.outlook.com ([40.107.79.88]:55040
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727372AbfCTPRb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Mar 2019 11:17:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mwxhAO+pKRKUGZ31dBzzXVqpEMcBr+zOfE7nUhS9O8g=;
 b=OrPKrGXP8K2jPU6Dey8qQNscD3ZM88HFid5w/pi3T5iz3OzWJjEFfk5XaLiJsNCT5hZsNT0PIn9OY4S8iZOAL55m9uSndHE1GfQEZe9TtEfNy98YAjxCuiBMbfQr44H9PnN6dETokTDcRLZHR9tGBWHkLA9KdtSs07WGSLLFxaM=
Received: from SN6PR05MB4174.namprd05.prod.outlook.com (52.135.67.141) by
 SN6PR05MB4766.namprd05.prod.outlook.com (52.135.115.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.8; Wed, 20 Mar 2019 15:17:27 +0000
Received: from SN6PR05MB4174.namprd05.prod.outlook.com
 ([fe80::2021:dd:4bb0:4adc]) by SN6PR05MB4174.namprd05.prod.outlook.com
 ([fe80::2021:dd:4bb0:4adc%3]) with mapi id 15.20.1709.015; Wed, 20 Mar 2019
 15:17:26 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB4589.namprd05.prod.outlook.com (52.135.75.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.15; Wed, 20 Mar 2019 15:16:47 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e%4]) with mapi id 15.20.1709.015; Wed, 20 Mar 2019
 15:16:47 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: Re: [PATCH 12/14] qtnfmac: fix debugfs entries for multiple cards on
 the same host
Thread-Topic: [PATCH 12/14] qtnfmac: fix debugfs entries for multiple cards on
 the same host
Thread-Index: AQHU3wRBThr6jAugZ0GKclwbi1SOe6YUjg/QgAATwAA=
Date:   Wed, 20 Mar 2019 15:16:47 +0000
Message-ID: <20190320151641.3477cx3kuc3ipqam@bars>
References: <20190320100340.14168-1-sergey.matyukevich.os@quantenna.com>
 <20190320100340.14168-13-sergey.matyukevich.os@quantenna.com>
 <874l7xzlmo.fsf@purkki.adurom.net>
In-Reply-To: <874l7xzlmo.fsf@purkki.adurom.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR01CA0026.prod.exchangelabs.com (2603:10b6:a02:80::39)
 To SN6PR05MB4928.namprd05.prod.outlook.com (2603:10b6:805:9d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fc5f1a4f-a246-474b-faa8-08d6ad471176
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB4589;
x-ms-traffictypediagnostic: SN6PR05MB4589:|SN6PR05MB4766:
x-moderation-data: 3/20/2019 3:17:24 PM
x-microsoft-antispam-prvs: <SN6PR05MB4766A645E6DEF340BDF68128A3410@SN6PR05MB4766.namprd05.prod.outlook.com>
x-forefront-prvs: 098291215C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(366004)(376002)(136003)(396003)(346002)(39850400004)(199004)(189003)(186003)(478600001)(6916009)(6116002)(3846002)(52116002)(2906002)(26005)(1076003)(33716001)(99286004)(25786009)(14454004)(446003)(5660300002)(11346002)(476003)(486006)(86362001)(436003)(97736004)(53936002)(6512007)(9686003)(68736007)(76176011)(6486002)(4326008)(229853002)(66066001)(305945005)(71200400001)(6436002)(7736002)(54906003)(102836004)(106356001)(105586002)(256004)(14444005)(6506007)(386003)(6246003)(5024004)(8936002)(107886003)(316002)(81166006)(81156014)(71190400001)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR05MB4766;H:SN6PR05MB4174.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: hF0Obn8KTp6xYUukIMk3EB31f8pieTcGLQuV8LDB9eMN5b12oadtluEMOMZIs12DMzQ7Hzwhww+bZYATWp7w5tc8aP0k3lmQQtUlI2cZJ6tAoIEoeUigqroPl4h0SO5MaX5PcJrth2I69u8JJpxj879YrmoE1AsWV6xqjORJbMaA7a0hFv1c0niNOL8ZzjqwQURV25ZAtHa+Lfpvj9ekGCzGmuGlhP6mC1aaEF3UgCBcwFs28M2gAv7mtUaFQS6HkjKp88Y1944MNE+trJyeLPvhvw+dTbt2YOYzdvqt6oeITKp95wnx9bqBVXIu4kRJKzmdJZeJvV3427gRvDRIedUprH7CZ3uMp0mFXGlWVSCxTtWsWuvf4e5YLc2bxFCZB3j4oYelTDoGhkML+Ra5jU+hccIn8/iJaOoi3EDkMaE=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6C59CF8545ECA34A91204F3AB4350010@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc5f1a4f-a246-474b-faa8-08d6ad471176
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2019 15:17:26.8860
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR05MB4766
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> > Fix creation of debugfs entries for qtnfmac wireless card: use separate
> > directories for different wireless cards. This commit enables support
> > for multiple qtnfmac wireless cards on the same PCIe host.
> >
> > Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
> > ---
> >  drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c b/drive=
rs/net/wireless/quantenna/qtnfmac/pcie/pcie.c
> > index b561b75e4433..56fc6d49c121 100644
> > --- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
> > +++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
> > @@ -130,6 +130,8 @@ static int qtnf_dbg_shm_stats(struct seq_file *s, v=
oid *data)
> >
> >  int qtnf_pcie_fw_boot_done(struct qtnf_bus *bus)
> >  {
> > +     struct qtnf_pcie_bus_priv *priv =3D get_bus_priv(bus);
> > +     char card_id[64];
> >       int ret;
> >
> >       bus->fw_state =3D QTNF_FW_STATE_BOOT_DONE;
> > @@ -137,7 +139,9 @@ int qtnf_pcie_fw_boot_done(struct qtnf_bus *bus)
> >       if (ret) {
> >               pr_err("failed to attach core\n");
> >       } else {
> > -             qtnf_debugfs_init(bus, DRV_NAME);
> > +             snprintf(card_id, sizeof(card_id), "%s:%s",
> > +                      DRV_NAME, pci_name(priv->pdev));
>=20
> Can you give an example for the path?
>=20

For instance:  /sys/kernel/debug/qtnfmac_pcie:0000:01:00.0

Regards,
Sergey
