Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:24223 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbaBQQFH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 11:05:07 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qca.qualcomm.com>,
	<ath10k@lists.infradead.org>
Subject: Pull request: ath 20140217
Date: Mon, 17 Feb 2014 18:05:01 +0200
Message-ID: <87txbx3etu.fsf@kamboji.qca.qualcomm.com> (sfid-20140217_170512_890970_2288F07D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

here's a new pull request for ath6kl and ath10k. 

For ath10k Alexander did some cleanup to PCI error cases and switched
ath10k to use pci_enable_msi_range(). Michal implemented AP CSA support
and sta_rc_update() operation. I enabled firmware "STA quick kickout"
functionality for faster detection of disappeared clients.

Also there are lots of small fixes to everywhere from various people.

For ath6kl Julien did two small USB related fixes.

Please let me know if there are any problmes

The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:

  Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)

are available in the git repository at:

  git://github.com/kvalo/ath.git for-linville

for you to fetch changes up to 9797febc4cc112869b19a110f70e0dedb1bb63d6:

  ath10k: implement sta_rc_update() (2014-02-15 08:49:02 +0200)

----------------------------------------------------------------
Alexander Gordeev (3):
      ath10k: Get rid of superfluous call to pci_disable_msi()
      ath10k: Disable MSI in case IRQ configuration is unknown
      ath10k: Use pci_enable_msi_range()

Bartosz Markowski (2):
      ath10k: remove excessive rx msdu len check
      ath10k: AP: handle HT station which does not have HT RX MCS

Ben Greear (4):
      ath10k:  Print out firmware feature bits from IE.
      ath10k: print out size of wmi-ready-event message
      ath10k: add more debugging for receive errors
      ath10k: better tx/rx debugging

Chun-Yeow Yeoh (1):
      ath10k: fix the printing of 10.x FW version when FW crashed

Janusz Dziedzic (3):
      ath10k: enable wmi ps peer param command for 10.x FW
      ath10k: AP mode, set UAPSD params correctly
      ath10k: pass frames with invalid peer status to upper layer

Julien Massot (2):
      ath6kl: increase usb rx buffer size to 4096
      ath6kl: set rx urb count threshold to 1

Kalle Valo (5):
      ath10k: enable firmware STA quick kickout
      Merge remote-tracking branch 'wireless-next/master' into ath-next
      ath10k: fix alignment in ath10k_dbg()
      ath: remove camel case from struct reg_dmn_pair_mapping
      ath10k: release conf_mutex if vdev_start() fails

Marek Kwaczynski (1):
      ath10k: Set proper nss value for the peer

Marek Puzyniak (3):
      ath10k: configure access category for arp
      ath10k: refactor suspend/resume functions
      ath10k: suspend hardware before reset

Michal Kazior (7):
      ath10k: implement channel switching
      ath10k: implement AP CSA
      ath10k: implement and use new beacon method
      ath10k: properly return err from start()
      ath10k: fix device initialization routine
      ath10k: fix SMPS support
      ath10k: implement sta_rc_update()

 drivers/net/wireless/ath/ath.h           |    2 +-
 drivers/net/wireless/ath/ath10k/core.c   |   36 +-
 drivers/net/wireless/ath/ath10k/core.h   |   47 ++-
 drivers/net/wireless/ath/ath10k/debug.h  |    2 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c |   35 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c |    4 +-
 drivers/net/wireless/ath/ath10k/hw.h     |    6 +
 drivers/net/wireless/ath/ath10k/mac.c    |  634 +++++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath10k/pci.c    |  147 ++++++-
 drivers/net/wireless/ath/ath10k/txrx.c   |    4 +-
 drivers/net/wireless/ath/ath10k/wmi.c    |  118 ++++--
 drivers/net/wireless/ath/ath10k/wmi.h    |   34 +-
 drivers/net/wireless/ath/ath6kl/usb.c    |    6 +-
 drivers/net/wireless/ath/ath6kl/wmi.c    |    4 +-
 drivers/net/wireless/ath/regd.c          |   10 +-
 15 files changed, 895 insertions(+), 194 deletions(-)

-- 
Kalle Valo
