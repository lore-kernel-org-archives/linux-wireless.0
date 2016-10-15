Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:36567 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754452AbcJOOAa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Oct 2016 10:00:30 -0400
Received: by mail-wm0-f48.google.com with SMTP id f193so31132900wmg.1
        for <linux-wireless@vger.kernel.org>; Sat, 15 Oct 2016 07:00:30 -0700 (PDT)
Received: from localhost.localdomain (127.7.150.83.ftth.as8758.net. [83.150.7.127])
        by smtp.gmail.com with ESMTPSA id n5sm37020605wjv.35.2016.10.15.07.00.28
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 15 Oct 2016 07:00:28 -0700 (PDT)
Subject: compex wle900vx (ath10k) problem on 4.4.24 / armv7
References: <b61ccf3c-1861-c8f8-ff7d-91c2b6ff4df5@gmail.com>
To: linux-wireless@vger.kernel.org
From: Oliver Zemann <oliver.zemann@gmail.com>
Message-ID: <41e828b1-c340-d6c6-61f4-051c845820c8@gmail.com> (sfid-20161015_160034_817698_093C3E9D)
Date: Sat, 15 Oct 2016 16:00:27 +0200
MIME-Version: 1.0
In-Reply-To: <b61ccf3c-1861-c8f8-ff7d-91c2b6ff4df5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a clearfog pro (arm7) from marvel and bought a pcie wifi card. 
Unfortunately, it does not work.
I am not sure if this is a bug in the module or even in some pci-e 
driver. Maybe someone could tell me that.

dmesg:

[ 5.348307] mvebu-pcie soc:pcie-controller: 
/soc/pcie-controller/pcie@2,0: reset gpio is active low
[ 5.358026] mvebu-pcie soc:pcie-controller: 
/soc/pcie-controller/pcie@3,0: reset gpio is active low
[ 5.421496] mvebu-pcie soc:pcie-controller: PCI host bridge to bus 0000:00
[ 5.428390] pci_bus 0000:00: root bus resource [io 0x1000-0xfffff]
[ 5.434680] pci_bus 0000:00: root bus resource [mem 0xf8000000-0xffdfffff]
[ 5.441575] pci_bus 0000:00: root bus resource [bus 00-ff]
[ 5.447083] pci 0000:00:02.0: [11ab:6828] type 01 class 0x060400
[ 5.447198] pci 0000:00:03.0: [11ab:6828] type 01 class 0x060400
[ 5.447295] PCI: bus0: Fast back to back transfers disabled
[ 5.452887] pci 0000:00:02.0: bridge configuration invalid ([bus 
00-00]), reconfiguring
[ 5.460911] pci 0000:00:03.0: bridge configuration invalid ([bus 
00-00]), reconfiguring
[ 5.468986] PCI: bus1: Fast back to back transfers enabled
[ 5.474491] pci_bus 0000:01: busn_res: [bus 01-ff] end is updated to 01
[ 5.474561] pci 0000:02:00.0: [168c:003c] type 00 class 0x028000
[ 5.474593] pci 0000:02:00.0: reg 0x10: [mem 0x00000000-0x001fffff 64bit]
[ 5.474617] pci 0000:02:00.0: reg 0x30: [mem 0x00000000-0x0000ffff pref]
[ 5.474667] pci 0000:02:00.0: supports D1 D2
[ 5.511395] PCI: bus2: Fast back to back transfers enabled
[ 5.516894] pci_bus 0000:02: busn_res: [bus 02-ff] end is updated to 02
[ 5.516905] pci 0000:02:00.0: of_irq_parse_pci() failed with rc=134
[ 5.523207] pci 0000:00:03.0: BAR 14: assigned [mem 0xf8000000-0xf82fffff]
[ 5.530098] pci 0000:00:02.0: PCI bridge to [bus 01]
[ 5.535082] pci 0000:02:00.0: BAR 0: assigned [mem 0xf8000000-0xf81fffff 
64bit]
[ 5.542413] pci 0000:02:00.0: BAR 0: error updating (0xf8000004 != 
0xffffffff)
[ 5.549652] pci 0000:02:00.0: BAR 0: error updating (high 0x000000 != 
0xffffffff)
[ 5.557155] pci 0000:02:00.0: BAR 6: assigned [mem 0xf8200000-0xf820ffff 
pref]
[ 5.564396] pci 0000:00:03.0: PCI bridge to [bus 02]
[ 5.569372] pci 0000:00:03.0: bridge window [mem 0xf8000000-0xf82fffff]
[ 5.576256] pcieport 0000:00:03.0: enabling device (0140 -> 0142)

lspci:


[root@alarm alarm]# lspci
00:02.0 PCI bridge: Marvell Technology Group Ltd. Device 6828 (rev 04)
00:03.0 PCI bridge: Marvell Technology Group Ltd. Device 6828 (rev 04)
02:00.0 Network controller: Qualcomm Atheros QCA986x/988x 802.11ac 
Wireless Network Adapter (rev ff)

Thanks!
