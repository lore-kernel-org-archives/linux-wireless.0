Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40189 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758749Ab0EUWzM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 May 2010 18:55:12 -0400
Received: by fxm5 with SMTP id 5so1281576fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 May 2010 15:55:08 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: dhlii@dlasys.net
Subject: Re: carl9170 1.0.6 carl9170_tx_superdesc
Date: Sat, 22 May 2010 00:55:02 +0200
Cc: linux-wireless@vger.kernel.org
References: <4BDC001F.9050202@dlasys.net> <201005021452.01101.chunkeey@googlemail.com> <4BF6FC91.9060109@dlasys.net>
In-Reply-To: <4BF6FC91.9060109@dlasys.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201005220055.02528.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 21 May 2010 23:35:13 David H. Lynch Jr. wrote:
> I need to track a new value for each tx frame only in the firmware.
> It appears I should be adding it to carl9170_tx_superdesc.
> But that structure seems to be used on both the Linux and firmware side,
> and I have not been able to successfully add to it without breaking
> something elsewhere either in the firmware or Linux driver or between them.
there are two superdesc structures:
	carl9170_tx_superdesc and _carl9170_tx_superdesc.

This is due to the bit-field packing bug which is present
in all GCC version prior to 4.4.

Now, for the firmware we have a special toolchain and
a BUILD_BUG check, so no problem is there.

But kernel driver & userspace tools might be compiled by
an older version.

Therefore, if you want to introduce new fields, you have
to update both structures accordingly.

(And of course, always check that you're using your
 custom firmware and driver.)

> 	Alternately I can create a private array to hold my data, but then I 
> need to be able to find items in it using a carl9170_tx_superframe 
> pointer. I am gathering that the cookie and queue number constitute a 
> unique identifier, but that seems like alot of work to avoid adding a 
> u16 to carl9170_tx_superdesc.
It might not be visible at first glance, but carl9170_tx_superframe
has two distinct header descriptors.
 * ar9170_tx_hwdesc
 * carl9170_tx_superdesc

variables of those headers can not be mixed. This is because the
layout of ar9170_tx_hwdesc is dictated by the hardware design.

Therefore the queue number goes into ar9170_tx_hwdesc.mac.QoS,
whereas the "cookie" is intended to be used by the firmware code.
(In fact, carl9170_tx_superdesc is _hidden_ from the hardware POV) 
 
> 	Any other ideas about tracking a u16 value for each tx frame only on 
> the firmware side without substantial complexity ?
Erm, adding a single u16 is a bad idea. I'm pretty sure that the documents
from your employer cover this subject in great detail since this is a
well-known limitation.

What you could try - on the other hand - u32.
even if you don't need the extra 2 bytes that come with this
bigger storage class.


BTW:
Yes, the (CARL9170_TX_STATUS_NUM % 2) check can be safely disabled now.
But let me run some experiments. Just to be on the safe side.

Regards,
	Chr
