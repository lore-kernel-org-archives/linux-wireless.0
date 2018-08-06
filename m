Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:46298 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728948AbeHFXHj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Aug 2018 19:07:39 -0400
Date: Mon, 6 Aug 2018 23:56:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: sgruszka@redhat.com
Cc: linux-wireless@vger.kernel.org
Subject: [bug report] mt76x0: eeprom files
Message-ID: <20180806205639.yoeruw2iamxpv6gl@kili.mountain> (sfid-20180806_225653_429650_A70AD8EE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Stanislaw Gruszka,

The patch e87b5039511a: "mt76x0: eeprom files" from Jul 31, 2018,
leads to the following static checker warning:

	drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c:250 mt76x0_set_lna_gain()
	warn: impossible condition '(gain == 255) => ((-128)-127 == 255)'

drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
   241  static void
   242  mt76x0_set_lna_gain(struct mt76x0_dev *dev, u8 *eeprom)
   243  {
   244          s8 gain;
                ^^
Should this be a "u8"?

   245  
   246          dev->ee->lna_gain_2ghz = eeprom[MT_EE_LNA_GAIN_2GHZ];
   247          dev->ee->lna_gain_5ghz[0] = eeprom[MT_EE_LNA_GAIN_5GHZ_0];
   248  
   249          gain = eeprom[MT_EE_LNA_GAIN_5GHZ_1];
   250          if (gain == 0xff || gain == 0)
                    ^^^^^^^^^^^^
Impossible

   251                  dev->ee->lna_gain_5ghz[1] = dev->ee->lna_gain_5ghz[0];
   252          else
   253                  dev->ee->lna_gain_5ghz[1] = gain;
   254  
   255          gain = eeprom[MT_EE_LNA_GAIN_5GHZ_2];
   256          if (gain == 0xff || gain == 0)
                    ^^^^^^^^^^^^
Same

   257                  dev->ee->lna_gain_5ghz[2] = dev->ee->lna_gain_5ghz[0];
   258          else
   259                  dev->ee->lna_gain_5ghz[2] = gain;
   260  }

regards,
dan carpenter
