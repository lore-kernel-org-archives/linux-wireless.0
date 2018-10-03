Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6286CC64EB8
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 16:15:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14F642082A
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 16:15:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WdhJN4uu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 14F642082A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbeJCXEr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 19:04:47 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:46538 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726834AbeJCXEr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 19:04:47 -0400
Received: by mail-io1-f66.google.com with SMTP id t7-v6so5470101ioj.13
        for <linux-wireless@vger.kernel.org>; Wed, 03 Oct 2018 09:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nb52tLxCIGQxA/c/0Pm/GlEH++W70ep5AqDu08R938Y=;
        b=WdhJN4uut9UgqCMz7Z/FBDz+WF+iK4Lvvz5ZYzX80yf8fETNgMFmkmjPfepmLb3+r9
         AXIZzui9zLYSWzgsYN6IieGcCc9rchligVw25jxZNDZUGhTDPzluw73zctux00NAuuo6
         ki98lOtuWVC/npmn6aZSjCEalcJdAoPLuE4tQmQRw9aq8YcRmf2NZaKVnNmgULRYfZzV
         3c+6NGO/8lwmuyV436sNPJkU4mwK3SqJowUrgsFV4otM1AhhUtK3jdxcKEZ125CXKpnm
         SpBBpkzHVUQ+zS5yom1BgJY04w0sw6GDcpI2uuBb6HSqCAdCnFZU0FCf1QpcspAcwOy8
         p1bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nb52tLxCIGQxA/c/0Pm/GlEH++W70ep5AqDu08R938Y=;
        b=jfrCwKUkJizXHN/jptwLFLcBGHuTa1S5+hgK8uxHwyu58DvQ7KpNiuglSCiN0Akhhd
         RO4U3cBCAhgEQjljiruwLgtwNe1Wl/XW5m93ZdAX+Lgb0u/wkZj/i3yYIPfslEKjSq2s
         qUtXtMFXrO4teRVKX10EatNPip7AeDVYG9JzUODhoXPCI30ytOTj4F5q7KpODKDsJHzj
         htXwgDzmGSUig5TtRRV2i0HlovBIsVDiNzo05MISwwfgnYZPLcWOGcietLzuGVxJc+un
         jAyvSKhuT2JVYro0/5+fCAlDIzdAlaFPvZt9WQtX6k5uLf62UGT3lyIhG3GsSACxBgI9
         Z7uw==
X-Gm-Message-State: ABuFfogHMKAXgVzNjgfLQD4gSVD1Md+rtp5JHDy7H/9ex+6hBLnZ6K2Z
        x7tlUoZX9Wh3DjlbKBpXvLzWoNVwSBy1YZ1mVLA=
X-Google-Smtp-Source: ACcGV60L1809efRTNoFAyAUlexIB/dkxqaqK2I+0qblXEMB8YRf9im6680GNucZCkKN6EHMvu3XsWuOWhyrUZkZedeE=
X-Received: by 2002:a6b:8e8f:: with SMTP id q137-v6mr1599874iod.174.1538583342952;
 Wed, 03 Oct 2018 09:15:42 -0700 (PDT)
MIME-Version: 1.0
References: <1538553748-26364-1-git-send-email-yhchuang@realtek.com>
In-Reply-To: <1538553748-26364-1-git-send-email-yhchuang@realtek.com>
From:   Sid Hayn <sidhayn@gmail.com>
Date:   Wed, 3 Oct 2018 12:15:35 -0400
Message-ID: <CAM0KTbAkm+crgK98kus7N7fCZFA5w9aRJ=Fam+Qe5cv_t9x=DA@mail.gmail.com>
Subject: Re: [RFC v2 00/12] rtw88: mac80211 driver for Realtek 802.11ac
 wireless network chips
To:     yhchuang@realtek.com
Cc:     Kalle Valo <kvalo@codeaurora.org>, Larry.Finger@lwfinger.net,
        pkshih@realtek.com, tehuang@realtek.com, sgruszka@redhat.com,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Is there a public repository where I can track development for this driver?

Thanks,
Zero
On Wed, Oct 3, 2018 at 4:04 AM <yhchuang@realtek.com> wrote:
>
> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
>
> This is a new mac80211 driver for Realtek 802.11ac wireless network chips.
> rtwlan supports 8822BE and 8822CE chips, and will be able to support
> multi-vif combinations in run-time.
>
> For now, only PCI bus is supported, but rtwlan was originally designed
> to optionally support three buses includes USB & SDIO. USB & SDIO modules
> will soon be supported by rtwlan, with configurable core module to fit
> with different bus modules in the same time.
>
> For example, if we choose 8822BE and 8822CU, only PCI & USB modules will
> be selected, built, loaded into kernel. This is one of the major
> difference from rtlwifi, which can only support specific combinations.
>
> Another difference from rtlwifi is that rtwlan is designed to support
> the latest Realtek 802.11ac wireless network chips like 8822B and
> 8822C series. Compared to the earlier chips supported by rtlwifi like
> the 802.11n 8192EE chipset or 802.11ac 8821AE/8812AE chips, newer ICs
> have different MAC & PHY settings, such as new multi-port feature for the
> MAC layer design and Jaguar2/Jaguar3 PHY layer IPs.
>
> Multi-Port feature is also supported under rtwlan's software architecture.
> rtlwifi can only support one vif in the same time, most because of the
> hardware limitations for early chips, hence the original design of it
> also restricts the usage of multi-vif support, so latest chipset seems not
> take advantages from its new MAC engine.
>
> However, rtwlan can run multiple vifs concurrently by holding them on
> hardware ports provided by MAC engine, hence can easily start different
> roles on a single device.
>
> Based on the reasons mentioned before, we implemented rtwlan. It had many
> authors, they are listed here alphabetically:
>
> Ping-Ke Shih <pkshih@realtek.com>
> Tzu-En Huang <tehuang@realtek.com>
> Yan-Hsuan Chuang <yhchuang@realtek.com>
>
>
> v2
>
>  - rename from rtwlan to rtw88
>  - remove lots of magic numbers
>  - add pci null entry for auto load on boot
>  - add rtwdev->mutex to protect against mac80211 callbacks
>  - add rcu lock protection for vif_list and sta_list
>  - refine bits & endian macros to use helper functions provided by kernel
>    instead of create new ones
>  - ieee80211_free_txskb for tx path dropped packets
>  - not register iface_combination since now only one vif is allowed
>  - some fixes suggested by Stanislaw
>
>
> Yan-Hsuan Chuang (12):
>   rtw88: main files
>   rtw88: core files
>   rtw88: hci files
>   rtw88: trx files
>   rtw88: mac files
>   rtw88: fw and efuse files
>   rtw88: phy files
>   rtw88: debug files
>   rtw88: chip files
>   rtw88: 8822B init table
>   rtw88: 8822C init table
>   rtw88: Kconfig & Makefile
>
>  drivers/net/wireless/realtek/Kconfig               |     1 +
>  drivers/net/wireless/realtek/Makefile              |     1 +
>  drivers/net/wireless/realtek/rtw88/Kconfig         |    57 +
>  drivers/net/wireless/realtek/rtw88/Makefile        |    19 +
>  drivers/net/wireless/realtek/rtw88/debug.c         |   652 +
>  drivers/net/wireless/realtek/rtw88/debug.h         |    45 +
>  drivers/net/wireless/realtek/rtw88/efuse.c         |   150 +
>  drivers/net/wireless/realtek/rtw88/efuse.h         |    53 +
>  drivers/net/wireless/realtek/rtw88/fw.c            |   638 +
>  drivers/net/wireless/realtek/rtw88/fw.h            |   182 +
>  drivers/net/wireless/realtek/rtw88/hci.h           |   212 +
>  drivers/net/wireless/realtek/rtw88/mac.c           |  1045 +
>  drivers/net/wireless/realtek/rtw88/mac.h           |    35 +
>  drivers/net/wireless/realtek/rtw88/mac80211.c      |   482 +
>  drivers/net/wireless/realtek/rtw88/main.c          |  1133 +
>  drivers/net/wireless/realtek/rtw88/main.h          |  1200 ++
>  drivers/net/wireless/realtek/rtw88/pci.c           |  1220 ++
>  drivers/net/wireless/realtek/rtw88/pci.h           |   228 +
>  drivers/net/wireless/realtek/rtw88/phy.c           |  1675 ++
>  drivers/net/wireless/realtek/rtw88/phy.h           |   125 +
>  drivers/net/wireless/realtek/rtw88/ps.c            |   198 +
>  drivers/net/wireless/realtek/rtw88/ps.h            |    21 +
>  drivers/net/wireless/realtek/rtw88/reg.h           |   404 +
>  drivers/net/wireless/realtek/rtw88/regd.c          |   462 +
>  drivers/net/wireless/realtek/rtw88/regd.h          |    40 +
>  drivers/net/wireless/realtek/rtw88/rtw8822b.c      |  1593 ++
>  drivers/net/wireless/realtek/rtw88/rtw8822b.h      |   271 +
>  .../net/wireless/realtek/rtw88/rtw8822b_table.c    | 20783 +++++++++++++++++++
>  .../net/wireless/realtek/rtw88/rtw8822b_table.h    |    18 +
>  drivers/net/wireless/realtek/rtw88/rtw8822c.c      |  1170 ++
>  drivers/net/wireless/realtek/rtw88/rtw8822c.h      |   416 +
>  .../net/wireless/realtek/rtw88/rtw8822c_table.c    |  4150 ++++
>  .../net/wireless/realtek/rtw88/rtw8822c_table.h    |    16 +
>  drivers/net/wireless/realtek/rtw88/rx.c            |   144 +
>  drivers/net/wireless/realtek/rtw88/rx.h            |    30 +
>  drivers/net/wireless/realtek/rtw88/sec.c           |   135 +
>  drivers/net/wireless/realtek/rtw88/sec.h           |    40 +
>  drivers/net/wireless/realtek/rtw88/tx.c            |   271 +
>  drivers/net/wireless/realtek/rtw88/tx.h            |    81 +
>  39 files changed, 39396 insertions(+)
>  create mode 100644 drivers/net/wireless/realtek/rtw88/Kconfig
>  create mode 100644 drivers/net/wireless/realtek/rtw88/Makefile
>  create mode 100644 drivers/net/wireless/realtek/rtw88/debug.c
>  create mode 100644 drivers/net/wireless/realtek/rtw88/debug.h
>  create mode 100644 drivers/net/wireless/realtek/rtw88/efuse.c
>  create mode 100644 drivers/net/wireless/realtek/rtw88/efuse.h
>  create mode 100644 drivers/net/wireless/realtek/rtw88/fw.c
>  create mode 100644 drivers/net/wireless/realtek/rtw88/fw.h
>  create mode 100644 drivers/net/wireless/realtek/rtw88/hci.h
>  create mode 100644 drivers/net/wireless/realtek/rtw88/mac.c
>  create mode 100644 drivers/net/wireless/realtek/rtw88/mac.h
>  create mode 100644 drivers/net/wireless/realtek/rtw88/mac80211.c
>  create mode 100644 drivers/net/wireless/realtek/rtw88/main.c
>  create mode 100644 drivers/net/wireless/realtek/rtw88/main.h
>  create mode 100644 drivers/net/wireless/realtek/rtw88/pci.c
>  create mode 100644 drivers/net/wireless/realtek/rtw88/pci.h
>  create mode 100644 drivers/net/wireless/realtek/rtw88/phy.c
>  create mode 100644 drivers/net/wireless/realtek/rtw88/phy.h
>  create mode 100644 drivers/net/wireless/realtek/rtw88/ps.c
>  create mode 100644 drivers/net/wireless/realtek/rtw88/ps.h
>  create mode 100644 drivers/net/wireless/realtek/rtw88/reg.h
>  create mode 100644 drivers/net/wireless/realtek/rtw88/regd.c
>  create mode 100644 drivers/net/wireless/realtek/rtw88/regd.h
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822b.c
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822b.h
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822b_table.c
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822b_table.h
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822c.c
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822c.h
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822c_table.c
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822c_table.h
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rx.c
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rx.h
>  create mode 100644 drivers/net/wireless/realtek/rtw88/sec.c
>  create mode 100644 drivers/net/wireless/realtek/rtw88/sec.h
>  create mode 100644 drivers/net/wireless/realtek/rtw88/tx.c
>  create mode 100644 drivers/net/wireless/realtek/rtw88/tx.h
>
> --
> 2.7.4
>
