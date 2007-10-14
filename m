Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35240 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759410AbXJNRuD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Oct 2007 13:50:03 -0400
Date: Sun, 14 Oct 2007 19:50:32 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ivo van Doorn <IvDoorn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: drivers/net/wireless/rt2x00/: struct data_desc strangeness
Message-ID: <20071014175032.GI4211@stusta.de> (sfid-20071014_185010_122038_43B93C3F)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/rt2x00/rt2x00ring.h contains the following:

<--  snip  -->

...
/*
 * data_desc
 * Each data entry also contains a descriptor which is used by the
 * device to determine what should be done with the packet and
 * what the current status is.
 * This structure is greatly simplified, but the descriptors
 * are basically a list of little endian 32 bit values.
 * Make the array by default 1 word big, this will allow us
 * to use sizeof() correctly.
 */
struct data_desc {
        __le32 word[1];
};
...
/*
 * TX/RX Descriptor access functions.
 */
static inline void rt2x00_desc_read(struct data_desc *desc,
                                    const u8 word, u32 *value)
{
        *value = le32_to_cpu(desc->word[word]);
}

static inline void rt2x00_desc_write(struct data_desc *desc,
                                     const u8 word, const u32 value)
{
        desc->word[word] = cpu_to_le32(value);
}
...

<--  snip  -->

I haven't checked whether it might work in all cases, but passing 
non-zero values as second parameter to rt2x00_desc_{read,write}()
(as is done in many cases) is even in the best case bad coding style.

Spotted by the Coverity checker.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

