Return-Path: <SRS0=n0sb=OU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDC84C67839
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 23:45:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6562B2084E
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 23:45:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="UX9n1H7s"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6562B2084E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbeLKXpC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Dec 2018 18:45:02 -0500
Received: from mail-yw1-f41.google.com ([209.85.161.41]:37259 "EHLO
        mail-yw1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbeLKXpC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Dec 2018 18:45:02 -0500
Received: by mail-yw1-f41.google.com with SMTP id h193so6221527ywc.4
        for <linux-wireless@vger.kernel.org>; Tue, 11 Dec 2018 15:45:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OW5qpbcRoyJ7y5emXk8hMndxC2vGiaot2klsnu8/cr4=;
        b=UX9n1H7s5KRlEYLAWNZki1R2jre8HjIMyh2YzrINCIUxh24MYxqJWPOEMF0BTCnge2
         1hhz+7+OCmi4di+SwMdHxocb4CGxzh1DWRBg9UjF9+HvSi6ogFxm+LxJczFLJINwvN3T
         ytECPRSmIEgiJPxFWE8VJ00W7gR5RTiouY/Zc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OW5qpbcRoyJ7y5emXk8hMndxC2vGiaot2klsnu8/cr4=;
        b=TOHbBQmJz1cmJz95UoW1HP76FZq+WR0tjXpKJfJxqVPO8IYjx1zmXKrn+21ajuwhvy
         4m/r4T9vAsjTDilKZbOJynezbIy1GdjiMl1JP/gVZdxNywjY54b8oIyBOvjredd0o5Xv
         sYjYJXGx5c9pXu8kB8ud7F0Kj4tPeplPgyHfvlbx8hldRX2ndZJBbQ4XjzSfhdivxV79
         5bAt/Fniv684CgcDp1LGDlVUdazsQMlD/L9DMj7J9outR2QBuwTQSiOgjNRF8bvLdlGC
         QPstnfjswfbYLq7tGwsXMWFsnLCQ59T3xmM1xuzCX8siVhB3Zhjfq8HVvmE0IGzE56AU
         loqA==
X-Gm-Message-State: AA+aEWaWBk56B/7Kh/IkRlpSvXovh3iqalaRyqkU38+P6nPENehjS/PD
        hFJA1TY/DoA1GToH5WdqVK4y24E9fdlha+oF+2El7g==
X-Google-Smtp-Source: AFSGD/U5gB9qv70jL/klmfICapYdJ2GTzMHHUwjlHVpU2pan333NJVpdYSkZgBVg8uT/H0gMgpVoeQa+SCMg25XwGRA=
X-Received: by 2002:a81:5250:: with SMTP id g77mr18473280ywb.95.1544571900563;
 Tue, 11 Dec 2018 15:45:00 -0800 (PST)
MIME-Version: 1.0
References: <CAHYQr0pKurSS=nvLEaLzup1hgx4+RJ0CezA2nFeA=C4XBDQQog@mail.gmail.com>
 <20181211181944.GW39861@atomide.com> <CAHYQr0pk-WKM-aYR7ubM4GHx8PA82XP5ze9TW9WEJLzdO0f88A@mail.gmail.com>
 <20181211190128.GX39861@atomide.com> <CAHYQr0qc_Lav=1sEGcOmOykUftWRzd6+vis97eBpanEXzfUHaA@mail.gmail.com>
 <CALAqxLUVajBw_PkyhA0s=FhQQHWu1FBEMX+4oDTStRXr6L5Txw@mail.gmail.com>
 <20181211201221.GY39861@atomide.com> <CAHYQr0qffa_G2ZVnSsDfjqSgxuBBZB+8e6ZODpAWV_TMhqzFYg@mail.gmail.com>
 <CAHYQr0onAAMZ21YU59XOgNsVrZ-+33tUHfOa9aPr+hG2M0zb3g@mail.gmail.com>
In-Reply-To: <CAHYQr0onAAMZ21YU59XOgNsVrZ-+33tUHfOa9aPr+hG2M0zb3g@mail.gmail.com>
From:   Anders Roxell <anders.roxell@linaro.org>
Date:   Wed, 12 Dec 2018 00:44:48 +0100
Message-ID: <CADYN=9KCQTecPHgDGU2iSF+q14Zjya1tGcn1suLWrm+6e_KSJw@mail.gmail.com>
Subject: Re: wlcore getting stuck on hikey after the runtime PM autosuspend
 support change
To:     rsalveti@rsalveti.net
Cc:     Tony Lindgren <tony@atomide.com>,
        John Stultz <john.stultz@linaro.org>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 11 Dec 2018 at 22:51, Ricardo Salveti <rsalveti@rsalveti.net> wrote:
>
> On Tue, Dec 11, 2018 at 6:23 PM Ricardo Salveti <rsalveti@rsalveti.net> wrote:
> > And now with while true:
> > Dec 11 20:18:13 hikey kernel: wlcore: mac80211 configure filter
> > changed 0 total 80000000
> > Dec 11 20:18:13 hikey kernel: wlcore: waking up chip from elp
> > Dec 11 20:18:13 hikey kernel: wlcore: wakeup time: 8 ms
> > Dec 11 20:18:13 hikey kernel: wlcore: acx group address tbl
> > Dec 11 20:18:13 hikey kernel: wlcore: cmd configure (63)
> > Dec 11 20:18:13 hikey kernel: wlcore: mac80211 remove interface
> > Dec 11 20:18:13 hikey kernel: wlcore: down
> > Dec 11 20:18:13 hikey kernel: wlcore: cmd role disable
> > Dec 11 20:18:13 hikey kernel: wlcore: IRQ work
> > Dec 11 20:18:13 hikey kernel: wlcore: mac80211 stop
> > Dec 11 20:18:13 hikey kernel: wlcore: intr: 0x20 (fw_rx_counter = 0,
> > drv_rx_counter = 0, tx_results_counter = 0)
> > Dec 11 20:18:13 hikey kernel: wlcore: WL1271_ACX_INTR_HW_AVAILABLE
> >
> > Dec 11 20:18:13 hikey kernel: wlcore: mac80211 start
> > Dec 11 20:18:13 hikey kernel: wlcore: mac80211 add interface type 2
> > mac 84:dd:20:92:54:5b
> > Dec 11 20:18:13 hikey kernel: wlcore: allocating hw queue base: 0
> > Dec 11 20:18:13 hikey kernel: wlcore: clock freq 5 (13, 120, 0, 0, spit)
> > Dec 11 20:18:13 hikey kernel: wlcore: chip id 0x6030111
> > Dec 11 20:18:13 hikey kernel: wlcore: firmware chunks to be uploaded: 15
> > Dec 11 20:18:13 hikey kernel: wlcore: chunk 14 addr 0x0 len 120432
> > Dec 11 20:18:13 hikey kernel: wlcore: starting firmware upload
> > Dec 11 20:18:13 hikey kernel: wlcore: fw_data_len 120432 chunk_size 16384
> > Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> > 0x000000002d8a6a40 to 0x0
> > Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> > 0x0000000048dff62f to 0x4000
> > Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> > 0x00000000f9372750 to 0x8000
> > Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> > 0x00000000f2685ee4 to 0xc000
> > Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> > 0x00000000c4fc484d to 0x10000
> > Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> > 0x00000000a6d3c9bf to 0x14000
> > Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> > 0x000000007404dc0f to 0x18000
> > Dec 11 20:18:13 hikey kernel: wlcore: uploading fw last chunk (5744 B)
> > 0x00000000d7beb1f6 to 0x1c000
> > Dec 11 20:18:13 hikey kernel: wlcore: chunk 13 addr 0x100000 len 131072
> > Dec 11 20:18:13 hikey kernel: wlcore: starting firmware upload
> > Dec 11 20:18:13 hikey kernel: wlcore: fw_data_len 131072 chunk_size 16384
> > Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> > 0x00000000c3cad69f to 0x100000
> > Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> > 0x00000000a9e4f338 to 0x104000
> > Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> > 0x000000003169e0a1 to 0x108000
> > Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> > 0x00000000cc5b7549 to 0x10c000
> > Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> > 0x000000009c0bb98a to 0x110000
> > Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> > 0x00000000f4d0b2c2 to 0x114000
> > Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> > 0x0000000026e1d203 to 0x118000
> > Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> > 0x00000000a3905e9c to 0x11c000
> > Dec 11 20:18:13 hikey kernel: wlcore: uploading fw last chunk (0 B)
> > 0x00000000f0c022b6 to 0x120000
> > Dec 11 20:18:13 hikey kernel: wlcore: chunk 12 addr 0x20400000 len 52600
> > Dec 11 20:18:13 hikey kernel: wlcore: starting firmware upload
> > Dec 11 20:18:13 hikey kernel: wlcore: fw_data_len 52600 chunk_size 16384
> > Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> > 0x000000004f52801e to 0x20400000
> > Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> > 0x0000000066503358 to 0x20404000
> > Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> > 0x00000000433fff1b to 0x20408000
> > Dec 11 20:18:13 hikey kernel: wlcore: uploading fw last chunk (3448 B)
> > 0x00000000a38c9bd9 to 0x2040c000
> > Dec 11 20:18:13 hikey kernel: wlcore: chunk 11 addr 0xb00000 len 536
> > Dec 11 20:18:13 hikey kernel: wlcore: starting firmware upload
> > Dec 11 20:18:13 hikey kernel: wlcore: fw_data_len 536 chunk_size 16384
> > Dec 11 20:18:13 hikey kernel: wlcore: uploading fw last chunk (536 B)
> > 0x00000000ced82f93 to 0xb00000
> > Dec 11 20:18:13 hikey kernel: wlcore: chunk 10 addr 0xb0ae40 len 28120
> > Dec 11 20:18:13 hikey kernel: wlcore: starting firmware upload
> > Dec 11 20:18:13 hikey kernel: wlcore: fw_data_len 28120 chunk_size 16384
> > Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> > 0x00000000d6832925 to 0xb0ae40
> > Dec 11 20:18:13 hikey kernel: wlcore: uploading fw last chunk (11736
> > B) 0x0000000037ae96d5 to 0xb0ee40
> > Dec 11 20:18:13 hikey kernel: wlcore: chunk 9 addr 0x80900000 len 61140
> > Dec 11 20:18:13 hikey kernel: wlcore: starting firmware upload
> > Dec 11 20:18:13 hikey kernel: wlcore: fw_data_len 61140 chunk_size 16384
> > Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> > 0x0000000096b9ba67 to 0x80900000 -------> hangs
> >
> > See the missing 'mmc_host mmc2' messages, which probably indicates
> > that mmc_host wasn't properly set after the down/up sequence, causing
> > the hang when uploading the firmware.
>
> Tried to change back wl12xx_sdio_power_off to use pm_runtime_put_sync
> as a test, and noticed I always get -EBUSY when reproducing the hang,
> so it looks like this could be a race between pm_runtime_put/get when
> doing if down/up (and the side effect on the mmc controller).

I have different serious, one when our board hangs on udhcpc [1], then I see
wlcore and wl18xx_driver.

[    8.824419] cfg80211: Loading compiled-in X.509 certificates for
regulatory database
[    8.852546] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[    8.861006] platform regulatory.0: Direct firmware load for
regulatory.db failed with error -2
[    8.870248] cfg80211: failed to load regulatory.db
[    8.895501] asix 1-1.1:1.0 eth0: register 'asix' at
usb-f72c0000.usb-1.1, ASIX AX88772B USB 2.0 Ethernet,
00:50:b6:14:c8:76
[    8.912285] usbcore: registered new interface driver asix
[    9.053373] mmc_host mmc2: Bus speed (slot 0) = 24800000Hz (slot
req 100000Hz, actual 100000HZ div = 124)
[    9.130886] mmc_host mmc2: Bus speed (slot 0) = 24800000Hz (slot
req 25000000Hz, actual 24800000HZ div = 0)
[    9.149318] wl18xx_driver wl18xx.3.auto: Direct firmware load for
ti-connectivity/wl18xx-conf.bin failed with error -2
[    9.160459] wlcore: ERROR could not get configuration binary
ti-connectivity/wl18xx-conf.bin: -2
[    9.169615] wlcore: WARNING falling back to default config
[    9.214108] mmc_host mmc2: Bus speed (slot 0) = 24800000Hz (slot
req 100000Hz, actual 100000HZ div = 124)
[    9.294294] mmc_host mmc2: Bus speed (slot 0) = 24800000Hz (slot
req 25000000Hz, actual 24800000HZ div = 0)
[[0;32m  OK  [0m] Listening on Load/Save RF Kill Switch Status
/dev/rfkill Watch.
[[0;32m  OK  [0m] Reached target Sockets.
[[0;32m  OK  [0m] Reached target Basic System.
         Starting Entropy Daemon based on the HAVEGE algorithm...
[[0;32m  OK  [0m] Started TEE Supplicant.
[    9.514713] wlcore: wl18xx HW: 183x or 180x, PG 2.2 (ROM 0x11)
[    9.526319] wlcore: WARNING Detected unconfigured mac address in
nvs, derive from fuse instead.
[    9.535454] wlcore: WARNING This default nvs file can be removed
from the file system

and when it passes that stage I can't find wlcore nor wl18xx_driver.
However, I can see
wl1271_sdio failing instead. See [2]

[    8.435849] Bluetooth: HCI UART protocol Broadcom registered
[    8.439669] mmc_host mmc2: Bus speed (slot 0) = 24800000Hz (slot
req 200000Hz, actual 200000HZ div = 62)
[[0;32m  OK  [0m] Started dnf-automatic-download timer.
[    8.469492] wl1271_sdio: probe of mmc2:0001:2 failed with error -16
[[0;32m  OK  [0m] Started Daily Cleanup of Temporary Directories.
[[0;32m  OK  [0m] Started dnf-automatic-install timer.
[    8.525443] Console: switching to colour frame buffer device 256x72
[    8.533489] Bluetooth: hci0: change remote baud rate command in firmware
[    8.584607] kirin-drm f4100000.ade: fb0: DRM emulated frame buffer device
[[0;32m  OK  [0m] Started dnf-automatic-notifyonly timer.
[[0;32m  OK  [0m] Listening on R[    8.614417] [drm] Initialized kirin
1.0.0 20150718 for f4100000.ade on minor 0

and another job that have the similar issue with the previous is [3]:

[    8.670110] adv7511 2-0039: 2-0039 supply pvdd not found, using
dummy regulator
[    8.677908] adv7511 2-0039: 2-0039 supply a2vdd not found, using
dummy regulator
[    8.685788] adv7511 2-0039: 2-0039 supply v3p3 not found, using
dummy regulator
[    8.688699] wl1271_sdio: probe of mmc2:0001:1 failed with error -16
[    8.690154] Bluetooth: Core ver 2.22
[    8.690346] NET: Registered protocol family 31
[    8.690355] Bluetooth: HCI device and connection manager
initialized
[    8.693495] adv7511 2-0039: 2-0039 supply v1p2 not found, using
dummy regulator
[    8.700240] wl1271_sdio: probe of mmc2:0001:2 failed with error -16
[    8.700992] Bluetooth: HCI socket layer initialized
[    8.701022] Bluetooth: L2CAP socket layer initialized
[    8.701554] Bluetooth: SCO socket layer initialized
             Starting sshd.socket.
[[0;32m  OK  [0m] Listening on RPCbind Server Activation Socket.
[[0;32m  OK  [0m] Started Daily rotation of log files.
[    8.791540] Bluetooth: HCI UART driver ver 2.3


I'm confused why we only see wlcore wl18xx in job [1] and that we see wl1271
in the other and that we are able to start running tests, even though
I don't think
the jobs where we run tests booted up OK, since we can see
"wl1271_sdio: probe of mmc2:0001:1 failed with error -16".

Cheers,
Anders

[1] https://lkft.validation.linaro.org/scheduler/job/543012
[2] https://lkft.validation.linaro.org/scheduler/job/506683
[3] https://lkft.validation.linaro.org/scheduler/job/487494
