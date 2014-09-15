Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32622 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbaIOJRY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 05:17:24 -0400
Date: Mon, 15 Sep 2014 12:17:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: marius.kotsbak@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: re: net/usb: Add Samsung Kalmia driver for Samsung GT-B3730
Message-ID: <20140915091704.GA22730@mwanda> (sfid-20140915_111727_723160_2096E7D2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I started writing a Smatch check to look for:

	skb->len - foo

where foo might be more than skb->len.  I don't know this code well
enough to say what the rules are exactly.  I chose a fairly suspect
bit of code to use as an example to get some feedback.

Hello Marius B. Kotsbak,

The patch d40261236e8e: "net/usb: Add Samsung Kalmia driver for
Samsung GT-B3730" from Jun 12, 2011, leads to the following static
checker warning:

	drivers/net/usb/kalmia.c:281 kalmia_rx_fixup()
	warn: this assumes skb->len is at least 12 bytes

drivers/net/usb/kalmia.c
   245          /* incomplete header? */
   246          if (skb->len < KALMIA_HEADER_LENGTH)
                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
We verify that it is at least 6.

   247                  return 0;
   248  
   249          do {

This is a do while (skb->len) loop.  Shouldn't the check for invalid
skb->len be inside the loop?

   250                  struct sk_buff *skb2 = NULL;
   251                  u8 *header_start;
   252                  u16 usb_packet_length, ether_packet_length;
   253                  int is_last;
   254  
   255                  header_start = skb->data;
   256  
   257                  if (unlikely(header_start[0] != 0x57 || header_start[1] != 0x44)) {
   258                          if (!memcmp(header_start, EXPECTED_UNKNOWN_HEADER_1,
   259                                  sizeof(EXPECTED_UNKNOWN_HEADER_1)) || !memcmp(
   260                                  header_start, EXPECTED_UNKNOWN_HEADER_2,
   261                                  sizeof(EXPECTED_UNKNOWN_HEADER_2))) {
   262                                  netdev_dbg(dev->net,
   263                                          "Received expected unknown frame header: %6phC. Package length: %i\n",
   264                                          header_start,
   265                                          skb->len - KALMIA_HEADER_LENGTH);
   266                          }
   267                          else {
   268                                  netdev_err(dev->net,
   269                                          "Received unknown frame header: %6phC. Package length: %i\n",
   270                                          header_start,
   271                                          skb->len - KALMIA_HEADER_LENGTH);
   272                                  return 0;
   273                          }
   274                  }
   275                  else
   276                          netdev_dbg(dev->net,
   277                                  "Received header: %6phC. Package length: %i\n",
   278                                  header_start, skb->len - KALMIA_HEADER_LENGTH);
   279  
   280                  /* subtract start header and end header */
   281                  usb_packet_length = skb->len - (2 * KALMIA_HEADER_LENGTH);
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
We could end up with usb_packet_length is a negative number truncated
to a largish u16.  Positive obviously.

   282                  ether_packet_length = get_unaligned_le16(&header_start[2]);
   283                  skb_pull(skb, KALMIA_HEADER_LENGTH);
   284  
   285                  /* Some small packets misses end marker */
   286                  if (usb_packet_length < ether_packet_length) {

This condition is not true because usb_packet_length is largish.

   287                          ether_packet_length = usb_packet_length
   288                                  + KALMIA_HEADER_LENGTH;
   289                          is_last = true;
   290                  }
   291                  else {
   292                          netdev_dbg(dev->net, "Correct package length #%i", i
   293                                  + 1);
   294  

regards,
dan carpenter
