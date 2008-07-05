Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:30623 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754611AbYGESk0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jul 2008 14:40:26 -0400
Message-ID: <486FBE75.5040100@sbcglobal.net> (sfid-20080705_204044_760390_A7DE00CC)
Date: Sat, 05 Jul 2008 11:33:25 -0700
From: Bryan Batten <BryanBatten@sbcglobal.net>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: linville@tuxdriver.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] [PATCH] rt2x00: Fix NULL pointer error in	adhoc/master
 mode
References: <200807051511.57995.IvDoorn@gmail.com>
In-Reply-To: <200807051511.57995.IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo van Doorn wrote:
...
> Note that the "raise beacondone interrupts without a beacon" is
> also a bug, and will be addressed later.
...

FWIW, I've never been able to figure out a way to shut it off in the 
legacy drivers. Unless there's some mechanism I've missed, I would 
consider this a bug, but its a hardware bug because - in the rt2500 
driver at least - even disabling it in the interrupt mask register has 
no effect.

I think it would be more accurately termed a target beacon 
transmission time interrupt. The rt61 driver's ISR simply does not 
test for the condition. The rt2400 and rt2500 drivers do nothing if 
not in adhoc mode. If in adhoc mode, they both assume a beacon frame 
is ready to go and send it. This relies on a canned frame that is set 
up during initialization.

Hope this is helpful,
-- 
Bryan
-
"Beyond the point of no return, there's no going back."

Narration to "Mars Rising" on the Science Channel
