Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F95FC282C4
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 12:08:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EB942084D
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 12:08:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfBIMIx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Feb 2019 07:08:53 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:51415 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbfBIMIx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Feb 2019 07:08:53 -0500
Received: from oxbaltgw66.schlund.de ([172.19.246.153]) by
 mrelayeu.kundenserver.de (mreue011 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MuV3i-1h9HUx2VUI-00rZIX; Sat, 09 Feb 2019 13:08:41 +0100
Date:   Sat, 9 Feb 2019 13:08:39 +0100 (CET)
From:   Stefan Wahren <stefan.wahren@i2se.com>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>
Cc:     linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org
Message-ID: <2003727085.234456.1549714119945@email.ionos.de>
Subject: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.8.4-Rev47
X-Originating-Client: open-xchange-appsuite
X-Provags-ID: V03:K1:2Jv1i4Qd/YPDGreg9X8adeKfaotGj0XgaXwMTJ8um/wt0jmDLF7
 0UMl0aJWXDD3rxyVxkSz9aK5tu2CWv1BzwCd21p5jtUzrmSIY0zBNmxpq9WISWNQkP7G4ue
 Unq2MCr14iQ4IEhEUtrtHd2TpPX+yUoovkytL7gzQjFTUlNNwu4nJ2CvzjkoSOZbl5ZQ87J
 FXVbQoc5rRIM4vPC7+YxA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:A5AxalNJmtQ=:0+tcCIFECgCZSXGJP0AOUz
 NSMOU9W03jLuT2rzv/n/vdpoH+uv1BNa07HlANz1qencK1mDRnAEUVyy24nuUsa1HC4JUkR4k
 f6LUte2d5w582caBWBxdKuGTOTMd7u1rJm1gadyKSTUYnbKDXIWJ0sDUYkE9isp6ixTAMQwqk
 HbQEDOOfTXDgNGY8XIn79xpWnuVMk+LqRf1zWI2yp5DgX1j91qrpFd0asW1/kYTKCcTW1ChDM
 n88+6zf95NHglGG7iseAf3YtVAyDA/GyHCzw9E/JSqI+VgHisb3f0MThc48n9/OE9R509mr3f
 6clN883a0zZ3Q4BBkRTSJMj1jW5J1PCe8NLB/roedROhGbkjI7jxfjiKe80UkCDEoS/ZkhhbD
 TC6Zk4C0UulY98DugA2Tdzz8GxVzzEurq4OdQRux6GH5u7wZR6gHecyCJYX1C+g9F+sqbGAue
 tcoK7sICHdJhcq8rT8RSxgVIpxb/9dnvwbF1a9droKPbABfyoMo4gmq9vTzuoytDj8n4pt8WN
 B09TJk+/5AgkfMUXEwflrwoaF9ydg3esfglEuKhYjuRDuIdNhTGDYAklEHRCOJ/TefYwgTdtu
 LLAvM5rFfiW8rlYnoArguq3yn868HTRwxT3R874bKXWUNBu0xs8Ue8umgUvJ1pif5S9ruzGxZ
 dUbiyFF2N6zXW5YrheZ2VBXsdhfU+y4j3TBYeyS7WwgMLmohz9yc7k4+KJL62Vy5vhLFSS8/W
 B6btbEScjGnd0mcX3KVg7+IAfrqeW7DoNlC2gcJW47c85aNCRtGlpHm6t8I=
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

as already reported here [1], that there are probing issues of mt76 using TP-Link Archer T2UH (wifi USB dongle) on Raspberry Pi 3 B+.

I retested it with recent linux-next 20190208 (aarch64 defconfig + enabling mt76 driver) and got the following output after plugin the wifi dongle:

[   29.778524] usb 1-1.3: new high-speed USB device number 6 using dwc2
[   31.794581] usb 1-1.3: reset high-speed USB device number 6 using dwc2
[   31.919916] mt76x0u 1-1.3:1.0: ASIC revision: 76100002 MAC revision: 76502000
[   32.304412] dwc2 3f980000.usb: dwc2_update_urb_state(): trimming xfer length
[   32.325724] dwc2 3f980000.usb: dwc2_update_urb_state(): trimming xfer length
[   32.346866] dwc2 3f980000.usb: dwc2_update_urb_state(): trimming xfer length
[   33.410559] mt76x0u 1-1.3:1.0: firmware upload timed out
[   33.435458] mt76x0u: probe of 1-1.3:1.0 failed with error -110
[   33.454829] usbcore: registered new interface driver mt76x0u

I took the firmware files from here [2].

Btw there is another issue, if i disconnect the wifi dongle during probe i'm getting a endless flood of the following output:

mt76x0u 1.1.3:1.0: rx urb failed: -71

Any chance to narrow down these issues?

[1] - https://marc.info/?l=linux-wireless&m=154875316703367
[2] - https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/mediatek
