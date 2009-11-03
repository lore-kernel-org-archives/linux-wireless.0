Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40932 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757175AbZKCDH5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 22:07:57 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFT 0/9] ath9k: few updates for virtual wiphy
Date: Mon,  2 Nov 2009 22:07:52 -0500
Message-Id: <1257217681-27180-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are a few fixes for the ath9k virtual wiphy. I thought I was
going to have time to test them all today but that didn't happen
so instead of letting them rot in my queue for a few days I'm
posting them for review.

I was not able to find an easy way to deal with the ah->opmode,
that should be updated based on the currently used ieee80211_vif
but mac80211 doesn't exactly tell us which vif we're using at any
given time -- instead each driver is supposed to support different
modes of operation on different vifs on one wiphy. With ath9k
virtual wiphy we've taken a different approach: two vifs can
have different operating modes but on at least they get to use
their own separate channel.

While we can reap benefits of using a separate channel with the
current implementation there are a few cases where mac80211 makes
it difficult to guess your current hw configuration, mainly because
it wasn't designed for two vifs on separate wiphys on the same hardware.

We'd still need to figure out a way to deal with the ah->opmode but
that varies depending on the used vif, and the rx filter also changes
depending on the vif we're on but we have no way of triggering an
appropriate filter update unless mac80211 does it by chance for us.

Luis R. Rodriguez (9):
  ath9k: fix listening to idle requests
  ath9k: update hw configuration for virtual wiphys
  ath9k: simpify RX by calling ath_get_virt_hw() once
  ath9k: use the passed ieee80211_hw on ath_rx_prepare()
  ath9k: pass the ieee80211_hw on radio enable/disable
  ath9k: use correct hw for tx aggregation TX completion
  ath9k: use the right hw on ath_tx_setup_buffer() for HT
  ath9k: handle low buffer space for virtual wiphys
  ath9k: do not pass the entire descriptor to ath_rx_prepare()

 drivers/net/wireless/ath/ath9k/ath9k.h   |   10 +++-
 drivers/net/wireless/ath/ath9k/main.c    |   51 +++++++++++-----
 drivers/net/wireless/ath/ath9k/recv.c    |   96 ++++++++++++++++-------------
 drivers/net/wireless/ath/ath9k/virtual.c |   79 +++++++++++++++++++++++--
 drivers/net/wireless/ath/ath9k/xmit.c    |   21 ++++--
 5 files changed, 184 insertions(+), 73 deletions(-)

