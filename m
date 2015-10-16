Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41978 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbbJPMnA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2015 08:43:00 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <c_traja@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2 v2] ath10k: add fw_stats support to 10.4 firmware
References: <1444812862-11173-1-git-send-email-c_traja@qti.qualcomm.com>
Date: Fri, 16 Oct 2015 15:42:44 +0300
In-Reply-To: <1444812862-11173-1-git-send-email-c_traja@qti.qualcomm.com> (c.
	traja's message of "Wed, 14 Oct 2015 14:24:22 +0530")
Message-ID: <87twprgf23.fsf@kamboji.qca.qualcomm.com> (sfid-20151016_144305_584057_2D70CD52)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<c_traja@qti.qualcomm.com> writes:

> From: Manikanta <c_mpubbi@qti.qualcomm.com>
>
> This patch adds support for getting firmware debug stats in 10.4 fw.
>
> Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>

This patch adds new warnings:

drivers/net/wireless/ath/ath10k/wmi.c:7121:6: warning: symbol 'ath10k_wmi_10_4_fw_stats_fill' was not declared. Should it be static?
drivers/net/wireless/ath/ath10k/wmi.c:7122: Alignment should match open parenthesis
drivers/net/wireless/ath/ath10k/wmi.h:6323: Alignment should match open parenthesis

And while testing this I found this buggy:

root@lainahp:/sys/kernel/debug/ieee80211/phy0/ath10k# tail -20 fw_stats 
   MPDU errors (FCS, MIC, ENC)          0
        Num Rx Overflow errors          0

             ath10k VDEV stats (0)
             =================


             ath10k PEER stats (2)
             =================

              Peer MAC address 02:00:00:00:03:00
                     Peer RSSI 0
                  Peer TX rate 5120
                  Peer RX rate 0

              Peer MAC address 00:00:00:00:10:68
                     Peer RSSI 34236
                  Peer TX rate 31
                  Peer RX rate 0

The last two bytes of the client's mac address are bc:85 and 34236 is
0x85bc so ath10k is definitely not parsing the peer stats correctly.

I used:

[   68.077601] ath10k_pci 0000:02:00.0: pci irq msi interrupts 1 irq_mode 0 reset_mode 0
[   72.516344] ath10k_pci 0000:02:00.0: qca99x0 hw2.0 (0x01000000, 0x003801ff bmi 1:1) fw 10.4.1.00030-1 fwapi 5 bdapi 2 htt-ver 2.2 wmi-op 6 htt-op 4 cal otp max-sta 512 raw 0 hwcrypto 1 features no-p2p
[   72.516468] ath10k_pci 0000:02:00.0: debug 1 debugfs 1 tracing 1 dfs 1 testmode 1

-- 
Kalle Valo
