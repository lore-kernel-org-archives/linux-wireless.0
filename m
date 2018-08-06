Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:46946 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbeHFJug (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Aug 2018 05:50:36 -0400
Date: Mon, 6 Aug 2018 10:42:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: lorenzo.bianconi@redhat.com
Cc: linux-wireless@vger.kernel.org
Subject: [bug report] mt76: add mt76x2_tx_common to mt76x2-common module
Message-ID: <20180806074239.jrufspo3d7c4kgtb@kili.mountain> (sfid-20180806_094252_710548_7DE94EBC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Lorenzo Bianconi,

The patch 9367a9c7f956: "mt76: add mt76x2_tx_common to mt76x2-common
module" from Jul 31, 2018, leads to the following static checker
warning:

	drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c:35 mt76x2_tx()
	warn: always true condition '(wcid->hw_key_idx != -1) => (0-255 != (-1))'

drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
    21  void mt76x2_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
    22                 struct sk_buff *skb)
    23  {
    24          struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
    25          struct mt76x2_dev *dev = hw->priv;
    26          struct ieee80211_vif *vif = info->control.vif;
    27          struct mt76_wcid *wcid = &dev->global_wcid;
    28  
    29          if (control->sta) {
    30                  struct mt76x2_sta *msta;
    31  
    32                  msta = (struct mt76x2_sta *)control->sta->drv_priv;
    33                  wcid = &msta->wcid;
    34                  /* sw encrypted frames */
    35                  if (!info->control.hw_key && wcid->hw_key_idx != -1)
                                                     ^^^^^^^^^^^^^^^^^^^^^^
This is always going to be true.

    36                          control->sta = NULL;
    37          }
    38  
    39          if (vif && !control->sta) {
    40                  struct mt76x2_vif *mvif;
    41  
    42                  mvif = (struct mt76x2_vif *)vif->drv_priv;
    43                  wcid = &mvif->group_wcid;
    44          }
    45  
    46          mt76_tx(&dev->mt76, control->sta, wcid, skb);
    47  }
    48  EXPORT_SYMBOL_GPL(mt76x2_tx);

regards,
dan carpenter
