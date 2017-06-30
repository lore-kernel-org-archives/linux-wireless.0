Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51744 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751817AbdF3Hyg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Jun 2017 03:54:36 -0400
Date: Fri, 30 Jun 2017 10:52:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org
Subject: [bug report] rtlwifi: Add rx ampdu cfg for btcoexist.
Message-ID: <20170628134840.wabf6j6m6aneljy5@mwanda> (sfid-20170630_095440_549660_1D2FC5AF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Ping-Ke Shih,

The patch 2635664e6e4a: "rtlwifi: Add rx ampdu cfg for btcoexist."
from Jun 18, 2017, leads to the following static checker warning:

	drivers/net/wireless/realtek/rtlwifi/base.c:1664 rtl_rx_ampdu_apply()
	error: uninitialized symbol 'reject_agg'.

drivers/net/wireless/realtek/rtlwifi/base.c
  1655  void rtl_rx_ampdu_apply(struct rtl_priv *rtlpriv)
  1656  {
  1657          struct rtl_btc_ops *btc_ops = rtlpriv->btcoexist.btc_ops;
  1658          u8 reject_agg, ctrl_agg_size = 0, agg_size;
  1659  
  1660          if (rtlpriv->cfg->ops->get_btc_status())
  1661                  btc_ops->btc_get_ampdu_cfg(rtlpriv, &reject_agg,
  1662                                             &ctrl_agg_size, &agg_size);
  1663  
  1664          RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_DMESG,
  1665                   "Set RX AMPDU: coex - reject=%d, ctrl_agg_size=%d, size=%d",
  1666                   reject_agg, ctrl_agg_size, agg_size);
                         ^^^^^^^^^^                 ^^^^^^^^
potentially uninitialized.

  1667  
  1668          rtlpriv->hw->max_rx_aggregation_subframes =
  1669                  (ctrl_agg_size ? agg_size : IEEE80211_MAX_AMPDU_BUF);
  1670  }
  1671  EXPORT_SYMBOL(rtl_rx_ampdu_apply);


regards,
dan carpenter
