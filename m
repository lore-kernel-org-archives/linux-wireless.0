Return-Path: <SRS0=wltO=RL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 934C9C4360F
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 15:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F25320868
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 15:25:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=camlinlimited.onmicrosoft.com header.i=@camlinlimited.onmicrosoft.com header.b="XiuDnBlQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbfCHPZH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Mar 2019 10:25:07 -0500
Received: from mail-eopbgr100075.outbound.protection.outlook.com ([40.107.10.75]:15584
        "EHLO GBR01-LO2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726296AbfCHPZH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Mar 2019 10:25:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=camlinlimited.onmicrosoft.com; s=selector1-camlintechnologies-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3PR/SdB4LMYpipOFkW03otiZL4+XM2jXa+deT/Fca+U=;
 b=XiuDnBlQgAke06GPG3D0KdN7RhNE3HS+96xsgk+y1SHItcZLixDsuo7BKQnaQ+HcsAlWYzulFtWHlcJHHYR/qnkwBiAB4krWppGNSP+UB2GZsbrCvolbHNGTKF0yB3L1FsVkbU09MhoP+vfkB5dMq11MHduuKenm/e/hXgnWP+Q=
Received: from LNXP123MB2185.GBRP123.PROD.OUTLOOK.COM (20.179.129.83) by
 LNXP123MB2106.GBRP123.PROD.OUTLOOK.COM (20.179.129.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1686.18; Fri, 8 Mar 2019 15:25:04 +0000
Received: from LNXP123MB2185.GBRP123.PROD.OUTLOOK.COM
 ([fe80::396a:e27e:d5dd:6bf0]) by LNXP123MB2185.GBRP123.PROD.OUTLOOK.COM
 ([fe80::396a:e27e:d5dd:6bf0%5]) with mapi id 15.20.1686.018; Fri, 8 Mar 2019
 15:25:04 +0000
From:   Piotr Figiel <p.figiel@camlintechnologies.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC:     "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
        "chi-hsien.lin@cypress.com" <chi-hsien.lin@cypress.com>,
        "wright.feng@cypress.com" <wright.feng@cypress.com>,
        "brcm80211-dev-list@cypress.com" <brcm80211-dev-list@cypress.com>,
        Pawel Lenkow <p.lenkow@camlintechnologies.com>,
        Lech Perczak <l.perczak@camlintechnologies.com>,
        =?iso-8859-2?Q?Krzysztof_Drobi=F1ski?= 
        <k.drobinski@camlintechnologies.com>,
        Piotr Figiel <p.figiel@camlintechnologies.com>
Subject: [PATCH 1/3] brcmfmac: fix race during disconnect when USB completion
 is in progress
Thread-Topic: [PATCH 1/3] brcmfmac: fix race during disconnect when USB
 completion is in progress
Thread-Index: AQHU1cMaAlmNpwu8GkCXDUXewU3Jmw==
Date:   Fri, 8 Mar 2019 15:25:04 +0000
Message-ID: <1552058658-23250-2-git-send-email-p.figiel@camlintechnologies.com>
References: <1552058658-23250-1-git-send-email-p.figiel@camlintechnologies.com>
In-Reply-To: <1552058658-23250-1-git-send-email-p.figiel@camlintechnologies.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [95.143.242.242]
x-clientproxiedby: DB6PR07CA0010.eurprd07.prod.outlook.com
 (2603:10a6:6:2d::20) To LNXP123MB2185.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:dc::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=p.figiel@camlintechnologies.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f5285d48-46ec-42e1-3586-08d6a3da3d10
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:LNXP123MB2106;
x-ms-traffictypediagnostic: LNXP123MB2106:
x-microsoft-exchange-diagnostics: =?iso-8859-2?Q?1;LNXP123MB2106;23:V8rl0huorYu4z4V7/ZdMkLvp93hPatZLbQXcTyr?=
 =?iso-8859-2?Q?g6zVqYHamYziTPWX/n64XUnR1x6D941H4MVk2+Fdv68JTGCVx6AVYeecLd?=
 =?iso-8859-2?Q?hhHV/d/VeKkgerlcrgRX2nyJ2voSOfH99iKWQfAs3eH51pEqgiGZXK0+a2?=
 =?iso-8859-2?Q?VOLp1/1whGJH2fepPfmRwbWVf+13WOvZR9Ve57HxLXC+KbSfwDEWXapHmv?=
 =?iso-8859-2?Q?dRIZeKl2vDw61egRKHgG3RSOHYZBZH3wuKQJISvAqKY87urXsewMEeUZKW?=
 =?iso-8859-2?Q?1koZpiTNSVLMJP0B7/7dd6OLqOUoeplaPzMmm7iquaPSdW5gFt9ACn0494?=
 =?iso-8859-2?Q?ZMQL+bSoh5zqGpTkHz4xuCZ7LBHXRlyYx9NJ7wQBAl7pr2dl5THJO00xvd?=
 =?iso-8859-2?Q?t7dvtYGfpHOj//NeuAtlTEt48GHK7AUrf89F6n5VsWY/DV87XOfhmDuSfv?=
 =?iso-8859-2?Q?3wmJbXjAvlVTLuQp+Ll0Q/5Ulo3JdaEfEG168rMWEiQKRxuXzDI/610Uaa?=
 =?iso-8859-2?Q?EmgJjfm0RJsSYrxOQ4/pQj2oKjeXfxTE421TtAgO2GlWPNYmF/I6AGt5Sp?=
 =?iso-8859-2?Q?tXSv5UoE2fWEQNrrddKMsb7EoVagX4Nvv9sFQ6fJyQ80p7X1IRcPn9bfdr?=
 =?iso-8859-2?Q?qQDflVmkK3aAKKMV6U3txuaC8pr/1pQqA6UMi/5HHWDIM+nk6nvxzixQ3K?=
 =?iso-8859-2?Q?Q4umaDDDB7cPVHBSSxlzhUlyBWwOC9VIfCexexvJABY0L42MTiesncHFA4?=
 =?iso-8859-2?Q?DgMsDXUNIz2MIuIMk8x7EJWgRjONRoUQ+r6UjFrNdCjPRILKsyuNDqwSNh?=
 =?iso-8859-2?Q?l/6eHvO4atB/7vTkNZJVumW2oQEltEw+sNOP27jVxmLzcPMYANs/yfsqEw?=
 =?iso-8859-2?Q?tWEXUFXGpwUtvuonz8JHmTbxTfW2xkTiG+/DMInCLu9+SlK0+bqERXPGep?=
 =?iso-8859-2?Q?0IhHf7lsYyBhkd9D0+szRyVLpP7GatE8/4nNY80JCVnu+4MeeC1ItkuS/1?=
 =?iso-8859-2?Q?W5qXfos1cEGq8SNh36PIMmGjDS7aG33fwXlcZYf4HbU+EECtEH7gRsxmUO?=
 =?iso-8859-2?Q?2EO3plQYRNn5S3kPko+q93Tcul0GowFqeqz4aMX7jr8wmE1HiU6hTttee5?=
 =?iso-8859-2?Q?msRykmlSOeu7QETg/kLgafutoslsP7rXHSrn0DHSTbh32H1WxXgTPXxtki?=
 =?iso-8859-2?Q?p6rwVGOFhQ2UKeLEt7tm1k8oquNfw78MrRkUDnAw7K62SHz2BWdSTvS0sz?=
 =?iso-8859-2?Q?cu7ttN8aZXrRdw9BVXWz66qYHSs78mZEgYWCJv2xbhvJKheWBqGsgowE2K?=
 =?iso-8859-2?Q?bR06M7coRpuPljaWm9J3N+6M8VbR4YyiO1qMLSBbcLFBnHsNeXDQj+ev3k?=
 =?iso-8859-2?Q?A0wlA9Lo=3D?=
x-microsoft-antispam-prvs: <LNXP123MB210654054433DE97530B9475E74D0@LNXP123MB2106.GBRP123.PROD.OUTLOOK.COM>
x-forefront-prvs: 0970508454
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(136003)(346002)(396003)(366004)(39850400004)(51234002)(189003)(199004)(8676002)(305945005)(97736004)(105586002)(486006)(99286004)(81166006)(3846002)(14454004)(81156014)(6116002)(476003)(106356001)(102836004)(6506007)(66066001)(186003)(6512007)(36756003)(26005)(110136005)(54906003)(6486002)(5660300002)(52116002)(446003)(2616005)(11346002)(386003)(2906002)(53936002)(107886003)(76176011)(71190400001)(71200400001)(86362001)(2201001)(50226002)(6436002)(316002)(4326008)(68736007)(14444005)(5024004)(256004)(25786009)(7736002)(2501003)(8936002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:LNXP123MB2106;H:LNXP123MB2185.GBRP123.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: camlintechnologies.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zmUFUe3iOUiGlL7id1c0pbeob+QtCl0SyVU9CiRUZoovc5cV+b0jRYeZ17BERhZwgIsGcJEDksuH9B8h4a8FsOboXZXDZYpIEgNyusEWRi06YE6XHY+9Dijeyv+hEvCpUAjHClfQe+pPpRZMcmbKYRMlnYIPulFuWaJtAmJ+bSBBAwBUL42nnLpunDsJv8oRYKbS2aV2pyhc+Tz3xdmbD1Edn8KHb7MPjXCPwxplxCIEJLTMib6zjhT7mfWgLZUH6uBPnIDfy2aJCI6TFUWhmJOU+ohjfju9cBb3Xmg3Ga9NC45f5UdRcf/jZrRGXvWWCah8MFiLMOO2XD7q21jyhZe1mRK9iQnF8Ye+NMl/ZrG0wx0zcmkdGobl1BSkx+82wizYpiwKkEuSeALVHErDkfoO8S5iMvi1u/t9u3mbPKM=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: camlintechnologies.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5285d48-46ec-42e1-3586-08d6a3da3d10
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2019 15:25:04.5106
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fd4b1729-b18d-46d2-9ba0-2717b852b252
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LNXP123MB2106
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

It was observed that rarely during USB disconnect happening shortly after
connect (before full initialization completes) usb_hub_wq would wait
forever for the dev_init_lock to be unlocked. dev_init_lock would remain
locked though because of infinite wait during usb_kill_urb:

[ 2730.656472] kworker/0:2     D    0   260      2 0x00000000
[ 2730.660700] Workqueue: events request_firmware_work_func
[ 2730.664807] [<809dca20>] (__schedule) from [<809dd164>] (schedule+0x4c/0=
xac)
[ 2730.670587] [<809dd164>] (schedule) from [<8069af44>] (usb_kill_urb+0xdc=
/0x114)
[ 2730.676815] [<8069af44>] (usb_kill_urb) from [<7f258b50>] (brcmf_usb_fre=
e_q+0x34/0xa8 [brcmfmac])
[ 2730.684833] [<7f258b50>] (brcmf_usb_free_q [brcmfmac]) from [<7f2517d4>]=
 (brcmf_detach+0xa0/0xb8 [brcmfmac])
[ 2730.693557] [<7f2517d4>] (brcmf_detach [brcmfmac]) from [<7f251a34>] (br=
cmf_attach+0xac/0x3d8 [brcmfmac])
[ 2730.702094] [<7f251a34>] (brcmf_attach [brcmfmac]) from [<7f2587ac>] (br=
cmf_usb_probe_phase2+0x468/0x4a0 [brcmfmac])
[ 2730.711601] [<7f2587ac>] (brcmf_usb_probe_phase2 [brcmfmac]) from [<7f25=
2888>] (brcmf_fw_request_done+0x194/0x220 [brcmfmac])
[ 2730.721795] [<7f252888>] (brcmf_fw_request_done [brcmfmac]) from [<80574=
8e4>] (request_firmware_work_func+0x4c/0x88)
[ 2730.731125] [<805748e4>] (request_firmware_work_func) from [<80141474>] =
(process_one_work+0x228/0x808)
[ 2730.739223] [<80141474>] (process_one_work) from [<80141a80>] (worker_th=
read+0x2c/0x564)
[ 2730.746105] [<80141a80>] (worker_thread) from [<80147bcc>] (kthread+0x13=
c/0x16c)
[ 2730.752227] [<80147bcc>] (kthread) from [<801010b4>] (ret_from_fork+0x14=
/0x20)

[ 2733.099695] kworker/0:3     D    0  1065      2 0x00000000
[ 2733.103926] Workqueue: usb_hub_wq hub_event
[ 2733.106914] [<809dca20>] (__schedule) from [<809dd164>] (schedule+0x4c/0=
xac)
[ 2733.112693] [<809dd164>] (schedule) from [<809e2a8c>] (schedule_timeout+=
0x214/0x3e4)
[ 2733.119621] [<809e2a8c>] (schedule_timeout) from [<809dde2c>] (wait_for_=
common+0xc4/0x1c0)
[ 2733.126810] [<809dde2c>] (wait_for_common) from [<7f258d00>] (brcmf_usb_=
disconnect+0x1c/0x4c [brcmfmac])
[ 2733.135206] [<7f258d00>] (brcmf_usb_disconnect [brcmfmac]) from [<8069e0=
c8>] (usb_unbind_interface+0x5c/0x1e4)
[ 2733.143943] [<8069e0c8>] (usb_unbind_interface) from [<8056d3e8>] (devic=
e_release_driver_internal+0x164/0x1fc)
[ 2733.152769] [<8056d3e8>] (device_release_driver_internal) from [<8056c07=
8>] (bus_remove_device+0xd0/0xfc)
[ 2733.161138] [<8056c078>] (bus_remove_device) from [<8056977c>] (device_d=
el+0x11c/0x310)
[ 2733.167939] [<8056977c>] (device_del) from [<8069cba8>] (usb_disable_dev=
ice+0xa0/0x1cc)
[ 2733.174743] [<8069cba8>] (usb_disable_device) from [<8069507c>] (usb_dis=
connect+0x74/0x1dc)
[ 2733.181823] [<8069507c>] (usb_disconnect) from [<80695e88>] (hub_event+0=
x478/0xf88)
[ 2733.188278] [<80695e88>] (hub_event) from [<80141474>] (process_one_work=
+0x228/0x808)
[ 2733.194905] [<80141474>] (process_one_work) from [<80141a80>] (worker_th=
read+0x2c/0x564)
[ 2733.201724] [<80141a80>] (worker_thread) from [<80147bcc>] (kthread+0x13=
c/0x16c)
[ 2733.207913] [<80147bcc>] (kthread) from [<801010b4>] (ret_from_fork+0x14=
/0x20)

It was traced down to a case where usb_kill_urb would be called on an URB
structure containing more or less random data, including large number in
its use_count. During the debugging it appeared that in brcmf_usb_free_q()
the traversal over URBs' lists is not synchronized with operations on those
lists in brcmf_usb_rx_complete() leading to handling
brcmf_usbdev_info structure (holding lists' head) as lists' element and in
result causing above problem.

Fix it by walking through all URBs during brcmf_cancel_all_urbs using the
arrays of requests instead of linked lists.

Signed-off-by: Piotr Figiel <p.figiel@camlintechnologies.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drive=
rs/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index e9cbfd0..a775409 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -682,12 +682,18 @@ static int brcmf_usb_up(struct device *dev)
=20
 static void brcmf_cancel_all_urbs(struct brcmf_usbdev_info *devinfo)
 {
+	int i;
+
 	if (devinfo->ctl_urb)
 		usb_kill_urb(devinfo->ctl_urb);
 	if (devinfo->bulk_urb)
 		usb_kill_urb(devinfo->bulk_urb);
-	brcmf_usb_free_q(&devinfo->tx_postq, true);
-	brcmf_usb_free_q(&devinfo->rx_postq, true);
+	if (devinfo->tx_reqs)
+		for (i =3D 0; i < devinfo->bus_pub.ntxq; i++)
+			usb_kill_urb(devinfo->tx_reqs[i].urb);
+	if (devinfo->rx_reqs)
+		for (i =3D 0; i < devinfo->bus_pub.nrxq; i++)
+			usb_kill_urb(devinfo->rx_reqs[i].urb);
 }
=20
 static void brcmf_usb_down(struct device *dev)
--=20
2.7.4

