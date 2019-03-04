Return-Path: <SRS0=K+dv=RH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BCD5C43381
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 14:55:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC83720815
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 14:55:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=camlinlimited.onmicrosoft.com header.i=@camlinlimited.onmicrosoft.com header.b="h/HeHKQF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbfCDOzp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Mar 2019 09:55:45 -0500
Received: from mail-eopbgr110047.outbound.protection.outlook.com ([40.107.11.47]:4568
        "EHLO GBR01-CWL-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726165AbfCDOzp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Mar 2019 09:55:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=camlinlimited.onmicrosoft.com; s=selector1-camlintechnologies-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Mo4UznkMGANfVl56wUGu7dDYxOw8br5h9PHUPksYZg=;
 b=h/HeHKQFJtzCgkM3lkuOaQmcD8mW/C2ZAK7BskVSfsjgQH/j/Y8+82sAUEk6MVrxXAg7iYgFeODLi9DRyfiI43bIw0aa08qpD33xIGAAhwm9hsirM7ZFeoTtSUi+eVdrdz75wpLo6TkvwAtNfXOpPp70aRrwUJYIr4IGmS7fX4o=
Received: from LNXP123MB2185.GBRP123.PROD.OUTLOOK.COM (20.179.129.83) by
 LNXP123MB2025.GBRP123.PROD.OUTLOOK.COM (20.179.128.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1665.18; Mon, 4 Mar 2019 14:55:41 +0000
Received: from LNXP123MB2185.GBRP123.PROD.OUTLOOK.COM
 ([fe80::396a:e27e:d5dd:6bf0]) by LNXP123MB2185.GBRP123.PROD.OUTLOOK.COM
 ([fe80::396a:e27e:d5dd:6bf0%4]) with mapi id 15.20.1665.019; Mon, 4 Mar 2019
 14:55:41 +0000
From:   Piotr Figiel <p.figiel@camlintechnologies.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>,
        "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
        "chi-hsien.lin@cypress.com" <chi-hsien.lin@cypress.com>,
        "wright.feng@cypress.com" <wright.feng@cypress.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "brcm80211-dev-list@cypress.com" <brcm80211-dev-list@cypress.com>
Subject: leaking mutex and a deadlock in brcmfmac
Thread-Topic: leaking mutex and a deadlock in brcmfmac
Thread-Index: AQHU0ppVw9vzyc8LlUmOva0pRgYIHw==
Date:   Mon, 4 Mar 2019 14:55:40 +0000
Message-ID: <20190304145537.GB23059@phoenix>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [95.143.242.242]
x-clientproxiedby: VI1PR07CA0250.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::17) To LNXP123MB2185.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:dc::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=p.figiel@camlintechnologies.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d6add28b-d527-4acc-9b1d-08d6a0b177df
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:LNXP123MB2025;
x-ms-traffictypediagnostic: LNXP123MB2025:
x-microsoft-exchange-diagnostics: =?us-ascii?Q?1;LNXP123MB2025;23:pcpEaJf208L3oocR16nLxjtGD7aJXNFiDI/qLv+gM?=
 =?us-ascii?Q?aH4mizdU4wwY30NNr3mgMFkncIM5l5+4HvQWhDvQiMAlrtLhFuvECd86hsrG?=
 =?us-ascii?Q?CblYuOcU+MclYxYxNn7KbGCvrI5d5CzYzAvvxJRA/jAJi3tY1euCR/nffPVf?=
 =?us-ascii?Q?/5Vo8o+7mpFsfeR8jia4idqTy/hiebq8j+h88q8arDw0GvbJpyrucbxLMwWN?=
 =?us-ascii?Q?YXw1MMYsfQuCE7tHikMBwHd93kOgslQxtHXM4+mOocmX3eogabCSyMkFMXTp?=
 =?us-ascii?Q?mjuMYBcULM8fbt1ZZs5bN+bh2zr8PlE7tDq+L4+K+1uNuZjsujOreMLVgs8k?=
 =?us-ascii?Q?lTGjQ7OKbg/C0iRLr2rxu3ztCs+oGjREbznAud/BCKAz1A1kFxjqeBaA3qY9?=
 =?us-ascii?Q?PnUl1ROJ+sA1z5iTTnZaRcKOq5RCmVFbX+PNCr6+TdIlw+7Xn5MHD5kU+C/m?=
 =?us-ascii?Q?yzmNPQc0Z7xK6u3g2Xv102ffAoFlwAFlZRjWL3QpfBsHVheDYC3OsTFPkcwu?=
 =?us-ascii?Q?GXrRil3Ugpcgrds+ZIZFu5nFbn2by53hYJKRdAiHy0JWHyPseCSNzNALf5rj?=
 =?us-ascii?Q?zWmfwUTendsOZMxHbbgl5NYNuSbEgI4lxAVzIRcqpQ2hlLQTaONDwhzupzkE?=
 =?us-ascii?Q?TtULDX54dX4sQCNjc6NhmaCZ5Yc9xtoLlNdQwE1sPq+AHouoJVp2KLVSfxgS?=
 =?us-ascii?Q?I2t29ZJdJ/40VXZC2JeLuixEVZilBpc4m34L3QTN0k4YZJCw9X5zmBthw7jb?=
 =?us-ascii?Q?varVmYir1oK4fkwtdASAdNlvfv6fYeet+UJ/aUcS581Hy0+gHc/BwM8GlYJa?=
 =?us-ascii?Q?vr1GrE9rqSSkbKstp1DQUh7Xc0H0zLfrCubWPq/XnS1mt3WMd+QGGnpRbISy?=
 =?us-ascii?Q?Sp3I5i5cgc8vmYuH+bQrgG2lcIx1rMsR3NhMOsTZLgCB+sYu0rfziZ6nVWLV?=
 =?us-ascii?Q?CLd/mBU/NOctF/C0Vnce0oYFTirHnofkoXvQWZ4FockFWgMJ1KLneOhNLKFP?=
 =?us-ascii?Q?I0I/hTiO+ZRciBtBF6Mc+k/lJKoUZnJIa/gnb+pgKqHFN81v3TH5g0NIrSRZ?=
 =?us-ascii?Q?u6RmBnOfWAMC0iHuBMr+EyRVAybwoTv7rnTrn1lW4Otrx6FqNFyk17d03pzC?=
 =?us-ascii?Q?D7TvpLgUYb1VpWK1F49fW7E+yb8IXHnMgSKwgttJufIFAS/ojEL/CW9UwE1j?=
 =?us-ascii?Q?Vb1eNg5ajcjLFvkb6mlY+AkCLo12IbW6nWYsBzwfFIL+bSho97U/4hLtWMaj?=
 =?us-ascii?Q?A936JrQ5OYhMC9qI3I/LXPulKZsjjhS9d0DZCpvZLduxlfsJ9z0Pb/+G3JO0?=
 =?us-ascii?Q?iiJcCieXfLMJXpQzNDM+9w=3D?=
x-microsoft-antispam-prvs: <LNXP123MB2025E6C95A6EC64F40F7DA01E7710@LNXP123MB2025.GBRP123.PROD.OUTLOOK.COM>
x-forefront-prvs: 09669DB681
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(39850400004)(136003)(366004)(396003)(376002)(346002)(51234002)(189003)(199004)(53936002)(71190400001)(2501003)(81156014)(5640700003)(6916009)(33716001)(6436002)(6486002)(66066001)(186003)(9686003)(6512007)(476003)(81166006)(8676002)(14454004)(71200400001)(305945005)(7736002)(486006)(1076003)(5660300002)(2906002)(478600001)(106356001)(86362001)(256004)(105586002)(99286004)(2351001)(26005)(4326008)(6116002)(8936002)(54906003)(3846002)(25786009)(52116002)(68736007)(5024004)(14444005)(33656002)(316002)(97736004)(386003)(6506007)(102836004)(156123004);DIR:OUT;SFP:1101;SCL:1;SRVR:LNXP123MB2025;H:LNXP123MB2185.GBRP123.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: camlintechnologies.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: up6UZ/i+VoKJUWuYC6oV3C4MzH0pAybe6rm/xWTmySGwemCPOqm+oXnaYOu5/7JCeqBDkiMLtGz9fapowH/1QSUAYQxezgXTkBZNpNFUe9p5HBzgnWb8ziq8+hx/wGil3atzCbd294oJl/QgIIWiX0FuLSb5RXeKwZ8Gk9abBPSnAN2kECQF2q0eE+tKj4xDN+BSGYB/QZnRnf272iX4+PHC9xFY7GyDjA+GBFU4ZtFQyQp+Kz7zDBSYiLF1eZHXaKVIq8ijVrWgWR2um3iORCwXrwKv9NSOzpznj5xJ0tH2MVmq7eA1HlQc46J/OW8RPQ81aQitb3mKOKmeLwdjcYPOe8lBA1osuu7je1gycrtAsaRIy4bmKZgVi4MCf8XyPzdzNKfckQv3cX0I+ZODYZci04a9yuYi/Ge8Ld3RIcg=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6BE6FD4212D3374EA2B224872EC394C0@GBRP123.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: camlintechnologies.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6add28b-d527-4acc-9b1d-08d6a0b177df
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2019 14:55:41.0739
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fd4b1729-b18d-46d2-9ba0-2717b852b252
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LNXP123MB2025
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,
I noticed the kernel reports a leaking mutex BUG and a deadlock in brcmfmac
driver.
The issue is observable when the Raspberry Pi WiFi USB dongle is plugged in
and the kernel has following options enabled (step 12 from the
submit-checklist.rst): CONFIG_PREEMPT, CONFIG_DEBUG_PREEMPT,
CONFIG_DEBUG_SLAB, CONFIG_DEBUG_PAGEALLOC, CONFIG_DEBUG_MUTEXES,
CONFIG_DEBUG_SPINLOCK, CONFIG_DEBUG_ATOMIC_SLEEP, CONFIG_PROVE_RCU and
CONFIG_DEBUG_OBJECTS_RCU_HEAD.

I'm pretty sure the deadlock can manifest itself in practice as I observed
once an issue that if the dongle is disconnected shortly after connection
the USB stack stopped responding to connect/disconnect events. I wasn't abl=
e
to reproduce it but I gathered the stack traces via sysrq and noticed the
usb workqueue was waiting in disconnect on that leaked mutex
(dev_init_lock).

Is this maybe a known problem or could you provide some hints how to tackle
it?  The critical section protected by the leaking mutex seems pretty huge
and I couldn't find any straightforward approach to fix this.

Here are the logs when reprodicing this on recent wireless-drivers-next
master:

usb 1-1.3.1.1: new high-speed USB device number 9 using ci_hdrc
brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac43143 for chip BCM4314=
3/2
usbcore: registered new interface driver brcmfmac
BUG: workqueue leaked lock or atomic: kworker/1:1/0x00000000/135
     last function: brcmf_driver_register [brcmfmac]
1 lock held by kworker/1:1/135:
 #0: 68d3f0a3 (&devinfo->dev_init_lock){+.+.}, at: brcmf_usb_probe+0x78/0x5=
70 [brcmfmac]
CPU: 1 PID: 135 Comm: kworker/1:1 Not tainted 5.0.0-rc7-00073-g837ea0d #112
Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
Workqueue: events brcmf_driver_register [brcmfmac]
[<80111c1c>] (unwind_backtrace) from [<8010d0e8>] (show_stack+0x10/0x14)
[<8010d0e8>] (show_stack) from [<809e64ac>] (dump_stack+0xa8/0xd4)
[<809e64ac>] (dump_stack) from [<801417d8>] (process_one_work+0x718/0x810)
[<801417d8>] (process_one_work) from [<801418fc>] (worker_thread+0x2c/0x564=
)
[<801418fc>] (worker_thread) from [<80147a80>] (kthread+0x13c/0x16c)
[<80147a80>] (kthread) from [<801010b4>] (ret_from_fork+0x14/0x20)
Exception stack(0xede63fb0 to 0xede63ff8)
3fa0:                                     00000000 00000000 00000000 000000=
00
3fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000=
00
3fe0: 00000000 00000000 00000000 00000000 00000013 00000000

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
WARNING: possible circular locking dependency detected
5.0.0-rc7-00073-g837ea0d #112 Not tainted
------------------------------------------------------
kworker/1:1/135 is trying to acquire lock:
38feea71 ((wq_completion)"events"){+.+.}, at: process_one_work+0x174/0x810

but task is already holding lock:
68d3f0a3 (&devinfo->dev_init_lock){+.+.}, at: brcmf_usb_probe+0x78/0x570 [b=
rcmfmac]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&devinfo->dev_init_lock){+.+.}:
       mutex_lock_nested+0x1c/0x24
       brcmf_usb_probe+0x78/0x570 [brcmfmac]
       usb_probe_interface+0xc0/0x1bc
       really_probe+0x214/0x2dc
       __driver_attach+0xe4/0xe8
       bus_for_each_dev+0x68/0xb4
       bus_add_driver+0x19c/0x214
       driver_register+0x78/0x110
       usb_register_driver+0x84/0x148
       brcmf_usb_register+0x20/0x54 [brcmfmac]
       process_one_work+0x228/0x810
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
       process_one_work+0x1b8/0x810
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

1 lock held by kworker/1:1/135:
 #0: 68d3f0a3 (&devinfo->dev_init_lock){+.+.}, at: brcmf_usb_probe+0x78/0x5=
70 [brcmfmac]

stack backtrace:
CPU: 1 PID: 135 Comm: kworker/1:1 Not tainted 5.0.0-rc7-00073-g837ea0d #112
Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
Workqueue: events request_firmware_work_func
[<80111c1c>] (unwind_backtrace) from [<8010d0e8>] (show_stack+0x10/0x14)
[<8010d0e8>] (show_stack) from [<809e64ac>] (dump_stack+0xa8/0xd4)
[<809e64ac>] (dump_stack) from [<8017352c>] (print_circular_bug+0x210/0x330=
)
[<8017352c>] (print_circular_bug) from [<801762cc>] (__lock_acquire+0x12b0/=
0x1a04)
[<801762cc>] (__lock_acquire) from [<80177448>] (lock_acquire+0xe0/0x268)
[<80177448>] (lock_acquire) from [<80141278>] (process_one_work+0x1b8/0x810=
)
[<80141278>] (process_one_work) from [<801418fc>] (worker_thread+0x2c/0x564=
)
[<801418fc>] (worker_thread) from [<80147a80>] (kthread+0x13c/0x16c)
[<80147a80>] (kthread) from [<801010b4>] (ret_from_fork+0x14/0x20)
Exception stack(0xede63fb0 to 0xede63ff8)
3fa0:                                     00000000 00000000 00000000 000000=
00
3fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000=
00
3fe0: 00000000 00000000 00000000 00000000 00000013 00000000
brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac43143 for chip BCM4314=
3/2
brcmfmac: brcmf_c_process_clm_blob: no clm_blob available (err=3D-2), devic=
e may have limited channels available
brcmfmac: brcmf_c_preinit_dcmds: Firmware: BCM43143/2 wl0: Apr  3 2014 04:4=
3:32 version 6.10.198.66 (r467479) FWID 01-32bd010e
ieee80211 phy0: brcmf_inetaddr_changed: fail to get arp ip table err:-52
IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready

Best regards,
Piotr Figiel
PS. when replying please keep in To:/CC: as I'm not subscribed to the list.
