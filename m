Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49216 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751795AbeA3MkM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Jan 2018 07:40:12 -0500
Date: Tue, 30 Jan 2018 15:39:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [bug report] mt76: fix transmission of encrypted management frames
Message-ID: <20180130123956.GA9178@mwanda> (sfid-20180130_134030_129447_CA3E516E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Felix Fietkau,

The patch 23405236460b: "mt76: fix transmission of encrypted
management frames" from Jan 18, 2018, leads to the following static
checker warning:

	drivers/net/wireless/mediatek/mt76/mt76x2_tx.c:41 mt76x2_tx()
	warn: always true condition '(wcid->hw_key_idx != -1) => (0-255 != (-1))'

drivers/net/wireless/mediatek/mt76/mt76x2_tx.c
    26  void mt76x2_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
    27               struct sk_buff *skb)
    28  {
    29          struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
    30          struct mt76x2_dev *dev = hw->priv;
    31          struct ieee80211_vif *vif = info->control.vif;
    32          struct mt76_wcid *wcid = &dev->global_wcid;
    33  
    34          if (control->sta) {
    35                  struct mt76x2_sta *msta;
    36  
    37                  msta = (struct mt76x2_sta *) control->sta->drv_priv;
    38                  wcid = &msta->wcid;
    39          }
    40  
    41          if (vif || (!info->control.hw_key && wcid->hw_key_idx != -1)) {
                                                     ^^^^^^^^^^^^^^^^^^^^^^
We set ->hw_key_idx to -1 but it's a u8 so it gets truncated to 0xFF.
This should probably be a define anyway.

    42                  struct mt76x2_vif *mvif;
    43  
    44                  mvif = (struct mt76x2_vif *) vif->drv_priv;
    45                  wcid = &mvif->group_wcid;
    46          }
    47  
    48          mt76_tx(&dev->mt76, control->sta, wcid, skb);
    49  }

regards,
dan carpenter
