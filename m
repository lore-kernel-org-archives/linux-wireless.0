Return-Path: <SRS0=n0sb=OU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5221C67839
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 20:24:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56FB920851
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 20:24:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=rsalveti-net.20150623.gappssmtp.com header.i=@rsalveti-net.20150623.gappssmtp.com header.b="DAIl382C"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 56FB920851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=rsalveti.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbeLKUYZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Dec 2018 15:24:25 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44948 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbeLKUYZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Dec 2018 15:24:25 -0500
Received: by mail-lj1-f195.google.com with SMTP id k19-v6so14175886lji.11
        for <linux-wireless@vger.kernel.org>; Tue, 11 Dec 2018 12:24:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rsalveti-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2Qv4eMo/O6XU2N/Tm1JMx6ZuGAFT63yf2kZxshqHu5o=;
        b=DAIl382CEdEo8KaT3nrdaRYhIm+Mv9H23QS153GzJKSTno+Qqd0yJGfNxJPBC5e/+B
         vVLYI8l2SdmRJIGXGxDskahfaXQ/RaaYnHIg8mMkm3HwfdMdn4xWfRdUnCJHcz9l9pP5
         BXLkhanQTYP+lXf45XFbLdRGv5mYnhZSG2jTdENQBhavNnatX0Qp+Y+3eAjRQ2MezHse
         H4fcphZfseVTsDtLG26kPlHUXtcBgCyqEz1lAZ09p39GmIkI9LZ10XrU9kw5O0aXi3JC
         7kZwjfe7YtFYl/28UgxJkQ5wsnBnTmAuTktp7+tsolzT69Tcx31WCAZObSlDTUC8lNYd
         Omwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2Qv4eMo/O6XU2N/Tm1JMx6ZuGAFT63yf2kZxshqHu5o=;
        b=arsHrCx0ct31J1A+Dci3BFXIRf/ji2Vd9jBw8GA6+TQidpkjRUDamSty6fSpeEDED7
         Nhf9y3We1/3L4c80LBCUtzZn3W/oCxYdHpCGvl2AqLqalOC7wvidOnDUy+BLfA5ly0yG
         56ed9YEcfoNQW1LpZngBHSpS+PrOUHNZ32zKQ6RGGGzq7NUZx+UG/ZP5rzAn4iShU7+L
         OpRop3lBTFfSr8ip6+AAgKIog2ZHkZmuOq0u22PApO6z1RiRQ5xlsABZwWaIWyEC5rEW
         AEE3bNEMF7eY9VYHo3liq+rZSYcMOEQJOI70nwmFfiGPyY1Z83WodVnS/CzURgzuowII
         J/gg==
X-Gm-Message-State: AA+aEWZhfkH6PGnrGgDw7an2EDIARQmMm1sPM+kDS8FU5Vb1Aie3FM57
        59+woWySJBK9lHdrPO0YyoPFmj8zULCpg0uSQ6zXF8Nmqco=
X-Google-Smtp-Source: AFSGD/X977oZQjeh92RX/mZyox1BIrgp9KNp3qkZji0Whix10HunRBElCSBEFWFB544iEb247mXb+hw5w+Hs5HETJOs=
X-Received: by 2002:a2e:2106:: with SMTP id h6-v6mr10298040ljh.37.1544559861827;
 Tue, 11 Dec 2018 12:24:21 -0800 (PST)
MIME-Version: 1.0
References: <CAHYQr0pKurSS=nvLEaLzup1hgx4+RJ0CezA2nFeA=C4XBDQQog@mail.gmail.com>
 <20181211181944.GW39861@atomide.com> <CAHYQr0pk-WKM-aYR7ubM4GHx8PA82XP5ze9TW9WEJLzdO0f88A@mail.gmail.com>
 <20181211190128.GX39861@atomide.com> <CAHYQr0qc_Lav=1sEGcOmOykUftWRzd6+vis97eBpanEXzfUHaA@mail.gmail.com>
 <CALAqxLUVajBw_PkyhA0s=FhQQHWu1FBEMX+4oDTStRXr6L5Txw@mail.gmail.com> <20181211201221.GY39861@atomide.com>
In-Reply-To: <20181211201221.GY39861@atomide.com>
From:   Ricardo Salveti <rsalveti@rsalveti.net>
Date:   Tue, 11 Dec 2018 18:23:44 -0200
Message-ID: <CAHYQr0qffa_G2ZVnSsDfjqSgxuBBZB+8e6ZODpAWV_TMhqzFYg@mail.gmail.com>
Subject: Re: wlcore getting stuck on hikey after the runtime PM autosuspend
 support change
To:     Tony Lindgren <tony@atomide.com>
Cc:     John Stultz <john.stultz@linaro.org>,
        linux-wireless@vger.kernel.org, anders.roxell@linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Dec 11, 2018 at 6:12 PM Tony Lindgren <tony@atomide.com> wrote:
>
> * John Stultz <john.stultz@linaro.org> [181211 19:51]:
> > On Tue, Dec 11, 2018 at 11:25 AM Ricardo Salveti <rsalveti@rsalveti.net> wrote:
> > > Then tried to reproduce with a simple 'while true; do ip link set dev
> > > wlan0 down; ip link set dev wlan0 up; done;' and it was already enough
> > > to cause the same hang. Adding a simple sleep 1 after down/up is
> > > already enough to make it work, so something might be missing during
> > > the down/up process that only happens when they get called right after
> > > the other.
>
> With while true test above, I'm getting:
>
> wlcore: ERROR timeout waiting for the hardware to complete initialization
>
> Then after ctrl-c, wlan0 connects to the access point just fine
> for me.
>
> Is that what you're seeing or some oops?

I'm getting the following oops with the while true test:
[ 1088.565996] INFO: task ifconfig:941 blocked for more than 120 seconds.
[ 1088.572552]       Not tainted 4.20.0-rc6-lmp-standard #1
[ 1088.577913] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1088.585777] ifconfig        D    0   941    916 0x00000008
[ 1088.591316] Call trace:
[ 1088.593772]  __switch_to+0xa0/0xf8
[ 1088.597200]  __schedule+0x2ac/0x948
[ 1088.600715]  schedule+0x38/0x98
[ 1088.603882]  schedule_timeout+0x288/0x458
[ 1088.607918]  wait_for_common+0x148/0x170
[ 1088.611866]  wait_for_completion+0x28/0x38
[ 1088.616013]  mmc_wait_for_req_done+0x38/0x198
[ 1088.620397]  mmc_wait_for_req+0xb0/0xf0
[ 1088.624259]  mmc_io_rw_extended+0x1d0/0x2c0
[ 1088.628469]  sdio_io_rw_ext_helper+0x180/0x1f8
[ 1088.633112]  sdio_memcpy_toio+0x44/0x58
[ 1088.636979]  wl12xx_sdio_raw_write+0xe0/0x1b0
[ 1088.641386]  wlcore_boot_upload_firmware+0x1a8/0x4c0
[ 1088.646378]  wl18xx_boot+0x7dc/0xbc0
[ 1088.649986]  wl1271_op_add_interface+0x558/0x910
[ 1088.654659]  drv_add_interface+0x5c/0x1e8
[ 1088.658716]  ieee80211_do_open+0x220/0x7f8
[ 1088.662857]  ieee80211_open+0x4c/0x68
[ 1088.666591]  __dev_open+0xdc/0x158
[ 1088.670034]  __dev_change_flags+0x15c/0x1c0
[ 1088.674246]  dev_change_flags+0x34/0x70
[ 1088.678131]  devinet_ioctl+0x3fc/0x740
[ 1088.681908]  inet_ioctl+0x108/0x278
[ 1088.685425]  sock_do_ioctl+0x5c/0x240
[ 1088.689133]  sock_ioctl+0x1e8/0x3f0
[ 1088.692652]  do_vfs_ioctl+0xc4/0x868
[ 1088.696253]  ksys_ioctl+0x84/0xb8
[ 1088.699594]  __arm64_sys_ioctl+0x28/0x38
[ 1088.703545]  el0_svc_common+0x94/0xe8
[ 1088.707233]  el0_svc_handler+0x74/0x90
[ 1088.711031]  el0_svc+0x8/0xc

Added some more debugging, and this is what I'm getting when I add
some delay between down/up (working behavior):

wlan0 down:
Dec 11 20:17:06 hikey kernel: wlcore: mac80211 remove interface
Dec 11 20:17:06 hikey kernel: wlcore: mac80211 configure filter
changed 0 total 80000000
Dec 11 20:17:06 hikey kernel: wlcore: down
Dec 11 20:17:06 hikey kernel: wlcore: waking up chip from elp
Dec 11 20:17:06 hikey kernel: wlcore: wakeup time: 12 ms
Dec 11 20:17:06 hikey kernel: wlcore: cmd role disable
Dec 11 20:17:06 hikey kernel: wlcore: mac80211 stop
Dec 11 20:17:06 hikey kernel: wlcore: IRQ work
Dec 11 20:17:06 hikey kernel: wlcore: intr: 0x20 (fw_rx_counter = 172,
drv_rx_counter = 11, tx_results_counter = 0)
Dec 11 20:17:06 hikey kernel: wlcore: WL1271_ACX_INTR_HW_AVAILABLE

wlan0 up:
Dec 11 20:17:11 hikey kernel: wlcore: mac80211 start
Dec 11 20:17:11 hikey kernel: wlcore: mac80211 add interface type 2
mac 84:dd:20:92:54:5b
Dec 11 20:17:11 hikey kernel: wlcore: allocating hw queue base: 0
Dec 11 20:17:11 hikey kernel: mmc_host mmc2: Bus speed (slot 0) =
24800000Hz (slot req 300000Hz, actual 295238HZ div = 42)
Dec 11 20:17:11 hikey kernel: mmc_host mmc2: Bus speed (slot 0) =
24800000Hz (slot req 25000000Hz, actual 24800000HZ div = 0)
Dec 11 20:17:12 hikey kernel: wlcore: clock freq 5 (13, 120, 0, 0, spit)
Dec 11 20:17:12 hikey kernel: wlcore: chip id 0x6030111
Dec 11 20:17:12 hikey kernel: wlcore: firmware chunks to be uploaded: 15
Dec 11 20:17:12 hikey kernel: wlcore: chunk 14 addr 0x0 len 120432
Dec 11 20:17:12 hikey kernel: wlcore: starting firmware upload
Dec 11 20:17:12 hikey kernel: wlcore: fw_data_len 120432 chunk_size 16384
Dec 11 20:17:12 hikey kernel: wlcore: uploading fw chunk
0x000000002d8a6a40 to 0x0
Dec 11 20:17:12 hikey kernel: wlcore: uploading fw chunk
0x0000000048dff62f to 0x4000
Dec 11 20:17:12 hikey kernel: wlcore: uploading fw chunk
0x00000000f9372750 to 0x8000
Dec 11 20:17:12 hikey kernel: wlcore: uploading fw chunk
0x00000000f2685ee4 to 0xc000
Dec 11 20:17:12 hikey kernel: wlcore: uploading fw chunk
0x00000000c4fc484d to 0x10000
Dec 11 20:17:12 hikey kernel: wlcore: uploading fw chunk
0x00000000a6d3c9bf to 0x14000
Dec 11 20:17:12 hikey kernel: wlcore: uploading fw chunk
0x000000007404dc0f to 0x18000
Dec 11 20:17:12 hikey kernel: wlcore: uploading fw last chunk (5744 B)
0x00000000d7beb1f6 to 0x1c000
...

And now with while true:
Dec 11 20:18:13 hikey kernel: wlcore: mac80211 configure filter
changed 0 total 80000000
Dec 11 20:18:13 hikey kernel: wlcore: waking up chip from elp
Dec 11 20:18:13 hikey kernel: wlcore: wakeup time: 8 ms
Dec 11 20:18:13 hikey kernel: wlcore: acx group address tbl
Dec 11 20:18:13 hikey kernel: wlcore: cmd configure (63)
Dec 11 20:18:13 hikey kernel: wlcore: mac80211 remove interface
Dec 11 20:18:13 hikey kernel: wlcore: down
Dec 11 20:18:13 hikey kernel: wlcore: cmd role disable
Dec 11 20:18:13 hikey kernel: wlcore: IRQ work
Dec 11 20:18:13 hikey kernel: wlcore: mac80211 stop
Dec 11 20:18:13 hikey kernel: wlcore: intr: 0x20 (fw_rx_counter = 0,
drv_rx_counter = 0, tx_results_counter = 0)
Dec 11 20:18:13 hikey kernel: wlcore: WL1271_ACX_INTR_HW_AVAILABLE

Dec 11 20:18:13 hikey kernel: wlcore: mac80211 start
Dec 11 20:18:13 hikey kernel: wlcore: mac80211 add interface type 2
mac 84:dd:20:92:54:5b
Dec 11 20:18:13 hikey kernel: wlcore: allocating hw queue base: 0
Dec 11 20:18:13 hikey kernel: wlcore: clock freq 5 (13, 120, 0, 0, spit)
Dec 11 20:18:13 hikey kernel: wlcore: chip id 0x6030111
Dec 11 20:18:13 hikey kernel: wlcore: firmware chunks to be uploaded: 15
Dec 11 20:18:13 hikey kernel: wlcore: chunk 14 addr 0x0 len 120432
Dec 11 20:18:13 hikey kernel: wlcore: starting firmware upload
Dec 11 20:18:13 hikey kernel: wlcore: fw_data_len 120432 chunk_size 16384
Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
0x000000002d8a6a40 to 0x0
Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
0x0000000048dff62f to 0x4000
Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
0x00000000f9372750 to 0x8000
Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
0x00000000f2685ee4 to 0xc000
Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
0x00000000c4fc484d to 0x10000
Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
0x00000000a6d3c9bf to 0x14000
Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
0x000000007404dc0f to 0x18000
Dec 11 20:18:13 hikey kernel: wlcore: uploading fw last chunk (5744 B)
0x00000000d7beb1f6 to 0x1c000
Dec 11 20:18:13 hikey kernel: wlcore: chunk 13 addr 0x100000 len 131072
Dec 11 20:18:13 hikey kernel: wlcore: starting firmware upload
Dec 11 20:18:13 hikey kernel: wlcore: fw_data_len 131072 chunk_size 16384
Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
0x00000000c3cad69f to 0x100000
Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
0x00000000a9e4f338 to 0x104000
Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
0x000000003169e0a1 to 0x108000
Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
0x00000000cc5b7549 to 0x10c000
Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
0x000000009c0bb98a to 0x110000
Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
0x00000000f4d0b2c2 to 0x114000
Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
0x0000000026e1d203 to 0x118000
Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
0x00000000a3905e9c to 0x11c000
Dec 11 20:18:13 hikey kernel: wlcore: uploading fw last chunk (0 B)
0x00000000f0c022b6 to 0x120000
Dec 11 20:18:13 hikey kernel: wlcore: chunk 12 addr 0x20400000 len 52600
Dec 11 20:18:13 hikey kernel: wlcore: starting firmware upload
Dec 11 20:18:13 hikey kernel: wlcore: fw_data_len 52600 chunk_size 16384
Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
0x000000004f52801e to 0x20400000
Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
0x0000000066503358 to 0x20404000
Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
0x00000000433fff1b to 0x20408000
Dec 11 20:18:13 hikey kernel: wlcore: uploading fw last chunk (3448 B)
0x00000000a38c9bd9 to 0x2040c000
Dec 11 20:18:13 hikey kernel: wlcore: chunk 11 addr 0xb00000 len 536
Dec 11 20:18:13 hikey kernel: wlcore: starting firmware upload
Dec 11 20:18:13 hikey kernel: wlcore: fw_data_len 536 chunk_size 16384
Dec 11 20:18:13 hikey kernel: wlcore: uploading fw last chunk (536 B)
0x00000000ced82f93 to 0xb00000
Dec 11 20:18:13 hikey kernel: wlcore: chunk 10 addr 0xb0ae40 len 28120
Dec 11 20:18:13 hikey kernel: wlcore: starting firmware upload
Dec 11 20:18:13 hikey kernel: wlcore: fw_data_len 28120 chunk_size 16384
Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
0x00000000d6832925 to 0xb0ae40
Dec 11 20:18:13 hikey kernel: wlcore: uploading fw last chunk (11736
B) 0x0000000037ae96d5 to 0xb0ee40
Dec 11 20:18:13 hikey kernel: wlcore: chunk 9 addr 0x80900000 len 61140
Dec 11 20:18:13 hikey kernel: wlcore: starting firmware upload
Dec 11 20:18:13 hikey kernel: wlcore: fw_data_len 61140 chunk_size 16384
Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
0x0000000096b9ba67 to 0x80900000 -------> hangs

See the missing 'mmc_host mmc2' messages, which probably indicates
that mmc_host wasn't properly set after the down/up sequence, causing
the hang when uploading the firmware.

Thanks,
-- 
Ricardo Salveti de Araujo
