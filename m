Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:9541 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbXJNStI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Oct 2007 14:49:08 -0400
Received: by fk-out-0910.google.com with SMTP id z23so1315544fkz
        for <linux-wireless@vger.kernel.org>; Sun, 14 Oct 2007 11:49:07 -0700 (PDT)
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: drivers/net/wireless/rt2x00/: struct data_desc strangeness
Date: Sun, 14 Oct 2007 21:06:20 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20071014175032.GI4211@stusta.de>
In-Reply-To: <20071014175032.GI4211@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710142106.20409.IvDoorn@gmail.com> (sfid-20071014_194913_773065_42FBD361)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 14 October 2007, Adrian Bunk wrote:
> drivers/net/wireless/rt2x00/rt2x00ring.h contains the following:
> 
> <--  snip  -->
> 
> ...
> /*
>  * data_desc
>  * Each data entry also contains a descriptor which is used by the
>  * device to determine what should be done with the packet and
>  * what the current status is.
>  * This structure is greatly simplified, but the descriptors
>  * are basically a list of little endian 32 bit values.
>  * Make the array by default 1 word big, this will allow us
>  * to use sizeof() correctly.
>  */
> struct data_desc {
>         __le32 word[1];
> };
> ...
> /*
>  * TX/RX Descriptor access functions.
>  */
> static inline void rt2x00_desc_read(struct data_desc *desc,
>                                     const u8 word, u32 *value)
> {
>         *value = le32_to_cpu(desc->word[word]);
> }
> 
> static inline void rt2x00_desc_write(struct data_desc *desc,
>                                      const u8 word, const u32 value)
> {
>         desc->word[word] = cpu_to_le32(value);
> }
> ...
> 
> <--  snip  -->
> 
> I haven't checked whether it might work in all cases, but passing 
> non-zero values as second parameter to rt2x00_desc_{read,write}()
> (as is done in many cases) is even in the best case bad coding style.

Access to the array is correct, even with non-zero values the code that is
reading/writing to the array knows the exact size of the descriptor. Within
rt2x00 are however 5 drivers who have different descriptor sizes. That means
I can't create a structure which has the correct array length.

The structure itself is just a simple map over preallocated memory
(skb->data in case of USB or dma in case of PCI).

So possible solutions would be:
 - remove struct data_desc and make it a void* or __le32*
   This is at the cost of code readibility since the above pointers
   have less meaning then a pointer to a structure which can be nicely
   documented.
 - increase the word[] array to something that fits all (+/- 20 entries)
   This wouldn't really be a problem, all it requires is fixing the sizeof() 
   statements. But then the code should contain a big note about that it
   is not allowed to read/write _all_ words in the entry since it depends on
   the driver that uses it.

What would in this case be the best solution for good coding style?

Ivo
