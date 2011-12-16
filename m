Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34871 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab1LPTnN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 14:43:13 -0500
Message-ID: <4EEB9F46.7040304@qca.qualcomm.com> (sfid-20111216_204317_008962_EA5B6AD3)
Date: Fri, 16 Dec 2011 21:43:02 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Pull request: ath6kl 20111216
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

please pull latest changes from ath6kl.git. There are again quite a few
changes, I should have sent the pull request a lot earlier. Sorry about
that.

Major changes are support for the new ar6004 chipset (SDIO is complete,
USB is not fully supported yet but will be soon), scheduled scan,
enablement of multivif and WAPI fixes.

I today merged latest wireless-next as there was a small conflict in
init.c. Let me know if there are any problems.

Kalle

The following changes since commit 5bd5e9a6ae5137a61d0b5c277eac61892d89fc4f:

  ath9k: Support RSN Mesh (2011-12-16 09:30:43 -0500)

are available in the git repository at:
  git://github.com/kvalo/ath6kl.git for-linville

Aarthi Thiruvengadam (2):
      ath6kl: Fix target minimum length requirement for
WMI_SEND_PROBE_RESPONSE_CMDID
      ath6kl: support for P2P mgmt operations on station interface

Arik Nemtsov (1):
      ath6kl: indicate probe-resp offload support

Dai Shuibing (3):
      ath6kl: Add support for configuring SMS4 keys
      ath6kl: Allow SMS4 to be configured in AP mode
      ath6kl: Indicate WAPI IE from (Re)Association Request frame

Dan Carpenter (2):
      ath6kl: unlock if ath6kl_cfg80211_connect() fails
      ath6kl: use a larger buffer for debug output

Jouni Malinen (1):
      ath6kl: Use delayed key configuration for WAPI in AP mode

Kalle Valo (29):
      ath6kl: move bmi calls to hif driver
      ath6kl: change bmi sizes being configurable by HIF
      ath6kl: move diag commands to hif driver
      ath6kl: update ar6004 definitions
      ath6kl: firmware boot fixes for ar6004
      ath6kl: add hif_type
      ath6kl: add USB support
      ath6kl: disable HTC for USB devices
      ath6kl: enable USB support
      ath6kl: remove hw version related parameter defines
      ath6kl: move hw version related to parameters to struct
      ath6kl: add board address to struct ath6kl_hw
      ath6kl: add firmware IE for board data address
      ath6kl: add name field to struct ath6kl_hw
      ath6kl: use hardware version names consistently
      ath6kl: add ar6004 firmwares to sdio module
      ath6kl: add firmware filename info to struct ath6kl_hw
      ath6kl: make maximum number of vifs runtime configurable
      ath6kl: add firmware IE for maximum number of vifs
      Merge remote branch 'wireless-next/master' into ath6kl-next
      ath6kl: remove unused sc_params from struct ath6kl
      ath6kl: cleanup ath6kl_priv()
      ath6kl: remove a workaround from ath6kl_cfg80211_stop()
      ath6kl: call ath6kl_cfg80211_stop() from ath6kl_close()
      ath6kl: implement ath6kl_cfg80211_stop_all()
      ath6kl: fix value of WOW_FILTER_SSID
      ath6kl: fix reading of FW IE capabilities
      ath6kl: implement scheduled scan
      Merge remote branch 'wireless-next/master' into ath6kl-next
Luis R. Rodriguez (1):
      ath6kl: fix ath6kl's set tx power

Naveen Gangadharan (1):
      ath6kl: AR6004 SDIO support

Raja Mani (3):
      ath6kl: Fix cfg80211 warning while starting IBSS mode
      ath6kl: Clear WPS ctrl flag if zero length IE is received from
cfg80211
      ath6kl: Use mutex to protect dma buffer in sync read write

Ryan Hsu (1):
      ath6kl: Support different uart_tx pin and refclk configuration

Vasanthakumar Thiagarajan (9):
      ath6kl: Fix accessing wrong skb->data in ath6kl_tx_complete()
      ath6kl: Fix packet drop when ath6kl_cookie runs out
      ath6kl: Fix bug in setting default key index for tx in AP mode
      ath6kl: Fix bug in setting dot11_auth_mode in AP mode
      ath6kl: Fix AP mode operation after interface down/up
      ath6kl: Remove modparam multi_norm_if_support
      ath6kl: Find ar->max_norm_iface in firmware IE parsing
      ath6kl: Enable multiple vif support
      ath6kl: Increase the maximum number of connections in AP mode

 drivers/net/wireless/ath/ath6kl/Kconfig    |   25 ++-
 drivers/net/wireless/ath/ath6kl/Makefile   |   37 ++-
 drivers/net/wireless/ath/ath6kl/bmi.c      |  245 ++++-------------
 drivers/net/wireless/ath/ath6kl/bmi.h      |    6 -
 drivers/net/wireless/ath/ath6kl/cfg80211.c |  382 +++++++++++++++++++------
 drivers/net/wireless/ath/ath6kl/cfg80211.h |    6 +-
 drivers/net/wireless/ath/ath6kl/common.h   |    1 +
 drivers/net/wireless/ath/ath6kl/core.h     |  109 +++++--
 drivers/net/wireless/ath/ath6kl/debug.c    |    4 +-
 drivers/net/wireless/ath/ath6kl/debug.h    |    1 +
 drivers/net/wireless/ath/ath6kl/hif-ops.h  |   30 ++
 drivers/net/wireless/ath/ath6kl/hif.c      |    5 +
 drivers/net/wireless/ath/ath6kl/hif.h      |    5 +
 drivers/net/wireless/ath/ath6kl/htc.c      |   10 +-
 drivers/net/wireless/ath/ath6kl/init.c     |  380 +++++++++++++++----------
 drivers/net/wireless/ath/ath6kl/main.c     |  125 ++-------
 drivers/net/wireless/ath/ath6kl/sdio.c     |  329 ++++++++++++++++++++-
 drivers/net/wireless/ath/ath6kl/target.h   |   16 +-
 drivers/net/wireless/ath/ath6kl/txrx.c     |   20 +-
 drivers/net/wireless/ath/ath6kl/usb.c      |  431
++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.c      |  152 ++++++++++-
 drivers/net/wireless/ath/ath6kl/wmi.h      |  143 +++++++++-
 22 files changed, 1809 insertions(+), 653 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath6kl/usb.c

