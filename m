Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:33542 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750908AbdAMVfY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 16:35:24 -0500
Received: by mail-lf0-f67.google.com with SMTP id x1so1724428lff.0
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jan 2017 13:35:23 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC 00/10] ath10k usb support
Date: Fri, 13 Jan 2017 22:34:59 +0100
Message-Id: <1484343309-6327-1-git-send-email-erik.stromdahl@gmail.com> (sfid-20170113_223527_655099_D8028D32)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds usb support to ath10k.

The target device used during development was a Linksys WUSB6100M
based on QCA9377.

I have tried to verify that the patches have not broken the existing
PCIe support since some of the patches affect the generic code as well.
To this end I have used a QCA9880 PCIe device operating in STA mode.

This patch series is depending on my previous sdio RFC (currently
version 3) since both these implementations share a lot of common
code. Hence, the sdio patches must be applied before these patches
can be applied!

* overview of patches *

patch 1 adds some usb definitions needed by the HIF layer.

patch 2 contains the actual usb HIF implementation.

patch 3 adds a is_high_latency check functionality

patch 4 introduces a new mechanism for fw fetch where the bus name is
used to determine which files to fetch (so we can have different fw for
usb and sdio).

patch 5 adds a HL version of the RX ring config.
This patch is applicable for sdio as well.

patch 6 sets the AMPDU and AMSDU limit to 1 for HL interfaces.
I believe this is the same thing as disabling frame aggregation but
I am not entirely sure (perhaps it just disables aggregation from
target to host). The reason for this patch is to have a simple setup
as possible. I have tried without this patch and the behavior is
identical so perhaps it should be removed from the series.

patch 7 adds more members to the ath10k_hw_params structure. These is
done in order to make it easier to separate HL config from LL config.
Some of stuff in here could potentially be added as elements in the
firmware file.

patch 8 adds "start once" functionality. It is used to leave the target
running after the BMI init phase in ath10k_core_probe_fw.
Could potentially be added as an element in the firmware file.

The last two patches (9 and 10) adds high latency RX and TX support.
These patches are applicable for sdio as well.

* testing *

The following functionality have been tested:

- connection to an 802.11ac AP with WPA2 PSK security.
- dhcp lease of ipv4 address
- pinging of access point and a few other devices on my home network
- TX/RX of TCP and UDP messages using netcat

UDP and TCP RX/TX is unfortunately not stable.
Currently I am only capable of receiving ~2.7 Mbytes over TCP before
the device stops receiving.

My RX/TX test looks like this:

Computer A (receiver):
nc -l -p 12345 > /tmp/random-out

Computer B (transmitter):
time nc -w 3 192.168.1.233 12345 < random-test-file

192.168.1.233 was the IPv4 address the WUSB6100M was assigned on my
home network.

The TCP RX data is identical to the TX data (no data is lost) but the
receiver stops receiving after ~2.7 Mbytes, so the RX data (/tmp/random-out
in my example) will be a truncated version of the TX file (random-test-file)

Adding a "-u" flag to netcat will do the same with UDP instead of TCP.

IMPORTANT:
It is possible to make the fw crash if an unsupported command or a
command with an unsupported setting is issued. This was the initial
problem I had with a crashing firmware after the RX ring config.
In this particular case the problem was related to an invalid init
message (containing an invalid maximum number of peers setting). There
could be more of this stuff in there that has not yet been fixed.
Depending on how wpa_supplicant etc. is configured there is a possibility
that the usb device will receive an unsupported command and crash.
It this happens, please enable logging and post the logs on the ath10k
mailing list.

* usb firmware *

Special firmware for usb is needed.
Linksys provide firmware for the QCA9377 version here:

http://www.linksys.com/us/support-article?articleNum=198580

The firmware must be converted into ath10k firmware using the below
command:

ath10k-fwencoder --create \
--otp=otp_AR6320.bin \
--firmware=athwlan_AR6320.bin \
--set-wmi-op-version=tlv \
--set-htt-op-version=tlv \
--set-fw-api=5 \
--features=ignore-otp-result

The firmware should be named firmware-usb-5.bin and should be placed
in /lib/firmware/ath10k/QCA9377/hw1.0

A board file is also needed:

cd /lib/firmware/ath10k/QCA9377/hw1.0
ln -s eeprom_qca9377_7_1p1_Robin_clpc_XXX.bin board-usb.bin

Pre-converted firmware can be obtained from my github fork of
ath10k-firmware:

https://github.com/erstrom/ath10k-firmware.git
branch: usb

Erik Stromdahl (10):
  ath10k: various usb related definitions
  ath10k: usb support
  ath10k: high_latency detection
  ath10k: new fw fetch functionality
  ath10k: htt: RX ring config HL support
  ath10k: disable frame aggregation for high latency
  ath10k: per target configurablity of various items
  ath10k: add start_once support
  ath10k: htt: High latency TX support
  ath10k: htt: High latency RX support

 drivers/net/wireless/ath/ath10k/Kconfig   |    6 +
 drivers/net/wireless/ath/ath10k/Makefile  |    3 +
 drivers/net/wireless/ath/ath10k/core.c    |  179 +++--
 drivers/net/wireless/ath/ath10k/core.h    |   17 +-
 drivers/net/wireless/ath/ath10k/debug.h   |    2 +
 drivers/net/wireless/ath/ath10k/htt.c     |    5 +-
 drivers/net/wireless/ath/ath10k/htt.h     |   61 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c  |   95 ++-
 drivers/net/wireless/ath/ath10k/htt_tx.c  |  123 +++-
 drivers/net/wireless/ath/ath10k/hw.h      |   33 +
 drivers/net/wireless/ath/ath10k/mac.c     |    5 +-
 drivers/net/wireless/ath/ath10k/rx_desc.h |   15 +
 drivers/net/wireless/ath/ath10k/usb.c     | 1125 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/usb.h     |  128 ++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |    4 +-
 15 files changed, 1724 insertions(+), 77 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath10k/usb.c
 create mode 100644 drivers/net/wireless/ath/ath10k/usb.h

-- 
2.7.4
