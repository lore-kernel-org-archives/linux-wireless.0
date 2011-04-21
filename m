Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34686 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab1DUA7z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2011 20:59:55 -0400
Date: Wed, 20 Apr 2011 22:00:13 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: pull request: bluetooth-2.6 2011-04-20
Message-ID: <20110421010013.GA9392@joana>
References: <20110420170432.GA2301@joana>
 <20110420202015.GA2311@joana>
 <20110421001836.GB2437@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110421001836.GB2437@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* John W. Linville <linville@tuxdriver.com> [2011-04-20 20:18:37 -0400]:

> On Wed, Apr 20, 2011 at 05:20:15PM -0300, Gustavo F. Padovan wrote:
> > Hi John,
> > 
> > * Gustavo F. Padovan <padovan@profusion.mobi> [2011-04-20 14:04:32 -0300]:
> > 
> > > Hi John,
> > > 
> > > Four small fixes for 2.6.39. An incorrect refcnt balance for hci connection by
> > > Ville Tervo, a warning fix in the command timer by Vinicius Gomes, an ERTM
> > > fix by Ruiyi Zhang, and SCO synchronization fix by Luiz Augusto von Dentz.
> > > 
> > > Please pull or let me know any problems. Thanks.
> > 
> > Hold on with the pull! I've found a merge conflict with -next. (I tested the
> > merge with --dry-run, but it doesn't check for check conflicts). I'll do the
> > right thing now and send a new pull request to you soon. 
> > 
> > Regards,
> > 
> > -- 
> > Gustavo F. Padovan
> > http://profusion.mobi
> 
> FWIW, I already did the pull into wireless-2.6 and pushed it out
> for some soak time.  If there is a merge conflict with -next, then
> please let me know how to fix it and I'll pull wireless-2.6 into
> wireless-next-2.6 as soon as possible to eliminate the conflict.

There was 3 conflicts. I fixed them by pulling wireless-2.6 into
bluetooth-next-2.6. Now you work is just have to pull my tree and everything
will be fine again. :-)
Here is the git pull-request output of what you are going to pull from
bluetooth-next-2.6. You are basically pulling wireless-2.6, I didn't add any 
new commit to the tree., it just wireless-2.6 with the conflict solved.

Thanks a lot!


The following changes since commit 73b48099cc265f88fa1255f3f43e52fe6a94fd5c:

  mac80211: explain padding in place of rate field (2011-04-19 15:40:09 -0400)

are available in the git repository at:
  master.kernel.org:/pub/scm/linux/kernel/git/padovan/bluetooth-next-2.6.git master

Daniel Halperin (1):
      iwlwifi: fix frame injection for HT channels

Felix Fietkau (3):
      ath9k: fix missing ath9k_ps_wakeup/ath9k_ps_restore calls
      ath9k_hw: fix stopping rx DMA during resets
      ath9k: fix the return value of ath_stoprecv

Gustavo F. Padovan (1):
      Merge master.kernel.org:/.../padovan/bluetooth-2.6

Jason Conti (1):
      p54: Initialize extra_len in p54_tx_80211

Johannes Berg (1):
      mac80211: fix SMPS debugfs locking

John W. Linville (2):
      iwlegacy: make iwl3945 and iwl4965 select IWLWIFI_LEGACY
      Merge branch 'master' of git://git.kernel.org/.../padovan/bluetooth-2.6

Luiz Augusto von Dentz (1):
      Bluetooth: fix shutdown on SCO sockets

Ruiyi Zhang (1):
      Bluetooth: Only keeping SAR bits when retransmitting one frame.

Stanislaw Gruszka (3):
      iwlegacy: fix tx_power initialization
      iwlwifi: fix skb usage after free
      iwl4965: fix skb usage after free

Sujith Manoharan (1):
      ath9k_htc: Fix ethtool reporting

Ville Tervo (1):
      Bluetooth: Fix refcount balance for hci connection

Vinicius Costa Gomes (1):
      Bluetooth: Fix keeping the command timer running

 drivers/atm/solos-pci.c                           |   39 +--
 drivers/connector/cn_queue.c                      |   58 +---
 drivers/connector/connector.c                     |   47 +--
 drivers/net/atlx/atl2.c                           |   22 +-
 drivers/net/bonding/bond_alb.h                    |    2 +-
 drivers/net/irda/via-ircc.c                       |   94 ++-----
 drivers/net/mlx4/eq.c                             |    4 +-
 drivers/net/mlx4/mcg.c                            |    7 +-
 drivers/net/phy/phy_device.c                      |    8 +-
 drivers/net/starfire.c                            |    6 +-
 drivers/net/usb/Kconfig                           |   15 +
 drivers/net/usb/Makefile                          |    1 +
 drivers/net/usb/cdc_eem.c                         |    2 +-
 drivers/net/usb/cdc_ether.c                       |   23 +-
 drivers/net/usb/cdc_ncm.c                         |    2 +-
 drivers/net/usb/cdc_subset.c                      |    8 +
 drivers/net/usb/gl620a.c                          |    2 +-
 drivers/net/usb/lg-vl600.c                        |  346 +++++++++++++++++++++
 drivers/net/usb/net1080.c                         |    2 +-
 drivers/net/usb/plusb.c                           |    2 +-
 drivers/net/usb/rndis_host.c                      |    2 +-
 drivers/net/usb/usbnet.c                          |   13 +-
 drivers/net/usb/zaurus.c                          |    8 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c          |    4 +-
 drivers/net/wireless/ath/ath9k/hw.c               |   10 +-
 drivers/net/wireless/ath/ath9k/mac.c              |   25 ++-
 drivers/net/wireless/ath/ath9k/mac.h              |    2 +-
 drivers/net/wireless/ath/ath9k/main.c             |   16 +-
 drivers/net/wireless/ath/ath9k/recv.c             |    6 +-
 drivers/net/wireless/ath/carl9170/carl9170.h      |    1 +
 drivers/net/wireless/ath/carl9170/main.c          |    1 +
 drivers/net/wireless/ath/carl9170/tx.c            |    7 +
 drivers/net/wireless/ath/regd_common.h            |    1 +
 drivers/net/wireless/b43/dma.c                    |    2 +-
 drivers/net/wireless/b43/dma.h                    |    2 +-
 drivers/net/wireless/iwlegacy/Kconfig             |    9 +-
 drivers/net/wireless/iwlegacy/iwl-3945-hw.h       |    2 -
 drivers/net/wireless/iwlegacy/iwl-4965-hw.h       |    3 -
 drivers/net/wireless/iwlegacy/iwl-4965-tx.c       |   10 +-
 drivers/net/wireless/iwlegacy/iwl-core.c          |   27 ++-
 drivers/net/wireless/iwlegacy/iwl-eeprom.c        |    7 -
 drivers/net/wireless/iwlegacy/iwl3945-base.c      |   11 +-
 drivers/net/wireless/iwlegacy/iwl4965-base.c      |    6 -
 drivers/net/wireless/iwlwifi/iwl-5000.c           |    3 +
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c       |    7 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |   10 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h         |    2 +-
 drivers/net/wireless/mwl8k.c                      |    9 +-
 drivers/net/wireless/p54/p54usb.c                 |    2 +
 drivers/net/wireless/p54/txrx.c                   |    2 +-
 drivers/net/wireless/rt2x00/rt2800usb.c           |   10 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c           |    6 +-
 drivers/net/wireless/rtlwifi/efuse.c              |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c |    2 +-
 drivers/net/wireless/rtlwifi/usb.c                |    2 +-
 drivers/net/wireless/wl12xx/sdio.c                |    2 +-
 drivers/net/wireless/wl12xx/spi.c                 |    2 +-
 drivers/net/wireless/wl12xx/testmode.c            |    5 +-
 drivers/net/wireless/zd1211rw/zd_usb.c            |   20 +-
 drivers/net/wireless/zd1211rw/zd_usb.h            |    1 +
 include/linux/atmdev.h                            |    1 +
 include/linux/connector.h                         |   16 +-
 include/linux/netdevice.h                         |    4 +-
 include/linux/skbuff.h                            |    2 +-
 include/linux/usb/usbnet.h                        |    5 +
 include/net/if_inet6.h                            |   16 +
 include/net/ip.h                                  |    8 +
 include/net/mac80211.h                            |   15 +-
 include/net/sctp/structs.h                        |    2 +-
 net/appletalk/ddp.c                               |   11 +-
 net/atm/common.c                                  |    1 +
 net/bluetooth/hci_core.c                          |    1 +
 net/bluetooth/hci_event.c                         |    2 -
 net/bluetooth/l2cap_core.c                        |    1 +
 net/bluetooth/sco.c                               |    9 +
 net/bridge/br_multicast.c                         |    2 +-
 net/bridge/br_stp_if.c                            |    2 +-
 net/core/dev.c                                    |   24 ++-
 net/ipv4/arp.c                                    |    3 +
 net/ipv4/fib_frontend.c                           |    2 +
 net/ipv4/tcp_output.c                             |    3 +-
 net/ipv6/ndisc.c                                  |    2 +
 net/mac80211/cfg.c                                |    2 +
 net/mac80211/debugfs_netdev.c                     |    4 +-
 net/mac80211/key.c                                |    7 +-
 net/mac80211/rc80211_minstrel_ht.c                |   25 +-
 net/mac80211/rx.c                                 |    5 +-
 net/sctp/protocol.c                               |    4 +-
 net/sctp/sm_make_chunk.c                          |    4 +-
 net/wireless/scan.c                               |   31 ++-
 90 files changed, 803 insertions(+), 363 deletions(-)
 create mode 100644 drivers/net/usb/lg-vl600.c

-- 
Gustavo F. Padovan
http://profusion.mobi
