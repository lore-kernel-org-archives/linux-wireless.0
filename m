Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59497 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab1BNKFd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 05:05:33 -0500
Subject: Re: implicit band switch or not
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <op.vqmzowhl3ri7v4@arend-laptop>
References: <op.vqmzowhl3ri7v4@arend-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 11:05:31 +0100
Message-ID: <1297677931.3785.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-02-09 at 13:59 +0100, Arend van Spriel wrote:
> Hi Johannes,
> 
> With our mac80211-based driver I was associated with 5GHz AP and ran into  
> an assert. Investigating this I found that a software scan was initiated  
> and our driver got a probe request from mac80211 to be transmitted.  
> However, it turned out that the transmit rate was a 2GHz rate and our  
> driver was still configured to 5GHz band. The ieee80211_tx_info also  
> contained the band and indeed that was for 2GHz. Given the comment for the  
> band attribute I am wondering whether we should a band switch implicitly  
> or not:
> 
>   * @band: the band to transmit on (use for checking for races)
> 
> Any suggestions? Are we have a race condition here?

Yes, there are race conditions here -- do you implement flush? If yes,
it might be interesting to hook up the tx function to tracing (in
mac80211) and analyse the race in more detail via tracing.

johannes

