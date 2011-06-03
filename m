Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qult.net ([82.238.217.46]:54214 "EHLO qult.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324Ab1FCUtm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 16:49:42 -0400
Received: from zenon.in.qult.net ([192.168.128.3])
	by qult.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.74)
	(envelope-from <i@lri.fr>)
	id 1QSbJM-0001dp-P2
	for linux-wireless@vger.kernel.org; Fri, 03 Jun 2011 22:49:40 +0200
Received: from ig by zenon.in.qult.net with local (Exim 4.74)
	(envelope-from <i@lri.fr>)
	id 1QSbJL-0003Ot-KJ
	for linux-wireless@vger.kernel.org; Fri, 03 Jun 2011 22:49:39 +0200
Date: Fri, 3 Jun 2011 22:49:39 +0200
From: Ignacy Gawedzki <i@lri.fr>
To: linux-wireless@vger.kernel.org
Subject: Re: sta_find_ibss (active_ibss=1) in a loop?
Message-ID: <20110603204939.GA12854@zenon.in.qult.net> (sfid-20110603_224946_722302_0BD6B2EC)
References: <20110603201644.GA7836@zenon.in.qult.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110603201644.GA7836@zenon.in.qult.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 03, 2011 at 10:16:44PM +0200, thus spake Ignacy Gawedzki:
> I can't confirm right now that this is indeed what's happening, but I'll post
> more information as soon as possible.

I can now confirm that the state is MLME_SEARCH and that the ignored station
can't be added because of the following in ieee80211_ibss_add_sta():

          if (ifibss->state == IEEE80211_IBSS_MLME_SEARCH)
                return NULL;

-- 
I have not lost my mind, it's backed up on disk somewhere.
