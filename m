Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.184]:2977 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016AbYCUUrR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2008 16:47:17 -0400
Received: by fk-out-0910.google.com with SMTP id 19so2082923fkr.5
        for <linux-wireless@vger.kernel.org>; Fri, 21 Mar 2008 13:47:14 -0700 (PDT)
To: rt2400-devel@lists.sourceforge.net
Subject: rt2x00: LED classes
Date: Fri, 21 Mar 2008 21:46:33 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803212146.34141.IvDoorn@gmail.com> (sfid-20080321_204723_063288_624D3CD4)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Some time ago I introduced LED classes to rt2x00.
For the USB drivers this has prooven to be tricky
since LED triggers are called in non-sleepable context
and USB drivers do need some sleep for register access.

As a workaround I introduced the in_atomic() check
which prints an error and skips the call. I am now
reading a discussion about in_atomic() on the netdev
mailinglist, and drivers are urged to remove the
usage as much as possible.

I must admit that I don't know if LED triggers work
in non-sleepable context by design or if it depends
on the calling trigger....

For rt2x00 there are now 2 options, either find the
trigger that is calling rt2x00 in non-sleepable context
and fix it or drop the LED class feature for USB drivers.

Has anybody recently tested the LED class option with
rt2500usb or rt73usb? And if so, do the following lines
appear in the log:
	Ignoring LED brightness command for led
If so, please post all those error messages so the problem
can be tracked down.

Otherwise I will start with either disabling LED handling
completely or create a large workaround which still uses
LED classes but works without LED triggers.
Depending on the amount of code, the LED triggers for PCI
drivers will also be sacrificed to keep the code as simple
as possible.

Ivo
