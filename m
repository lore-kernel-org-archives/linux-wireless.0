Return-Path: <SRS0=wq86=OV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5075C65BAF
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 18:33:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5116D20851
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 18:33:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5116D20851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=atomide.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbeLLSdw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 12 Dec 2018 13:33:52 -0500
Received: from muru.com ([72.249.23.125]:57854 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727910AbeLLSdv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Dec 2018 13:33:51 -0500
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 73958809F;
        Wed, 12 Dec 2018 18:33:54 +0000 (UTC)
Date:   Wed, 12 Dec 2018 10:33:48 -0800
From:   Tony Lindgren <tony@atomide.com>
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     rsalveti@rsalveti.net, John Stultz <john.stultz@linaro.org>,
        linux-wireless@vger.kernel.org, Eyal Reizer <eyalr@ti.com>
Subject: Re: wlcore getting stuck on hikey after the runtime PM autosuspend
 support change
Message-ID: <20181212183348.GI39861@atomide.com>
References: <CAHYQr0pKurSS=nvLEaLzup1hgx4+RJ0CezA2nFeA=C4XBDQQog@mail.gmail.com>
 <20181211181944.GW39861@atomide.com>
 <CAHYQr0pk-WKM-aYR7ubM4GHx8PA82XP5ze9TW9WEJLzdO0f88A@mail.gmail.com>
 <20181211190128.GX39861@atomide.com>
 <CAHYQr0qc_Lav=1sEGcOmOykUftWRzd6+vis97eBpanEXzfUHaA@mail.gmail.com>
 <CALAqxLUVajBw_PkyhA0s=FhQQHWu1FBEMX+4oDTStRXr6L5Txw@mail.gmail.com>
 <20181211201221.GY39861@atomide.com>
 <CAHYQr0qffa_G2ZVnSsDfjqSgxuBBZB+8e6ZODpAWV_TMhqzFYg@mail.gmail.com>
 <CAHYQr0onAAMZ21YU59XOgNsVrZ-+33tUHfOa9aPr+hG2M0zb3g@mail.gmail.com>
 <CADYN=9KCQTecPHgDGU2iSF+q14Zjya1tGcn1suLWrm+6e_KSJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADYN=9KCQTecPHgDGU2iSF+q14Zjya1tGcn1suLWrm+6e_KSJw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

* Anders Roxell <anders.roxell@linaro.org> [181211 23:45]:
> I have different serious, one when our board hangs on udhcpc [1], then I see
> wlcore and wl18xx_driver.

Hmm so on what SoC is this with? Adding Eyeal to Cc here too.

Regards,

Tony

> [    8.824419] cfg80211: Loading compiled-in X.509 certificates for
> regulatory database
> [    8.852546] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
> [    8.861006] platform regulatory.0: Direct firmware load for
> regulatory.db failed with error -2
> [    8.870248] cfg80211: failed to load regulatory.db
> [    8.895501] asix 1-1.1:1.0 eth0: register 'asix' at
> usb-f72c0000.usb-1.1, ASIX AX88772B USB 2.0 Ethernet,
> 00:50:b6:14:c8:76
> [    8.912285] usbcore: registered new interface driver asix
> [    9.053373] mmc_host mmc2: Bus speed (slot 0) = 24800000Hz (slot
> req 100000Hz, actual 100000HZ div = 124)
> [    9.130886] mmc_host mmc2: Bus speed (slot 0) = 24800000Hz (slot
> req 25000000Hz, actual 24800000HZ div = 0)
> [    9.149318] wl18xx_driver wl18xx.3.auto: Direct firmware load for
> ti-connectivity/wl18xx-conf.bin failed with error -2
> [    9.160459] wlcore: ERROR could not get configuration binary
> ti-connectivity/wl18xx-conf.bin: -2
> [    9.169615] wlcore: WARNING falling back to default config
> [    9.214108] mmc_host mmc2: Bus speed (slot 0) = 24800000Hz (slot
> req 100000Hz, actual 100000HZ div = 124)
> [    9.294294] mmc_host mmc2: Bus speed (slot 0) = 24800000Hz (slot
> req 25000000Hz, actual 24800000HZ div = 0)
> [[0;32m  OK  [0m] Listening on Load/Save RF Kill Switch Status
> /dev/rfkill Watch.
> [[0;32m  OK  [0m] Reached target Sockets.
> [[0;32m  OK  [0m] Reached target Basic System.
>          Starting Entropy Daemon based on the HAVEGE algorithm...
> [[0;32m  OK  [0m] Started TEE Supplicant.
> [    9.514713] wlcore: wl18xx HW: 183x or 180x, PG 2.2 (ROM 0x11)
> [    9.526319] wlcore: WARNING Detected unconfigured mac address in
> nvs, derive from fuse instead.
> [    9.535454] wlcore: WARNING This default nvs file can be removed
> from the file system
> 
> and when it passes that stage I can't find wlcore nor wl18xx_driver.
> However, I can see
> wl1271_sdio failing instead. See [2]
> 
> [    8.435849] Bluetooth: HCI UART protocol Broadcom registered
> [    8.439669] mmc_host mmc2: Bus speed (slot 0) = 24800000Hz (slot
> req 200000Hz, actual 200000HZ div = 62)
> [[0;32m  OK  [0m] Started dnf-automatic-download timer.
> [    8.469492] wl1271_sdio: probe of mmc2:0001:2 failed with error -16
> [[0;32m  OK  [0m] Started Daily Cleanup of Temporary Directories.
> [[0;32m  OK  [0m] Started dnf-automatic-install timer.
> [    8.525443] Console: switching to colour frame buffer device 256x72
> [    8.533489] Bluetooth: hci0: change remote baud rate command in firmware
> [    8.584607] kirin-drm f4100000.ade: fb0: DRM emulated frame buffer device
> [[0;32m  OK  [0m] Started dnf-automatic-notifyonly timer.
> [[0;32m  OK  [0m] Listening on R[    8.614417] [drm] Initialized kirin
> 1.0.0 20150718 for f4100000.ade on minor 0
> 
> and another job that have the similar issue with the previous is [3]:
> 
> [    8.670110] adv7511 2-0039: 2-0039 supply pvdd not found, using
> dummy regulator
> [    8.677908] adv7511 2-0039: 2-0039 supply a2vdd not found, using
> dummy regulator
> [    8.685788] adv7511 2-0039: 2-0039 supply v3p3 not found, using
> dummy regulator
> [    8.688699] wl1271_sdio: probe of mmc2:0001:1 failed with error -16
> [    8.690154] Bluetooth: Core ver 2.22
> [    8.690346] NET: Registered protocol family 31
> [    8.690355] Bluetooth: HCI device and connection manager
> initialized
> [    8.693495] adv7511 2-0039: 2-0039 supply v1p2 not found, using
> dummy regulator
> [    8.700240] wl1271_sdio: probe of mmc2:0001:2 failed with error -16
> [    8.700992] Bluetooth: HCI socket layer initialized
> [    8.701022] Bluetooth: L2CAP socket layer initialized
> [    8.701554] Bluetooth: SCO socket layer initialized
>              Starting sshd.socket.
> [[0;32m  OK  [0m] Listening on RPCbind Server Activation Socket.
> [[0;32m  OK  [0m] Started Daily rotation of log files.
> [    8.791540] Bluetooth: HCI UART driver ver 2.3
> 
> 
> I'm confused why we only see wlcore wl18xx in job [1] and that we see wl1271
> in the other and that we are able to start running tests, even though
> I don't think
> the jobs where we run tests booted up OK, since we can see
> "wl1271_sdio: probe of mmc2:0001:1 failed with error -16".
> 
> Cheers,
> Anders
> 
> [1] https://lkft.validation.linaro.org/scheduler/job/543012
> [2] https://lkft.validation.linaro.org/scheduler/job/506683
> [3] https://lkft.validation.linaro.org/scheduler/job/487494
