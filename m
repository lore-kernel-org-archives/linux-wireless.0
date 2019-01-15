Return-Path: <SRS0=v11p=PX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9BD6C43387
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 06:42:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 898DA20859
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 06:42:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=qti.qualcomm.com header.i=@qti.qualcomm.com header.b="yVftV5fT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbfAOGmY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jan 2019 01:42:24 -0500
Received: from alexa-out-tai-02.qualcomm.com ([103.229.16.227]:56590 "EHLO
        alexa-out-tai-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726975AbfAOGmY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jan 2019 01:42:24 -0500
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jan 2019 01:42:22 EST
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=qti.qualcomm.com; i=@qti.qualcomm.com; q=dns/txt;
  s=qcdkim; t=1547534542; x=1579070542;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=88bZE27DOq7LgPuLHt4VX3wyGZsmyVEtmvrhaimXHu0=;
  b=yVftV5fTp8RBDH6t49ULjvcti/lzbD0s8DQBImyW2PoXlC2N31yAlMH8
   tMuEZQ81fjYSaEIhGkYj+5/gaORrI30go+2mpsjBu1tr+2nxDDl33kHJ8
   b1cth4G8EdbQJGG8rJVSiPixq6ucAseYh7aD/ccgP83XhzmyuTo/k+jBo
   M=;
X-IronPort-AV: E=Sophos;i="5.56,480,1539619200"; 
   d="scan'208";a="1801672"
Subject: RE: [PATCH] ath10k: fix S5 power consumption issue for QCA9377
Thread-Topic: [PATCH] ath10k: fix S5 power consumption issue for QCA9377
Received: from ironmsg03-tai.qualcomm.com ([10.249.140.8])
  by alexa-out-tai-02.qualcomm.com with ESMTP; 15 Jan 2019 14:36:03 +0800
X-IronPort-AV: E=McAfee;i="5900,7806,9136"; a="21995386"
Received: from aptaiexm02e.ap.qualcomm.com ([10.249.150.15])
  by ironmsg03-tai.qualcomm.com with ESMTP/TLS/AES256-SHA; 15 Jan 2019 14:36:03 +0800
Received: from aptaiexm02a.ap.qualcomm.com (10.249.150.11) by
 aptaiexm02e.ap.qualcomm.com (10.249.150.15) with Microsoft SMTP Server (TLS)
 id 15.0.1395.4; Tue, 15 Jan 2019 14:36:01 +0800
Received: from aptaiexm02a.ap.qualcomm.com ([fe80::1903:8789:b1db:f24c]) by
 aptaiexm02a.ap.qualcomm.com ([fe80::1903:8789:b1db:f24c%19]) with mapi id
 15.00.1395.000; Tue, 15 Jan 2019 14:36:01 +0800
From:   Robert Chang <rwchang@qti.qualcomm.com>
To:     Yu Wang <yyuwang@codeaurora.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Karen Huang (TAM)" <yahuan@qti.qualcomm.com>
Thread-Index: AQHUrJxWZ4OiysEV/EOjY5A7ql0mD6Wv39xg
Date:   Tue, 15 Jan 2019 06:36:01 +0000
Message-ID: <9149f921df804d68b33c76cb01beb62b@aptaiexm02a.ap.qualcomm.com>
References: <1547533867-15131-1-git-send-email-yyuwang@codeaurora.org>
In-Reply-To: <1547533867-15131-1-git-send-email-yyuwang@codeaurora.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.249.136.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

+ Karen

Thanks,
Robert

-----Original Message-----
From: ath10k <ath10k-bounces@lists.infradead.org> On Behalf Of Yu Wang
Sent: Tuesday, January 15, 2019 2:31 PM
To: ath10k@lists.infradead.org
Cc: Yu Wang <yyuwang@codeaurora.org>; linux-wireless@vger.kernel.org
Subject: [EXT] [PATCH] ath10k: fix S5 power consumption issue for QCA9377

After system entering S5 (shut down but system still providing power to QCA=
9377) on Ubuntu platform, power consumption of QCA9377 is 69mA, which is to=
o high.
The root cause is pci_soft_reset is not set for QCA9377 during pci probe.
To fix this issue, set 'pci_soft_reset' to 'th10k_pci_warm_reset', and then=
 the power consumption drops to a normal value(10mA).
Verified on Dell Ubuntu platform with firmware:
WLAN.TF.1.0-00002-QCATFSWPZ-5

Signed-off-by: Yu Wang <yyuwang@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/a=
th/ath10k/pci.c
index 01b4edb..0a4ce98 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -3554,7 +3554,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	case QCA9377_1_0_DEVICE_ID:
 		hw_rev =3D ATH10K_HW_QCA9377;
 		pci_ps =3D true;
-		pci_soft_reset =3D NULL;
+		pci_soft_reset =3D ath10k_pci_warm_reset;
 		pci_hard_reset =3D ath10k_pci_qca6174_chip_reset;
 		targ_cpu_to_ce_addr =3D ath10k_pci_qca6174_targ_cpu_to_ce_addr;
 		break;
--
1.9.1


_______________________________________________
ath10k mailing list
ath10k@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/ath10k
