Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:51488 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbZGaTIS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 15:08:18 -0400
Received: by bwz19 with SMTP id 19so1364630bwz.37
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 12:08:17 -0700 (PDT)
Subject: Re: [PATCH 000/002] Fix frequent reconnects caused by new
 conection monitor
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1249066338.30019.214.camel@rc-desk>
References: <1249056817.20593.1.camel@maxim-laptop>
	 <1249066338.30019.214.camel@rc-desk>
Content-Type: text/plain
Date: Fri, 31 Jul 2009 22:08:13 +0300
Message-Id: <1249067293.19089.10.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-07-31 at 11:52 -0700, reinette chatre wrote:
> On Fri, 2009-07-31 at 09:13 -0700, Maxim Levitsky wrote:
> > Hi, here is the updated version of these two patches that fix the
> > $SUBJECT issue.
> > 
> > I attach these (in case mailer mangles them), and reply with patches.
> > 
> > Tested both with low quality signal, and beacon loss.
> > Lack of TX is found, every 30 seconds now, and quite reliable.
> > Lack of beacons, triggers probe like it did every 2 seconds.
> 
> Thanks!
> 
> I've been running with this for two hours now with no disconnects. This
> is where before the patches I would get disconnected after a few
> minutes. I did get two "No probe response from AP xx:xx:xx:xx:xx:xx
> after 500ms, try 1" messages in my log.
This is normal, or at least can be normal, I patched the driver to
display this message, when there is a probe timeout, but instead of
disconnect, it retries, currently 5 times, but this can be even further
increased is necessarily.
(these messages are only in logs when verbose mac debugging is enabled)

I don't know exactly why probes aren't answered, but I strongly suspect
that my AP sometimes 'goes out to lunch' and then answers, since
typically after a failed probe it sends many replies.
(Or it could be some buffering done by iwl3945 microcode). I currently
can't monitor the connection from outside, but as soon as I can I see
whether the above is true. Nevertheless if signal quality isn't great,
there are valid reasons for probe loss, and it shouldn't cause all the
fuzz (and since I use WPA2, every reconnection causes whole WPA
handshake to be preformed, and this takes at least 2 seconds, and if a
reconnection happens each 5 seconds, it gets very very annoying, and
almost unusable.

And polling every 2 seconds, this way or another, I think is too much
anyway.


Best regards,
	Maxim Levitsky

> 
> Reinette
> 
> 

