Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f182.google.com ([209.85.217.182]:33792 "EHLO
        mail-ua0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751189AbdDHFM6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 8 Apr 2017 01:12:58 -0400
MIME-Version: 1.0
In-Reply-To: <20170322194240.1488-1-nbd@nbd.name>
References: <20170322194240.1488-1-nbd@nbd.name>
From: Weedy <weedy2887@gmail.com>
Date: Sat, 8 Apr 2017 01:12:37 -0400
Message-ID: <CAFE24U10xk0ZmcHL6zUYk=vMqNTxE_uMZVAv2Q0Leyi1iBTCdA@mail.gmail.com> (sfid-20170408_071303_533849_E3783C4A)
Subject: Re: [PATCH] ath9k_hw: fix channel maximum power level test
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 March 2017 at 15:42, Felix Fietkau <nbd@nbd.name> wrote:
> The tx power applied by set_txpower is limited by the CTL (conformance
> test limit) entries in the EEPROM. These can change based on the user
> configured regulatory domain.
> Depending on the EEPROM data this can cause the tx power to become too
> limited, if the original regdomain CTLs impose lowr limits than the CTLs
> of the user configured regdomain.

When merged, should this this fix this annoyance? Or is TP-Link just
shipping junk cal data?

root@LEDE:~# iw phy
Wiphy phy1
...
        Frequencies:
            * 5180 MHz [36] (21.0 dBm)
            * 5200 MHz [40] (21.0 dBm)
            * 5220 MHz [44] (21.0 dBm)
            * 5240 MHz [48] (21.0 dBm)
            * 5260 MHz [52] (21.0 dBm) (radar detection)
            * 5280 MHz [56] (21.0 dBm) (radar detection)
            * 5300 MHz [60] (21.0 dBm) (radar detection)
            * 5320 MHz [64] (21.0 dBm) (radar detection)
            * 5500 MHz [100] (21.0 dBm) (radar detection)
            * 5520 MHz [104] (21.0 dBm) (radar detection)
            * 5540 MHz [108] (21.0 dBm) (radar detection)
            * 5560 MHz [112] (21.0 dBm) (radar detection)
            * 5580 MHz [116] (21.0 dBm) (radar detection)
            * 5600 MHz [120] (disabled)
            * 5620 MHz [124] (disabled)
            * 5640 MHz [128] (disabled)
            * 5660 MHz [132] (21.0 dBm) (radar detection)
            * 5680 MHz [136] (21.0 dBm) (radar detection)
            * 5700 MHz [140] (21.0 dBm) (radar detection)
            * 5745 MHz [149] (21.0 dBm)
            * 5765 MHz [153] (21.0 dBm)
            * 5785 MHz [157] (21.0 dBm)
            * 5805 MHz [161] (21.0 dBm)
            * 5825 MHz [165] (21.0 dBm)
root@LEDE:~# iw reg get
global
country CA: DFS-FCC
    (2402 - 2472 @ 40), (N/A, 30), (N/A)
    (5150 - 5250 @ 80), (N/A, 23), (N/A), AUTO-BW
    (5250 - 5350 @ 80), (N/A, 24), (0 ms), DFS, AUTO-BW
    (5470 - 5600 @ 80), (N/A, 24), (0 ms), DFS
    (5650 - 5730 @ 80), (N/A, 24), (0 ms), DFS
    (5735 - 5835 @ 80), (N/A, 30), (N/A)

phy#1
country US: DFS-FCC
    (2402 - 2472 @ 40), (N/A, 30), (N/A)
    (5170 - 5250 @ 80), (N/A, 23), (N/A), AUTO-BW
    (5250 - 5330 @ 80), (N/A, 23), (0 ms), DFS, AUTO-BW
    (5490 - 5730 @ 160), (N/A, 23), (0 ms), DFS
    (5735 - 5835 @ 80), (N/A, 30), (N/A)
    (57240 - 63720 @ 2160), (N/A, 40), (N/A)

root@LEDE:~# iw phy phy1 set txpower fixed 1500
root@LEDE:~# iwinfo
wlan1     ESSID: nah
          Access Point: still nah
          Mode: Master  Channel: 48 (5.240 GHz)
          Tx-Power: 15 dBm  Link Quality: 44/70
          Signal: -66 dBm  Noise: -90 dBm
          Bit Rate: 147.5 MBit/s
          Encryption: WPA2 PSK (CCMP)
          Type: nl80211  HW Mode(s): 802.11an
          Hardware: 168C:0033 168C:A120 [Atheros AR9580]
          TX power offset: none
          Frequency offset: none
          Supports VAPs: yes  PHY name: phy1

root@LEDE:~# iw phy phy1 set txpower fixed 2000
root@LEDE:~# iwinfo
wlan1     ESSID: nah
          Access Point: still nah
          Mode: Master  Channel: 48 (5.240 GHz)
          Tx-Power: 17 dBm  Link Quality: 45/70
          Signal: -65 dBm  Noise: -90 dBm
          Bit Rate: 177.5 MBit/s
          Encryption: WPA2 PSK (CCMP)
          Type: nl80211  HW Mode(s): 802.11an
          Hardware: 168C:0033 168C:A120 [Atheros AR9580]
          TX power offset: none
          Frequency offset: none
          Supports VAPs: yes  PHY name: phy1
