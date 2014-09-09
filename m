Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42315 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842AbaIIJii (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2014 05:38:38 -0400
Date: Tue, 9 Sep 2014 12:38:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: herself@thefumon.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net
Subject: re: ath5k: added debugfs file for dumping eeprom
Message-ID: <20140909093802.GA10439@mwanda> (sfid-20140909_113842_152783_6581AC06)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Jade Bilkey,

The patch db906eb2101b: "ath5k: added debugfs file for dumping
eeprom" from Aug 30, 2014, leads to the following static checker
warning:

	drivers/net/wireless/ath/ath5k/debug.c:942 open_file_eeprom()
	error: buffer overflow 'buf' 2048 <= 4095

drivers/net/wireless/ath/ath5k/debug.c
   905  static int open_file_eeprom(struct inode *inode, struct file *file)
   906  {
   907          struct eeprom_private *ep;
   908          struct ath5k_hw *ah = inode->i_private;
   909          bool res;
   910          int i, ret;
   911          u32 eesize;
   912          u16 val, *buf;
                          ^^^
buf is type u16.

   913  
   914          /* Get eeprom size */
   915  
   916          res = ath5k_hw_nvram_read(ah, AR5K_EEPROM_SIZE_UPPER, &val);
   917          if (!res)
   918                  return -EACCES;
   919  
   920          if (val == 0) {
   921                  eesize = AR5K_EEPROM_INFO_MAX + AR5K_EEPROM_INFO_BASE;
   922          } else {
   923                  eesize = (val & AR5K_EEPROM_SIZE_UPPER_MASK) <<
   924                          AR5K_EEPROM_SIZE_ENDLOC_SHIFT;
   925                  ath5k_hw_nvram_read(ah, AR5K_EEPROM_SIZE_LOWER, &val);
   926                  eesize = eesize | val;
   927          }
   928  
   929          if (eesize > 4096)
   930                  return -EINVAL;
   931  
   932          /* Create buffer and read in eeprom */
   933  
   934          buf = vmalloc(eesize);
                              ^^^^^^
eesize is in bytes.

   935          if (!buf) {
   936                  ret = -ENOMEM;
   937                  goto err;
   938          }
   939  
   940          for (i = 0; i < eesize; ++i) {
   941                  AR5K_EEPROM_READ(i, val);
   942                  buf[i] = val;

We are writing u16 but the for loop limit is in terms of bytes so this
loop will corrupt memory past the end of the buffer.

   943          }
   944  

regards,
dan carpenter
