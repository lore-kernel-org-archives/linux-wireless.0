Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:34885 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727354AbeHGTao (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Aug 2018 15:30:44 -0400
Received: by mail-io0-f196.google.com with SMTP id w11-v6so14635190iob.2
        for <linux-wireless@vger.kernel.org>; Tue, 07 Aug 2018 10:15:26 -0700 (PDT)
MIME-Version: 1.0
References: <20180806074239.jrufspo3d7c4kgtb@kili.mountain>
In-Reply-To: <20180806074239.jrufspo3d7c4kgtb@kili.mountain>
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date: Tue, 7 Aug 2018 19:15:14 +0200
Message-ID: <CAJ0CqmUkeHnUAsqvM=_CFndD8ivOx73BfhowLcncgRaxQt49EQ@mail.gmail.com> (sfid-20180807_191530_573248_53074624)
Subject: Re: [bug report] mt76: add mt76x2_tx_common to mt76x2-common module
To: dan.carpenter@oracle.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> Hello Lorenzo Bianconi,
>
> The patch 9367a9c7f956: "mt76: add mt76x2_tx_common to mt76x2-common
> module" from Jul 31, 2018, leads to the following static checker
> warning:
>
>         drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c:35 mt76x2_tx()
>         warn: always true condition '(wcid->hw_key_idx != -1) => (0-255 != (-1))'
>
> drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
>     21  void mt76x2_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
>     22                 struct sk_buff *skb)
>     23  {
>     24          struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
>     25          struct mt76x2_dev *dev = hw->priv;
>     26          struct ieee80211_vif *vif = info->control.vif;
>     27          struct mt76_wcid *wcid = &dev->global_wcid;
>     28
>     29          if (control->sta) {
>     30                  struct mt76x2_sta *msta;
>     31
>     32                  msta = (struct mt76x2_sta *)control->sta->drv_priv;
>     33                  wcid = &msta->wcid;
>     34                  /* sw encrypted frames */
>     35                  if (!info->control.hw_key && wcid->hw_key_idx != -1)
>                                                      ^^^^^^^^^^^^^^^^^^^^^^
> This is always going to be true.
>
>     36                          control->sta = NULL;
>     37          }
>     38
>     39          if (vif && !control->sta) {
>     40                  struct mt76x2_vif *mvif;
>     41
>     42                  mvif = (struct mt76x2_vif *)vif->drv_priv;
>     43                  wcid = &mvif->group_wcid;
>     44          }
>     45
>     46          mt76_tx(&dev->mt76, control->sta, wcid, skb);
>     47  }
>     48  EXPORT_SYMBOL_GPL(mt76x2_tx);
>
> regards,
> dan carpenter

Hi Dan,

thx for the info. This patch just moves mt76x2_tx (and other tx
routines) in mt76x2-common module in order to remove pci dependency in
usb code; the warning was already there. I will fix it in a separate
patch.

Regards,
Lorenzo
