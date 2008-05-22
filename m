Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:59349 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915AbYEVTJr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 15:09:47 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1JzGAW-0001eV-LE
	for linux-wireless@vger.kernel.org; Thu, 22 May 2008 19:09:41 +0000
Received: from host34.fmed.uc.pt ([193.137.208.34])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2008 19:09:40 +0000
Received: from tolas_feup by host34.fmed.uc.pt with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2008 19:09:40 +0000
To: linux-wireless@vger.kernel.org
From: JMF <tolas_feup@hotmail.com>
Subject: Re: [PATCH] mac80211: do not alter injected seq numbers
Date: Thu, 22 May 2008 19:09:31 +0000 (UTC)
Message-ID: <loom.20080522T185920-107@post.gmane.org> (sfid-20080522_211000_297449_6D1BE157)
References: <47FAB829.9010304@latinsud.com>  <200804081025.39645.mb@bu3sch.de> <loom.20080522T171937-155@post.gmane.org>  <69e28c910805221115g6290e5e9nef4444efca07aea@mail.gmail.com>  <69e28c910805221121v1a34901co35ec41bff41bd1ec@mail.gmail.com>  (sfid-20080522_202122_300727_51A7210B) <1211481278.3698.58.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@...> writes:

> 
> > >> This does not work, since we use injection for other types of
> > >>  frames. For example management frames from hostapd. We don't want
> > >>  (and can't) make hostapd keep track of sequence numbers.
> > >> You'll have to contact radiotap people and add a flag for this.
> > >>  This would also solve the hardware counter problem then.
> 
> > The flag is IEEE80211_TX_INJECTED. Here is a new patch, for the
> > current wireless-testing:


Are you really sure the flag is IEEE80211_TX_INJECTED?
For the current (today, 22 May) wireless-testing, it seems it's been
 renamed to IEEE80211_TX_CTL_INJECTED. Also, not tx->flags anymore, but
 info->flags instead.
Can you confirm that?


I was going to say something else, but I saw another post by Johannes... Strange
that hostapd uses injection in monitor mode interfaces, I thought it would be
only  AP mode interfaces.
And it is also strange that iwlwifi developers wanted to disallow injection in
monitor mode, with hostapd apparently needing it!

