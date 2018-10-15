Return-Path: <SRS0=ZQ3y=M3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22D30C04AA5
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 13:11:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3A1E20652
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 13:11:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yy5cylGE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D3A1E20652
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbeJOU43 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Oct 2018 16:56:29 -0400
Received: from mail-ot1-f54.google.com ([209.85.210.54]:33124 "EHLO
        mail-ot1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbeJOU43 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Oct 2018 16:56:29 -0400
Received: by mail-ot1-f54.google.com with SMTP id q50so18837029otd.0
        for <linux-wireless@vger.kernel.org>; Mon, 15 Oct 2018 06:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=hBB8BPRNFbY/YxYjWmYFj2lGg5rXww5LKjWt1yV6fKU=;
        b=Yy5cylGET6/Bdt5lbHGGIXZXyVgpxR/tJlc2ejjJvVihKTT7+uYtY65qlUtPz0DyLO
         t2duVhe5tBHuarKesgMIKxHkeRAMhYZ8CgLt+1sijMfOz6Lk7iKkw9PVA8u/KW27QrZr
         Naa6meANteoensbwzaguulKdr9bqDoMWrFdd2q5l9sGCGwe1WME/Gw/guJNPAHuwaeOK
         SmelEVQLOUgwV2ghRRz2sTk0DDOresuqpn0IuBW7XE497zl6MQ5M6ABH5HqVYn3sEsKX
         KHeZPacHwnF0nUbcreKMKNZMKkI5pstHAgoZnpXBOv5NAxF+XsRG3gGX7pzNOsSFNd0r
         9B+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=hBB8BPRNFbY/YxYjWmYFj2lGg5rXww5LKjWt1yV6fKU=;
        b=IhVc2sJypK9fyvUS80ffCBYavREJqmmQa5WCY0M76gtMPLMGvkLExzDp83toutDf4e
         muxJ65kzPM4bjIFKIdtPSA6Qm7Fv23Kz6wcZYL5goLsUDjhH3y/rwK51/NBF3B9TiEmf
         h3+H7E7nKwltd7TuDBdG+2NZ7WeODCD8kIBUI4E/IAsCAFcxXPF19hLuRJ+CixCQKcIs
         R7nM3KK9IqubfghhUl+m9WjYTbpoRrSM7+kgehbXQ2mlBfgvTFQOjfM7GPLmYV0A8ns6
         lk33p5B7YwX5qwysY5aO7ppxItuVuAkg5s2cPwzeRLAkxIOP30K2GdAtKLzOVvqeDUdd
         9ZiQ==
X-Gm-Message-State: ABuFfohZb+jI0nnoR04KdYgsFaLbdPXNHN9oQEeUaJBfWkrKTmFxs2pL
        BWaKDnAhb00rleqbU3cfH8hjwUSUm38JPt7w6rh9iw==
X-Google-Smtp-Source: ACcGV62oirZjbIsWU7CTzMy1ESGRHEng2AK4SpHTQciCPE3OICAs/RVUPt3rxvRapU++/bFy0U2dy1e5guab+P1fVqQ=
X-Received: by 2002:a9d:191f:: with SMTP id j31mr10482406ota.76.1539609073594;
 Mon, 15 Oct 2018 06:11:13 -0700 (PDT)
MIME-Version: 1.0
From:   Nicolai <nicolai.kellerer@gmail.com>
Date:   Mon, 15 Oct 2018 15:11:02 +0200
Message-ID: <CAFOhvodrA0GesXMqeAP-aX+V36tyeDoC6VEW6Ji_YcAvuY2KcQ@mail.gmail.com>
Subject: [BUG REPORT] ath10k: failed to wake target
To:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello,

I'm using the Lenovo Yoga 910 with Linux 4.18.13.
After some time the Wifi connection drops and one CPU core is capped at ~90%.
If there is anything I could do to help with debugging, just let me know.

Thanks

$ lscpi -k
01:00.0 Network controller: Qualcomm Atheros QCA6174 802.11ac Wireless
Network Adapter (rev 32)
    Subsystem: Lenovo Device 0827
    Kernel driver in use: ath10k_pci
    Kernel modules: ath10k_pci

$ sudo ethtool -i wlp1s0
driver: ath10k_pci
version: 4.18.13-200.fc28.x86_64
firmware-version: WLAN.RM.4.4.1-00079-QCARMSWPZ-1
expansion-rom-version:
bus-info: 0000:01:00.0
supports-statistics: yes
supports-test: no
supports-eeprom-access: no
supports-register-dump: no
supports-priv-flags: no

$ dmesg | grep "ath10k"
[    4.335716] ath10k_pci 0000:01:00.0: pci irq msi oper_irq_mode 2
irq_mode 0 reset_mode 0
[    4.551405] ath10k_pci 0000:01:00.0: qca6174 hw3.2 target
0x05030000 chip_id 0x00340aff sub 17aa:0827
[    4.551408] ath10k_pci 0000:01:00.0: kconfig debug 0 debugfs 1
tracing 0 dfs 0 testmode 0
[    4.551848] ath10k_pci 0000:01:00.0: firmware ver
WLAN.RM.4.4.1-00079-QCARMSWPZ-1 api 6 features wowlan,ignore-otp crc32
fd869beb
[    4.617583] ath10k_pci 0000:01:00.0: board_file api 2 bmi_id N/A
crc32 20d869c3
[    5.272911] ath10k_pci 0000:01:00.0: Unknown eventid: 118809
[    5.275912] ath10k_pci 0000:01:00.0: Unknown eventid: 90118
[    5.276499] ath10k_pci 0000:01:00.0: htt-ver 3.47 wmi-op 4 htt-op 3
cal otp max-sta 32 raw 0 hwcrypto 1
[    5.357593] ath10k_pci 0000:01:00.0 wlp1s0: renamed from wlan0
[    6.208647] ath10k_pci 0000:01:00.0: Unknown eventid: 118809
[    6.211655] ath10k_pci 0000:01:00.0: Unknown eventid: 90118
[    7.021111] ath10k_pci 0000:01:00.0: Unknown eventid: 118809
[    7.024123] ath10k_pci 0000:01:00.0: Unknown eventid: 90118
[  479.281186] ath10k_pci 0000:01:00.0: Unknown eventid: 118809
[  479.284099] ath10k_pci 0000:01:00.0: Unknown eventid: 90118
[  481.069796] ath10k_pci 0000:01:00.0: failed to receive control
response completion, polling..
[  481.102612] ath10k_pci 0000:01:00.0: failed to wake target for
write32 of 0x00000001 at 0x00034430: -110
[  481.135383] ath10k_pci 0000:01:00.0: failed to wake target for
read32 at 0x00034444: -110
[  481.168154] ath10k_pci 0000:01:00.0: failed to wake target for
write32 of 0x0000001e at 0x00034430: -110
[  481.200921] ath10k_pci 0000:01:00.0: failed to wake target for
write32 of 0x00000001 at 0x00034830: -110
[  481.233680] ath10k_pci 0000:01:00.0: failed to wake target for
write32 of 0x00000001 at 0x00035430: -110
[  481.266432] ath10k_pci 0000:01:00.0: failed to wake target for
read32 at 0x00035444: -110
[  481.299199] ath10k_pci 0000:01:00.0: failed to wake target for
write32 of 0x0000001e at 0x00035430: -110
[  482.797704] ath10k_pci 0000:01:00.0: ctl_resp never came in (-110)
[  482.797718] ath10k_pci 0000:01:00.0: failed to connect to HTC: -110
[  484.283071] ath10k_warn: 60 callbacks suppressed
[  484.283074] ath10k_pci 0000:01:00.0: failed to wake target for
write32 of 0xfffff81f at 0x00036034: -110
[  484.315837] ath10k_pci 0000:01:00.0: failed to wake target for
read32 at 0x0003602c: -110
[  484.348237] ath10k_pci 0000:01:00.0: failed to wake target for
write32 of 0xffffffe1 at 0x0003602c: -110
[  484.381002] ath10k_pci 0000:01:00.0: failed to wake target for
write32 of 0x00000000 at 0x0003a008: -110
[  484.413766] ath10k_pci 0000:01:00.0: failed to wake target for
write32 of 0x0007fc00 at 0x0003a014: -110
[  484.446526] ath10k_pci 0000:01:00.0: failed to wake target for
read32 at 0x0003a008: -110
[  484.479289] ath10k_pci 0000:01:00.0: failed to wake target for
read32 at 0x0003a000: -110
[  484.512051] ath10k_pci 0000:01:00.0: failed to wake target for
write32 of 0xfffff7ff at 0x0003a000: -110
[  484.544820] ath10k_pci 0000:01:00.0: failed to wake target for
read32 at 0x00000800: -110
[  484.577584] ath10k_pci 0000:01:00.0: failed to wake target for
write32 of 0xffffffff at 0x00000800: -110
[  489.311522] ath10k_warn: 144 callbacks suppressed
[  489.311525] ath10k_pci 0000:01:00.0: failed to wake target for
read32 at 0x0003a028: -110
[  489.344294] ath10k_pci 0000:01:00.0: failed to wake target for
read32 at 0x0003a028: -110
[  489.377060] ath10k_pci 0000:01:00.0: failed to wake target for
read32 at 0x0003a028: -110
[  489.409828] ath10k_pci 0000:01:00.0: failed to wake target for
read32 at 0x0003a028: -110
[  489.442592] ath10k_pci 0000:01:00.0: failed to wake target for
read32 at 0x0003a028: -110
[  489.475353] ath10k_pci 0000:01:00.0: failed to wake target for
read32 at 0x0003a028: -110
[  489.508118] ath10k_pci 0000:01:00.0: failed to wake target for
read32 at 0x0003a028: -110
[  489.540884] ath10k_pci 0000:01:00.0: failed to wake target for
read32 at 0x0003a028: -110
[  489.573650] ath10k_pci 0000:01:00.0: failed to wake target for
read32 at 0x0003a028: -110
[  489.606418] ath10k_pci 0000:01:00.0: failed to wake target for
read32 at 0x0003a028: -110
[  490.556544] ath10k_pci 0000:01:00.0: failed to read device
register, device is gone
[  494.327776] ath10k_warn: 143 callbacks suppressed
[  494.327779] ath10k_pci 0000:01:00.0: failed to wake target for
read32 at 0x0003a028: -110
[  494.360545] ath10k_pci 0000:01:00.0: failed to wake target for
read32 at 0x0003a028: -110
[  494.391132] ath10k_pci 0000:01:00.0: failed to wake target for
read32 at 0x0003a028: -110
[  494.421473] ath10k_pci 0000:01:00.0: failed to wake target for
read32 at 0x0003a028: -110
[  494.451814] ath10k_pci 0000:01:00.0: failed to wake target for
read32 at 0x0003a028: -110
[  494.484233] ath10k_pci 0000:01:00.0: failed to wake target for
read32 at 0x0003a028: -110
[  494.516996] ath10k_pci 0000:01:00.0: failed to wake target for
read32 at 0x0003a028: -110
[  494.549762] ath10k_pci 0000:01:00.0: failed to wake target for
read32 at 0x0003a028: -110
[  494.582529] ath10k_pci 0000:01:00.0: failed to wake target for
read32 at 0x0003a028: -110
[  494.615293] ath10k_pci 0000:01:00.0: failed to wake target for
read32 at 0x0003a028: -110
[  496.581039] ath10k_pci 0000:01:00.0: failed to read device
register, device is gone
[  498.310878] ath10k_pci 0000:01:00.0: Could not init core: -110
[  499.342333] ath10k_warn: 143 callbacks suppressed
[  499.342336] ath10k_pci 0000:01:00.0: failed to wake target for
read32 at 0x0003a028: -110
[  499.375100] ath10k_pci 0000:01:00.0: failed to wake target for
read32 at 0x0003a028: -110
[  499.407864] ath10k_pci 0000:01:00.0: failed to wake target for
read32 at 0x0003a028: -110
[  499.438455] ath10k_pci 0000:01:00.0: failed to wake target for
read32 at 0x0003a028: -110
[  499.468794] ath10k_pci 0000:01:00.0: failed to wake target for
read32 at 0x0003a028: -110
[  499.499133] ath10k_pci 0000:01:00.0: failed to wake target for
read32 at 0x0003a028: -110
[  499.531554] ath10k_pci 0000:01:00.0: failed to wake target for
read32 at 0x0003a028: -110
[  499.564322] ath10k_pci 0000:01:00.0: failed to wake target for
read32 at 0x0003a028: -110
[  499.597105] ath10k_pci 0000:01:00.0: failed to wake target for
read32 at 0x0003a028: -110
[  499.629874] ath10k_pci 0000:01:00.0: failed to wake target for
read32 at 0x0003a028: -110
[  501.621565] ath10k_pci 0000:01:00.0: failed to read device
register, device is gone
[  501.719847] ath10k_pci 0000:01:00.0: firmware crashed! (guid
85ef4036-19a2-4997-9828-bc9386ee1d98)
[  501.719851] ath10k_pci 0000:01:00.0: qca6174 hw3.2 target
0x05030000 chip_id 0x00340aff sub 17aa:0827
[  501.719852] ath10k_pci 0000:01:00.0: kconfig debug 0 debugfs 1
tracing 0 dfs 0 testmode 0
[  501.720228] ath10k_pci 0000:01:00.0: firmware ver
WLAN.RM.4.4.1-00079-QCARMSWPZ-1 api 6 features wowlan,ignore-otp crc32
fd869beb
[  501.720510] ath10k_pci 0000:01:00.0: board_file api 2 bmi_id N/A
crc32 20d869c3
[  501.720512] ath10k_pci 0000:01:00.0: htt-ver 3.47 wmi-op 4 htt-op 3
cal otp max-sta 32 raw 0 hwcrypto 1
[  502.224177] ath10k_pci 0000:01:00.0: failed to read firmware dump area: -16
[  502.224180] ath10k_pci 0000:01:00.0: Copy Engine register dump:
[  502.355210] ath10k_pci 0000:01:00.0: [00]: 0x00034400 4294967295
4294967295 4294967295 4294967295
[  502.486243] ath10k_pci 0000:01:00.0: [01]: 0x00034800 4294967295
4294967295 4294967295 4294967295
[  502.617270] ath10k_pci 0000:01:00.0: [02]: 0x00034c00 4294967295
4294967295 4294967295 4294967295
[  502.748321] ath10k_pci 0000:01:00.0: [03]: 0x00035000 4294967295
4294967295 4294967295 4294967295
[  502.871659] ath10k_pci 0000:01:00.0: [04]: 0x00035400 4294967295
4294967295 4294967295 4294967295
[  503.002700] ath10k_pci 0000:01:00.0: [05]: 0x00035800 4294967295
4294967295 4294967295 4294967295
[  503.133734] ath10k_pci 0000:01:00.0: [06]: 0x00035c00 4294967295
4294967295 4294967295 4294967295
[  503.264782] ath10k_pci 0000:01:00.0: [07]: 0x00036000 4294967295
4294967295 4294967295 4294967295
[  503.264788] ath10k_pci 0000:01:00.0: failed to reset chip: -5
[  503.264790] ath10k_pci 0000:01:00.0: Could not init hif: -5
[  504.352295] ath10k_warn: 146 callbacks suppressed
