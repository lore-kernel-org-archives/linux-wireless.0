Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:38758 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbeH2GVe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 02:21:34 -0400
Received: by mail-it0-f68.google.com with SMTP id p129-v6so5233245ite.3
        for <linux-wireless@vger.kernel.org>; Tue, 28 Aug 2018 19:27:03 -0700 (PDT)
MIME-Version: 1.0
References: <1535381791-14908-1-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1535381791-14908-1-git-send-email-sgruszka@redhat.com>
From: Sid Hayn <sidhayn@gmail.com>
Date: Wed, 29 Aug 2018 02:26:44 +0000
Message-ID: <CAM0KTbB5k54BvA2UOmoss-PuGtgHE_SGy2cG4n4ROxPH7kxYXA@mail.gmail.com> (sfid-20180829_042706_338252_F21081CD)
Subject: Re: [PATCH v2 00/17] mt76 patches 2018-08-24 v2
To: sgruszka@redhat.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        lorenzo.bianconi@redhat.com, nbd@nbd.name,
        linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw et al,

Thanks for working on this, I have a small stack of different devices
covered by this driver which I'm excited to test with.

I'm running wireless-testing which may or may not be fully up to date
on the patches you have sent (head is at
c9cd161770dd1866207b70d41ec03c9a26eea94f from Aug 13th), so please
tell me if this has already been fixed.  I have a script that attempts
to connect to 16 differently configured SSIDs using 33 different (yet
compatible) wpa_supplicant.conf files and reports failures to me.
It's hardly perfect, but it gives me an idea if something is obviously
broken and needs a deeper dive.  When I run this script against a
device supported by mt76x2 or mt76x0 I get an unusual error.
Everything goes fine, connect, dhcp, disconnect, connect, dhcp,
disconnect, but after about 5 or 6 connections I start getting errors
like this during wpa_supplicant:

Could not set interface t2uh flags (UP): No space left on device
nl80211: Could not set interface 't2uh' UP
nl80211: deinit ifname=t2uh disabled_11b_rates=0
t2uh: Failed to initialize driver interface

and then this with dhcpcd:

dhcpcd_prestartinterface: t2uh: No space left on device
t2uh: waiting for carrier

the same happens with just ifconfig up:

SIOCSIFFLAGS: No space left on device

I see nothing useful in dmesg, and this happens after multiple
successful connections.  I've used this test setup before, and never
seen anything like this.  I will be happy to provide more detail if
requested, but for now here is a list of the tested device which
exhibit this behavior (named for my convenience to the model):

phy1    036acm          mt76x2u         MediaTek Inc.
phy0    pau0a           mt76x0          MediaTek Inc.
phy2    t1u             mt76x0
phy3    t2u             mt76x0          Ralink Technology, Corp.
MT7610U ("Archer T2U" 2.4G+5G WLAN Adapter
phy4    t2uh            mt76x0          Ralink Technology, Corp.
MT7610U ("Archer T2U" 2.4G+5G WLAN Adapter

Last thing I can think of, the tests were not conducted
simultaneously, meaning they didn't all start or fail at once.  I had
multiple successful connections with each one before they
independently failed.

Hope that helps.

Thanks,
Zero_Chaos

(apologies if you got this twice, original bounced from ML)

On Mon, Aug 27, 2018 at 2:58 PM Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>
> This is the begin work of integration between mt76x0 and mt76x2.
>
> Further development can be seen here:
> https://github.com/sgruszka/wireless-drivers-next/commits/mt76x0-draft-v2
>
> v1 -> v2:
> - rename mt76xx to mt76x02 to reflect that common code is for mt76x0
>   and mt76x2 only, not for new chips.
> - fixup 'stucture typo' in one patch
>
> Stanislaw Gruszka (17):
>   mt76: unify wait_for_mac
>   mt76: rename mt76x2_regs.h
>   mt76: merge mt76x0/regs.h into mt76x02_regs.h
>   mt76: create new mt76x02-lib module for common mt76x{0,2} code
>   mt76: fix mt76x02-lib module license
>   mt76: unify mac_get_key_info
>   mt76: add helpers for register access with mt76_dev struct
>   mt76: unify mac_shared_key_setup
>   mt76: unify mt76x02_mac_wcid_set_key
>   mt76: unify mac_wcid_setup
>   mt76: use mac_wcid_set_drop in mt76x0
>   mt76x0: use mt76_wcid_free in mt76x0
>   mt76: unify mt76x02_vif struct
>   mt76: unify sta structure part 1
>   mt76: unify sta structure part 2
>   mt76x0: initalize custom tx queues
>   mt76x0: use mt76x02_sta and mt76x02_tx_status
>
>  drivers/net/wireless/mediatek/mt76/Kconfig         |   6 +
>  drivers/net/wireless/mediatek/mt76/Makefile        |   3 +
>  drivers/net/wireless/mediatek/mt76/mac80211.c      |   1 +
>  drivers/net/wireless/mediatek/mt76/mt76.h          |  13 +
>  drivers/net/wireless/mediatek/mt76/mt76x0/init.c   |  37 +-
>  drivers/net/wireless/mediatek/mt76/mt76x0/mac.c    | 126 +---
>  drivers/net/wireless/mediatek/mt76/mt76x0/mac.h    |   8 +-
>  drivers/net/wireless/mediatek/mt76/mt76x0/main.c   | 127 ++--
>  drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c    |   4 +-
>  drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |  35 +-
>  drivers/net/wireless/mediatek/mt76/mt76x0/regs.h   | 651 --------------------
>  drivers/net/wireless/mediatek/mt76/mt76x0/trace.h  |   4 +-
>  drivers/net/wireless/mediatek/mt76/mt76x0/tx.c     |   8 +-
>  drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |   5 +-
>  drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   | 157 +++++
>  drivers/net/wireless/mediatek/mt76/mt76x02_mac.h   |  85 +++
>  drivers/net/wireless/mediatek/mt76/mt76x02_regs.h  | 685 +++++++++++++++++++++
>  drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |  55 ++
>  drivers/net/wireless/mediatek/mt76/mt76x02_util.h  |  25 +
>  drivers/net/wireless/mediatek/mt76/mt76x2.h        |  50 +-
>  drivers/net/wireless/mediatek/mt76/mt76x2_common.c |  99 +--
>  drivers/net/wireless/mediatek/mt76/mt76x2_init.c   |  15 +-
>  .../wireless/mediatek/mt76/mt76x2_init_common.c    |   4 +-
>  drivers/net/wireless/mediatek/mt76/mt76x2_mac.c    |   4 +-
>  drivers/net/wireless/mediatek/mt76/mt76x2_mac.h    |  21 +-
>  .../net/wireless/mediatek/mt76/mt76x2_mac_common.c | 130 +---
>  drivers/net/wireless/mediatek/mt76/mt76x2_main.c   |  47 +-
>  .../net/wireless/mediatek/mt76/mt76x2_phy_common.c |   4 +-
>  drivers/net/wireless/mediatek/mt76/mt76x2_regs.h   | 619 -------------------
>  drivers/net/wireless/mediatek/mt76/mt76x2_trace.h  |   2 +-
>  drivers/net/wireless/mediatek/mt76/mt76x2_tx.c     |   8 +-
>  .../net/wireless/mediatek/mt76/mt76x2_tx_common.c  |   8 +-
>  drivers/net/wireless/mediatek/mt76/mt76x2u_core.c  |   2 +-
>  drivers/net/wireless/mediatek/mt76/mt76x2u_init.c  |   8 +-
>  drivers/net/wireless/mediatek/mt76/mt76x2u_mac.c   |   2 +-
>  drivers/net/wireless/mediatek/mt76/mt76x2u_main.c  |  29 +-
>  36 files changed, 1226 insertions(+), 1861 deletions(-)
>  delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/regs.h
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_regs.h
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_util.c
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_util.h
>  delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_regs.h
>
> --
> 2.7.5
>
