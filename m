Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33931 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbcEQWMe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2016 18:12:34 -0400
Received: by mail-wm0-f67.google.com with SMTP id n129so8239778wmn.1
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2016 15:12:33 -0700 (PDT)
MIME-Version: 1.0
From: Daniel Lenski <dlenski@gmail.com>
Date: Tue, 17 May 2016 15:11:53 -0700
Message-ID: <CAOw_LSHt8u00A9FbLAjbiATQgtr_LC5idbrhFGC6B9_BmOxo1A@mail.gmail.com> (sfid-20160518_001238_202950_3192D1D2)
Subject: rtl8xxxu: "Firmware failed to start" caused by too-short polling timeout
To: linux-wireless@vger.kernel.org
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
I submitted a small patch for the r8723au driver a few months, and
quickly abandoned that driver once Jes Sorensen pointed out his
rtl8xxxu wireless driver which supports the same RTL8723AU chipset and
is part of the mainline
(http://thread.gmane.org/gmane.linux.kernel.wireless.general/146615).

I frequently encounter "Firmware failed to start" errors after a cold
boot, although rtl8xxxu is totally stable and reliable otherwise.

It appears that other chipsets supported by the driver have the same
problem. Here are a couple of relevant bug reports:
- http://ubuntuforums.org/showthread.php?t=2321756
- https://www.mail-archive.com/ubuntu-bugs@lists.ubuntu.com/msg4942468.html

This issue seems to occur because RTL8XXXU_FIRMWARE_POLL_MAX (1000) is
too short, and the MCU fails to start up as quickly as expected:

        /* Wait for firmware to become ready */
        for (i = 0; i < RTL8XXXU_FIRMWARE_POLL_MAX; i++) {
                val32 = rtl8xxxu_read32(priv, REG_MCU_FW_DL);
                if (val32 & MCU_WINT_INIT_READY)
                        break;

                udelay(100);
        }

        if (i == RTL8XXXU_FIRMWARE_POLL_MAX) {
                dev_warn(dev, "Firmware failed to start\n");
                ret = -EAGAIN;
                goto exit;
        }

I've made a small patch to make a configurable module parameter
(firmware_poll_max). With a longer value (5000), the driver now starts
up consistently and successfully after cold-boot.

I would like to propose both increasing the default value, and making
it a configurable parameter. If this patch will be useful as-is, I
will submit it, or I can help collect more debugging information if
it's desired.

Thanks,
Dan Lenski
