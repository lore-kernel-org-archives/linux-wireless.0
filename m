Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:40215 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab3LCQWL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 11:22:11 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Pull request: ath 20131203
Date: Tue, 3 Dec 2013 18:22:04 +0200
Message-ID: <87txep52hf.fsf@kamboji.qca.qualcomm.com> (sfid-20131203_172215_567660_9CE40234)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

here are ath10k patches which accumulated during the merge window.

Janusz and Marek implemented DFS support to ath10k, but the code is not
enabled yet due to missing cfg80211/mac80211 patches (it will be enabled
in the next pull request). Michal did some device reset fixes and made
it possible for ath10k to share an interrupt with another device. And
lots of smaller fixes from different people.

This time there are two conflicts, one in htc.c and other in mac.c. For
the htc change just delete the hunk. For the mac.c conflict take the
hunk from cfb27d29b61 (the bigger one) and rename
IEEE80211_CHAN_PASSIVE_SCAN to IEEE80211_CHAN_NO_IR. After you have
fixed the conflicts 'git diff' should show you this:

diff --cc drivers/net/wireless/ath/ath10k/htc.c
index edae50b,b068ae0..0000000
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
diff --cc drivers/net/wireless/ath/ath10k/mac.c
index 06fe2b8,7d3d3ac..0000000
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@@ -1356,7 -1482,10 +1482,10 @@@ static int ath10k_update_channel_list(s
                        ch->ht40plus =
                                !(channel->flags & IEEE80211_CHAN_NO_HT40PLUS);
  
+                       ch->chan_radar =
+                               !!(channel->flags & IEEE80211_CHAN_RADAR);
+ 
 -                      passive = channel->flags & IEEE80211_CHAN_PASSIVE_SCAN;
 +                      passive = channel->flags & IEEE80211_CHAN_NO_IR;
                        ch->passive = passive;
  
                        ch->freq = channel->center_freq;

Please let me know if you prefer me to handle the conflict differently
or if there are any other problems with the pull request.

The following changes since commit a1b13b9ad3759dca24c6b721ee026c540a4e6564:

  rt2x00: rt2800pci: use module_pci_driver macro (2013-10-18 14:07:00 -0400)

are available in the git repository at:

  git://github.com/kvalo/ath.git tags/for-linville-20131203

for you to fetch changes up to cfb27d29b61cc32c0bb75f741aeabb9c6e6af742:

  ath10k: fix multi BSSID with WPA on FW 10.1 (2013-12-02 18:51:13 +0200)

----------------------------------------------------------------
Bartosz Markowski (1):
      ath10k: expand the wmi mgmt queue limit to 128

Ben Greear (3):
      ath10k: Initialize list-head on vif creation.
      ath10k: Fix un-initialized debug objects.
      ath10k: add logging to better determine some VIF/STA creation failures

Janusz Dziedzic (1):
      ath10k: add phyerr/dfs handling

Kalle Valo (6):
      ath10k: implement ath10k_pci_soc_read/write32()
      ath10k: add error handling to ath10k_pci_wait()
      ath10k: remove htt rx amsdu clear retry bit hack
      ath10k: don't show MSI registration warnings
      ath10k: make core boot messages more compact
      ath10k: show hardware and firmware info prints only once

Marek Puzyniak (2):
      ath10k: introduce DFS implementation
      ath10k: add debugfs file to control radar events blocking

Michal Kazior (37):
      ath10k: prevent starting monitor without a vdev
      ath10k: add sanity checks for monitor management
      ath10k: fix endianess in prints
      ath10k: fix NSS reporting in RX
      ath10k: fix NULL deref upon early FW crash
      ath10k: fix FW crashes on heavy TX on 10.1.389 AP FW
      ath10k: setup min channel power to a reasonable value
      ath10k: use proper tx power unit
      ath10k: respect power_level values
      ath10k: plug memory leak in wmi mgmt tx worker
      ath10k: plug memory leak on beacon tx
      ath10k: remove ar_pci->ce_count
      ath10k: don't forget to kill fw error tasklet
      ath10k: split tasklet killing function
      ath10k: rename ath10k_pci_reset_target()
      ath10k: make sure to mask all CE irqs
      ath10k: fix ath10k_ce_init() failpath
      ath10k: remove meaningless check
      ath10k: use ath10k_do_pci_wake/sleep
      ath10k: propagate ath10k_ce_disable_interrupts() errors
      ath10k: guard against CE corruption from firmware
      ath10k: re-arrange PCI init code
      ath10k: add and fix some PCI prints
      ath10k: reset device upon stopping/power down
      ath10k: fix core init failpath
      ath10k: allow dynamic bandwidth in hw rate control
      ath10k: clear tx status before submitting to mac80211
      ath10k: don't consume other's shared interrupts
      ath10k: split up pci irq code
      ath10k: don't use interrupts for BMI
      ath10k: decouple ath10k_pci_start_ce()
      ath10k: defer irq registration until hif start()
      ath10k: extract functions for legacy irq handling
      ath10k: re-add support for early fw indication
      ath10k: allow explicit MSI/MSI-X disabling
      ath10k: fix Tx status clearing
      ath10k: fix multi BSSID with WPA on FW 10.1

Wei Yongjun (1):
      ath10k: fix possible memory leak in ath10k_pci_probe()

 drivers/net/wireless/ath/ath10k/ce.c     |   53 +-
 drivers/net/wireless/ath/ath10k/ce.h     |    2 +-
 drivers/net/wireless/ath/ath10k/core.c   |   43 +-
 drivers/net/wireless/ath/ath10k/core.h   |   23 +-
 drivers/net/wireless/ath/ath10k/debug.c  |   94 ++++
 drivers/net/wireless/ath/ath10k/debug.h  |    6 +
 drivers/net/wireless/ath/ath10k/htc.c    |   31 +-
 drivers/net/wireless/ath/ath10k/htt.c    |    4 +-
 drivers/net/wireless/ath/ath10k/htt.h    |    1 +
 drivers/net/wireless/ath/ath10k/htt_rx.c |   25 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c |   11 +-
 drivers/net/wireless/ath/ath10k/hw.h     |    1 +
 drivers/net/wireless/ath/ath10k/mac.c    |  316 ++++++++++--
 drivers/net/wireless/ath/ath10k/pci.c    |  791 +++++++++++++++++++-----------
 drivers/net/wireless/ath/ath10k/pci.h    |   14 +-
 drivers/net/wireless/ath/ath10k/txrx.c   |    6 +-
 drivers/net/wireless/ath/ath10k/wmi.c    |  302 +++++++++++-
 drivers/net/wireless/ath/ath10k/wmi.h    |   96 +++-
 18 files changed, 1413 insertions(+), 406 deletions(-)

-- 
Kalle Valo
