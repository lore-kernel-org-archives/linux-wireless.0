Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:36061 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbZHRKam (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 06:30:42 -0400
Date: Tue, 18 Aug 2009 12:30:43 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 00/29] mwl8k update to version 0.10
Message-ID: <20090818103043.GA6171@mail.wantstofly.org>
References: <20090818034942.GE18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090818034942.GE18639@mail.wantstofly.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 18, 2009 at 05:49:42AM +0200, Lennert Buytenhek wrote:

> In this series, various mwl8k coding style cleanups, removal of the
> usage of radio_enabled, some minor bug fixes, optimisations, and
> removal of most of the driver's workqueue use.  (Against latest
> wireless-testing.)

Johannes' ->configure_filter rework and ->radio_enabled removal
caused some fallout further in my series, so I've pulled latest
wireless-testing and pushed a new queue to git.marvell.com, with
the following changes from the patch set posted to the list:

- The atomic part of ->configure_filter has been split off into
  ->prepare_multicast(), so use the latter to synthesize our multicast
  firmware command, and then post it in ->configure_filter().

- Exchange the patch that changed the ->radio_enabled check to a
  IEEE80211_CONF_IDLE check for a patch that adds a IEEE80211_CONF_IDLE
  check, since mwl8k's ->radio_enabled check is gone in current
  wireless-testing.

- The patch to switch mwl8k_configure_filter() over to queue_work()
  directly is gone since ->configure_filter() can sleep now, and it's
  been replaced by a patch that just does the firmware command
  issuing (which sleeps) directly in mwl8k_configure_filter().

All in all, this patch set is a 20% reduction in file size, without
loss of functionality.  Please consider pulling.

(A future set of patches will add AP and 11n support, but that needs
some more work still.)



The following changes since commit f0602f40fe362f4ee15aad719d5cf7021de61914:
  Bob Copeland (1):
        wl1251: correct definitions for 0th bit defines

are available in the git repository at:

  git://git.marvell.com/mwl8k.git master

Lennert Buytenhek (29):
      mwl8k: remove various unused struct members and defines
      mwl8k: s/IEEE80211_ADDR_LEN/ETH_ALEN/g
      mwl8k: sort firmware command list by opcode, and trim unused commands
      mwl8k: various coding style cleanups
      mwl8k: remove MWL8K_RADIO_* defines
      mwl8k: remove MWL8K_RADIO_*_PREAMBLE defines
      mwl8k: remove MWL8K_WMM_* defines
      mwl8k: remove MWL8K_*_SLOTTIME defines
      mwl8k: fix mwl8k_configure_filter() parameter lifetime issue
      mwl8k: ->add_interface() is not called for monitor interfaces
      mwl8k: dma header manipulations can't fail
      mwl8k: don't touch 'command done' interrupt during firmware load
      mwl8k: don't hardcode the number of transmit queues
      mwl8k: no need to hold ->tx_lock while setting the hardware interrupt mask
      mwl8k: implement rfkill
      mwl8k: mwl8k_txq_xmit() rework
      mwl8k: mwl8k_queue_work() cleanup
      mwl8k: fix firmware command serialisation
      mwl8k: get rid of mwl8k_start() workqueue use
      mwl8k: get rid of mwl8k_stop() workqueue use
      mwl8k: get rid of mwl8k_config() workqueue use
      mwl8k: get rid of mwl8k_bss_info_changed() workqueue use
      mwl8k: get rid of mwl8k_set_rts_threshold() workqueue use
      mwl8k: get rid of mwl8k_conf_tx() workqueue use
      mwl8k: get rid of mwl8k_get_stats() workqueue use
      mwl8k: get rid of mwl8k_configure_filter() workqueue use
      mwl8k: remove mwl8k_queue_work()
      mwl8k: update copyright and version number
      MAINTAINERS: add information for mwl8k wireless driver

 MAINTAINERS                  |    6 +
 drivers/net/wireless/mwl8k.c | 1545 ++++++++++++------------------------------
 2 files changed, 437 insertions(+), 1114 deletions(-)
