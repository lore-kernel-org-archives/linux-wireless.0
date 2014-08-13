Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41921 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbaHMS3L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Aug 2014 14:29:11 -0400
Message-ID: <1407954545.21220.40.camel@jlt4.sipsolutions.net> (sfid-20140813_202914_228202_95C4CC21)
Subject: Re: About the TSFT field
From: Johannes Berg <johannes@sipsolutions.net>
To: Roberto Riggio <roberto.riggio@create-net.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 13 Aug 2014 20:29:05 +0200
In-Reply-To: <53EBA16F.9070305@create-net.org>
References: <53EB355E.6090508@create-net.org>
		 (sfid-20140813_120259_727542_9924FF23) <1407924311.21220.28.camel@jlt4.sipsolutions.net>
	 <53EBA16F.9070305@create-net.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-08-13 at 19:33 +0200, Roberto Riggio wrote:

> > It's purely local time - no synchronisation happens.
> 
> Meaning that is the system time. right?

No, it's wifi time. TSF in TUs. Whatever that means. It may or may not
even have a fixed reference, and it's not even guaranteed to sync with
the network.

> What if I create an adhoc
> interface together with the AP? According to the standard devices
> in IBSS shall synch with each other using the tsf info in the beacon
> frames. Is this behavior implemented by mac80211?

That behaviour is implemented, but it's not guaranteed that the TSF will
be used for the radiotap timestamp field. In fact radiotap isn't really
specified to be used while operating, so it seems to me that any
free-running clock with the right frequency (TUs) would be acceptable.

In that sense, the only real use for the timestamp field (barring
external information, like knowing what your driver does) would be for
relative time inside a single capture file.

johannes

