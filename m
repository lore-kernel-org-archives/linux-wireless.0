Return-Path: <SRS0=RnVe=O2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EBA4C43387
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Dec 2018 09:36:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3552206A2
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Dec 2018 09:36:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="Bl7nNbiV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732023AbeLQJgh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 17 Dec 2018 04:36:37 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:39970 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbeLQJgg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Dec 2018 04:36:36 -0500
Received: by mail-yb1-f193.google.com with SMTP id a10so1419513ybl.7
        for <linux-wireless@vger.kernel.org>; Mon, 17 Dec 2018 01:36:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZA2tRXoMcwkwtM8zhBr+Pfoh6I6fsNdqp8HJpBxY0Sk=;
        b=Bl7nNbiVFLxOTEx+XBq/cZKWW7AhZyE+yp9Hz8xkiFVClvyCIZ4SyE4kaQlF6ysC6W
         csNd4nK50Q2KJpzM3h7LYzTWXCOqAhok7Z7UmvP1jSVge5mJ/LimKX6X75AXlWz8iMho
         90WNC8dznYfc/ZPRO7WUntCqAbbIZiME+GDf8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZA2tRXoMcwkwtM8zhBr+Pfoh6I6fsNdqp8HJpBxY0Sk=;
        b=kR/5qVFbAT0ZjOkshX/lQMdgDlEXsc7UaPkElIOez+eo8h9lMpfkAMWpDeVJSt1YYt
         LRIy103YKncGwGtRjmFq5se3v7AFPyB8QOHUDZVJuMSOX7A65nMTvUojQA6sCnuekyiI
         2Uca9EM2/NCSSILoJ0SJaipdssYa/H9c93RHYIakEv/Zu3w0Nq149iziOBrYiBO5YPAc
         xJaK8alps9DADIj/7KzDy5isfZJVhe9/jcgAdjkX+JaLxQPeEQQqz9146FCcdnamIDDE
         HjORlRPuDCwW82HDj6k7kBiOKiV5EjyNYGjJ8em5NL3PQZXgbOjiVsVoGW08UBEcQMiS
         avuA==
X-Gm-Message-State: AA+aEWbPbKWq87DYOeSwpSTAQnvS0KiLW/+sLWqbaMC7Uz5a+CQBeKdj
        ooIfslZg/Hxe6N+2xq0xPxYScXibw0KpAu4Znb4dWA==
X-Google-Smtp-Source: AFSGD/XLYeYxAWKCff2V2KVhm3z9eS+flZPq7V3b6P1DZrw0W5EBiHGAqIQTqmKkqUIXCABwQWdC1wAG7oq/z2JyvCM=
X-Received: by 2002:a25:d6d3:: with SMTP id n202mr12412343ybg.257.1545039395008;
 Mon, 17 Dec 2018 01:36:35 -0800 (PST)
MIME-Version: 1.0
References: <CAHYQr0pKurSS=nvLEaLzup1hgx4+RJ0CezA2nFeA=C4XBDQQog@mail.gmail.com>
 <20181211181944.GW39861@atomide.com> <CAHYQr0pk-WKM-aYR7ubM4GHx8PA82XP5ze9TW9WEJLzdO0f88A@mail.gmail.com>
 <20181211190128.GX39861@atomide.com> <CAHYQr0qc_Lav=1sEGcOmOykUftWRzd6+vis97eBpanEXzfUHaA@mail.gmail.com>
 <CALAqxLUVajBw_PkyhA0s=FhQQHWu1FBEMX+4oDTStRXr6L5Txw@mail.gmail.com>
 <20181211201221.GY39861@atomide.com> <CAHYQr0qffa_G2ZVnSsDfjqSgxuBBZB+8e6ZODpAWV_TMhqzFYg@mail.gmail.com>
 <CAHYQr0onAAMZ21YU59XOgNsVrZ-+33tUHfOa9aPr+hG2M0zb3g@mail.gmail.com>
 <CADYN=9KCQTecPHgDGU2iSF+q14Zjya1tGcn1suLWrm+6e_KSJw@mail.gmail.com> <20181212183348.GI39861@atomide.com>
In-Reply-To: <20181212183348.GI39861@atomide.com>
From:   Anders Roxell <anders.roxell@linaro.org>
Date:   Mon, 17 Dec 2018 10:36:24 +0100
Message-ID: <CADYN=9JEpTj444+SD_0fmBzK1DjRgSK-1S0ujeUyxXpuq6rLMA@mail.gmail.com>
Subject: Re: wlcore getting stuck on hikey after the runtime PM autosuspend
 support change
To:     Tony Lindgren <tony@atomide.com>
Cc:     rsalveti@rsalveti.net, John Stultz <john.stultz@linaro.org>,
        linux-wireless@vger.kernel.org, Eyal Reizer <eyalr@ti.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 12 Dec 2018 at 19:33, Tony Lindgren <tony@atomide.com> wrote:
>
> * Anders Roxell <anders.roxell@linaro.org> [181211 23:45]:
> > I have different serious, one when our board hangs on udhcpc [1], then I see
> > wlcore and wl18xx_driver.
>
> Hmm so on what SoC is this with?

I'm sorry for the late reply. The Soc is Kirin 620.

Cheers,
Anders

> Adding Eyeal to Cc here too.
>
> Regards,
>
> Tony
>
> > [    8.824419] cfg80211: Loading compiled-in X.509 certificates for
> > regulatory database
> > [    8.852546] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
> > [    8.861006] platform regulatory.0: Direct firmware load for
> > regulatory.db failed with error -2
> > [    8.870248] cfg80211: failed to load regulatory.db
> > [    8.895501] asix 1-1.1:1.0 eth0: register 'asix' at
> > usb-f72c0000.usb-1.1, ASIX AX88772B USB 2.0 Ethernet,
> > 00:50:b6:14:c8:76
> > [    8.912285] usbcore: registered new interface driver asix
> > [    9.053373] mmc_host mmc2: Bus speed (slot 0) = 24800000Hz (slot
> > req 100000Hz, actual 100000HZ div = 124)
> > [    9.130886] mmc_host mmc2: Bus speed (slot 0) = 24800000Hz (slot
> > req 25000000Hz, actual 24800000HZ div = 0)
> > [    9.149318] wl18xx_driver wl18xx.3.auto: Direct firmware load for
> > ti-connectivity/wl18xx-conf.bin failed with error -2
> > [    9.160459] wlcore: ERROR could not get configuration binary
> > ti-connectivity/wl18xx-conf.bin: -2
> > [    9.169615] wlcore: WARNING falling back to default config
> > [    9.214108] mmc_host mmc2: Bus speed (slot 0) = 24800000Hz (slot
> > req 100000Hz, actual 100000HZ div = 124)
> > [    9.294294] mmc_host mmc2: Bus speed (slot 0) = 24800000Hz (slot
> > req 25000000Hz, actual 24800000HZ div = 0)
> > [[0;32m  OK  [0m] Listening on Load/Save RF Kill Switch Status
> > /dev/rfkill Watch.
> > [[0;32m  OK  [0m] Reached target Sockets.
> > [[0;32m  OK  [0m] Reached target Basic System.
> >          Starting Entropy Daemon based on the HAVEGE algorithm...
> > [[0;32m  OK  [0m] Started TEE Supplicant.
> > [    9.514713] wlcore: wl18xx HW: 183x or 180x, PG 2.2 (ROM 0x11)
> > [    9.526319] wlcore: WARNING Detected unconfigured mac address in
> > nvs, derive from fuse instead.
> > [    9.535454] wlcore: WARNING This default nvs file can be removed
> > from the file system
> >
> > and when it passes that stage I can't find wlcore nor wl18xx_driver.
> > However, I can see
> > wl1271_sdio failing instead. See [2]
> >
> > [    8.435849] Bluetooth: HCI UART protocol Broadcom registered
> > [    8.439669] mmc_host mmc2: Bus speed (slot 0) = 24800000Hz (slot
> > req 200000Hz, actual 200000HZ div = 62)
> > [[0;32m  OK  [0m] Started dnf-automatic-download timer.
> > [    8.469492] wl1271_sdio: probe of mmc2:0001:2 failed with error -16
> > [[0;32m  OK  [0m] Started Daily Cleanup of Temporary Directories.
> > [[0;32m  OK  [0m] Started dnf-automatic-install timer.
> > [    8.525443] Console: switching to colour frame buffer device 256x72
> > [    8.533489] Bluetooth: hci0: change remote baud rate command in firmware
> > [    8.584607] kirin-drm f4100000.ade: fb0: DRM emulated frame buffer device
> > [[0;32m  OK  [0m] Started dnf-automatic-notifyonly timer.
> > [[0;32m  OK  [0m] Listening on R[    8.614417] [drm] Initialized kirin
> > 1.0.0 20150718 for f4100000.ade on minor 0
> >
> > and another job that have the similar issue with the previous is [3]:
> >
> > [    8.670110] adv7511 2-0039: 2-0039 supply pvdd not found, using
> > dummy regulator
> > [    8.677908] adv7511 2-0039: 2-0039 supply a2vdd not found, using
> > dummy regulator
> > [    8.685788] adv7511 2-0039: 2-0039 supply v3p3 not found, using
> > dummy regulator
> > [    8.688699] wl1271_sdio: probe of mmc2:0001:1 failed with error -16
> > [    8.690154] Bluetooth: Core ver 2.22
> > [    8.690346] NET: Registered protocol family 31
> > [    8.690355] Bluetooth: HCI device and connection manager
> > initialized
> > [    8.693495] adv7511 2-0039: 2-0039 supply v1p2 not found, using
> > dummy regulator
> > [    8.700240] wl1271_sdio: probe of mmc2:0001:2 failed with error -16
> > [    8.700992] Bluetooth: HCI socket layer initialized
> > [    8.701022] Bluetooth: L2CAP socket layer initialized
> > [    8.701554] Bluetooth: SCO socket layer initialized
> >              Starting sshd.socket.
> > [[0;32m  OK  [0m] Listening on RPCbind Server Activation Socket.
> > [[0;32m  OK  [0m] Started Daily rotation of log files.
> > [    8.791540] Bluetooth: HCI UART driver ver 2.3
> >
> >
> > I'm confused why we only see wlcore wl18xx in job [1] and that we see wl1271
> > in the other and that we are able to start running tests, even though
> > I don't think
> > the jobs where we run tests booted up OK, since we can see
> > "wl1271_sdio: probe of mmc2:0001:1 failed with error -16".
> >
> > Cheers,
> > Anders
> >
> > [1] https://lkft.validation.linaro.org/scheduler/job/543012
> > [2] https://lkft.validation.linaro.org/scheduler/job/506683
> > [3] https://lkft.validation.linaro.org/scheduler/job/487494
