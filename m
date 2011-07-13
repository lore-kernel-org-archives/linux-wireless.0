Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38102 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965144Ab1GMJYg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 05:24:36 -0400
Received: by pzk9 with SMTP id 9so4633423pzk.19
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jul 2011 02:24:36 -0700 (PDT)
Date: Wed, 13 Jul 2011 12:22:57 +0300
From: Dan Carpenter <error27@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	gregkh@suse.de
Subject: Re: [PATCH 00/24] ath6kl cleaned up driver
Message-ID: <20110713092257.GN18655@shale.localdomain> (sfid-20110713_112439_856249_A0EE796F)
References: <20110713013023.8517.15940.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110713013023.8517.15940.stgit@localhost6.localdomain6>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nice.  :)

There are a some smatch warnings you might want to take a look at:

drivers/net/wireless/ath/ath6kl/sdio.c +373 ath6kl_sdio_setup_scat_resource(42) warn: 's_req' was already freed.
drivers/net/wireless/ath/ath6kl/htc.c +2480 htc_create(74) warn: possible memory leak of 'packet'
drivers/net/wireless/ath/ath6kl/txrx.c +156 ath6kl_powersave_ap(76) error: we previously assumed 'conn' could be null.
  (The line number is off on that one.  Should be +142.  Odd)
drivers/net/wireless/ath/ath6kl/txrx.c +758 ath6kl_alloc_amsdu_rxbuf(33) warn: can 'packet' even be NULL?
drivers/net/wireless/ath/ath5k/phy.c +847 ath5k_hw_rfregs_init(152) error: potential null derefence 'go'.
drivers/net/wireless/ath/ath9k/ar9003_eeprom.c +3320 ar9300_eeprom_restore_internal(20) warn: returning -1 instead of -ENOMEM is sloppy
drivers/net/wireless/ath/ath9k/hif_usb.c +135 hif_usb_mgmt_cb(6) warn: variable dereferenced before check 'cmd'
drivers/net/wireless/ath/ath9k/pci.c +68 ath_pci_eeprom_read(12) error: buffer overflow 'pdata->eeprom_data' 2048 <= 2048

regards,
dan carpenter
