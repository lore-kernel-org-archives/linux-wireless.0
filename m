Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:61262 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbYCXQVn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2008 12:21:43 -0400
Received: by nf-out-0910.google.com with SMTP id g13so847315nfb.21
        for <linux-wireless@vger.kernel.org>; Mon, 24 Mar 2008 09:21:42 -0700 (PDT)
To: rt2400-devel@lists.sourceforge.net
Subject: Re: rt2x00: LED classes
Date: Mon, 24 Mar 2008 17:20:49 +0100
Cc: linux-wireless@vger.kernel.org
References: <200803212146.34141.IvDoorn@gmail.com>
In-Reply-To: <200803212146.34141.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803241720.49887.IvDoorn@gmail.com> (sfid-20080324_162148_385349_35DF72E1)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> I must admit that I don't know if LED triggers work
> in non-sleepable context by design or if it depends
> on the calling trigger....

On inspection of led_trigger_event() it seems to grab
a read_lock before calling the driver.
This means that USB drivers cannot use LED triggers.

I will see if I can simulate the behavior differently
where LED classes are still used but rt2x00 implements
its own version of LED triggers. Most likely this will result
in rt2x00 not be using the triggers provided by mac80211
for any of the drivers.

For the time being LED support for rt2500usb and rt73usb
will be disabled with CONFIG_BROKEN. A better solution will
hopefully be ready for 2.6.27.

Ivo
