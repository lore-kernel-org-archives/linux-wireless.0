Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:37163 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751254AbdIQTkZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Sep 2017 15:40:25 -0400
Received: by mail-lf0-f65.google.com with SMTP id q132so3528870lfe.4
        for <linux-wireless@vger.kernel.org>; Sun, 17 Sep 2017 12:40:24 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v3 00/11] ath10k high latency
Date: Sun, 17 Sep 2017 21:40:02 +0200
Message-Id: <20170917194013.8658-1-erik.stromdahl@gmail.com> (sfid-20170917_214031_801393_8D3BF446)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the third version of the high latency patches (stuff common for
usb and sdio).

One major difference between this version and the previous is that the
num_pending_tx counter has been disabled for high latency devices (last patch).

This fixes the previous issue with the halted USB RX.
I have tested these patches with a Linksys WUSB6100M and it looks
much better than the previous version.

High latency devices does not seem to send HTT_T2H_MSG_TYPE_TX_COMPL_IND's
to the host for outgoing packets, resulting in a transmit stop when the
upper limit of num_pending_tx is reached.

The qcacld driver mentions that the TX_COMPL_IND can be disabled for HL
devices in order to achieve better throughput:

/*
 * HTT option TLV for specifying whether HL systems should indicate
 * over-the-air tx completion for individual frames, or should instead
 * send a bulk TX_CREDIT_UPDATE_IND except when the host explicitly
 * requests an OTA tx completion for a particular tx frame.
 * This option does not apply to LL systems, where the TX_COMPL_IND
 * is mandatory.
 * This option is primarily intended for HL systems in which the tx frame
 * downloads over the host --> target bus are as slow as or slower than
 * the transmissions over the WLAN PHY.  For cases where the bus is faster
 * than the WLAN PHY, the target will transmit relatively large A-MPDUs,
 * and consquently will send one TX_COMPL_IND message that covers several
 * tx frames.  For cases where the WLAN PHY is faster than the bus,
 * the target will end up transmitting very short A-MPDUs, and consequently
 * sending many TX_COMPL_IND messages, which each cover a very small number
 * of tx frames.
 * The HL_SUPPRESS_TX_COMPL_IND TLV can be sent by the host to the target as
 * a suffix to the VERSION_REQ message to request whether the host desires to
 * use TX_CREDIT_UPDATE_IND rather than TX_COMPL_IND.  The target can then
 * send a HTT_SUPPRESS_TX_COMPL_IND TLV to the host as a suffix to the
 * VERSION_CONF message to confirm whether TX_CREDIT_UPDATE_IND will be used
 * rather than TX_COMPL_IND.  TX_CREDIT_UPDATE_IND shall only be used if the
 * host sends a HL_SUPPRESS_TX_COMPL_IND TLV requesting use of
 * TX_CREDIT_UPDATE_IND, and the target sends a HL_SUPPRESS_TX_COMPLE_IND TLV
 * back to the host confirming use of TX_CREDIT_UPDATE_IND.
 * Lack of a HL_SUPPRESS_TX_COMPL_IND TLV from either host --> target or
 * target --> host is equivalent to a HL_SUPPRESS_TX_COMPL_IND that
 * explicitly specifies HL_ALLOW_TX_COMPL_IND in the value payload of the
 * TLV.
 */

I am suspecting this is the default behavior in the firmware.

I have tried a simple wget test where I download a Linux kernel tar ball
from kernel.org. I got the below results:

wget --no-check-certificate \
https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.11.4.tar.xz

2017-09-17 16:46:20 (13.3 MB/s) - 'linux-4.11.4.tar.xz' saved
[95549228/95549228]

13.3 MB/s is a fairly OK result since I have a 100 Mbit/s internet
connection.

Changes since v2:

- Disabled htt num_pending_tx counter for HL.
- Fixed transmit flags for HL HTT TX.
- Proper marking of aggregated frames in the HL HTT RX handler.
- A few other minor fixes

Erik Stromdahl (11):
  ath10k: high_latency detection
  ath10k: htt: RX ring config HL support
  ath10k: per target configurablity of various items
  ath10k: add start_once support
  ath10k: htt: High latency TX support
  ath10k: htt: High latency RX support
  ath10k: various fixes for high latency devices
  ath10k: add QCA9377 usb hw_param item
  ath10k: add QCA9377 sdio hw_param item
  ath10k: wmi: disable softirq's while calling ieee80211_rx
  ath10k: remove htt pending TX count for high latency

 drivers/net/wireless/ath/ath10k/core.c    | 128 +++++++++++++++++++-----
 drivers/net/wireless/ath/ath10k/core.h    |  16 +--
 drivers/net/wireless/ath/ath10k/htc.c     |  19 ++--
 drivers/net/wireless/ath/ath10k/htt.c     |   5 +-
 drivers/net/wireless/ath/ath10k/htt.h     |  57 ++++++++++-
 drivers/net/wireless/ath/ath10k/htt_rx.c  | 122 ++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/htt_tx.c  | 157 +++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/hw.h      |  30 ++++++
 drivers/net/wireless/ath/ath10k/mac.c     |   5 +-
 drivers/net/wireless/ath/ath10k/rx_desc.h |  15 +++
 drivers/net/wireless/ath/ath10k/txrx.c    |   5 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |   4 +-
 drivers/net/wireless/ath/ath10k/wmi.c     |   3 +
 13 files changed, 513 insertions(+), 53 deletions(-)

-- 
2.14.1
