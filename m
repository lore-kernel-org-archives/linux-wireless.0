Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:38004 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732312AbeHFWOI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Aug 2018 18:14:08 -0400
Date: Mon, 6 Aug 2018 23:03:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: sgruszka@redhat.com
Cc: linux-wireless@vger.kernel.org
Subject: [bug report] mt76x0: mac files
Message-ID: <20180806200318.tya32jj5k5fvptff@kili.mountain> (sfid-20180806_220332_383493_A6B2AA72)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Stanislaw Gruszka,

The patch a77443498137: "mt76x0: mac files" from Jul 31, 2018, leads
to the following static checker warning:

	drivers/net/wireless/mediatek/mt76/mt76x0/mac.c:429 mt76x0_mac_set_ampdu_factor()
	info: ignoring unreachable code.

drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
   419  void mt76x0_mac_set_ampdu_factor(struct mt76x0_dev *dev)
   420  {
   421          struct ieee80211_sta *sta;
   422          struct mt76_wcid *wcid;
   423          void *msta;
   424          u8 min_factor = 3;
   425          int i;
   426  
   427          return;
                ^^^^^^^
Did you mean to comment this function out?

   428  
   429          rcu_read_lock();
   430          for (i = 0; i < ARRAY_SIZE(dev->wcid); i++) {
   431                  wcid = rcu_dereference(dev->wcid[i]);
   432                  if (!wcid)
   433                          continue;
   434  
   435                  msta = container_of(wcid, struct mt76_sta, wcid);
   436                  sta = container_of(msta, struct ieee80211_sta, drv_priv);
   437  
   438                  min_factor = min(min_factor, sta->ht_cap.ampdu_factor);
   439          }
   440          rcu_read_unlock();
   441  
   442          mt76_wr(dev, MT_MAX_LEN_CFG, 0xa0fff |
   443                     FIELD_PREP(MT_MAX_LEN_CFG_AMPDU, min_factor));
   444  }

regards,
dan carpenter
