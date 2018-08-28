Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:35676 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727054AbeH1UKY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 16:10:24 -0400
Received: by mail-it0-f51.google.com with SMTP id 139-v6so3300873itf.0
        for <linux-wireless@vger.kernel.org>; Tue, 28 Aug 2018 09:18:00 -0700 (PDT)
MIME-Version: 1.0
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 28 Aug 2018 21:47:48 +0530
Message-ID: <CABPxzYK=jmERyvryoy274gtDEBft-BUMjOBsDhjVd+xQu-tQLg@mail.gmail.com> (sfid-20180828_181803_373188_C3BC883F)
Subject: ath10k: adding wlan to bridge causes WPA2-PSK to fail
To: "Hostap@lists.infradead.org" <hostap@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am trying to connect ath10k interface to Linux bridge after enabling
of 4addr mode in WPA2-PSK mode, but EAPOL handshake fails, M1 is
not received by the wpa_supplicant.

ath10k_pci: QCA6174
=================
pci irq msi oper_irq_mode 2 irq_mode 0 reset_mode 0
qca6174 hw3.2 target 0x05030000 chip_id 0x00340aff sub 1028:0310
kconfig debug 0 debugfs 1 tracing 1 dfs 0 testmode 0
firmware ver WLAN.RM.4.4.1-00079-QCARMSWPZ-1 api 6 features
wowlan,ignore-otp crc32 fd869beb
board_file api 2 bmi_id N/A crc32 20d869c3
Unknown eventid: 118809
Unknown eventid: 90118
htt-ver 3.47 wmi-op 4 htt-op 3 cal otp max-sta 32 raw 0 hwcrypto 1
============
Kernel: 4.18.0-rc8: wireless-drivers-next:
209b43759d65b2cc99ce7757249aacc82b03c4e2
============
wpa_supp: b3f24b06e30411e1d4af06945b43eb4db0ac3394
  .config has #CONFIG_NO_LINUX_PACKET_SOCKET_WAR=y
and default L2 packet (linux packet socket)

wpa_supplicant verbose logs:

wlp3s0: State: ASSOCIATING -> ASSOCIATED
nl80211: Set wlp3s0 operstate 0->0 (DORMANT)
netlink: Operstate: ifindex=3 linkmode=-1 (no change), operstate=5
(IF_OPER_DORMANT)
<<Snip..............>>
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
EAPOL: External notification - portEnabled=1
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: enable timer tick
EAPOL: SUPP_BE entering state IDLE
wlp3s0: Setting authentication timeout: 10 sec 0 usec
wlp3s0: Cancelling scan request
<<Snip..............>>
RTM_NEWLINK: ifi_index=3 ifname=wlp3s0 wext ifi_family=0
ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK: ifi_index=3 ifname=wlp3s0 wext ifi_family=0
ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK: ifi_index=3 ifname=wlp3s0 master=12 operstate=5
ifi_family=7 ifi_flags=0x11003 ([UP][LOWER_UP])
nl80211: Add ifindex 12 for bridge br0
nl80211: Add own interface ifindex 12 (ifidx_reason 3)
nl80211: ifindex 12 already in the list
RTM_NEWLINK: ifi_index=3 ifname=wlp3s0 operstate=5 linkmode=1
master=12 ifi_family=0 ifi_flags=0x11003 ([UP][LOWER_UP])
<<Snip..............>>
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: enable timer tick
EAPOL: txStart
WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
RTM_NEWLINK: ifi_index=3 ifname=wlp3s0 master=12 operstate=2
ifi_family=7 ifi_flags=0x1003 ([UP])
nl80211: Add ifindex 12 for bridge br0
nl80211: Add own interface ifindex 12 (ifidx_reason 3)
nl80211: ifindex 12 already in the list
RTM_NEWLINK: ifi_index=3 ifname=wlp3s0 operstate=2 linkmode=1
master=12 ifi_family=0 ifi_flags=0x1003 ([UP])
nl80211: Event message available
nl80211: Ignored event (cmd=20) for foreign interface (ifindex 3 wdev 0x0)
nl80211: Drv Event 20 (NL80211_CMD_DEL_STATION) received for wlp3s0
nl80211: Delete station 08:02:8e:8c:9c:50
nl80211: Event message available
nl80211: Ignored event (cmd=40) for foreign interface (ifindex 3 wdev 0x0)
nl80211: Drv Event 40 (NL80211_CMD_DISASSOCIATE) received for wlp3s0
nl80211: MLME event 40 (NL80211_CMD_DISASSOCIATE) on
wlp3s0(9c:30:5b:7b:18:65) A1=9c:30:5b:7b:18:65 A2=08:02:8e:8c:9c:50
nl80211: MLME event frame - hexdump(len=26): a0 00 3c 00 9c 30 5b 7b
18 65 08 02 8e 8c 9c 50 08 02 8e 8c 9c 50 00 00 02 00
nl80211: Disassociate event
wlp3s0: Event DISASSOC (1) received
wlp3s0: Disassociation notification
wlp3s0:  * reason 2
wlp3s0:  * address 08:02:8e:8c:9c:50
Disassociation frame IE(s) - hexdump(len=0): [NULL]
