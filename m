Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:35144 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816Ab2LKNzK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 08:55:10 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Gabor Juhos <juhosg@openwrt.org>,
	<users@rt2x00.serialmonkey.com>
Subject: [PATCH 1/3] rt2x00: zero-out rx_status
Date: Tue, 11 Dec 2012 14:55:03 +0100
Message-Id: <1355234105-12013-1-git-send-email-juhosg@openwrt.org> (sfid-20121211_145515_231523_CE45EFE3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In commit 'mac80211: support radiotap vendor namespace RX data'
new fields were added to 'struct ieee80211_rx_status'.
The rt2x00 driver does not initializes those fields and
this can cause unexpected behaviour.

The rt2x00 driver from the compat-wireless-2012-12-01
tarball caused the following warning:

  WARNING: at
  /devel/ramips/build_dir/target-mipsel_r2_uClibc-0.9.33.2/linux-ramips_rt305x/
  compat-wireless-2012-12-01/net/mac80211/rx.c:115 ieee80211_rx_irqsafe+0x274/0xbcc
  [mac80211]()
  Modules linked in: dwc_otg ledtrig_usbdev nf_nat_irc
  nf_nat_ftp nf_conntrack_irc nf_conntrack_ftp ipt_MASQUERADE
  iptable_nat nf_nat pppoe xt_conntrack xt_CT xt_NOTRACK iptable_raw
  xt_state nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack pppox
  ipt_REJECT xt_TCPMSS xt_comment xt_multiport xt_mac xt_limit
  iptable_mangle iptable_filter ip_tables xt_tcpudp x_tables ppp_async
  ppp_generic slhc rt2800pci(O) rt2800lib(O) rt2x00soc(O) rt2x00pci(O)
  rt2x00lib(O) mac80211(O) usbcore usb_common nls_base crc_itu_t
  crc_ccitt eeprom_93cx6 cfg80211(O) compat(O) arc4 aes_generic
  crypto_blkcipher cryptomgr aead crypto_hash crypto_algapi leds_gpio
  button_hotplug(O) gpio_keys_polled input_polldev input_core
  Call Trace:
  [<801e96b4>] dump_stack+0x8/0x34
  [<80010a9c>] warn_slowpath_common+0x78/0xa4
  [<80010ae0>] warn_slowpath_null+0x18/0x24
  [<80a9710c>] ieee80211_rx_irqsafe+0x274/0xbcc [mac80211]

The patch ensures that each field gets initialized with
zeroes.

Cc: <users@rt2x00.serialmonkey.com>
Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 3248b42..be90277 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -686,6 +686,8 @@ void rt2x00lib_rxdone(struct queue_entry *entry, gfp_t gfp)
 	 * to mac80211.
 	 */
 	rx_status = IEEE80211_SKB_RXCB(entry->skb);
+	memset(rx_status, 0, sizeof(*rx_status));
+
 	rx_status->mactime = rxdesc.timestamp;
 	rx_status->band = rt2x00dev->curr_band;
 	rx_status->freq = rt2x00dev->curr_freq;
-- 
1.7.10

