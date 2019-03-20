Return-Path: <SRS0=2I9a=RX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F377DC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 10:05:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAA182184E
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 10:05:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="qmVcaRKm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbfCTKFS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Mar 2019 06:05:18 -0400
Received: from mail-eopbgr740073.outbound.protection.outlook.com ([40.107.74.73]:60864
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727054AbfCTKFR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Mar 2019 06:05:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=69Gw43XMINcbHa57Znd+s8wPtyT1V2KH4BZoGsz62QQ=;
 b=qmVcaRKmWn5eKu6/SoXpGJV3tguuCTZ57CNeT63Y9mhabbGHC6rtswC0t2lvBAqLrS07HSTw4FD1Qz4pMKowhFGAljPEM49u0YRPeAZf8+1dXhC6iD3R5c2FZ4kKxznCc2ZoSIkNmaB/dcewz7JmZjBg5++dWeMBcWVBxE9IW6Y=
Received: from DM5PR0501MB3701.namprd05.prod.outlook.com (10.167.106.19) by
 DM5PR0501MB3910.namprd05.prod.outlook.com (10.167.108.37) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.16; Wed, 20 Mar 2019 10:05:15 +0000
Received: from DM5PR0501MB3701.namprd05.prod.outlook.com
 ([fe80::fc20:4997:6034:8b47]) by DM5PR0501MB3701.namprd05.prod.outlook.com
 ([fe80::fc20:4997:6034:8b47%2]) with mapi id 15.20.1709.015; Wed, 20 Mar 2019
 10:05:15 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB5661.namprd05.prod.outlook.com (52.135.111.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.15; Wed, 20 Mar 2019 10:04:07 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e%4]) with mapi id 15.20.1709.015; Wed, 20 Mar 2019
 10:04:07 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 12/14] qtnfmac: fix debugfs entries for multiple cards on the
 same host
Thread-Topic: [PATCH 12/14] qtnfmac: fix debugfs entries for multiple cards on
 the same host
Thread-Index: AQHU3wRBThr6jAugZ0GKclwbi1SOew==
Date:   Wed, 20 Mar 2019 10:04:07 +0000
Message-ID: <20190320100340.14168-13-sergey.matyukevich.os@quantenna.com>
References: <20190320100340.14168-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20190320100340.14168-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0106.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::47) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.11.0
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 724e5e4d-0d08-4208-7902-08d6ad1b63e8
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB5661;
x-ms-traffictypediagnostic: SN6PR05MB5661:|DM5PR0501MB3910:
x-moderation-data: 3/20/2019 10:05:13 AM
x-microsoft-antispam-prvs: <DM5PR0501MB3910BA001CDE16BBF5B3ED3BA3410@DM5PR0501MB3910.namprd05.prod.outlook.com>
x-forefront-prvs: 098291215C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(136003)(346002)(39840400004)(396003)(366004)(199004)(189003)(8676002)(66066001)(81156014)(6486002)(50226002)(256004)(14444005)(5024004)(5660300002)(102836004)(6506007)(5640700003)(436003)(3846002)(6116002)(386003)(103116003)(26005)(71190400001)(186003)(54906003)(316002)(71200400001)(14454004)(68736007)(97736004)(2501003)(25786009)(8936002)(86362001)(81166006)(99286004)(6436002)(478600001)(76176011)(2351001)(4326008)(36756003)(107886003)(486006)(6916009)(2616005)(53936002)(105586002)(106356001)(305945005)(446003)(6512007)(11346002)(476003)(2906002)(1076003)(7736002)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR0501MB3910;H:DM5PR0501MB3701.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: lQbgtKeZfA/GRHCmPWwwQL0BYOHWZ21MQijD26tMdlzx6Tlteo5vJrInxlUS+hSuxyeDNsaU+F9tTEMo2f7maCIk2aVV3yEdJ7Yw717SKKV8PwrOfkqKaUI+gFBnqCu6dAoZ+k6a6vKV5yhjLq6m+0n/01itOwCscNIgiX3M1NE3PRmCufIaTZDngF2C8qgqmsDnV0Yzb/8iZYV2UgAjYYpq9q5V8mLxtAF16YAzpz1FBXqy5SjJ0oH5jcXaSqH9crU7xrS6rug1+1+5sQnu9WnI+jSwDF7rSTAq1DfSxifbGMBlQ11flbgtOfIVAksugUDjC82PM9MDK8yhNI4Gsswa02GJ2u5wx0h41mkm5IJYcPC3KxxFfLHfVrY7qsYtvBfkC98ug+/7dOH0Okj02F27W5gsL3Vm1HwtNCxlw9k=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 724e5e4d-0d08-4208-7902-08d6ad1b63e8
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2019 10:05:15.5810
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0501MB3910
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix creation of debugfs entries for qtnfmac wireless card: use separate
directories for different wireless cards. This commit enables support
for multiple qtnfmac wireless cards on the same PCIe host.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c b/drivers/n=
et/wireless/quantenna/qtnfmac/pcie/pcie.c
index b561b75e4433..56fc6d49c121 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
@@ -130,6 +130,8 @@ static int qtnf_dbg_shm_stats(struct seq_file *s, void =
*data)
=20
 int qtnf_pcie_fw_boot_done(struct qtnf_bus *bus)
 {
+	struct qtnf_pcie_bus_priv *priv =3D get_bus_priv(bus);
+	char card_id[64];
 	int ret;
=20
 	bus->fw_state =3D QTNF_FW_STATE_BOOT_DONE;
@@ -137,7 +139,9 @@ int qtnf_pcie_fw_boot_done(struct qtnf_bus *bus)
 	if (ret) {
 		pr_err("failed to attach core\n");
 	} else {
-		qtnf_debugfs_init(bus, DRV_NAME);
+		snprintf(card_id, sizeof(card_id), "%s:%s",
+			 DRV_NAME, pci_name(priv->pdev));
+		qtnf_debugfs_init(bus, card_id);
 		qtnf_debugfs_add_entry(bus, "mps", qtnf_dbg_mps_show);
 		qtnf_debugfs_add_entry(bus, "msi_enabled", qtnf_dbg_msi_show);
 		qtnf_debugfs_add_entry(bus, "shm_stats", qtnf_dbg_shm_stats);
--=20
2.11.0

