Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:35934 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753184AbdEHPbz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 May 2017 11:31:55 -0400
Received: by mail-wm0-f49.google.com with SMTP id u65so88832473wmu.1
        for <linux-wireless@vger.kernel.org>; Mon, 08 May 2017 08:31:55 -0700 (PDT)
Received: from [192.168.10.89] ([147.83.206.88])
        by smtp.gmail.com with ESMTPSA id p197sm8900692wmb.34.2017.05.08.08.31.52
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 May 2017 08:31:53 -0700 (PDT)
To: linux-wireless@vger.kernel.org
From: Joan Josep <jj.aleixendri@gmail.com>
Subject: Ath10k Firmware crashes on QCA9888 board
Message-ID: <5d095188-45a8-1a0c-16a8-c58cd4aeb4f6@gmail.com> (sfid-20170508_173159_821576_A79E96B4)
Date: Mon, 8 May 2017 17:31:23 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello everybody

We bought some 11AC cards and we experienced some issues.

We are using a qca9888 chipset 11AC mini pci card on a 4.9.0 kernel 
compiled for an ARM processor (imx6) using Ubuntu 14.04 as operating system.

We are experiencing some problems when we try to load the ath10k_pci 
kernel module to use this card.

This is the resulting dmesg:

--> $ modprobe ath10k_pci

[   48.623361] ath10k_pci 0000:07:00.0: enabling bus mastering
[   48.624103] ath10k_pci 0000:07:00.0: pci irq msi oper_irq_mode 2 
irq_mode 0 reset_mode 0
[   48.697892] imx-sgtl5000 sound: ASoC: CODEC DAI sgtl5000 not registered
[   48.704523] imx-sgtl5000 sound: snd_soc_register_card failed (-517)
[   48.798971] ath10k_pci 0000:07:00.0: Direct firmware load for 
ath10k/pre-cal-pci-0000:07:00.0.bin failed with error -2
[   48.799002] ath10k_pci 0000:07:00.0: Direct firmware load for 
ath10k/cal-pci-0000:07:00.0.bin failed with error -2
[   48.800225] ath10k_pci 0000:07:00.0: qca9888 hw2.0 target 0x01000000 
chip_id 0x00000000 sub 0000:0000
[   48.800236] ath10k_pci 0000:07:00.0: kconfig debug 1 debugfs 1 
tracing 0 dfs 0 testmode 0
[   48.802878] ath10k_pci 0000:07:00.0: firmware ver 10.4-3.2-00072 api 
5 features no-p2p,mfp,peer-flow-ctrl crc32 b1da0716
[   50.789954] ath10k_pci 0000:07:00.0: board_file api 2 bmi_id 0:17 
crc32 74a04250

-- wlan0 appears on the system.

--> $ ifconfig wlan0 up


[   54.243525] ath10k_pci 0000:07:00.0: htt-ver 2.2 wmi-op 6 htt-op 4 
cal otp max-sta 512 raw 0 hwcrypto 1
[   54.250981] ath10k_pci 0000:07:00.0: firmware crashed! (uuid 
bf8aea5c-18bb-4433-b6a0-28143d0bae33)
[   54.259971] ath10k_pci 0000:07:00.0: qca9888 hw2.0 target 0x01000000 
chip_id 0x00000000 sub 0000:0000
[   54.259980] ath10k_pci 0000:07:00.0: kconfig debug 1 debugfs 1 
tracing 0 dfs 0 testmode 0
[   54.262670] ath10k_pci 0000:07:00.0: firmware ver 10.4-3.2-00072 api 
5 features no-p2p,mfp,peer-flow-ctrl crc32 b1da0716
[   54.263023] ath10k_pci 0000:07:00.0: board_file api 2 bmi_id 0:17 
crc32 74a04250
[   54.263032] ath10k_pci 0000:07:00.0: htt-ver 2.2 wmi-op 6 htt-op 4 
cal otp max-sta 512 raw 0 hwcrypto 1
[   54.275070] ath10k_pci 0000:07:00.0: failed to get memcpy hi address 
for firmware address 4: -16
[   54.275077] ath10k_pci 0000:07:00.0: failed to read firmware dump 
area: -16
[   54.339879] ath: EEPROM regdomain: 0x0
[   54.339886] ath: EEPROM indicates default country code should be used
[   54.339888] ath: doing EEPROM country->regdmn map search
[   54.339895] ath: country maps to regdmn code: 0x3a
[   54.339898] ath: Country alpha2 being used: US
[   54.339902] ath: Regpair used: 0x3a
[   54.407533] ath10k_pci 0000:07:00.0: cannot restart a device that 
hasn't been started
[   58.528359] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   63.047527] random: crng init done

-- wlan0 is still on the system but not responding anymore.


Could you please give us any help on this?

Thank you

Joan Josep
