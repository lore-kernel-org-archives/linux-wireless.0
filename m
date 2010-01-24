Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:17080 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab0AXSYb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jan 2010 13:24:31 -0500
Received: by fg-out-1718.google.com with SMTP id l26so747925fgb.1
        for <linux-wireless@vger.kernel.org>; Sun, 24 Jan 2010 10:24:29 -0800 (PST)
Subject: Re: mac80211: Breakage in software encryption (iwl3945)
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1264330613.23766.17.camel@johannes.local>
References: <1264277460.13250.10.camel@maxim-laptop>
	 <1264330613.23766.17.camel@johannes.local>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 24 Jan 2010 20:24:25 +0200
Message-ID: <1264357465.4152.4.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-01-24 at 11:56 +0100, Johannes Berg wrote: 
> Maxim,
> 
> Your mail is confusing me.
> 
> On Sat, 2010-01-23 at 22:10 +0200, Maxim Levitsky wrote:
> > I updated the kernel and lost connection to my WPA2
> > AP. Strangely the WPA handshake completes, but DHCP not.
> 
> What did you upgrade to?
latest -git of wireless-testing

> 
> > I also unfortunately found that all that time I was using software
> > encryption (this is iwl3945 loaded with swcrypto=1).
> > Hardware encryption doesn't work ether and didn't work in the slightly
> > older kernel (but it did work once, I sure)
> 
> That must be a different problem, surely?
Sure, and I open a bugreport about it too.

> 
> > Now, the commit a6bae9e7ab19876a157c91019852395539e4f20e breaks software
> > encryption, with behaviour like described above.
> 
> And how did you arrive at that conclusion? Have you reverted the patch
> and it works again? I really don't see how this particular patch could
> break it since afaict it's entirely correct, there are exactly two tests
> for IEEE80211_TX_INTFL_DONT_ENCRYPT in mac80211, both of which execute
> before the code I removed.

I didn't want to add the standard meme: 'Commit X just before Y works,
commit Y doesn't. I reverted Y and now everything works fine.'

I bisected it, manually this time. Sorry for confusion.

I will continue that discussion in the thread about this patch.
(Also sorry for not including commit description....)


Best regards,
Maxim Levitsky

