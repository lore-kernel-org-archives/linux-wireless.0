Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:37197 "EHLO
        mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750923AbdLaRbf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 31 Dec 2017 12:31:35 -0500
Received: by mail-lf0-f48.google.com with SMTP id f3so16110568lfe.4
        for <linux-wireless@vger.kernel.org>; Sun, 31 Dec 2017 09:31:34 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v4 00/18] ath10k high latency
Date: Sun, 31 Dec 2017 18:29:07 +0100
Message-Id: <20171231172925.24014-1-erik.stromdahl@gmail.com> (sfid-20171231_183213_444857_80AE314C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the fourth version of the high latency patches (stuff common for
usb and sdio).

Most of Kalles comments have been addressed, except the start_once patch
which is identical to the previous version. I need to investigate more
how this feature affects the case where the interface is brought up and
down several times.

The first two patches adds inline wrappers to the newly introduced htt
ops. I think these patches could have been submitted separately (as
PATCH and not RFC) but I decided to include them in this RFC series
instead.
Adding them separately would have reduced the size of the patchset
somewhat, but since the rest of the patches are depending on the first
two, I decided not to submit them separately.

I have tested USB support and the performance is similar to previous
versions.

Below are the results from iperf with a WUSB6100M:

192.168.1.190: WUSB6100M
192.168.1.244: other computer

Uplink test results (WUSB6100M -> other computer):

# iperf-client.sh 192.168.1.244
/usr/bin/iperf
------------------------------------------------------------
Client connecting to 192.168.1.244, TCP port 1234
TCP window size: 85.0 KByte (default)
------------------------------------------------------------
[  3] local 192.168.1.190 port 50524 connected with 192.168.1.244 port
1234
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.1 sec  10.8 MBytes  8.95 Mbits/sec

The result is not so good (I expect more from an 11ac device),
but hopefully it is configuration related.

Downlink test results (other computer -> WUSB6100M):

# iperf-server.sh
/usr/bin/iperf
------------------------------------------------------------
Server listening on TCP port 1234
TCP window size: 85.3 KByte (default)
------------------------------------------------------------
[  4] local 192.168.1.190 port 1234 connected with 192.168.1.244 port
44824
[  349.641149] usb 1-1: failed to transmit packet, dropping: -12
[  349.643246] usb 1-1: failed to submit frame: -12
[  349.643644] usb 1-1: failed to push frame: -12
[  349.663267] usb 1-1: failed to transmit packet, dropping: -12
[  349.664250] usb 1-1: failed to submit frame: -12
[  349.665405] usb 1-1: failed to push frame: -12
[  349.670244] usb 1-1: failed to transmit packet, dropping: -12
[  349.670907] usb 1-1: failed to submit frame: -12
[  349.671419] usb 1-1: failed to push frame: -12
[  349.671887] usb 1-1: failed to transmit packet, dropping: -12
[  350.703418] random: crng init done
[  354.877329] ath10k_warn: 10661 callbacks suppressed
[  354.877331] usb 1-1: failed to transmit packet, dropping: -12
[  354.879931] usb 1-1: failed to submit frame: -12
[  354.880307] usb 1-1: failed to push frame: -12
[  354.940557] usb 1-1: failed to transmit packet, dropping: -12
[  354.942516] usb 1-1: failed to submit frame: -12
[  354.943062] usb 1-1: failed to push frame: -12
[  355.134808] usb 1-1: failed to transmit packet, dropping: -12
[  355.136463] usb 1-1: failed to submit frame: -12
[  355.137425] usb 1-1: failed to push frame: -12
[  355.159841] usb 1-1: failed to transmit packet, dropping: -12
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0-10.0 sec   225 MBytes   188 Mbits/sec

As you can see, there are a lot of ENOMEM errors in the TX path.
I think they could be related to patch 16 (that removes the pending
TX counter), but since I don't know how to configure the device
to generate HTT_T2H_MSG_TYPE_TX_COMPL_IND's the sw flow control had
to be disabled.

Since I no longer have access to any SDIO hardware I have not been able
to try the SDIO stuff, so it might be broken.

Erik Stromdahl (18):
  ath10k: add inlined wrappers for htt tx ops
  ath10k: add inlined wrappers for htt rx ops
  ath10k: add struct ath10k_bus_params
  ath10k: high_latency detection
  ath10k: add bus type check in ath10k_init_hw_params
  ath10k: per target config of max_num_peers
  ath10k: DMA related fixes for high latency devices
  ath10k: various fixes for high latency devices
  ath10k: add start_once support
  ath10k: add HTT TX HL ops
  ath10k: add HTT RX HL ops
  ath10k: htt: RX ring config HL support
  ath10k: htt: High latency TX support
  ath10k: htt: High latency RX support
  ath10k: wmi: disable softirq's while calling ieee80211_rx
  ath10k: remove htt pending TX count for high latency
  ath10k: add QCA9377 usb hw_param item
  ath10k: add QCA9377 sdio hw_param item

 drivers/net/wireless/ath/ath10k/ahb.c     |   9 +-
 drivers/net/wireless/ath/ath10k/core.c    | 108 ++++++++++++++++---
 drivers/net/wireless/ath/ath10k/core.h    |  19 ++--
 drivers/net/wireless/ath/ath10k/htc.c     |  19 ++--
 drivers/net/wireless/ath/ath10k/htt.c     |   4 +-
 drivers/net/wireless/ath/ath10k/htt.h     | 136 +++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/htt_rx.c  | 150 +++++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/htt_tx.c  | 173 ++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/hw.h      |  20 ++++
 drivers/net/wireless/ath/ath10k/mac.c     |   2 +-
 drivers/net/wireless/ath/ath10k/pci.c     |  13 +--
 drivers/net/wireless/ath/ath10k/rx_desc.h |  15 +++
 drivers/net/wireless/ath/ath10k/sdio.c    |   8 +-
 drivers/net/wireless/ath/ath10k/txrx.c    |   5 +-
 drivers/net/wireless/ath/ath10k/usb.c     |   7 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |   3 +-
 drivers/net/wireless/ath/ath10k/wmi.c     |   3 +-
 17 files changed, 622 insertions(+), 72 deletions(-)

-- 
2.15.1
