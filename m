Return-Path: <SRS0=fcMp=QR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AB65C282C2
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 10:22:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C189020863
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 10:22:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbfBJKWi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 10 Feb 2019 05:22:38 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:51449 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725984AbfBJKWi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Feb 2019 05:22:38 -0500
Received: by mail-it1-f194.google.com with SMTP id y184so13217954itc.1
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2019 02:22:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H4a01L2XG2+wcESXu2GhRQkYe+FVo67b+5IcmDh+2Os=;
        b=QRy42WMa5Rn0eG/5AHQXpl/PkM9V4mQGiyxUOZhjvlQ5FPv04bRcVpW5tID0Jwep+X
         8a8Qv8Y+f4PVx5FQ2AMZoSCtnaVZrS58jITf6dYfxOD9mEtl8eJUNXJJrliYp4mT7/Mk
         0go7QjDvNv1m4kVKJB2GkBXB70nMRDAyBhSX67f3K0iESzejUG2juGklGVN1rBNzoTBq
         daQ/2+QPEr7tM7Wk9lCLFg1Y9u4703FKCB87hfWQWpbB+/dvjg9F912zfuRZsyRqqaJk
         kjzVrL4n4GRGUQPQ5eEz73pPGag0oeX30DTnDILfmx+dTRJ5RD8/KHDozhX9sMpqLbaD
         iTJA==
X-Gm-Message-State: AHQUAuaz1nZY/BuA+w1EJVbFKAUsz2ReFfM4zFACmpA+GZeZoWsjGy6Y
        l/9MCFpvIWsbmXuMKJysJT+dkAFG7PkgGSNQ3+niTw==
X-Google-Smtp-Source: AHgI3IbCy8hptlJMKfO12rtqz175uFo+Ilh47RIJhOiRRhvPjWGqy0/v0tS2GMcBx6V8levi7bacjM0Sph3KuTVDS5s=
X-Received: by 2002:a05:660c:a50:: with SMTP id j16mr3099833itl.52.1549794156866;
 Sun, 10 Feb 2019 02:22:36 -0800 (PST)
MIME-Version: 1.0
References: <2003727085.234456.1549714119945@email.ionos.de>
 <CAJ0CqmXSuNQ_tQOatyKwO9O2KsxqD5NZRQnngOme5PURssiv5Q@mail.gmail.com>
 <165515185.283024.1549744145982@email.ionos.de> <20190210094123.GB2913@redhat.com>
In-Reply-To: <20190210094123.GB2913@redhat.com>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Sun, 10 Feb 2019 11:22:25 +0100
Message-ID: <CAJ0CqmXp2a-zwPMyMFu+UCqTHP7qNRiJFopDSdZWdms7dVef4Q@mail.gmail.com>
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Stefan Wahren <stefan.wahren@i2se.com>,
        Felix Fietkau <nbd@nbd.name>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On Sat, Feb 09, 2019 at 09:29:05PM +0100, Stefan Wahren wrote:
> > > could you please test the following series:
> > > https://patchwork.kernel.org/cover/10764453/
> >
> > yeah this fixed the probing timeout and the driver will probe successful. AFAIK the dwc2 host mode doesn't support scatter-gather yet.
>
> So this is either dwc2 scatter-gather problem which should be addressed in
> this driver or mt76x0u does something wrong when configuring SG.
>
> Disabling SG is just workaround, which do not address actual problem.
>
> I think I found mt76x0u issue that could cause this USB probe error
> (and possibly also address AMD IOMMU issue). We seems do not correctly
> set URB transfer length smaller than sg buffer length. Attached  patch
> should correct that.

Hi Stanislaw,

I think 'sg[0].length' is already set in mt76u_fill_rx_sg().
Moreover applying this patch I got the following crash (rpi-5.0.y):

[   38.856623] mt76x0u 1-1.2:1.0: ASIC revision: 76100002 MAC
revision: 76502000
[   38.865999] ------------[ cut here ]------------
[   38.871817] WARNING: CPU: 3 PID: 751 at lib/refcount.c:187
refcount_sub_and_test_checked+0xa4/0xb8
[   38.883277] refcount_t: underflow; use-after-free.
[   38.889358] Modules linked in: mt76x0u(+) mt76x0_common mt76x02_usb
mt76_usb mt76x02_lib mt76 mac80211 bnep hci_uart btbcm serdev
bluetooth ecdh_generic spidev brcmfmac brcmutil sha256_generic
cfg80211 rfkill raspberrypi_hwmon hwmon b
cm2835_v4l2(C) i2c_bcm2835 v4l2_common videobuf2_vmalloc
videobuf2_memops snd_bcm2835(C) spi_bcm2835 videobuf2_v4l2
videobuf2_common snd_pcm videodev snd_timer media snd uio_pdrv_genirq
uio fixed i2c_dev ip_tables x_tables ipv6
[   38.938953] CPU: 3 PID: 751 Comm: systemd-udevd Tainted: G
C        5.0.0-rc5-v7+ #1
[   38.950574] Hardware name: BCM2835
[   38.955503] Backtrace:
[   38.959410] [<8010c91c>] (dump_backtrace) from [<8010cc00>]
(show_stack+0x20/0x24)
[   38.969952]  r6:60000013 r5:ffffffff r4:00000000 r3:a50bade6
[   38.977198] [<8010cbe0>] (show_stack) from [<807ca5f4>]
(dump_stack+0xc8/0x114)
[   38.986183] [<807ca52c>] (dump_stack) from [<8011e65c>]
(__warn+0xf4/0x120)
[   38.994804]  r9:000000bb r8:804d0138 r7:00000009 r6:8099dc84
r5:00000000 r4:b9631b58
[   39.005708] [<8011e568>] (__warn) from [<8011e6d0>]
(warn_slowpath_fmt+0x48/0x50)
[   39.016372]  r9:7f652128 r8:80d1419c r7:80c0bac4 r6:b34a2044
r5:b6096780 r4:00000000
[   39.027368] [<8011e68c>] (warn_slowpath_fmt) from [<804d0138>]
(refcount_sub_and_test_checked+0xa4/0xb8)
[   39.040150]  r3:80c91c25 r2:8099dc94
[   39.045296]  r4:00000000
[   39.049320] [<804d0094>] (refcount_sub_and_test_checked) from
[<804d0164>] (refcount_dec_and_test_checked+0x18/0x1c)
[   39.062966]  r4:b6096780 r3:00000001
[   39.068043] [<804d014c>] (refcount_dec_and_test_checked) from
[<805db49c>] (usb_free_urb+0x20/0x4c)
[   39.080279] [<805db47c>] (usb_free_urb) from [<7f62d804>]
(mt76u_buf_free+0x98/0xac [mt76_usb])
[   39.092224]  r4:00000001 r3:00000001
[   39.097386] [<7f62d76c>] (mt76u_buf_free [mt76_usb]) from
[<7f62def8>] (mt76u_queues_deinit+0x44/0x100 [mt76_usb])
[   39.111016]  r8:b791f600 r7:b3628480 r6:b3628e20 r5:00000001
r4:00000000 r3:00000080
[   39.122039] [<7f62deb4>] (mt76u_queues_deinit [mt76_usb]) from
[<7f650040>] (mt76x0u_cleanup+0x40/0x4c [mt76x0u])
[   39.135636]  r7:b3628480 r6:b791f600 r5:ffffffea r4:b3628e20
[   39.142968] [<7f650000>] (mt76x0u_cleanup [mt76x0u]) from
[<7f650564>] (mt76x0u_probe+0x1f0/0x354 [mt76x0u])
[   39.156063]  r4:b3628e20 r3:00000000
[   39.161202] [<7f650374>] (mt76x0u_probe [mt76x0u]) from
[<805e0b6c>] (usb_probe_interface+0x104/0x240)
[   39.173805]  r7:00000000 r6:7f652034 r5:b6299000 r4:b791f620
[   39.181165] [<805e0a68>] (usb_probe_interface) from [<8056a8bc>]
(really_probe+0x224/0x2f8)
[   39.192856]  r10:b626d800 r9:00000019 r8:7f652034 r7:80d3e124
r6:00000000 r5:80d3e120
[   39.204057]  r4:b791f620 r3:805e0a68
[   39.209269] [<8056a698>] (really_probe) from [<8056ab60>]
(driver_probe_device+0x6c/0x180)
[   39.220854]  r10:b626d800 r9:7f6522c0 r8:b791f620 r7:00000000
r6:7f652034 r5:7f652034
[   39.232057]  r4:b791f620 r3:00000000
[   39.237265] [<8056aaf4>] (driver_probe_device) from [<8056ad54>]
(__driver_attach+0xe0/0xe4)
[   39.248982]  r9:7f6522c0 r8:7f65122c r7:00000000 r6:b791f654
r5:7f652034 r4:b791f620
[   39.260002] [<8056ac74>] (__driver_attach) from [<8056880c>]
(bus_for_each_dev+0x68/0xa0)
[   39.271498]  r6:8056ac74 r5:7f652034 r4:00000000 r3:00000027
[   39.278885] [<805687a4>] (bus_for_each_dev) from [<8056a1cc>]
(driver_attach+0x28/0x30)
[   39.290252]  r6:80c6ddc8 r5:b6096a00 r4:7f652034
[   39.296557] [<8056a1a4>] (driver_attach) from [<80569c24>]
(bus_add_driver+0x194/0x21c)
[   39.307899] [<80569a90>] (bus_add_driver) from [<8056b504>]
(driver_register+0x8c/0x124)
[   39.319328]  r7:80c6ddc8 r6:7f652034 r5:00000000 r4:7f652034
[   39.326730] [<8056b478>] (driver_register) from [<805df510>]
(usb_register_driver+0x74/0x140)
[   39.338655]  r5:00000000 r4:7f652000
[   39.343880] [<805df49c>] (usb_register_driver) from [<7f655024>]
(mt76x0_driver_init+0x24/0x1000 [mt76x0u])
[   39.357002]  r9:00000001 r8:7f652308 r7:00000000 r6:80c08d48
r5:7f655000 r4:7f6522c0
[   39.368143] [<7f655000>] (mt76x0_driver_init [mt76x0u]) from
[<80102f6c>] (do_one_initcall+0x4c/0x210)
[   39.380894] [<80102f20>] (do_one_initcall) from [<801ae63c>]
(do_init_module+0x6c/0x21c)
[   39.392392]  r8:7f652308 r7:80c08d48 r6:b6116880 r5:7f6522c0
r4:7f6522c0
[   39.400876] [<801ae5d0>] (do_init_module) from [<801ad68c>]
(load_module+0x1d10/0x2304)

Moreover for mt76x0u SG is 'already' disabled since we use just one
buffer so from performance point of view I do not see any difference
of using a standard usb buffer.
This patch has been tested in multiple scenarios and seems to fix
reported issues (for usb2.0).
Are you concerned about increasing code complexity?

Regards,
Lorenzo

>
> Stanislaw
