Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:34021 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755003AbYEVRzE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 13:55:04 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1JzF0J-0006Pv-1V
	for linux-wireless@vger.kernel.org; Thu, 22 May 2008 17:55:03 +0000
Received: from host34.fmed.uc.pt ([193.137.208.34])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2008 17:55:03 +0000
Received: from tolas_feup by host34.fmed.uc.pt with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2008 17:55:03 +0000
To: linux-wireless@vger.kernel.org
From: JMF <tolas_feup@hotmail.com>
Subject: Re: [PATCH] mac80211: do not alter injected seq numbers
Date: Thu, 22 May 2008 17:48:02 +0000 (UTC)
Message-ID: <loom.20080522T171937-155@post.gmane.org> (sfid-20080522_195508_338612_4E461A73)
References: <47FAB829.9010304@latinsud.com> <200804081025.39645.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch <mb@...> writes:
 (...)
> > +	if (unlikely(tx->flags & IEEE80211_TXRXD_TX_INJECTED))
> > +		return TXRX_CONTINUE;
 (...)
> This does not work, since we use injection for other types of
>  frames. For example management frames from hostapd. We don't want
>  (and can't) make hostapd keep track of sequence numbers.
> You'll have to contact radiotap people and add a flag for this.
>  This would also solve the hardware counter problem then.

The last time I saw tx.c, this should now be something like
     info->flags & IEEE80211_TX_CTL_INJECTED
But as far as I can see the usage is the same.
And, unless I'm wrong, IEEE80211_TX_CTL_INJECTED is only used
 with Monitor mode interfaces.
Does hostapd use monitor mode interfaces? Because if it doesn't,
 and if I saw things correcly, info->flags won't be set to
 IEEE80211_TX_CTL_INJECTED, right?

Any comments on this?

