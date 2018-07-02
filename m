Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:64459 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751440AbeGBFdX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jul 2018 01:33:23 -0400
Date: Mon, 2 Jul 2018 13:32:54 +0800
From: kbuild test robot <lkp@intel.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: kbuild-all@01.org, nbd@nbd.name, linux-wireless@vger.kernel.org,
        sgruszka@redhat.com
Subject: Re: [PATCH 12/19] mt76: add mt76x2_tx_common to mt76x2-common module
Message-ID: <201807021325.70849r2F%fengguang.wu@intel.com> (sfid-20180702_073327_506781_A0007DA1)
References: <20180701141231.25323-13-lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180701141231.25323-13-lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Lorenzo,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on wireless-drivers-next/master]
[also build test WARNING on v4.18-rc3 next-20180629]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Lorenzo-Bianconi/add-mt76x2u-support-to-mt76-driver/20180701-221609
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git master

smatch warnings:
drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c:35 mt76x2_tx() warn: always true condition '(wcid->hw_key_idx != -1) => (0-255 != (-1))'

vim +35 drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c

    20	
    21	void mt76x2_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
    22		       struct sk_buff *skb)
    23	{
    24		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
    25		struct mt76x2_dev *dev = hw->priv;
    26		struct ieee80211_vif *vif = info->control.vif;
    27		struct mt76_wcid *wcid = &dev->global_wcid;
    28	
    29		if (control->sta) {
    30			struct mt76x2_sta *msta;
    31	
    32			msta = (struct mt76x2_sta *)control->sta->drv_priv;
    33			wcid = &msta->wcid;
    34			/* sw encrypted frames */
  > 35			if (!info->control.hw_key && wcid->hw_key_idx != -1)
    36				control->sta = NULL;
    37		}
    38	
    39		if (vif && !control->sta) {
    40			struct mt76x2_vif *mvif;
    41	
    42			mvif = (struct mt76x2_vif *)vif->drv_priv;
    43			wcid = &mvif->group_wcid;
    44		}
    45	
    46		mt76_tx(&dev->mt76, control->sta, wcid, skb);
    47	}
    48	EXPORT_SYMBOL_GPL(mt76x2_tx);
    49	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
