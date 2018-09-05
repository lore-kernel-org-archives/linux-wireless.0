Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:36214 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727645AbeIFBEx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Sep 2018 21:04:53 -0400
Date: Wed, 5 Sep 2018 23:32:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: sgruszka@redhat.com
Cc: linux-wireless@vger.kernel.org
Subject: [bug report] mt76: unify wait_for_mac
Message-ID: <20180905203253.socfflhgirudy6xj@kili.mountain> (sfid-20180905_223306_306011_05636FCD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Stanislaw Gruszka,

The patch 2735a6dd7df3: "mt76: unify wait_for_mac" from Aug 29, 2018,
leads to the following static checker warning:

    drivers/net/wireless/mediatek/mt76/mt76x02_mac.h:60 mt76x02_wait_for_mac()
    warn: signedness bug returning '(-5)'

drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
    53  static inline bool mt76x02_wait_for_mac(struct mt76_dev *dev)
    54  {
    55          const u32 MAC_CSR0 = 0x1000;
    56          int i;
    57  
    58          for (i = 0; i < 500; i++) {
    59                  if (test_bit(MT76_REMOVED, &dev->state))
    60                          return -EIO;
                                       ^^^^
This is supposed to be true or false.

    61  
    62                  switch (dev->bus->rr(dev, MAC_CSR0)) {
    63                  case 0:
    64                  case ~0:
    65                          break;
    66                  default:
    67                          return true;
    68                  }
    69                  usleep_range(5000, 10000);
    70          }
    71          return false;
    72  }

regards,
dan carpenter
