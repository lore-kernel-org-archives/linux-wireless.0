Return-Path: <SRS0=G8on=RY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C238C4360F
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 15:47:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E723218A5
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 15:47:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="Fvc428XV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbfCUPrj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Mar 2019 11:47:39 -0400
Received: from mail-eopbgr820083.outbound.protection.outlook.com ([40.107.82.83]:25640
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728071AbfCUPrh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Mar 2019 11:47:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ujVVrXHulRDCKk2ANFN8BA74eY5IAm7tgwfnAhUKhM=;
 b=Fvc428XVUcxqw3rJezvaZRI6JAOB+WJ+iSbGP4wbByCBZUUWTTr81ZurGy2zqmiLbyWtDfoelcm5fJjqV+XtrPQLigMQVHTSgBSzUd9xoIo+eoUJmAaZK2SNQ3W8inV9rT6fvnT6Bn+mfFo3LxwCtSfwQgFT+9OZZWN+PXa3E3E=
Received: from BYAPR05MB4711.namprd05.prod.outlook.com (52.135.233.89) by
 BYAPR05MB4933.namprd05.prod.outlook.com (52.135.235.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.16; Thu, 21 Mar 2019 15:47:11 +0000
Received: from BYAPR05MB4711.namprd05.prod.outlook.com
 ([fe80::c9ee:8c50:f84e:b8ce]) by BYAPR05MB4711.namprd05.prod.outlook.com
 ([fe80::c9ee:8c50:f84e:b8ce%2]) with mapi id 15.20.1709.015; Thu, 21 Mar 2019
 15:47:11 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB4382.namprd05.prod.outlook.com (52.135.74.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.13; Thu, 21 Mar 2019 15:46:23 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e%4]) with mapi id 15.20.1709.015; Thu, 21 Mar 2019
 15:46:23 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
CC:     Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: Re: [PATCH 12/14] qtnfmac: fix debugfs entries for multiple cards on
 the same host
Thread-Topic: [PATCH 12/14] qtnfmac: fix debugfs entries for multiple cards on
 the same host
Thread-Index: AQHU3wRBThr6jAugZ0GKclwbi1SOe6YUjg/QgABGCoCAAN8a2YAALKWAgABckQA=
Date:   Thu, 21 Mar 2019 15:46:23 +0000
Message-ID: <20190321154617.zouatzq2mrddu53y@bars>
References: <20190320100340.14168-1-sergey.matyukevich.os@quantenna.com>
 <20190320100340.14168-13-sergey.matyukevich.os@quantenna.com>
 <874l7xzlmo.fsf@purkki.adurom.net> <20190320151641.3477cx3kuc3ipqam@bars>
 <8736ngsms9.fsf@codeaurora.org>
 <5d1012ab-9c4e-3c14-05b6-f76e6fde2951@broadcom.com>
In-Reply-To: <5d1012ab-9c4e-3c14-05b6-f76e6fde2951@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR02CA0015.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::28) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0f04243e-5093-4c15-5d2d-08d6ae145ecc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB4382;
x-ms-traffictypediagnostic: SN6PR05MB4382:|BYAPR05MB4933:
x-moderation-data: 3/21/2019 3:47:10 PM
x-microsoft-antispam-prvs: <BYAPR05MB4933333467DBDFC315F10FBDA3420@BYAPR05MB4933.namprd05.prod.outlook.com>
x-forefront-prvs: 0983EAD6B2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(136003)(39850400004)(376002)(346002)(366004)(396003)(189003)(199004)(186003)(8676002)(106356001)(66066001)(5024004)(71190400001)(486006)(102836004)(4326008)(14454004)(6116002)(97736004)(5660300002)(6506007)(86362001)(33716001)(9686003)(476003)(6916009)(6512007)(3846002)(71200400001)(256004)(7736002)(305945005)(53936002)(386003)(14444005)(2906002)(25786009)(52116002)(93886005)(76176011)(99286004)(446003)(81166006)(26005)(68736007)(54906003)(81156014)(11346002)(436003)(6436002)(8936002)(229853002)(105586002)(6246003)(6486002)(1076003)(316002)(478600001)(107886003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB4933;H:BYAPR05MB4711.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZrY6xF32v7iNBRdT+WZ3DoA8Wca2+bsn7ReJJEUegBVg3xxjNzd0pUAbW7FBTwShkpjqpvY5pD685GDfr3pmwRIBGeMHlPn9oat9Ez0n34PTfROcBCIaSQyj+N9a6De4G+04Jknekz8sUfLJmupi367deQoeNgS67BFaYzeZIdorOO/MsVAWgK/3nW2C82d1QuKmQpWTpefgqguZwIxYmXLv0w4qNFZaYSrP/nBp6d93beADZS40XlITdJtKugrtxegBu4VNkvRiDYmgOTN46KkJa1dGI5WVDLA1guibLuP4/oOUatgPdtCpmAsd0+VqtDlIJRg71afVlPPaJw/Od/XbOLIDfpAfVsJ0OXvGvx+ZWwVqw14JoW58qcsgO+hd9ANoFMAYajOiQwHjQ6PASDtz6IYw8I+D2Pz1pg5xHfo=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3376B9480F37E4489DC084CEDCD9F2DD@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f04243e-5093-4c15-5d2d-08d6ae145ecc
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2019 15:47:11.7900
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4933
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> > > > > Fix creation of debugfs entries for qtnfmac wireless card: use se=
parate
> > > > > directories for different wireless cards. This commit enables sup=
port
> > > > > for multiple qtnfmac wireless cards on the same PCIe host.
> > > > >=20
> > > > > Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenn=
a.com>
> > > > > ---
> > > > >   drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c | 6 +++++-
> > > > >   1 file changed, 5 insertions(+), 1 deletion(-)
> > > > >=20
> > > > > diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c b=
/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
> > > > > index b561b75e4433..56fc6d49c121 100644
> > > > > --- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
> > > > > +++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
> > > > > @@ -130,6 +130,8 @@ static int qtnf_dbg_shm_stats(struct seq_file=
 *s, void *data)
> > > > >=20
> > > > >   int qtnf_pcie_fw_boot_done(struct qtnf_bus *bus)
> > > > >   {
> > > > > +     struct qtnf_pcie_bus_priv *priv =3D get_bus_priv(bus);
> > > > > +     char card_id[64];
> > > > >        int ret;
> > > > >=20
> > > > >        bus->fw_state =3D QTNF_FW_STATE_BOOT_DONE;
> > > > > @@ -137,7 +139,9 @@ int qtnf_pcie_fw_boot_done(struct qtnf_bus *b=
us)
> > > > >        if (ret) {
> > > > >                pr_err("failed to attach core\n");
> > > > >        } else {
> > > > > -             qtnf_debugfs_init(bus, DRV_NAME);
> > > > > +             snprintf(card_id, sizeof(card_id), "%s:%s",
> > > > > +                      DRV_NAME, pci_name(priv->pdev));
> > > >=20
> > > > Can you give an example for the path?
> > > >=20
> > >=20
> > > For instance:  /sys/kernel/debug/qtnfmac_pcie:0000:01:00.0
> >=20
> > TBH not really fond of that. What about
> > "/sys/kernel/debug/qtnfmac/pcie:0000:01:00.0"? IIRC iwlwifi used
> > something like that.


Hello Arend,

> In brcmfmac we used to have it like that, but I changed it to use wiphy
> debugfs, ie. /sys/kernel/debug/ieee80211/phyX/.

Yes, I saw the patches for brcmfmac. In fact, looking at those patches
we figured out that we have a problem before we started testing
two cards in one pcie host :)

But /sys/kernel/debug/eee80211/phyX approach does not fit well for our
use-case. We may have up to 3 phy-s for single card, but counters
exported via debugfs are for pcie device as a whole.

Thanks,
Sergey
