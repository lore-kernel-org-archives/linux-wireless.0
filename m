Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yb0-f178.google.com ([209.85.213.178]:33982 "EHLO
        mail-yb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753751AbcIHHwv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Sep 2016 03:52:51 -0400
Received: by mail-yb0-f178.google.com with SMTP id x93so14095315ybh.1
        for <linux-wireless@vger.kernel.org>; Thu, 08 Sep 2016 00:52:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160905095128.80560-4-nbd@nbd.name>
References: <20160905095128.80560-1-nbd@nbd.name> <20160905095128.80560-4-nbd@nbd.name>
From: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date: Thu, 8 Sep 2016 10:52:30 +0300
Message-ID: <CAHNKnsTwBVmWSis_5EV1mrJM53E6XDhJ=CHWCjihZ839bDXGuA@mail.gmail.com> (sfid-20160908_095303_888312_3509D668)
Subject: Re: [PATCH v3 3/3] mt76: add driver code for MT76x2e
To: Felix Fietkau <nbd@nbd.name>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First of all I would like to thank you Felix for this great job!
Please find one simple question below.

2016-09-05 12:51 GMT+03:00 Felix Fietkau <nbd@nbd.name>:
> From: Felix Fietkau <nbd@openwrt.org>
>
> This is a 2x2 PCIe 802.11ac chipset by MediaTek
>

[skip]

> +int mt76x2_init_hardware(struct mt76x2_dev *dev)
> +{
> +       static const u16 beacon_offsets[16] = {
> +               /* 1024 byte per beacon */
> +               0xc000,
> +               0xc400,
> +               0xc800,
> +               0xcc00,
> +               0xd000,
> +               0xd400,
> +               0xd800,
> +               0xdc00,
> +
> +               /* BSS idx 8-15 not used for beacons */
> +               0xc000,
> +               0xc000,
> +               0xc000,
> +               0xc000,
> +               0xc000,
> +               0xc000,
> +               0xc000,
> +               0xc000,
> +       };
> +       u32 val;
> +       int ret;
> +
> +       dev->beacon_offsets = beacon_offsets;
> +       tasklet_init(&dev->pre_tbtt_tasklet, mt76x2_pre_tbtt_tasklet,
> +                    (unsigned long) dev);
> +
> +       dev->chainmask = 0x202;
> +       dev->global_wcid.idx = 255;
> +       dev->global_wcid.hw_key_idx = -1;
> +       dev->slottime = 9;
> +
> +       val = mt76_rr(dev, MT_WPDMA_GLO_CFG);
> +       val &= MT_WPDMA_GLO_CFG_DMA_BURST_SIZE |
> +              MT_WPDMA_GLO_CFG_BIG_ENDIAN |
> +              MT_WPDMA_GLO_CFG_HDR_SEG_LEN;
> +       val |= MT_WPDMA_GLO_CFG_TX_WRITEBACK_DONE;
> +       mt76_wr(dev, MT_WPDMA_GLO_CFG, val);
> +
> +       mt76x2_reset_wlan(dev, true);
> +       mt76x2_power_on(dev);
> +
> +       ret = mt76x2_eeprom_init(dev);
> +       if (ret)
> +               return ret;
> +
> +       ret = mt76x2_mac_reset(dev, true);
> +       if (ret)
> +               return ret;
> +
> +       ret = mt76x2_dma_init(dev);
> +       if (ret)
> +               return ret;
> +
> +       set_bit(MT76_STATE_INITIALIZED, &dev->mt76.state);
> +       ret = mt76x2_mac_start(dev);
> +       if (ret)
> +               return ret;
> +
> +       ret = mt76x2_mcu_init(dev);
> +       if (ret)
> +               return ret;
> +
> +       mt76x2_mac_stop(dev, false);
> +       dev->rxfilter = mt76_rr(dev, MT_RX_FILTR_CFG);
> +
> +       return 0;
> +}

[skip]

> +
> +int mt76x2_register_device(struct mt76x2_dev *dev)
> +{
> +       struct ieee80211_hw *hw = mt76_hw(dev);
> +       struct wiphy *wiphy = hw->wiphy;
> +       void *status_fifo;
> +       int fifo_size;
> +       int i, ret;
> +
> +       fifo_size = roundup_pow_of_two(32 * sizeof(struct mt76x2_tx_status));
> +       status_fifo = devm_kzalloc(dev->mt76.dev, fifo_size, GFP_KERNEL);
> +       if (!status_fifo)
> +               return -ENOMEM;
> +
> +       kfifo_init(&dev->txstatus_fifo, status_fifo, fifo_size);
> +
> +       ret = mt76x2_init_hardware(dev);
> +       if (ret)
> +               return ret;
> +
> +       hw->queues = 4;
> +       hw->max_rates = 1;
> +       hw->max_report_rates = 7;
> +       hw->max_rate_tries = 1;
> +       hw->extra_tx_headroom = 2;
> +
> +       hw->sta_data_size = sizeof(struct mt76x2_sta);
> +       hw->vif_data_size = sizeof(struct mt76x2_vif);
> +
> +       for (i = 0; i < ARRAY_SIZE(dev->macaddr_list); i++) {
> +               u8 *addr = dev->macaddr_list[i].addr;
> +
> +               memcpy(addr, dev->mt76.macaddr, ETH_ALEN);
> +
> +               if (!i)
> +                       continue;
> +
> +               addr[0] |= BIT(1);
> +               addr[0] ^= ((i - 1) << 2);
> +       }
> +       wiphy->addresses = dev->macaddr_list;
> +       wiphy->n_addresses = ARRAY_SIZE(dev->macaddr_list);
> +
> +       wiphy->iface_combinations = if_comb;
> +       wiphy->n_iface_combinations = ARRAY_SIZE(if_comb);
> +
> +       wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_VHT_IBSS);
> +
> +       ieee80211_hw_set(hw, SUPPORTS_HT_CCK_RATES);
> +       INIT_DELAYED_WORK(&dev->cal_work, mt76x2_phy_calibrate);
> +       INIT_DELAYED_WORK(&dev->mac_work, mt76x2_mac_work);
> +
> +       dev->mt76.sband_2g.sband.ht_cap.cap |= IEEE80211_HT_CAP_LDPC_CODING;
> +       dev->mt76.sband_5g.sband.ht_cap.cap |= IEEE80211_HT_CAP_LDPC_CODING;
> +
> +       ret = mt76_register_device(&dev->mt76, true, mt76x2_rates,
> +                                  ARRAY_SIZE(mt76x2_rates));
> +       if (ret)
> +               goto fail;
> +
> +       mt76x2_init_debugfs(dev);
> +
> +       return 0;
> +
> +fail:
> +       mt76x2_stop_hardware(dev);
> +       return ret;
> +}

Just curious, almost full chip initialization performed in probe
procedure, why not do that in start() callback? In such case we could
fully restart chip without module reloading, just with ifdown/ifup
circle.

-- 
Sergey
