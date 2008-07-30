Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bromo.msbb.uc.edu ([129.137.3.146]:42688 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751263AbYG3N5y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 09:57:54 -0400
Date: Wed, 30 Jul 2008 09:57:52 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: AP association timeout bugzilla PR?
Message-ID: <20080730135752.GA11193@bromo.msbb.uc.edu> (sfid-20080730_155757_163088_59C63F5F)
References: <20080728172722.GA26893@bromo.msbb.uc.edu> <1217266609.15381.4.camel@johannes.berg> <20080730001012.GA2046@bromo.msbb.uc.edu> <1217402210.10489.81.camel@johannes.berg> <20080730132846.GA10959@bromo.msbb.uc.edu> <1217425934.10489.128.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1217425934.10489.128.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,
   One other question. Does the mac80211 based drivers like
ath5k and ath9k support any form of proc output? I am assuming
that the NetworkManager wireless menu item reports zero signal
due to the absence of a /proc/net/wireless under ath9k. Is that
a TODO as well or should file a bug report against the Fedora
NetworkManager concerning that. I am assuming it uses the proc
to get the signal level and that is why it reports zero. If
I use iwconfig there appears to be a signal level reported for
ath9k.
               Jack

On Wed, Jul 30, 2008 at 03:52:14PM +0200, Johannes Berg wrote:
> 
> I think that's the false positive due to the tx mq changes that people
> were talking about all the time. Please ignore.
> 
> > Is this a known issue or perhaps due to may skb->cb patch for ath9k?
> 
> Yeah it's a known issue, nothing with your patch, except for the PAE
> placement your patch is fine. And I don't understand that part of ath9k,
> it shouldn't need to look at that but rather ask the RC algorithm to do
> that job.
> 
> johannes


