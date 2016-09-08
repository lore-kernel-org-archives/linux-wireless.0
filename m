Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:37098 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757138AbcIHIZZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Sep 2016 04:25:25 -0400
Subject: Re: [PATCH v3 3/3] mt76: add driver code for MT76x2e
To: Sergey Ryazanov <ryazanov.s.a@gmail.com>
References: <20160905095128.80560-1-nbd@nbd.name>
 <20160905095128.80560-4-nbd@nbd.name>
 <CAHNKnsTwBVmWSis_5EV1mrJM53E6XDhJ=CHWCjihZ839bDXGuA@mail.gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <d65738be-cb30-cedd-562c-814d02a91794@nbd.name> (sfid-20160908_102528_976640_825C6A92)
Date: Thu, 8 Sep 2016 10:25:22 +0200
MIME-Version: 1.0
In-Reply-To: <CAHNKnsTwBVmWSis_5EV1mrJM53E6XDhJ=CHWCjihZ839bDXGuA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-09-08 09:52, Sergey Ryazanov wrote:
>> +
>> +int mt76x2_register_device(struct mt76x2_dev *dev)
>> +{
>> +       struct ieee80211_hw *hw = mt76_hw(dev);
>> +       struct wiphy *wiphy = hw->wiphy;
>> +       void *status_fifo;
>> +       int fifo_size;
>> +       int i, ret;
>> +
>> +       fifo_size = roundup_pow_of_two(32 * sizeof(struct mt76x2_tx_status));
>> +       status_fifo = devm_kzalloc(dev->mt76.dev, fifo_size, GFP_KERNEL);
>> +       if (!status_fifo)
>> +               return -ENOMEM;
>> +
>> +       kfifo_init(&dev->txstatus_fifo, status_fifo, fifo_size);
>> +
>> +       ret = mt76x2_init_hardware(dev);
>> +       if (ret)
>> +               return ret;
>> +
>> +       hw->queues = 4;
>> +       hw->max_rates = 1;
>> +       hw->max_report_rates = 7;
>> +       hw->max_rate_tries = 1;
>> +       hw->extra_tx_headroom = 2;
>> +
>> +       hw->sta_data_size = sizeof(struct mt76x2_sta);
>> +       hw->vif_data_size = sizeof(struct mt76x2_vif);
>> +
>> +       for (i = 0; i < ARRAY_SIZE(dev->macaddr_list); i++) {
>> +               u8 *addr = dev->macaddr_list[i].addr;
>> +
>> +               memcpy(addr, dev->mt76.macaddr, ETH_ALEN);
>> +
>> +               if (!i)
>> +                       continue;
>> +
>> +               addr[0] |= BIT(1);
>> +               addr[0] ^= ((i - 1) << 2);
>> +       }
>> +       wiphy->addresses = dev->macaddr_list;
>> +       wiphy->n_addresses = ARRAY_SIZE(dev->macaddr_list);
>> +
>> +       wiphy->iface_combinations = if_comb;
>> +       wiphy->n_iface_combinations = ARRAY_SIZE(if_comb);
>> +
>> +       wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_VHT_IBSS);
>> +
>> +       ieee80211_hw_set(hw, SUPPORTS_HT_CCK_RATES);
>> +       INIT_DELAYED_WORK(&dev->cal_work, mt76x2_phy_calibrate);
>> +       INIT_DELAYED_WORK(&dev->mac_work, mt76x2_mac_work);
>> +
>> +       dev->mt76.sband_2g.sband.ht_cap.cap |= IEEE80211_HT_CAP_LDPC_CODING;
>> +       dev->mt76.sband_5g.sband.ht_cap.cap |= IEEE80211_HT_CAP_LDPC_CODING;
>> +
>> +       ret = mt76_register_device(&dev->mt76, true, mt76x2_rates,
>> +                                  ARRAY_SIZE(mt76x2_rates));
>> +       if (ret)
>> +               goto fail;
>> +
>> +       mt76x2_init_debugfs(dev);
>> +
>> +       return 0;
>> +
>> +fail:
>> +       mt76x2_stop_hardware(dev);
>> +       return ret;
>> +}
> 
> Just curious, almost full chip initialization performed in probe
> procedure, why not do that in start() callback? In such case we could
> fully restart chip without module reloading, just with ifdown/ifup
> circle.
Last time I tried that I ran into some weird chip quirks. I do think
it's a good idea but I'd rather see this merged first and try again to
rework it when I have some more time to figure out what's going on.

- Felix
