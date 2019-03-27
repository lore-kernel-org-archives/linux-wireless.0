Return-Path: <SRS0=A7Z7=R6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D68CC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 07:29:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 221A62075D
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 07:29:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="T/6JIU06";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="iXYg1pF5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbfC0H3X (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Mar 2019 03:29:23 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:41758 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725795AbfC0H3W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Mar 2019 03:29:22 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x2R7FKJA027123;
        Wed, 27 Mar 2019 00:29:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0818; bh=coY0NakWiQgT40lkuAbt0oY1gXn7E2KEELvwFgMu2gQ=;
 b=T/6JIU06Xt6qXw/cNR9Ktgg4AEYQh1jEtjXSOcc3Y/xasIIxeFm9ZltrCZXDYyWvOfRF
 iOX815y2eQjiWDBDSyv5I4+mM+AcruwlVqIM6F020peFALjEmJ7lKyoMRu0TXHlUA1as
 O7uX7mL3F7BYKNYZ4ckI1OfiMv7g7AjAc/uEPCwr4kYFLdrswOBT59iNNerVsIsboGAE
 3UIN5USPrafcGjsVnot/j6o0IrVfCIugTHrMsjaWsxD5jhj0cbSlgcO894SDse0Kw+jS
 NbSyDs/X5vlb3H69+6KU5j7CqxBnQopYof4iYGEkXIqLdSlA8psmC3t7Si6/nEfg3uys 4A== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2rfjtbtv26-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 27 Mar 2019 00:29:18 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 27 Mar
 2019 00:29:03 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (104.47.33.50) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 27 Mar 2019 00:29:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=coY0NakWiQgT40lkuAbt0oY1gXn7E2KEELvwFgMu2gQ=;
 b=iXYg1pF5gIZl/JIye9xMyD8KbfQEGD15t/7xPZFWsLUTM9xeyQGIh8hbOXraHRjhQBguXaPVymoutOulCD8VcKwtCnI/gIDs9g8UI8eFw/MkTM2A2M54tnRVoml/ugfGsuKOSY4iS3QmNvAEMC7Y8jLxmqmhT84GmbMyrwixwZ8=
Received: from CY4PR18MB1237.namprd18.prod.outlook.com (10.172.177.140) by
 CY4PR18MB0968.namprd18.prod.outlook.com (10.173.182.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.18; Wed, 27 Mar 2019 07:29:01 +0000
Received: from CY4PR18MB1237.namprd18.prod.outlook.com
 ([fe80::d05:bf1b:c20c:af49]) by CY4PR18MB1237.namprd18.prod.outlook.com
 ([fe80::d05:bf1b:c20c:af49%9]) with mapi id 15.20.1750.014; Wed, 27 Mar 2019
 07:29:01 +0000
From:   Ganapathi Bhat <gbhat@marvell.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Cathy Luo <cluo@marvell.com>, Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Rakesh Parmar <rakeshp@marvell.com>,
        Brian Norris <briannorris@chromium.org>
Subject: mwifiex: update set_mac_address logic
Thread-Topic: mwifiex: update set_mac_address logic
Thread-Index: AQHU5G5hjQjjDj7Q502tl1FpVaYtlQ==
Date:   Wed, 27 Mar 2019 07:29:01 +0000
Message-ID: <CY4PR18MB123726E26A33B0E4F48E785FA0580@CY4PR18MB1237.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [182.72.17.59]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 130db5d2-9f01-46fd-062d-08d6b285e206
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600127)(711020)(4605104)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:CY4PR18MB0968;
x-ms-traffictypediagnostic: CY4PR18MB0968:
x-microsoft-antispam-prvs: <CY4PR18MB0968B0CFF728BE0E16E6AA8FA0580@CY4PR18MB0968.namprd18.prod.outlook.com>
x-forefront-prvs: 0989A7979C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(136003)(39860400002)(366004)(376002)(346002)(396003)(189003)(199004)(55016002)(81166006)(5640700003)(316002)(478600001)(9686003)(66066001)(53936002)(8936002)(6916009)(81156014)(6436002)(256004)(99286004)(78486014)(26005)(2501003)(14444005)(8676002)(186003)(71200400001)(86362001)(102836004)(6506007)(55236004)(97736004)(71190400001)(14454004)(25786009)(53546011)(486006)(305945005)(4326008)(476003)(2351001)(7696005)(6116002)(54906003)(7736002)(3846002)(33656002)(68736007)(74316002)(2906002)(52536014)(105586002)(106356001)(5660300002)(15650500001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR18MB0968;H:CY4PR18MB1237.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: x6AGf0X8CMuWqb7ErdbmYpAd+OD8A/jDneoEvB87TPeLoFX3x86XeV+ynYXwZcL5uZh3stnY49RYe4HVQkMqdTxmXjtQ0xnV4dbdZUkRp4Rg+2akiZnBPWNcCZR245CrNiUrJQarFf+Cn+N/oyLFBPttCcPAO2jpD8WvQws8D1moeZ5v3R/L/2W5Y0O31ajAO9BUXwuogPtt+DiPylZfX9IUwh9XR+Ebuk3BBrAvhO35rPTzcVWbGp2UQ2in25uPM7kXQZyicLRaSvr8cw/yocDkDhJUIzvRzFdUowYsNGpnSu1HJmSwNnDtfdCsrltXVxOd0CC/m37pXCJjvBHIDfvht2aufuZwifvoG+HXzsTG5KPWI2SHLS4BcoKjk2a+WdpELSE4bc/mBm3wDLDhZQRtQmrvp8ApNX9mbwvNUL0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 130db5d2-9f01-46fd-062d-08d6b285e206
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2019 07:29:01.0302
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR18MB0968
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-03-27_04:,,
 signatures=0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sharvari Harisangam <sharvari@marvell.com>
Date: Wed, 27 Mar 2019 11:47:03 +0530
Subject: mwifiex: update set_mac_address logic

In set_mac_address, driver check for interfaces with same bss_type
For first STA entry, this would return 3 interfaces since all priv's have
bss_type as 0 due to kzalloc. Thus mac address gets changed for STA
unexpected. This patch adds check for first STA and avoids mac address
change. This patch also adds mac_address change for p2p based on bss_num
type.

Signed-off-by: Sharvari Harisangam <sharvari@marvell.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wire=
less/marvell/mwifiex/main.c
index 5ed2d9b..4eabd94 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -965,10 +965,10 @@ int mwifiex_set_mac_address(struct mwifiex_private *p=
riv,

        mac_addr =3D old_mac_addr;

-       if (priv->bss_type =3D=3D MWIFIEX_BSS_TYPE_P2P)
+       if (priv->bss_type =3D=3D MWIFIEX_BSS_TYPE_P2P) {
            mac_addr |=3D BIT_ULL(MWIFIEX_MAC_LOCAL_ADMIN_BIT);
-
-       if (mwifiex_get_intf_num(priv->adapter, priv->bss_type) > 1) {
+           mac_addr +=3D priv->bss_num;
+       } else if (priv->adapter->priv[0] !=3D priv) {
            /* Set mac address based on bss_type/bss_num */
            mac_addr ^=3D BIT_ULL(priv->bss_type + 8);
            mac_addr +=3D priv->bss_num;
--=20
1.9.1

