Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:20452 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396Ab1CNR7O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 13:59:14 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Mar 2011 10:58:51 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 00/38] ath6kl: remove typedefs part II
Date: Mon, 14 Mar 2011 10:58:34 -0700
Message-ID: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greg, here is my second cleanup series for ath6kl. This series addresses
more typedef removals. Given that I have so many and they all do the
same, and are tested I'm submitting them all in one series. I can really
split it but you can just do that yourself if you believe this is really
necessary. Either way they all go tested.

We still have some more typedefs left after this so that'll go in some
other series. This applies on top of Ilia Mirkin's submitted but not
yet merged patch titled, "staging: ath6kl: Remove NULL check before kfree"

Luis R. Rodriguez (38):
  ath6kl: remove-tyepdef DL_LIST and PDL_LIST pointer
  ath6kl: remove-typedef GMBOX_PROTO_HCI_UART
  ath6kl: remove-typedef HCI_TRANSPORT_CALLBACKS
  ath6kl: remove-typedef HCI_TRANSPORT_CONFIG_INFO
  ath6kl: remove-typedef HCI_TRANSPORT_MISC_HANDLES
  ath6kl: remove-typedef HCI_TRANSPORT_PROPERTIES
  ath6kl: remove-typedef HIF_DEVICE_IRQ_YIELD_PARAMS
  ath6kl: remove-typedef HIF_DEVICE_MBOX_INFO
  ath6kl: remove-typedef HIF_DEVICE_OS_DEVICE_INFO
  ath6kl: remove-typedef HIF_DEVICE_SCATTER_SUPPORT_INFO
  ath6kl: remove-typedef HIF_MBOX_PROPERTIES
  ath6kl: remove-typedef HIF_PENDING_EVENTS_INFO
  ath6kl: remove-typedef HIF_SCATTER_ITEM
  ath6kl: remove-typedef HIF_SCATTER_REQ_PRIV
  ath6kl: remove-typedef HIF_SCATTER_REQ
  ath6kl: remove-typedef HTC_CONTROL_BUFFER
  ath6kl: remove-typedef HTC_ENDPOINT
  ath6kl: remove-typedef HTC_ENDPOINT_CREDIT_DIST
  ath6kl: remove-typedef HTC_ENDPOINT_STATS
  ath6kl: remove-typedef HTC_EP_CALLBACKS
  ath6kl: remove-typedef HTC_FRAME_HDR
  ath6kl: remove-typedef HTC_INIT_INFO
  ath6kl: remove-typedef HTC_PACKET
  ath6kl: remove-typedef HTC_PACKET_QUEUE
  ath6kl: remove-typedef HTC_RX_PACKET_INFO
  ath6kl: remove-typedef HTC_SERVICE_CONNECT_REQ
  ath6kl: remove-typedef HTC_SERVICE_CONNECT_RESP
  ath6kl: remove-typedef HTC_TARGET
  ath6kl: remove-typedef HTC_TX_PACKET_INFO
  ath6kl: remove-typedef OSBUF_HOLD_Q
  ath6kl: remove-typedef PSCmdPacket
  ath6kl: remove-typedef RXTID
  ath6kl: remove-typedef RXTID_STATS
  ath6kl: remove-typedef ST_PS_DATA_FORMAT
  ath6kl: remove-typedef ST_READ_STATUS
  ath6kl: remove-typedef WINDOW_SNAPSHOT
  ath6kl: remove-typedef AR_SOFTC_T
  ath6kl: remove-typedef HIF_DEVICE

 drivers/staging/ath6kl/bmi/include/bmi_internal.h  |    4 +-
 drivers/staging/ath6kl/bmi/src/bmi.c               |   42 ++--
 .../staging/ath6kl/hif/common/hif_sdio_common.h    |    2 +-
 .../hif/sdio/linux_sdio/include/hif_internal.h     |   30 +-
 .../staging/ath6kl/hif/sdio/linux_sdio/src/hif.c   |   92 +++---
 .../ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c   |   40 ++--
 drivers/staging/ath6kl/htc2/AR6000/ar6k.c          |   48 ++--
 drivers/staging/ath6kl/htc2/AR6000/ar6k.h          |   28 +-
 drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c   |   18 +-
 drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c    |   18 +-
 .../ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c        |  102 ++++----
 drivers/staging/ath6kl/htc2/htc.c                  |   60 ++--
 drivers/staging/ath6kl/htc2/htc_internal.h         |   84 +++---
 drivers/staging/ath6kl/htc2/htc_recv.c             |  142 +++++-----
 drivers/staging/ath6kl/htc2/htc_send.c             |  120 ++++----
 drivers/staging/ath6kl/htc2/htc_services.c         |   38 ++--
 drivers/staging/ath6kl/include/ar3kconfig.h        |    4 +-
 drivers/staging/ath6kl/include/ar6000_diag.h       |   12 +-
 drivers/staging/ath6kl/include/bmi.h               |   34 ++--
 .../staging/ath6kl/include/common/epping_test.h    |    2 +-
 drivers/staging/ath6kl/include/common/htc.h        |    8 +-
 drivers/staging/ath6kl/include/common_drv.h        |   28 +-
 drivers/staging/ath6kl/include/dl_list.h           |   26 +-
 drivers/staging/ath6kl/include/hci_transport_api.h |   26 +-
 drivers/staging/ath6kl/include/hif.h               |   87 +++---
 drivers/staging/ath6kl/include/htc_api.h           |   70 +++---
 drivers/staging/ath6kl/include/htc_packet.h        |   46 ++--
 drivers/staging/ath6kl/miscdrv/ar3kconfig.c        |   12 +-
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c   |    4 +-
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c   |   28 +-
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.h   |    8 +-
 drivers/staging/ath6kl/miscdrv/common_drv.c        |   38 ++--
 drivers/staging/ath6kl/miscdrv/credit_dist.c       |   22 +-
 drivers/staging/ath6kl/os/linux/ar6000_android.c   |    2 +-
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |  298 ++++++++++----------
 drivers/staging/ath6kl/os/linux/ar6000_pm.c        |   18 +-
 drivers/staging/ath6kl/os/linux/ar6000_raw_if.c    |   26 +-
 drivers/staging/ath6kl/os/linux/ar6k_pal.c         |   12 +-
 drivers/staging/ath6kl/os/linux/cfg80211.c         |   50 ++--
 drivers/staging/ath6kl/os/linux/eeprom.c           |    6 +-
 .../staging/ath6kl/os/linux/export_hci_transport.c |   22 +-
 drivers/staging/ath6kl/os/linux/hci_bridge.c       |   72 +++---
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |   48 ++--
 drivers/staging/ath6kl/os/linux/include/cfg80211.h |   10 +-
 .../ath6kl/os/linux/include/export_hci_transport.h |   16 +-
 drivers/staging/ath6kl/os/linux/ioctl.c            |  116 ++++----
 drivers/staging/ath6kl/os/linux/netbuf.c           |    4 +-
 drivers/staging/ath6kl/os/linux/wireless_ext.c     |   66 +++---
 drivers/staging/ath6kl/reorder/aggr_rx_internal.h  |   27 +-
 drivers/staging/ath6kl/reorder/rcv_aggr.c          |   42 ++--
 50 files changed, 1078 insertions(+), 1080 deletions(-)

-- 
1.7.4.15.g7811d

