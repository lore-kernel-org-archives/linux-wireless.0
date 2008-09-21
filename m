Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:29949 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbYIUEW6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Sep 2008 00:22:58 -0400
Received: by ey-out-2122.google.com with SMTP id 6so296265eyi.37
        for <linux-wireless@vger.kernel.org>; Sat, 20 Sep 2008 21:22:56 -0700 (PDT)
Message-ID: <f488382f0809202122v4c77bc96r54edd24bdf365724@mail.gmail.com> (sfid-20080921_062302_839245_61811586)
Date: Sat, 20 Sep 2008 21:22:56 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Howard Chu" <hyc@symas.com>
Subject: Re: ath9k problems
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <48D5CAD0.1080909@symas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <48D5CAD0.1080909@symas.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 20, 2008 at 9:17 PM, Howard Chu <hyc@symas.com> wrote:
> With the 2.6.27-rc6 kernel I find that my wireless connection dies after a
> few minutes. Using nm-applet I have to disable wireless and re-enable it
> before I can re-establish a session (using WPA).

Yeah, you need this patch:
http://marc.info/?l=linux-wireless&m=122163541519736&w=2

> I tried pulling the wireless-testing branch and found it behaved strangely
> as well - within about 30 seconds of idle time it would die. But, it would
> usually immediately begin to reconnect (and succeed). My logs were full of
> "ForceXPAon: 0" messages which I found were from ath9_hw_reset(), which were
> all being called from set_channel, during the scan that took place when the
> card was not associated with the AP. It typically occurred every 30-35
> seconds.

I'm sure the ath9k guys can be more informative about what
'ForceXPAon: 0' is all about, but wireless-testing is pretty outdated
now. Strange, too, because it seems that even Linus' tree has newer
code than wireless-testing.

> I also found that if I kept a ping session to my wifi router running, then
> the wireless connection would not die, it would operate normally.
>
> It seems that it all worked fine in 2.6.27-rc4...

Yeah, did a git-bisect on the issue. Again, see the above link to get
the patch for it. :)

- Steven
