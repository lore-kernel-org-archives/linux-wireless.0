Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3710 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754970Ab0LTKUH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 05:20:07 -0500
From: "Arend Van Spriel" <arend@broadcom.com>
To: "Dan Carpenter" <error27@gmail.com>,
	"Vasanthakumar Thiagarajan" <vasanth@atheros.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Date: Mon, 20 Dec 2010 02:16:56 -0800
Subject: RE: smatch stuff: potential read past the end of the buffer
Message-ID: <400C43189542CE41BC0A5B252FC90136952F0594D7@SJEXCHCCR02.corp.ad.broadcom.com>
References: <20101220083041.GQ1936@bicker>
In-Reply-To: <20101220083041.GQ1936@bicker>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

Why not use min() function?
    index = min(COMP_HDR_LEN + osize, 2046);
    mchecksum = word[index] |
                    (word[index + 1] << 8);

Or would smatch miss this in its analysis?

Gr. AvS
________________________________________
From: linux-wireless-owner@vger.kernel.org [linux-wireless-owner@vger.kernel.org] On Behalf Of Dan Carpenter [error27@gmail.com]
Sent: Monday, December 20, 2010 9:30 AM
To: Vasanthakumar Thiagarajan
Cc: linux-wireless@vger.kernel.org; ath9k-devel@lists.ath9k.org
Subject: smatch stuff: potential read past the end of the buffer

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

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


