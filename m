Return-Path: <SRS0=EMXR=RQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35298C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 09:52:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFE022183F
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 09:52:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=camlinlimited.onmicrosoft.com header.i=@camlinlimited.onmicrosoft.com header.b="poLzx6kR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbfCMJwr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Mar 2019 05:52:47 -0400
Received: from mail-eopbgr110048.outbound.protection.outlook.com ([40.107.11.48]:63168
        "EHLO GBR01-CWL-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726751AbfCMJwr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Mar 2019 05:52:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=camlinlimited.onmicrosoft.com; s=selector1-camlintechnologies-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UVjkiwFOtKXyhnQRI7hSM1OQRZntVxOj4HWthi47CqE=;
 b=poLzx6kRowapo6kyWk3ahGUTeoJL6HBfOY3ysSAwYxNE1nQgdTCRgPzideW81+uM5LlChvIJM/7CnRenvEOdS8+hmCTWVhM49HdUBjyGIOga7AP4Wk82YnVVhZ2FoWz5aNTqqYJ/GnPyq2Q5skzhi0MMW2wesW+YECvez2zC/lI=
Received: from LNXP123MB1963.GBRP123.PROD.OUTLOOK.COM (20.179.128.81) by
 LNXP123MB2298.GBRP123.PROD.OUTLOOK.COM (20.179.129.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.13; Wed, 13 Mar 2019 09:52:42 +0000
Received: from LNXP123MB1963.GBRP123.PROD.OUTLOOK.COM
 ([fe80::9cd1:578e:30c0:f5d9]) by LNXP123MB1963.GBRP123.PROD.OUTLOOK.COM
 ([fe80::9cd1:578e:30c0:f5d9%2]) with mapi id 15.20.1709.011; Wed, 13 Mar 2019
 09:52:42 +0000
From:   Piotr Figiel <p.figiel@camlintechnologies.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC:     "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
        "chi-hsien.lin@cypress.com" <chi-hsien.lin@cypress.com>,
        "wright.feng@cypress.com" <wright.feng@cypress.com>,
        "brcm80211-dev-list@cypress.com" <brcm80211-dev-list@cypress.com>,
        =?iso-8859-2?Q?Krzysztof_Drobi=F1ski?= 
        <k.drobinski@camlintechnologies.com>,
        Pawel Lenkow <p.lenkow@camlintechnologies.com>,
        Lech Perczak <l.perczak@camlintechnologies.com>,
        Piotr Figiel <p.figiel@camlintechnologies.com>
Subject: [PATCH] brcmfmac: convert dev_init_lock mutex to completion
Thread-Topic: [PATCH] brcmfmac: convert dev_init_lock mutex to completion
Thread-Index: AQHU2YKAMk2g+MVwck2AyPV44asFWg==
Date:   Wed, 13 Mar 2019 09:52:42 +0000
Message-ID: <1552470749-3625-1-git-send-email-p.figiel@camlintechnologies.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [95.143.242.242]
x-clientproxiedby: DB6PR06CA0005.eurprd06.prod.outlook.com (2603:10a6:6:1::18)
 To LNXP123MB1963.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:d8::17)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=p.figiel@camlintechnologies.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 439d99ab-cf96-43dd-628f-08d6a799a293
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:LNXP123MB2298;
x-ms-traffictypediagnostic: LNXP123MB2298:
x-microsoft-antispam-prvs: <LNXP123MB229891A4862C84FE60C97293E74A0@LNXP123MB2298.GBRP123.PROD.OUTLOOK.COM>
x-forefront-prvs: 09752BC779
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(346002)(366004)(376002)(136003)(199004)(189003)(51234002)(71190400001)(71200400001)(4326008)(256004)(14444005)(5024004)(25786009)(2501003)(36756003)(66066001)(2616005)(476003)(86362001)(486006)(2201001)(14454004)(81166006)(81156014)(8676002)(97736004)(107886003)(478600001)(26005)(54906003)(110136005)(52116002)(6512007)(316002)(2906002)(186003)(99286004)(53936002)(305945005)(50226002)(7736002)(5660300002)(106356001)(105586002)(102836004)(3846002)(386003)(6506007)(6486002)(68736007)(8936002)(6116002)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:LNXP123MB2298;H:LNXP123MB1963.GBRP123.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: camlintechnologies.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zyka6wEGzefDSccxZ9eDPcAn7BWGKqrCubICwh7DD4HHEGcBK9mdRdMuJS4lhMSBaQ2MuILn32jsmhLuST/exOC9ROj0aTzK+p05SCK7LG3hfNgV1zyk1cBLg00etlpfk5WVblEolVAq8ZcCyEA2FRjhPIzxYsqeP3ltXRIJ8pG/rVcs65uJDPH7LiRIIcUhniMtu8nxHA5zMmbeb8XxsjfJuBFCbUGL7328tXxqFLflrHFp1GyrbtrUbd44aH8FI0+Z4gDMydInJXmlkhbpaDdzPlCfjtl7j5MVWzbBRoZrVEYIMP9wbtUOvsP6kGp4F9gUWd331Y3tPWpKWkk0hAS47cxUeeB5ktF6Pmh/QfwvHMIa7pkjePFX7Z4T52MUKkVgbstX0VtuKj+xwnCeB4Zh/e082kwZ+UyHG5ZMak0=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: camlintechnologies.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 439d99ab-cf96-43dd-628f-08d6a799a293
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2019 09:52:42.1418
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fd4b1729-b18d-46d2-9ba0-2717b852b252
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LNXP123MB2298
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Leaving dev_init_lock mutex locked in probe causes BUG and a WARNING when
kernel is compiled with CONFIG_PROVE_LOCKING. Convert mutex to completion
which silences those warnings and improves code readability.

Fix below errors when connecting the USB WiFi dongle:

brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac43143 for chip BCM4314=
3/2
BUG: workqueue leaked lock or atomic: kworker/0:2/0x00000000/434
     last function: hub_event
1 lock held by kworker/0:2/434:
 #0: 18d5dcdf (&devinfo->dev_init_lock){+.+.}, at: brcmf_usb_probe+0x78/0x5=
50 [brcmfmac]
CPU: 0 PID: 434 Comm: kworker/0:2 Not tainted 4.19.23-00084-g454a789-dirty =
#123
Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
Workqueue: usb_hub_wq hub_event
[<8011237c>] (unwind_backtrace) from [<8010d74c>] (show_stack+0x10/0x14)
[<8010d74c>] (show_stack) from [<809c4324>] (dump_stack+0xa8/0xd4)
[<809c4324>] (dump_stack) from [<8014195c>] (process_one_work+0x710/0x808)
[<8014195c>] (process_one_work) from [<80141a80>] (worker_thread+0x2c/0x564=
)
[<80141a80>] (worker_thread) from [<80147bcc>] (kthread+0x13c/0x16c)
[<80147bcc>] (kthread) from [<801010b4>] (ret_from_fork+0x14/0x20)
Exception stack(0xed1d9fb0 to 0xed1d9ff8)
9fa0:                                     00000000 00000000 00000000 000000=
00
9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000=
00
9fe0: 00000000 00000000 00000000 00000000 00000013 00000000

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
WARNING: possible circular locking dependency detected
4.19.23-00084-g454a789-dirty #123 Not tainted
------------------------------------------------------
kworker/0:2/434 is trying to acquire lock:
e29cf799 ((wq_completion)"events"){+.+.}, at: process_one_work+0x174/0x808

but task is already holding lock:
18d5dcdf (&devinfo->dev_init_lock){+.+.}, at: brcmf_usb_probe+0x78/0x550 [b=
rcmfmac]

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #2 (&devinfo->dev_init_lock){+.+.}:
       mutex_lock_nested+0x1c/0x24
       brcmf_usb_probe+0x78/0x550 [brcmfmac]
       usb_probe_interface+0xc0/0x1bc
       really_probe+0x228/0x2c0
       __driver_attach+0xe4/0xe8
       bus_for_each_dev+0x68/0xb4
       bus_add_driver+0x19c/0x214
       driver_register+0x78/0x110
       usb_register_driver+0x84/0x148
       process_one_work+0x228/0x808
       worker_thread+0x2c/0x564
       kthread+0x13c/0x16c
       ret_from_fork+0x14/0x20
         (null)

-> #1 (brcmf_driver_work){+.+.}:
       worker_thread+0x2c/0x564
       kthread+0x13c/0x16c
       ret_from_fork+0x14/0x20
         (null)

-> #0 ((wq_completion)"events"){+.+.}:
       process_one_work+0x1b8/0x808
       worker_thread+0x2c/0x564
       kthread+0x13c/0x16c
       ret_from_fork+0x14/0x20
         (null)

other info that might help us debug this:

Chain exists of:
  (wq_completion)"events" --> brcmf_driver_work --> &devinfo->dev_init_lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&devinfo->dev_init_lock);
                               lock(brcmf_driver_work);
                               lock(&devinfo->dev_init_lock);
  lock((wq_completion)"events");

 *** DEADLOCK ***

1 lock held by kworker/0:2/434:
 #0: 18d5dcdf (&devinfo->dev_init_lock){+.+.}, at: brcmf_usb_probe+0x78/0x5=
50 [brcmfmac]

stack backtrace:
CPU: 0 PID: 434 Comm: kworker/0:2 Not tainted 4.19.23-00084-g454a789-dirty =
#123
Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
Workqueue: events request_firmware_work_func
[<8011237c>] (unwind_backtrace) from [<8010d74c>] (show_stack+0x10/0x14)
[<8010d74c>] (show_stack) from [<809c4324>] (dump_stack+0xa8/0xd4)
[<809c4324>] (dump_stack) from [<80172838>] (print_circular_bug+0x210/0x330=
)
[<80172838>] (print_circular_bug) from [<80175940>] (__lock_acquire+0x160c/=
0x1a30)
[<80175940>] (__lock_acquire) from [<8017671c>] (lock_acquire+0xe0/0x268)
[<8017671c>] (lock_acquire) from [<80141404>] (process_one_work+0x1b8/0x808=
)
[<80141404>] (process_one_work) from [<80141a80>] (worker_thread+0x2c/0x564=
)
[<80141a80>] (worker_thread) from [<80147bcc>] (kthread+0x13c/0x16c)
[<80147bcc>] (kthread) from [<801010b4>] (ret_from_fork+0x14/0x20)
Exception stack(0xed1d9fb0 to 0xed1d9ff8)
9fa0:                                     00000000 00000000 00000000 000000=
00
9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000=
00
9fe0: 00000000 00000000 00000000 00000000 00000013 00000000

Signed-off-by: Piotr Figiel <p.figiel@camlintechnologies.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c | 17 ++++++++------=
---
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drive=
rs/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index e9cbfd0..a513990 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -160,7 +160,7 @@ struct brcmf_usbdev_info {
=20
 	struct usb_device *usbdev;
 	struct device *dev;
-	struct mutex dev_init_lock;
+	struct completion dev_init_done;
=20
 	int ctl_in_pipe, ctl_out_pipe;
 	struct urb *ctl_urb; /* URB for control endpoint */
@@ -1193,11 +1193,11 @@ static void brcmf_usb_probe_phase2(struct device *d=
ev, int ret,
 	if (ret)
 		goto error;
=20
-	mutex_unlock(&devinfo->dev_init_lock);
+	complete(&devinfo->dev_init_done);
 	return;
 error:
 	brcmf_dbg(TRACE, "failed: dev=3D%s, err=3D%d\n", dev_name(dev), ret);
-	mutex_unlock(&devinfo->dev_init_lock);
+	complete(&devinfo->dev_init_done);
 	device_release_driver(dev);
 }
=20
@@ -1265,7 +1265,7 @@ static int brcmf_usb_probe_cb(struct brcmf_usbdev_inf=
o *devinfo)
 		if (ret)
 			goto fail;
 		/* we are done */
-		mutex_unlock(&devinfo->dev_init_lock);
+		complete(&devinfo->dev_init_done);
 		return 0;
 	}
 	bus->chip =3D bus_pub->devid;
@@ -1325,11 +1325,10 @@ brcmf_usb_probe(struct usb_interface *intf, const s=
truct usb_device_id *id)
=20
 	devinfo->usbdev =3D usb;
 	devinfo->dev =3D &usb->dev;
-	/* Take an init lock, to protect for disconnect while still loading.
+	/* Init completion, to protect for disconnect while still loading.
 	 * Necessary because of the asynchronous firmware load construction
 	 */
-	mutex_init(&devinfo->dev_init_lock);
-	mutex_lock(&devinfo->dev_init_lock);
+	init_completion(&devinfo->dev_init_done);
=20
 	usb_set_intfdata(intf, devinfo);
=20
@@ -1407,7 +1406,7 @@ brcmf_usb_probe(struct usb_interface *intf, const str=
uct usb_device_id *id)
 	return 0;
=20
 fail:
-	mutex_unlock(&devinfo->dev_init_lock);
+	complete(&devinfo->dev_init_done);
 	kfree(devinfo);
 	usb_set_intfdata(intf, NULL);
 	return ret;
@@ -1422,7 +1421,7 @@ brcmf_usb_disconnect(struct usb_interface *intf)
 	devinfo =3D (struct brcmf_usbdev_info *)usb_get_intfdata(intf);
=20
 	if (devinfo) {
-		mutex_lock(&devinfo->dev_init_lock);
+		wait_for_completion(&devinfo->dev_init_done);
 		/* Make sure that devinfo still exists. Firmware probe routines
 		 * may have released the device and cleared the intfdata.
 		 */
--=20
2.7.4

