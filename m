Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:36268 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373AbbG0UIP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2015 16:08:15 -0400
Received: by wicgb10 with SMTP id gb10so127627450wic.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2015 13:08:14 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 27 Jul 2015 22:08:14 +0200
Message-ID: <CAMQd7mbWC7rj8-eU7Jv21ehT8KrpC=L=xWxzDQxHEU_ePNSdUg@mail.gmail.com> (sfid-20150727_220818_747011_DDCC9CAD)
Subject: QCA6174 hw2.1 irq_mode=0 broken on 4.2-rc3, working on 4.1.2
From: Enrico Tagliavini <enrico.tagliavini@gmail.com>
To: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello there,

I gave 4.2 rc3 a shot and I discovered the wireless was not working
anymore with it. I tried adding irq_mode=1 alongside skip_otp=y in
ath10k_core (I assume you need fw api 5 to remove this, is that
correct?, I still have fw 4 only).

Loading with irq_mode=0

[   21.130224] ath10k_pci 0000:03:00.0: enabling device (0000 -> 0002)
[   21.130734] ath10k_pci 0000:03:00.0: pci irq msi-x interrupts 8
irq_mode 0 reset_mode 0
[   21.277023] ath10k_pci 0000:03:00.0: Direct firmware load for
ath10k/cal-pci-0000:03:00.0.bin failed with error -2
[   21.278105] ath10k_pci 0000:03:00.0: Direct firmware load for
ath10k/QCA6174/hw2.1/board-pci-168c:003e:1a56:1525.bin failed with
error -2
[   21.278109] ath10k_pci 0000:03:00.0: failed to load spec board
file, falling back to generic: -2
[   21.279048] ath10k_pci 0000:03:00.0: Direct firmware load for
ath10k/QCA6174/hw2.1/firmware-5.bin failed with error -2
[   21.279051] ath10k_pci 0000:03:00.0: could not fetch firmware file
'ath10k/QCA6174/hw2.1/firmware-5.bin': -2
[   22.445285] ath10k_pci 0000:03:00.0: received unsolicited fw crash interrupt
[   22.445319] ath10k_pci 0000:03:00.0: received unsolicited fw crash interrupt
[   23.445028] ath10k_pci 0000:03:00.0: failed to receive control
response completion, polling..
[   23.445183] ath10k_pci 0000:03:00.0: received unsolicited fw crash interrupt
[   23.445247] ath10k_pci 0000:03:00.0: received unsolicited fw crash interrupt
[   24.445040] ath10k_pci 0000:03:00.0: Service connect timeout
[   24.445043] ath10k_pci 0000:03:00.0: failed to connect htt (-110)
[   24.508619] ath10k_pci 0000:03:00.0: could not init core (-110)
[   24.508640] ath10k_pci 0000:03:00.0: could not probe fw (-110)
[   74.965904] ath10k_pci 0000:03:00.0: received unsolicited fw crash interrupt

With irq_mode=1 (and debug_mask=0x00000432 for ath10k_core... didn't
do.. anything?)

[  612.043708] ath10k_pci 0000:03:00.0: limiting irq mode to: 1
[  612.043711] ath10k_pci 0000:03:00.0: pci irq legacy interrupts 0
irq_mode 1 reset_mode 0
[  612.249048] ath10k_pci 0000:03:00.0: Direct firmware load for
ath10k/cal-pci-0000:03:00.0.bin failed with error -2
[  612.249148] ath10k_pci 0000:03:00.0: Direct firmware load for
ath10k/QCA6174/hw2.1/board-pci-168c:003e:1a56:1525.bin failed with
error -2
[  612.249150] ath10k_pci 0000:03:00.0: failed to load spec board
file, falling back to generic: -2
[  612.249251] ath10k_pci 0000:03:00.0: Direct firmware load for
ath10k/QCA6174/hw2.1/firmware-5.bin failed with error -2
[  612.249252] ath10k_pci 0000:03:00.0: could not fetch firmware file
'ath10k/QCA6174/hw2.1/firmware-5.bin': -2
[  613.435568] ath10k_pci 0000:03:00.0: qca6174 hw2.1 (0x05010000,
0x003405ff, 168c:003e:1a56:1525 fallback) fw killer-n1525-fw api 4 htt
3.0 wmi 4 cal otp max_sta 32
[  613.435571] ath10k_pci 0000:03:00.0: debug 0 debugfs 1 tracing 0
dfs 0 testmode 0
[  613.509157] ath: EEPROM regdomain: 0x6c
[  613.509160] ath: EEPROM indicates we should expect a direct regpair map
[  613.509162] ath: Country alpha2 being used: 00
[  613.509163] ath: Regpair used: 0x6c
[  613.513311] ath10k_pci 0000:03:00.0 wlp3s0: renamed from wlan0


This is a Dell Alienware 15 (early 2015) laptop.
