Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:45374 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753279AbeERJai (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 May 2018 05:30:38 -0400
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 00/14] rtlwifi: remove duplicate C2H handlers
Date: Fri, 18 May 2018 17:29:53 +0800
Message-ID: <20180518093007.23594-1-pkshih@realtek.com> (sfid-20180518_113125_926999_EC26C196)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

The goal of patch 1/14 and 2/14 is to use keep-alive mechanism in mac80211
stack that needs accurate TX ack status for null frame reported by firmware
through C2H.
The remaining patches are step by step to remove duplicate C2H handlers
that widely distributed in IC specific files. An example of calling flow
before this patchset is:
	_rtl_pci_rx_interrupt() -> 
	rtlpriv->cfg->ops->rx_command_packet() =
		rtl8723be_rx_command_packet() -->
	rtl8723be_c2h_packet_handler() -->
		case 1: rtl_c2hcmd_enqueue()
		case 2: rtl8723be_c2h_content_parsing()

	if case 1:
	rtl_c2hcmd_launcher() ->
	rtlpriv->cfg->ops->c2h_content_parsing() =
		rtl8723be_c2h_content_parsing()

This patchset remove two ops:
	rtlpriv->cfg->ops->rx_command_packet()
	rtlpriv->cfg->ops->c2h_content_parsing()

But a special C2H is still existing, so add one op for RA report:
	rtlpriv->cfg->ops->c2h_ra_report_handler()

Finally, calling flow becomes:
	_rtl_pci_rx_interrupt() -->
	rtl_c2hcmd_enqueue() -->
		case 1: enqueue
		case 2: rtl_c2h_content_parsing() if fast_cmd
	
	if case 1:
	rtl_c2hcmd_launcher() ->
	rtl_c2h_content_parsing() ->
	hal_ops->c2h_ra_report_handler() =
		rtl8821ae_c2h_ra_report_handler() if C2H_RA_RPT


Ping-Ke Shih (13):
  rtlwifi: remove CONNECTION_MONITOR flag
  rtlwifi: remove duplicate rx_packet_type definition
  rtlwifi: rename register-based C2H command IDs to V0
  rtlwifi: remove duplicate C2H definition
  rtlwifi: remove unused fw C2H command ID
  rtlwifi: remove dummy hal_op rx_command_packet from rtl8188ee and
    rtl8723ae
  rtlwifi: Add hal_op c2h_ra_report_handler for special process
  rtlwifi: remove duplicate C2H handler
  rtlwifi: remove hal_op rx_command_packet
  rtlwifi: remove hal_op c2h_content_parsing
  rtlwifi: use sk_buff to queue C2H commands
  rtlwifi: access skb->data to get C2H data by macro
  rtlwifi: fix btmpinfo timeout while processing C2H_BT_INFO

Tzu-En Huang (1):
  rtlwifi: support accurate nullfunc frame tx ack report

 drivers/net/wireless/realtek/rtlwifi/base.c        | 208 ++++++++++++++++-----
 drivers/net/wireless/realtek/rtlwifi/base.h        |   7 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |  18 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/def.h   |  32 ----
 .../net/wireless/realtek/rtlwifi/rtl8188ee/sw.c    |   2 -
 .../net/wireless/realtek/rtlwifi/rtl8188ee/trx.c   |   7 -
 .../net/wireless/realtek/rtlwifi/rtl8188ee/trx.h   |   4 -
 .../net/wireless/realtek/rtlwifi/rtl8192ce/def.h   |  25 ---
 .../net/wireless/realtek/rtlwifi/rtl8192ee/def.h   |   8 -
 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.c    |  78 +-------
 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.h    |  16 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/sw.c    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/trx.c   |  29 +--
 .../net/wireless/realtek/rtlwifi/rtl8192ee/trx.h   |   3 -
 .../net/wireless/realtek/rtlwifi/rtl8723ae/def.h   |  25 ---
 .../wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c   |   6 +-
 .../wireless/realtek/rtlwifi/rtl8723ae/hal_btc.h   |  20 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/sw.c    |   1 -
 .../net/wireless/realtek/rtlwifi/rtl8723ae/trx.c   |   7 -
 .../net/wireless/realtek/rtlwifi/rtl8723ae/trx.h   |   3 -
 .../net/wireless/realtek/rtlwifi/rtl8723be/def.h   |   8 -
 .../net/wireless/realtek/rtlwifi/rtl8723be/fw.c    |  69 -------
 .../net/wireless/realtek/rtlwifi/rtl8723be/fw.h    |  13 --
 .../net/wireless/realtek/rtlwifi/rtl8723be/sw.c    |   2 -
 .../net/wireless/realtek/rtlwifi/rtl8723be/trx.c   |  30 +--
 .../net/wireless/realtek/rtlwifi/rtl8723be/trx.h   |   3 -
 .../net/wireless/realtek/rtlwifi/rtl8821ae/def.h   |  33 ----
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.c    |  69 +------
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.h    |  21 +--
 .../net/wireless/realtek/rtlwifi/rtl8821ae/sw.c    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/trx.c   |  31 +--
 .../net/wireless/realtek/rtlwifi/rtl8821ae/trx.h   |   3 -
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  56 +++++-
 33 files changed, 254 insertions(+), 589 deletions(-)

-- 
2.15.1
