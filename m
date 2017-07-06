Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36933 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752081AbdGFLv4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 07:51:56 -0400
Date: Thu, 6 Jul 2017 14:50:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org
Subject: [bug report] rtlwifi: Fill ap_num field by driver
Message-ID: <20170706114936.mung5qc4wt3mzjww@mwanda> (sfid-20170706_135200_463239_436A8C57)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Ping-Ke Shih,

The patch c76ab8e75442: "rtlwifi: Fill ap_num field by driver" from
Jun 21, 2017, leads to the following static checker warning:

	drivers/net/wireless/realtek/rtlwifi/base.c:1741 rtl_scan_list_expire()
	error: dereferencing freed memory 'entry'

drivers/net/wireless/realtek/rtlwifi/base.c
  1724  void rtl_scan_list_expire(struct ieee80211_hw *hw)
  1725  {
  1726          struct rtl_priv *rtlpriv = rtl_priv(hw);
  1727          struct rtl_bssid_entry *entry, *next;
  1728          unsigned long flags;
  1729  
  1730          spin_lock_irqsave(&rtlpriv->locks.scan_list_lock, flags);
  1731  
  1732          list_for_each_entry_safe(entry, next, &rtlpriv->scan_list.list, list) {
  1733                  /* 180 seconds */
  1734                  if (jiffies_to_msecs(jiffies - entry->age) < 180000)
  1735                          continue;
  1736  
  1737                  list_del(&entry->list);
  1738                  kfree(entry);
                              ^^^^^
Freed.

  1739                  rtlpriv->scan_list.num--;
  1740  
  1741                  RT_TRACE(rtlpriv, COMP_SCAN, DBG_LOUD,
  1742                           "BSSID=%pM is expire in scan list (total=%d)\n",
  1743                           entry->bssid, rtlpriv->scan_list.num);
                                 ^^^^^^^^^^^^
Dereferenced.

  1744          }

regards,
dan carpenter
