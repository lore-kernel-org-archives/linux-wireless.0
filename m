Return-Path: <SRS0=hThr=N5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D78DDC43441
	for <linux-wireless@archiver.kernel.org>; Sun, 18 Nov 2018 17:08:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 851672075B
	for <linux-wireless@archiver.kernel.org>; Sun, 18 Nov 2018 17:08:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="OMfIJuEa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 851672075B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=posteo.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbeKSD3C (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 18 Nov 2018 22:29:02 -0500
Received: from mout02.posteo.de ([185.67.36.66]:42927 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726523AbeKSD3C (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Nov 2018 22:29:02 -0500
Received: from submission (posteo.de [89.146.220.130]) 
        by mout02.posteo.de (Postfix) with ESMTPS id 97D1E2400FB
        for <linux-wireless@vger.kernel.org>; Sun, 18 Nov 2018 18:08:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
        t=1542560890; bh=S2aurrse0btF38PPH+ta08neYShzVRXZbMwsxW6f2eI=;
        h=From:Subject:To:Openpgp:Autocrypt:Date:From;
        b=OMfIJuEaK1ZIyecyRzu0wgHakx78tEdKPTwJnQdM3mvZBz59mjQZHh2j9DUTPS7dU
         l5ZBV6Btq735o0FOsqGFy7y2HvnPjfZMcr0+lgnNR9dDax7xPjhy7rstJgIzxnAic5
         skP1liAXRgOq5pZNADv9k6KOGFtg02akA5y9WhsSBFgP2wAPmDX1MraURzjlenqz/G
         lkfOcAmfngvDO19YOPzq4bcVp1pVhixbT+GQDk/uo6fdsofo5MYaBLy/4UJZoplZKF
         AR1/xNi2KbRJkDu7kdQ3kJPCZokDSWgFNtAKcquI/9ugbdbES3exjLaqAK6ZbUXmLg
         8xDz9KC8cg8nA==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 42ydhT6BTHz9rxP
        for <linux-wireless@vger.kernel.org>; Sun, 18 Nov 2018 18:08:09 +0100 (CET)
From:   Vedran <1vf@posteo.net>
Subject: Firmware crash with ath10k (QCA6174 hw2.1)
X-Mozilla-News-Host: news://news://news.gmane.org:119
Reply-To: 1vf@posteo.net
To:     linux-wireless@vger.kernel.org
Openpgp: preference=signencrypt
Autocrypt: addr=1vf@posteo.net; prefer-encrypt=mutual; keydata=
 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
Message-ID: <f2d1b74e-a7f3-91c7-7fac-0c9b7b9e2749@posteo.net>
Date:   Sun, 18 Nov 2018 18:08:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello,

I'm reporting a firmware crash with ath10k and latest firmware. It
happens when "downing" an interface (or when suspending to RAM). Kernel
is 4.18.0 x86_64, but happens on older kernels as well. This used to
prevent interface from working after suspend and reboot was required,
but recent test shows that interface indeed sometimes (always?) works
after this happens, however it still sometimes prevents machine from
shutting down gracefully. Please let me know if this isn't the proper
place to report such issues. I'm not subscribed, please keep me in CC.
Details below.

Card:

04: PCI 200.0: 0282 WLAN controller
  [Created at pci.378]
  Unique ID: qru8.A+rG3bHqm97
  Parent ID: Z7uZ.8MJX3kOXqE4
  SysFS ID: /devices/pci0000:00/0000:00:1c.3/0000:02:00.0
  SysFS BusID: 0000:02:00.0
  Hardware Class: network
  Model: "Qualcomm Atheros QCA6174 802.11ac Wireless Network Adapter"
  Vendor: pci 0x168c "Qualcomm Atheros"
  Device: pci 0x003e "QCA6174 802.11ac Wireless Network Adapter"
  SubVendor: pci 0x11ad "Lite-On Communications Inc"
  SubDevice: pci 0x0804
  Revision: 0x20
  Driver: "ath10k_pci"
  Driver Modules: "ath10k_pci"
  Device File: wlp2s0
  Features: WLAN
  Memory Range: 0xc1000000-0xc11fffff (rw,non-prefetchable)
  IRQ: 51 (no events)
  HW Address: ac:e0:10:5f:03:2f
  Permanent HW Address: ac:e0:10:5f:03:2f
  Link detected: yes
  WLAN channels: 1 2 3 4 5 6 7 8 9 10 11 12 13 36 40 44 48 52 56 60 64
100 104 108 112 116 120 124 128 132 136 140
  WLAN frequencies: 2.412 2.417 2.422 2.427 2.432 2.437 2.442 2.447
2.452 2.457 2.462 2.467 2.472 5.18 5.2 5.22 5.24 5.26 5.28 5.3 5.32 5.5
5.52 5.54 5.56 5.58 5.6 5.62 5.64 5.66 5.68 5.7
  WLAN encryption modes: WEP40 WEP104 TKIP CCMP
  WLAN authentication modes: open sharedkey wpa-psk wpa-eap
  Module Alias: "pci:v0000168Cd0000003Esv000011ADsd00000804bc02sc80i00"
  Driver Info #0:
    Driver Status: ath10k_pci is active
    Driver Activation Cmd: "modprobe ath10k_pci"
  Config Status: cfg=new, avail=yes, need=no, active=unknown
  Attached to: #8 (PCI bridge)

Firmware md5:

11920f7c30a1b1dd009928baef1021dc
/lib/firmware/ath10k/QCA6174/hw2.1/board-2.bin
461e7f4b2f32f1c4ef50d26f76b715eb
/lib/firmware/ath10k/QCA6174/hw2.1/board.bin
944ef57488e09e708222d4fb49c3ab73
/lib/firmware/ath10k/QCA6174/hw2.1/firmware-5.bin


Dmesg output (boot):

[   20.862456] ath10k_pci 0000:02:00.0: pci irq msi oper_irq_mode 2
irq_mode 0 reset_mode 0
[   21.158378] ath10k_pci 0000:02:00.0: qca6174 hw2.1 target 0x05010000
chip_id 0x003405ff sub 11ad:0804
[   21.158383] ath10k_pci 0000:02:00.0: kconfig debug 0 debugfs 1
tracing 1 dfs 0 testmode 0
[   21.158909] ath10k_pci 0000:02:00.0: firmware ver
SW_RM.1.1.1-00157-QCARMSWPZ-1 api 5 features ignore-otp,no-4addr-pad
crc32 10bf8e08
[   21.252397] ath10k_pci 0000:02:00.0: board_file api 2 bmi_id N/A
crc32 ae2e275a
[   22.484918] ath10k_pci 0000:02:00.0: htt-ver 3.1 wmi-op 4 htt-op 3
cal otp max-sta 32 raw 0 hwcrypto 1
[   22.579024] ath: EEPROM regdomain: 0x6c
[   22.579026] ath: EEPROM indicates we should expect a direct regpair map
[   22.579028] ath: Country alpha2 being used: 00
[   22.579029] ath: Regpair used: 0x6c
[   22.690575] ath10k_pci 0000:02:00.0 wlp2s0: renamed from wlan0
[   64.032825] ath: EEPROM regdomain: 0x80bf
[   64.032826] ath: EEPROM indicates we should expect a country code
[   64.032827] ath: doing EEPROM country->regdmn map search
[   64.032828] ath: country maps to regdmn code: 0x37
[   64.032829] ath: Country alpha2 being used: HR
[   64.032831] ath: Regpair used: 0x37
[   64.032832] ath: regdomain 0x80bf dynamically updated by country element

Dmesg output (when stopping):

[ 3055.562261] ath10k_pci 0000:02:00.0: failed to install key for vdev 0
peer e4:6f:13:45:ca:56: -110
[ 3055.562273] wlp2s0: failed to remove key (0, e4:6f:13:45:ca:56) from
hardware (-110)
[ 3055.570420] ath10k_pci 0000:02:00.0: firmware crashed! (guid
2cb58b2b-3ffb-47ad-84f3-836a38ee6ffa)
[ 3055.570436] ath10k_pci 0000:02:00.0: qca6174 hw2.1 target 0x05010000
chip_id 0x003405ff sub 11ad:0804
[ 3055.570442] ath10k_pci 0000:02:00.0: kconfig debug 0 debugfs 1
tracing 1 dfs 0 testmode 0
[ 3055.571279] ath10k_pci 0000:02:00.0: firmware ver
SW_RM.1.1.1-00157-QCARMSWPZ-1 api 5 features ignore-otp,no-4addr-pad
crc32 10bf8e08
[ 3055.571717] ath10k_pci 0000:02:00.0: board_file api 2 bmi_id N/A
crc32 ae2e275a
[ 3055.571725] ath10k_pci 0000:02:00.0: htt-ver 3.1 wmi-op 4 htt-op 3
cal otp max-sta 32 raw 0 hwcrypto 1
[ 3055.573749] ath10k_pci 0000:02:00.0: firmware register dump:
[ 3055.573761] ath10k_pci 0000:02:00.0: [00]: 0x05010000 0x00000000
0x0092E4DC 0x6490A17E
[ 3055.573769] ath10k_pci 0000:02:00.0: [04]: 0x0092E4DC 0x00060130
0x00000018 0x0041A760
[ 3055.573775] ath10k_pci 0000:02:00.0: [08]: 0x6490A16A 0x00400000
0x00000000 0x000A5C88
[ 3055.573782] ath10k_pci 0000:02:00.0: [12]: 0x00000009 0x00000000
0x0096C09C 0x0096C0A7
[ 3055.573789] ath10k_pci 0000:02:00.0: [16]: 0x0096BDBC 0x009287BD
0x00000000 0x009287BD
[ 3055.573795] ath10k_pci 0000:02:00.0: [20]: 0x4092E4DC 0x0041A710
0x00000000 0x0F000000
[ 3055.573802] ath10k_pci 0000:02:00.0: [24]: 0x809432A7 0x0041A770
0x0040D400 0xC092E4DC
[ 3055.573808] ath10k_pci 0000:02:00.0: [28]: 0x80942BC4 0x0041A790
0x6490A16A 0x00400000
[ 3055.573815] ath10k_pci 0000:02:00.0: [32]: 0x80947BA7 0x0041A7B0
0x00404D88 0x0040E074
[ 3055.573821] ath10k_pci 0000:02:00.0: [36]: 0x809BDECC 0x0041A7D0
0x00404D88 0x0040E074
[ 3055.573828] ath10k_pci 0000:02:00.0: [40]: 0x8099638C 0x0041A7F0
0x00404D88 0x00000000
[ 3055.573835] ath10k_pci 0000:02:00.0: [44]: 0x80992076 0x0041A810
0x0044FD68 0x0046FFE8
[ 3055.573842] ath10k_pci 0000:02:00.0: [48]: 0x80996BD3 0x0041A830
0x0044FD68 0x00000000
[ 3055.573849] ath10k_pci 0000:02:00.0: [52]: 0x800B4405 0x0041A850
0x00422318 0x00005002
[ 3055.573855] ath10k_pci 0000:02:00.0: [56]: 0x809A6C34 0x0041A8E0
0x0042932C 0x0042CA20
[ 3055.573861] ath10k_pci 0000:02:00.0: Copy Engine register dump:
[ 3055.573880] ath10k_pci 0000:02:00.0: [00]: 0x00034400   1   1   3   3
[ 3055.573898] ath10k_pci 0000:02:00.0: [01]: 0x00034800   9   9 492 493
[ 3055.573916] ath10k_pci 0000:02:00.0: [02]: 0x00034c00  58  58 121 122
[ 3055.573934] ath10k_pci 0000:02:00.0: [03]: 0x00035000  24  24  25  24
[ 3055.573952] ath10k_pci 0000:02:00.0: [04]: 0x00035400 1251 1251 179 115
[ 3055.573970] ath10k_pci 0000:02:00.0: [05]: 0x00035800   0   0   0   0
[ 3055.573987] ath10k_pci 0000:02:00.0: [06]: 0x00035c00   2   2   2   2
[ 3055.574005] ath10k_pci 0000:02:00.0: [07]: 0x00036000   1   1   1   1
[ 3055.578268] ath10k_pci 0000:02:00.0: failed to update channel list: -108
[ 3055.578273] ath10k_pci 0000:02:00.0: failed to set pdev regdomain: -108
[ 3055.697200] ieee80211 phy0: Hardware restart was requested
[ 3057.056123] ath10k_pci 0000:02:00.0: device successfully recovered

Thanks,
Vedran

