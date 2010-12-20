Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45598 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab0LTIay (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 03:30:54 -0500
Received: by wyb28 with SMTP id 28so2603483wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Dec 2010 00:30:53 -0800 (PST)
Date: Mon, 20 Dec 2010 11:30:41 +0300
From: Dan Carpenter <error27@gmail.com>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: smatch stuff: potential read past the end of the buffer
Message-ID: <20101220083041.GQ1936@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Vasanthakumar,

Smatch complains that in linux-next 60e0c3a7 "ath9k_hw: Eeeprom changes
for AR9485" means there is a potential read past the end of the buffer
int ar9300_eeprom_restore_internal().

drivers/net/wireless/ath/ath9k/ar9003_eeprom.c +3381
	ar9300_eeprom_restore_internal(81)
	error: buffer overflow 'word' 2048 <= 4099

"word" is allocated with 2048 bytes:
        word = kzalloc(2048, GFP_KERNEL);

"length" can be up to 4099:
                if ((!AR_SREV_9485(ah) && length >= 1024) ||
                    (AR_SREV_9485(ah) && length >= (4 * 1024))) {
                                         ^^^^^^^^^^^^^^^^^^^^^

so "osize" can be up to 4099 as well:
                osize = length;

We're reading way past the end of the word array here:
                mchecksum = word[COMP_HDR_LEN + osize] |
                            ^^^^^^^^^^^^^^^^^^^^^^^^^^
                    (word[COMP_HDR_LEN + osize + 1] << 8);

I don't know how to fix this.  Can you take a look?

regards,
dan carpenter

