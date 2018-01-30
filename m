Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55208 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751821AbeA3NEO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Jan 2018 08:04:14 -0500
Date: Tue, 30 Jan 2018 16:03:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: Re: [bug report] mt76: fix transmission of encrypted management
 frames
Message-ID: <20180130130354.2fm7s6s4icqi5hic@mwanda> (sfid-20180130_140418_168281_3F263D01)
References: <20180130123956.GA9178@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180130123956.GA9178@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 30, 2018 at 03:39:56PM +0300, Dan Carpenter wrote:
> Hello Felix Fietkau,
> 
> The patch 23405236460b: "mt76: fix transmission of encrypted
> management frames" from Jan 18, 2018, leads to the following static
> checker warning:
> 
> 	drivers/net/wireless/mediatek/mt76/mt76x2_tx.c:41 mt76x2_tx()
> 	warn: always true condition '(wcid->hw_key_idx != -1) => (0-255 != (-1))'
> 
> drivers/net/wireless/mediatek/mt76/mt76x2_tx.c
>     26  void mt76x2_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
>     27               struct sk_buff *skb)
>     28  {
>     29          struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
>     30          struct mt76x2_dev *dev = hw->priv;
>     31          struct ieee80211_vif *vif = info->control.vif;
>     32          struct mt76_wcid *wcid = &dev->global_wcid;
>     33  
>     34          if (control->sta) {
>     35                  struct mt76x2_sta *msta;
>     36  
>     37                  msta = (struct mt76x2_sta *) control->sta->drv_priv;
>     38                  wcid = &msta->wcid;
>     39          }
>     40  
>     41          if (vif || (!info->control.hw_key && wcid->hw_key_idx != -1)) {
>                                                      ^^^^^^^^^^^^^^^^^^^^^^
> We set ->hw_key_idx to -1 but it's a u8 so it gets truncated to 0xFF.
> This should probably be a define anyway.
> 
>     42                  struct mt76x2_vif *mvif;
>     43  
>     44                  mvif = (struct mt76x2_vif *) vif->drv_priv;
                                                       ^^^^^^^^^^^^^
Oh, there is another static checker warning because of the "vif" check:

        drivers/net/wireless/mediatek/mt76/mt76x2_tx.c:44 mt76x2_tx()
        error: we previously assumed 'vif' could be null (see line 41)

Assume "vif" is NULL, and info->control.hw_key is zero and ->hw_key_idx
is not -1.

regards,
dan carpenter
