Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:53859 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933208Ab3GVTyO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 15:54:14 -0400
Received: by mail-ee0-f48.google.com with SMTP id b47so3979651eek.21
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jul 2013 12:54:13 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: linux-wireless@vger.kernel.org,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Seth Forshee <seth.forshee@canonical.com>
Subject: Re: FUSB200 xhci issue
Date: Mon, 22 Jul 2013 21:54:09 +0200
Message-ID: <1559414.LIxku4Z5O8@blech> (sfid-20130722_215418_017536_6FD06CA5)
In-Reply-To: <51ED4E12.8030006@rempel-privat.de>
References: <51ED4E12.8030006@rempel-privat.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

On Monday, July 22, 2013 05:21:54 PM Oleksij Rempel wrote:
> i'm one of ath9k_htc devs. Currently i'm working on usb_suspend issue of 
> this adapters. Looks like ar9271 and ar7010 have FUSB200, and i 
> accidentally discovered that 9170 have it too. Are there any issue with 
> usb-suspend + xhci controllers by you? Did you some how specially 
> handled it?

No, I haven't heard any complains about xhci + suspend. In fact, 
it's working fine with the NEC xhci I have. I also have a AR9271
and AR7010, so if you want I could try if they survive a suspend
+resume cycle when attached.

But, I do have a bug-report from someone else who has/had? problems
with carl9170 and xhci. If you want, you can get the details from:
"carl9170 A-MPDU transmit problem":
<http://comments.gmane.org/gmane.linux.kernel.wireless.general/104597>

The likely cause is related to Intel's xhci silicon (Ivy Bridge is
affected, but I don't know about Haswell):
<http://permalink.gmane.org/gmane.linux.kernel.wireless.general/104602>

However, I haven't heard back from Sarah or Seth about this matter
(Added them to the CC. so "PLEASE" join if either of you think to
have something to add about carl9170 transmit problem or ath9k_htc's
suspend issue... of course, if it was fixed, then it would be really
great to know which commit "fixed it"...)

Regards

Christian
