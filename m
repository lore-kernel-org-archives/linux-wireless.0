Return-Path: <SRS0=Li3M=OI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40443C04EB9
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 22:56:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3AF620989
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 22:56:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=intellastar.com header.i=@intellastar.com header.b="Z1Ql6iAv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E3AF620989
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=intellastar.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbeK3KDj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 30 Nov 2018 05:03:39 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34405 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbeK3KDj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Nov 2018 05:03:39 -0500
Received: by mail-qt1-f196.google.com with SMTP id r14so3993965qtp.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 Nov 2018 14:56:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intellastar.com; s=google;
        h=from:to:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=I7J5CwpAiDm8MUHYtRgsXqIlcPFL5S8vOk4sutBZj3g=;
        b=Z1Ql6iAvXIVwY66a3dPKV28bSVtvRycH61P68P6rNmi1vkw2LJABxILfjgHVJeZHxA
         NjtBGT3hXxqH926MyMtWBPHMxjBdfNABjGwOfi2pX4pqXQMNioD5938iiSZJ9ste+bt0
         9vchj5ljdtWJiPpqHemIWOsHgFZuKUujTqKN+mZweXWr8MJZtB2UH2eq3O2CnxuOrhr3
         NE+58tlIbKGz1F0ieYunJFagfRaxCgI0PcJp5w2/LNBW/E1VeaCfplvzZP+pTgZw4NeB
         MzPKL4YlFHRsEsvDMoqsmq8EBX52tYpmdxYXJhvAKMvdYEZNWcDfqCqxB6PIfsCsulq8
         gjXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=I7J5CwpAiDm8MUHYtRgsXqIlcPFL5S8vOk4sutBZj3g=;
        b=cq8/xPVmLAgEqE/4u1plDMIFVuPXDW93EYcK6Lcv218OO7pQU6GQmNxZVfYr3oP7CZ
         /6CXRedPETLMBenDxjPiSRtxyF62VqK3IgNRQiOhgEvVxfJKq689H+aGUWHrnvgc5jy/
         ebTIV46bfyms3fxOTSCmxDSdKvKeSJqvLBn+Q3RtFQMRjIUS4dzg8d6IiyVRAu01RcaP
         WZJo2ZRAdO9pXZYK9GZ872+3bXTSEgstyqr4O2aFajOs+3MF3SNrphy3ELRkt24kHZWO
         CoAFg3CGUvFI3EW9SdK4pTO/0WapKDCI4Y6UOq265sxhYQNl7+bVZdrOUbDgNiHOryT5
         ubfw==
X-Gm-Message-State: AA+aEWaP7wB3S1bnsAOfj4zac9DCY0QngBDfJ5r+c9S4ByNcy5wUd1Q9
        Z8J76VQ1AZBqlobI1k3lEJ/8+6Rq4viYRKZBGfVM5FKPdLirLxHBho/AbwOtYV1u0gM05A61uy0
        VZjI6xR8OBPqFzMTIXnrLBguzEOnHrPQchOBurDx3NwDKSUsZ59TQbN+yJEBSf9szHIRubtVpTR
        3Njio=
X-Google-Smtp-Source: AFSGD/WyYRNKgkMcCOohmC4GD2j1RHDn75FUi6WKVsRJcnVQxQhbDXlwkjwyKs0fDa4kBKVI4i3YzQ==
X-Received: by 2002:aed:3eac:: with SMTP id n41mr3347427qtf.196.1543532192096;
        Thu, 29 Nov 2018 14:56:32 -0800 (PST)
Received: from [192.168.110.7] (cpe-67-241-170-88.buffalo.res.rr.com. [67.241.170.88])
        by smtp.gmail.com with ESMTPSA id 21sm3095429qkr.89.2018.11.29.14.56.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Nov 2018 14:56:31 -0800 (PST)
From:   Dietmar May <dmay@intellastar.com>
To:     stable@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: wlcore update breaks on 4.9 and 4.4 kernel branches
Message-ID: <43ee432a-c6ab-e23c-616c-b626a5fb4637@intellastar.com>
Date:   Thu, 29 Nov 2018 17:56:31 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

I've run into some problems which appear due to (a) recent patch(es) on=20
the wlcore wifi driver.

4.4.160 - commit 3fdd34643ffc378b5924941fad40352c04610294
4.9.131 - commit afeeecc764436f31d4447575bb9007732333818c

Earlier versions (4.9.130 and 4.4.159 - tested back to 4.4.49) do not=20
exhibit this problem. It is still present in 4.9.141.

master as of 4.20.0-rc4 does not exhibit this problem.

Basically, during client association when in AP mode (running hostapd),=20
handshake may or may not complete following a noticeable delay. If=20
successful, then the driver fails consistently in warn_slowpath_null=20
during disassociation. If unsuccessful, the wifi client attempts=20
multiple times, sometimes failing repeatedly. I've had clients unable to=20
connect for 3-5 minutes during testing, with the syslog filled with=20
dozens of backtraces. syslog details are below.

I'm working on an embedded device with a TI 3352 ARM processor and a=20
murata wl1271 module in sdio mode. We're running a fully patched ubuntu=20
18.04 ARM build, with a kernel built from kernel.org's stable/linux repo=20
<https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=
=3Dlinux-4.9.y&id=3Dafeeecc764436f31d4447575bb9007732333818c>.=20
Relevant parts of the kernel config are included below.

The commit message states:

> /I've only seen this few times with the runtime PM patches enabled so=20
> this one is probably not needed before that. This seems to work=20
> currently based on the current PM implementation timer. Let's apply=20
> this separately though in case others are hitting this issue./
We're not doing anything explicit with power management. The device is=20
an IoT edge gateway with battery backup, normally running on wall power.=20
The battery is currently used solely to shut down the system cleanly to=20
avoid filesystem corruption.

The device tree is configured to keep power in suspend; but the device=20
should never suspend, so in our case, there is no need to call=20
wl1271_ps_elp_wakeup() or wl1271_ps_elp_sleep(), as occurs in the patch.

&mmc2 {
 =C2=A0=C2=A0=C2=A0 status =3D "okay";
 =C2=A0=C2=A0=C2=A0 pinctrl-names =3D "default";
 =C2=A0=C2=A0=C2=A0 pinctrl-0 =3D <&wl1271_pins>;
 =C2=A0=C2=A0=C2=A0 vmmc-supply =3D <&vwifi>;
 =C2=A0=C2=A0=C2=A0 bus-width =3D <4>;
 =C2=A0=C2=A0=C2=A0 ti,non-removable;
/* am335x-evm.dts: ti,needs-special-hs-handling; - evm has wl18xx not=20
wl12xx */
 =C2=A0=C2=A0=C2=A0 cap-power-off-card;
 =C2=A0=C2=A0=C2=A0 keep-power-in-suspend;

 =C2=A0=C2=A0=C2=A0 #address-cells =3D <1>;
 =C2=A0=C2=A0=C2=A0 #size-cells =3D <0>;
 =C2=A0=C2=A0=C2=A0 wlcore: wlcore@2 {
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 compatible =3D "ti,wl1271";
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 reg =3D <2>;
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 interrupt-parent =3D <&gpio1>;
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 interrupts =3D <14 IRQ_TYPE_LEV=
EL_HIGH>; /* gpio1[14] */
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ref-clock-frequency =3D <384000=
00>;
 =C2=A0=C2=A0=C2=A0 };
};

At this point, we're unable to ship a kernel version later than 4.9.130;=20
so it's important to us to get this issue resolved.

The simplest thing for us would be if these changes could be reverted;=20
but I'd be happy to debug or try some things out.

Thanks,

Dietmar May
Software Architect
Intellastar LLC

_Association_

Nov 16 15:25:52 ice hostapd: wlan0: STA 84:3a:4b:00:8d:04 IEEE 802.11:=20
authenticated
Nov 16 15:25:52 ice hostapd: wlan0: STA 84:3a:4b:00:8d:04 IEEE 802.11:=20
associated (aid 1)
Nov 16 15:25:52 ice hostapd: wlan0: STA 84:3a:4b:00:8d:04 RADIUS:=20
starting accounting session 5BEEE158-00000000
Nov 16 15:25:52 ice hostapd: wlan0: STA 84:3a:4b:00:8d:04 WPA: pairwise=20
key handshake completed (RSN)

_Disassociation_

Nov 16 15:26:05 ice kernel: ------------[ cut here ]------------
Nov 16 15:26:05 ice kernel: WARNING: CPU: 0 PID: 1067 at=20
drivers/net/wireless/ti/wlcore/ps.c:91 wl12xx_op_sta_state+0x208/0x56c=20
[wlcore]
Nov 16 15:26:05 ice kernel: Modules linked in: bridge stp llc cdc_ncm=20
usbnet mii cdc_acm usb_serial_simple usbserial bnep hci_uart bluetooth=20
xt_conntrack iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4=20
nf_nat nf_conntrack arc4 wl12xx wlcore mac80211 cfg80211 musb_dsps=20
musb_hdrc usbcore phy_am335x cppi41 phy_am335x_control phy_generic=20
usb_common ti_am335x_adc kfifo_buf industrialio wlcore_sdio omap_rng=20
rng_core musb_am335x rtc_omap omap_wdt ti_am335x_tscadc cpufreq_dt=20
leds_gpio led_class thermal_sys hwmon autofs4
Nov 16 15:26:05 ice kernel: CPU: 0 PID: 1067 Comm: hostapd Not tainted=20
4.9.131-ice245 #1
Nov 16 15:26:05 ice kernel: Hardware name: Generic AM33XX (Flattened=20
Device Tree)
Nov 16 15:26:05 ice kernel: [<c010d2e0>] (unwind_backtrace) from=20
[<c010b50c>] (show_stack+0x10/0x14)
Nov 16 15:26:05 ice kernel: [<c010b50c>] (show_stack) from [<c012e3ac>]=20
(__warn+0xd8/0x100)
Nov 16 15:26:05 ice kernel: [<c012e3ac>] (__warn) from [<c012e480>]=20
(warn_slowpath_null+0x20/0x28)
Nov 16 15:26:05 ice kernel: [<c012e480>] (warn_slowpath_null) from=20
[<bf2e521c>] (wl12xx_op_sta_state+0x208/0x56c [wlcore])
Nov 16 15:26:05 ice kernel: [<bf2e521c>] (wl12xx_op_sta_state [wlcore])=20
from [<bf20dbf8>] (drv_sta_state+0x84/0x6c8 [mac80211])
Nov 16 15:26:05 ice kernel: [<bf20dbf8>] (drv_sta_state [mac80211]) from=20
[<bf215284>] (__sta_info_destroy_part2+0x160/0x1b4 [mac80211])
Nov 16 15:26:05 ice kernel: [<bf215284>] (__sta_info_destroy_part2=20
[mac80211]) from [<bf2152f8>] (__sta_info_destroy+0x20/0x28 [mac80211])
Nov 16 15:26:05 ice kernel: [<bf2152f8>] (__sta_info_destroy [mac80211])=20
from [<bf21537c>] (sta_info_destroy_addr_bss+0x30/0x4c [mac80211])
Nov 16 15:26:05 ice kernel: [<bf21537c>] (sta_info_destroy_addr_bss=20
[mac80211]) from [<bf171c70>] (nl80211_del_station+0xe8/0x2b8 [cfg80211])
Nov 16 15:26:05 ice kernel: [<bf171c70>] (nl80211_del_station=20
[cfg80211]) from [<c05535c4>] (genl_rcv_msg+0x308/0x3e4)
Nov 16 15:26:05 ice kernel: [<c05535c4>] (genl_rcv_msg) from=20
[<c05527a0>] (netlink_rcv_skb+0xa4/0xe8)
Nov 16 15:26:05 ice kernel: [<c05527a0>] (netlink_rcv_skb) from=20
[<c05532a8>] (genl_rcv+0x20/0x34)
Nov 16 15:26:05 ice kernel: [<c05532a8>] (genl_rcv) from [<c0552100>]=20
(netlink_unicast+0x168/0x1f4)
Nov 16 15:26:05 ice kernel: [<c0552100>] (netlink_unicast) from=20
[<c0552540>] (netlink_sendmsg+0x2e8/0x378)
Nov 16 15:26:05 ice kernel: [<c0552540>] (netlink_sendmsg) from=20
[<c050396c>] (sock_sendmsg+0x14/0x24)
Nov 16 15:26:05 ice kernel: [<c050396c>] (sock_sendmsg) from=20
[<c05041f8>] (___sys_sendmsg+0x1ec/0x200)
Nov 16 15:26:05 ice kernel: [<c05041f8>] (___sys_sendmsg) from=20
[<c0504fa0>] (__sys_sendmsg+0x40/0x6c)
Nov 16 15:26:05 ice kernel: [<c0504fa0>] (__sys_sendmsg) from=20
[<c0107560>] (ret_fast_syscall+0x0/0x1c)
Nov 16 15:26:05 ice kernel: ---[ end trace 44f73265865f31c4 ]---

CONFIG_FW_LOADER=3Dy
CONFIG_FIRMWARE_IN_KERNEL=3Dy
CONFIG_EXTRA_FIRMWARE=3D"am335x-pm-firmware.elf"
CONFIG_AM335X_PHY_USB=3Dm
CONFIG_ARCH_MULTI_V6=3Dy
CONFIG_ARCH_OMAP2PLUS=3Dy
CONFIG_ARCH_OMAP2=3Dy
CONFIG_ARCH_OMAP3=3Dy
CONFIG_ARCH_OMAP=3Dy
CONFIG_ARM_APPENDED_DTB=3Dy
CONFIG_ARM_ATAG_DTB_COMPAT=3Dy
CONFIG_ARM_CRYPTO=3Dy
CONFIG_ARM_ERRATA_411920=3Dy
CONFIG_ARM_ERRATA_430973=3Dy
CONFIG_ARM_THUMBEE=3Dy
CONFIG_CFG80211=3Dm
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=3Dy
CONFIG_CPUFREQ_DT=3Dm
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=3Dy
CONFIG_CPU_FREQ_GOV_POWERSAVE=3Dy
CONFIG_CPU_FREQ_GOV_USERSPACE=3Dy
CONFIG_CPU_FREQ_STAT_DETAILS=3Dy
CONFIG_CPU_FREQ=3Dy
CONFIG_CPU_IDLE=3Dy
CONFIG_CPUSETS=3Dy
CONFIG_CPU_THERMAL=3Dy
CONFIG_DMA_CMA=3Dy
CONFIG_DMADEVICES=3Dy
CONFIG_DMA_OMAP=3DyCONFIG_MAC80211=3Dm
CONFIG_MMC_OMAP_HS=3Dy
CONFIG_MMC_OMAP=3Dy
CONFIG_MMC=3Dy
CONFIG_OMAP3_THERMAL=3Dy
CONFIG_OMAP_IOMMU=3Dy
CONFIG_OMAP_MUX_DEBUG=3Dn
CONFIG_OMAP_OCP2SCP=3Dy
CONFIG_OMAP_RESET_CLOCKS=3Dy
CONFIG_OMAP_SSI=3Dm
CONFIG_OMAP_USB2=3Dm
CONFIG_OMAP_WATCHDOG=3Dm
CONFIG_POWER_AVS_OMAP_CLASS3=3Dy
CONFIG_POWER_AVS_OMAP=3Dy
CONFIG_POWER_AVS=3Dy
CONFIG_POWER_RESET=3Dy
CONFIG_SLUB=3Dy
CONFIG_SOC_AM33XX=3Dy
CONFIG_SOC_TI=3Dy
CONFIG_THERMAL_GOV_FAIR_SHARE=3Dy
CONFIG_THERMAL_GOV_USER_SPACE=3Dy
CONFIG_THERMAL=3Dm
CONFIG_TI_AM335X_ADC=3Dm
CONFIG_TI_CPSW=3Dy
CONFIG_TI_CPTS=3Dy
CONFIG_TI_DAVINCI_EMAC=3Dy
CONFIG_TI_EDMA=3Dy
CONFIG_TI_EMIF=3Dm
CONFIG_TIMER_STATS=3Dy
CONFIG_TI_PIPE3=3Dy
CONFIG_TI_SOC_THERMAL=3Dm
CONFIG_TI_THERMAL=3Dy
CONFIG_WIRELESS=3Dy
CONFIG_WL12XX=3Dm
CONFIG_WL18XX=3Dm
CONFIG_WLAN=3Dy
CONFIG_WLCORE_SDIO=3Dm
CONFIG_WLCORE_SPI=3Dm
CONFIG_WL_TI=3Dy



--=20
This email and any information disclosed in connection herewith, whether=20
written or oral, is the property of Intellastar LLC, and is intended only=
=20
for the person or entity to which it is addressed. This email may contain=
=20
information that is privileged confidential or otherwise protected from=20
disclosure. Distributing or copying any information contained in this email=
=20
to anyone other than the intended recipient is strictly prohibited.=C2=A0
