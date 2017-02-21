Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:36028 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753691AbdBUQQO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 11:16:14 -0500
Received: by mail-lf0-f67.google.com with SMTP id 90so4026380lfr.3
        for <linux-wireless@vger.kernel.org>; Tue, 21 Feb 2017 08:16:13 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v4 00/21] ath10k sdio and usb support
Date: Tue, 21 Feb 2017 17:15:20 +0100
Message-Id: <1487693741-10042-1-git-send-email-erik.stromdahl@gmail.com> (sfid-20170221_171647_626991_A7123A91)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the 4th version of the sdio and usb RFC patch series.
I have combined the sdio and usb patches into one series since they are
inseparable (both series must be applied in order to have a working system).

The main difference since last version (v3) is that QCA9377 sdio support
was added. I have also fixed a few minor issues in the sdio HIF layer.

*Current status*

The sdio and usb HIF layers seem to work fine. I am able to download fw,
connect WMI and HTT services and so on.

I have been running it for a while now and so far I have not encountered
any major issues.

The biggest issue right now is that the board setup of high latency devices
is very different in qcacld than for ath10k. I have a working qcacld
system on a 4.1 kernel that I am using a as a reference. I am basically
diffing the bus traffic between qcacld and ath10k to see what the
differences are and then try to incorporate the missing stuff in ath10k.
Some WMI messages used by qcacld are not present in ath10k, and a few
others are different.

An example is the WMI init message:

>From qcacld:
[539.662779]    WMI msg id:      1,  WMI_INIT_CMDID
WmiTlvInitCmd:
  TlvHeader:
    length: 0x1c
    tag: 0x4a (WMI_TLV_TAG_STRUCT_INIT_CMD)
  WmiTlvAbiVersion:
    abi_ver0: 0x1000000
    abi_ver1: 0xa8                                    <- DIFFERENT
    abi_ver_ns0: 0x5f414351
    abi_ver_ns1: 0x4c4d
    abi_ver_ns2: 0x0
    abi_ver_ns3: 0x0
  num_host_mem_chunks: 0x0
WmiTlvResourceConfig:
  TlvHeader:
    length: 0xac                                      <- DIFFERENT
    tag: 0x4b (WMI_TLV_TAG_STRUCT_RESOURCE_CONFIG)
    ...

>From ath10k:
[51.312300]     WMI msg id:      1,  WMI_INIT_CMDID
WmiTlvInitCmd:
  TlvHeader:
    length: 0x1c
    tag: 0x4a (WMI_TLV_TAG_STRUCT_INIT_CMD)
  WmiTlvAbiVersion:
    abi_ver0: 0x1000000
    abi_ver1: 0x35                                    <- DIFFERENT
    abi_ver_ns0: 0x5f414351
    abi_ver_ns1: 0x4c4d
    abi_ver_ns2: 0x0
    abi_ver_ns3: 0x0
  num_host_mem_chunks: 0x0
WmiTlvResourceConfig:
  TlvHeader:
    length: 0x9c                                      <- DIFFERENT
    tag: 0x4b (WMI_TLV_TAG_STRUCT_RESOURCE_CONFIG)
    ...

Notice the difference in abi_ver1 and the WmiTlvResourceConfig length.
Apparently qcacld uses a newer version of the wmi tlv protocol.
I get the feeling that the high latency devices are intended to be used
with a newer WMI protocol version than ath10k supports.

The usb firmware seems to be more capable of handling the older wmi format
than the sdio firmware (I am able to connect to my AP and lease an IP
address with the usb device but not with the sdio device using exactly the
same setup)

I think these issues will have to be addressed in a future patch series.

The usb stuff is more or less in the same state as previously, nothing
has happened there except for a few checkpatch fixes.

Erik Stromdahl (21):
  ath10k: htc: made static function public
  ath10k: htc: rx trailer lookahead support
  ath10k: htc: move htc ctrl ep connect to htc_init
  ath10k: htc: refactorization
  ath10k: various sdio related definitions
  ath10k: sdio support
  ath10k: add sdio extra initializations
  ath10k: sdio get target info
  ath10k: htc: ready_ext msg support
  ath10k: various usb related definitions
  ath10k: usb support
  ath10k: high_latency detection
  ath10k: different fw file names for usb and sdio
  ath10k: htt: RX ring config HL support
  ath10k: per target configurablity of various items
  ath10k: add start_once support
  ath10k: htt: High latency TX support
  ath10k: htt: High latency RX support
  ath10k: add QCA9377 usb hw_param item
  ath10k: add QCA9377 sdio hw_param item
  ath10k: dma fixes for high latency devices

 drivers/net/wireless/ath/ath10k/Kconfig     |   12 +
 drivers/net/wireless/ath/ath10k/Makefile    |    6 +
 drivers/net/wireless/ath/ath10k/bmi.c       |   70 +
 drivers/net/wireless/ath/ath10k/bmi.h       |    2 +
 drivers/net/wireless/ath/ath10k/core.c      |  176 ++-
 drivers/net/wireless/ath/ath10k/core.h      |   18 +-
 drivers/net/wireless/ath/ath10k/debug.h     |    4 +
 drivers/net/wireless/ath/ath10k/htc.c       |  254 +++-
 drivers/net/wireless/ath/ath10k/htc.h       |   39 +-
 drivers/net/wireless/ath/ath10k/htt.c       |    5 +-
 drivers/net/wireless/ath/ath10k/htt.h       |   57 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c    |   98 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c    |  126 +-
 drivers/net/wireless/ath/ath10k/hw.h        |   83 ++
 drivers/net/wireless/ath/ath10k/mac.c       |    5 +-
 drivers/net/wireless/ath/ath10k/rx_desc.h   |   15 +
 drivers/net/wireless/ath/ath10k/sdio.c      | 2138 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/sdio.h      |  263 ++++
 drivers/net/wireless/ath/ath10k/targaddrs.h |   24 +
 drivers/net/wireless/ath/ath10k/txrx.c      |    5 +-
 drivers/net/wireless/ath/ath10k/usb.c       | 1125 ++++++++++++++
 drivers/net/wireless/ath/ath10k/usb.h       |  128 ++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c   |    4 +-
 23 files changed, 4529 insertions(+), 128 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath10k/sdio.c
 create mode 100644 drivers/net/wireless/ath/ath10k/sdio.h
 create mode 100644 drivers/net/wireless/ath/ath10k/usb.c
 create mode 100644 drivers/net/wireless/ath/ath10k/usb.h

-- 
2.7.4
