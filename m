Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51937 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964783AbbGQJQE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 05:16:04 -0400
Message-ID: <1437124562.1933.7.camel@sipsolutions.net> (sfid-20150717_111615_762999_D6BF66BF)
Subject: Re: [PATCH V3] mac80211: wowlan: suspend: Fix power save state
 stuck in ACTIVE caused by race between suspend and Tx packet.
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 17 Jul 2015 11:16:02 +0200
In-Reply-To: <CABPxzYKmsGyhmM_5e11N2sgw8c-ARyJJ_rPkfjwCcZ6+hfqHgg@mail.gmail.com> (sfid-20150617_141526_443639_F66B0051)
References: <1433943751-11221-1-git-send-email-chaitanya.mgit@gmail.com>
	 <1434530870.1884.12.camel@sipsolutions.net>
	 <CABPxzYL0rnht72K1fLcpyjC=eOM4nHxzHQRpD47iE6J=J-3sOg@mail.gmail.com>
	 <1434538909.1884.39.camel@sipsolutions.net>
	 <CABPxzY+Nz+wOCtot-4ROZJ6SR-a1gV625ak8qmLHtjvR=JadGQ@mail.gmail.com>
	 <1434541047.1884.41.camel@sipsolutions.net>
	 <CABPxzYKmsGyhmM_5e11N2sgw8c-ARyJJ_rPkfjwCcZ6+hfqHgg@mail.gmail.com>
	 (sfid-20150617_141526_443639_F66B0051)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I've applied this patch.

> > I really hate this whole powersave code btw - we really should 
> > refactor
> > that into its own little library module or so...
> Yes, that sounds good.

want to work on that? :)

The whole thing is awfully broken anyway since it does hw-level
configuration based on vif-level state, and ath9k does in fact support
multiple vifs ...

johannes
